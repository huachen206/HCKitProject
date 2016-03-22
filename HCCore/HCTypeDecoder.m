//
//  HCTypeDecoder.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/17.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCTypeDecoder.h"
static NSString * const kHCEncodingMapFile = @"HCEncoding";
static NSString * const kHCPlistExtension = @"plist";
static NSString * const kHCPointerFormat = @"%@ *";
static NSString * const kHCArrayFormat = @"%@[]";
static NSString * const kHCBitfieldFormat = @"bitfield(%@)";
static NSString * const kHCUnionFormat = @"union %@";
static NSString * const kHCStructFormat = @"struct %@";
static NSString * const kHCFixedArrayFormat = @"%@[%ld]";
static NSDictionary *kHCMapDictionary;

static NSString * const kHCObjectTypeEncoding = @"@\"";
static NSString * const kHCArrayEncoding = @"[]";
static NSString * const kHCBitFieldEncoding = @"b";
static NSString * const kHCStructEncoding = @"{}";
static NSString * const kHCUnionEncoding = @"()";
static NSString * const kHCAssignmentOperator = @"=";
static NSString * const kHCPointerToTypeEncoding = @"^";
static NSString * const kHCDereferenceOperator = @"*";
static NSString * const kHCClassPrefix = @"@";
@interface HCTypeDecoder()
+ (NSCharacterSet *)HC_pointerCharacterSet;
+ (NSCharacterSet *)HC_objectTypeEncodingCharacterSet;
+ (NSCharacterSet *)HC_valueTypePointerEncodingCharacterSet;
+ (NSCharacterSet *)HC_structEncodingCharacterSet;
+ (NSCharacterSet *)HC_unionEncodingCharacterSet;
+ (NSCharacterSet *)HC_bitFieldEncodingCharacterSet;
+ (NSCharacterSet *)HC_arrayEncodingCharacterSet;
+ (NSCharacterSet *)HC_fixedArrayEncodingCharacterSet;
+ (BOOL)HC_isPrefix:(NSCharacterSet *)prefixSet inString:(NSString *)string;

@end

@implementation HCTypeDecoder
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * const path = [[NSBundle bundleForClass:self] pathForResource:kHCEncodingMapFile ofType:kHCPlistExtension];
        kHCMapDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    });
}

+ (NSString *)nameFromTypeEncoding:(NSString *)encoding {
    NSString *result = nil;
    
    if ([encoding length] == 1) {
        result = kHCMapDictionary[encoding];
    }
    else {
        result = [self checkCustomEncoding:encoding];
    }
    
    if ([result length] == 0) {
        // in case no match is found, a fail-safe solution is to keep the encoding itself
        result = [encoding copy];
    }
    
    return result;
}
+ (NSString *)checkCustomEncoding:(NSString *)encoding {
    id result;
    if ([self HC_isPrefix:[self HC_objectTypeEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kHCPointerFormat, [encoding stringByTrimmingCharactersInSet:[self HC_objectTypeEncodingCharacterSet]]];
    }
    else if ([self HC_isPrefix:[self HC_valueTypePointerEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kHCPointerFormat, [self nameFromTypeEncoding:[encoding stringByTrimmingCharactersInSet:[self HC_valueTypePointerEncodingCharacterSet]]]];
    }
    else if ([self HC_isPrefix:[self HC_arrayEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kHCArrayFormat, [self nameFromTypeEncoding:[encoding stringByTrimmingCharactersInSet:[self HC_arrayEncodingCharacterSet]]]];
    }
    else if ([self HC_isPrefix:[self HC_bitFieldEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kHCBitfieldFormat, [encoding stringByTrimmingCharactersInSet:[self HC_bitFieldEncodingCharacterSet]]];
    }
    else if ([self HC_isPrefix:[self HC_structEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kHCStructFormat, [encoding stringByTrimmingCharactersInSet:[self HC_structEncodingCharacterSet]]];
    }
    else if ([self HC_isPrefix:[self HC_unionEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kHCUnionFormat, [encoding stringByTrimmingCharactersInSet:[self HC_unionEncodingCharacterSet]]];
    }
    else if ([self HC_isPrefix:[NSCharacterSet decimalDigitCharacterSet] inString:encoding] && [encoding rangeOfCharacterFromSet:[self HC_valueTypePointerEncodingCharacterSet]].location != NSNotFound) {
        // in case the encoding is a fixed size c-style array, then the numbers preceding the '^' sign is the length of it
        // the long casts are required for the %ld format specifier, which in turn is needed for the mac-compatibility, where NSInteger is long instead of int.
        NSInteger arraySize = 0;
        [[NSScanner scannerWithString:encoding] scanInteger:&arraySize];
        NSString * const typeEncoding = [encoding stringByTrimmingCharactersInSet:[self HC_fixedArrayEncodingCharacterSet]];
        NSString * const type = [self nameFromTypeEncoding:typeEncoding];
        result = [NSString stringWithFormat:kHCFixedArrayFormat, type, (long)arraySize];
    }
    
    return result;
}
static NSMutableCharacterSet * RFPointerCharacterSet = nil;
static NSMutableCharacterSet * RFObjectTypeEncodingCharacterSet = nil;

+ (NSCharacterSet *)HC_pointerCharacterSet {
    if (!RFPointerCharacterSet) {
        RFPointerCharacterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [RFPointerCharacterSet addCharactersInString:kHCDereferenceOperator];
    }
    
    return RFPointerCharacterSet;
}

+ (NSCharacterSet *)HC_objectTypeEncodingCharacterSet {
    if (!RFObjectTypeEncodingCharacterSet) {
        RFObjectTypeEncodingCharacterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [RFObjectTypeEncodingCharacterSet addCharactersInString:kHCObjectTypeEncoding];
    }
    return RFObjectTypeEncodingCharacterSet;
}

+ (NSCharacterSet *)HC_valueTypePointerEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kHCPointerToTypeEncoding];
}

+ (NSCharacterSet *)HC_structEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kHCStructEncoding];
}

+ (NSCharacterSet *)HC_unionEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kHCUnionEncoding];
}

+ (NSCharacterSet *)HC_bitFieldEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kHCBitFieldEncoding];
}

+ (NSCharacterSet *)HC_arrayEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kHCArrayEncoding];
}

+ (NSCharacterSet *)HC_fixedArrayEncodingCharacterSet {
    NSMutableCharacterSet * const set = [NSMutableCharacterSet decimalDigitCharacterSet];
    [set addCharactersInString:kHCPointerToTypeEncoding];
    return set;
}

+ (BOOL)HC_isPrefix:(NSCharacterSet *)prefixSet inString:(NSString *)string {
    NSAssert([string length] > 0, @"Assertion: string (%@) is not empty and is not nil.", string);
    return [string rangeOfCharacterFromSet:prefixSet options:NSLiteralSearch range:NSMakeRange(0, 1)].location != NSNotFound;
}


+ (BOOL)HC_isPrimitiveType:(NSString *)typeEncoding {
    return (![typeEncoding hasPrefix:kHCClassPrefix]);
}

+ (NSString *)HC_classNameFromTypeName:(NSString *)typeName {
    NSString *typeClassStr=[typeName componentsSeparatedByString:@"<"].firstObject;
    typeClassStr =[typeClassStr stringByTrimmingCharactersInSet:[self HC_pointerCharacterSet]];
    return typeClassStr;
}
+ (NSString *)HC_typeProtocolNameFromTypeName:(NSString *)typeName{
    NSScanner* scanner =scanner = [NSScanner scannerWithString: typeName];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                            intoString:NULL];
    while ([scanner scanString:@"<" intoString:NULL]) {
        NSString* protocolName = nil;
        [scanner scanUpToString:@">" intoString: &protocolName];
        [scanner scanString:@">" intoString:NULL];
        return protocolName;
    }
    return nil;
}
@end
