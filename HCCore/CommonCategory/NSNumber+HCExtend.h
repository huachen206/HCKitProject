//
//  NSNumber+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/6/4.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (HCExtend)
-(NSString *)valueStringForRoundUp:(int)afterPoint;
-(NSString *)valueStringForRoundZero;
-(NSString *)valueStringForRoundOne;
-(NSString *)valueStringForRoundTwo;
-(NSString *)valueStringForRoundThree;
@end
