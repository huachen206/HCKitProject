//
//  NSString+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/25.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

//检测字符串是否为空|null|nil
#define HCIsEmptyString(a) (a==nil || [a isKindOfClass:[NSNull class]] || a.length==0)
//字符串是否一样，“”=nil=null
#define HCIsSameString(a,b) ( (HCIsEmptyString(a)&&HCIsEmptyString(b)) || [a HCIsEmptyString:b] )

@interface NSString (HCExtend)
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

/**
 *  base64编码转换
 *
 */
-(NSString *)hc_base64EncodedString;
/**
 *  将一个十六进制整数字符，转换成无符号长整型
 *
 */
-(unsigned long)hc_hexValue;
/**
 *  将一个无符号长整型，转换成字符串
 *
 */
extern NSString *NSStringOfHexFromValue(unsigned long value);

@end

@interface NSString (HCJSON)
/**
 *  转换出JOSN对象
 *
 */
- (id )hc_jsonValue;
@end
