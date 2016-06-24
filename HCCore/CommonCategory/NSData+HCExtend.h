//
//  NSData+HCExtend.h
//  HCKitProject
//
//  Created by HuaChen on 16/6/24.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HCExtend)
@end
@interface NSData (HCJSON)
/**
 *  生成JSON对象
 *
 */
-(id)hc_jsonValue;
@end
