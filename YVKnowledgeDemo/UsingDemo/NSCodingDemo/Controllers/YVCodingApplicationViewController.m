//
//  YVCodingApplicationViewController.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVCodingApplicationViewController.h"

#import "YVPersonModel.h"
#import "YVStudentModel.h"

@interface YVCodingApplicationViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIButton *getBtn;

@end

@implementation YVCodingApplicationViewController

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"NSCoding"];
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
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10*widthScale, SafeAreaTopHeight+10*heightScale, ScreenWidth-20*widthScale, ScreenHeight*0.5-40*heightScale)];
    _label.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _label.layer.borderWidth = 0.3;
    _label.layer.cornerRadius = 3.0;
    _label.font = [UIFont systemFontOfSize:17.0*widthScale];
    _label.textColor = [UIColor whiteColor];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_label];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(10*widthScale, SafeAreaTopHeight+ScreenHeight*0.5-20*heightScale, ScreenWidth-20*widthScale, 40*heightScale);
    _setBtn.layer.backgroundColor = [UIColor orangeColor].CGColor;
    [_setBtn setTitle:@"写入缓存" forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_setBtn addTarget:self action:@selector(setArchive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setBtn];
    
    _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getBtn.frame = CGRectMake(10*widthScale, SafeAreaTopHeight+ScreenHeight*0.5+30*heightScale, ScreenWidth-20*widthScale, 40*heightScale);
    _getBtn.layer.backgroundColor = [UIColor orangeColor].CGColor;
    [_getBtn setTitle:@"取出缓存" forState:UIControlStateNormal];
    [_getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getBtn addTarget:self action:@selector(getArchive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getBtn];
}

#pragma mark - <ArchiveSet>
//归档
- (void)setArchive
{
    YVStudentModel *studentA = [[YVStudentModel alloc]initWithName:@"老司机" gender:@"男" grade:@"23"];
    YVStudentModel *studentB = [[YVStudentModel alloc]initWithName:@"老干部" gender:@"男" grade:@"26"];
    
    //创建存储器进行编码
    NSMutableData *mData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:mData];
    [archiver encodeObject:studentA forKey:@"studentA"];
    [archiver encodeObject:studentB forKey:@"studentB"];
    [archiver finishEncoding];
    
    //写入缓存
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"student"];
    [mData writeToFile:path atomically:YES];
    
    NSLog(@"\r\n studentA: %@ \r\n studentB: %@ \r\n path:%@",studentA,studentB,path);
}

#pragma mark - <ArchiveGet>
//解档
- (void)getArchive
{
    //创建解编码编译器解档
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"student"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    YVStudentModel *studentA = [unarchiver decodeObjectForKey:@"studentA"];
    YVStudentModel *studentB = [unarchiver decodeObjectForKey:@"studentB"];
    [unarchiver finishDecoding];
    NSLog(@"\r\n student_A: %@ \r\n student_B: %@ \r\n path:%@",studentA, studentB, path);
    _label.text = [NSString stringWithFormat:@"StudentA: \r\n 姓名: %@ \r\n 性别:%@ \r\n 班级: %@ \r\n ========== \r\n StudentB: \r\n 姓名: %@ \r\n 性别:%@ \r\n 班级: %@", studentA.name, studentA.gender, studentA.grade, studentB.name, studentB.gender, studentB.grade];
}


@end
