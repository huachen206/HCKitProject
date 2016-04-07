//
//  HCScheduled.h
//  Lottery
//
//  Created by 花晨 on 15/11/24.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCScheduled;
typedef void(^ScheduledBlock)( float *_Nullable delay,BOOL *_Nullable stop,HCScheduled *_Nullable scheduled);

@interface HCScheduled : NSObject
@property (readonly, getter=isValid) BOOL valid;
@property (readonly, getter=isPaused) BOOL paused;
@property (readonly) NSTimeInterval timeInterval;

+(instancetype _Nonnull)scheduled:(ScheduledBlock _Nonnull)block;
-(void)scheduled:(ScheduledBlock _Nonnull)block;
-(void)invalidate;
-(void)pause;
-(void)resume;
-(void)scheduledDisplayWithtarget:(id _Nonnull)target selector:(SEL _Nonnull)select repeats:(BOOL)isRepeats;
+(instancetype _Nonnull)scheduledDisplayWithtarget:(id _Nonnull)target selector:(nonnull SEL)select repeats:(BOOL)isRepeats;

@end
