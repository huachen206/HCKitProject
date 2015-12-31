//
//  HCDBManager.h
//  WrapperSQL
//
//  Created by 花晨 on 14-7-24.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBaseDBHelper.h"
@interface HCDBManager : NSObject
@property (nonatomic,strong) NSMutableArray *arry_dbHelper;

+ (instancetype)shared;
-(void)addDBHelper:(HCBaseDBHelper *)helper;
-(HCBaseDBHelper *)dbHelperWithDbPath:(NSString *)dbPath;
-(void)closeAll;
@end
