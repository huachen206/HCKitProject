//
//  HCHUD.h
//  RFTPMS
//
//  Created by HuaChen on 16/7/2.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef NS_ENUM(NSInteger, HCHUDStyle) {
    HCHUDStyleLight,
    HCHUDStyleDark,
    HCHUDStyleCustom
};

@interface HCHUD : UIViewController
@property (assign, nonatomic) HCHUDStyle defaultStyle UI_APPEARANCE_SELECTOR;                   // default is HCHUDStyleLight

@property (nonatomic,strong) UIColor *dimingColor; //背景颜色
@property (nonatomic,strong) UIColor *hudBackgroundColor;//HUD背景色
@property (nonatomic,strong) UIColor *foregroundColor;//内容的前景色
@property (nonatomic,assign) float cornerRadius;

@property (strong, nonatomic) UIFont *font UI_APPEARANCE_SELECTOR;                  // default is [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]

+(HCHUD*)HUD;
+(void)dismiss;
+(void)showWithText:(NSString *)text;
+(void)showWithImage:(UIImage *)image withText:(NSString *)text;

@end
@interface HCBlockHUD : HCHUD

@end

@interface HCProgressHUD : HCHUD

@end
