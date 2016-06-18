//
//  HCTestDBModel.m
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCTestDBModel.h"

@implementation HCTestDBModel
-(id)init{
    if (self == [super init]) {
        
    }
    return self;
}
-(void)creatTestData{
    self.astring = @"astring";
    self.aint = 1234;
    self.achar = 98;
    self.abool = YES;
    self.ashort = 4;
    self.along = 8;
    self.afloat = 10.5;
    self.adouble = 9.7;
    self.adata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HCEncoding" ofType:@"plist"]];
    self.nsnumber = @(1022.0034);
    
    
}

@end
