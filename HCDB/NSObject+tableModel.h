//
//  NSObject+tableModel.h
//  KTVGroupBuy
//
//  Created by 花晨 on 15/8/31.
//  Copyright (c) 2015年 HuaChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"
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
@property (nonatomic,strong) HCTableFlg dataType columnName##TABLECOL

#define TABLECOL_VAR(dataType,columnName) columnName;\
@property (nonatomic,strong) HCTableFlg dataType *columnName##TABLECOL

@interface NSObject (tableModel)<NSCoding>
+ (NSArray *)properties;/**< 类的属性名称列表*/
+(NSArray*)propertieClassNames;/**< 类的属性类型名称列表*/
+(NSDictionary *)properties_pan;/**< 类的属性名称+类型 字典*/
- (NSDictionary *)properties_aps;/**< 实例的属性名称+值 字典*/
-(id)initWithDictionary:(NSDictionary *)dic;/**< 配对数据源字典中的键与model中的属性名，进行赋值*/
-(id)initWithFMResultSet:(FMResultSet *)result;/**< 从数据库的查询结果，初始化model*/
-(id)initWithFMResultSet:(FMResultSet *)result columns:(NSArray *)columns;/**< 从数据库的查询结果，初始化model*/
+(NSArray *)modelListWithDicArray:(NSArray *)array;/**< 批量生成model*/

-(id)initWithDictionary:(NSDictionary *)dic addOther:(NSDictionary *)ortherDic;

@end
