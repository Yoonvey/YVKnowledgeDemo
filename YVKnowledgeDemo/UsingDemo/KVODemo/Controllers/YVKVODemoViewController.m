//
//  YVKVODemoViewController.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/4.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVKVODemoViewController.h"

#import "YVKVOModel.h"

@interface YVKVODemoViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *changeNum;

//@property (nonatomic, strong) YVKVOModel *kvoModel;

@end

@implementation YVKVODemoViewController

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"KVO-1"];
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
- (void)dealloc
{
    //注销KVO
    [[YVKVOModel sharedKVOModel] removeObserver:self forKeyPath:@"num" context:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupInterFace];
    
    NSLog(@"kvoNoti>%@", self.kvoNoti);
    
    /*1.注册对象myKVO为被观察者: option中，
     NSKeyValueObservingOptionOld 以字典的形式提供 “初始对象数据”;
     NSKeyValueObservingOptionNew 以字典的形式提供 “更新后新的数据”; */
    [[YVKVOModel sharedKVOModel] addObserver:self forKeyPath:@"num" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - <SetupInterFace>
- (void)setupInterFace
{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10*widthScale, SafeAreaTopHeight+10*heightScale, ScreenWidth-20*widthScale, ScreenHeight*0.5-10*heightScale)];
    _label.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _label.layer.borderWidth = 0.3;
    _label.layer.cornerRadius = 3.0;
    _label.font = [UIFont systemFontOfSize:17.0*widthScale];
    _label.textColor = [UIColor darkGrayColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    _changeNum = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeNum.frame = CGRectMake(10*widthScale, SafeAreaTopHeight+ScreenHeight*0.5+10*heightScale, ScreenWidth-20*widthScale, 40*heightScale);
    _changeNum.layer.backgroundColor = [UIColor orangeColor].CGColor;
    [_changeNum setTitle:@"下一页" forState:UIControlStateNormal];
    [_changeNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeNum addTarget:self action:@selector(valueIncrease:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeNum];
}

#pragma mark - <UserAction>
- (void)valueIncrease:(UIButton *)sender
{
    [YVObserverManager push:self toNextControl:@"YVKVONotificationViewController" withProperties:nil];
}

#pragma mark - <KVOResponse>
//只要object的keyPath属性发生变化，就会调用此回调方法，进行相应的处理：UI更新：*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //判断是否为self.rootModel的num属性
    if ([keyPath isEqualToString:@"num"] && object == [YVKVOModel sharedKVOModel])
    {
        // 响应变化处理：UI更新（label文本改变）
        _label.text = [NSString stringWithFormat:@"当前num为:%@", [change valueForKey:@"new"]];

        //change的使用：上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
        NSLog(@"The old num is:%@", [change valueForKey:@"old"]);
    }
}

@end
