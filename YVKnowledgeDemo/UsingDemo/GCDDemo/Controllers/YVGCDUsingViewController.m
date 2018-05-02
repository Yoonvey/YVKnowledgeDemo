//
//  YVGCDUsingViewController.m
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/28.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVGCDUsingViewController.h"

#import "YVGCDServer.h"

@interface YVGCDUsingViewController ()

@property (nonatomic, strong) YVGCDServer *server;

@end

@implementation YVGCDUsingViewController

#pragma mark - <LazyLoading>
- (YVGCDServer *)server
{
    if (!_server)
    {
        _server = [[YVGCDServer alloc]init];
    }
    return _server;
}

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"GCD"];
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
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.frame = CGRectMake((ScreenWidth-100)*0.5, (ScreenHeight-50)*0.5, 100, 50);
    [sender setTitle:@"发送实例" forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(clickResponseOfSending) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender];
}

#pragma mark - <UserAction>
- (void)clickResponseOfSending
{
    __weak YVGCDUsingViewController *weakSelf = self;
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择发送方式" preferredStyle:UIAlertControllerStyleActionSheet];
    // 2.创建并添加按钮
    UIAlertAction *concurrentAction = [UIAlertAction actionWithTitle:@"并发队列" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        NSLog(@"并发队列");
        [weakSelf.server asyncGlobalQueue];
    }];
    
    UIAlertAction *serialAction = [UIAlertAction actionWithTitle:@"串行队列" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        NSLog(@"串行队列");
        [weakSelf.server asyncSerialQueue];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        NSLog(@"取消");
    }];
    
    [alertControl addAction:concurrentAction];
    [alertControl addAction:serialAction];
    [alertControl addAction:cancelAction];
    [self presentViewController:alertControl animated:YES completion:nil];
}

@end
