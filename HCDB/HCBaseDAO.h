//
//  HCBaseDAO.h
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBaseDBHelper.h"
#import "FMDB.h"
#import "HCDBManager.h"
#import "HCBaseTable.h"

@class HCBaseTable;
#define PADBQuickCheck(SomeBool)            \
{                                           \
if (!(SomeBool)) {                      \
DebugAssert(NO, @"Sql Failure");    \
}                                       \
}

#ifdef DEBUG
#define DebugAssert(cnd, prompt)  NSAssert((cnd), (prompt))
#else
#define DebugAssert(cnd, prompt)
#endif

#define PADBQuickCheck(SomeBool)            \
{                                           \
if (!(SomeBool)) {                      \
DebugAssert(NO, @"Sql Failure");    \
}                                       \
}

#define PADBTransactionSQLCheck(SomeBool, rollBack)             \
{                                                               \
if (!(SomeBool)) {                                          \
DebugAssert(NO, @"Sql Failuer in Transaction");         \
if (rollBack != nil)                                    \
*(rollBack) = YES;                                  \
return;                                                 \
}                                                           \
}

@interface HCBaseDAO : NSObject
@property (nonatomic,strong) FMDatabaseQueue *fmDbQueue;
@property (nonatomic,strong) HCBaseDBHelper *baseDBHelper;
+(instancetype)dao;

@end
