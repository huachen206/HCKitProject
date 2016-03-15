//
//  HCDBViewController.m
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCDBViewController.h"
#import "HCTestDAO.h"

@interface HCDBViewController ()

@end

@implementation HCDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DB";
    
//    [HCTestDBModel properties_pan];
//    NSDictionary *column =  [HCTestDBModel tableColumnAndDataType];
    
    HCTestDBModel *db = [[HCTestDBModel alloc] init];
    db.name = @"feixiao";
    db.nickName = @"a dog";
    db.atext = @"atextatextatextatextatextatextatextatextatextatextatextatextatextatext";
    db.abool = NO;
    
    [[HCTestDAO dao].testTable insertOrReplaceWithModel:db isIgnorePrimaryKey:YES];
    
    NSArray *models = [[HCTestDAO dao].testTable selectAll];
    
    NSLog(@"%@",[[HCTestDAO dao].testTable description]);
    
    
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
