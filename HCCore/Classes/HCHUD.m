//
//  HCHUD.m
//  RFTPMS
//
//  Created by HuaChen on 16/7/2.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "HCHUD.h"
#import "UIViewController+HCExtend.h"
#import "HCHUDPresentationController.h"
#import "HCHUDPresentationAnimationController.h"

@interface HCHUD()<UIViewControllerTransitioningDelegate>

@end
@implementation HCHUD
+(instancetype)HUD{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(id)init{
    if (self == [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.view.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"HUD";
        label.center = self.view.center;
        [self.view addSubview:label];
    }
    return self;
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIViewControllerTransitioningDelegate
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0){
    if(presented == self){
        return [[HCHUDPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    }else{
        return nil;
    }
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    if (presented == self) {
        return [[HCHUDPresentationAnimationController alloc] initWithisPresenting:YES];
    }else{
        return nil;
    }
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    if (dismissed == self) {
        return [[HCHUDPresentationAnimationController alloc] initWithisPresenting:NO];
    }else{
        return nil;
    }
}

@end
