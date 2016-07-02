//
//  HCKitHTTPRequest.h
//  HCKitProject
//
//  Created by HuaChen on 16/7/2.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCHTTPRequest.h"

@interface HCKitHTTPRequest : HCHTTPRequest
+(id _Nonnull)requestWithParameters:(NSDictionary *_Nullable)parameters;

+(id _Nonnull)requestForCarList;

@end
