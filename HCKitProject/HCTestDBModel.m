//
//  HCTestDBModel.m
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import "HCTestDBModel.h"
#import "objc/runtime.h"

@implementation HCTestDBModel
-(id)init{
    if (self == [super init]) {
        
    }
    return self;
}


+(NSDictionary *)tableColumnAndDataType{
    NSMutableDictionary *colunms = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSScanner* scanner = nil;

    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([propertyName hasSuffix:@"TABLECOL"]) {
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
                    NSString *dataType = [self dataTypeWithProtocolName:protocolName];
                    propertyName = [propertyName substringToIndex:[propertyName rangeOfString:@"TABLECOL"].location];
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

+(NSString *)dataTypeWithProtocolName:(NSString *)protocolName{
    NSArray* attributeItems = [protocolName componentsSeparatedByString:@"_"];
    NSString *dataType = [attributeItems componentsJoinedByString:@" "];
    
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    int value =[[dataType stringByTrimmingCharactersInSet:nonDigits] intValue];
    
    if (value) {
        NSMutableString *mutDataType = [NSMutableString stringWithString:dataType];
        [mutDataType replaceCharactersInRange:[dataType rangeOfString:[@(value) stringValue]] withString:[NSString stringWithFormat:@"(%d)",value]];
        dataType = mutDataType;
    }
    return dataType;
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
//        if ([propertyName hasSuffix:@"TABLECOL"]) {
//            continue;
//        }else{
//            
//        }
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

@end
