//
//  DAO.h
//  HCDBDemo
//
//  Created by HuaChen on 16/7/28.
//  Copyright © 2016年 HuaChen. All rights reserved.
//

#import "HCDAO.h"
#import "Table_carModel.h"
#import "Table_planeModel.h"
@interface DAO : HCDAO
@property (nonatomic,strong) Table_carModel *carTable;
@property (nonatomic,strong) Table_planeModel *planeTable;
+(instancetype)daoWithAccount:(NSString*)name;

@end
