//
//  NSObject+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "HCPropertyInfo.h"
#import "HCIvarInfo.h"
//#import "HCDBTableField.h"
#import "NSObject+HCExtend.h"
#import "NSArray+HCExtend.h"
#import "HCUtilityMacro.h"

@interface NSObject (HCExtend)<NSCoding>

@end
@interface NSObject (HCRuntime)
/**
 *  runtime取类的属性
 *
 *  @return 数组，元素为HCPropertyInfo类型
 */
+(NSArray <HCPropertyInfo *>*)hc_propertyInfos;
+(NSArray <HCPropertyInfo *>*)hc_propertyInfosWithdepth:(NSInteger)depth;
/**
 *  runtime取类的属性名称
 *
 *  @return 数组，元素为NSString类型
 */
+(NSArray *)hc_propertyNameList;
+ (NSArray *)hc_propertyNameListWithdepth:(NSInteger)depth;
/**
 *  runtime取实例的属性
 *
 *  @return 数组，HCIvarInfo类型
 */
-(NSArray *)hc_ivasInfos;

/**
 *  配对数据源字典中的键与model中的属性名，进行赋值
 *
 *  @param dic 键与值，与属性对应
 *
 *  @return 本类的实例
 */
-(id)hc_initWithDictionary:(NSDictionary *)dic;
-(id)hc_initWithDictionary:(NSDictionary *)dic addOther:(NSDictionary *)ortherDic;
/**
 *  上面一个方法的批量方法
 */
+(NSArray *)hc_modelListWithDicArray:(NSArray *)array;

/**
 *  配对数据源字典中的键与model中的属性名，进行赋值
 *
 *  @param dic 键与值，与属性对应
 *  @param keyMay key:属性名，value：数据key
 *
 *  @return 实例
 */
-(id)hc_initWithDictionary:(NSDictionary *)dic withKeyMap:(NSDictionary *)keyMay;
+(NSArray *)hc_modelListWithDicArray:(NSArray *)array withKeyMap:(NSDictionary *)keyMay;

/**
 * 返回属性名，属性类别，值
 *
 */
-(NSString *)hc_description;
/**
 *  debug下打印自身
 *
 */
-(void)hc_debugLog;


@end

@interface NSObject (HCObject)
-(void)hc_setObject:(id)aObject forKey:(NSString *)aKey;
-(id)hc_objectForKey:(NSString *)aKey;
-(void)hc_removeObjectForKey:(NSString *)aKey;
@end

