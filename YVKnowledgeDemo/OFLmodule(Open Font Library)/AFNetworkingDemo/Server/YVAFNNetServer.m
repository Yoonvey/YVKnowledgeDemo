//
//  YVAFNNetServer.m
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/26.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVAFNNetServer.h"

@implementation YVAFNNetServer

#pragma mark Get请求
+ (void)getWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //初始化请求对象
    YVSingletonManager *manager = [YVSingletonManager sharedManager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //设置请求超时
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress)
     {
         //progress
     }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (failure)
         {
             failure(error);
         }
     }];
}

#pragma mark Post
+ (void)postWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    //初始化请求对象
    YVSingletonManager *manager = [YVSingletonManager sharedManager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置请求超时
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress)
     {
         NSLog(@"下载进度>%f",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
     }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
             NSData *resData = responseObject;
             NSString *resString =  [[NSString alloc]initWithData:resData encoding:NSUTF8StringEncoding];
             NSLog(@"%@.resString>%@", URLString, resString);
             id response = dictionaryWithJsonString(resString);
             success(task, response);
         }
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (failure)
         {
             failure(task, error);
         }
     }];
}

#pragma mark 上传图片(二进制文件上传)
+ (void)uploadImagePost:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           uploadParams:(NSArray *)uploadParams
               progress:(void (^)(CGFloat progressValue))progress
                success:(void (^)(NSURLSessionDataTask *, id))success
                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    YVSingletonManager *manager = [YVSingletonManager sharedManager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         for (YVAFNNetServer *uploadParam in uploadParams)
         {
             [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
         }
     } progress:^(NSProgress * _Nonnull uploadProgress)
     {
         NSLog(@"上传进度>%f",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
         CGFloat progressValue = 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
         if (progress)
         {
             progress(progressValue);
         }
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
             NSLog(@"responseObject>%@",responseObject);
             NSData *doubi = responseObject;
             NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
             id response = dictionaryWithJsonString(shabi);
             if (response != nil)
             {
                 success(task,response);
             }
             else
             {
                 success(task,shabi);
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (failure)
         {
             failure(task,error);
         }
     }];
}

#pragma mark 下载文件
+ (void)downLoadFileWithFileUrl:(NSURL *)fileUrl finised:(void (^)(NSString *fullPath))finished
{
    //1.创建会话管理者
    YVSingletonManager *manager = [YVSingletonManager sharedManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    //2.下载文件
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress)
    {
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response)
    {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:response.suggestedFilename];
        if (finished)
        {
            finished(fullPath);
        }
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error)
    {
        NSLog(@"filePath>%@",filePath);
    }];
    //3.执行Task
    [download resume];
}

@end

#pragma mark - <YVSingletonManager>
@implementation YVSingletonManager

+ (YVSingletonManager *)sharedManager
{
    static YVSingletonManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        manager = [[YVSingletonManager alloc]init];
    });
    return manager;
}

@end
