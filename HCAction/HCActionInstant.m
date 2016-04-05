/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#import "HCActionInstant.h"


//
// InstantAction
//
#pragma mark HCActionInstant

@implementation HCActionInstant

-(id) init
{
	if( (self=[super init]) )
		self.duration = 0;

	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCActionInstant *copy = [[[self class] allocWithZone: zone] init];
	return copy;
}

- (BOOL) isDone
{
	return YES;
}
-(void)step:(HCScheduled *)timer{
    [self update: 1];

}

-(void) update: (NSTimeInterval) t
{
	// nothing
}

-(HCFiniteTimeAction*) reverse
{
	return [self copy];
}
@end

//
// Show
//
#pragma mark CCShow

@implementation CCShow
-(void) update:(NSTimeInterval)time
{
    UIView *view = (UIView *)self.target;
	view.hidden = NO;
}

-(HCFiniteTimeAction*) reverse
{
	return [CCHide action];
}
@end

//
// Hide
//
#pragma mark CCHide

@implementation CCHide
-(void) update:(NSTimeInterval)time
{
    UIView *view = (UIView *)self.target;
	view.hidden = YES;
}

-(HCFiniteTimeAction*) reverse
{
	return [CCShow action];
}
@end

//
// ToggleVisibility
//
#pragma mark CCToggleVisibility

@implementation CCToggleVisibility
-(void) update:(NSTimeInterval)time
{
    UIView *view = (UIView *)self.target;
	view.hidden = !view.hidden;

}
@end


//
// Place
//
#pragma mark CCPlace

@implementation CCPlace
+(id) actionWithPosition: (CGPoint) pos
{
	return [[self alloc]initWithPosition:pos];
}

-(id) initWithPosition: (CGPoint) pos
{
	if( (self=[super init]) )
		position = pos;

	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCActionInstant *copy = [[[self class] allocWithZone: zone] initWithPosition: position];
	return copy;
}

-(void) update:(NSTimeInterval)time
{
//	self.target.position = position;
    [self.target setPosition:position];
}

@end

//
// CallFunc
//
#pragma mark CCCallFunc

@implementation CCCallFunc

@synthesize targetCallback = targetCallback_;

+(id) actionWithTarget: (id) t selector:(SEL) s
{
	return [[self alloc] initWithTarget: t selector: s];
}

-(id) initWithTarget: (id) t selector:(SEL) s
{
	if( (self=[super init]) ) {
		self.targetCallback = t;
		selector_ = s;
	}
	return self;
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %p | Tag = %ld | selector = %@>",
			[self class],
			self,
			(long)self.tag,
			NSStringFromSelector(selector_)
			];
}

-(void) dealloc
{
	targetCallback_ = nil;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCActionInstant *copy = [[[self class] allocWithZone: zone] initWithTarget:targetCallback_ selector:selector_];
	return copy;
}

-(void) update:(NSTimeInterval)time
{
	[self execute];
}

-(void) execute
{
    SuppressPerformSelectorLeakWarning(
    [targetCallback_ performSelector:selector_];
                                       );
}
@end

//
// CallFuncN
//
#pragma mark CCCallFuncN

@implementation CCCallFuncN

-(void) execute
{
    SuppressPerformSelectorLeakWarning(
	[targetCallback_ performSelector:selector_ withObject:self.target];
                                       );
}
@end

//
// CallFuncND
//
#pragma mark CCCallFuncND

@implementation CCCallFuncND

@synthesize callbackMethod = callbackMethod_;

+(id) actionWithTarget:(id)t selector:(SEL)s data:(void*)d
{
	return [[self alloc] initWithTarget:t selector:s data:d];
}

-(id) initWithTarget:(id)t selector:(SEL)s data:(void*)d
{
	if( (self=[super initWithTarget:t selector:s]) ) {
		data_ = d;

#if COCOS2D_DEBUG
		NSMethodSignature * sig = [t methodSignatureForSelector:s]; // added
		NSAssert(sig !=0 , @"Signature not found for selector - does it have the following form? -(void)name:(id)sender data:(void*)data");
#endif
		callbackMethod_ = (CC_CALLBACK_ND) [t methodForSelector:s];
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCActionInstant *copy = [[[self class] allocWithZone: zone] initWithTarget:targetCallback_ selector:selector_ data:data_];
	return copy;
}

-(void) dealloc
{
	// nothing to dealloc really. Everything is dealloc on super (CCCallFuncN)
//	[super dealloc];
}

-(void) execute
{
	callbackMethod_(targetCallback_,selector_,self.target, data_);
}
@end

@implementation CCCallFuncO
@synthesize  object = object_;

+(id) actionWithTarget: (id) t selector:(SEL) s object:(id)object
{
	return [[self alloc] initWithTarget:t selector:s object:object];
}

-(id) initWithTarget:(id) t selector:(SEL) s object:(id)object
{
	if( (self=[super initWithTarget:t selector:s] ) )
		self.object = object;

	return self;
}

- (void) dealloc
{
    object_ = nil;
//	[object_ release];
//	[super dealloc];
}

-(id) copyWithZone: (NSZone*) zone
{
	HCActionInstant *copy = [[[self class] allocWithZone: zone] initWithTarget:targetCallback_ selector:selector_ object:object_];
	return copy;
}


-(void) execute
{
    SuppressPerformSelectorLeakWarning(
	[targetCallback_ performSelector:selector_ withObject:object_];
                                       );
}

@end


#pragma mark -
#pragma mark Blocks

#pragma mark CCCallBlock

@implementation CCCallBlock

+(id) actionWithBlock:(void(^)())block
{
	return [[self alloc] initWithBlock:block];
}

-(id) initWithBlock:(void(^)())block
{
	if ((self = [super init]))
		block_ = [block copy];

	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCActionInstant *copy = [[[self class] allocWithZone: zone] initWithBlock:block_];
	return copy;
}

-(void) update:(NSTimeInterval)time
{
	[self execute];
}

-(void) execute
{
	block_();
}

-(void) dealloc
{
    block_ = nil;
//	[block_ release];
//	[super dealloc];
}

@end

#pragma mark CCCallBlockN

@implementation CCCallBlockN

+(id) actionWithBlock:(void(^)(CCNode *node))block
{
	return [[self alloc] initWithBlock:block];
}

-(id) initWithBlock:(void(^)(CCNode *node))block
{
	if ((self = [super init]))
		block_ = [block copy];

	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCActionInstant *copy = [[[self class] allocWithZone: zone] initWithBlock:block_];
	return copy;
}

-(void) update:(NSTimeInterval)time
{
	[self execute];
}

-(void) execute
{
	block_(self.target);
}

-(void) dealloc
{
    block_ = nil;
//	[block_ release];
//	[super dealloc];
}

@end

#pragma mark CCCallBlockO

@implementation CCCallBlockO

@synthesize object=object_;

+(id) actionWithBlock:(void(^)(id object))block object:(id)object
{
	return [[self alloc] initWithBlock:block object:object];
}

-(id) initWithBlock:(void(^)(id object))block object:(id)object
{
	if ((self = [super init])) {
		block_ = [block copy];
		object_ = object;
	}

	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HCActionInstant *copy = [[[self class] allocWithZone: zone] initWithBlock:block_];
	return copy;
}

-(void) update:(NSTimeInterval)time
{
	[self execute];
}

-(void) execute
{
	block_(object_);
}

-(void) dealloc
{
    object_ = nil;
    block_ = nil;
//	[object_ release];
//	[block_ release];

//	[super dealloc];
}

@end

