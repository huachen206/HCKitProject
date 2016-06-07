//
//  HCUnit.m
//  RFTPMS
//
//  Created by HuaChen on 16/6/3.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "HCUnit.h"

@implementation HCUValue
+(instancetype)uvalueWithValue:(double)value unit:(NSString *)unit{
    HCUValue *uv = [[HCUValue alloc] init];
    uv.value = value;
    uv.unit = unit;
    return uv;
}

-(void)whenUnit:(NSString *)unit toUnit:(NSString *)toUnit formula:(double(^)(double value))formula{
    if ([self.unit isEqualToString:unit]) {
        self.unit = toUnit;
        self.value = formula(self.value);
    }
}

-(HCUValue*)toUnit:(NSString *)toUnit formula:(double(^)(NSString *unit,double value))formula{
    return [HCUValue uvalueWithValue:formula(self.unit,self.value) unit:toUnit];
}
-(BOOL)isEqualUnit:(NSString *)unit{
    return [self.unit isEqualToString:unit];
}

@end

@interface HCUnit()
@property (nonatomic,strong) HCUValue *unitValue;
@end


@implementation HCUnit
-(id)initWithUValue:(HCUValue*)uvalue{
    if (self == [super init]) {
        self.unitValue = uvalue;
    }
    return self;
}
-(id)initWithValue:(double)value unit:(NSString*)unit {
    if (self == [super init]) {
        self.unitValue = [HCUValue uvalueWithValue:value unit:unit];
    }
    return self;
}
-(void)updateWithValue:(double)value unit:(NSString*)unit {
    self.unitValue = [HCUValue uvalueWithValue:value unit:unit];
}
-(HCUValue *)uvalueWithUnit:(NSString *)unit{
    NSAssert(NO, @"子类重载");
    return nil;
}

@end


@implementation HCUnitPressure

-(HCUValue *)baseUnitValue{
    if (![self.unitValue isEqualUnit:kUnitKey_kPa]) {
        self.unitValue = [self.unitValue toUnit:kUnitKey_kPa formula:^double(NSString *unit, double value) {
            if ([unit isEqualToString:kUnitKey_psi]) {
                return value*6.895;
            }else if([unit isEqualToString:kUnitKey_Bar]){
                return value*100;
            }else{
                return value;
            }
        }];
    }
    return self.unitValue;
}

-(HCUValue *)uvalueWithUnit:(NSString *)unit{
    if ([unit isEqualToString:kUnitKey_psi]) {
        return self.psi;
    }else if([unit isEqualToString:kUnitKey_Bar]){
        return self.Bar;
    }else{
        return self.kPa;
    }
}

-(HCUValue*)kPa {
    return [self baseUnitValue];
}
-(HCUValue*)Bar {
    return [[self baseUnitValue] toUnit:kUnitKey_Bar formula:^double(NSString *unit, double value) {
        return value/100;
    }];
}
-(HCUValue*)psi {
    return [[self baseUnitValue] toUnit:kUnitKey_psi formula:^double(NSString *unit, double value) {
        return value/6.895;
    }];
}
@end

@implementation HCUnitTemperature

-(HCUValue *)baseUnitValue{
    if (![self.unitValue isEqualUnit:kUnitKey_C]) {
        self.unitValue = [self.unitValue toUnit:kUnitKey_C formula:^double(NSString *unit, double value) {
            if ([unit isEqualToString:kUnitKey_F]) {
                return (value - 32)/1.8;
            }else{
                return value;
            }
        }];
    }
    return self.unitValue;
}

-(HCUValue*)C{
    return [self baseUnitValue];
}
-(HCUValue*)F{
    return [[self baseUnitValue] toUnit:kUnitKey_F formula:^double(NSString *unit, double value) {
        return value = value*1.8+32;
    }];
}
-(HCUValue *)uvalueWithUnit:(NSString *)unit{
    if ([unit isEqualToString:kUnitKey_F]) {
        return self.F;
    }else{
        return self.C;
    }
}

@end