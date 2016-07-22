//
//  UIViewController+HCExtend.m
//  RFTPMS
//
//  Created by HuaChen on 16/7/6.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "UIViewController+HCExtend.h"

@implementation UIViewController (HCExtend)
+(UIViewController *)hc_topestViewController{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        return nil;
    }
    UIViewController *topVc =[self hc_getTopestViewController:keyWindow.rootViewController];
    return topVc;
}


+(UIViewController *)hc_getTopestViewController:(UIViewController *)rootViewController{
    UIViewController *topVc = rootViewController;
    if ([topVc isKindOfClass:[UINavigationController class]]) {
        topVc = ((UINavigationController *)rootViewController).viewControllers.lastObject;
        return [self hc_getTopestViewController:topVc];
    }
    if (topVc.presentedViewController) {
        return [self hc_getTopestViewController:rootViewController.presentedViewController];
    }
    return topVc;
}

@end
