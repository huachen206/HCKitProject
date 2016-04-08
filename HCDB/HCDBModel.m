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
    return [HCDBTableField tableFieldListWithClass:[self class]];
}
+(NSArray *)modelListWithFmResultSet:(FMResultSet *)rs tableFields:(NSArray*)tableField{
    NSMutableArray *modelList = [NSMutableArray array];
    while ([rs next]) {
        [modelList addObject:[[self alloc] initWithFMResultSet:rs tableFields:tableField]];
    }
    [rs close];
    return modelList;
}
-(id)initWithFMResultSet:(FMResultSet *)result tableFields:(NSArray*)tableFields{
    if (self == [super init]) {
        [tableFields enumerateObjectsUsingBlock:^(HCDBTableField *tableField, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tableField.dataType isEqualToString:@"INTEGER"]) {
                [self setValue:@([result longLongIntForColumn:tableField.columnName]) forKey:tableField.columnName];
            }else if ([tableField.dataType isEqualToString:@"TEXT"]) {
                [self setValue:[result stringForColumn:tableField.columnName] forKey:tableField.columnName];
            }else if ([tableField.dataType isEqualToString:@"BOOLEAN"]) {
                [self setValue:@([result boolForColumn:tableField.columnName]) forKey:tableField.columnName];
            }else if ([tableField.dataType isEqualToString:@"REAL"]) {
                [self setValue:@([result doubleForColumn:tableField.columnName]) forKey:tableField.columnName];
            }else if ([tableField.dataType isEqualToString:@"BLOB"]){
                [self setValue:[result dataForColumn:tableField.columnName] forKey:tableField.columnName];
            }else{
                NSAssert(NO, @"还有没考虑到的吗？");
            }
         
        }];
    }
    return self;
}

+(NSInteger)depth {
    return 1;
}

@end
@implementation HCDBTableFlg



@end

