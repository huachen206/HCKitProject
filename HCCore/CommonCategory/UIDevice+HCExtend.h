//
//  UIDevice+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HCDeviceResolution) {
    UIDevice_320x480,// iPhone 1,3,3GS
    UIDevice_640x960,// iPhone 4,4S
    UIDevice_640x1136,// iPhone 5,5s,5SE
    UIDevice_750x1334,// iPhone 6,6s
    UIDevice_1242x2208,// iPhone 6p,6sp
    
    UIDevice_1024x768,// iPad 1,2 标准分辨率
    UIDevice_2048x1536,// iPad  iPad pro 9.7寸
    UIDevice_2732x2048,// iPad pro 12.9寸
    
    UIDevice_TV,
    UIDevice_unKnow,
};


@interface UIDevice (HCExtend)

+ (HCDeviceResolution)hc_currentResolution;
/**
 *  判断系统版本是否高于version
 *
 *  @param version 判断基线
 *
 */
+(BOOL)hc_isIOSBeyondThan:(float)version;
/**
 *  判断系统版本是否为version
 *
 *  @param version 对比基线
 *
 */
+(BOOL)hc_isIOSEqualTo:(float)version;
@end
