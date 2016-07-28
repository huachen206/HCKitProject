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
    }else{
        car = [[CarModel alloc] init];
        car.scientificName = @"卡车";
        car.manufacturer = @"福特";
        car.attachData = [@"this a test cat data" dataUsingEncoding:NSUTF8StringEncoding];
        car.fantasy = NO;
        car.weight = 500;
        car.maxSpeed = 160;
        car.displacement = 3.8;
        car.driver = @"hh";
        car.forIgnoreExample = [[NSObject alloc] init];
        car.wheelNumber = 8;
        [[DAO dao].carTable insertWithModel:car];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
