//
//  HCTestDAO.h
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCDAO.h"
#import "HCTestTable.h"

@interface HCTestDAO : HCDAO
@property (nonatomic,strong) HCTestTable *testTable;
@end
