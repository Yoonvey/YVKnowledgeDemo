//
//  YVAFNNetServer.h
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/26.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AFNetworking;

@interface YVAFNNetServer : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSURL *fileUrl;

/*@
 * @brief get
 * @param URLString
 * @param parameters
 * @param success
 * @param failure
 */
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

/*!
 * @brief 发送post请求
 * @param URLString  请求的网址字符串
 * @param parameters 请求的参数
 * @param success    请求成功的回调
 * @param failure    请求失败的回调
 */
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/*!
 * @brieg 上传图片(二进制文件上传)
 * @param urlString   上传图片的网址字符串
 * @param parameters  上传图片的参数
 * @param uploadParams 上传图片的信息
 * @param success     上传成功的回调+
 * @param failure     上传失败的回调
 */
+ (void)uploadImagePost:(NSString *)urlString
             parameters:(id)parameters
           uploadParams:(NSArray *)uploadParams
               progress:(void (^)(CGFloat progressValue))progress
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/*!
 * @brieg 下载文件
 * @param fileUrl   上传图片的网址字符串
 * @param finished     上传的回调
 */
+ (void)downLoadFileWithFileUrl:(NSURL *)fileUrl
                        finised:(void (^)(NSString *fullPath))finished;

@end

#pragma mark - <WCSingletonManager>
@interface YVSingletonManager : AFHTTPSessionManager

+ (YVSingletonManager *)sharedManager;

@end
