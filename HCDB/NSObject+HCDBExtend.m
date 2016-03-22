//
//  NSObject+HCDBExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/3.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSObject+HCDBExtend.h"
#import "HCDBTableField.h"

@implementation NSObject (HCDBExtend)
+(NSArray *)hc_tableFieldList{
    return [HCDBTableField tableFieldListWithClass:[self class]];
}


@end


