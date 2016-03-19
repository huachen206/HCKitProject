//
//  HCDBModel.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/17.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCDBModel.h"
#import "FMResultSet.h"

@implementation HCDBModel
+(NSArray*)tableFieldList{
    return [HCDBTableField tableFieldListWithPropertyInfos:[self hc_propertyInfos]];
}

-(id)initWithFMResultSet:(FMResultSet *)result tableFields:(NSArray*)tableFields{
    if (self == [super init]) {
        [tableFields enumerateObjectsUsingBlock:^(HCDBTableField *tableField, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (tableField.dataType)) {
//                <#statements#>
//            }
            
        }];
    }
    return self;
}
-(id)hc_initWithFMResultSet:(FMResultSet *)result columns:(NSArray *)columns{
    if (self == [self init]) {
        for (NSString *columnName in columns) {
            HCDBTableField *tableField = [[self class] hc_propertyInfos];
        }
        NSDictionary *tmpDic = [[self class] hc_propertyNameAndClassName];
        NSArray *propertyNames;
        if (columns) {
            propertyNames =[tmpDic.allKeys hc_objectAlsoIn:columns];
        }else{
            propertyNames = tmpDic.allKeys;
        }
        for (NSString *propertyName in propertyNames) {
            NSString *className = [tmpDic objectForKey:propertyName];
            if ([className isEqualToString:NSStringFromClass([NSString class])]) {
                [self setValue:[result stringForColumn:propertyName] forKey:propertyName];
            }else if ([className isEqualToString:@"NSInteger"]){
                [self setValue:@([result longForColumn:propertyName]) forKey:propertyName];
            }else if ([className isEqualToString:@"double"]||[className isEqualToString:@"float"]){
                [self setValue:@([result doubleForColumn:propertyName]) forKey:propertyName];
            }else if ([className isEqualToString:@"int"]){
                [self setValue:@([result intForColumn:propertyName]) forKey:propertyName];
            }else if ([className isEqualToString:@"bool"]){
                [self setValue:@([result boolForColumn:propertyName]) forKey:propertyName];
            }else if ([className isEqualToString:@"char"]){
                [self setValue:@([result intForColumn:propertyName]) forKey:propertyName];
            }
            else{
                NSAssert(NO, @"添加更多的类型吧");
            }
            //TODO:判断更多的类型
        }
    }
    return self;
}

@end
