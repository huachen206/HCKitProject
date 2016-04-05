//
//  UIButton+HCCheckMenu.h
//  Lottery
//
//  Created by 花晨 on 15/9/14.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CheckMenuAction)(UIButton *checkBox,NSInteger index);
@interface HCCheckMenu:NSObject
@property (nonatomic,assign) NSInteger checkNumber;
@property (nonatomic,assign) NSInteger checkedIndex;
+(instancetype)menuWithCheckBoxs:(UIButton *)checkBox,...NS_REQUIRES_NIL_TERMINATION;
-(void)addCheckBoxs:(UIButton *)checkBox,...NS_REQUIRES_NIL_TERMINATION;
-(void)checkMenuAction:(CheckMenuAction)block;

@end



@interface UIButton (HCCheckMenu)
+(HCCheckMenu *)hc_checkMenuCombiWithButton:(UIButton *)checkBox,...NS_REQUIRES_NIL_TERMINATION;

@end
