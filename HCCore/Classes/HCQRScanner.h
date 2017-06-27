//
//  HCQRScanner.h
//  HCKitProject
//
//  Created by HuaChen on 16/6/21.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@class HCQRScanner;
typedef void(^ScannerResultBlock)(HCQRScanner *scanner,NSString *result);

@interface HCQRScannerView : UIView
-(void)inView:(UIView *)inview scanner:(HCQRScanner *)scanner previewLayer:(CALayer *)prelayer;

@end

@class UIView;
@class HCQRScannerView;


@interface HCQRScanner : NSObject

/**
 *  扫描二维码
 *
 *  @param inview      取景框
 *  @param resultBlock 回调
 *  @param isStartNow  是否立即开始扫描
 */
-(void)inView:(UIView*)inview scannerResult:(ScannerResultBlock)resultBlock isStartNow:(BOOL)isStartNow;
+(instancetype)inView:(UIView*)inview scannerResult:(ScannerResultBlock)resultBlock isStartNow:(BOOL)isStartNow;

-(void)start;
-(void)stop;
-(void)clear;

@end
