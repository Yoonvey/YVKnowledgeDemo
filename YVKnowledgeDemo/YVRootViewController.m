//
//  YVRootViewController.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/4.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVRootViewController.h"

@interface YVRootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSDictionary *menus;
@property (nonatomic, strong) NSDictionary *titleInfo;

@end

@implementation YVRootViewController

#pragma mark - <Lazyloading>

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"菜单"];
}

#pragma mark - <LifeCycle>
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menus = @{
                   @"0":@{
                           @"0":@"YVKVODemoViewController-KVO模式应用",
                           @"1":@"YVDelegatesMainViewController-多代理模式应用",
                           @"2":@"YVCodingApplicationViewController-归档解档应用",
                           @"3":@"YVURLSessionListViewController-网络请求应用"
                           },
                    @"1":@{
                           @"0":@"YVDrawerViewController-拖动视图",
                           },
                    @"2":@{
                           @"0":@"YVFMDBMCenterViewController-FMDB数据库使用",
                           @"1":@"YVAFNetworkingCenterViewController-AFN网络框架使用"
                           }
                   };
    self.titleInfo = @{
                       @"0":@"应用",
                       @"1":@"视图",
                       @"2":@"开源库"
                       };
    [self setupListView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - <SetupInterFace>
- (void)setupListView
{
    _listView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _listView.bounces = NO;
    _listView.dataSource = self;
    _listView.delegate = self;
    [self.view addSubview:_listView];
    
    [YVCustomViewManager setExtraCellLineHidden:_listView];
}

#pragma mark - <UITableViewDelegate、DataSorce>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menus.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *object = [self.menus valueForKey:[NSString stringWithFormat:@"%li", section]];
    return object.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YVTableHeaderView *headerView = [[YVTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*heightScale)];
    headerView.backgroundColor = KColor(230, 230, 230);
    headerView.tableView = tableView;
    headerView.section = section;
    headerView.title = [self.titleInfo valueForKey:[NSString stringWithFormat:@"%li", section]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"RootViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:15*widthScale];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.contentMode = UIViewContentModeLeft;
    }
    NSDictionary *controlInfo = [self.menus valueForKey:[NSString stringWithFormat:@"%li", (long)indexPath.section]];
    cell.textLabel.text = [controlInfo valueForKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*heightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取字典存储的类的名称
    NSDictionary *controlInfo = [self.menus valueForKey:[NSString stringWithFormat:@"%li", (long)indexPath.section]];
    NSString *className = [controlInfo valueForKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    NSRange range = [className rangeOfString:@"-"];
    if (range.location != NSNotFound)
    {
        className = [className substringWithRange:NSMakeRange(0, range.location)];
    }
    
    //属性传值
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setValue:@"This is delegates value!" forKey:@"delegates"];
    [properties setValue:@"This is kvoNoti value!" forKey:@"kvoNoti"];
    
    //发起跳转
    [YVObserverManager push:self toNextControl:className withProperties:properties];
}

@end
