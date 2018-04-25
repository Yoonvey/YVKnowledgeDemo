//
//  YVPersonModel.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVPersonModel.h"

#import <objc/runtime.h>

@implementation YVPersonModel

- (instancetype)initWithName:(NSString *)name gender:(NSString *)gender
{
    if (self = [super init])
    {
        _name = name;
        _gender = gender;
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    [aCoder encodeObject:_name forKey:@"name"];
//    [aCoder encodeObject:_gender forKey:@"gender"];
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([YVPersonModel class], &count);
    for (int i=0; i<count; i++)
    {
        const char *name = ivar_getName(ivarList[i]);
        NSString *strName = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:strName] forKey:strName];
    }
    free(ivarList);//释放
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
//        [aDecoder decodeObjectForKey:@"name"];
//        [aDecoder decodeObjectForKey:@"gender"];
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList([YVPersonModel class], &count);
        for (int i=0; i<count; i++)
        {
            const char *name = ivar_getName(ivarList[i]);
            NSString *strName = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivarList);//释放
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@, gender = %@", self.name, self.gender];
}

@end
