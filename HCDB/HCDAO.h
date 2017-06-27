//
//  HCDAO.h
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCDBHelper.h"
#import <FMDB/FMDB.h>
#import "HCDBManager.h"
#import "HCDBTable.h"
#import "HCUtilityMacro.h"

@class HCDBTable;
#define HCDBQuickCheck(SomeBool)            \
{                                           \
if (!(SomeBool)) {                      \
DebugAssert(NO, @"Sql Failure");    \
}                                       \
}


#define HCDBQuickCheck(SomeBool)            \
{                                           \
if (!(SomeBool)) {                      \
DebugAssert(NO, @"Sql Failure");    \
}                                       \
}

#define HCDBTransactionSQLCheck(SomeBool, rollBack)             \
{                                                               \
if (!(SomeBool)) {                                          \
DebugAssert(NO, @"Sql Failuer in Transaction");         \
if (rollBack != nil)                                    \
*(rollBack) = YES;                                  \
return;                                                 \
}                                                           \
}

@class HCVersionTable;
@interface HCDAO : NSObject
@property (nonatomic,strong) FMDatabaseQueue *fmDbQueue;
@property (nonatomic,strong) HCDBHelper *baseDBHelper;

@property (nonatomic,strong) HCVersionTable *versionTable;

+(instancetype)dao;
+(instancetype)daoWithDBPath:(NSString *)dbPath;

-(BOOL)open;
-(void)close;
@end
