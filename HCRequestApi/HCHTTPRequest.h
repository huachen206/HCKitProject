//
//  HCHTTPRequest.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;
@interface HCHTTPRequest : NSObject
@property (nonatomic,strong) NSDictionary *_Nullable headers;
@property (nonatomic,copy) NSString *_Nonnull urlString;
@property (nonatomic,strong) NSDictionary *_Nullable parameters;

/**
 *  子类通过重写此静态方法来配置HTTPSessionManager。
 *
 */
+( AFHTTPSessionManager * _Nonnull )designatHTTPSessionManager;
/**
 * 将所有的请求以及回调取消
 */
+(void)cancelAll;
/**
 *  注意看，配置中是否配置了baseurl
 *
 */

+(id _Nonnull)POST_requestWithUrl:(NSString *_Nullable)urlString parameters:(NSDictionary *_Nullable)parameters;
+(id _Nonnull)GET_requestWithUrl:(NSString *_Nullable)urlString parameters:(NSDictionary *_Nullable)parameters;
/**
 *  重载这个方法以统一处理返回数据
 *
 */
-(id _Nonnull)handleResponsObject:(id _Nullable)responseObject;

-(id _Nonnull)success:(void(^_Nullable)(id _Nullable responseObject))successBlock;
-(id _Nonnull)success:(void(^_Nullable)(id _Nullable responseObject))successBlock failure:(void(^_Nullable)(NSError * _Nonnull error))failureBlock;
-(void)cancel;

@end
