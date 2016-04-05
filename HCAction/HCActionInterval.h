//
//  HCActionInterval.h
//  Russianalphabet
//
//  Created by HuaChen on 13-8-21.
//  Copyright (c) 2013年 HuaChen. All rights reserved.
//

#import "HCAction.h"

#pragma mark -
#pragma mark IntervalAction

@interface HCActionInterval : HCFiniteTimeAction{
    BOOL	firstTick_;
}
@property (nonatomic,readonly) NSTimeInterval elapsed;

/** creates the action */
+(id) actionWithDuration: (NSTimeInterval) d;
/** initializes the action */
-(id) initWithDuration: (NSTimeInterval) d;
/** returns YES if the action has finished */
-(BOOL) isDone;
/** returns a reversed action */
- (HCActionInterval*) reverse;

@end
/** Runs actions sequentially, one after another
 */
@interface CCSequence : HCActionInterval <NSCopying>
{
	HCFiniteTimeAction *actions_[2];
	NSTimeInterval split_;
	int last_;
}
/** helper contructor to create an array of sequenceable actions */
+(id) actions: (HCFiniteTimeAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;
/** helper contructor to create an array of sequenceable actions given an array */
+(id) actionsWithArray: (NSArray*) actions;
/** creates the action */
+(id) actionOne:(HCFiniteTimeAction*)actionOne two:(HCFiniteTimeAction*)actionTwo;
/** initializes the action */
-(id) initOne:(HCFiniteTimeAction*)actionOne two:(HCFiniteTimeAction*)actionTwo;
@end
/** Spawn a new action immediately
 */
@interface CCSpawn : HCActionInterval <NSCopying>
{
    HCFiniteTimeAction *_one;
    HCFiniteTimeAction *_two;
}
/** helper constructor to create an array of spawned actions */
+(id) actions: (HCFiniteTimeAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;
/** helper constructor to create an array of spawned actions */
+(id) actions: (HCFiniteTimeAction*) action1 vaList:(va_list)args;
/** helper constructor to create an array of spawned actions given an array */
+(id) actionWithArray: (NSArray*) arrayOfActions;
/** creates the Spawn action */
+(id) actionOne: (HCFiniteTimeAction*) one two:(HCFiniteTimeAction*) two;
/** initializes the Spawn action with the 2 actions to spawn */
-(id) initOne: (HCFiniteTimeAction*) one two:(HCFiniteTimeAction*) two;
@end




@interface HCMoveTo : HCActionInterval <NSCopying>
{
	CGPoint endPosition_;
	CGPoint startPosition_;
	CGPoint delta_;
}
/** creates the action */
+(id) actionWithDuration:(NSTimeInterval)duration position:(CGPoint)position;
/** initializes the action */
-(id) initWithDuration:(NSTimeInterval)duration position:(CGPoint)position;
@end

typedef struct controlPos{
    float posX;
    float posY;
}controlPos;


@interface HCBezier : HCActionInterval {
    int number_;
    CGPoint startPosition_;
    NSMutableArray *arrayOfControlPoints;
    float **ps;
    
}
+(id)actionWithPoints:(controlPos *)array pointNumber:(int)number Duration:(NSTimeInterval)t;
+(id)actionWithDuration:(NSTimeInterval)d pointNumber:(int)number withPoints:(float** (^)(void))points;
@end

typedef enum {
    kHCSpeedDefault,
    kHCSpeedLow,
    kHCSpeedNomal,
    kHCSpeedHigh,
    kHCSpeedVeryHigh
}kHCSpeedLevel;

@interface HCWiggle : HCActionInterval{
    CGPoint op;
    float radius;
    
    float cd;
    float dcd;
    
    float ra;
    float ralp;
    int raLevelSpeed;
    
    float v;
    float vx;
    float vy;
    
    float k;

}
+(id)actionWithDuration:(NSTimeInterval)d originPoint:(CGPoint)p radius:(float)r;
+(id)actionWithDuration:(NSTimeInterval)d originPoint:(CGPoint)p radius:(float)r withStartSpeed:(kHCSpeedLevel)ssl withSpeed:(kHCSpeedLevel)sl;
@end

/** bezier configuration structure
 */
typedef struct _ccBezierConfig {
    //! end position of the bezier
    CGPoint endPosition;
    //! Bezier control point 1
    CGPoint controlPoint_1;
    //! Bezier control point 2
    CGPoint controlPoint_2;
} ccBezierConfig;

/** An action that moves the target with a cubic Bezier curve by a certain distance.
 */
@interface CCBezierBy : HCActionInterval <NSCopying>
{
    ccBezierConfig _config;
    CGPoint _startPosition;
    CGPoint _previousPosition;
}

/** creates the action with a duration and a bezier configuration */
+(id) actionWithDuration: (NSTimeInterval) t bezier:(ccBezierConfig) c;

/** initializes the action with a duration and a bezier configuration */
-(id) initWithDuration: (NSTimeInterval) t bezier:(ccBezierConfig) c;
@end

/** An action that moves the target with a cubic Bezier curve to a destination point.
 @since v0.8.2
 */
@interface CCBezierTo : CCBezierBy
{
    ccBezierConfig _toConfig;
}
// XXX: Added to prevent bug on BridgeSupport
-(void) startWithTarget:(id )aTarget;
@end

@interface CCScaleTo : HCActionInterval <NSCopying>
{
	float scaleX_;
	float scaleY_;
	float startScaleX_;
	float startScaleY_;
	float endScaleX_;
	float endScaleY_;
	float deltaX_;
	float deltaY_;
}
/** creates the action with the same scale factor for X and Y */
+(id) actionWithDuration: (NSTimeInterval)duration scale:(float) s;
/** initializes the action with the same scale factor for X and Y */
-(id) initWithDuration: (NSTimeInterval)duration scale:(float) s;
/** creates the action with and X factor and a Y factor */
+(id) actionWithDuration: (NSTimeInterval)duration scaleX:(float) sx scaleY:(float)sy;
/** initializes the action with and X factor and a Y factor */
-(id) initWithDuration: (NSTimeInterval)duration scaleX:(float) sx scaleY:(float)sy;
@end

/** Scales a CCNode object a zoom factor by modifying it's scale attribute.
 */
@interface CCScaleBy : CCScaleTo <NSCopying>
{
}
@end

/** Fades In an object that implements the CCRGBAProtocol protocol. It modifies the opacity from 0 to 255.
 The "reverse" of this action is FadeOut
 */
@interface CCFadeIn : HCActionInterval <NSCopying>
{
}
@end

/** Fades Out an object that implements the CCRGBAProtocol protocol. It modifies the opacity from 255 to 0.
 The "reverse" of this action is FadeIn
 */
@interface CCFadeOut : HCActionInterval <NSCopying>
{
}
@end
/**  Rotates a CCNode object to a certain angle by modifying it's
 rotation attribute.
 The direction will be decided by the shortest angle.
 */
@interface CCRotateTo : HCActionInterval <NSCopying>
{
	float dstAngle_;
	float startAngle_;
	float diffAngle_;
}
/** creates the action */
+(id) actionWithDuration:(NSTimeInterval)duration angle:(float)angle;
/** initializes the action */
-(id) initWithDuration:(NSTimeInterval)duration angle:(float)angle;
@end

/** Rotates a CCNode object clockwise a number of degrees by modiying it's rotation attribute.
 */
@interface CCRotateBy : HCActionInterval <NSCopying>
{
	float angle_;
	float startAngle_;
}
/** creates the action */
+(id) actionWithDuration:(NSTimeInterval)duration angle:(float)deltaAngle;
/** initializes the action */
-(id) initWithDuration:(NSTimeInterval)duration angle:(float)deltaAngle;
@end

@interface HCAnchorPointTo : HCActionInterval<NSCopying>{
    CGPoint startP_;
    CGPoint p_;
}
/** creates the action */
+(id) actionWithDuration:(NSTimeInterval)duration anchorPoint:(CGPoint)p;
/** initializes the action */
-(id) initWithDuration:(NSTimeInterval)duration anchorPoint:(CGPoint)p;


@end

@interface CCJumpBy : HCActionInterval <NSCopying>
{
	CGPoint startPosition_;
	CGPoint delta_;
	NSTimeInterval height_;
	NSUInteger jumps_;
}
/** creates the action */
+(id) actionWithDuration: (NSTimeInterval)duration position:(CGPoint)position height:(NSTimeInterval)height jumps:(NSUInteger)jumps;
/** initializes the action */
-(id) initWithDuration: (NSTimeInterval)duration position:(CGPoint)position height:(NSTimeInterval)height jumps:(NSUInteger)jumps;
@end

/** Moves a CCNode object to a parabolic position simulating a jump movement by modifying its position attribute.
 */
@interface CCJumpTo : CCJumpBy <NSCopying>
{
}
@end

@interface CCDelayTime : HCActionInterval <NSCopying>
{
}
@end

@interface HCScrewRotation : HCActionInterval<NSCopying>{
    float radius_;
    CGPoint startPosition_;

}
+(id)actionWithDuration:(NSTimeInterval)d radius:(float)r;
-(id)initWithDuration:(NSTimeInterval)d radius:(float)r;


@end
