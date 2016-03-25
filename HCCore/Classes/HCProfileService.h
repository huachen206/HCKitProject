//
//  HCProfileService.h
//  PAQZZ
//
//  Created by 花晨 on 14-6-5.
//  Copyright (c) 2014年 平安付. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ProfileServiceDownLoadState) {
    ProfileServiceDownLoadState_unStart,
    ProfileServiceDownLoadState_downLoading,
    ProfileServiceDownLoadState_success,
    ProfileServiceDownLoadState_fail
};
@class HCProfileService;
@protocol HCProfileServiceDelegate <NSObject>

-(void)ProfileServiceDownStart:(HCProfileService *)service;
-(void)ProfileService:(HCProfileService *)service jsonResult:(id)result;
-(void)ProfileService:(HCProfileService *)service downLoadError:(NSError *)error;


@end

@interface HCProfileService : NSObject
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,strong) id jsonData;
@property (nonatomic,assign) NSInteger updateTime;
@property (nonatomic,weak) id<HCProfileServiceDelegate> delegate;
@property (nonatomic,assign) ProfileServiceDownLoadState downLoadState;
@property (nonatomic,assign) BOOL autoRefreshEnable;//default is YES
@property (nonatomic,assign) BOOL downLoadFailRetry;//default is YES
+(instancetype)profileServiceWithUrl:(NSString *)urlString delegate:(id)delegate;
@end
