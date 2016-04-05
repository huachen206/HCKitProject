//
//  UIView+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HCExtend)
/**
 *  将此view截图
 */
+(UIView *)hc_snapshotOfView:(UIView*)view;
/**
 *  开始闪烁
 */
- (void)hc_stopShimmering;
- (void)hc_startShimmering;
@end
