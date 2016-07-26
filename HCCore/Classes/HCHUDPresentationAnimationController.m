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
        self.duration = 0.3;
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
    
    presentedControllerView.frame = [transitionContext finalFrameForViewController:presentedController];
        presentedControllerView.center =containerView.center;
//    [containerView addSubview:presentedControllerView];
    presentedControllerView.transform = CGAffineTransformScale(presentedControllerView.transform, 1.3, 1.3);
    
    presentedControllerView.alpha = 0.0f;

    // 添加一个动画，让被呈现的 view 移动到最终位置，我们使用0.6的damping值让动画有一种duang-duang的感觉……
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        presentedControllerView.transform = CGAffineTransformScale(presentedControllerView.transform, 1/1.3f, 1/1.3f);
        presentedControllerView.alpha = 1.0f;

        
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
    
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        presentedControllerView.transform = CGAffineTransformScale(presentedControllerView.transform, 0.8, 0.8);
        presentedControllerView.alpha = 0;
    } completion:^(BOOL finished) {
        presentedControllerView.transform = CGAffineTransformScale(presentedControllerView.transform, 1/0.8, 1/0.8);
        [transitionContext completeTransition:finished];
    }];
}

@end
