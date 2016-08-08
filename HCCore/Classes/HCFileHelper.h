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
/**
 *  创建一个文件
 *
 *  @param filePath 文件路径
 *
 *  @return 成功或失败
 */
+ (BOOL)createFileAtPath:(NSString *)filePath;
/**
 *  创建一个文件夹
 *
 *  @param folderPath 文件夹路径
 *
 *  @return 成功或失败
 */
+ (BOOL)createFolderAtPath:(NSString *)folderPath;
/**
 *  将一个文件拷贝到指定路径
 *
 *  @param srcPath 原路径
 *  @param dstPath 目标路径
 *
 *  @return 成功或失败
 */
+(BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;
/**
 *  从一个文件路径中得到文件名
 *
 *  @param directory 文件路径
 *
 *  @return 文件名
 */
+ (NSString *)fileNameAtDirectory:(NSString *)directory;
+(NSString *)documentsPath;/**>documnets路径 */
+(NSString *)homePath;/**>home路径 */
+(NSString *)cachePath;/**>cache路径 */
+(NSString *)tmpPath;/**>tmp路径 */

@end
