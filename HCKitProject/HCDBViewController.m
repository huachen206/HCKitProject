//
//  HCDBViewController.m
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCDBViewController.h"
#import "HCTestDAO.h"
#import "HCDBModel.h"
#import "HCTestDBModel_depth2.h"
#import "HCDiskCache.h"

@interface HCDBViewController ()

@end

@implementation HCDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DB";
    
    HCTestDBModel_depth2 *db = [[HCTestDBModel_depth2 alloc] init];
    [db creatTestData];
    
    for (HCPropertyInfo *pi in [[db class] hc_propertyInfosWithdepth:2]) {
        NSLog(@"%@",pi);
    }
//    NSArray *plist = [HCTestDBModel hc_propertyNameList];
//    NSArray *fList = [HCTestDBModel tableFieldList];
    
    
    [[HCTestDAO dao].testTable insertOrReplaceWithModel:db autoPrimaryKey:YES];
    
    [[HCDiskCache diskCache] addObject:db key:@"adb"];
    
    HCTestDBModel_depth2 *adb = [[HCDiskCache diskCache] objectForKey:@"adb"];
//
    NSArray *models = [[HCTestDAO dao].testTable selectAll];
    NSLog(@"%@",models);
    
    
//    NSLog(@"%@",[[HCTestDAO dao].testTable description]);
    
    
//    NSArray *results = [[HCTestDAO dao].testTable selectAll];
//    for (HCTestDBModel *td in results) {
//        NSLog(@"name:%@ -- nickName:%@",td.name,td.nickName);
//        
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
