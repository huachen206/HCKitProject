//
//  NSObject+HCDBExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/3.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#define VARCHAR(NUM) \
@protocol VARCHAR_##NUM \
@end

#define INTEGER(NUM) \
@protocol INTEGER_##NUM \
@end

#define INTEGER_PRIMARY_KEY_AUTOINCREMENT(NUM) \
@protocol INTEGER##NUM##_PRIMARY_KEY_AUTOINCREMENT \
@end



#define TABLECOL_OBJ(dataType,columnName) columnName;\
@property (nonatomic,strong) HCDBTableFlg dataType columnName##_HCTABLECOL

#define TABLECOL_VAR(dataType,columnName) columnName;\
@property (nonatomic,strong) HCDBTableFlg dataType *columnName##_HCTABLECOL

@class FMResultSet;
@interface NSObject (HCDBExtend)
+ (NSArray *)hc_propertyNameList;/**< 类的属性名称列表*/
+(NSDictionary *)hc_propertyNameAndClassName;/**< 类的属性名称+类型名称 字典*/
/**
 *  取sql数据类型，建表数据需要
 *
 *  @return key：字段名，value：sql数据类型
 */
+(NSDictionary *)hc_columnAndSqlDataType;
- (NSDictionary *)hc_propertyNameAndValue;/**< 实例的属性名称+值 字典*/
-(id)hc_initWithDictionary:(NSDictionary *)dic;/**< 配对数据源字典中的键与model中的属性名，进行赋值*/
-(id)hc_initWithFMResultSet:(FMResultSet *)result;/**< 从数据库的查询结果，初始化model*/
-(id)hc_initWithFMResultSet:(FMResultSet *)result columns:(NSArray *)columns;/**< 从数据库的查询结果，初始化model*/
+(NSArray *)hc_modelListWithDicArray:(NSArray *)array;/**< 批量生成model*/

-(id)hc_initWithDictionary:(NSDictionary *)dic addOther:(NSDictionary *)ortherDic;
@end

@interface NSArray(HCDBExtend)

-(NSArray *)hc_objectAlsoIn:(NSArray *)array;

@end
@interface HCDBTableFlg : NSObject

@end

