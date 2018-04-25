//
//  YVObserverManager.h
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/4.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YVObserverManager : NSObject

/*!
 * @brief push跳转
 * @param viewControl 跳转发起类
 * @param className 跳转目标类名称
 * @param properties 传递的属性(KVC模式,将要传递的属性的键值写入字典,该方法会查询目标类中是否含有相应的属性名,对应进行传值)
 */
+ (void)push:(UIViewController *)viewControl toNextControl:(NSString *)className withProperties:(NSDictionary *)properties;

/*!
 * @brief present跳转
 * @param viewControl 跳转发起类
 * @param className 跳转目标类名称
 * @param properties 传递的属性(KVC模式,将要传递的属性的键值写入字典,该方法会查询目标类中是否含有相应的属性名,对应进行传值)
 */
+ (void)present:(UIViewController *)viewControl toNextControl:(NSString *)className withProperties:(NSDictionary *)properties;

@end
