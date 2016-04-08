//
//  HCDAO.m
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import "HCDAO.h"
#import "HCVersionTable.h"
@implementation HCDAO
+(instancetype)dao{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
-(HCVersionTable *)versionTable{
    if (!_versionTable) {
        _versionTable = [HCVersionTable table];
        _versionTable.DAO = self;
        [_versionTable creatTable];
    }
    return _versionTable;
}

-(id)init{
    if (self = [super init]) {
        BOOL flag =[self.baseDBHelper open];
        PADBQuickCheck(flag);
        //versiontable单独初始化
        for (HCPropertyInfo *info in [[self class] hc_propertyInfosWithdepth:2]) {
            if ([info.typeClass isSubclassOfClass:[HCDBTable class]]&&![info.typeClass isSubclassOfClass:[HCVersionTable class]]) {
                HCDBTable *table = [info.typeClass table];
                table.DAO = self;
                [table creatTable];
                HCVersionModel *versionModel = [self.versionTable versionModelWithTableName:[table tableName]];
                if (!versionModel) {
                    versionModel = [[HCVersionModel alloc] init];
                    versionModel.tableName = [table tableName];
                    versionModel.version = table.tableVersion;
                    [self.versionTable insertOrReplaceWithModel:versionModel autoPrimaryKey:NO];
                }else{
                    //版本库记录的表版本低于当前表版本，需要调用数据库迁移方法
                    while (versionModel.version<table.tableVersion) {
                        if ([table tableMigrationWithCurrentTableVersion:versionModel.version]) {
                            ++versionModel.version;
                            [self.versionTable insertOrReplaceWithModel:versionModel autoPrimaryKey:NO];
                        }
                    }
                    //到此处时，若检测到表结构变动，说明没有手动升级表，则会默认自动升级表。
                    if ([table isColumnChanged]) {
                        [table autoUpgradeTable];
                    }
                }
                [self setValue:table forKey:info.propertyName];
            }
        }
    }
    return self;
}

//需要指定sql文件路径时子类重写这个方法。
-(HCDBHelper *)baseDBHelper{
    if (!_baseDBHelper) {
        _baseDBHelper =[[HCDBManager shared] dbHelperWithDbPath:[HCDBHelper defaultDBPath]];
        if (!_baseDBHelper) {
            _baseDBHelper = [[HCDBHelper alloc] initDefault];
            [[HCDBManager shared] addDBHelper:_baseDBHelper];
        }
    }
    return _baseDBHelper;
}

-(FMDatabaseQueue*)fmDbQueue{
    if (!_fmDbQueue) {
        _fmDbQueue = self.baseDBHelper.fmDbQueue;
    }
    return _fmDbQueue;
}

@end
