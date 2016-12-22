//
//  HCDBManager.h
//  WrapperSQL
//
//  Created by 花晨 on 14-7-24.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCDBHelper.h"
@class HCDAO;
@interface HCDBManager : NSObject
@property (nonatomic,strong) NSMutableArray *array_dao;

+ (instancetype)shared;

-(HCDAO*)daoWithDBPath:(NSString *)dbPath;
-(void)addDAO:(HCDAO *)dao;
-(void)closeAll;


@end
