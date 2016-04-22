//
//  UIDevice+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "UIDevice+HCExtend.h"

@implementation UIDevice (HCExtend)
+ (HCDeviceResolution)hc_currentResolution {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    float scale =[UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    float height = MAX(result.width, result.height);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (height == 480.0f) {
            return UIDevice_320x480;
        }else if (height == 960.0f){
            return UIDevice_640x960;
        }else if (height == 1136.0f){
            return UIDevice_640x1136;
        }else if (height == 1334.0f){
            return UIDevice_750x1334;
        }else if (height == 2208.0f){
            return UIDevice_1242x2208;
        }
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (height == 1024.0f) {
            return UIDevice_1024x768;
        }else if (height == 2048.0f){
            return UIDevice_2048x1536;
        }else if (height == 2732.0f){
            return UIDevice_2732x2048;
        }
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV){
        return UIDevice_TV;
    }
    return UIDevice_unKnow;
}

+(BOOL)hc_isIOSBeyondThan:(float)version {
    return [[[UIDevice currentDevice] systemVersion] doubleValue]>=version;
}
+(BOOL)hc_isIOSWith:(float)version{
    return [[[UIDevice currentDevice] systemVersion] doubleValue]==version;
}

@end
