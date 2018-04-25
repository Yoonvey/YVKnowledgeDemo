//
//  YVBaseViewController.h
//  YVKnowledgeDemo
//
//  Created by 周荣飞 on 2018/4/4.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YVBaseControlDatasource <NSObject>

- (NSMutableAttributedString *)setTitle;//重写标题
- (UIButton *)setLeftButton;//重写左侧按钮
- (UIButton *)setRightButton;//重写右侧按钮
- (UIColor *)setBackgroundColor;//重写导航栏背景颜色
- (UIView *)setTitleView;//自定义导航栏TitleView
- (UIImage *)setBackgroundImage;//重写导航栏背景图片
- (BOOL)hideNavigationLine;//隐藏到导航栏底部黑线
- (UIImage *)setLeftButtonItemWithImage;
- (UIImage *)setRightButtonItemWithImage;

@end

@protocol YVBaseControlDelegate <NSObject>

@optional

- (void)titleClickEvent:(UIView *)sender;
- (void)leftButtonEvent:(UIButton *)sender;
- (void)rightButtonEvent:(UIButton *)sender;

@end

@interface YVBaseViewController : UIViewController <YVBaseControlDelegate, YVBaseControlDatasource, UINavigationControllerDelegate>

- (void)setNavTitle:(NSMutableAttributedString *)title;
- (NSMutableAttributedString *)changeTitle:(NSString *)title;

@end
