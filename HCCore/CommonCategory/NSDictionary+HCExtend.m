//
//  NSDictionary+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/6/24.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSDictionary+HCExtend.h"

@implementation NSDictionary (HCExtend)

@end
@implementation NSDictionary (HCJSON)
- (NSString *)hc_jsonString {
    NSData *data = self.hc_jsonData;
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
- (NSData *)hc_jsonData{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) return nil;
    return result;
}

@end
