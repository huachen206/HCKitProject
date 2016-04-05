//
//  HCAction.h
//  Russianalphabet
//
//  Created by HuaChen on 13-8-21.
//  Copyright (c) 2013年 HuaChen. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UIView+Action.h"
#import <QuartzCore/QuartzCore.h>
#import "HCScheduled.h"

#define ccp(__X__,__Y__) CGPointMake(__X__,__Y__)

#define CC_SWAP( x, y )			\
({ __typeof__(x) temp  = (x);		\
x = y; y = temp;		\
})


/** Returns opposite of point.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpNeg(const CGPoint v)
{
	return ccp(-v.x, -v.y);
}

/** Calculates sum of two points.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpAdd(const CGPoint v1, const CGPoint v2)
{
	return ccp(v1.x + v2.x, v1.y + v2.y);
}

/** Calculates difference of two points.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpSub(const CGPoint v1, const CGPoint v2)
{
	return ccp(v1.x - v2.x, v1.y - v2.y);
}
/** Returns point multiplied by given factor.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpMult(const CGPoint v, const CGFloat s)
{
	return ccp(v.x*s, v.y*s);
}

/** Calculates midpoint between two points.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpMidpoint(const CGPoint v1, const CGPoint v2)
{
	return ccpMult(ccpAdd(v1, v2), 0.5f);
}

/** Calculates dot product of two points.
 @return CGFloat
 @since v0.7.2
 */
static inline CGFloat
ccpDot(const CGPoint v1, const CGPoint v2)
{
	return v1.x*v2.x + v1.y*v2.y;
}

/** Calculates cross product of two points.
 @return CGFloat
 @since v0.7.2
 */
static inline CGFloat
ccpCross(const CGPoint v1, const CGPoint v2)
{
	return v1.x*v2.y - v1.y*v2.x;
}

/** Calculates perpendicular of v, rotated 90 degrees counter-clockwise -- cross(v, perp(v)) >= 0
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpPerp(const CGPoint v)
{
	return ccp(-v.y, v.x);
}

/** Calculates perpendicular of v, rotated 90 degrees clockwise -- cross(v, rperp(v)) <= 0
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpRPerp(const CGPoint v)
{
	return ccp(v.y, -v.x);
}

/** Calculates the projection of v1 over v2.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpProject(const CGPoint v1, const CGPoint v2)
{
	return ccpMult(v2, ccpDot(v1, v2)/ccpDot(v2, v2));
}

/** Rotates two points.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpRotate(const CGPoint v1, const CGPoint v2)
{
	return ccp(v1.x*v2.x - v1.y*v2.y, v1.x*v2.y + v1.y*v2.x);
}

/** Unrotates two points.
 @return CGPoint
 @since v0.7.2
 */
static inline CGPoint
ccpUnrotate(const CGPoint v1, const CGPoint v2)
{
	return ccp(v1.x*v2.x + v1.y*v2.y, v1.y*v2.x - v1.x*v2.y);
}

/** Calculates the square length of a CGPoint (not calling sqrt() )
 @return CGFloat
 @since v0.7.2
 */
static inline CGFloat
ccpLengthSQ(const CGPoint v)
{
	return ccpDot(v, v);
}

static inline float
clampf(float value, float min_inclusive, float max_inclusive)
{
	if (min_inclusive > max_inclusive) {
		CC_SWAP(min_inclusive,max_inclusive);
	}
	return value < min_inclusive ? min_inclusive : value < max_inclusive? value : max_inclusive;
}


enum{
    kHCActionTagInvalid = -1,
};

@interface HCAction : NSObject<NSCopying>
@property (nonatomic,assign,readonly) id originalTarget;
@property (nonatomic,assign,readonly) id target;
@property (nonatomic,assign) NSInteger tag;

/** Allocates and initializes the action */
+(id) action;

/** Initializes the action */
-(id) init;

-(id) copyWithZone: (NSZone*) zone;

//! return YES if the action has finished
-(BOOL) isDone;
//! called before the action start. It will also set the target.
-(void) startWithTarget:(id)target;
//! called after the action has finished. It will set the 'target' to nil.
//! IMPORTANT: You should never call "[action stop]" manually. Instead, use: "[target stopAction:action];"
-(void) stop;
//! called every frame with it's delta time. DON'T override unless you know what you are doing.
-(void) step: (HCScheduled *)timer;
//! called once per frame. time a value between 0 and 1
//! For example:
//! * 0 means that the action just started
//! * 0.5 means that the action is in the middle
//! * 1 means that the action is over
-(void) update: (NSTimeInterval) time;


@end

@interface HCFiniteTimeAction : HCAction<NSCopying>
@property (nonatomic,assign) NSTimeInterval duration;
- (HCFiniteTimeAction*) reverse;

@end


@class HCActionInterval;
/** Repeats an action for ever.
 To repeat the an action for a limited number of times use the Repeat action.
 @warning This action can't be Sequenceable because it is not an IntervalAction
 */
@interface CCRepeatForever : HCAction <NSCopying>
{
	HCActionInterval *innerAction_;
}
/** Inner action */
@property (nonatomic, readwrite, retain) HCActionInterval *innerAction;

/** creates the action */
+(id) actionWithAction: (HCActionInterval*) action;
/** initializes the action */
-(id) initWithAction: (HCActionInterval*) action;
@end

/** Changes the speed of an action, making it take longer (speed>1)
 or less (speed<1) time.
 Useful to simulate 'slow motion' or 'fast forward' effect.
 @warning This action can't be Sequenceable because it is not an CCIntervalAction
 */
@interface CCSpeed : HCAction <NSCopying>
{
	HCActionInterval	*innerAction_;
	float speed_;
}
/** alter the speed of the inner function in runtime */
@property (nonatomic,readwrite) float speed;
/** Inner action of CCSpeed */
@property (nonatomic, readwrite, retain) HCActionInterval *innerAction;

/** creates the action */
+(id) actionWithAction: (HCActionInterval*) action speed:(float)rate;
/** initializes the action */
-(id) initWithAction: (HCActionInterval*) action speed:(float)rate;
@end

//@class CCNode;
/** CCFollow is an action that "follows" a node.
 
 Eg:
 [layer runAction: [CCFollow actionWithTarget:hero]];
 
 Instead of using CCCamera as a "follower", use this action instead.
 @since v0.99.2
 */
@interface CCFollow : HCAction <NSCopying>
{
	/* node to follow */
	id followedNode_;
	
	/* whether camera should be limited to certain area */
	BOOL boundarySet;
	
	/* if screensize is bigger than the boundary - update not needed */
	BOOL boundaryFullyCovered;
	
	/* fast access to the screen dimensions */
	CGPoint halfScreenSize;
	CGPoint fullScreenSize;
	
	/* world boundaries */
	float leftBoundary;
	float rightBoundary;
	float topBoundary;
	float bottomBoundary;
}

/** alter behavior - turn on/off boundary */
@property (nonatomic,readwrite) BOOL boundarySet;

/** creates the action with no boundary set */
+(id) actionWithTarget:(id)followedNode;

/** creates the action with a set boundary */
+(id) actionWithTarget:(id)followedNode worldBoundary:(CGRect)rect;

/** initializes the action */
-(id) initWithTarget:(id)followedNode;

/** initializes the action with a set boundary */
-(id) initWithTarget:(id)followedNode worldBoundary:(CGRect)rect;

@end

