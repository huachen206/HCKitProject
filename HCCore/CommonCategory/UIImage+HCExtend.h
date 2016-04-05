//
//  UIImage+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HCExtend)
/**
 *  图片缩放到指定大小
 *
 *  @param size      scaleType == 0,则为maxSize； scaleType == 1,则为toSize。
 *  @param scaleType 0默认，等比例缩放,不超过maxSize。  scaleType 1，强制缩放为toSize,不足部分留白。
 *
 *  @return 一张也许变小的图片
 */
-(UIImage*)hc_imageToSize:(CGSize)size scaleType:(int)scaleType;


/**
 *  裁剪出部分图片
 *
 *  @param cutRect 指定区域
 *
 *  @return 一张残缺的图片
 */
-(UIImage*)hc_imageWithCutRect:(CGRect)cutRect;


/**
 *  按比例切割图片
 *
 *  @param p1 切割比例，相加总值必须为1
 *
 *  @return 多张被分尸的图片
 */
-(NSArray*)hc_imagesWithPercentage:(NSNumber *)p1,...;

/**
 *  计算图片的容量
 *
 *  @return 图片容量，不要太胖
 */
-(float)hc_sizeInMB;

/**
 *  作为JPEG存在本地
 *
 *  @param quality 0~1
 *  @param path    存储地址
 *
 *  @return 存储地址
 */
-(BOOL)hc_saveAsJPEGWithQuality:(float)quality toPath:(NSString*)path;
/**
 *  将rawSize等比例缩小到constraint以内
 *
 *  @param constraint 容器大小
 *  @param rawSize    原size
 *
 *  @return 一个憋屈的size
 */
+(CGSize)hc_clampSizeTo:(CGSize)constraint size:(CGSize)rawSize;

/**
 *  限定图片容量大小
 *
 *  @param lengKb 容量上限
 *
 *  @return 一张也许更苗条的图片
 */
-(UIImage*)hc_imageUnderMaxKb:(float)lengKb;

/**
 *  返回一个内容可拉伸，边角不拉伸的图片。
 *
 */
-(UIImage *)hc_stretchableImage;


/**
 *  高斯模糊
 */
- (UIImage*)hc_imageWithGaussianBlur:(CGFloat)blurRadius;
/**
 *  从上下文中创建一个图片
 *
 */
+(UIImage*)hc_imageFromContext:(CGContextRef) context orientation:(UIImageOrientation) orientation;
@end
