//
//  HCScheduled.m
//  Lottery
//
//  Created by 花晨 on 15/11/24.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCScheduled.h"
#import "HCUtilityMacro.h"
#import <QuartzCore/CADisplayLink.h>

@interface HCScheduled(){
    BOOL blockStop;
}
@property (nonatomic,strong) ScheduledBlock actionBlock;
@property (nonatomic,strong) id atarget;
@property (nonatomic,assign) SEL aselect;
@property (nonatomic,strong) CADisplayLink *displayLink;
@end

@implementation HCScheduled
@synthesize valid = _valid,paused = _paused;

+(instancetype)scheduled:(ScheduledBlock)block{
    HCScheduled *scheduled = [[[self class] alloc] init];
    [scheduled scheduled:block];
    return scheduled;
}
+(instancetype)scheduledDisplayWithtarget:(id)target selector:(nonnull SEL)select repeats:(BOOL)isRepeats{
    HCScheduled *as = [[self alloc] init];
    [as scheduledDisplayWithtarget:target selector:select repeats:isRepeats];
    return as;
}

-(void)scheduledDisplayWithtarget:(id)target selector:(SEL)select repeats:(BOOL)isRepeats{
    self.atarget = target;
    self.aselect = select;
    if ([target respondsToSelector:select]) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaySchedule:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:isRepeats?NSDefaultRunLoopMode:NSRunLoopCommonModes];
    }
}

-(void)displaySchedule:(CADisplayLink*)displayLink{
    _timeInterval = displayLink.duration;
    SuppressPerformSelectorLeakWarning(
                                       [self.atarget performSelector:self.aselect withObject:self];
                                       );
}




-(void)scheduled:(ScheduledBlock)block{
    if (blockStop||!_paused) {
        return;
    }
    self.actionBlock = block;
    _valid = YES;
    float *delay = (float *)malloc(sizeof(float));
    BOOL *stop = (BOOL *)malloc(sizeof(BOOL));
    *delay = 0;
    *stop = NO;
    block(delay,stop,self);
    _timeInterval = *delay;
    if (!*stop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(*delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scheduled:block];
        });
//        [self performSelector:@selector(scheduled:) withObject:block afterDelay:*delay];
    }else{
        _valid = NO;
    }
}

-(void)invalidate{
    if (self.displayLink) {
        [self.displayLink invalidate];
    }else if(self.actionBlock){
        blockStop = YES;
//        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    _valid = NO;
}

-(BOOL)isValid{
    return _valid;
}

-(void)pause{
    if (self.displayLink) {
        self.displayLink.paused = YES;
    }else if(self.actionBlock){
        _paused = YES;
    }

}
-(void)resume{
    if (self.displayLink) {
        self.displayLink.paused = NO;
    }else if(self.actionBlock){
        _paused = NO;
        float *delay = (float *)malloc(sizeof(float));
        BOOL *stop = (BOOL *)malloc(sizeof(BOOL));
        self.actionBlock(delay,stop,self);
    }

}

-(BOOL)isPaused{
    if (self.displayLink) {
        return self.displayLink.paused;
    }else if(self.actionBlock){
        return _paused;
    }else{
        return NO;
    }
}
@end
