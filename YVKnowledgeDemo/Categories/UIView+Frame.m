//
//  UIView+Frame.m
//  WisdomParkingSpace
//
//  Created by 周荣飞 on 17/9/25.
//  Copyright © 2017年 ModouTech. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - Shortcuts for the coords

- (CGFloat)c_top
{
    return self.frame.origin.y;
}

- (void)setC_top:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)c_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setC_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)c_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setC_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)c_left
{
    return self.frame.origin.x;
}

- (void)setC_left:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)c_width
{
    return self.frame.size.width;
}

- (void)setC_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)c_height
{
    return self.frame.size.height;
}

- (void)setC_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - Shortcuts for frame properties

- (CGPoint)c_origin {
    return self.frame.origin;
}

- (void)setC_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)c_size {
    return self.frame.size;
}

- (void)setC_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
#pragma mark - Shortcuts for positions

- (CGFloat)c_centerX {
    return self.center.x;
}

- (void)setC_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)c_centerY {
    return self.center.y;
}

- (void)setC_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


@end
