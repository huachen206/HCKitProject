//
//  UIViewController+HCExtend.h
//  RFTPMS
//
//  Created by HuaChen on 16/7/6.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HCExtend)
/**
 *  获取当前keywindow 最上层的视图控制器。
 *
 */
+(UIViewController *)hc_topestViewController;
/**
 *  获取某个视图控制器上最上层的视图控制器
 *
 */
+(UIViewController *)hc_getTopestViewController:(UIViewController *)rootViewController;
@end
