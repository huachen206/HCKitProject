//
//  HCDBManager.m
//  WrapperSQL
//
//  Created by 花晨 on 14-7-24.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import "HCDBManager.h"
#import "HCDAO.h"
@implementation HCDBManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static HCDBManager *shared_;
    dispatch_once(&onceToken, ^{
        if (!shared_) {
            shared_ = [[HCDBManager alloc]init];
            shared_.array_dao = [[NSMutableArray alloc] init];
        }
    });
    return shared_;
}

-(void)closeAll{
    for (HCDAO* dao in self.array_dao) {
        [dao.baseDBHelper close];
    }
}

-(HCDAO*)daoWithDBPath:(NSString *)dbPath{
    for (HCDAO* dao in self.array_dao) {
        if ([dao.baseDBHelper.dbPath isEqualToString:dbPath]) {
            return dao;
        }
    }
    return nil;
}
-(void)addDAO:(HCDAO *)dao{
    [self.array_dao addObject:dao];
}
@end
