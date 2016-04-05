//
//  HCScheduled.h
//  Lottery
//
//  Created by 花晨 on 15/11/24.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCScheduled;
typedef void(^ScheduledBlock)(float *delay,BOOL *stop,HCScheduled *scheduled);

@interface HCScheduled : NSObject
@property (readonly, getter=isValid) BOOL valid;
@property (readonly, getter=isPaused) BOOL paused;
@property (readonly) NSTimeInterval timeInterval;

+(instancetype)scheduled:(ScheduledBlock)block;
-(void)scheduled:(ScheduledBlock)block;
-(void)invalidate;
-(void)pause;
-(void)resume;
-(void)scheduledDisplayWithtarget:(id)target selector:(SEL)select repeats:(BOOL)isRepeats;
+(instancetype)scheduledDisplayWithtarget:(id)target selector:(nonnull SEL)select repeats:(BOOL)isRepeats;

@end
