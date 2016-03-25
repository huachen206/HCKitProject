//
//  UILabel+StringFrame.h
//  KTVGroupBuy
//
//  Created by 花晨 on 15/8/4.
//  Copyright (c) 2015年 HuaChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)
+(CGSize)boundingRectWithSize:(CGSize)size text:(NSString *)text;
- (CGSize)boundingRectWithSize:(CGSize)size;
- (CGSize)boundingRect;
@end
