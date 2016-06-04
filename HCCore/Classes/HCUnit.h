//
//  HCUnit.h
//  RFTPMS
//
//  Created by HuaChen on 16/6/3.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HCUValue:NSObject

@property (nonatomic,assign) double value;
@property (nonatomic,strong) NSString *unit;

-(void)whenUnit:(NSString *)unit toUnit:(NSString *)toUnit formula:(double(^)(double value))formula;
-(HCUValue*)toUnit:(NSString *)toUnit formula:(double(^)(NSString *unit,double value))formula;
-(BOOL)isEqualUnit:(NSString *)unit;
+(instancetype)uvalueWithValue:(double)value unit:(NSString *)unit;
@end

@interface HCUnit : NSObject

-(id)initWithValue:(double)value unit:(NSString*)unit;
-(void)updateWithValue:(double)value unit:(NSString*)unit;
-(id)initWithUValue:(HCUValue*)uvalue;
-(HCUValue *)uvalueWithUnit:(NSString *)unit;


@end
static NSString *const kUnitKey_kPa = @"kPa";
static NSString *const kUnitKey_Bar = @"Bar";
static NSString *const kUnitKey_psi = @"psi";

@interface HCUnitPressure : HCUnit

-(HCUValue*)kPa;
-(HCUValue*)Bar;
-(HCUValue*)psi;
-(HCUValue *)uvalueWithUnit:(NSString *)unit;
@end

static NSString *const kUnitKey_C = @"℃";
static NSString *const kUnitKey_F = @"℉";
@interface HCUnitTemperature : HCUnit
-(HCUValue*)C;
-(HCUValue*)F;

@end
