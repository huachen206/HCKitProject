//
//  HCClock.m
//
//  Created by 花晨 on 14-1-26.
//  Copyright (c) 2014年 平安付. All rights reserved.
//

#import "HCClock.h"

@implementation HCClock
+(NSMutableDictionary *)clocks{
    static dispatch_once_t onceToken;
    static NSMutableDictionary *__clocks;
    dispatch_once(&onceToken, ^{
        __clocks = [[NSMutableDictionary alloc] init];
    });
    return __clocks;
}
+(void)setClock:(HCClock *)clock withKey:(NSString*)key{
    clock.key = key;
    [[HCClock clocks] setObject:clock forKey:key];
}
+(HCClock*)clockByKey:(NSString *)key{
    return [[HCClock clocks] objectForKey:key];
}
-(void)setKey:(NSString *)key{
    [[HCClock clocks] setObject:self forKey:key];
    _key = key;
}
-(id)initWithTotalTime:(NSInteger)totalTime{
    return [[[self class]alloc]initWithTotalTime:totalTime withTimeInterVal:1];
}
-(id)initWithTotalTime:(NSInteger)totalTime withTimeInterVal:(NSInteger)timeInterval{
    self = [super init];
    if (self) {
        self.timeInterval = timeInterval;
        self.totalTime = totalTime;
    }
    return self;
}
-(void)clockStartWithBlock:(clockStartBlock)startBlock withUpdateBlock:(clockUpdateBlock)updateBlock FinishWithBlock:(clockFinishBlock)finishBlock {
    self.startBlock = startBlock;
    self.updateBlock = updateBlock;
    self.finishBlcok = finishBlock;
}

-(void)start{
    if (self.isRuning) {
        return;
    }
    self.isRuning = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(update) userInfo:Nil repeats:YES];
    if ([self.delegate respondsToSelector:@selector(clockStart:)]) {
        [self.delegate clockStart:self];
    }
    if (self.startBlock) {
        self.startBlock(self);
    }
}
-(void)update{
    self.isRuning = YES;
    self.runingTime +=self.timeInterval;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clockUpdate:)]) {
        [self.delegate clockUpdate:self];
    }
    if (self.updateBlock != nil) {
        self.updateBlock(self);
    }
    if (self.runingTime>=self.totalTime) {
        [self finish];
    }
}
-(void)finish{
    self.isRuning = NO;
    [self.timer invalidate];
    if ([self.delegate respondsToSelector:@selector(clockFinish:)]) {
        [self.delegate clockFinish:self];
    }
    if (self.key) {
        [[HCClock clocks] removeObjectForKey:self.key];
    }
    if (self.finishBlcok) {
        self.finishBlcok(self);
    }
}
-(void)cancel{
    self.isRuning = NO;
    [self.timer invalidate];
    if ([self.delegate respondsToSelector:@selector(clockCancel:)]) {
        [self.delegate clockCancel:self];
    }
    if (self.key) {
        [[HCClock clocks] removeObjectForKey:self.key];
    }
}
-(void)stop{
    self.isRuning = NO;
    [self.timer invalidate];
}
-(void)resume{
    self.isRuning = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(update) userInfo:Nil repeats:YES];
}


@end
