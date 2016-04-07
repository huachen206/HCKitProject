//
//  HCClock.h
//
//  Created by 花晨 on 14-1-26.
//  Copyright (c) 2014年 平安付. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCClock;
@protocol HCClockDelegate <NSObject>
@optional
-(void)clockStart:(HCClock *)clock;
-(void)clockUpdate:(HCClock *)clock;
-(void)clockFinish:(HCClock *)clock;
-(void)clockCancel:(HCClock *)clock;
@end

typedef void(^clockStartBlock)(HCClock *clock);
typedef void(^clockUpdateBlock)(HCClock *clock);
typedef void(^clockFinishBlock)(HCClock *clock);


@interface HCClock : NSObject
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger timeInterval;
@property (nonatomic,assign) NSInteger runingTime;
@property (nonatomic,assign) NSInteger totalTime;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,assign) BOOL isRuning;
@property (nonatomic,weak) id<HCClockDelegate> delegate;

@property (nonatomic,assign) clockStartBlock startBlock;
@property (nonatomic,assign) clockUpdateBlock updateBlock;
@property (nonatomic,assign) clockFinishBlock finishBlcok;
+(void)setClock:(HCClock *)clock withKey:(NSString*)key;
+(HCClock*)clockByKey:(NSString *)key;

-(id)initWithTotalTime:(NSInteger)totalTime;
-(id)initWithTotalTime:(NSInteger)totalTime withTimeInterVal:(NSInteger)timeInterval;
-(void)clockStartWithBlock:(clockStartBlock)startBlock withUpdateBlock:(clockUpdateBlock)updateBlock FinishWithBlock:(clockFinishBlock)finishBlock;
-(void)start;
-(void)stop;
-(void)resume;
-(void)cancel;
+(NSMutableDictionary *)clocks;
@end
