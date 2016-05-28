//
//  NSDate+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/5/28.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
//NSString * const kDateFormat_yyyyMMddHHmmss = @"yyyy-MM-dd HH:mm:ss";
//NSString * const kDateFormat_yyyyMMddHHmm = @"yyyy-MM-dd HH:mm";
//NSString * const kDateFormat_HHmm = @"HH:mm";

@interface NSDate (HCExtend)
/**
 *  从NSDate输出格式化日期字符串
 *
 *  @param aformat 格式字符
 *
 *  @return 日期字符串
 */
-(NSString *)hc_stringFromFormat:(NSString *)aformat;
/**
 *  从字符串中去的NSDate
 *
 *  @param dateString 日期字符串
 *  @param aformat    格式字符
 *
 *  @return 日期NSDate
 */
+(NSDate*)hc_dateFromString:(NSString *)dateString formFormat:(NSString *)aformat;
/**
 *  取得格式化实例
 *
 *  @param aformat 格式字符
 *
 */
+(NSDateFormatter *)hc_dateFormatterWithFormatString:(NSString *)aformat;
/**
 *  根据时区转化时间至指定格式
 *
 *  @param aformat 格式化字符
 *  @param zone    设置时区
 *
 */
- (NSString *)hc_stringFromFormat:(NSString *)aformat timeZone:(NSTimeZone *)zone;
/**
 *  UTC +00:00 校准的全球时间
 */
+ (NSTimeZone *)UTCTimeZone;
@end
