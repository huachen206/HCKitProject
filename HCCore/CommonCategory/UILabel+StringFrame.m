//
//  UILabel+StringFrame.m
//  KTVGroupBuy
//
//  Created by 花晨 on 15/8/4.
//  Copyright (c) 2015年 HuaChen. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)
+(CGSize)boundingRectWithSize:(CGSize)size text:(NSString *)text{
    UILabel *label = [[[self class] alloc] init];
    label.text = text;
    return [label boundingRectWithSize:size];
}
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
- (CGSize)boundingRect
{
    return [self boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
}

@end
