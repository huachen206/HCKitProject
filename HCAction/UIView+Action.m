//
//  UIView+Action.m
//  Russianalphabet
//
//  Created by HuaChen on 13-8-22.
//  Copyright (c) 2013年 HuaChen. All rights reserved.
//

#import "UIView+Action.h"
#import "HCAction.h"
#import <objc/runtime.h>
#import "HCScheduled.h"
static const void *scaleXkey = &scaleXkey;
static const void *scaleYkey = &scaleYkey;
static const void *originFramekey = &originFramekey;
static const void *isRunningkey = &isRunningkey;
static const void *rotationkkey = &rotationkkey;
static const void *actionskey = &actionskey;
static const void *actionTimerskey = &actionTimerskey;


@interface UIView ()
@property (nonatomic,strong) NSMutableArray *actionTimers;
@end

@implementation UIView (Action)
@dynamic isRunning,scaleX,scaleY,actions;

-(void)setActionTimers:(NSMutableArray *)actionTimers{
    objc_setAssociatedObject(self, actionTimerskey, actionTimers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray*)actionTimers{
    if (!objc_getAssociatedObject(self, actionTimerskey)) {
        objc_setAssociatedObject(self, actionTimerskey, [[NSMutableArray alloc] init ], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, actionTimerskey);
}

-(void)setActions:(NSMutableArray *)actions{
        objc_setAssociatedObject(self, actionskey, actions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray *)actions{
    if (!objc_getAssociatedObject(self, actionskey)) {
        objc_setAssociatedObject(self, actionskey, [[NSMutableArray alloc] init ], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, actionskey);
}

-(void)setRotation_h:(float)rotation{
    [[self layer] setValue:[NSNumber numberWithFloat:rotation] forKeyPath:@"transform.rotation"];
//    [self setTransform:CGAffineTransformMakeRotation(rotation)];
//    objc_setAssociatedObject(self, rotationkkey, [NSNumber numberWithFloat:rotation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(float)rotation_h{
    return [[[self layer] valueForKeyPath:@"transform.rotation"] floatValue];

//    return [objc_getAssociatedObject(self, rotationkkey) floatValue];
}
-(void)setIsRunning:(BOOL)isRunning{
    objc_setAssociatedObject(self, isRunningkey, [NSNumber numberWithBool:isRunning], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isRunning{
    return [objc_getAssociatedObject(self, isRunningkey) boolValue];
}
-(void)setScale:(float)f{
    
    CGRect rect = self.frame;

    float subWith = (f-self.scaleX)*rect.size.width;
    float subHeigh = (f-self.scaleY)*rect.size.height;

    [self setFrame:CGRectMake(rect.origin.x - subWith/2, rect.origin.y -subHeigh/2, rect.size.width+subWith, rect.size.height+subHeigh)];

//    [self setTransform:CGAffineTransformMakeScale(f, f)];
    objc_setAssociatedObject(self, scaleXkey, [NSNumber numberWithFloat:f], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, scaleYkey, [NSNumber numberWithFloat:f], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
}

-(void)setScaleX:(float)scaleX{
    objc_setAssociatedObject(self, scaleXkey, [NSNumber numberWithFloat:scaleX], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTransform:CGAffineTransformMakeScale(scaleX, self.scaleY)];


}
-(float)scaleX{
    float newScaleX = [objc_getAssociatedObject(self, scaleXkey) floatValue];
    if (newScaleX == 0) {
        newScaleX =1;
        objc_setAssociatedObject(self, scaleXkey, [NSNumber numberWithFloat:newScaleX], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return newScaleX;
}
-(void)setScaleY:(float)scaleY{

    objc_setAssociatedObject(self, scaleYkey, [NSNumber numberWithFloat:scaleY], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTransform:CGAffineTransformMakeScale([self scaleX], scaleY)];

}
-(float)scaleY{
    float newScaleY = [objc_getAssociatedObject(self, scaleYkey) floatValue];
    if (newScaleY == 0) {
        newScaleY = 1;
        objc_setAssociatedObject(self, scaleYkey, [NSNumber numberWithFloat:newScaleY], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return newScaleY;
}
//-(void)setScale:(float)f{
//    CGRect rect = self.frame;
//    
//    float subWith = (f-1)*rect.size.width;
//    float subHeigh = (f-1)*rect.size.height;
//    
//    [self setFrame:CGRectMake(rect.origin.x - subWith/2, rect.origin.y -subHeigh/2, rect.size.width*f, rect.size.height*f)];
//}

-(HCAction*)runAction:(HCAction*)action{
    [action startWithTarget:self];
    NSAssert( action != nil, @"Argument must be non-nil");
    
    HCScheduled *as = [[HCScheduled alloc] init];
    [as scheduledDisplayWithtarget:action selector:@selector(step:) repeats:YES];
    [self.actionTimers addObject:as];
    
    [self.actions addObject:action];
	return action;
}

-(void)removeAction:(HCAction*)action{
    if ([self.actions containsObject:action]) {
        [self.actions removeObject:action];
    }
}
-(void)stopAction:(HCAction *)action{
    [action stop];
    HCScheduled *as = (HCScheduled *)[self.actionTimers objectAtIndex:[self.actions indexOfObject:action]];
    [as invalidate];
    [self.actionTimers removeObject:as];
    [self removeAction:action];
}
-(void)stopAllAction{
    for (HCAction *a in self.actions) {
        [a stop];
        HCScheduled *as = (HCScheduled *)[self.actionTimers objectAtIndex:[self.actions indexOfObject:a]];
        [as invalidate];
    }
    [self.actionTimers removeAllObjects];
    [self.actions removeAllObjects];
}
-(int)numberOfActions{
    return (int)[self.actions count];
}


-(void)pauseAllAction{
    for (HCScheduled *as in self.actionTimers) {
        [as pause];
    }
}
-(void)resumAllAction{
    for (HCScheduled *as in self.actionTimers) {
        [as resume];
    }
}
//+(BOOL)resolveInstanceMethod:(SEL)sel{
//    NSString *methodName=NSStringFromSelector(sel);
//    BOOL result=NO;
//    //看看是不是我们要动态实现的方法名称
//    if ([methodName isEqualToString:@"scaleX"]) {
//        class_addMethod([self class], <#SEL name#>, <#IMP imp#>, <#const char *types#>)
//        
//        result=YES;  
//    }  
//    return result;  
//
//}


@end
