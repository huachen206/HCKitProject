//
//  HCHUDPresentationAnimationController.m
//  HCKitProject
//
//  Created by HuaChen on 16/7/21.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCHUDPresentationAnimationController.h"

@implementation HCHUDPresentationAnimationController
-(id)initWithisPresenting:(BOOL)isPresenting{
    if (self == [super init]) {
        self.isPresenting = isPresenting;
        self.duration = 0.5;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.isPresenting) {
        [self animatePresentationWithTransitionContext:transitionContext];
    }
    else {
        [self animateDismissalWithTransitionContext:transitionContext];
    }
}

-(void)animatePresentationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    
    if (!presentedController||!presentedControllerView ||!containerView) {
        return;
    }
    
    // 设定被呈现的 view 一开始的位置，在屏幕下方
    presentedControllerView.frame = [transitionContext finalFrameForViewController:presentedController];
        presentedControllerView.center =containerView.center;
//    [containerView addSubview:presentedControllerView];
    presentedControllerView.alpha = 0;
    // 添加一个动画，让被呈现的 view 移动到最终位置，我们使用0.6的damping值让动画有一种duang-duang的感觉……
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        presentedControllerView.alpha = 1;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

-(void)animateDismissalWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = transitionContext.containerView;
    if (!presentedControllerView ||!containerView) {
        return;
    }
    // 添加一个动画，让要消失的 view 向下移动，离开屏幕
    
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        presentedControllerView.alpha = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

@end
