//
//  VehicleModel.h
//  HCDBDemo
//
//  Created by HuaChen on 16/7/28.
//  Copyright © 2016年 HuaChen. All rights reserved.
//


#import "HCDBModel.h"

@interface VehicleModel : HCDBModel
@property (nonatomic,assign) NSUInteger HC_PRIMARY_KEY_AUTOINCREMENT(vid);
@property (nonatomic,strong) NSString *scientificName;
@property (nonatomic,strong) NSString *manufacturer;
@property(nonatomic,strong) NSData *attachData;

@property (nonatomic,assign,getter=isFantasy) BOOL fantasy;
@property (nonatomic,assign) float weight;
@property (nonatomic,assign) long maxSpeed;
@property (nonatomic,assign) double displacement;

@property (nonatomic,assign) id HC_IGNORE(driver);
@property (nonatomic,strong) NSObject *HC_IGNORE(forIgnoreExample);

-(BOOL)isFantasy;
@end

@interface CarModel : VehicleModel
@property (nonatomic,assign) int wheelNumber;
+(instancetype)defaultCar;
@end

@interface PlaneModel : VehicleModel
@property (nonatomic,assign) int wingNumber;
@property (nonatomic,assign) float maxHeight;
@end
