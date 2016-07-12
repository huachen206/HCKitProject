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
#define DESKEY @"b939d3ff-eebd-4b1c-acea-c7b7"

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

-(id)handleResponsObject:(id)responsObject{
    NSString *responsString = [[NSString alloc]initWithData:(NSData*)responsObject encoding:4];
    NSString *descrypt = [NSString hc_decryptStr:responsString key:DESKEY];
    id result = [descrypt hc_jsonValue];
    return [super handleResponsObject:responsObject];
    
    

    
}

@end
