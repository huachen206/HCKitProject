//
//  HCFileHelper.m
//  HCKitProject
//
//  Created by HuaChen on 16/5/6.
//  Copyright © 2016年 花晨. All rights reserved.
//
#define DefaultManager [NSFileManager defaultManager]

#import "HCFileHelper.h"
#import "HCUtilityMacro.h"
@implementation HCFileHelper

+ (BOOL)isExistAtPath:(NSString *)filePath {
    return [DefaultManager fileExistsAtPath:filePath];
}

+ (BOOL)createFileAtPath:(NSString *)filePath {
    return [self isExistAtPath:filePath]?YES:[DefaultManager createFileAtPath:filePath contents:nil attributes:nil];
}

+ (BOOL)createFolderAtPath:(NSString *)folderPath {
    BOOL success = NO;
    if (![self isExistAtPath:folderPath]) {
        NSError *error;
        success = [DefaultManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DebugLog(@"%@",error);
        }
    }
    return success;
}

+(BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    BOOL success = NO;
    if ([self createFileAtPath:dstPath]) {
        NSError *error;
        success = [DefaultManager copyItemAtPath:srcPath toPath:dstPath error:&error];
        if (error) {
            DebugLog(@"%@",error);
        }
    }
    return success;
}

+ (void)deleteFolderAtPath:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:folderPath error:nil];
}
+(BOOL)copyFolderAtPath:(NSString *)atPath toPath:(NSString *)toPath{
    BOOL success = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([self createFolderAtPath:toPath]) {
        NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:atPath];
        NSString *path;
        while ((path = [dirEnum nextObject]) != nil) {
            success = success && [fileManager moveItemAtPath:atPath
                        toPath:toPath
                         error:NULL];
        }
        
        if (success) {
            [self deleteFolderAtPath:atPath];
        }else{
            [self deleteFolderAtPath:toPath];
        }
    }
    return success;
}

+ (NSString *)fileNameAtDirectory:(NSString *)directory {
    NSString *resultFileName = @"";
    if (directory.length > 0) {
        NSRange range = [directory rangeOfString:@"/" options:NSBackwardsSearch];
        resultFileName = [directory substringFromIndex:range.location];
    }
    return resultFileName;
}

+(NSString *)documentsPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
+(NSString *)homePath{
    return NSHomeDirectory();

}
+(NSString *)cachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
+(NSString *)tmpPath{
    return NSTemporaryDirectory();
}

@end
