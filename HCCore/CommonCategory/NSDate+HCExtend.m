//
//  NSDate+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/5/28.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSDate+HCExtend.h"

@implementation NSDate (HCExtend)
+ (NSMutableDictionary *)DateFromatterDic{
    static dispatch_once_t onceToken;
    static NSMutableDictionary *dic;
    dispatch_once(&onceToken, ^{
        dic = [[NSMutableDictionary alloc] init];
    });
    return dic;
}

+ (NSTimeZone *)UTCTimeZone
{
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    return utcTimeZone;
}

+(NSDateFormatter *)hc_dateFormatterWithFormatString:(NSString *)aformat{
    NSDateFormatter *formatter = [[self DateFromatterDic] objectForKey:aformat];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:aformat];
        [[self DateFromatterDic] setObject:formatter forKey:aformat];
    }
    return formatter;
}

- (NSString *)hc_stringFromFormat:(NSString *)aformat timeZone:(NSTimeZone *)zone
{
    NSDateFormatter *formatter = [[self class] hc_dateFormatterWithFormatString:aformat];
    if (nil != zone) {
        [formatter setTimeZone:zone];
    }
    NSString *text = [formatter stringFromDate:self];
    return text;
}


-(NSString *)hc_stringFromFormat:(NSString *)aformat{
    return [[[self class] hc_dateFormatterWithFormatString:aformat] stringFromDate:self];
}
+(NSDate*)hc_dateFromString:(NSString *)dateString formFormat:(NSString *)aformat{
    return [[[self class] hc_dateFormatterWithFormatString:aformat] dateFromString:dateString];
}

@end
