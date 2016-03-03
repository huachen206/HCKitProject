//
//  HCDBManager.m
//  WrapperSQL
//
//  Created by 花晨 on 14-7-24.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import "HCDBManager.h"
@implementation HCDBManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static HCDBManager *shared_;
    dispatch_once(&onceToken, ^{
        if (!shared_) {
            shared_ = [[HCDBManager alloc]init];
            shared_.arry_dbHelper = [[NSMutableArray alloc] init];
        }
    });
    
    return shared_;
}

-(void)closeAll{
    for (HCDBHelper *dbhelper in self.arry_dbHelper) {
        [dbhelper close];
    }
}

-(void)addDBHelper:(HCDBHelper *)helper{
    [self.arry_dbHelper addObject:helper];
}

-(HCDBHelper *)dbHelperWithDbPath:(NSString *)dbPath{
    for (HCDBHelper *helper in self.arry_dbHelper) {
        if ([helper.dbPath isEqualToString:dbPath]) {
            return helper;
        }
    }
    return nil;
}
@end
