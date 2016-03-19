//
//  HCDBTableField.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/17.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCPropertyInfo;
@interface HCDBTableField : NSObject
@property (nonatomic,strong,readonly) NSString *columnName;/**<字段名*/
@property (nonatomic,strong,readonly) NSString *dataType;/**<数据类型*/
/**
 *  用于表语句的数据类型 = (primary key)+(autoincrement )+datatype
 */
@property (nonatomic,strong,readonly) NSString *fieldDataType;
@property (nonatomic,assign,readonly,getter=isPrimaryKey) BOOL primaryKey;/**<是否为主键*/
@property (nonatomic,assign,readonly,getter=isAutoIncrement) BOOL autoIncrement;/**<是否自增*/
+(instancetype)tableFieldWithPropertyInfo:(HCPropertyInfo*)pi;
+(NSArray *)tableFieldListWithPropertyInfos:(NSArray*)pinfos;

-(void)changeDataType:(NSString *)dataType;
@end
