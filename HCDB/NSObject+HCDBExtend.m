//
//  NSObject+HCDBExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/3.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSObject+HCDBExtend.h"
#import "objc/runtime.h"
#import "FMResultSet.h"

@implementation NSObject (HCDBExtend)
+(NSArray *)hc_modelListWithDicArray:(NSArray *)array{
    NSMutableArray *modelList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        [modelList addObject:[[self alloc] hc_initWithDictionary:dic]];
    }
    return modelList;
}
-(id)hc_initWithDictionary:(NSDictionary *)dic{
    if (self == [self init]) {
        NSArray *propertyNames = [[self class] hc_propertyNameList];
        for (NSString *propertyName in propertyNames) {
            id value = [dic objectForKey:propertyName];
            if (value) {
                [self setValue:value forKey:propertyName];
            }
        }
    }
    return self;
}
-(id)hc_initWithDictionary:(NSDictionary *)dic addOther:(NSDictionary *)ortherDic{
    NSMutableDictionary *totalDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [totalDic setDictionary:ortherDic];
    return [self hc_initWithDictionary:totalDic];
}
-(id)hc_initWithFMResultSet:(FMResultSet *)result columns:(NSArray *)columns{
    if (self == [self init]) {
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

-(id)hc_initWithFMResultSet:(FMResultSet *)result{
    return [self hc_initWithFMResultSet:result columns:nil];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self)
    {
        for (NSString *property in [[self class] hc_propertyNameList]) {
            [self setValue:[aDecoder decodeObjectForKey:property] forKey:property];
        }
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *property in [[self class] hc_propertyNameList]) {
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
}

+ (NSArray *)hc_propertyNameList
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
+(NSDictionary *)hc_propertyNameAndClassName{
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
        NSLog(@"%@",propertyClassName);
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

+(NSDictionary *)hc_columnAndSqlDataType{
    NSMutableDictionary *colunms = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSScanner* scanner = nil;
    
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([propertyName hasSuffix:@"_HCTABLECOL"]) {
            //get property attributes
            const char *attrs = property_getAttributes(property);
            NSString* propertyAttributes = @(attrs);
            NSLog(@"%@",propertyAttributes);
            scanner = [NSScanner scannerWithString: propertyAttributes];
            [scanner scanUpToString:@"T" intoString: nil];
            [scanner scanString:@"T" intoString:nil];
            NSString* propertyType = nil;
            
            if ([scanner scanString:@"@\"" intoString: &propertyType]) {
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                        intoString:&propertyType];
                
                while ([scanner scanString:@"<" intoString:NULL]) {
                    NSString* protocolName = nil;
                    [scanner scanUpToString:@">" intoString: &protocolName];
                    NSString *dataType = [self hc_sqlDataTypeWithProtocolName:protocolName];
                    propertyName = [propertyName substringToIndex:[propertyName rangeOfString:@"_HCTABLECOL"].location];
                    [colunms setValue:dataType forKey:propertyName];
                    NSLog(@"dataType:%@----propertyName:%@",dataType,propertyName);
                    [scanner scanString:@">" intoString:NULL];
                }
                NSLog(@"propertyType:%@",propertyType);
            }
        }
    }
    return colunms;
}
/**
 *  从构造的协议名称中获取sql数据类型
 *
 *  @param protocolName 属性协议名称
 *
 *  @return sql数据类型
 */
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

- (NSDictionary *)hc_propertyNameAndValue
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

@end

@implementation NSArray(HCDBExtend)
-(NSArray *)hc_objectAlsoIn:(NSArray *)array{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",array];
    NSArray * filter = [self filteredArrayUsingPredicate:filterPredicate];
    return filter;
}
@end

