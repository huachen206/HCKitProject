//
//  HCHTTPRequest.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCHTTPRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation HCHTTPRequest
+(AFHTTPSessionManager *)httpSessionManager{
    NSString *key = NSStringFromClass([self class]);
    AFHTTPSessionManager *_httpSessionManager =(AFHTTPSessionManager *)[HCSessionManagerPool sessionManagerWithKey:key];
    if (!_httpSessionManager) {
        [HCSessionManagerPool addSessionManager:[AFHTTPSessionManager manager] withKey:key];
    }
    return _httpSessionManager;
}

-(void)requestWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters{
    [[[self class] httpSessionManager] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}



@end
