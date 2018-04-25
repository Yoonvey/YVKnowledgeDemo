//
//  YVURLSessionServer.h
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YVURLSessionDelegate <NSObject>

@optional
/*!
 * @brief 下载任务正在进行
 * @send progress 进行进度
 */
- (void)downloadSessionIsUnderway:(CGFloat)progress;

/*!
 * @brief 下载任务重启
 * @send task 任务信息
 */
- (void)downloadSessionIsResume:(NSURLSessionTask *)task;

/*!
 * @brief 下载任务完成
 * @send fullPath 文件缓存路径
 */
- (void)downloadSessionDidFinished:(NSString *)fullPath;

/*!
 * @brief 下载任务错误
 * @send error 错误信息
 */
- (void)downloadSessionAppearedError:(NSError *)error;

@end

#pragma mark - <YVURLSessionServer>
@interface YVURLSessionServer : NSObject <YVURLSessionDelegate>

@property (nonatomic, weak) id<YVURLSessionDelegate> delegate;
@property (nonatomic, readonly, strong) NSArray *tasks;//任务池

+ (instancetype)sharedSessionServer;

/*!
 * @brief 发起GET请求
 * @param urlString url字符
 * @param parameter 参数内容
 * @block callBack 执行回调(返回服务器返回内容)
 */
- (void)sendGetRequestWithUrlString:(NSString *)urlString
                          parameter:(id)parameter
                           callBack:(void(^)(id responseObject))callBack;

/*!
 * @brief 发起POST请求
 * @param urlString url字符
 * @param parameter 参数内容
 * @block callBack 执行回调(返回服务器返回内容)
 */
- (void)sendPostRequestWithUrlString:(NSString *)urlString
                           parameter:(id)parameter
                            callBack:(void(^)(id responseObject))callBack;

/*!
 * @brief 文件下载请求
 * @param urlString url字符
 * @param delegateEnabled 是否启动代理(启用代理,block将不执行回调)
 * @block callBack 执行回调
 */
- (void)sendDownloadRequestWithUrlString:(NSString *)urlString
                          delegateEnable:(BOOL)delegateEnabled
                                callBack:(void(^)(NSString *fullPath))callBack;

/*!
 * @brif 文件上传请求
 *
 *
 */
//- (void)sendUploadRequestWithUrlString:(NSString *)urlString;

//取消下载任务(可恢复续传)
- (void)cancelDownloadTask;

//恢复下载任务
- (void)resumeDownloadTask;

@end
