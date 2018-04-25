//
//  YVCustomViewManager.m
//  iOS_SuperBlocks
//
//  Created by 周荣飞 on 17/4/28.
//  Copyright © 2017年 EdwinChen. All rights reserved.
//

#import "YVCustomViewManager.h"

static CGRect oldframe;

@implementation YVCustomViewManager

#pragma mark - <TableView相关>
+ (void)setSeparatorInsetsZeroWithTableView:(UITableView *)tableView
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

+ (void)setSeparatorInsetsZeroWithCell:(UITableViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - <图片相关>
+(void)showImage:(UIImageView*)avatarImageView
{
    UIImage *image = avatarImageView.image;
    if(!image)
    {
        return;
    }
    // 获得根窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    oldframe =[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor =[UIColor blackColor];
    backgroundView.alpha = 0.5;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    //点击图片缩小的手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    [UIView animateWithDuration:0.3 animations:^
     {
         imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
         backgroundView.alpha =1;
     }];
}
+(void)hideImage:(UITapGestureRecognizer *)tap
{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^
     {
         imageView.frame = oldframe;
         backgroundView.alpha = 0;
     } completion:^(BOOL finished)
     {
         [backgroundView removeFromSuperview];
     }];
}

+ (UIImage *)attachCustomStringForImage:(UIImage *)image
                withCustomContentString:(NSString *)contentString
               andCustomContentFontSize:(CGFloat)fontSize
                  andCustomContentColor:(UIColor *)color
                        andContextPoint:(CGPoint)contextPoint
{
    //设置字体样式
    //    UIFont *font = [UIFont fontWithName:@"Arial-BoldItalicMT"size:fontSize];
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *dict = @{NSFontAttributeName:font,
                           NSForegroundColorAttributeName:color,
                           NSParagraphStyleAttributeName:paragraph};
    
    CGSize contentSize = [contentString sizeWithAttributes:dict];
    //绘制上下文
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0, image.size.width, image.size.height)];
    CGRect rect = {CGPointMake(contextPoint.x, contextPoint.y - contentSize.height/2), image.size};
    
    //此方法必须写在上下文才生效
    [contentString drawInRect:rect withAttributes:dict];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  获取当前时间
 *
 *  @return 以"20160621171802.png"形式的当前时间字符串形式的照片名
 */
+ (NSString *)getNowTimeImageName
{
    //获取当前时间
    
    NSDate* today = [NSDate date];
    
    NSLog(@"%@",today);
    //转换时间格式
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyyMMddHHmmss"];
    
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    NSString* s1 = [df stringFromDate:today];
    
    NSString *s2 = [NSString stringWithFormat:@"%@.png",s1];
    
    return s2;
}

+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength
{
    // Compress by quality
    CGFloat compression = 1.0;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i)
    {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9)
        {
            min = compression;
        }
        else if (data.length > maxLength)
        {
            max = compression;
        }
        else
        {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength)
    {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}


@end
