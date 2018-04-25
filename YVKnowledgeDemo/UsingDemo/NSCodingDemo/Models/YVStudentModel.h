//
//  YVStudentModel.h
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVPersonModel.h"

///**********************************************************************///
///***** 内容中注释掉的部分为常规归档解档示例, 本实例中使用runtime进行归档解档 *****///
///**********************************************************************///

@interface YVStudentModel : YVPersonModel

@property (nonatomic, copy) NSString *grade;

- (instancetype)initWithName:(NSString *)name
                      gender:(NSString *)gender
                       grade:(NSString *)grade;

@end
