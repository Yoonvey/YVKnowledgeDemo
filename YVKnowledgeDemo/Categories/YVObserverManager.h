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
 * @brief 把格式化的JSON格式的二进制数据转换成字符串
 * @param object JSON格式的二进制数据
 * @return 返回字符串
 */
NSString *DataToJsonString(id object);

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
NSDictionary *dictionaryWithJsonString(NSString *jsonString);

/*!
 * @brief 把格式化的JSON格式的字符串转换成数组
 * @param jsonString JSON格式的字符串
 * @return 返回数组
 */
NSArray *arrayWithJsonString(NSString *jsonString);

/*!
 * @breif 将数据模型还原成字典
 * @param obj 数据模型对象
 * @return 字典对象
 */
NSDictionary *getObjectData(id obj);

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
