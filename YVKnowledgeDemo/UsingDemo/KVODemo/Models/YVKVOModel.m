//
//  YVKVOModel.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/4.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVKVOModel.h"

@implementation YVKVOModel

@synthesize num;

+ (instancetype)sharedKVOModel
{
    static dispatch_once_t onceToken;
    static YVKVOModel *kvoModel = nil;
    dispatch_once(&onceToken, ^
    {
        kvoModel = [[YVKVOModel alloc]init];
    });
    return kvoModel;
}

//- (void)setInformation:(NSMutableDictionary *)information
//{
//    NSLog(@"information>%@", information);
//}

@end
