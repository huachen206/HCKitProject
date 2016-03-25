//
//  HCUtilityFuc.h
//  BusinessArea
//
//  Created by 花晨 on 14-7-12.
//  Copyright (c) 2014年 花晨. All rights reserved.
//



static inline short kScreenScale() {
    static short __screenScale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __screenScale = [[UIScreen mainScreen] scale];
    });
    return __screenScale;
}

static inline UIImage *imageWithColor(CGSize size, UIColor *color) {
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


static inline BOOL isIOS5Clan(){
    double ver =[[[UIDevice currentDevice] systemVersion] doubleValue];
    return ver>=5.0 && ver<6.0;
}

static inline BOOL isIOS7AndBeyond() {
    return [[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0;
}

static inline BOOL isIOS6Clan() {
    double ver = [[[UIDevice currentDevice] systemVersion] doubleValue];
    return ver>=6.0 && ver < 7.0;
    ;
}
static inline UIBarButtonItem *barItem(UIView *view) {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    barButtonItem.width = view.bounds.size.width;
    return barButtonItem;
}
//获取屏幕实际尺寸
static inline CGRect getScreenFrame() {
    return [UIScreen mainScreen].bounds;
}

