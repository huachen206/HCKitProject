//
//  NSString+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/25.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HCExtend)
/**
 *  检测是否为nil，null，或长度为0
 *
 */
-(BOOL)hc_isEmpty;
/**
 *  检测两个字符串是否相同
 *
 */
-(BOOL)hc_isSame:(NSString *)str;
/**
 *  取文件的md5
 *
 */
+(NSString*)hc_MD5WithFilePath:(NSString*)path;
/**
 *  取字符串的md5
 *
 */
-(NSString*)hc_MD5;
/**
 *  取字符串中的数字
 *
 */
-(NSString*)hc_subStringOfNumber;
/**
 *  中文转为拼音
 *
 */
-(NSString *)hc_toPinyin;
/**
 *  首字母匹配
 *
 */
- (BOOL)hc_isMatchedForSearchText:(NSString *)searchText;

- (NSString *)hc_urldecodedValue;
- (NSString *)hc_urlencodedValue;


@end
