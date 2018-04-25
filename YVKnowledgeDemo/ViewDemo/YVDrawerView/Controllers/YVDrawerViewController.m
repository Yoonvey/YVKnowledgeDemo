//
//  YVDrawerViewController.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/11.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVDrawerViewController.h"

#import "YVDrawerUsingView.h"

@interface YVDrawerViewController ()

@property (nonatomic, strong) UIButton *showBtn;

@property (nonatomic, strong) YVDrawerUsingView *drawerView;

@end

@implementation YVDrawerViewController

#pragma mark - <LazyLoading>
- (YVDrawerUsingView *)drawerView
{
    if (!_drawerView)
    {
        _drawerView = [[YVDrawerUsingView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        [self.view addSubview:_drawerView];
    }
    return _drawerView;
}

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"拖动视图"];
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

#pragma mark - <LifeCycle>
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupInterFace];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - <SetupInterFace>
- (void)setupInterFace
{
    self.showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showBtn.frame = CGRectMake(50, (ScreenHeight-50)*0.5, 100, 50);
    self.showBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.showBtn setTitle:@"Show" forState:UIControlStateNormal];
    [self.showBtn  setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:self.showBtn];
    
    [self.showBtn addTarget:self action:@selector(showDrawerView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <UserAction>
- (void)showDrawerView
{
    [self.drawerView responderOfShowLayoutsForNormalState];
}

@end
