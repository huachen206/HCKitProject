//
//  HCHUDPresentationController.m
//  HCKitProject
//
//  Created by HuaChen on 16/7/9.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCHUDPresentationController.h"
@interface HCHUDPresentationController()
@property (nonatomic,strong) UIView *dimingView;
@end

@implementation HCHUDPresentationController

-(UIView *)dimingView{
    if (!_dimingView) {
        _dimingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _dimingView.backgroundColor = [UIColor clearColor];
        _dimingView.alpha = 0;
    }
    return _dimingView;
}

-(void)setDimingColor:(UIColor *)dimingColor{
    self.dimingView.backgroundColor = dimingColor;
}

- (void)presentationTransitionWillBegin{
    UIView *containerView = self.containerView;
    UIView *presentedView = self.presentedView;

    self.dimingView.frame = containerView.bounds;
    [containerView addSubview:self.dimingView];
    [containerView addSubview:presentedView];
    
    if (self.presentedViewController.transitionCoordinator) {
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.dimingView.alpha = 1.0;
        } completion:nil];
    }
    
}
- (void)presentationTransitionDidEnd:(BOOL)completed{
    if (!completed) {
        [self.dimingView removeFromSuperview];
        [self.presentedView removeFromSuperview];
    }
}
- (void)dismissalTransitionWillBegin{
    if (self.presentedViewController.transitionCoordinator) {
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.dimingView.alpha = 0;
        } completion:nil];
    }
}
- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed) {
        [self.dimingView removeFromSuperview];
        [self.presentedView removeFromSuperview];
    }
}

//- (CGRect)frameOfPresentedViewInContainerView{
//    if (self.containerView) {
//        return CGRectInset(self.containerView.frame, 50, 50);
//    }
//    return CGRectZero;
//}

@end
