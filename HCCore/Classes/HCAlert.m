//
//  HCAlert.m
//  HCKitProject
//
//  Created by HuaChen on 16/7/9.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCAlert.h"
#import "UIViewController+HCExtend.h"
#import "HCUtilityMacro.h"
@interface HCAlert()
@property (nonatomic,strong) UIAlertController *alertController;

@end

@implementation HCAlert
+(instancetype)alertWithTitle:(NSString *)title message:(NSString *)message{
    HCAlert *alert = [[HCAlert alloc] init];
    alert.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    return alert;
}
-(id)addAction:(UIAlertAction *(^)(UIAlertController *alertController))actionBlock{
    if (actionBlock) {
        UIAlertAction *action = actionBlock(self.alertController);
        [self.alertController addAction:action];
    }
    return self;
}

-(id)addTextField:(void(^)(UITextField *textField,UIAlertController *alertController))textFieldBlock{
    __weak UIAlertController *__weakAc = self.alertController;
    if (textFieldBlock) {
        [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textFieldBlock(textField,__weakAc);
        }];
    }
    return self;
}

-(void)show{
    UIViewController *topVc =[UIViewController hc_topestViewController];
    if (!topVc) {
        DebugLog(@"HCAlert show fail");
    }else{
        [topVc presentViewController:self.alertController animated:YES completion:nil];
    }
}


@end
