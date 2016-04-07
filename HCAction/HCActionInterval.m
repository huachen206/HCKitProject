//
//  HCActionInterval.m
//  Russianalphabet
//
//  Created by HuaChen on 13-8-21.
//  Copyright (c) 2013年 HuaChen. All rights reserved.
//

#import "HCActionInterval.h"
#import <UIKit/UIKit.h>
//#import "UIView+HCAction.h"
@implementation HCActionInterval

-(id) init
{
	NSAssert(NO, @"IntervalActionInit: Init not supported. Use InitWithDuration");
	return nil;
}

+(id) actionWithDuration: (NSTimeInterval) d
{
	return [[self alloc] initWithDuration:d];
}

-(id) initWithDuration: (NSTimeInterval) d
{
	if( (self=[super init]) ) {
		self.duration = d;
		
		// prevent division by 0
		// This comparison could be in step:, but it might decrease the performance
		// by 3% in heavy based action games.
		if( self.duration == 0 )
			self.duration = FLT_EPSILON;
		_elapsed = 0;
		firstTick_ = YES;
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] ];
	return copy;
}

- (BOOL) isDone
{
	return (_elapsed >= self.duration);
}

-(void) step: (HCScheduled *)timer
{
    NSTimeInterval dt = timer.timeInterval;
	if( firstTick_ ) {
		firstTick_ = NO;
		_elapsed = 0;
	} else
		_elapsed += dt;
    
	[self update: MIN(1, _elapsed/self.duration)];
    
    if (MIN(1, _elapsed/self.duration) == 1) {
        [timer invalidate];
    }
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	_elapsed = 0.0f;
	firstTick_ = YES;
}

- (HCActionInterval*) reverse
{
	NSAssert(NO, @"CCIntervalAction: reverse not implemented.");
	return nil;
}

@end

//
// Sequence
//
#pragma mark -
#pragma mark Sequence
@implementation CCSequence
+(id) actions: (HCFiniteTimeAction*) action1, ...
{
	va_list params;
	va_start(params,action1);
	
	HCFiniteTimeAction *now;
	HCFiniteTimeAction *prev = action1;
	
	while( action1 ) {
		now = va_arg(params,HCFiniteTimeAction*);
		if ( now )
			prev = [self actionOne: prev two: now];
		else
			break;
	}
	va_end(params);
	return prev;
}

+(id) actionsWithArray: (NSArray*) actions
{
	HCFiniteTimeAction *prev = [actions objectAtIndex:0];
	
	for (NSUInteger i = 1; i < [actions count]; i++)
		prev = [self actionOne:prev two:[actions objectAtIndex:i]];
	
	return prev;
}

+(id) actionOne: (HCFiniteTimeAction*) one two: (HCFiniteTimeAction*) two
{
	return [[self alloc] initOne:one two:two ];
}

-(id) initOne: (HCFiniteTimeAction*) one two: (HCFiniteTimeAction*) two
{
	NSAssert( one!=nil && two!=nil, @"Sequence: arguments must be non-nil");
	NSAssert( one!=actions_[0] && one!=actions_[1], @"Sequence: re-init using the same parameters is not supported");
	NSAssert( two!=actions_[1] && two!=actions_[0], @"Sequence: re-init using the same parameters is not supported");
    
	NSTimeInterval d = [one duration] + [two duration];
	
	if( (self=[super initWithDuration: d]) ) {
        
		// XXX: Supports re-init without leaking. Fails if one==one_ || two==two_
		actions_[0] =nil;
		actions_[1] = nil;
        
		actions_[0] = one;
		actions_[1] = two;
	}
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone:zone] initOne:[actions_[0] copy] two:[actions_[1] copy]];
	return copy;
}

-(void) dealloc
{
    actions_[0] =nil;
    actions_[1] = nil;
//	[super dealloc];
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	split_ = [actions_[0] duration] / self.duration;
	last_ = -1;
}

-(void) stop
{
	[actions_[0] stop];
	[actions_[1] stop];
	[super stop];
}

-(void) update: (NSTimeInterval) t
{
	int found = 0;
	NSTimeInterval new_t = 0.0f;
	
	if( t >= split_ ) {
		found = 1;
		if ( split_ == 1 )
			new_t = 1;
		else
			new_t = (t-split_) / (1 - split_ );
	} else {
		found = 0;
		if( split_ != 0 )
			new_t = t / split_;
		else
			new_t = 1;
	}
	
	if (last_ == -1 && found==1)	{
		[actions_[0] startWithTarget:self.target];
		[actions_[0] update:1.0f];
		[actions_[0] stop];
	}
    
	if (last_ != found ) {
		if( last_ != -1 ) {
			[actions_[last_] update: 1.0f];
			[actions_[last_] stop];
		}
		[actions_[found] startWithTarget:self.target];
	}
	[actions_[found] update: new_t];
	last_ = found;
}

- (HCActionInterval *) reverse
{
	return [[self class] actionOne: [actions_[1] reverse] two: [actions_[0] reverse ] ];
}
@end
//
// Spawn
//
#pragma mark - CCSpawn

@implementation CCSpawn
+(id) actions: (HCFiniteTimeAction*) action1, ...
{
    va_list args;
    va_start(args, action1);
    
    id ret = [self actions:action1 vaList:args];
    
    va_end(args);
    return ret;
}

+(id) actions: (HCFiniteTimeAction*) action1 vaList:(va_list)args
{
    HCFiniteTimeAction *now;
    HCFiniteTimeAction *prev = action1;
    
    while( action1 ) {
        now = va_arg(args,HCFiniteTimeAction*);
        if ( now )
            prev = [self actionOne: prev two: now];
        else
            break;
    }
    
    return prev;
}


+(id) actionWithArray: (NSArray*) actions
{
    HCFiniteTimeAction *prev = [actions objectAtIndex:0];
    
    for (NSUInteger i = 1; i < [actions count]; i++)
        prev = [self actionOne:prev two:[actions objectAtIndex:i]];
    
    return prev;
}

+(id) actionOne: (HCFiniteTimeAction*) one two: (HCFiniteTimeAction*) two
{
    return [[self alloc] initOne:one two:two ];
}

-(id) initOne: (HCFiniteTimeAction*) one two: (HCFiniteTimeAction*) two
{
    NSAssert( one!=nil && two!=nil, @"Spawn: arguments must be non-nil");
    NSAssert( one!=_one && one!=_two, @"Spawn: reinit using same parameters is not supported");
    NSAssert( two!=_two && two!=_one, @"Spawn: reinit using same parameters is not supported");
    
    NSTimeInterval d1 = [one duration];
    NSTimeInterval d2 = [two duration];
    
    if( (self=[super initWithDuration: MAX(d1,d2)] ) ) {
        
        // XXX: Supports re-init without leaking. Fails if one==_one || two==_two
        
        _one = one;
        _two = two;
        
        if( d1 > d2 )
            _two = [CCSequence actionOne:two two:[CCDelayTime actionWithDuration: (d1-d2)] ];
        else if( d1 < d2)
            _one = [CCSequence actionOne:one two: [CCDelayTime actionWithDuration: (d2-d1)] ];
        
    }
    return self;
}

-(id) copyWithZone: (NSZone*) zone
{
    HCAction *copy = [[[self class] allocWithZone: zone] initOne: [_one copy] two: [_two copy]];
    return copy;
}


-(void) startWithTarget:(id)aTarget
{
    [super startWithTarget:aTarget];
    [_one startWithTarget:self.target];
    [_two startWithTarget:self.target];
}

-(void) stop
{
    [_one stop];
    [_two stop];
    [super stop];
}

-(void) update: (NSTimeInterval) t
{
    [_one update:t];
    [_two update:t];
}

- (HCActionInterval *) reverse
{
    return [[self class] actionOne: [_one reverse] two: [_two reverse ] ];
}
@end

#pragma mark -
#pragma mark MoveTo

@implementation CCMoveTo
+(id) actionWithDuration: (NSTimeInterval) t position: (CGPoint) p
{
	return [[self alloc] initWithDuration:t position:p ];
}

-(id) initWithDuration: (NSTimeInterval) t position: (CGPoint) p
{
	if( (self=[super initWithDuration: t]) )
		endPosition_ = p;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] position: endPosition_];
	return copy;
}

-(void) startWithTarget:(id )aTarget
{
	[super startWithTarget:aTarget];
	startPosition_ = [(UIView *)self.target center];
	delta_ = ccpSub( endPosition_, startPosition_ );
}

-(void) update: (NSTimeInterval) t
{
	[self.target setCenter: ccp( (startPosition_.x + delta_.x * t ), (startPosition_.y + delta_.y * t ) )];
}
@end


#pragma mark HCBezier
@implementation HCBezier


+(id)actionWithDuration:(NSTimeInterval)d pointNumber:(int)number withPoints:(float** (^)(void))points{
    controlPos array[number];
    float **p = points();
    for (int i = 0; i<number; i++) {
        array[i].posX = *((float*)p +i*2);
        array[i].posY = *((float*)p +i*2 +1);
    }
    return [[self alloc] initWithPoints:array pointNumber:number Duration:d];
}

+(id) actionWithPoints:(controlPos *)array pointNumber:(int)number Duration:(NSTimeInterval)t{
    return [[self alloc] initWithPoints:array pointNumber:number Duration:t];
}


-(id) initWithPoints:(controlPos *)array pointNumber:(int)number Duration:(NSTimeInterval)t{
    if (self = [super initWithDuration:t]) {
        number_ = number;
        arrayOfControlPoints = [[NSMutableArray alloc] init];
        for (int i = 0; i<number_; i++) {
            CGPoint p = ccp(array[i].posX, array[i].posY);
            [arrayOfControlPoints addObject:[NSValue valueWithCGPoint:p]];
        }
    }
    return self;
}

//阶乘
static inline int factorial(int n){
    int result = 1;
    while (n) {
        result *=n;
        n--;
    }
    return result;
}

//杨辉三角
static inline int pascalTriangleRatio(int n,int i){
    int result = 0;
    result = factorial(n)/(factorial(i)*factorial(n-i));
    return result;
}


//在t点贝塞尔多项式的和
static inline controlPos bezieerat(controlPos *p,int n,float t){
    float px =0;
    float py = 0;
    int i=0;
    while (i<=n) {
        px += pascalTriangleRatio(n, i)*p[i].posX*powf(t, i)*powf(1-t, n-i);
        py += pascalTriangleRatio(n, i)*p[i].posY*powf(t, i)*powf(1-t, n-i);
        i++;
    }
    controlPos m;
    m.posX = px;
    m.posY = py;
    return m;
}

-(void) update: (NSTimeInterval) t
{
    controlPos _controlPos[number_];
    for (int i = 0; i<number_; i++) {
        _controlPos[i].posX = [[arrayOfControlPoints objectAtIndex:i] CGPointValue].x;
        _controlPos[i].posY = [[arrayOfControlPoints objectAtIndex:i] CGPointValue].y;
        
    }
    controlPos pos = bezieerat(_controlPos, number_-1, t);
    CGPoint p = ccp(pos.posX, pos.posY);
    [self.target setCenter:p];
    
}


-(id) copyWithZone: (NSZone*) zone
{
    controlPos _controlPos[number_];
    for (int i = 0; i<number_; i++) {
        _controlPos[i].posX = [[arrayOfControlPoints objectAtIndex:i] CGPointValue].x;
        _controlPos[i].posY = [[arrayOfControlPoints objectAtIndex:i] CGPointValue].y;
    }
    
	HCAction *copy = [[[self class] allocWithZone: zone] initWithPoints:_controlPos pointNumber:number_ Duration:[self duration]];
    return copy;
}
-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	startPosition_ = [(id)self.target center];
}

-(HCActionInterval *)reverse{
    controlPos _controlPos[number_];
    for (int i= 0; i<number_  ; i++) {
        _controlPos[i].posX = [[arrayOfControlPoints objectAtIndex:number_ -i -1] CGPointValue].x;
        _controlPos[i].posY = [[arrayOfControlPoints objectAtIndex:number_ -i -1] CGPointValue].y;
    }
    HCBezier *action = [[self class] actionWithPoints:_controlPos pointNumber:number_ Duration:[self duration]];
    return action;
}
@end


#pragma mark HCWiggle
#define kHca 300.0   


@implementation HCWiggle

+(id)actionWithDuration:(NSTimeInterval)d originPoint:(CGPoint)p radius:(float)r withStartSpeed:(kHCSpeedLevel)ssl withSpeed:(kHCSpeedLevel)sl{
    return [[self alloc] initWithDuration:d originPoint:p radius:r withStartSpeed:ssl withSpeed:sl];
}
-(id)initWithDuration:(NSTimeInterval)d originPoint:(CGPoint)p radius:(float)r withStartSpeed:(kHCSpeedLevel)ssl withSpeed:(kHCSpeedLevel)sl{
    self = [self initWithDuration:d];
    if (self) {
        op = p;
        radius = r;

        switch (ssl) {
            case kHCSpeedDefault:
                v = random()%600-300;
                break;
                
            case kHCSpeedLow:
                v =300;
                break;
                
            case kHCSpeedNomal:
                v=600;
                break;
                
            case kHCSpeedHigh:
                v=900;
                break;
                
            case kHCSpeedVeryHigh:
                v = 1200;
                break;
                
            default:
                break;
        }
        float alp = random()%360/360.0*2*M_PI;
        vx = v*cosf(alp);
        vy = v*sinf(alp);

        switch (sl) {
            case kHCSpeedDefault:
                raLevelSpeed = 600;
                k = 0.01;
                break;
                
            case kHCSpeedLow:
                raLevelSpeed = 300;
                k = 0.01;
                break;
                
            case kHCSpeedNomal:
                raLevelSpeed = 600;
                k = 0.01;
                break;
                
            case kHCSpeedHigh:
                raLevelSpeed = 900;
                k = 0.001;
                break;
                
            case kHCSpeedVeryHigh:
                raLevelSpeed = 1200;
                k = 0.001;
                break;
                
            default:
                break;
        }
        
        
    }
    return self;
}
+(id)actionWithDuration:(NSTimeInterval)d originPoint:(CGPoint)p radius:(float)r{
    return [[self alloc] initWithDuration:d originPoint:p radius:r];
}
-(id)initWithDuration:(NSTimeInterval)d originPoint:(CGPoint)p radius:(float)r{
    if (self = [super initWithDuration:d]) {
        op = p;
        radius = r;
        k = 0.003;
        v = random()%600-300;
        float alp = random()%360/360.0*2*M_PI;
        vx = v*cosf(alp);
        vy = v*sinf(alp);
        raLevelSpeed = 900;
    }
    return self;
}
-(void)step:(HCScheduled *)timer{
    [super step:timer];
    float dt = timer.timeInterval;
    cd +=dt;
    if (cd>=dcd) {
        cd = 0;
        dcd = random()%3+(random()%10)/10;
        ralp = random()%360/360.0*2*M_PI;
        ra = random()%raLevelSpeed;
    }
    
    CGPoint center = [self.target center];
    
    float sx = -(center.x - op.x);
    float sy = -(center.y - op.y);
    
    float alp = atan2f(sy, sx);
    
    float ss = sqrtf(sx*sx+sy*sy);
    float f = ss==0?0:(ss/ABS(ss))*tanf(MIN(ABS(ss/radius), 0.99)*M_PI_2)*kHca;
    float ax = f*cosf(alp);
    float ay = f*sinf(alp);
    float rx = ra*cosf(ralp);
    float ry = ra*sinf(ralp);
    vx += (rx+ax)*dt;
    vy += (ry+ay)*dt;
    
    vx = (vx==0)?0:vx-k*vx*vx*dt*(vx/ABS(vx));
    vy = (vy==0)?0:vy-k*vy*vy*dt*(vy/ABS(vy));

    center = CGPointMake(center.x+vx*dt, center.y+vy*dt);
    [self.target setCenter:center];
    
}

@end

#pragma mark - CCBezierBy

// Bezier cubic formula:
//	((1 - t) + t)3 = 1
// Expands to…
//   (1 - t)3 + 3t(1-t)2 + 3t2(1 - t) + t3 = 1
static inline CGFloat bezierat( float a, float b, float c, float d, NSTimeInterval t )
{
    return (powf(1-t,3) * a +
            3*t*(powf(1-t,2))*b +
            3*powf(t,2)*(1-t)*c +
            powf(t,3)*d );
}

//
// BezierBy
//
@implementation CCBezierBy
+(id) actionWithDuration: (NSTimeInterval) t bezier:(ccBezierConfig) c
{
    return [[self alloc] initWithDuration:t bezier:c ];
}

-(id) initWithDuration: (NSTimeInterval) t bezier:(ccBezierConfig) c
{
    if( (self=[super initWithDuration: t]) ) {
        _config = c;
    }
    return self;
}

-(id) copyWithZone: (NSZone*) zone
{
    return [[[self class] allocWithZone: zone] initWithDuration:[self duration] bezier:_config];
}

-(void) startWithTarget:(id)aTarget
{
    [super startWithTarget:aTarget];
    _previousPosition = _startPosition = [(id)self.target center];
}

-(void) update: (NSTimeInterval) t
{
    CGFloat xa = 0;
    CGFloat xb = _config.controlPoint_1.x;
    CGFloat xc = _config.controlPoint_2.x;
    CGFloat xd = _config.endPosition.x;
    
    CGFloat ya = 0;
    CGFloat yb = _config.controlPoint_1.y;
    CGFloat yc = _config.controlPoint_2.y;
    CGFloat yd = _config.endPosition.y;
    
    CGFloat x = bezierat(xa, xb, xc, xd, t);
    CGFloat y = bezierat(ya, yb, yc, yd, t);
    
//    CCNode *node = (CCNode*)_target;
    
#if CC_ENABLE_STACKABLE_ACTIONS
    CGPoint currentPos = [(id)self.target center];
    CGPoint diff = ccpSub(currentPos, _previousPosition);
    _startPosition = ccpAdd( _startPosition, diff);
    
    CGPoint newPos = ccpAdd( _startPosition, ccp(x,y));
    [node setPosition: newPos];
    
    _previousPosition = newPos;
#else
    [self.target setCenter:ccpAdd( _startPosition, ccp(x,y))];
#endif // !CC_ENABLE_STACKABLE_ACTIONS
}

- (HCActionInterval*) reverse
{
    ccBezierConfig r;
    
    r.endPosition	 = ccpNeg(_config.endPosition);
    r.controlPoint_1 = ccpAdd(_config.controlPoint_2, ccpNeg(_config.endPosition));
    r.controlPoint_2 = ccpAdd(_config.controlPoint_1, ccpNeg(_config.endPosition));
    
    CCBezierBy *action = [[self class] actionWithDuration:[self duration] bezier:r];
    return action;
}
@end

//
// BezierTo
//
#pragma mark - CCBezierTo
@implementation CCBezierTo
-(id) initWithDuration: (NSTimeInterval) t bezier:(ccBezierConfig) c
{
    if( (self=[super initWithDuration: t]) ) {
        _toConfig = c;
    }
    return self;
}

-(void) startWithTarget:(id)aTarget
{
    [super startWithTarget:aTarget];
    _config.controlPoint_1 = ccpSub(_toConfig.controlPoint_1, _startPosition);
    _config.controlPoint_2 = ccpSub(_toConfig.controlPoint_2, _startPosition);
    _config.endPosition = ccpSub(_toConfig.endPosition, _startPosition);
}

-(id) copyWithZone: (NSZone*) zone
{
    return [[[self class] allocWithZone: zone] initWithDuration:[self duration] bezier:_toConfig];
}

@end

//
// ScaleTo
//
#pragma mark -
#pragma mark ScaleTo
@implementation CCScaleTo
+(id) actionWithDuration: (NSTimeInterval) t scale:(float) s
{
	return [[self alloc] initWithDuration: t scale:s];
}

-(id) initWithDuration: (NSTimeInterval) t scale:(float) s
{
	if( (self=[super initWithDuration: t]) ) {
		endScaleX_ = s;
		endScaleY_ = s;
	}
	return self;
}

+(id) actionWithDuration: (NSTimeInterval) t scaleX:(float)sx scaleY:(float)sy
{
	return [[self alloc] initWithDuration: t scaleX:sx scaleY:sy];
}

-(id) initWithDuration: (NSTimeInterval) t scaleX:(float)sx scaleY:(float)sy
{
	if( (self=[super initWithDuration: t]) ) {
		endScaleX_ = sx;
		endScaleY_ = sy;
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] scaleX:endScaleX_ scaleY:endScaleY_];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	startScaleX_ = [self.target scaleX];
	startScaleY_ = [self.target scaleY];
	deltaX_ = endScaleX_ - startScaleX_;
	deltaY_ = endScaleY_ - startScaleY_;
}

-(void) update: (NSTimeInterval) t
{
    
	[self.target setScaleX: (startScaleX_ + deltaX_ * t ) ];
	[self.target setScaleY: (startScaleY_ + deltaY_ * t ) ];
//    [self.target setTransform:CGAffineTransformMakeScale((startScaleX_ + deltaX_ * t ), (startScaleY_ + deltaY_ * t ))];
}
@end

//
// ScaleBy
//
#pragma mark -
#pragma mark ScaleBy
@implementation CCScaleBy
-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	deltaX_ = startScaleX_ * endScaleX_ - startScaleX_;
	deltaY_ = startScaleY_ * endScaleY_ - startScaleY_;
}

-(HCActionInterval*) reverse
{
	return [[self class] actionWithDuration:self.duration scaleX:1/endScaleX_ scaleY:1/endScaleY_];
}
@end


//
// FadeIn
//
#pragma mark -
#pragma mark FadeIn
@implementation CCFadeIn
-(void) update: (NSTimeInterval) t
{
    [self.target setAlpha:t];
}

-(HCActionInterval*) reverse
{
	return [CCFadeOut actionWithDuration:self.duration];
}
@end

//
// FadeOut
//
#pragma mark -
#pragma mark FadeOut
@implementation CCFadeOut
-(void) update: (NSTimeInterval) t
{
    [self.target setAlpha:(1-t)];
}

-(HCActionInterval*) reverse
{
	return [CCFadeIn actionWithDuration:self.duration];
}
@end
//
// RotateTo
//
#pragma mark -
#pragma mark RotateTo

@implementation CCRotateTo
+(id) actionWithDuration: (NSTimeInterval) t angle:(float) a
{
	return [[self alloc] initWithDuration:t angle:a ];
}

-(id) initWithDuration: (NSTimeInterval) t angle:(float) a
{
	if( (self=[super initWithDuration: t]) )
		dstAngle_ = a;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] angle:dstAngle_];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	startAngle_ = [self.target rotation_h];
	if (startAngle_ > 0)
		startAngle_ = fmodf(startAngle_, 360.0f);
	else
		startAngle_ = fmodf(startAngle_, -360.0f);
	
	diffAngle_ =dstAngle_ - startAngle_;
	if (diffAngle_ > 180)
		diffAngle_ -= 360;
	if (diffAngle_ < -180)
		diffAngle_ += 360;
}
-(void) update: (NSTimeInterval) t
{
	[self.target setRotation_h: startAngle_ + diffAngle_ * t];

}
@end


//
// RotateBy
//
#pragma mark -
#pragma mark RotateBy

@implementation CCRotateBy
+(id) actionWithDuration: (NSTimeInterval) t angle:(float) a
{
	return [[self alloc] initWithDuration:t angle:a ];
}

-(id) initWithDuration: (NSTimeInterval) t angle:(float) a
{
	if( (self=[super initWithDuration: t]) )
		angle_ = a;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] angle: angle_];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	startAngle_ = [self.target rotation_h];
}

-(void) update: (NSTimeInterval) t
{
	// XXX: shall I add % 360
	[self.target setRotation_h: (startAngle_ +angle_ * t )];
//    NSLog(@"%f",)
}

-(HCActionInterval*) reverse
{
	return [[self class] actionWithDuration:self.duration angle:-angle_];
}

@end

@implementation CCAnchorPointTo
+(id)actionWithDuration:(NSTimeInterval)duration anchorPoint:(CGPoint)p{
    return [[self alloc] initWithDuration:duration anchorPoint:p];
}
-(id)initWithDuration:(NSTimeInterval)duration anchorPoint:(CGPoint)p{
    if (self = [super initWithDuration:duration]) {
        p_ = p;
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    HCAction *copy = [[[self class] allocWithZone:zone] initWithDuration:self.duration anchorPoint:p_];
    return copy ;
}
-(void)startWithTarget:(id)target{
    [super startWithTarget:target];
    startP_ = [[self.target layer] anchorPoint];
}
-(void) update: (NSTimeInterval) t{
    CGPoint dp = ccpSub(p_, startP_);
    [[self.target layer] setAnchorPoint:CGPointMake(startP_.x+dp.x*t, startP_.y+dp.y*t)];
}
-(HCActionInterval*)reverse{
    return [[self class] actionWithDuration:self.duration anchorPoint:startP_];
}
@end
//
// JumpBy
//
#pragma mark - CCJumpBy

@implementation CCJumpBy
+(id) actionWithDuration: (NSTimeInterval) t position: (CGPoint) pos height: (NSTimeInterval) h jumps:(NSUInteger)j
{
	return [[self alloc] initWithDuration: t position: pos height: h jumps:j];
}

-(id) initWithDuration: (NSTimeInterval) t position: (CGPoint) pos height: (NSTimeInterval) h jumps:(NSUInteger)j
{
	if( (self=[super initWithDuration:t]) ) {
		delta_ = pos;
		height_ = h;
		jumps_ = j;
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] position:delta_ height:height_ jumps:jumps_];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	startPosition_ = [self.target position];
}

-(void) update: (NSTimeInterval) t
{
	// Sin jump. Less realistic
    //	NSTimeInterval y = height * fabsf( sinf(t * (CGFloat)M_PI * jumps ) );
    //	y += delta.y * t;
    //	NSTimeInterval x = delta.x * t;
    //	[target setPosition: ccp( startPosition.x + x, startPosition.y + y )];
    
	// parabolic jump (since v0.8.2)
	NSTimeInterval frac = fmodf( t * jumps_, 1.0f );
	NSTimeInterval y = height_ * 4 * frac * (1 - frac);
	y += delta_.y * t;
	NSTimeInterval x = delta_.x * t;
	[self.target setPosition: ccp( startPosition_.x + x, startPosition_.y + y )];
    
}

-(HCActionInterval*) reverse
{
	return [[self class] actionWithDuration:self.duration position: ccp(-delta_.x,-delta_.y) height:height_ jumps:jumps_];
}
@end

//
// JumpTo
//
#pragma mark - CCJumpTo

@implementation CCJumpTo
-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	delta_ = ccp( delta_.x - startPosition_.x, delta_.y - startPosition_.y );
}
@end

#pragma mark - CCDelayTime
@implementation CCDelayTime
-(void) update: (NSTimeInterval) t
{
	return;
}

-(id)reverse
{
	return [[self class] actionWithDuration:self.duration];
}
@end

@implementation HCScrewRotation

+(id)actionWithDuration:(NSTimeInterval)d radius:(float)r{
    return [[self alloc] initWithDuration:d radius:r];
}
-(id)initWithDuration:(NSTimeInterval)d radius:(float)r {
    if (self = [super initWithDuration:d]) {
        radius_ = r;
    }
    return self;
}


-(void)startWithTarget:(id)target{
    [super startWithTarget:target];
//    startPosition_ = 
}
-(void)update:(NSTimeInterval)time{
    
}

@end
