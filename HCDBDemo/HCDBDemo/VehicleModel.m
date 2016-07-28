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

+(instancetype)defaultCar{
    CarModel *car = [[CarModel alloc] init];
    car.scientificName = @"卡车";
    car.manufacturer = @"福特";
    car.attachData = [@"this a test cat data" dataUsingEncoding:NSUTF8StringEncoding];
    car.fantasy = NO;
    car.weight = 500;
    car.maxSpeed = 160;
    car.displacement = 3.8;
    car.driver = @"hh";
    car.forIgnoreExample = [[NSObject alloc] init];
    car.wheelNumber = 8;
    return car;
}
@end
@implementation PlaneModel
+(NSInteger)depth{
    return 2;
}
@end