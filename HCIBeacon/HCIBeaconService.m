//
//  HCIBeaconService.m
//  RFTPMS
//
//  Created by HuaChen on 16/7/29.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "HCIBeaconService.h"


@interface HCIBeaconService ()
@end

@implementation HCIBeaconService

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    return _locationManager;
}

-(void)setAllowsBackgroundLocationUpdates:(BOOL)allowsBackgroundLocationUpdates{
    if (allowsBackgroundLocationUpdates) {
        [self.locationManager startUpdatingLocation];
    }else{
        [self.locationManager stopUpdatingHeading];
    }
}

-(CLBeaconRegion*)beaconRegion{
    NSUUID *uuid = nil;
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    beaconRegion.notifyEntryStateOnDisplay =YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    return beaconRegion;
}

-(NSMutableArray *)beaconRegionList{
    if (!_beaconRegionList) {
        _beaconRegionList = [[NSMutableArray alloc] init];
    }
    return _beaconRegionList;
}

-(void)addBeaconRegion:(CLBeaconRegion *)beaconRegion{
    [self.beaconRegionList addObject:beaconRegion];
}
-(void)addBeaconRegionWithUUID:(NSUUID*)uuid{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    beaconRegion.notifyEntryStateOnDisplay =YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    [self.beaconRegionList addObject:beaconRegion];
}
-(void)addBeaconRegionWithUUIDString:(NSString*)uuidString{
    [self addBeaconRegionWithUUID:[[NSUUID alloc] initWithUUIDString:uuidString]];
}


-(id)init{
    if (self == [super init]) {
        //如果还没有请求授权，则请求始终定位权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestAlwaysAuthorization];

        }
    }
    return self;
}


-(void)startRanging{
    for (CLBeaconRegion *region in self.beaconRegionList) {
        [self.locationManager startRangingBeaconsInRegion:region];
        [self.locationManager startMonitoringForRegion:region];
    }
    
}

-(void)stopRanging{
    for (CLBeaconRegion *region in self.beaconRegionList) {
        [self.locationManager stopRangingBeaconsInRegion:region];
        [self.locationManager stopMonitoringForRegion:region];
    }

}

#pragma mark - Location manager delegate
//- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
//{
//    /*
//     A user can transition in or out of a region while the application is not running. When this happens CoreLocation will launch the application momentarily, call this delegate method and we will let the user know via a local notification.
//     */
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//
//    if(state == CLRegionStateInside)
//    {
//        notification.alertBody = NSLocalizedString(@"You're inside the region", @"");
//    }
//    else if(state == CLRegionStateOutside)
//    {
//        notification.alertBody = NSLocalizedString(@"You're outside the region", @"");
//    }
//    else
//    {
//        return;
//    }
//
//    /*
//     If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
//     If it's not, iOS will display the notification to the user.
//     */
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//}


//- (void)locationManager:(CLLocationManager *)manager
//         didEnterRegion:(CLRegion *)region{
//    [[self class] registerLocalNotification:1 alertBody:@"enter"];
//}
//- (void)locationManager:(CLLocationManager *)manager
//          didExitRegion:(CLRegion *)region{
//    [[self class] registerLocalNotification:1 alertBody:@"exit"];
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region{
//}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (manager == self.locationManager) {
        if ([self.delegate respondsToSelector:@selector(IBeaconService:didRangeBeacons:inRegion:)]) {
            [self.delegate IBeaconService:self didRangeBeacons:beacons inRegion:region];
        }
    }
}

@end
