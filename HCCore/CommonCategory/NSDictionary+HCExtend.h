//
//  NSDictionary+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/6/24.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HCExtend)

@end
@interface NSDictionary (HCJSON)
/**
 *  转换成JSON字符串
 *
 */
- (nullable NSString *)hc_jsonString;
/**
 *  转换成JSONData
 *
 */
- (nullable NSData *)hc_jsonData;

@end
