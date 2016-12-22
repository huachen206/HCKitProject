//
//  HCBaseDBHelper.m
//  WrapperSQL
//
//  Created by 花晨 on 14-7-24.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import "HCDBHelper.h"

@implementation HCDBHelper
+(NSString *)dbPathWithFileName:(NSString *)fileName{
    return [getDocumentPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@.db",@"DBFile",fileName]];
}
+(NSString *)defaultDBPath{
    return [self dbPathWithFileName:@"defaultDB"];
}

-(id)initDefault{
    if (self = [self initWithDbFileName:@"defaultDB"]) {
    }
    return self;
}
-(id)initWithDbPath:(NSString *)dbPath{
    if (self = [super init]) {
        NSString* foldPath = [dbPath stringByDeletingLastPathComponent];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:foldPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:foldPath withIntermediateDirectories:NO attributes:nil error:&error];
            NSAssert(!error, @"无法创建文件夹");
        }
        self.dbPath = dbPath;
    }
    return self;
}

-(id)initWithDbFileName:(NSString *)fileName{
    NSString *docsPath = getDocumentPath();
    if (self = [self initWithDbPath:[docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@.db",@"DBFile",fileName]]]) {
//        NSString *docsPath = getDocumentPath();
//        NSString *dbFolderPath = [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"DBFile"]];
//        NSError *error = nil;
//        if (![[NSFileManager defaultManager] fileExistsAtPath:dbFolderPath]) {
//            [[NSFileManager defaultManager] createDirectoryAtPath:dbFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
//        }
//        self.dbPath = [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@.db",@"DBFile",fileName]];
    }
    return self;
}


- (BOOL)open {
    if (self.isOpened) {
        return YES;
    }
    FMDatabaseQueue *q = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    if (!q) {
        return NO;
    }
    self.fmDbQueue = q;
    NSLog(@"open DB success -----Path:%@",self.dbPath);
    
    BOOL isDBFileExisted = [self isDBFileExisted];
    if (isDBFileExisted) {
        
    }else{
        
    }
    self.isOpened = YES;
    return YES;
}
-(void)close{
    [self.fmDbQueue close];
    self.isOpened = NO;
}

#pragma mark ---

#pragma mark - Aux Methods

- (BOOL)isDBFileExisted {
    return [[NSFileManager defaultManager] fileExistsAtPath:self.dbPath];
}

- (void)removeDBFile {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.dbPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.dbPath error:nil];
    }
}

@end
