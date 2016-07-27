//
//  HUDViewController.m
//  HCKitProject
//
//  Created by HuaChen on 16/7/9.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HUDViewController.h"
#import "HCAlert.h"
#import "HCHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+HCExtend.h"


@interface HUDViewController()
@property (nonatomic,strong) HCAlert *alert;

@end

@implementation HUDViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"HUD";
    [HCHUD HUD].options.defaultStyle = HCHUDStyleDark;
//    [HCHUD HUD].dimingColor = [UIColor hc_colorForBlackWithAlpha:0.5];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
}
static bool flag;
- (IBAction)hudAction:(id)sender {
    
    if (flag) {
        [SVProgressHUD showSuccessWithStatus:@"success"];
    }else{
        [HCHUD showWithImage:[UIImage imageNamed:@"success"] withText:@"success"];
//        [HCHUD showWithText:@"success"];
    }
    flag = !flag;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
        [HCHUD dismiss];
        [SVProgressHUD dismiss];
    });
    
    
    
    
}
- (IBAction)alertAction:(id)sender {
//    [[[HCAlert alertWithTitle:@"alert" message:@"this is a alert"] addActionWithBlock:^UIAlertAction * _Nullable(UIAlertController * _Nonnull alertController) {
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        return action;
//    }] show];

    for (int i = 0; i<3; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[HCAlert alertWithTitle:@"alert" message:@"this is a alert"] addActionWithBlock:^UIAlertAction * _Nullable(UIAlertController * _Nonnull alertController) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                return action;
            }] show];
        });
    }
    
}
@end
