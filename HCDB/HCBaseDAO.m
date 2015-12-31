//
//  HCBaseDAO.m
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import "HCBaseDAO.h"

@implementation HCBaseDAO
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
        NSDictionary *nameAndClassNameDic = [[self class] properties_pan];
        for (NSString *propertyName in nameAndClassNameDic.allKeys) {
            NSString *propertyClassName = [nameAndClassNameDic objectForKey:propertyName];
            if (NSClassFromString(propertyClassName)&&[NSClassFromString(propertyClassName) isSubclassOfClass:[HCBaseTable class]]) {
                HCBaseTable *table = [NSClassFromString(propertyClassName) table];
                table.DAO = self;
                [table creatOrUpgradeTable];
                [self setValue:table forKey:propertyName];
            }

        }
    }
    return self;
}

//需要指定sql文件路径时子类重写这个方法。
-(HCBaseDBHelper *)baseDBHelper{
    if (!_baseDBHelper) {
        _baseDBHelper =[[HCDBManager shared] dbHelperWithDbPath:[HCBaseDBHelper defaultDBPath]];
        if (!_baseDBHelper) {
            _baseDBHelper = [[HCBaseDBHelper alloc] initDefault];
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
