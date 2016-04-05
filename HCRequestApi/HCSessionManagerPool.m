//
//  HCSessionManagerPool.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCSessionManagerPool.h"

@interface HCSessionManagerPool()
@property (nonatomic,strong) NSMutableDictionary *pool;
@end
@implementation HCSessionManagerPool
+(instancetype)sessionManagerPool{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _sharedInstance = [[HCSessionManagerPool alloc] init];
    });
    return _sharedInstance;
}
-(NSMutableDictionary *)pool{
    if (!_pool) {
        _pool = [[NSMutableDictionary alloc] init];
    }
    return _pool;
}
+(AFURLSessionManager *)sessionManagerWithKey:(NSString*)key{
    return [HCSessionManagerPool sessionManagerPool].pool[key];
}
+(void)addSessionManager:(AFURLSessionManager *)sessionManager withKey:(NSString *)key{
    [[HCSessionManagerPool sessionManagerPool].pool setObject:sessionManager forKey:key];
}
//+(AFHTTPSessionManager *)pureHttpSessionManager{
//    return [AFHTTPSessionManager manager];
//}
@end
