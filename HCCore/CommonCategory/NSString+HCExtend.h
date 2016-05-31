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


@end
