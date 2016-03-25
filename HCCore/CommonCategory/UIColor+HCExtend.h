//
//  UIColor+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/25.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HCExtend)
+(UIColor*)hc_colorWithHex:(NSInteger)rgbValue;
+(UIColor*)hc_colorWithHex:(NSInteger)rgbValue alpha:(float)alphaValue;
+(UIColor*)hc_colorRandom;
+(UIColor*)hc_colorWithWhitePercent:(float)p;
+(UIColor*)hc_colorWithBlackPercent:(float)p;
+(UIColor*)hc_colorForWhiteWithAlpha:(float)Alpha;
+(UIColor*)hc_colorForBlackWithAlpha:(float)Alpha;
@end
