//
//  JSONModel.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/8.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol StudentInfo
@end

@interface StudentInfo : NSObject
@property (nonatomic,strong) NSString *studentName;
@property (nonatomic,strong) NSString *fatherName;
@property (nonatomic,strong) NSString *motherName;
@end

@interface ClassInfo : NSObject
@property (nonatomic,strong) NSString *className;
@property (nonatomic,assign) float  grade;
@property (nonatomic,strong) StudentInfo *astudentInfo;
@property (nonatomic,strong) NSArray <StudentInfo> *studentInfo;
@property (nonatomic,strong) NSArray *teacherList;


@end

