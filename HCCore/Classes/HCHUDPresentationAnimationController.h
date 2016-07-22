//
//  HCHUDPresentationAnimationController.h
//  HCKitProject
//
//  Created by HuaChen on 16/7/21.
//  Copyright © 2016年 花晨. All rights reserved.
//

@import UIKit;

@interface HCHUDPresentationAnimationController : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) BOOL isPresenting;
@property (nonatomic,assign) NSTimeInterval duration;
-(id)initWithisPresenting:(BOOL)isPresenting;
@end
