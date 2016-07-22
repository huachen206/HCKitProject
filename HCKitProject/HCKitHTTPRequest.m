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

-(id)handleResponsObject:(id)responsObject{
    NSString *responsString = [[NSString alloc]initWithData:(NSData*)responsObject encoding:4];
    
    return [super handleResponsObject:responsObject];
    
    

    
}

@end
