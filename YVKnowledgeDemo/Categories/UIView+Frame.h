//
//  UIView+Frame.h
//  WisdomParkingSpace
//
//  Created by 周荣飞 on 17/9/25.
//  Copyright © 2017年 ModouTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// shortcuts for frame properties
@property (nonatomic, assign) CGPoint c_origin;
@property (nonatomic, assign) CGSize c_size;

// shortcuts for positions
@property (nonatomic) CGFloat c_centerX;
@property (nonatomic) CGFloat c_centerY;


@property (nonatomic) CGFloat c_top;
@property (nonatomic) CGFloat c_bottom;
@property (nonatomic) CGFloat c_right;
@property (nonatomic) CGFloat c_left;

@property (nonatomic) CGFloat c_width;
@property (nonatomic) CGFloat c_height;

@end
