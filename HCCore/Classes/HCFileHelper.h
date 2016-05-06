//
//  HCFileHelper.h
//  HCKitProject
//
//  Created by HuaChen on 16/5/6.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCFileHelper : NSObject
/**
 *  文件路径是否存在
 *
 */
+ (BOOL)isExistAtPath:(NSString *)filePath;
+ (BOOL)createFileAtPath:(NSString *)filePath;
+ (BOOL)createFolderAtPath:(NSString *)folderPath;
+(BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;
+ (NSString *)fileNameAtDirectory:(NSString *)directory;

@end
