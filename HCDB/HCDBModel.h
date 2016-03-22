//
//  HCDBModel.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/17.
//  Copyright © 2016年 花晨. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "NSObject+HCDBExtend.h"
#import "HCPropertyInfo.h"
#import "HCMethodInfo.h"
#import "HCDBTableField.h"

@protocol INTEGER
@end
@protocol TEXT
@end
@protocol BLOB
@end
@protocol BOOLEAN
@end
@protocol REAL
@end

@protocol PRIMARY_KEY
@end
@protocol AUTOINCREMENT
@end

@protocol PRIMARY_KEY_AUTOINCREMENT
@end
@protocol IGNORE
@end

#define HCDBFeature "A8BB31B5B938FBCF"

#define _CreatTableFlgPropertayWithProtocol(propertyName,protocol) propertyName;\
@property (nonatomic,strong) HCDBTableFlg protocol *A8BB31B5B938FBCF_##propertyName

#define HC_IGNORE(propertyName)\
_CreatTableFlgPropertayWithProtocol(propertyName,<IGNORE>)

#define HC_PRIMARY_KEY(propertyName)\
_CreatTableFlgPropertayWithProtocol(propertyName,<PRIMARY_KEY>)

#define HC_AUTOINCREMENT(propertyName)\
_CreatTableFlgPropertayWithProtocol(propertyName,<AUTOINCREMENT>)

#define HC_PRIMARY_KEY_AUTOINCREMENT(propertyName)\
_CreatTableFlgPropertayWithProtocol(propertyName,<PRIMARY_KEY_AUTOINCREMENT>)


@class FMResultSet;
@interface HCDBModel : NSObject
+(NSArray*)tableFieldList;
-(id)initWithFMResultSet:(FMResultSet *)result tableFields:(NSArray*)tableFields;
@end
@interface HCDBTableFlg : NSObject

@end

