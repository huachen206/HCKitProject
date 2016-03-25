//
//  UIColor+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/25.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "UIColor+HCExtend.h"

@implementation UIColor (HCExtend)
+(UIColor*)hc_colorWithHex:(NSInteger)rgbValue{
    return [self hc_colorWithHex:rgbValue alpha:1];
}
+(UIColor*)hc_colorWithHex:(NSInteger)rgbValue alpha:(float)alphaValue{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue];
}
+(UIColor*)hc_colorRandom{
    return [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
}
+(UIColor*)hc_colorWithWhitePercent:(float)p{
    return [UIColor colorWithRed:p green:p blue:p alpha:1];
}
+(UIColor*)hc_colorWithBlackPercent:(float)p{
    return [self hc_colorWithWhitePercent:1-p];
}

+(UIColor*)hc_colorForWhiteWithAlpha:(float)Alpha{
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:Alpha];
}
+(UIColor*)hc_colorForBlackWithAlpha:(float)Alpha{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:Alpha];
}

@end
