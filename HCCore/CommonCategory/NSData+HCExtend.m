//
//  NSData+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/6/24.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSData+HCExtend.h"

@implementation NSData (HCExtend)
@end
@implementation NSData (HCJSON)
-(id)hc_jsonValue{
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) return nil;
    return result;
}
@end

