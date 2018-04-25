//
//  YVTableHeaderView.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/11.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVTableHeaderView.h"

@interface YVTableHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YVTableHeaderView

#pragma mark - <Lazyloading>
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width, self.frame.size.height)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setFrame:(CGRect)frame
{
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
    [super setFrame:newFrame];
    [self addSubview:self.titleLabel];
}

//- (void)layoutSubviews
//{
//    if (_titleLabel)
//    {
//        self.titleLabel.font = [UIFont systemFontOfSize:self.titleSize];
//        self.titleLabel.textColor = self.titleColor;
//    }
//}


@end
