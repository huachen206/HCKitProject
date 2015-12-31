//
//  HCTestTable.m
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCTestTable.h"
@implementation HCTestTable
+(instancetype)table{
    HCTestTable *table = [[self alloc] init];
    table.columns = [NSMutableDictionary dictionaryWithDictionary:[HCTestDBModel tableColumnAndDataType]];
    return table;
}

-(Class)tableModelClass{
    return [HCTestDBModel class];
}

@end
