//
//  NSString+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/25.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSString+HCExtend.h"

@implementation NSString (HCExtend)
-(BOOL)isEmpty{
    NSString *string = self;
    return (string==nil || [string isKindOfClass:[NSNull class]] || string.length==0);
}
@end
