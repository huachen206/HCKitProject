//
//  NSObject+tableModel.m
//  KTVGroupBuy
//
//  Created by 花晨 on 15/8/31.
//  Copyright (c) 2015年 HuaChen. All rights reserved.
//

#import "NSObject+tableModel.h"
#import "objc/runtime.h"

@implementation NSObject (tableModel)
+(NSArray *)modelListWithDicArray:(NSArray *)array{
    NSMutableArray *modelList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        [modelList addObject:[[self alloc] initWithDictionary:dic]];
    }
    return modelList;
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self = [self init]) {
        NSArray *propertyNames = [[self class] properties];
        for (NSString *propertyName in propertyNames) {
            id value = [dic objectForKey:propertyName];
            if (value) {
                [self setValue:value forKey:propertyName];
            }
        }
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)dic addOther:(NSDictionary *)ortherDic{
    NSMutableDictionary *totalDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [totalDic setDictionary:ortherDic];
    return [self initWithDictionary:totalDic];
}
-(id)initWithFMResultSet:(FMResultSet *)result columns:(NSArray *)columns{
    if (self = [self init]) {
        NSDictionary *tmpDic = [[self class] properties_pan];
        NSArray *propertyNames;
        if (columns) {
            propertyNames =[self objectIn:tmpDic.allKeys andIn:columns];
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

-(id)initWithFMResultSet:(FMResultSet *)result{
    return [self initWithFMResultSet:result columns:nil];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self)
    {
        for (NSString *property in [[self class] properties]) {
            [self setValue:[aDecoder decodeObjectForKey:property] forKey:property];
        }
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *property in [[self class] properties]) {
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
}


- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

+(NSDictionary *)properties_pan{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        const char* char_a =property_getAttributes(property);
        NSString *propertyClassName = [NSString stringWithUTF8String:char_a];
//        NSLog(@"%@",propertyClassName);
        if ([propertyClassName hasPrefix:@"T@"])//这是一个对象
        {
            propertyClassName = [[propertyClassName componentsSeparatedByString:@","] firstObject];
            propertyClassName = [propertyClassName substringFromIndex:3];
            propertyClassName = [propertyClassName substringToIndex:propertyClassName.length-1];
        }else if([propertyClassName hasPrefix:@"Tq,N"])//NSInteger,long,long long
        {
            propertyClassName = @"NSInteger";
        }else if([propertyClassName hasPrefix:@"TQ,N"])//NSUInteger
        {
            propertyClassName = @"NSUInteger";
        }else if([propertyClassName hasPrefix:@"Ti,N"])//int
        {
            propertyClassName = @"int";

        }else if([propertyClassName hasPrefix:@"Tf,N"])//float
        {
            propertyClassName = @"float";

        }else if([propertyClassName hasPrefix:@"Td,N"])//double
        {
            propertyClassName = @"double";
        }else if([propertyClassName hasPrefix:@"Tc,N"])//char
        {
            propertyClassName = @"char";
        }else if ([propertyClassName hasPrefix:@"TB,N"])//bool
        {
            propertyClassName = @"bool";
        }
        else{
            NSAssert1(NO, @"未知类型，增加判断 %@", propertyClassName);
        }
        [props setObject:propertyClassName forKey:propertyName];
    }
    free(properties);
    return props;
    
}
+(NSArray*)propertieClassNames{
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getAttributes(property);
        NSString *propertyClassName = [NSString stringWithUTF8String:char_f];
        propertyClassName = [[propertyClassName componentsSeparatedByString:@","] firstObject];
        propertyClassName = [propertyClassName substringFromIndex:3];
        propertyClassName = [propertyClassName substringToIndex:propertyClassName.length-1];

        [props addObject:propertyClassName];
    }
    free(properties);
    return props;

}

+ (NSArray *)properties
{
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);
    return props;
}
-(NSArray *)objectIn:(NSArray *)array1 andIn:(NSArray *)array2{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",array2];
    NSArray * filter = [array1 filteredArrayUsingPredicate:filterPredicate];
    return filter;
}

@end
