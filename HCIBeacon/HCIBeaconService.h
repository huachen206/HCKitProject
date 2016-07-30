//
//  HCIBeaconService.h
//  RFTPMS
//
//  Created by HuaChen on 16/7/29.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@class HCIBeaconService;
@protocol HCIBeaconServiceDelegate <NSObject>
-(void)IBeaconService:(HCIBeaconService *)service didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end
@interface HCIBeaconService : NSObject<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *beaconRegionList;
@property (strong, nonatomic) id<HCIBeaconServiceDelegate> delegate;

/**
 *  默认为 NO. 如果设为 YES，则会在后台持续开启GPS定位，以获得持续接受IBeacon数据的能力，比较耗电。
 */
@property (assign, nonatomic) BOOL allowsBackgroundLocationUpdates;
-(void)addBeaconRegion:(CLBeaconRegion *)beaconRegion;
-(void)addBeaconRegionWithUUID:(NSUUID*)uuid;
-(void)addBeaconRegionWithUUIDString:(NSString*)uuidString;
-(void)startRanging;
-(void)stopRanging;

@end

