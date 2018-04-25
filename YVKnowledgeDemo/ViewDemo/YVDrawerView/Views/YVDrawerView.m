//
//  YVDrawerView.m
//  WisdomParkingSpaces
//
//  Created by 周荣飞 on 2018/3/6.
//  Copyright © 2018年 ModouTech. All rights reserved.
//

#import "YVDrawerView.h"

@interface YVDrawerView ()

@property (nonatomic) CGPoint disOrigin;
@property (nonatomic) CGPoint normalOrigin;
@property (nonatomic) CGPoint screenOrigin;
@property (nonatomic) CGPoint stayOrigin;

@property (nonatomic) BOOL reload;

@end

@implementation YVDrawerView

#pragma mark - <构造方法>
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self addtionPanGestureRecognizer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addtionPanGestureRecognizer];
    }
    return self;
}

- (void)reloadOrigins
{
    self.reload = YES;
    if (self.normalDisplayHeight == 0)
    {
        self.normalDisplayHeight = 100*heightScale;
    }
    if (self.marginTopHeight == 0)
    {
        self.marginTopHeight = 65;
    }
    if (self.effectiveHeight == 0)
    {
        self.effectiveHeight = 30;
    }
    
    self.disOrigin = CGPointMake(0, ScreenHeight);
    self.stayOrigin = self.disOrigin;
    self.normalOrigin = CGPointMake(0, ScreenHeight-self.normalDisplayHeight);
    self.screenOrigin = CGPointMake(0, self.marginTopHeight);
}

#pragma mark - <添加滑动手势>
- (void)addtionPanGestureRecognizer
{
    //添加滑动手势响应
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionResponseWhileDraging:)];
    [self addGestureRecognizer:panGesture];
}

- (void)actionResponseWhileDraging:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self];
    if (self.c_origin.y + translation.y > self.normalOrigin.y)
    {
        self.c_origin = self.normalOrigin;
    }
    else if(self.c_origin.y + translation.y < self.screenOrigin.y)
    {
        self.c_origin = self.screenOrigin;
    }
    else
    {
        self.c_origin = CGPointMake(self.c_origin.x,self.c_origin.y + translation.y);
    }
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             if(self.c_origin.y<self.stayOrigin.y)//上拉
             {
                 if (self.normalOrigin.y - self.c_origin.y <= self.effectiveHeight)
                 {
                     self.c_origin = self.normalOrigin;
                 }
                 else
                 {
                     self.c_origin = self.screenOrigin;
                 }
             }
             else//下拉
             {
                 if (self.c_origin.y - self.screenOrigin.y > self.effectiveHeight)
                 {
                     self.c_origin = self.normalOrigin;
                 }
                 else
                 {
                     self.c_origin = self.screenOrigin;
                 }
             }
             self.stayOrigin = self.c_origin;
         } completion:nil];
    }
}

#pragma mark - <公开方法>
- (void)responderOfShowLayoutsForNormalState
{
    if (!self.reload)
    {
        [self reloadOrigins];
    }
    [UIView animateWithDuration:0.15f delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.c_origin = self.normalOrigin;
        self.stayOrigin = self.c_origin;
    } completion:nil];
}

- (void)responderOfDismissLayouts
{
    [UIView animateWithDuration:0.15f delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         self.c_origin = self.disOrigin;
         self.stayOrigin = self.c_origin;
     } completion:nil];
}

@end
