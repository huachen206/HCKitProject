//
//  NSString+HCValidation.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/7.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSString+HCValidation.h"
#import "HCIdCardNoRulesChecker.h"
#import <sys/socket.h>
#import <arpa/inet.h>

@implementation NSString (HCValidation)
-(BOOL)hc_ValidationForIDCard{
    NSError *error;
    return [HCIdCardNoRulesChecker checkIdCardNo:self withError:&error];
}
- (BOOL)hc_ValidationForIPAddress
{
    const char *utf8 = [self UTF8String];
    int success;
    
    struct in_addr dst;
    success = inet_pton(AF_INET, utf8, &dst);
    if (success != 1) {
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    return (success == 1 ? TRUE : FALSE);
}

- (BOOL)hc_ValidationForMobileNumber
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";;
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";;
    return [self hc_validationWithPredicate:@[MOBILE,CM,CU,CT]];
}
- (BOOL)hc_ValidationForBankCard
{
    NSString * bankCardStr  = @"^[0-9]{15,19}$";
    return[self hc_validationWithPredicate:bankCardStr];
}
// 验证信用卡
- (BOOL)hc_ValidationForCreditCard
{
    NSString * bankCardStr  = @"^[0-9]{14,16}$";
    return[self hc_validationWithPredicate:bankCardStr];
}

- (BOOL)hc_ValidationForCVV2
{
    NSString * verificationCodeStr  = @"^[0-9]{3}$";
    return [self hc_validationWithPredicate:verificationCodeStr];
}

// 验证验证码
- (BOOL)hc_ValidationForVerificationCodeWithLength:(int)length
{
    NSString * verificationCodeStr  = [NSString stringWithFormat:@"^[0-9]{%d}$",length];
    return [self hc_validationWithPredicate:verificationCodeStr];
}
//邮箱验证
- (BOOL)hc_ValidationForEmail{
    
    NSString *regexEmailStr = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    return [self hc_validationWithPredicate:regexEmailStr];
    
}
- (BOOL)hc_ValidationForUserName{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]+";
    return [self hc_validationWithPredicate:regex];
}

- (BOOL)hc_ValidationForChineseCharacter{
    NSString *regex = @"^[\u4e00-\u9fa5]{1,}$";
    return [self hc_validationWithPredicate:regex];
}

// 验证设置 登录 密码  6-20个字母，数字，符号
- (BOOL)hc_ValidationForSetLoginPW{
    //^[\x21-\x7E]{6,20}$ 也可以
    NSString * regexLoginPWStr = @"^[A-Za-z0-9_-]{6,20}$"; //符号支持_-两种
    return [self hc_validationWithPredicate:regexLoginPWStr];
}

// 验证设置 支付 密码
- (BOOL)hc_ValidationForSetPayPW{
    NSString * regexPWStr = @"^[A-Za-z0-9_-]{6,20}$"; //符号支持_-两种
    return [self hc_validationWithPredicate:regexPWStr];
}


-(BOOL)hc_validationWithPredicate:(id)predicate{
    if ([predicate isKindOfClass:[NSString class]]) {
        NSPredicate * regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicate];
        if (![regextest evaluateWithObject:self]){
            return NO;
        }
    }else if ([predicate isKindOfClass:[NSArray class]]){
        for (NSString *prestr in predicate) {
            NSPredicate * regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",prestr];
            if ([regextest evaluateWithObject:self]){
                return YES;
            }
        }
        return NO;
    }else{
        return NO;
    }
    return YES;
}

@end
