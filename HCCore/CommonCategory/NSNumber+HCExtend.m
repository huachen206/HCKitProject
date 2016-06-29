//
//  NSNumber+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/6/4.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSNumber+HCExtend.h"

@implementation NSNumber (HCExtend)
-(NSString *)valueStringForRoundBreaker:(int)afterPoint {
    NSDecimalNumberHandler*roundBanker = [NSDecimalNumberHandler
                                          
                                          decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                          
                                          scale:afterPoint
                                          
                                          raiseOnExactness:NO
                                          
                                          raiseOnOverflow:NO
                                          
                                          raiseOnUnderflow:NO
                                          
                                          raiseOnDivideByZero:YES];
    
    NSDecimalNumber *dv = [NSDecimalNumber decimalNumberWithString:self.stringValue];
    dv = [dv decimalNumberByRoundingAccordingToBehavior:roundBanker];
    return dv.stringValue;

}

-(NSString *)valueStringForRoundZero{
    return [self valueStringForRoundBreaker:0];
}
-(NSString *)valueStringForRoundOne{
    return [self valueStringForRoundBreaker:1];
}
-(NSString *)valueStringForRoundTwo{
    return [self valueStringForRoundBreaker:2];
}
-(NSString *)valueStringForRoundThree{
    return [self valueStringForRoundBreaker:3];
}

-(NSString *)valueStringForBinaryNumber{
    NSInteger value = self.integerValue;
    NSMutableString *result = [[NSMutableString alloc] init];
    while (value) {
        NSInteger p = value&1;
        [result insertString:@(p).stringValue atIndex:0];
        value = value>>1;
    }
    return result;
}


@end
