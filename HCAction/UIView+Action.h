//
//  UIView+Action.h
//  Russianalphabet
//
//  Created by HuaChen on 13-8-22.
//  Copyright (c) 2013年 HuaChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCAction;
@interface UIView (Action)
@property(nonatomic,assign)BOOL isRunning;

@property(nonatomic,assign)float scaleX;
@property(nonatomic,assign)float scaleY;

@property(nonatomic,assign)float rotation_h;

@property(nonatomic,strong)NSMutableArray *actions;
-(void)removeAction:(HCAction*)action;

-(HCAction *)runAction:(HCAction*)action;
-(void)stopAction:(HCAction *)action;
-(void)setScale:(float)f;
-(void)stopAllAction;
-(int)numberOfActions;
-(void)pauseAllAction;
-(void)resumAllAction;
@end
