//
//  HCDBTableField.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/17.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCDBTableField.h"
#import "HCPropertyInfo.h"
#import "NSObject+HCDBExtend.h"

@interface HCDBTableField(){
    HCPropertyInfo *_propertyInfo;
    
}

@end
@implementation HCDBTableField
@synthesize primaryKey = _primaryKey,autoIncrement=_autoIncrement;

+(instancetype)tableFieldWithPropertyInfo:(HCPropertyInfo*)pi{
    return [[self alloc] initWithPropertyInfo:pi];
}
-(id)initWithPropertyInfo:(HCPropertyInfo *)pi{
    if (self == [super init]) {
        if ([pi.propertyName hasPrefix:@HCDBFeature]) {
            _columnName = [pi.propertyName substringFromIndex:@HCDBFeature.length+1];
            if (!pi.isPrimitive) {
                _dataType = [[self class] hc_sqlDataTypeWithProtocolName:pi.protocolName];
            }
        }else{
            _columnName = pi.propertyName;
            if (!pi.isPrimitive) {
                
            }else{
                
            }
        }
        
    }
    return self;
}
-(BOOL)isPrimaryKey{
    if (self.dataType.length) {
        if ([self.dataType rangeOfString:@"PRIMARY KEY"].length) {
            _primaryKey = YES;
        }
    }
    return _primaryKey;
}
-(BOOL)isAutoIncrement{
    if (self.dataType.length) {
        if ([self.dataType rangeOfString:@"AUTOINCREMENT"].length) {
            _autoIncrement = YES;
        }
    }
    return _autoIncrement;
}

+(NSString *)hc_sqlDataTypeWithProtocolName:(NSString *)protocolName{
    NSArray* attributeItems = [protocolName componentsSeparatedByString:@"_"];
    NSString *sqlDataType = [attributeItems componentsJoinedByString:@" "];
    
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    int value =[[sqlDataType stringByTrimmingCharactersInSet:nonDigits] intValue];
    
    if (value) {
        NSMutableString *mutDataType = [NSMutableString stringWithString:sqlDataType];
        [mutDataType replaceCharactersInRange:[sqlDataType rangeOfString:[@(value) stringValue]] withString:[NSString stringWithFormat:@"(%d)",value]];
        sqlDataType = mutDataType;
    }
    return sqlDataType;
}

@end
