//
//  YVAFNetworkingCenterViewController.m
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/23.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVAFNetworkingCenterViewController.h"

@interface YVAFNetworkingCenterViewController ()

@end

@implementation YVAFNetworkingCenterViewController

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"AFN开源库使用"];
}

//设置返回按键
- (UIButton*)setLeftButton
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [leftBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateHighlighted];
    return leftBtn;
}

- (void)leftButtonEvent:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <lifeCycle>
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = KColor(240, 240, 240);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
