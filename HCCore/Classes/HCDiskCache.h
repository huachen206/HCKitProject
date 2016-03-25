//
//  HCDiskCache.h
//
//  Created by 花晨 on 14-2-14.
//  Copyright (c) 2014年 平安付. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  可以将对象存入本地磁盘，功能类似于NSUserDefault
 */
@interface HCDiskCache : NSObject<NSCoding>
-(void)addObject:(id)obj key:(NSString *)keyName;
-(id)objectForKey:(NSString *)keyName;
-(void)removeObjectForKey:(NSString *)keyName;

/**
 *  默认路径
 *
 */
+ (instancetype)diskCache;
/**
 *  用户专用路径
 *
 */
+(HCDiskCache *)diskCacheWithUserID:(NSString *)userID;

@end
