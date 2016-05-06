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
    BOOL success;
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
    BOOL success;
    NSError *error;
    [self createFileAtPath:dstPath];
    success = [DefaultManager copyItemAtPath:srcPath toPath:dstPath error:&error];
    if (error) {
        DebugLog(@"%@",error);
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


@end
