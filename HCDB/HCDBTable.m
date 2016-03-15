//
//  HCDBTable.m
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import "HCDBTable.h"

@interface HCDBTable()
@property (nonatomic,strong) NSMutableArray *elements;
@end

@implementation HCDBTable
+(instancetype)table{
    HCDBTable *table = [[self alloc] init];
    table.columns = [NSMutableDictionary dictionaryWithDictionary:[[table tableModelClass] hc_columnAndSqlDataType]];
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

-(id)init{
    if (self = [super init]) {
        self.columns = [[NSMutableDictionary alloc] init];
//        self.elements = [[NSMutableArray alloc] init];
    }
    return self;
}
-(id)initWithDataTypeNames:(NSArray *)dataTypeNames columnNames:(NSArray *)columnNames{
    if (self = [super init]) {
        self.columns = [[NSMutableDictionary alloc] initWithObjects:dataTypeNames forKeys:columnNames];

    }
    return self;
}
-(void)addDataTypeName:(NSString *)dataTypeName columnName:(NSString *)columnName{
    [self.columns setValue:dataTypeName forKey:columnName];
    
//    NSString *tmpStr = [NSString stringWithFormat:@"%@ %@",columnName,dataTypeName];
//    [self.elements addObject:tmpStr];
    
}

-(NSMutableArray *)elements{
    if (!_elements) {
        _elements = [[NSMutableArray alloc] init];
        for (NSString *key in self.columns) {
            NSString *tmpStr = [NSString stringWithFormat:@"%@ %@",key,[self.columns objectForKey:key]];
            [self.elements addObject:tmpStr];
        }
        
    }
    return _elements;
}
-(NSString*)primaryColumnName{
    for (NSString *columnName in self.columns.allKeys) {
        NSString *dataTypeName = [self.columns objectForKey:columnName];
        if ([dataTypeName rangeOfString:@"PRIMARY KEY"].length) {
            return columnName;
        }
    }
    return nil;
}

#pragma mark creat upgrade
-(BOOL)creatOrUpgradeTable{
    __block BOOL flag = NO;
    NSString *creatSql = [self creatString];
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:creatSql];
    }];
    PADBQuickCheck(flag);
    if (flag) {
        flag = [self upgradeTable];
    }
    return flag;
    
}
-(BOOL)upgradeTable{
    __block BOOL flag = YES;
    
    NSArray *adds = [self objectIn:self.columns.allKeys withOut:[self getTableFields]];
    NSArray *drops = [self objectIn:[self getTableFields] withOut:self.columns.allKeys];
    
    [self.fmDbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSString *column in adds) {
            NSString *dataTypeName = self.columns[column];
            NSString *addSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",[self tableName],column,dataTypeName];
            flag = flag&&[db executeUpdate:addSql];
        }
        
        if (drops.count>0) {
            DebugAssert(NO, @"少定义字段");
        }
        
        PADBTransactionSQLCheck(flag,rollback);
        
    }];
    
    return flag;
    
}
#pragma mark read
-(NSArray *)selectAll{
    __block NSMutableArray *models = [NSMutableArray array];
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",self.tableName]];
        while ([rs next]) {
            if (self.tableModelClass) {
                NSObject *model = [[self.tableModelClass alloc] hc_initWithFMResultSet:rs columns:self.columns.allKeys];

                [models addObject:model];
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
-(NSDictionary *)valueAndColumnWithModel:(NSObject *)baseModel{
    NSDictionary *dic = [baseModel hc_propertyNameAndValue];
    
    NSArray *columnNames =self.columns.allKeys;
    
    NSArray *bothNameList = [dic.allKeys hc_objectAlsoIn:columnNames];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSString *columnName in bothNameList) {
        [mdic setObject:[dic objectForKey:columnName] forKey:columnName];
    }
    return mdic;
}
-(NSDictionary *)removePrimaryKey:(NSDictionary *)mdic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    for (NSString *columnName in self.columns.allKeys) {
        NSString *dataTypeName = [self.columns objectForKey:columnName];
        if ([dataTypeName rangeOfString:@"PRIMARY KEY AUTOINCREMENT"].length) {
            [dic removeObjectForKey:columnName];
        }
    }
    return dic;
}

-(BOOL)insertWithModel:(NSObject*)baseModel{
    return [self insertWithModel:baseModel isIgnorePrimaryKey:NO];
}
-(BOOL)insertWithModel:(NSObject*)baseModel isIgnorePrimaryKey:(BOOL)isIgnore{
    __block BOOL flag;
    NSDictionary *mdic;
    if (isIgnore) {
        mdic = [self removePrimaryKey:[self valueAndColumnWithModel:baseModel]];
    }else{
        mdic = [self valueAndColumnWithModel:baseModel];
    }
    NSString *sql = [self createInsertSqlByDictionary:mdic tablename:self.tableName];
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:sql withParameterDictionary:mdic];
    }];
    return flag;
}

-(BOOL)insertOrReplaceWithModel:(NSObject *)baseModel isIgnorePrimaryKey:(BOOL)isIgnore{
    __block BOOL flag;
    NSDictionary *mdic;
    if (isIgnore) {
        mdic = [self removePrimaryKey:[self valueAndColumnWithModel:baseModel]];
    }else{
        mdic = [self valueAndColumnWithModel:baseModel];
    }
    NSString *sql = [self createInsertOrReplaceSqlByDictionary:mdic tablename:self.tableName];
    
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:sql withParameterDictionary:mdic];
    }];
    return flag;
}
-(BOOL)insertOrReplaceWithModel:(NSObject *)baseModel{
    return [self insertOrReplaceWithModel:baseModel isIgnorePrimaryKey:NO];
}

-(BOOL)insertOrReplaceWithModelList:(NSArray *)modelList{
    return [self insertOrReplaceWithModelList:modelList isIgnorePrimaryKey:NO];
}
-(BOOL)insertOrReplaceWithModelList:(NSArray *)modelList  isIgnorePrimaryKey:(BOOL)isIgnore{
    __block BOOL flag = YES;
    [self.fmDbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSObject *model in modelList) {
            NSDictionary *mdic;
            if (isIgnore) {
                mdic = [self removePrimaryKey:[self valueAndColumnWithModel:model]];
            }else{
                mdic = [self valueAndColumnWithModel:model];
            }
            NSString *sql = [self createInsertOrReplaceSqlByDictionary:mdic tablename:self.tableName];
            flag = flag&&[db executeUpdate:sql withParameterDictionary:mdic];
        }
    }];
    return flag;

}

#pragma mark delete
-(BOOL)deleteWithModel:(id)model{
    //以primarykey删除
    if (!self.primaryColumnName) {
        NSAssert(NO, @"没有设置主键，无法删除");
        return NO;
    }
    id value = [model valueForKey:self.primaryColumnName];
    if (!value) {
        NSAssert(NO, @"主键无值，无法删除");
        return NO;
    }
    __block BOOL flag = NO;
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@",[self tableName],self.primaryColumnName,value];
        flag = [db executeUpdate:sqlstr];
        PADBQuickCheck(flag);
    }];
    return flag;
    
}


-(NSArray *)objectIn:(NSArray *)array1 andIn:(NSArray *)array2{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",array2];
    NSArray * filter = [array1 filteredArrayUsingPredicate:filterPredicate];
    return filter;
}


-(NSArray *)objectIn:(NSArray *)array1 withOut:(NSArray *)array2{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",array2];
    NSArray * filter = [array1 filteredArrayUsingPredicate:filterPredicate];
    return filter;
}

-(NSArray *)getTableFields{
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




-(NSString *)creatString{
    NSString *creatTable = @"CREATE TABLE IF NOT EXISTS %@ ()";
    creatTable =[NSString stringWithFormat:creatTable,self.tableName];
    
    return [creatTable stringByReplacingOccurrencesOfString:@"()" withString:[NSString stringWithFormat:@"(%@)",[self holeElementString]]];
}
-(NSString *)createInsertSqlByDictionary:(NSDictionary *)dict tablename:(NSString *)table{
    return [self createSqlStrWithHeadString:@"insert into" Dictionary:dict tablename:table];
}

-(NSString *)createInsertOrReplaceSqlByDictionary:(NSDictionary *)dict tablename:(NSString *)table{
    return [self createSqlStrWithHeadString:@"INSERT OR REPLACE INTO" Dictionary:dict tablename:table];
}
-(NSString *)createSqlStrWithHeadString:(NSString *)headString Dictionary:(NSDictionary *)dict tablename:(NSString *)table{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"%@ %@ (",headString,table] ;
    NSInteger i = 0;
    for (NSString *key in dict.allKeys) {
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendFormat:@"%@",key];
        i++;
    }
    [sql appendString:@") values ("];
    i = 0;
    for (NSString *key in dict.allKeys) {
        if (i>0) {
            [sql appendString:@","];
        }
        [sql appendFormat:@":%@",key];
        i++;
    }
    [sql appendString:@")"];
    return sql;

}

-(NSString *)holeElementString{
    NSString *holeElementString = @"";
    for (NSString *elStr in self.elements) {
        if (holeElementString.length == 0) {
            holeElementString = elStr;
        }else{
            holeElementString = [[holeElementString stringByAppendingString:@","] stringByAppendingString:elStr];
        }
    }
    return holeElementString;
}
-(HCDBHelper *)baseDBHelper{
    return self.DAO.baseDBHelper;
}

-(FMDatabaseQueue*)fmDbQueue{
    return self.DAO.fmDbQueue;
}
-(NSString *)description{
    NSMutableString *text = [[NSMutableString alloc] init];
    for (NSString *key in self.columns) {
        [text appendString:key];
        [text appendString:@","];
    }
    return [NSString stringWithFormat:@"\nTable description----\ntableName:%@\ncolumns:%@\n",self.tableName,text];
}
@end
