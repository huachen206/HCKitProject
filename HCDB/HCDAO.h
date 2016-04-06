//
//  HCDAO.h
//  Lottery
//
//  Created by 花晨 on 15/8/29.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCDBHelper.h"
#import "FMDB.h"
#import "HCDBManager.h"
#import "HCDBTable.h"

@class HCDBTable;
#define PADBQuickCheck(SomeBool)            \
{                                           \
if (!(SomeBool)) {                      \
DebugAssert(NO, @"Sql Failure");    \
}                                       \
}

#ifdef DEBUG
#define DebugAssert(cnd, prompt)  NSAssert((cnd), (prompt))
#define DebugLog(format,...) NSLog(format,__VA_ARGS__)
#else
#define DebugAssert(cnd, prompt)
#define DebugLog(format,...)
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

@interface HCDAO : NSObject
@property (nonatomic,strong) FMDatabaseQueue *fmDbQueue;
@property (nonatomic,strong) HCDBHelper *baseDBHelper;
+(instancetype)dao;

@end