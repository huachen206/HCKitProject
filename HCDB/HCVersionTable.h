//
//  HCVersionTable.h
//  HCKitProject
//
//  Created by HuaChen on 16/4/8.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCDBTable.h"

@interface HCVersionModel: HCDBModel
@property (nonatomic,strong) NSString *HC_PRIMARY_KEY(tableName);
@property (nonatomic,assign) NSInteger version;
@end

@interface HCVersionTable : HCDBTable
-(HCVersionModel *)versionModelWithTableName:(NSString *)tableName;

@end
