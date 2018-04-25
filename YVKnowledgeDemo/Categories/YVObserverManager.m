//
//  YVObserverManager.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/4.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVObserverManager.h"

#import <objc/runtime.h>

@implementation YVObserverManager

+ (void)push:(UIViewController *)viewControl toNextControl:(NSString *)className withProperties:(NSDictionary *)properties
{
    if (viewControl.navigationController)
    {
        UIViewController *nextControl = [[NSClassFromString(className) alloc] init];
        if (properties.count != 0)
        {
            NSArray *propertyKeys = [properties allKeys];
            NSArray *propertyValues = [properties allValues];
            for (int i=0; i<propertyKeys.count; i++)
            {
                NSString *propertyKey = propertyKeys[i];
                NSString *propertyValue = propertyValues[i];
                //属性写入
                if ([self checkIsExistPropertyWithInstance:nextControl verifyPropertyName:propertyKey])
                {
                    [nextControl setValue:propertyValue forKey:propertyKey];
                }
            }
        }
        [viewControl.navigationController pushViewController:nextControl animated:YES];
    }
}

+ (void)present:(UIViewController *)viewControl toNextControl:(NSString *)className withProperties:(NSDictionary *)properties
{
    if (viewControl.navigationController)
    {
        UIViewController *nextControl = [[NSClassFromString(className) alloc] init];
        if (properties.count != 0)
        {
            NSArray *propertyKeys = [properties allKeys];
            NSArray *propertyValues = [properties allValues];
            for (int i=0; i<propertyKeys.count; i++)
            {
                NSString *propertyKey = propertyKeys[i];
                NSString *propertyValue = propertyValues[i];
                //属性写入
                if ([self checkIsExistPropertyWithInstance:nextControl verifyPropertyName:propertyKey])
                {
                    [nextControl setValue:propertyValue forKey:propertyKey];
                }
            }
        }
        [viewControl presentViewController:nextControl animated:YES completion:nil];
    }
}

+ (BOOL)checkIsExistPropertyWithInstance:(id _Nonnull)instance
                      verifyPropertyName:(NSString *_Nonnull)verifyPropertyName
{
    unsigned int outCount, i;
    //获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName])
        {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}

@end
