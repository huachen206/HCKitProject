//
//  HCQRScanner.h
//  HCKitProject
//
//  Created by HuaChen on 16/6/21.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCQRScanner;
/**
 *  二维码扫描回调
 *
 *  @param scanner  本身
 *  @param result   结果字符串
 *  @param dontStop 扫描到结果后是否不停止。
 */
typedef void(^ScannerResultBlock)(HCQRScanner *scanner,NSString *result,BOOL *dontStop);

@interface HCQRScanner : NSObject
+(instancetype)scanner;
/**
 *  扫描二维码
 *
 *  @param inview      取景框
 *  @param resultBlock 回调
 *  @param isStartNow  是否立即开始扫描
 */
-(void)inView:(UIView*)inview scannerResult:(ScannerResultBlock)resultBlock isStartNow:(BOOL)isStartNow;

-(void)start;
-(void)stop;
-(void)clear;

@end
