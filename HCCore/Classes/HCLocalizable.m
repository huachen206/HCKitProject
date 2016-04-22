//
//  HCLocalizable.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCLocalizable.h"
#import <UIKit/UIKit.h>
#import "UIDevice+HCExtend.h"

@implementation HCLocalizable
static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    return bundle;
}

+(void)initUserLanguage{
    NSString *userLanguage = [self userLanguage];
    if(userLanguage.length == 0){//如果没有设置过，则设置为系统语言
        [self setAppleLanguages];
    }else{
        [self setUserlanguage:userLanguage];
    }
}

+(NSString *)userLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"userLanguage"];
    return language;
}

+(void)setUserlanguage:(NSString *)language{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}

+(void)setAppleLanguages{
    //设置为系统当前语言版本
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [def objectForKey:@"AppleLanguages"];
    NSString *current = [languages objectAtIndex:0];
    
    if ([UIDevice hc_isIOSGreaterThan:9.0]) {
        NSMutableArray *tmp = [current componentsSeparatedByString:@"-"].mutableCopy;
        if (tmp.count>1) {
            [tmp removeObjectAtIndex:tmp.count-1];
        }
        current = [tmp componentsJoinedByString:@"-"];
    }
    [self setUserlanguage:current];
}

@end
