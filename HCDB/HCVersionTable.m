//
//  HCVersionTable.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/8.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCVersionTable.h"
@implementation HCVersionModel

@end

@implementation HCVersionTable
-(Class)tableModelClass{
    return [HCVersionModel class];
}

-(HCVersionModel *)versionModelWithTableName:(NSString *)tableName{
    __block NSArray *models = nil;
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",self.tableName]];
        models = [self modelListWithFMResultSet:rs];
    }];
    if (models.count) {
        return models[0];
    }else{
        return nil;
    }
}

@end
