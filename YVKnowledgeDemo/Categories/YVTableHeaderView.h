//
//  YVTableHeaderView.h
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/11.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YVTableHeaderView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger section;

@property (nonatomic) CGFloat titleSize;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *title;

@end
