//
//  LocalNotificationViewController.m
//  HCKitProject
//
//  Created by HuaChen on 16/6/20.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "LocalNotificationViewController.h"

@implementation LocalNotificationViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    
}
- (IBAction)action:(id)sender {
    NSDate *now = [NSDate new];
    NSInteger delay = 10;
    NSString *alertBody = [NSString stringWithFormat:@"now:%@,delay:%ld",now,delay];

    [[self class] registerLocalNotification:delay alertBody:alertBody];

//    int count = 6*24;
//    
//    for (int i = -count; i<count; i++) {
//        NSInteger delay = i*10*60;
//        NSString *alertBody = [NSString stringWithFormat:@"now:%@,delay:%ld",now,delay];
//        
//        [[self class] registerLocalNotification:delay alertBody:alertBody];
//        
//    }
}
- (IBAction)cancel:(id)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime alertBody:(NSString *)alertBody{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *now = [NSDate new];
    NSDate *fireDate = [now dateByAddingTimeInterval:alertTime];
    NSLog(@"fireDate=%@\n nowDate = %@",fireDate,[NSDate date]);
    
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    // 时区
    
    // 设置重复的间隔
    notification.repeatInterval = 0;
    
    // 通知内容
    notification.alertBody = alertBody;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = @"tireException.mp3";
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"胎压异常" forKey:@"key"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        //        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        //        notification.repeatInterval = NSDayCalendarUnit;
    }
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
