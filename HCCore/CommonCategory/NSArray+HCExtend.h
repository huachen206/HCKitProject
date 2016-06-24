
//
//  NSArray+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HCExtend)
/**
 *  对照参数array，筛选出共有的部分
 *
 */
-(nullable NSArray *)hc_objectAlsoIn:(nonnull NSArray *)array;
/**
 *  对照参数array，挑选出不共有的部分
 */
-(nullable NSArray *)hc_objectWithOut:(nonnull NSArray *)array;
/**
 *  遍历数组，并将block中的返回值集合为数组返回
 */
-(nullable NSArray*)hc_map:(_Nullable id(^_Nullable)(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop))usingBlock;

@end
@interface NSArray (HCJSON)
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