//
//  YVDelegatesSource.h
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YVDelegatesSourceDelegate <NSObject>

@optional
/*!
 * @brief 回调代理传递的通讯内容
 * @param communication 通讯内容
 */
- (void)delegateResponse:(id)communication;

@end


@interface YVDelegatesSource : NSObject

+ (instancetype)sharedDelegateSource;

@property (nonatomic, weak) id<YVDelegatesSourceDelegate> delegate;

/*!
 * @brief 发送代理需要传递的通讯内容
 * @param communication 通讯内容
 */
- (void)sendCommunication:(id)communication;

@end
