//
//  HCAction.m
//  Russianalphabet
//
//  Created by HuaChen on 13-8-21.
//  Copyright (c) 2013年 HuaChen. All rights reserved.
//

#import "HCAction.h"
#import "HCActionInterval.h"

@implementation HCAction
+(id) action
{
	return [[self alloc] init];
}

-(id) init
{
	if( (self=[super init]) ) {
		_originalTarget = _target = nil;
		_tag = kHCActionTagInvalid;
	}
	return self;
}

-(void) dealloc
{
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %8@ | Tag = %li>", [self class], self, (long)_tag];
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] init];
	copy.tag = _tag;
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	_originalTarget = _target = aTarget;
}

-(void) stop
{
	_target = nil;
}

-(BOOL) isDone
{
	return YES;
}

-(void) step: (HCScheduled*) timer
{
//	NSLog(@"[Action step]. override me");
}

-(void) update: (NSTimeInterval) time
{
//	NSLog(@"[Action update]. override me");
}

@end

#pragma mark -
#pragma mark FiniteTimeAction

@implementation HCFiniteTimeAction
- (HCFiniteTimeAction*) reverse
{
	NSLog(@"HCAction: FiniteTimeAction#reverse: Implement me");
	return nil;
}
@end
//
// RepeatForever
//
#pragma mark -
#pragma mark RepeatForever
@implementation CCRepeatForever
@synthesize innerAction=innerAction_;
+(id) actionWithAction: (HCActionInterval*) action
{
	return [[self alloc] initWithAction: action];
}

-(id) initWithAction: (HCActionInterval*) action
{
	if( (self=[super init]) )
		self.innerAction = action;
    
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] initWithAction:innerAction_ ];
    return copy;
}

-(void) dealloc
{
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[innerAction_ startWithTarget:self.target];
}

-(void) step: (HCScheduled *)timer
{
//    float dt = timer.timeInterval;
    if (!self.target) {
        return;
    }
	[innerAction_ step: timer];
	if( [innerAction_ isDone] ) {
//		NSTimeInterval diff = dt + innerAction_.duration - innerAction_.elapsed;
//		[innerAction_ startWithTarget:self.target];
		
		// to prevent jerk. issue #390
//        NSTimer *ti = [NSTimer timerWithTimeInterval:diff invocation:nil repeats:NO];
//		[innerAction_ step:ti];
        [self.target runAction:self];
	}
}


-(BOOL) isDone
{
	return NO;
}

- (HCActionInterval *) reverse
{
	return [CCRepeatForever actionWithAction:[innerAction_ reverse]];
}
@end

//
// Speed
//
#pragma mark -
#pragma mark Speed
@implementation CCSpeed
@synthesize speed=speed_;
@synthesize innerAction=innerAction_;

+(id) actionWithAction: (HCActionInterval*) action speed:(float)r
{
	return [[self alloc] initWithAction: action speed:r];
}

-(id) initWithAction: (HCActionInterval*) action speed:(float)r
{
	if( (self=[super init]) ) {
		self.innerAction = action;
		speed_ = r;
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] initWithAction:innerAction_ speed:speed_];
    return copy;
}

-(void) dealloc
{
//	[innerAction_ release];
//	[super dealloc];
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[innerAction_ startWithTarget:self.target];
}

-(void) stop
{
	[innerAction_ stop];
	[super stop];
}

-(void) step:(HCScheduled*) timer
{
    [NSTimer scheduledTimerWithTimeInterval:timer.timeInterval * speed_ target:innerAction_ selector:@selector(step:) userInfo:nil repeats:NO];
}

-(BOOL) isDone
{
	return [innerAction_ isDone];
}

- (HCActionInterval *) reverse
{
	return [CCSpeed actionWithAction:[innerAction_ reverse] speed:speed_];
}
@end



//
// Follow
//
#pragma mark -
#pragma mark Follow
@implementation CCFollow

@synthesize boundarySet;

+(id) actionWithTarget:(id) fNode
{
	return [[self alloc] initWithTarget:fNode];
}

+(id) actionWithTarget:(id) fNode worldBoundary:(CGRect)rect
{
	return [[self alloc] initWithTarget:fNode worldBoundary:rect];
}

-(id) initWithTarget:(id)fNode
{
	if( (self=[super init]) ) {
        
		followedNode_ = fNode;
		boundarySet = FALSE;
		boundaryFullyCovered = FALSE;
		
		CGSize s = [UIScreen mainScreen].bounds.size;
		fullScreenSize = CGPointMake(s.width, s.height);
		halfScreenSize = ccpMult(fullScreenSize, .5f);
	}
	
	return self;
}

-(id) initWithTarget:(id)fNode worldBoundary:(CGRect)rect
{
	if( (self=[super init]) ) {
        
		followedNode_ = fNode;
		boundarySet = TRUE;
		boundaryFullyCovered = FALSE;
		
		CGSize winSize = [UIScreen mainScreen].bounds.size;
		fullScreenSize = CGPointMake(winSize.width, winSize.height);
		halfScreenSize = ccpMult(fullScreenSize, .5f);
		
		leftBoundary = -((rect.origin.x+rect.size.width) - fullScreenSize.x);
		rightBoundary = -rect.origin.x ;
		topBoundary = -rect.origin.y;
		bottomBoundary = -((rect.origin.y+rect.size.height) - fullScreenSize.y);
		
		if(rightBoundary < leftBoundary)
		{
			// screen width is larger than world's boundary width
			//set both in the middle of the world
			rightBoundary = leftBoundary = (leftBoundary + rightBoundary) / 2;
		}
		if(topBoundary < bottomBoundary)
		{
			// screen width is larger than world's boundary width
			//set both in the middle of the world
			topBoundary = bottomBoundary = (topBoundary + bottomBoundary) / 2;
		}
		
		if( (topBoundary == bottomBoundary) && (leftBoundary == rightBoundary) )
			boundaryFullyCovered = TRUE;
	}
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] init];
	copy.tag = self.tag;
	return copy;
}

-(void) step:(HCScheduled *) timer
{
	if(boundarySet)
	{
		// whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
		if(boundaryFullyCovered)
			return;
		
		CGPoint tempPos = ccpSub( halfScreenSize, [(UIView *)followedNode_ center]);
		[self.target setCenter:ccp(clampf(tempPos.x,leftBoundary,rightBoundary), clampf(tempPos.y,bottomBoundary,topBoundary))];
	}
	else
		[self.target setCenter:ccpSub( halfScreenSize, [(UIView *)followedNode_ center])];
	
#undef CLAMP
}


-(BOOL) isDone
{
	return ![(UIView*)followedNode_ isRunning];
//    return YES;
}

-(void) stop
{
	[super stop];
}

-(void) dealloc
{
    followedNode_ = nil;
}

@end




