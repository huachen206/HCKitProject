//
//  HCBaseDBHelper.h
//  WrapperSQL
//
//  Created by 花晨 on 14-7-24.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
static inline NSString *getDocumentPath()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@interface HCDBHelper : NSObject
@property (nonatomic,strong) NSString *dbPath;/**< db文件所在的完整路劲*/
@property (nonatomic,strong) FMDatabaseQueue *fmDbQueue;
@property(nonatomic, assign)BOOL isOpened;

-(id)initWithDbPath:(NSString *)dbPath;
/**
 *  @param fileName db文件名，不带后缀
 *
 *  @return
 */
-(id)initWithDbFileName:(NSString *)fileName;
/**
 *  根据db文件名，取到默认db文件完整路径
 *
 *  @param fileName db文件名，不带后缀
 *
 *  @return db文件完整路径
 */
+(NSString *)dbPathWithFileName:(NSString *)fileName;
/**
 *  @return 返回一个默认的db文件路径
 */
+(NSString *)defaultDBPath;
-(id)initDefault;

- (BOOL)open;
-(void)close;

@end

