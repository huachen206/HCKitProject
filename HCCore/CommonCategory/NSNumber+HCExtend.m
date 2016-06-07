//
//  NSNumber+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/6/4.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSNumber+HCExtend.h"

@implementation NSNumber (HCExtend)
-(NSString *)valueStringForRoundUp:(int)afterPoint{
    int a = pow(10, afterPoint);
    int intValue =(int)([self doubleValue]*a);
    NSDecimalNumber *dv = [NSDecimalNumber decimalNumberWithMantissa:intValue exponent:-afterPoint isNegative:NO];
    return dv.stringValue;
}
-(NSString *)valueStringForRoundZero{
    return [self valueStringForRoundUp:0];
}
-(NSString *)valueStringForRoundOne{
    return [self valueStringForRoundUp:1];
}
-(NSString *)valueStringForRoundTwo{
    return [self valueStringForRoundUp:2];
}
-(NSString *)valueStringForRoundThree{
    return [self valueStringForRoundUp:3];
}

@end
