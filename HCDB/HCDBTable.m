//
//  HCDBTable.m
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import "HCDBTable.h"
#import "HCDBModel.h"

@interface HCDBTable()
@property (nonatomic,strong) NSArray *tableColumnNameList;
@end

@implementation HCDBTable
+(instancetype)table{
    HCDBTable *table = [[self alloc] init];
    table.fieldList = [[table tableModelClass] hc_tableFieldList];
    
    return table;
}

//重写此方法可重命名表名
-(NSString*)tableName{
    return NSStringFromClass([self class]);
}

-(Class)tableModelClass{
    NSAssert(NO, @"override me");
    return nil;
}


-(NSArray *)tableColumnNameList{
    if (!_tableColumnNameList) {
        _tableColumnNameList = [self.fieldList hc_enumerateObjectsForArrayUsingBlock:^id _Nullable(HCDBTableField *field, NSUInteger idx, BOOL * _Nonnull stop) {
            return field.columnName;
        }];
    }
    return _tableColumnNameList;
}
-(HCDBTableField *)tableFieldForColumn:(NSString *)columnName{
    __block HCDBTableField *tableField = nil;
    [self.fieldList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HCDBTableField *field = (HCDBTableField *)obj;
        if ([field.columnName isEqualToString:columnName]) {
            tableField = field;
        }
    }];
    return tableField;
}

-(HCDBTableField *)primaryTableField{
    __block HCDBTableField *tableField = nil;
    [self.fieldList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HCDBTableField *field = (HCDBTableField *)obj;
        if (field.isPrimaryKey) {
            tableField = field;
        }
    }];
    return tableField;

}

#pragma mark creat upgrade
-(BOOL)creatOrUpgradeTable{
    __block BOOL flag = NO;
    NSString *creatTableSqlStr = [self sqlStrForCreatTable];
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:creatTableSqlStr];
    }];
    PADBQuickCheck(flag);
    if (flag) {
        flag = [self upgradeTable];
    }
    return flag;
}
-(BOOL)upgradeTable{
    __block BOOL flag = YES;
    
    NSArray *adds = [[self tableColumnNameList] hc_objectWithOut:[self tableFieldsFromDB]];
    
    NSArray *drops = [[self tableFieldsFromDB] hc_objectWithOut:[self tableColumnNameList]];
    if (!adds.count) {
        return YES;
    }
    [self.fmDbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSString *column in adds) {
            HCDBTableField *field = [self tableFieldForColumn:column];
            NSString *addSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",[self tableName],field.columnName,field.dataType];
            flag = flag&&[db executeUpdate:addSql];
        }
        if (flag) {
            DebugLog(@"add COLUMN SUCCESS:%@",adds);
        }
        if (drops.count>0) {
            DebugAssert(NO, @"少定义字段");
        }
        PADBTransactionSQLCheck(flag,rollback);
        
    }];
    return flag;
    
}
-(NSString *)sqlStrForCreatTable{
    NSArray *tmps = [self.fieldList hc_enumerateObjectsForArrayUsingBlock:^id _Nullable(HCDBTableField *field, NSUInteger idx, BOOL * _Nonnull stop) {
        return [NSString stringWithFormat:@"%@ %@",field.columnName,field.fieldDataType];
    }];
    return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",self.tableName,[tmps componentsJoinedByString:@","]];
}

#pragma mark read
-(NSArray *)selectAll{
    __block NSMutableArray *models = [NSMutableArray array];
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",self.tableName]];
        while ([rs next]) {
            if (self.tableModelClass) {
                NSObject *model = nil;
                if ([self.tableModelClass isSubclassOfClass:[HCDBModel class]]) {
                    model = [[self.tableModelClass alloc] initWithFMResultSet:rs tableFields:self.fieldList];
                    [models addObject:model];
                }
            }
        }
        [rs close];
    }];
    return models;
}

-(NSInteger)countOfRecord{
    __block NSInteger count;
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT count(*) FROM %@",self.tableName]];
        if (results == nil)
        {
            count = -1;
        }
        else if ([results next])
        {
            if (sizeof(NSInteger) == sizeof(long))
            {
                count = [results longForColumnIndex:0];
            }
            else
            {
                count = [results intForColumnIndex:0];
            }
        }
        else
        {
            count = 0;
        }
        [results close];
    }];
    return count;
}

#pragma mark insert or replace
-(NSDictionary *)valueAndColumnListWithModel:(HCDBModel*)dbModel containPrimary:(BOOL)containPrimary{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
    [self.fieldList enumerateObjectsUsingBlock:^(HCDBTableField* field, NSUInteger idx, BOOL * _Nonnull stop) {
        if (field.isPrimaryKey && !containPrimary) {
        }else{
            NSString *key = field.columnName;
            id value =[dbModel valueForKey:key];
            if (value) {
                [mdic setObject:value forKey:key];
            }
        }
    }];
    return mdic;
}
-(NSString *)sqlWithAction:(NSString *)actionStr{
    return [NSString stringWithFormat:@"%@ %@ (%@) values (:%@)",actionStr,self.tableName,[self.tableColumnNameList componentsJoinedByString:@","],[self.tableColumnNameList componentsJoinedByString:@",:"]];
}

-(BOOL)insertWithModel:(HCDBModel*)DBModel autoPrimaryKey:(BOOL)isAuto{
    __block BOOL flag;
    NSDictionary *mdic = [self valueAndColumnListWithModel:DBModel containPrimary:!isAuto];
    NSString *sql = [self createInsertSqlByDictionary:mdic tablename:self.tableName];
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:sql withParameterDictionary:mdic];
    }];
    return flag;
}
-(BOOL)insertOrReplaceWithModel:(HCDBModel *)DBModel autoPrimaryKey:(BOOL)isAuto{
    __block BOOL flag;
    NSDictionary *mdic = [self valueAndColumnListWithModel:DBModel containPrimary:!isAuto];
    NSString *sql = [self createInsertOrReplaceSqlByDictionary:mdic tablename:self.tableName];
    
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:sql withParameterDictionary:mdic];
    }];
    return flag;
}

-(BOOL)insertOrReplaceWithModelList:(NSArray *)modelList autoPrimaryKey:(BOOL)isAuto{
    __block BOOL flag = YES;
    [self.fmDbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (HCDBModel *DBModel in modelList) {
            NSDictionary *mdic = [self valueAndColumnListWithModel:DBModel containPrimary:!isAuto];
            NSString *sql = [self createInsertOrReplaceSqlByDictionary:mdic tablename:self.tableName];
            flag = flag&&[db executeUpdate:sql withParameterDictionary:mdic];
        }
    }];
    return flag;

}

#pragma mark delete
-(BOOL)deleteWithModel:(id)model{
    //以primarykey删除
    if (![self primaryTableField]) {
        NSAssert(NO, @"没有设置主键，无法删除");
        return NO;
    }
    NSString *primaryKey = [self primaryTableField].columnName;
    id value = [model valueForKey:primaryKey];
    if (!value) {
        NSAssert(NO, @"主键无值，无法删除");
        return NO;
    }
    __block BOOL flag = NO;
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@",[self tableName],primaryKey,value];
        flag = [db executeUpdate:sqlstr];
        PADBQuickCheck(flag);
    }];
    return flag;
}



-(NSArray *)tableFieldsFromDB{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ limit 1",self.tableName];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        for (int i = 0; i<rs.columnCount; i++) {
            [array addObject:[rs columnNameForIndex:i]];
        }
        [rs close];
    }];
    return array;
}


-(NSString *)createInsertSqlByDictionary:(NSDictionary *)dict tablename:(NSString *)table{
    return [self createSqlStrWithHeadString:@"insert into" Dictionary:dict tablename:table];
}

-(NSString *)createInsertOrReplaceSqlByDictionary:(NSDictionary *)dict tablename:(NSString *)table{
    return [self createSqlStrWithHeadString:@"INSERT OR REPLACE INTO" Dictionary:dict tablename:table];
}

-(NSString *)createSqlStrWithHeadString:(NSString *)headString Dictionary:(NSDictionary *)dict tablename:(NSString *)table{
    return [NSString stringWithFormat:@"%@ %@ (%@) values (:%@)",headString,table,[dict.allKeys componentsJoinedByString:@","],[dict.allKeys componentsJoinedByString:@",:"]];
}

-(HCDBHelper *)baseDBHelper{
    return self.DAO.baseDBHelper;
}

-(FMDatabaseQueue*)fmDbQueue{
    return self.DAO.fmDbQueue;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"-------------------\nTable Name:%@\nfield list:%@\nrecord count:%ld\n-------------------",self.tableName,[[self tableColumnNameList] componentsJoinedByString:@","],[self countOfRecord]];
}
@end
