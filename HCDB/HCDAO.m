//
//  HCDAO.m
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import "HCDAO.h"

@implementation HCDAO
+(instancetype)dao{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        BOOL flag =[self.baseDBHelper open];
        PADBQuickCheck(flag);
        for (HCPropertyInfo *info in [[self class] hc_propertyInfos]) {
            if ([info.typeClass isSubclassOfClass:[HCDBTable class]]) {
                HCDBTable *table = [info.typeClass table];
                table.DAO = self;
                [table creatOrUpgradeTable];
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
