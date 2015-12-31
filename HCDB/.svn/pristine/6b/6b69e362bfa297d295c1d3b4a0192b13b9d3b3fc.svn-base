//
//  SQLHelper.h
//  WrapperSQL
//
//  Created by 花晨 on 14-7-18.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLHelper : NSObject
@property (nonatomic,strong) NSMutableArray *types;
@property (nonatomic,strong) NSMutableArray *fields;

@property (nonatomic,strong) NSString *tableName;

@property (nonatomic,strong) NSString *sqlString;
+(SQLHelper *)CreatWithTableName:(NSString *)tableName;
-(void)addType:(NSString *)Type field:(NSString *)field;
-(NSString *)creatString;
-(NSString *)dropTableString;

//-(void)endAddType;

@end
