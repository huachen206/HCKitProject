//
//  HCHTTPRequest.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCHTTPRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HCUtilityMacro.h"
#import "NSData+HCExtend.h"
//typedef void(^SUCCESSBLOCK)(id responseObject);
//typedef void(^FAILBLOCK)(NSError * _Nonnull error);

@interface HCHTTPRequest(){
//    SUCCESSBLOCK _successBlock;
//    FAILBLOCK _failBlock;
}
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

-(id)handleResponsObject:(id)responseObject{
    DebugLog(@"\n--------------------------------------------------------------\nReceivedData HCHTTPRequest:\n%@\n%@\n--------------------------------------------------------------",self.urlString,responseObject);
    return responseObject;
}

-(id)initWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters withMethod:(NSString *)method{
    if (self == [super init]) {
        self.urlString = urlString;
        self.parameters = parameters;
        self.method = method;
    }
    return self;
}
-(id)success:(void(^)(id responseObject))successBlock{
    return [self success:^(id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(id)success:(void(^)(id responseObject))successBlock failure:(void(^)(NSError * _Nonnull error))failureBlock{
    DebugLog(@"\n--------------------------------------------------------------\nSend HCHTTPRequest:\n%@\n%@\n--------------------------------------------------------------",self.urlString,self.parameters);

    
    if ([self.method isEqualToString:@"POST"]) {
        self.dataTask =[[[self class] httpSessionManager] POST:self.urlString parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock([self handleResponsObject:responseObject]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) {
                failureBlock([self handleResponsObject:error]);
            }
        }];
    }else if([self.method isEqualToString:@"GET"]){
        self.dataTask = [[[self class] httpSessionManager] GET:self.urlString parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock([self handleResponsObject:responseObject]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) {
                failureBlock([self handleResponsObject:error]);
            }
        }];
    }
    return self;
}

-(void)cancel{
    if (self.dataTask) {
        [self.dataTask cancel];
    }
}

-(NSString*)urlString{
    return _urlString;
}
-(NSDictionary*)parameters{
    return _parameters;
}

@end
