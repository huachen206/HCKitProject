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

@class HCDAO;
@interface HCDBTable : NSObject /**< 表信息*/
@property (nonatomic,strong) NSString *tableName;
//@property (nonatomic,strong) NSMutableArray *dataTypeNames;/**< 数据类型*/
//@property (nonatomic,strong) NSMutableArray *columnNames;/**< 列名*/
@property (nonatomic,strong) FMDatabaseQueue *fmDbQueue;
@property (nonatomic,strong) HCDBHelper *baseDBHelper;
@property (nonatomic,weak) HCDAO *DAO;
@property (nonatomic,strong) Class tableModelClass;

@property (nonatomic,strong) NSMutableDictionary *columns;/**< key:列名同属性名；value 属性名*/


/**
 *  eg:
 *  +(instancetype)table{
 *      HCTestTable *table = [[self alloc] init];
 *      [table adddataTypeName:@"INTEGER PRIMARY KEY AUTOINCREMENT" columnName:@"testId"];
 *      [table adddataTypeName:@"VARCHAR(20)" columnName:@"name"];
 *      return table;
 *   }
 *
 *  -(Class)tableModelClass{
 *      return [HCTestDBModel class];
 *  }
 *
 */
+(instancetype)table;
/**
 *
 *
 *  @param dataTypeNames   数据类型
 *  @param columnNames 列名
 *
 *  @return self
 */
-(id)initWithDataTypeNames:(NSArray *)dataTypeNames columnNames:(NSArray *)columnNames;

-(void)addDataTypeName:(NSString *)dataTypeName columnName:(NSString *)columnName;
-(NSString*)primaryColumnName;


-(BOOL)creatOrUpgradeTable;
-(NSArray *)selectAll;
-(NSInteger)countOfRecord;
-(BOOL)insertWithModel:(NSObject*)baseModel;
-(BOOL)insertWithModel:(NSObject*)baseModel isIgnorePrimaryKey:(BOOL)isIgnore;/**< 主键自增时用此方法*/
-(BOOL)insertOrReplaceWithModel:(NSObject *)baseModel;
-(BOOL)insertOrReplaceWithModel:(NSObject *)baseModel isIgnorePrimaryKey:(BOOL)isIgnore;/**< 主键自增时用此方法*/
-(BOOL)insertOrReplaceWithModelList:(NSArray *)modelList;
-(BOOL)insertOrReplaceWithModelList:(NSArray *)modelList  isIgnorePrimaryKey:(BOOL)isIgnore;/**< 主键自增时用此方法*/
-(BOOL)deleteWithModel:(id)model;

@end
