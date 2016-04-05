//
//  UIView+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "UIView+HCExtend.h"

@implementation UIView (HCExtend)
+(UIView *)hc_snapshotOfView:(UIView*)view
{
    if ([view respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        return [view snapshotViewAfterScreenUpdates:YES];
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, view.bounds);
    
    [view.layer renderInContext:context];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *snapshotImageView = [[UIImageView alloc] initWithImage:snapshotImage];
    
    return snapshotImageView;
}
- (void)hc_startShimmering
{
    id light = (id)[UIColor colorWithWhite:0 alpha:0.2].CGColor;
    id dark  = (id)[UIColor blackColor].CGColor;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[light, dark, light];
    gradient.frame = CGRectMake(-self.bounds.size.width, 0, 3*self.bounds.size.width, self.bounds.size.height);
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint   = CGPointMake(1.0, 0.5); // slightly slanted forward
    gradient.locations  = @[@0.4, @0.5, @0.6];
    self.layer.mask = gradient;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = @[@0.0, @0.1, @0.2];
    animation.toValue   = @[@0.8, @0.9, @1.0];
    
    animation.duration = 1.5;
    animation.repeatCount = HUGE_VALF;
    [gradient addAnimation:animation forKey:@"shimmer"];
}

- (void)hc_stopShimmering
{
    self.layer.mask = nil;
}

@end
