//
//  NSNumber+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/6/4.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (HCExtend)
/**
 *  取四舍五入的字符串
 *
 *  @param afterPoint 小数点后几位
 *
 */
-(NSString *)valueStringForRoundBreaker:(int)afterPoint;
-(NSString *)valueStringForRoundZero;
-(NSString *)valueStringForRoundOne;
-(NSString *)valueStringForRoundTwo;
-(NSString *)valueStringForRoundThree;
/**
 *  将一个数字格式化为二进制数字符串
 *
 */
-(NSString *)valueStringForBinaryNumber;
@end
