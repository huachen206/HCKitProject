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
@implementation HUDViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"HUD";
    
    
    
}
- (IBAction)hudAction:(id)sender {
    HCHUD *hud = [[HCHUD alloc] init];
    [self presentViewController:hud animated:YES completion:nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
//        [hud dismiss];
    });
    
}
- (IBAction)alertAction:(id)sender {
    [[[HCAlert alertWithTitle:@"alert" message:@"this is a alert"] addAction:^UIAlertAction * _Nullable(UIAlertController * _Nonnull alertController) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        return action;
    }] show];
    
    
}
@end
