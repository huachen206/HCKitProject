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

@property (nonatomic,assign,readonly) NSInteger tableVersion;/**< 初始版本为1*/

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
 *  创建表
 *
 */
-(BOOL)creatTable;
/**
 *  自动升级表，会自动增删字段，删掉的字段数据会被丢弃。若要保留，请重载(tableMigrationWithCurrentTableVersion:)方法，并在其中手动迁移数据
 *
 */
-(BOOL)autoUpgradeTable;

/**
 *  取出表中所有数据
 */
-(NSArray *)selectAll;
/**
 *  从数据库查询结果中实例化model
 *
 */
-(NSArray *)modelListWithFMResultSet:(FMResultSet *)rs;

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
/**
 *  表结构更新，数据库迁移，重载此方法。此方法在调用成功后会被继续调用，直到更新到最新的制定版本。
 *
 *  @param currentVersion 数据库中的表版本，请根据这个版本号依次更新版本。
 *
 *  @return 是否更新成功。
 */
-(BOOL)tableMigrationWithCurrentTableVersion:(NSInteger)currentVersion;
/**
 *  检测表字段是否有变动
 *
 */
-(BOOL)isColumnChanged;

@end
