//
//  HCTypeDecoder.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/17.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCTypeDecoder : NSObject

/**
 * Returns the attribute name from the type encoding.
 * @param encoding The type encoding in NSString.
 * @result The name of the type encoding.
 */
+ (NSString *)nameFromTypeEncoding:(NSString *)encoding;

/**
 * Checks whether type is primitive or not.
 * @param typeEncoding The type encoding in NSString.
 * @result YES if type is primitive or NO if type is a class.
 */
+ (BOOL)HC_isPrimitiveType:(NSString *)typeEncoding;

/**
 * Returns just type (without any special symbols like *) from the type encoding.
 * @param typeName The type encoding in NSString.
 * @result The just name of the type encoding.
 */
+ (NSString *)HC_classNameFromTypeName:(NSString *)typeName;

+ (NSString *)HC_typeProtocolNameFromTypeName:(NSString *)typeName;


@end
