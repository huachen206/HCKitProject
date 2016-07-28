//
//  VehicleModel.m
//  HCDBDemo
//
//  Created by HuaChen on 16/7/28.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "VehicleModel.h"

@implementation VehicleModel


-(BOOL)isFantasy {
    return _fantasy;
}
@end

@implementation CarModel
+(NSInteger)depth{
    return 2;
}


@end
@implementation PlaneModel
+(NSInteger)depth{
    return 2;
}
@end