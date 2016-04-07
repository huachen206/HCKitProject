//
//  NSString+HCValidation.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/7.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HCValidation)
/**
 *  验证身份证，详情参考HCIdCardNoRulesChecker
 *
 */
-(BOOL)hc_ValidationForIDCard;
/**
 *  验证IP地址
 *
 */
- (BOOL)hc_ValidationForIPAddress;
/**
 *  验证手机号
 *
 */
- (BOOL)hc_ValidationForMobileNumber;
/**
 *  验证银行卡
 *
 */
- (BOOL)hc_ValidationForBankCard;
/**
 *  验证信用卡
 *
 */
- (BOOL)hc_ValidationForCreditCard;
/**
 *  验证信用卡安全码
 *
 */
- (BOOL)hc_ValidationForCVV2;
/**
 *  验证验证码
 *
 *  @param length 限定长度
 *
 */
- (BOOL)hc_ValidationForVerificationCodeWithLength:(int)length;
/**
 *  验证邮箱
 *
 */
- (BOOL)hc_ValidationForEmail;
/**
 *  验证用户名
 *
 */
- (BOOL)hc_ValidationForUserName;
/**
 *  验证是否为纯汉字
 *
 */
- (BOOL)hc_ValidationForChineseCharacter;
/**
 *  验证登录密码
 *
 */
- (BOOL)hc_ValidationForSetLoginPW;
/**
 *  验证支付密码
 *
 */
- (BOOL)hc_ValidationForSetPayPW;
/**
 *  验证自身
 *
 *  @param predicate 正则
 *
 */
-(BOOL)hc_validationWithPredicate:(id)predicate;
@end
