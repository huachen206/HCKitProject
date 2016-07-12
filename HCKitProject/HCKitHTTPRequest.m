//
//  HCKitHTTPRequest.m
//  HCKitProject
//
//  Created by HuaChen on 16/7/2.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCKitHTTPRequest.h"
#import "HCKitProject.h"
#define RFTPMSBASEURL @""

@implementation HCKitHTTPRequest

+(id _Nonnull)requestWithParameters:(NSDictionary *_Nullable)parameters{
    return [self POST_requestWithUrl:RFTPMSBASEURL parameters:@{@"para":parameters.hc_jsonString}];
}

+(id _Nonnull)requestForCarList{
    NSDictionary *para = @{@"data":@""};
    return [self requestWithParameters:para];
}
+(id _Nonnull)requestForCarBrand{
    //TODO: 正式的时候换成 http://appch.roidmi.com
    return [self POST_requestWithUrl:[@"http://fmtest.mi-ae.cn/" stringByAppendingString:@"info/brand"] parameters:@{}];
}

@end
