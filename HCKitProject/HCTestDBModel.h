//
//  HCTestDBModel.h
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+tableModel.h"


VARCHAR(20);
INTEGER_PRIMARY_KEY_AUTOINCREMENT();
INTEGER();

@interface HCTableFlg : NSObject

@end

@interface HCTestDBModel : NSObject
@property (nonatomic,assign) NSInteger TABLECOL_VAR(<INTEGER_PRIMARY_KEY_AUTOINCREMENT>,test_id);
@property (nonatomic,strong) NSString TABLECOL_OBJ(<VARCHAR_20>,*name);


+(NSDictionary *)properties_pan;
+(NSDictionary *)tableColumnAndDataType;

@end
