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
+(NSMutableArray *)alertCaches{
    static id _alertCaches = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _alertCaches = [[NSMutableArray alloc] init];
    });
    return _alertCaches;
}

+(instancetype)alertWithTitle:(NSString *)title message:(NSString *)message{
    return [HCAlert alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}


-(id)addActionWithBlock:(UIAlertAction *(^)(UIAlertController *alertController))actionBlock{
    if (actionBlock) {
        __weak UIAlertController *__weakAc = self;
        UIAlertAction *action = actionBlock(__weakAc);
        [super addAction:action];
    }
    return self;
}

-(id)addTextFieldWithBlock:(void(^)(UITextField *textField,UIAlertController *alertController))textFieldBlock{
    __weak UIAlertController *__weakAc = self;
    if (textFieldBlock) {
        [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textFieldBlock(textField,__weakAc);
        }];
    }
    return self;
}

-(void)show{
    [[[self class] alertCaches]addObject:self];
    NSInteger index = [[[self class] alertCaches] indexOfObject:self];
    if (index!=0) {
        return;
    }
    UIViewController *topVc =[UIViewController hc_topestViewController];
    if (!topVc) {
        DebugLog(@"HCAlert show fail");
    }else{
        [topVc presentViewController:self animated:YES completion:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[[self class] alertCaches] removeObject:self];
    if ([[self class] alertCaches].count) {
        HCAlert *alert = [[self class] alertCaches].firstObject;
        [alert show];
    }
}

@end
