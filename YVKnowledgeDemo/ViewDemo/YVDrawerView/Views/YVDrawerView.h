//
//  YVDrawerView.h
//  WisdomParkingSpaces
//
//  Created by 周荣飞 on 2018/3/6.
//  Copyright © 2018年 ModouTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YVDrawerView : UIView

@property (nonatomic) CGFloat normalDisplayHeight;//显示时(非全屏)的高度
@property (nonatomic) CGFloat marginTopHeight;//距离顶部的距离
@property (nonatomic) CGFloat effectiveHeight;//释放时拖动到设定之后执行拖动生效(正值)

- (void)reloadOrigins;
- (void)responderOfShowLayoutsForNormalState;
- (void)responderOfDismissLayouts;

@end
