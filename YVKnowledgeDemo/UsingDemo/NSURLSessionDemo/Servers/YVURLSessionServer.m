//
//  YVURLSessionServer.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVURLSessionServer.h"

#import <objc/runtime.h>

#pragma mark - <YVQueryStringPair>
@interface YVQueryStringPair : NSObject

@property (nonatomic, readwrite, strong) id field;
@property (nonatomic, readwrite, strong) id value;

- (instancetype)initWithField:(id)field value:(id)value;
- (NSString *)URLEncodedStringValue;

@end

@implementation YVQueryStringPair

- (instancetype)initWithField:(id)field value:(id)value
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    self.field = field;
    self.value = value;
    return self;
}

//自动转码
- (NSString *)URLEncodedStringValue
{
    if (!self.field || [self.value isEqual:[NSNull null]])
    {
        return PercentEscapedStringFromString([self.field description]);
    }
    else
    {
        return [NSString stringWithFormat:@"%@=%@", PercentEscapedStringFromString([self.field description]),PercentEscapedStringFromString([self.value description])];
    }
}

NSString *PercentEscapedStringFromString(NSString *string)
{
    //常用定界符
    static NSString *const kCharactersGeneralDelimitersToEncode = @":#[]@";
    //附加定界符
    static NSString *const kCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    //字符过滤
    NSMutableCharacterSet *allowedCharacerSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacerSet removeCharactersInString:[kCharactersGeneralDelimitersToEncode stringByAppendingString:kCharactersSubDelimitersToEncode]];
    
    static NSUInteger const batchSize = 50;
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index<string.length)
    {
#pragma GCC diagnostic push//GCC编译诊断
#pragma GCC diagnostic ignored "-Wgnu"//GCC编译诊断忽略 "-Wgnu"
        NSUInteger length = MIN(string.length-index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        //为了避免分割序列
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        NSString *subString = [string substringWithRange:range];
        NSString *encoded = [subString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacerSet];
        [escaped appendString:encoded];
        index += string.length;
    }
    return escaped;
}

@end

#pragma mark - <YVURLSessionServer>
@interface YVURLSessionServer () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;//下载的数据信息
@property (nonatomic, strong) NSURLSession *downloadSession;//下载的会话

@end

@implementation YVURLSessionServer

#pragma mark - <ResetSystemMethod>
//+ (BOOL)accessInstanceVariablesDirectly
//{
//    return NO;
//}

+ (instancetype)sharedSessionServer
{
    static dispatch_once_t onceToken;
    static YVURLSessionServer *sessionServer = nil;
    dispatch_once(&onceToken, ^
    {
        sessionServer = [[YVURLSessionServer alloc]init];
    });
    return sessionServer;
}

- (void)sendGetRequestWithUrlString:(NSString *)urlString parameter:(id)parameter callBack:(void (^)(id))callBack
{
    //清理任务
    RemoveTask(self, urlString, self.tasks);
    //创建一个资源描述符
    NSURL *url = [NSURL URLWithString:urlString];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置请求参数
    if (parameter)
    {
        NSString *queryString = QueryFromParameter(parameter);
        request.HTTPBody = [queryString dataUsingEncoding:NSUTF8StringEncoding];//添加body
    }
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建请求任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        //data：二进制数据：服务器返回的数据。（就是我们想要的内容）
        //response：服务器的响应
        //error：链接错误的信息
        NSString *jsonString =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        id responseObject = dictionaryWithJsonString(jsonString);
        //结束任务
        RemoveTask(self, urlString, self.tasks);
        if (callBack)
        {
            callBack(responseObject);
        }
    }];
    //执行任务
    [task resume];
    //添加任务描述
    task.taskDescription = urlString;
    //加入任务管理池
    AdditionTask(self, task, self.tasks);
}

- (void)sendPostRequestWithUrlString:(NSString *)urlString parameter:(id)parameter callBack:(void(^)(id responseObject))callBack
{
    //清理任务
    RemoveTask(self, urlString, self.tasks);
    //创建一个资源描述符
    NSURL *url = [NSURL URLWithString:urlString];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置请求参数
    if (parameter)
    {
        NSString *queryString = QueryFromParameter(parameter);
        request.HTTPBody = [queryString dataUsingEncoding:NSUTF8StringEncoding];//添加body
    }
    //获得会话
    NSURLSession *session = [NSURLSession sharedSession];
    //根据会话创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        //data：二进制数据：服务器返回的数据。（就是我们想要的内容）
        //response：服务器的响应
        //error：链接错误的信息
        NSString *jsonString =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        id responseObject = dictionaryWithJsonString(jsonString);
        //结束任务
        RemoveTask(self, urlString, self.tasks);
        if (callBack)
        {
            callBack(responseObject);
        }
    }];
    //开始任务
    [task resume];
    //添加任务描述
    task.taskDescription = urlString;
    //加入任务管理池
    AdditionTask(self, task, self.tasks);
}

- (void)sendDownloadRequestWithUrlString:(NSString *)urlString delegateEnable:(BOOL)delegateEnabled callBack:(void (^)(NSString *fullPath))callBack
{
    //清理任务
    RemoveTask(self, urlString, self.tasks);
    //创建一个资源描述符
    NSURL *url = [NSURL URLWithString:urlString];
    //获取会话
    NSURLSession *session = nil;
    //根据会话创建任务
    NSURLSessionDownloadTask *task = nil;
    if (delegateEnabled)
    {
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        task = [session downloadTaskWithURL:url];
    }
    else
    {
        session = [NSURLSession sharedSession];
        //根据会话创建任务
        task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            /*
            a.location是沙盒中tmp文件夹下的一个临时url,文件下载后会存到这个位置,由于tmp中的文件随时可能被删除,所以我们需要自己需要把下载的文件移动到其他地方:pathUrl.
            b.response.suggestedFilename是从相应中取出文件在服务器上存储路径的最后部分，例如根据本路径为，最后部分应该为：“image.png”
                     */
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
            NSURL *pathUrl = [NSURL fileURLWithPath:path];
            //剪切文件
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:pathUrl error:nil];
            //结束任务
            RemoveTask(self, urlString, self.tasks);
            if(callBack)
            {
                callBack(path);
            }
        }];
    }
    [task resume];
    //添加任务描述
    task.taskDescription = urlString;
    //加入任务管理池
    AdditionTask(self, task, self.tasks);
    
    self.downloadTask = task;
    self.downloadSession = session;
}

#pragma mark - <NSURLSessionDownloadTaskService>
//取消下载任务(可恢复续传)
- (void)cancelDownloadTask
{
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData)
     {
         RemoveTask(self, self.downloadTask.taskDescription, self.tasks);
         self.resumeData = resumeData;
     }];
}

//恢复下载任务
- (void)resumeDownloadTask
{
    //根据进度信息创建下载任务
    NSURLSessionDownloadTask *task = [self.downloadSession downloadTaskWithResumeData:self.resumeData];
    //开始任务
    [task resume];
    //
    self.downloadTask = task;
    AdditionTask(self, task, self.tasks);
}

#pragma mark - <NSURLSessionDownloadDelegate>
//下载数据的过程中会调用的代理方法
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat progress =1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    if (_delegate && [_delegate respondsToSelector:@selector(downloadSessionIsUnderway:)])
    {
        [_delegate downloadSessionIsUnderway:progress];
    }
}

//恢复下载
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    if (_delegate && [_delegate respondsToSelector:@selector(downloadSessionIsResume:)])
    {
        [_delegate downloadSessionIsResume:downloadTask];
    }
}

//下载完成,写入数据到本地的时候会调用的方法
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //保存
    NSString* fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                          stringByAppendingPathComponent:downloadTask.response.suggestedFilename];;
    [[NSFileManager defaultManager] moveItemAtURL:location
                                            toURL:[NSURL fileURLWithPath:fullPath]
                                            error:nil];
    //结束任务
    RemoveTask(self, downloadTask.debugDescription, self.tasks);
    //代理
    if (_delegate && [_delegate respondsToSelector:@selector(downloadSessionDidFinished:)])
    {
        [_delegate downloadSessionDidFinished:fullPath];
    }
}

//请求完成，错误调用的代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    //结束任务
    RemoveTask(self, task.debugDescription, self.tasks);
    if (_delegate && [_delegate respondsToSelector:@selector(downloadSessionAppearedError:)])
    {
        [_delegate downloadSessionAppearedError:error];
    }
}

#pragma mark - <DataControl>
void AdditionTask(id class, NSURLSessionTask *task, NSArray *oldTasks)
{
    //任务添加保存
    NSMutableArray *tTasks = [NSMutableArray arrayWithArray:oldTasks];
    [tTasks addObject:task];
    [class setValue:tTasks forKey:NSStringFromSelector(@selector(tasks))];
}

void RemoveTask(id class, NSString *taskDescription, NSArray *oldTasks)
{
    YVURLSessionServer *sessionServer = nil;
    if ([class isKindOfClass:[YVURLSessionServer class]])
    {
        sessionServer = (YVURLSessionServer *)class;
    }
    //任务移除
    NSMutableArray *tTasks = [NSMutableArray arrayWithArray:oldTasks];
    for (NSURLSessionTask *task in tTasks)
    {
        if ([task.taskDescription isEqualToString:taskDescription])
        {
            if ([task isKindOfClass:[NSURLSessionDownloadTask class]])
            {
                sessionServer.downloadTask = nil;
                sessionServer.downloadSession = nil;
            }
            [task cancel];
            [tTasks removeObject:task];
        }
    }
    [class setValue:tTasks forKey:NSStringFromSelector(@selector(tasks))];
}

#pragma mark - <ParameterConfiguration>
NSString *QueryFromParameter(NSDictionary *parameter)
{
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (YVQueryStringPair *queryStringPair in QueryStringPairsFromKeyAndValue(nil, parameter))
    {
        [mutablePairs addObject:[queryStringPair URLEncodedStringValue]];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray *QueryStringPairsFromKeyAndValue(NSString *key, id value)
{
    NSMutableArray *mutableQueryStringComponent = [NSMutableArray array];
    //parameter排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    //将参数取出拼接到数组
    if ([value isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = value;
        for (id nestedKey in [[dictionary allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]])
        {
            id nestedValue = dictionary[nestedKey];//取值
            if(nestedValue)
            {
                //key不存在时,调用自身获取参数中的属性
                [mutableQueryStringComponent addObjectsFromArray:QueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedValue] : nestedKey), nestedValue)];
            }
        }
    }
    else if([value isKindOfClass:[NSArray class]])
    {
        NSArray *array = value;
        for (id nestedValue in array)
        {
            if (nestedValue)
            {
                [mutableQueryStringComponent addObjectsFromArray:QueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
            }
        }
    }
    else if([value isKindOfClass:[NSSet class]])
    {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[sortDescriptor]])
        {
            [mutableQueryStringComponent addObjectsFromArray:QueryStringPairsFromKeyAndValue(key, obj)];
        }
    }
    else
    {
        [mutableQueryStringComponent addObject:[[YVQueryStringPair alloc]initWithField:key value:value] ];
    }
    return mutableQueryStringComponent;
}

#pragma mark - <TransformDataFormat>
/*!
 * @brief 把格式化的JSON格式的二进制数据转换成字符串
 * @param object JSON格式的二进制数据
 * @return 返回字符串
 */
NSString *DataToJsonString(id object)
{
    if (!object) return object;
    
    NSString *jsonString = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
NSDictionary *dictionaryWithJsonString(NSString *jsonString)
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error)
    {
        NSLog(@"jsonString>%@",jsonString);
        NSLog(@"dictionaryjson解析失败：%@",error);
        return nil;
    }
    return dic;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成数组
 * @param jsonString JSON格式的字符串
 * @return 返回数组
 */
NSArray *arrayWithJsonString(NSString *jsonString)
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&error];
    if(error)
    {
        NSLog(@"ArratjsonString>%@",jsonString);
        NSLog(@"Arrayjson解析失败：%@",error);
        return nil;
    }
    return array;
}

/*!
 * @breif 将数据模型还原成字典
 * @param obj 数据模型对象
 * @return 字典对象
 */
NSDictionary *getObjectData(id obj)
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i =0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = getObjectInternal(value);
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

id getObjectInternal(id obj)
{
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i =0;i < objarr.count; i++)
        {
            [arr setObject:getObjectInternal([objarr objectAtIndex:i]) atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:getObjectInternal([objdic objectForKey:key]) forKey:key];
        }
        return dic;
    }
    return getObjectData(obj);
}

@end
