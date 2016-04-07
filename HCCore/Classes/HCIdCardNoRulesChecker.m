//
//  HCIdCardNoRulesChecker.m
//
//  Created by 花晨 on 15/11/24.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCIdCardNoRulesChecker.h"

@implementation HCIdCardNoRulesChecker
/*********************************** 身份证验证开始 ****************************************/
/**
 * 身份证号码验证 1、号码的结构 公民身份号码是特征组合码，由十七位数字本体码和一位校验码组成。排列顺序从左至右依次为：六位数字地址码，
 * 八位数字出生日期码，三位数字顺序码和一位数字校验码。 2、地址码(前六位数）
 * 表示编码对象常住户口所在县(市、旗、区)的行政区划代码，按GB/T2260的规定执行。 3、出生日期码（第七位至十四位）
 * 表示编码对象出生的年、月、日，按GB/T7408的规定执行，年、月、日代码之间不用分隔符。 4、顺序码（第十五位至十七位）
 * 表示在同一地址码所标识的区域范围内，对同年、同月、同日出生的人编定的顺序号， 顺序码的奇数分配给男性，偶数分配给女性。 5、校验码（第十八位数）
 * （1）十七位数字本体码加权求和公式 S = Sum(Ai * Wi), i = 0, ... , 16 ，先对前17位数字的权求和
 * Ai:表示第i位置上的身份证号码数字值 Wi:表示第i位置上的加权因子 Wi: 7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2
 * （2）计算模 Y = mod(S, 11) （3）通过模得到对应的校验码 Y: 0 1 2 3 4 5 6 7 8 9 10 校验码: 1 0 X 9 8 7 6 5 4 3 2
 */



+ (BOOL)checkIdCardNo:(NSString *)idCardNo withError:(NSError **)error
{
    
    // ================ 号码的长度 15位或18位 ================

    if (idCardNo.length != 15 && idCardNo.length != 18) {
        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证号码长度应该为15位或18位。"}];
        return NO;
    }
    // =======================(end)========================
    
    // ================ 数字 除最后一位都为数字 ================

    NSArray *ValCodeArr = @[@"1", @"0", @"x", @"9", @"8", @"7", @"6", @"5", @"4",
                            @"3", @"2" ];
    NSArray *Wi = @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7",
        @"9", @"10", @"5", @"8", @"4", @"2" ];
    NSString *Ai = @"";

    if (idCardNo.length == 18) {
        Ai = [idCardNo substringToIndex:17];
    } else if (idCardNo.length == 15) {
        Ai = [[[idCardNo substringToIndex:6] stringByAppendingString:@"19"] stringByAppendingString:[idCardNo substringWithRange:NSMakeRange(6, 9)]];
    }
    
    if (isNumberic(Ai) == false) {
        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证15位号码都应为数字 ; 18位号码除最后一位外，都应为数字。"}];
        return NO;
    }
    // =======================(end)========================
    
    // ================ 出生年月是否有效 ================

    
    NSString *strYear = [Ai substringWithRange:NSMakeRange(6, 4)];// 年份
    NSString *strMonth = [Ai substringWithRange:NSMakeRange(10, 2)];// 月份
    NSString *strDay = [Ai substringWithRange:NSMakeRange(12, 2)];// 月份
    
    if (isDate([NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay]) == false) {
        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证生日无效。"}];
        return NO;
    }
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//
//    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay]];
    
    
    NSDateFormatter *nowYearFormatter = [[NSDateFormatter alloc] init];
    [nowYearFormatter setDateFormat:@"yyyy"];
    NSString *nowYearStr = [nowYearFormatter stringFromDate:[NSDate new]];
    NSInteger nowYear = [nowYearStr integerValue];
    NSInteger oldYear = nowYear-150;
    
    
    
    if ([strYear integerValue]<oldYear||[strYear integerValue]>nowYear) {
        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证生日不在有效范围。"}];
        return NO;
    }
    
    
//    NSDate *oldDate = [NSDate dateWithTimeIntervalSinceNow:-365*24*60*60];
//    if ([date compare:oldDate] == NSOrderedAscending) {
//        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证生日不在有效范围。"}];
//        return NO;
//        
//    }
    
//    if ([date compare:[NSDate new]] == NSOrderedDescending || [date compare:[NSDate dateWithDaysBeforeNow:150*365] ]== NSOrderedAscending) {
//        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证生日不在有效范围。"}];
//        return NO;
//
//    }

    if ([strMonth integerValue]>12||[strMonth integerValue]==0 ){
        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证月份无效."}];
        return NO;
        
    }
    
    if ([strDay integerValue]>31||[strDay integerValue]==0 ){
        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证日期无效."}];
        return NO;
        
    }
    
    // =====================(end)=====================
    
    // ================ 地区码是否有效 ================
    if (!areaCode([Ai substringWithRange:NSMakeRange(0, 2)])) {
        *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证地区编码错误。"}];
        return NO;

    }
    // ==============================================
    
    // ================ 判断最后一位的值 ================
    int totalmulAiWi = 0;
    for (int i = 0; i<17; i++) {
        totalmulAiWi = totalmulAiWi + (int)([[Ai substringWithRange:NSMakeRange(i , 1)] integerValue]*[Wi[i] integerValue]);
    }
    int modValue = totalmulAiWi % 11;

    NSString *strVerifyCode = ValCodeArr[modValue];
    Ai = [Ai stringByAppendingString:strVerifyCode];
    
    if (idCardNo.length == 18) {
        if (!([Ai caseInsensitiveCompare:idCardNo] == NSOrderedSame)) {
            *error = [NSError errorWithDomain:@"pa.idcardValidate" code:1 userInfo:@{NSLocalizedDescriptionKey:@"身份证无效，不是合法的身份证号码"}];
            return NO;
        }
    }
    // =====================(end)=====================

    
    
    
    
    return YES;
}



static inline bool isNumberic(NSString *string){
    NSString * regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}


static inline bool isDate(NSString *string){
    NSString * regex = @"^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-3]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}
/**
 
 * 功能:判断是否在地区码内
 
 * 参数:地区码
 
 */

static inline bool areaCode(NSString *code)

{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
    
}




@end
