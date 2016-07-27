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
#import "HCUtilityMacro.h"
#import "UILabel+StringFrame.h"

@implementation HCHUDOptions
-(id)init{
    if (self == [super init]) {
        _cornerRadius = 14.0f;
        if ([UIFont respondsToSelector:@selector(preferredFontForTextStyle:)]) {
            _font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        } else {
            _font = [UIFont systemFontOfSize:17.0f];
        }
    }
    return self;
}
- (UIColor*)hudViewBackgroudColorForStyle {
    if(self.defaultStyle == HCHUDStyleLight) {
        return [UIColor whiteColor];
    } else if(self.defaultStyle == HCHUDStyleDark) {
        return [UIColor blackColor];
    } else {
        return self.hudBackgroundColor;
    }
}
- (UIColor*)foregroundColorForStyle {
    if(self.defaultStyle == HCHUDStyleLight) {
        return [UIColor blackColor];
    } else if(self.defaultStyle == HCHUDStyleDark) {
        return [UIColor whiteColor];
    } else {
        return self.foregroundColor;
    }
}

@end


@interface HCHUD()<UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) UIView *hudView;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIImageView *imageView;
@end
@implementation HCHUD

+(HCHUD*)HUD{
    static HCHUD *_sharedInstance = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
+(void)showWithText:(NSString *)text{
    [[self HUD] setText:text];
    [[self HUD] show];
}

+(void)showWithImage:(UIImage *)image withText:(NSString *)text{
    if (image) {
        [[self HUD] setImage:image];
    }
    if (text) {
        [[self HUD] setText:text];
    }
    [[self HUD] show];
}

-(HCHUDOptions *)options{
    if (!_options) {
        _options = [[HCHUDOptions alloc] init];
    }
    return _options;
}
- (UIView*)hudView {
    if(!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _hudView.center = self.view.center;
        _hudView.layer.masksToBounds = YES;
//        _hudView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    
    // Update styling
    _hudView.layer.cornerRadius = self.options.cornerRadius;
    _hudView.backgroundColor = self.options.hudViewBackgroudColorForStyle;
    
    return _hudView;
}
- (UILabel*)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _statusLabel.numberOfLines = 0;
    }
    if(!_statusLabel.superview) {
        [self.hudView addSubview:_statusLabel];
    }
    
    // Update styling
    _statusLabel.textColor = self.options.foregroundColorForStyle;
    _statusLabel.font = self.options.font;
//    _statusLabel.backgroundColor = [UIColor redColor];
    
    return _statusLabel;
}
- (UIImageView*)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeCenter;
//        _imageView.backgroundColor = [UIColor greenColor];
    }
    if(!_imageView.superview) {
        [self.hudView addSubview:_imageView];
    }
    return _imageView;
}



-(id)init{
    if (self == [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.view.backgroundColor = [UIColor clearColor];
        

        [self.view addSubview:self.hudView];
        
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    UIColor *tintColor = self.options.foregroundColorForStyle;
    UIImage *tintedImage = image;
    if([self.imageView respondsToSelector:@selector(setTintColor:)]) {
        if (tintedImage.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            tintedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        self.imageView.tintColor = tintColor;
    } else {
        tintedImage = [self image:image withTintColor:tintColor];
    }
    self.imageView.image = tintedImage;
}
- (UIImage*)image:(UIImage*)image withTintColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

-(void)setText:(NSString *)text{
    [self.statusLabel setText:text];
}


-(void)updateConstraints{
    CGFloat margin = self.options.cornerRadius;

    CGFloat hudWidth = 0.f;
    CGFloat hudHeight =0;
    
    CGRect labelRect = CGRectZero;
    CGRect imageRect = CGRectZero;

    
    CGSize imageSize = CGSizeZero;
    if (self.imageView.image) {
        imageSize = self.imageView.image.size;
        hudWidth = imageSize.width;
        hudHeight = imageSize.height;
        
    }

    CGSize labelSize = CGSizeZero;
    if (self.statusLabel.text.length) {
        labelSize = [self.statusLabel boundingRectWithSize:CGSizeMake(200, 300)];
        hudWidth += labelSize.width;
        hudHeight += labelSize.height;
        
    }
    
    hudWidth += margin*2;
    hudWidth = MAX(hudWidth, 100);
    
    hudHeight = hudHeight + margin*2 +10;
    hudHeight = MAX(hudHeight, 90);

    self.hudView.frame = CGRectMake(0, 0, hudWidth, hudHeight);
    self.hudView.center = self.view.center;
    
    if (self.imageView.image) {
        imageRect = CGRectMake(hudWidth/2 - imageSize.width/2, margin, imageSize.width, imageSize.height);
        self.imageView.frame = imageRect;
    }
    
    if (self.statusLabel.text.length) {
        labelRect = CGRectMake(hudWidth/2 - labelSize.width/2,hudHeight - labelSize.height- margin, labelSize.width, labelSize.height);
        self.statusLabel.frame = labelRect;
    }
    
    if (!self.imageView.image || !self.statusLabel.text.length) {
        self.statusLabel.center = CGPointMake(hudWidth/2, hudHeight/2);
        self.imageView.center = CGPointMake(hudWidth/2, hudHeight/2);

    }
    [self updateBlurBounds];

}
- (void)updateBlurBounds {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if(NSClassFromString(@"UIBlurEffect") && self.options.defaultStyle != HCHUDStyleCustom) {
        // Remove background color, else the effect would not work
        self.hudView.backgroundColor = [UIColor clearColor];
        
        // Remove any old instances of UIVisualEffectViews
        for (UIView *subview in self.hudView.subviews) {
            if([subview isKindOfClass:[UIVisualEffectView class]]) {
                [subview removeFromSuperview];
            }
        }
        
        if(self.options.hudBackgroundColor != [UIColor clearColor]) {
            // Create blur effect
            UIBlurEffectStyle blurEffectStyle = self.options.defaultStyle == HCHUDStyleDark ? UIBlurEffectStyleDark : UIBlurEffectStyleLight;
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurEffectView.autoresizingMask = self.hudView.autoresizingMask;
            blurEffectView.frame = self.hudView.bounds;
            
            // Add vibrancy to the blur effect to make it more vivid
            UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
            UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
            vibrancyEffectView.autoresizingMask = blurEffectView.autoresizingMask;
            vibrancyEffectView.bounds = blurEffectView.bounds;
            [blurEffectView.contentView addSubview:vibrancyEffectView];
            
            [self.hudView insertSubview:blurEffectView atIndex:0];

        }
    }
#endif
}

-(void)show{
    [self updateConstraints];

    UIViewController *topVc =[UIViewController hc_topestViewController];
    if (!topVc) {
        DebugLog(@"HCHUD show fail");
    }else{
        [topVc presentViewController:self animated:YES completion:nil];
    }
}

+(void)dismiss{
    [[self HUD] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIViewControllerTransitioningDelegate
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0){
    if(presented == self){
        HCHUDPresentationController *pc =[[HCHUDPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
        pc.dimingColor = self.options.dimingColor;
        return pc;
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
