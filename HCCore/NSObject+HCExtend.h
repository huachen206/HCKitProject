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
//#import "HCDBTableField.h"
#import "NSObject+HCExtend.h"
#import "NSArray+HCExtend.h"

@interface NSObject (HCExtend)

@end
@interface NSObject (HCRuntime)
+(NSArray *)hc_propertyNameList;/**< 类的属性名称列表*/
-(id)hc_initWithDictionary:(NSDictionary *)dic;/**< 配对数据源字典中的键与model中的属性名，进行赋值*/
+(NSArray *)hc_modelListWithDicArray:(NSArray *)array;/**< 批量生成model*/

-(id)hc_initWithDictionary:(NSDictionary *)dic addOther:(NSDictionary *)ortherDic;

+(NSArray *)hc_propertyInfos;

@end
