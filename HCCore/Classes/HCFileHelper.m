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
@interface HCFileHelper()

@end


@implementation HCFileHelper

+ (BOOL)isExistAtPath:(NSString *)filePath {
    return [DefaultManager fileExistsAtPath:filePath];
}

+ (BOOL)createFileAtPath:(NSString *)filePath {
    return [self isExistAtPath:filePath]?YES:[DefaultManager createFileAtPath:filePath contents:nil attributes:nil];
}

+ (BOOL)createFolderAtPath:(NSString *)folderPath {
    BOOL success = YES;
    if (![self isExistAtPath:folderPath]) {
        NSError *error;
        success = success && [DefaultManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DebugLog(@"%@",error);
        }
    }
    return success;
}

+(BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    BOOL success = NO;
    NSError *error;
    success = [DefaultManager copyItemAtPath:srcPath toPath:dstPath error:&error];
    if (error) {
        DebugLog(@"%@",error);
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
            NSString *orignPath = [atPath stringByAppendingPathComponent:path];
            NSString *tagPath = [toPath stringByAppendingPathComponent:path];
            if ([path containsString:@"."]) {
                [fileManager copyItemAtPath:orignPath toPath:tagPath error:nil];
            }else{
                [self copyFolderAtPath:orignPath toPath:tagPath];
            }
        }
        if (!success) {
            [self deleteFolderAtPath:toPath];
            DebugLog(@"copy Folder Fail");
        }
    }
    return success;
}
+ (NSString *)fileNameAtDirectory:(NSString *)directory {
    NSString *resultFileName = @"";
    if (directory.length > 0) {
        NSRange range = [directory rangeOfString:@"/" options:NSBackwardsSearch];
        resultFileName = [directory substringFromIndex:range.location+1];
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
