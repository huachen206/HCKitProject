//
//  HCMainTableViewTableViewController.m
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCMainTableViewTableViewController.h"
#import "HCDBViewController.h"
#import "ClassInfo.h"
@interface HCMainTableViewTableViewController ()

@end

@implementation HCMainTableViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"main";
    
    NSDictionary *dic = @{@"className":@"高二",@"grade":@"99",@"astudentInfo":@{@"studentName":@"王五",@"fatherName":@"王父",@"motherName":@"王母"},@"studentInfo":@[@{@"studentName":@"张三",@"fatherName":@"张父",@"motherName":@"张母"},@{@"studentName":@"李四",@"fatherName":@"李父",@"motherName":@"李母"},@{@"studentName":@"王五",@"fatherName":@"王父",@"motherName":@"王母"}],@"teacherList":@[@"赵老师",@"吴老师"]};
    ClassInfo *classInfo = [[ClassInfo alloc] hc_initWithDictionary:dic];
    
    [classInfo hc_debugLog];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.textLabel.text = @"DBPackage";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HCDBViewController *dbv = [self.storyboard instantiateViewControllerWithIdentifier:@"DBVCID"];
    [self.navigationController pushViewController:dbv animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
