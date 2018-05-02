//
//  YVGCDServer.m
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/28.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVGCDServer.h"

@implementation YVGCDServer

- (void)asyncGlobalQueue
{
    //获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 将任务添加全局队列中去异步执行
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

- (void)asyncSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("YoonveyTest", NULL);
    // 将任务添加全局队列中去异步执行
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^ {
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}

@end
