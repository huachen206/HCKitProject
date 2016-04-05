//
//  HCSessionManagerPool.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface HCSessionManagerPool : NSObject
+(AFURLSessionManager *)sessionManagerWithKey:(NSString*)key;
+(void)addSessionManager:(AFURLSessionManager *)sessionManager withKey:(NSString *)key;

@end
