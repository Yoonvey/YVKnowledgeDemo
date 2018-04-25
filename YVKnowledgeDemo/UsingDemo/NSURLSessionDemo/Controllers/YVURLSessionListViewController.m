//
//  YVURLSessionListViewController.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/8.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVURLSessionListViewController.h"

#import "YVURLSessionServer.h"

@interface YVURLSessionListViewController () <UITableViewDataSource, UITableViewDelegate, YVURLSessionDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray *menus;

@end

@implementation YVURLSessionListViewController

#pragma mark - <NavSet>
- (UIColor *)setBackgroundColor
{
    return [UIColor orangeColor];
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"网络应用菜单"];
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
    self.menus = [NSArray arrayWithObjects:@{@"0":@"GET请求"}, @{@"1":@"POST请求"}, @{@"2":@"Download下载"}, @{@"3":@""}, nil];
    [self setupListView];
    [YVURLSessionServer sharedSessionServer].delegate = self;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SessionListViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:15*widthScale];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.contentMode = UIViewContentModeLeft;
    }
    NSDictionary *controlInfo = self.menus[indexPath.row];
    cell.textLabel.text = [controlInfo valueForKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0://get
        {
            [[YVURLSessionServer sharedSessionServer] sendGetRequestWithUrlString:@"https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_1210762272462065281%22%7D&n_type=0&p_from=1" parameter:nil callBack:^(id responseObject)
             {
                 NSLog(@"responseObject>%@", responseObject);
                 NSLog(@"tasks>%@", [YVURLSessionServer sharedSessionServer].tasks);
             }];
        }
            break;
        case 1://post
        {
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            [parameter setValue:@"27.974402509690055" forKey:@"lat"];
            [parameter setValue:@"120.633862509690005" forKey:@"lon"];
            
            [[YVURLSessionServer sharedSessionServer] sendPostRequestWithUrlString:@"http://172.16.8.94:2222/GetNearByArea?" parameter:parameter callBack:^(id responseObject)
            {
                NSLog(@"responseObject>%@", responseObject);
                NSLog(@"tasks>%@", [YVURLSessionServer sharedSessionServer].tasks);
            }];
        }
            break;
        case 2://download
        {
            [[YVURLSessionServer sharedSessionServer] sendDownloadRequestWithUrlString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" delegateEnable:YES callBack:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - <YVURLSessionDelegate>
- (void)downloadSessionIsUnderway:(CGFloat)progress
{
    NSLog(@"progress= %f", progress);
}

- (void)downloadSessionIsResume:(NSURLSessionTask *)task
{
    NSLog(@"resume.taskDescription= %@", task.taskDescription);
}

- (void)downloadSessionDidFinished:(NSString *)fullPath
{
    NSLog(@"fullPath= %@", fullPath);
}

- (void)downloadSessionAppearedError:(NSError *)error
{
    NSLog(@"error= %@", error);
}

@end
