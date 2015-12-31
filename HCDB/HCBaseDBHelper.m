//
//  HCBaseDBHelper.m
//  WrapperSQL
//
//  Created by 花晨 on 14-7-24.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import "HCBaseDBHelper.h"

@implementation HCBaseDBHelper
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
        
        self.dbPath = dbPath;
    }
    return self;
}

-(id)initWithDbFileName:(NSString *)fileName{
    if (self = [super init]) {
        NSString *docsPath = getDocumentPath();
        NSString *dbFolderPath = [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"DBFile"]];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbFolderPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dbFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
        }
        self.dbPath = [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@.db",@"DBFile",fileName]];
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
