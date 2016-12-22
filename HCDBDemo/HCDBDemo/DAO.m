//
//  DAO.m
//  HCDBDemo
//
//  Created by HuaChen on 16/7/28.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "DAO.h"

@implementation DAO
+(instancetype)daoWithAccount:(NSString*)name{
    NSString *dbpath = [[[getDocumentPath() stringByAppendingPathComponent:@"testFileFold"] stringByAppendingPathComponent:@"testFileFoldEx"] stringByAppendingPathComponent:name];
    return [self daoWithDBPath:dbpath];
}
@end
