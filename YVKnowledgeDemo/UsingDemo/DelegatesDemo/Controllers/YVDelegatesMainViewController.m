//
//  YVDelegatesMainViewController.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVDelegatesMainViewController.h"

#import "YVDelegatesSource.h"

@interface YVDelegatesMainViewController () <YVDelegatesSourceDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *pushBtn;

@property (nonatomic, strong) YVDelegatesSource *delegateSource;

@end

@implementation YVDelegatesMainViewController

#pragma mark - <LazyLoading>
- (YVDelegatesSource *)delegateSource
{
    if (!_delegateSource)
    {
        _delegateSource = [YVDelegatesSource sharedDelegateSource];
    }
    return _delegateSource;
}

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"DelegatesMain"];
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
    
    //打印跳转封装的测试代码
    NSLog(@"DelegatesValue>%@", self.delegates);
    self.delegateSource.delegate = self;
    [self setupInterFace];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - <SetupInterFace>
- (void)setupInterFace
{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10*widthScale, SafeAreaTopHeight+10*heightScale, ScreenWidth-20*widthScale, ScreenHeight*0.5-40*heightScale)];
    _label.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _label.layer.borderWidth = 0.3;
    _label.layer.cornerRadius = 3.0;
    _label.font = [UIFont systemFontOfSize:17.0*widthScale];
    _label.textColor = [UIColor whiteColor];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_label];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(10*widthScale, SafeAreaTopHeight+ScreenHeight*0.5-20*heightScale, ScreenWidth-20*widthScale, 40*heightScale);
    _sendBtn.layer.backgroundColor = [UIColor orangeColor].CGColor;
    [_sendBtn setTitle:@"发送代理" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendDelegateCommunication) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    
    _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _pushBtn.frame = CGRectMake(10*widthScale, SafeAreaTopHeight+ScreenHeight*0.5+30*heightScale, ScreenWidth-20*widthScale, 40*heightScale);
    _pushBtn.layer.backgroundColor = [UIColor orangeColor].CGColor;
    [_pushBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [_pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_pushBtn addTarget:self action:@selector(pushToNextControl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pushBtn];
}

#pragma mark - <UserAction>
//发送代理内容
- (void)sendDelegateCommunication
{
    [self.delegateSource sendCommunication:@"YVDelegatesMainViewController.DelegateSendMessage!"];
}

//跳转下一页
- (void)pushToNextControl
{
    [YVObserverManager push:self toNextControl:@"YVDelegatesExtensionViewController" withProperties:nil];
}

#pragma mark - <RealizeDelegate>
- (void)delegateResponse:(id)communication
{
    NSLog(@"YVDelegatesMainViewController.Receive.communication>%@", communication);
    _label.text = [NSString stringWithFormat:@"代理回调内容: %@", communication];
}

@end
