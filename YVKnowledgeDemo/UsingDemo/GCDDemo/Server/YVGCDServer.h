//
//  YVGCDServer.h
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/28.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YVGCDServer : NSObject

/**
 *  async -- 并发队列（最常用）
 *  会不会创建线程：会，一般同时开多条
 *  任务的执行方式：并发执行
 */
- (void)asyncGlobalQueue;

/**
 *  async -- 串行队列（有时候用）
 *  会不会创建线程：会，一般只开1条线程
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 */
- (void)asyncSerialQueue;

@end
