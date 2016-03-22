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
#import "HCDBModel.h"

@interface HCDBTableField(){
    HCPropertyInfo *_propertyInfo;
    
}

@end

@implementation HCDBTableField
@synthesize primaryKey = _primaryKey,autoIncrement=_autoIncrement;


+(NSArray *)tableFieldListWithClass:(Class)aclass{
    return [self tableFieldListWithPropertyInfos:[aclass hc_propertyInfosWithdepth:[aclass depth]]];
}
+(NSArray *)tableFieldListWithPropertyInfos:(NSArray*)pinfos{
    NSMutableArray *fieldList = [[NSMutableArray alloc] init];
    [pinfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fieldList addObject:[HCDBTableField tableFieldWithPropertyInfo:obj]];
    }];
    return [self filtTableFields:fieldList];
}

+(NSArray *)filtTableFields:(NSArray*)fieldList{
    NSMutableArray *noMarkFields = [NSMutableArray array];
    NSArray *beMarkedFields = [fieldList hc_enumerateObjectsForArrayUsingBlock:^id _Nullable(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HCDBTableField *field = (HCDBTableField *)obj;
        if ([field isBeMarked]) {
            return field;
        }else{
            [noMarkFields addObject:field];
            return nil;
        }
    }];
    
    NSArray *filtedList = [noMarkFields hc_enumerateObjectsForArrayUsingBlock:^id _Nullable(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HCDBTableField *field = (HCDBTableField *)obj;
        for (HCDBTableField *markedfield in beMarkedFields) {
            if ([markedfield.columnName isEqualToString:field.columnName]) {
                if (![markedfield.dataType isEqualToString:@"IGNORE"]) {
                    [markedfield changeDataType:field.dataType];
                }
                return nil;
            }
        }
        return field;
    }];
    
    NSArray *results =[[beMarkedFields arrayByAddingObjectsFromArray:filtedList] hc_enumerateObjectsForArrayUsingBlock:^id _Nullable(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HCDBTableField *field = (HCDBTableField *)obj;
        if (field.dataType.length) {
            if ([field.dataType isEqualToString:@"IGNORE"]) {
                return nil;
            }
            return field;
        }else{
            NSAssert(NO, @"这个类型不被支持存入SQL，请用HC_IGNORE标记");
            return nil;
        }
    }];
    return results;
}


/**
 *  NSString,char,还有数值类型可以被转换为tablefield。
 */
+(instancetype)tableFieldWithPropertyInfo:(HCPropertyInfo*)pi{
    return [[self alloc] initWithPropertyInfo:pi];
}
static NSDictionary * dataTypeEncodingDic;
-(id)initWithPropertyInfo:(HCPropertyInfo *)pi{
    if (!dataTypeEncodingDic) {
        dataTypeEncodingDic = @{
                                @"c":@"INTEGER",
                                @"i":@"INTEGER",
                                @"s":@"INTEGER",
                                @"l":@"INTEGER",
                                @"q":@"INTEGER",
                                @"C":@"INTEGER",
                                @"I":@"INTEGER",
                                @"S":@"INTEGER",
                                @"L":@"INTEGER",
                                @"Q":@"INTEGER",
                                @"f":@"REAL",
                                @"d":@"REAL",
                                @"B":@"BOOLEAN",
                                };
    }
    if (self == [super init]) {
        _propertyInfo = pi;
        if ([self isBeMarked]) {
            _columnName = [pi.propertyName substringFromIndex:@HCDBFeature.length+1];
            _dataType = [[self class] hc_sqlDataTypeWithProtocolName:pi.protocolName];
            if (_dataType.length) {
                if ([_dataType rangeOfString:@"PRIMARY KEY"].length) {
                    _primaryKey = YES;
                }
                if ([_dataType rangeOfString:@"AUTOINCREMENT"].length) {
                    _autoIncrement = YES;
                }
                if (![_dataType isEqualToString:@"IGNORE"]) {
                    _dataType = @"";
                }
            }
        }else{
            _columnName = pi.propertyName;
            if (!pi.isPrimitive) {
                if ([pi.typeClass isSubclassOfClass:[NSString class]]) {
                    _dataType = @"TEXT";
                }else if ([pi.typeClass isSubclassOfClass:[NSData class]]){
                    _dataType = @"BLOB";
                }
                else{
                }
            }else{
                _dataType = dataTypeEncodingDic[pi.typeEncoding];
            }
        }
    }
    return self;
}
-(NSString *)fieldDataType{
    NSString *fieldDataType = _dataType;
    if (self.isPrimaryKey) {
        fieldDataType = [@[fieldDataType,@"PRIMARY KEY"] componentsJoinedByString:@" "];
    }
    if (self.isAutoIncrement) {
        fieldDataType = [@[fieldDataType,@"AUTOINCREMENT"] componentsJoinedByString:@" "];
    }
    return fieldDataType;
}
-(void)changeDataType:(NSString *)dataType {
    _dataType = dataType;
}

//是否是用属性标记过的
-(BOOL)isBeMarked{
    return [_propertyInfo.propertyName hasPrefix:@HCDBFeature];
}
-(BOOL)isPrimaryKey{
    return _primaryKey;
}
-(BOOL)isAutoIncrement{
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

-(NSString *)description{
    return [NSString stringWithFormat:@"---------------------\ncoloumn name     = %@\ndata tyape       = %@\nis primarykey    = %@\nis autoIncrement = %@",self.columnName,self.dataType,self.isPrimaryKey?@"YES":@"NO",self.isAutoIncrement?@"YES":@"NO"];
    
}


@end
