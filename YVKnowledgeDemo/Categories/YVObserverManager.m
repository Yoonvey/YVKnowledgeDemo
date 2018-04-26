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

#pragma mark - <TransformDataFormat>
//把格式化的JSON格式的二进制数据转换成字符串
NSString *DataToJsonString(id object)
{
    if (!object) return object;
    
    NSString *jsonString = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//把格式化的JSON格式的字符串转换成字典
NSDictionary *dictionaryWithJsonString(NSString *jsonString)
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error)
    {
        NSLog(@"jsonString>%@",jsonString);
        NSLog(@"dictionaryjson解析失败：%@",error);
        return nil;
    }
    return dic;
}

//把格式化的JSON格式的字符串转换成数组
NSArray *arrayWithJsonString(NSString *jsonString)
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&error];
    if(error)
    {
        NSLog(@"ArratjsonString>%@",jsonString);
        NSLog(@"Arrayjson解析失败：%@",error);
        return nil;
    }
    return array;
}

//将数据模型还原成字典
NSDictionary *getObjectData(id obj)
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i =0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = getObjectInternal(value);
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

id getObjectInternal(id obj)
{
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i =0;i < objarr.count; i++)
        {
            [arr setObject:getObjectInternal([objarr objectAtIndex:i]) atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:getObjectInternal([objdic objectForKey:key]) forKey:key];
        }
        return dic;
    }
    return getObjectData(obj);
}

#pragma mark - <skip>
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
