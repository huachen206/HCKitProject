//
//  HCDBTable.h
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HCDBExtend.h"
#import "HCDAO.h"
#import "HCDBModel.h"

@class HCDAO;
@interface HCDBTable : NSObject /**< 表信息*/
@property (nonatomic,strong) NSString *tableName;
@property (nonatomic,strong) FMDatabaseQueue *fmDbQueue;
@property (nonatomic,strong) HCDBHelper *baseDBHelper;
@property (nonatomic,weak) HCDAO *DAO;
@property (nonatomic,strong) Class tableModelClass;


@property (nonatomic,strong) NSArray *fieldList;

/**
 *  eg:
 *
 *  -(Class)tableModelClass{
 *      return [HCTestDBModel class];
 *  }
 *
 */
+(instancetype)table;
/**
 *  如果没有表则建表。如果检测到数据模型中的字段名多于现有表，则更新表；若少于，则报错。
 */
-(BOOL)creatOrUpgradeTable;
/**
 *  取出表中所有数据
 */
-(NSArray *)selectAll;
/**
 *  @return 返回表中记录的数据个数
 */
-(NSInteger)countOfRecord;
/**
 *  根据实际MODEL删除数据
 */
-(BOOL)deleteWithModel:(id)model;

/**
 *  插入或替换数据
 *  @param isAuto  YES：主键自增，主键值不会插入；NO：主键有值，会根据逐渐插入或替换
 *  @return 是否成功
 */
-(BOOL)insertOrReplaceWithModel:(HCDBModel *)DBModel autoPrimaryKey:(BOOL)isAuto;
/**
 *  插入或替换数据
 *  @param isAuto  YES：主键自增，主键值不会插入；NO：主键有值，会根据逐渐插入或替换
 *  @return 是否成功
 */
-(BOOL)insertWithModel:(HCDBModel*)DBModel autoPrimaryKey:(BOOL)isAuto;
/**
 *  插入或替换数据
 *  @param isAuto  YES：主键自增，主键值不会插入；NO：主键有值，会根据逐渐插入或替换
 *  @return 是否成功
 */
-(BOOL)insertOrReplaceWithModelList:(NSArray *)modelList autoPrimaryKey:(BOOL)isAuto;

@end
