//
//  YVBaseViewController.m
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/4.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVBaseViewController.h"

@interface YVBaseViewController ()

@end

@implementation YVBaseViewController

#pragma mark - <LifeCycle>
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.translucent = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBarHidden = NO;
    
    //设置默认的导航栏
    UIImage *bgimage = [self imageWithColor:[UIColor orangeColor]];
    [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    
    //注册响应方法
    //设置背景图片
    if ([self respondsToSelector:@selector(backgroundImage)])
    {
        UIImage *bgImage = [self setBackgroundImage];
        [self setNavigationBackImage:bgImage];
    }
    //设置标题
    if ([self respondsToSelector:@selector(setTitle)])
    {
        NSMutableAttributedString *attTitle = [self setTitle];
        [self setNavTitle:attTitle];
    }
    //左按钮
    if (![self leftButton])
    {
        [self configLeftBarItemWithImage];
    }
    //右按钮
    if (![self rightButton])
    {
        [self configRightBarItemWithImage];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //重写背景色
    if ([self respondsToSelector:@selector(setBackgroundColor)])
    {
        UIImage *image = [self imageWithColor:[self setBackgroundColor]];
        if ([self setBackgroundColor] == [UIColor clearColor])
        {
            self.navigationController.navigationBar.translucent = YES;
        }
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    //导航栏分割线
    UIImageView *line = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    line.hidden = NO;
    if ([self respondsToSelector:@selector(hideNavigationLine)] && [self hideNavigationLine])
    {
        line.hidden = YES;
    }
    //自定义titleView
    if([self respondsToSelector:@selector(setTitleView)])
    {
        self.navigationItem.titleView = [self setTitleView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - <backImage>
//设置导航栏背景图片
- (void)setNavigationBackImage:(UIImage *)image
{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image];
    [self.navigationController.navigationBar setShadowImage:image];
}

#pragma mark - <title>
//设置导航栏标题
- (void)setNavTitle:(NSMutableAttributedString *)title
{
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines = 0;//可能需要多行的标题
    navTitleLabel.textAlignment = NSTextAlignmentCenter;//居中
    navTitleLabel.backgroundColor = [UIColor clearColor];//背景无色
    navTitleLabel.userInteractionEnabled = YES;//用户交互开启
    [navTitleLabel setAttributedText:title];
    
    //标题点击事件，遵守协议，实现title_click_event方法即可
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    self.navigationItem.titleView = navTitleLabel;
}

- (void)titleClick:(UIGestureRecognizer *)tap
{
    UIView *view = tap.view;
    if ([self respondsToSelector:@selector(titleClickEvent:)])
    {
        [self titleClickEvent:view];
    }
}

#pragma mark - <leftButton>
- (BOOL)leftButton
{
    BOOL flag = [self respondsToSelector:@selector(setLeftButton)];
    if (flag)
    {
        UIButton *leftButton = [self setLeftButton];
        [leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = item;
        //        self.navigationItem.leftItemsSupplementBackButton = YES;//left和back共存
    }
    return flag;
}

- (void)configLeftBarItemWithImage
{
    if ([self respondsToSelector:@selector(setLeftButtonItemWithImage)])
    {
        UIImage *image = [self setLeftButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(leftClick:)];
        self.navigationItem.backBarButtonItem = item;
    }
}

- (void)leftClick:(id)sender
{
    if ([self respondsToSelector:@selector(leftButtonEvent:)])
    {
        [self leftButtonEvent:sender];
    }
}

#pragma mark - <rightButton>
- (BOOL)rightButton
{
    BOOL flag = [self respondsToSelector:@selector(setRightButton)];
    if (flag)
    {
        UIButton *rightButton = [self setRightButton];
        [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = item;
        //        self.navigationItem.leftItemsSupplementBackButton = YES;//left和back共存
    }
    return flag;
}

- (void)configRightBarItemWithImage
{
    if ([self respondsToSelector:@selector(setRightButtonItemWithImage)])
    {
        UIImage *image = [self setRightButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(rightClick:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)rightClick:(id)sender
{
    if ([self respondsToSelector:@selector(rightButtonEvent:)])
    {
        [self rightButtonEvent:sender];
    }
}

#pragma mark - <查找到Nav底部的黑线>
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - <自定义标题样式>
- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

#pragma mark - <扩展方法>
/*!
 * @brief 根据颜色生成纯色图片
 * @param color 颜色
 * @return 纯色图片
 */
-  (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
