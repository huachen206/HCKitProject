//
//  UIButton+HCCheckMenu.m
//  Lottery
//
//  Created by 花晨 on 15/9/14.
//  Copyright (c) 2015年 花晨. All rights reserved.
//

#import "UIButton+HCCheckMenu.h"
#import <objc/runtime.h>


@interface HCCheckMenu()
@property (nonatomic,strong) NSMutableArray *checkBoxList;
@property (nonatomic,strong) CheckMenuAction tapedBlock;
@end

@implementation HCCheckMenu
@synthesize checkedIndex = _checkedIndex;
+(instancetype)menuWithCheckBoxs:(UIButton *)checkBox,...NS_REQUIRES_NIL_TERMINATION{
    HCCheckMenu *menu = [[self alloc] init];
    va_list args;
    va_start(args, checkBox);
    if (checkBox) {
        [menu addCheckBox:checkBox];
        UIButton *otherbox;
        while ((otherbox = va_arg(args, UIButton *))) {
            [menu addCheckBox:otherbox];
        }
    }
    va_end(args);
    return menu;
}

-(id)init{
    if (self = [super init]) {
        self.checkBoxList = [[NSMutableArray alloc] init];
        self.checkNumber = 1;
    }
    return self;
}

-(void)checkMenuAction:(CheckMenuAction)block{
    self.tapedBlock = block;
}

-(NSInteger)checkedIndex{
    NSAssert(self.checkNumber == 1, @"单选时可用");
    return _checkedIndex;
}
-(void)setCheckedIndex:(NSInteger)checkedIndex{
    UIButton *button = self.checkBoxList[checkedIndex];
    [self checkBoxTaped:button];
}


-(void)addCheckBoxs:(UIButton *)checkBox,...NS_REQUIRES_NIL_TERMINATION{
    va_list args;
    va_start(args, checkBox);
    if (checkBox) {
        [self addCheckBox:checkBox];
        UIButton *otherbox;
        while ((otherbox = va_arg(args, UIButton *))) {
            [self addCheckBox:otherbox];
        }
    }
    va_end(args);
}


-(void)addCheckBox:(UIButton *)box{
    [self.checkBoxList addObject:box];
    [box addTarget:self action:@selector(checkBoxTaped:) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger)numberOfChecked{
    NSInteger number = 0;
    for (UIButton *checkBox in self.checkBoxList) {
        if (checkBox.selected == YES) {
            number++;
        }
    }
    return number;
}
-(void)checkBoxTaped:(UIButton *)box{
    if (self.checkNumber == 1) {
        int index = 0;
        for (UIButton *checkBox in self.checkBoxList) {
            checkBox.selected = (checkBox==box);
            if (checkBox.selected) {
                _checkedIndex = index;
            }
            index++;
        }
    }else{
        box.selected = ([self numberOfChecked] < self.checkNumber)?!box.selected:NO;
    }
    if (self.tapedBlock) {
        self.tapedBlock(box,[self.checkBoxList indexOfObject:box]);
    }
}

@end



@interface UIButton ()

@end

@implementation UIButton (HCCheckMenu)
static char const *const hc_observerKey = "hc_checkMenu";


+(HCCheckMenu *)hc_checkMenuCombiWithButton:(UIButton *)checkBox,...NS_REQUIRES_NIL_TERMINATION{
    HCCheckMenu *menu = [[HCCheckMenu alloc] init];
    va_list args;
    va_start(args, checkBox);
    if (checkBox) {
        [menu addCheckBox:checkBox];
        UIButton *otherbox;
        while ((otherbox = va_arg(args, UIButton *))) {
            [menu addCheckBox:otherbox];
        }
    }
    va_end(args);
    objc_setAssociatedObject(self, hc_observerKey, menu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    return menu;
}


@end
