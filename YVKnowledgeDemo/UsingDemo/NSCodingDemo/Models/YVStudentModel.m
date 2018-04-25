//
//  YVStudentModel.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVStudentModel.h"
#import <objc/runtime.h>

@implementation YVStudentModel

- (instancetype)initWithName:(NSString *)name gender:(NSString *)gender grade:(NSString *)grade
{
    if (self = [super initWithName:name gender:gender])
    {
        _grade = grade;
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    [aCoder encodeObject:_grade forKey:@"grade"];
    [super encodeWithCoder:aCoder];
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++)
    {
        const char *name = ivar_getName(ivarList[i]);
        NSString *strName = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:strName] forKey:strName];
    }
    free(ivarList);
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
//        _grade = [aDecoder decodeObjectForKey:@"grade"];
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList([self class], &count);
        for (int i=0; i<count; i++)
        {
            const char *name = ivar_getName(ivarList[i]);
            NSString *strName = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivarList);
    }
    return self;
}

- (NSString *)description
{
    NSString *string = [super description];
    return [string stringByAppendingString:[NSString stringWithFormat:@" grade = %@", self.grade]];
}


@end
