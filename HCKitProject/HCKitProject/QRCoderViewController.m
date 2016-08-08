//
//  QRCoderViewController.m
//  HCKitProject
//
//  Created by HuaChen on 16/6/21.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "QRCoderViewController.h"
#import "UIImage+HCExtend.h"
#import "HCQRScanner.h"
@interface QRCoderViewController(){
    HCQRScanner *_scanner;
}
@end
@implementation QRCoderViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"二维码";
}
- (IBAction)sureAction:(id)sender {
    [self.textField resignFirstResponder];
    if (_scanner) {
        [_scanner clear];
    }
    if (self.textField.text.length) {
        self.qrCoderImageView.image = [UIImage hc_imageBlackToTransparent:[UIImage hc_imageWithQRString:self.textField.text size:self.qrCoderImageView.bounds.size.width level:@"M"] withRed:100 andGreen:40 andBlue:200];
    }
}

- (IBAction)scannerAction:(id)sender {
    self.qrCoderImageView.image = nil;
    _scanner =[HCQRScanner inView:self.qrCoderImageView scannerResult:^(HCQRScanner *scanner, NSString *result) {
        self.textField.text = result;
        NSLog(@"%@",result);
        [scanner clear];
    } isStartNow:YES];
    
}
@end
