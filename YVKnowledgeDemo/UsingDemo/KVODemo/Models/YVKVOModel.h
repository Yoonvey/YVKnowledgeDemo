//
//  YVKVOModel.h
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/4.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YVKVOModel : NSObject

@property (nonatomic, assign) int num;
@property (nonatomic, strong) NSMutableDictionary *information;

+ (instancetype)sharedKVOModel;

@end
