//
//  YVDelegatesSource.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVDelegatesSource.h"
#import <objc/runtime.h>

@interface YVDelegatesSource ()

@property (nonatomic, strong) NSPointerArray *weakDelegates;

@end

@implementation YVDelegatesSource

#pragma mark - <Singleton>
+ (instancetype)sharedDelegateSource
{
    static dispatch_once_t onceToken;
    static YVDelegatesSource *delegateSource;
    dispatch_once(&onceToken, ^
    {
        delegateSource = [[YVDelegatesSource alloc]init];
    });
    return delegateSource;
}

#pragma mark - < LazyLoading-懒加载>
- (NSPointerArray *)weakDelegates
{
    if (!_weakDelegates)
    {
        _weakDelegates = [NSPointerArray weakObjectsPointerArray];
    }
    return _weakDelegates;
}

#pragma mark - <MoreDelegate-多代理>
//重写Set方法
- (void)setDelegate:(id<YVDelegatesSourceDelegate>)delegate
{
    if ([delegate respondsToSelector:@selector(delegateResponse:)])
    {
        [self.weakDelegates addPointer:(__bridge void *)delegate];
    }
}

//发送代理传递内容
- (void)sendCommunication:(id)communication
{
    for (id target in self.weakDelegates)
    {
        if ([target respondsToSelector:@selector(delegateResponse:)])
        {
            [target delegateResponse:communication];
        }
    }
}


@end
