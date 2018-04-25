//
//  YVCustomViewManager.h
//  iOS_SuperBlocks
//
//  Created by 周荣飞 on 17/4/28.
//  Copyright © 2017年 EdwinChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YVCustomViewManager : NSObject

#pragma mark - <TableView相关>
/*!
 * @brief 设置表格的分割线从最左边显示(两个方法配套使用)
 */
+ (void)setSeparatorInsetsZeroWithTableView:(UITableView *)tableView;
+ (void)setSeparatorInsetsZeroWithCell:(UITableViewCell *)cell;
/*!
 * @brief 隐藏(替换)表格多余的分割线
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView;


#pragma mark - <图片相关>

/*!
 * @brief点击图片放大,再次点击退出查看,不支持缩放
 * @param avatarImageView 图片所在的avatarImageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

/*!
 * @brief 在图片上添加文字(支持中文显示)
 * @param image 图片
 * @param contentString 要添加的文字内容
 * @param fontSize 要添加的文字内容的字体大小
 * @param color 要添加的文字内容的字体颜色
 * @param contextPoint 文字的绘制点
 * @return 新的图片
 */
+ (UIImage *)attachCustomStringForImage:(UIImage *)image
                withCustomContentString:(NSString *)contentString
               andCustomContentFontSize:(CGFloat)fontSize
                  andCustomContentColor:(UIColor *)color
                        andContextPoint:(CGPoint)contextPoint;

+ (NSString *)getNowTimeImageName;

+ (NSData *)compressImage:(UIImage *)image
                   toByte:(NSUInteger)maxLength;


@end
