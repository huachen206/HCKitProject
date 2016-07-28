//
//  ViewController.m
//  HCDBDemo
//
//  Created by HuaChen on 16/7/28.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "ViewController.h"
#import "DAO.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CarModel *car;
    NSArray *carList = [[DAO dao].carTable selectAll];
    if (carList.count) {
        car = carList.firstObject;
        car.wheelNumber ++;
        [[DAO dao].carTable replaceWithModel:car];
    }else{
        car = [CarModel defaultCar];
        [[DAO dao].carTable insertWithModel:car];
    }
    
    
    [[DAO dao].carTable deleteWithModel:car];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
