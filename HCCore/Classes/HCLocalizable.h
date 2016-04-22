//
//  HCLocalizable.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HCLocalizedString(key) [[HCLocalizable bundle] localizedStringForKey:key value:@"" table:nil]

@interface HCLocalizable : NSObject
+(NSBundle *)bundle;/**< 获取当前资源文件*/

+(void)initUserLanguage;/**<初始化语言文件*/

+(NSString *)userLanguage;/**<获取应用当前语言*/

+(void)setUserlanguage:(NSString *)language;/**<设置当前语言*/

+(void)setAppleLanguages;/**<设置为系统当前语言版本*/
@end
