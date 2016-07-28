//
//  Table_carModel.m
//  HCDBDemo
//
//  Created by HuaChen on 16/7/28.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "Table_carModel.h"
@implementation Table_carModel
-(Class)tableModelClass{
    return [CarModel class];
}

-(NSArray *)selectWithWheelNumber:(int)wheelNumber{
    __block NSArray *models = nil;
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE deviceId = %@",self.tableName,@(wheelNumber)]];
        models = [self modelListWithFMResultSet:rs];
    }];
    return models;
}

-(NSInteger)tableVersion{
    //默认为1，每次表结构变动且需要数据迁移时，将此值+1；
    return 3;
}

-(BOOL)tableMigrationWithCurrentTableVersion:(NSInteger)currentVersion{
    //此调用在表结构升级之前，version会逐级上升。建议尽量不要删除字段
    if (currentVersion == 2) {
        //do something 比如将数据全部取出
    }else if (currentVersion ==3){
        
        
    }
    return YES;
}

-(BOOL)autoUpgradeTable{
    BOOL success =[super autoUpgradeTable];
    if (success) {
        //此时表已升级为最新，与当前DBModel相匹配。
    }
    return success;
}
@end
