//
//  DAO.m
//  HCDBDemo
//
//  Created by HuaChen on 16/7/28.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "DAO.h"

@implementation DAO
@synthesize baseDBHelper = _baseDBHelper;

-(HCDBHelper *)baseDBHelper{
    NSString *dbFileName = @"VehicleDBFile";
    NSString *dbPath =[HCDBHelper dbPathWithFileName:dbFileName];
    _baseDBHelper =[[HCDBManager shared] dbHelperWithDbPath:dbPath];
    if (!_baseDBHelper) {
        _baseDBHelper = [[HCDBHelper alloc] initWithDbFileName:dbFileName];
        [[HCDBManager shared] addDBHelper:_baseDBHelper];
    }
    return _baseDBHelper;
}

@end
