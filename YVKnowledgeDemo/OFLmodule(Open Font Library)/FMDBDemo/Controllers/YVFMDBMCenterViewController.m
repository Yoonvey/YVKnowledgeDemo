//
//  YVFMDBMCenterViewController.m
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/23.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVFMDBMCenterViewController.h"

#import "YVFMDBBase.h"

@interface YVFMDBMCenterViewController ()

@end

@implementation YVFMDBMCenterViewController

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"FMDB数据库使用"];
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
    self.view.backgroundColor = KColor(240, 240, 240);
    [self setupCreationButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - <setupInterFace>
- (void)setupCreationButton
{
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame =CGRectMake((ScreenWidth-100)*0.5, ScreenHeight*0.5-85, 100, 50);
    createBtn.layer.backgroundColor = KColor(255, 105, 180).CGColor;
    createBtn.layer.cornerRadius = 4.0;
    [createBtn setTitle:@"创建" forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(clickResponseOfCreatedDataBase) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    
    UIButton *insertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    insertBtn.frame =CGRectMake((ScreenWidth-100)*0.5, ScreenHeight*0.5-25, 100, 50);
    insertBtn.layer.backgroundColor = KColor(0, 0, 205).CGColor;
    insertBtn.layer.cornerRadius = 4.0;
    [insertBtn setTitle:@"添加" forState:UIControlStateNormal];
    [insertBtn addTarget:self action:@selector(clickResponseOfInsertDataSource) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insertBtn];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame =CGRectMake((ScreenWidth-100)*0.5, ScreenHeight*0.5+35, 100, 50);
    selectBtn.layer.backgroundColor = KColor(47,79,79).CGColor;
    selectBtn.layer.cornerRadius = 4.0;
    [selectBtn setTitle:@"查询" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(clickResponseOfSelectedDataBase) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
}

#pragma mark - <Action>
- (void)clickResponseOfCreatedDataBase
{
    NSMutableDictionary *form = [NSMutableDictionary dictionary];
    [form setValue:@"text" forKey:@"subId"];
    [form setValue:@"text" forKey:@"name"];
    
    BOOL flag = [[YVFMDBBase sharedDataBase] createDataBaseWithSqliteName:@"test" form:form];
    NSLog(@"create_flag>%i", flag);
}

- (void)clickResponseOfInsertDataSource
{
    NSMutableDictionary *form = [NSMutableDictionary dictionary];
    [form setValue:@"1x" forKey:@"subId"];
    [form setValue:@"你喵" forKey:@"name"];
    BOOL flag = [[YVFMDBBase sharedDataBase] insertDataSources:AppendingInsertionQueryString([YVFMDBBase sharedDataBase].tableName, [YVFMDBBase sharedDataBase].keyProperties, form), @"1x", @"你喵"];
    NSLog(@"insert_flag>%i", flag);
}

- (void)clickResponseOfSelectedDataBase
{
    NSMutableArray *results = [[YVFMDBBase sharedDataBase] selectedInfoWithCondition:nil objectName:nil];
    NSLog(@"select_results>%@", results);
}

@end
