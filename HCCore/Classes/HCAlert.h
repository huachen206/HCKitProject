//
//  HCAlert.h
//  HCKitProject
//
//  Created by HuaChen on 16/7/9.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface HCAlert : UIAlertController
+(instancetype _Nonnull)alertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message;
-(id _Nonnull)addAction:(UIAlertAction * _Nullable(^_Nonnull)(UIAlertController *_Nonnull alertController))actionBlock;
-(void)show;
-(id _Nonnull)addTextField:(void(^_Nonnull)(UITextField *_Nonnull textField,UIAlertController *_Nonnull alertController))textFieldBlock;
@end