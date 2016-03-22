//
//  NSArray+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HCExtend)
-(nullable NSArray *)hc_objectAlsoIn:(nonnull NSArray *)array;
-(nullable NSArray *)hc_objectWithOut:(nonnull NSArray *)array;
-(nullable NSArray*)hc_enumerateObjectsForArrayUsingBlock:(_Nullable id(^_Nullable)(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop))usingBlock;

@end
