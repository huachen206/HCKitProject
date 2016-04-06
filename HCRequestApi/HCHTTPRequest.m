//
//  HCHTTPRequest.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCHTTPRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface HCHTTPRequest()
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,strong) NSDictionary *parameters;

@property (nonatomic,strong) NSURLSessionDataTask *dataTask;
@property (nonatomic,copy) NSString *method;

@end

@implementation HCHTTPRequest
+(instancetype)managerPool{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _sharedInstance = [[NSMutableDictionary alloc] init];
    });
    return _sharedInstance;
}

+(AFHTTPSessionManager *)httpSessionManager{
    NSString *key = NSStringFromClass([self class]);
    AFHTTPSessionManager *_httpSessionManager =(AFHTTPSessionManager *)[self managerPool][key];
    if (!_httpSessionManager) {
        _httpSessionManager =[self designatHTTPSessionManager];
        [[self managerPool] setObject:_httpSessionManager forKey:key];
    }
    return _httpSessionManager;
}

+(AFHTTPSessionManager *)designatHTTPSessionManager{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager.requestSerializer setTimeoutInterval:20];//请求超时时间20s
    return sessionManager;
}

+(void)cancelAll{
    for (NSURLSessionTask *task in [[self class] httpSessionManager].tasks) {
        [task cancel];
    }
    [[[self class] httpSessionManager].operationQueue cancelAllOperations];
}

+(id)POST_requestWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters{
    return [[self alloc] initWithUrl:urlString parameters:parameters withMethod:@"POST"];
}
+(id)GET_requestWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters{
    return [[self alloc] initWithUrl:urlString parameters:parameters withMethod:@"GET"];
}
+(void)handleWithResponsObject:(id )responsObject success:(void(^)(id responseObject))successBlock failure:(void(^)(NSError * _Nonnull error))failureBlock{
    if ([responsObject isKindOfClass:[NSError class]]) {
        if (failureBlock) {
            failureBlock(responsObject);
        }
    }else{
        if (successBlock) {
            successBlock(responsObject);
        }
    }
}

-(id)initWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters withMethod:(NSString *)method{
    if (self == [super init]) {
        self.urlString = urlString;
        self.parameters = parameters;
        self.method = method;
    }
    return self;
}
-(void)success:(void(^)(id responseObject))successBlock{
    [self success:^(id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)success:(void(^)(id responseObject))successBlock failure:(void(^)(NSError * _Nonnull error))failureBlock{
    if ([self.method isEqualToString:@"POST"]) {
        self.dataTask =[[[self class] httpSessionManager] POST:self.urlString parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[self class] handleWithResponsObject:responseObject success:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self class] handleWithResponsObject:error success:nil failure:failureBlock];
        }];
    }else if([self.method isEqualToString:@"GET"]){
        self.dataTask = [[[self class] httpSessionManager] GET:self.urlString parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[self class] handleWithResponsObject:responseObject success:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self class] handleWithResponsObject:error success:nil failure:failureBlock];
        }];
    }
}

-(void)cancel{
    if (self.dataTask) {
        [self.dataTask cancel];
    }
}

@end
