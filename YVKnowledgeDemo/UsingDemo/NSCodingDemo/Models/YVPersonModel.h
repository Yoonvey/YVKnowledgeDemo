//
//  YVPersonModel.h
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <Foundation/Foundation.h>

///**********************************************************************///
///***** 内容中注释掉的部分为常规归档解档示例, 本实例中使用runtime进行归档解档 *****///
///**********************************************************************///
 

@interface YVPersonModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *gender;

- (instancetype)initWithName:(NSString *)name
                      gender:(NSString *)gender;

@end
