//
//  HCIdCardNoRulesChecker.h
//
//  Created by 花晨 on 15/11/24.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCIdCardNoRulesChecker : NSObject

+ (BOOL)checkIdCardNo:(NSString *)idCardNo withError:(NSError **)error;

@end
