//
//  HCPropertyInfo.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/16.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCPropertyInfo : NSObject
/**
 * The property's name.
 */
@property (readonly, nonatomic) NSString *propertyName;

/**
 * The name of the host class.
 */
@property (readonly, nonatomic) NSString *className;

/**
 * The type of the host class.
 */
@property (readonly, nonatomic) Class hostClass;

/**
 * The name of the class or variable type of the property declaration.
 */
@property (readonly, nonatomic) NSString *typeName;
/**
 * The name of the setter method.
 */
@property (readonly, nonatomic) NSString *setterName;

/**
 * The name of the getter method.
 */
@property (readonly, nonatomic) NSString *getterName;

/**
 * Boolean property telling whether the property's implementatin is done via the @dynamic directive.
 */
@property (readonly, nonatomic, getter = isDynamic) BOOL dynamic;

/**
 * Boolean property telling whether the property is weak.
 */
@property (readonly, nonatomic, getter = isWeak) BOOL weak;

/**
 * Boolean property telling whether the property is nonatomic.
 */
@property (readonly, nonatomic, getter = isNonatomic) BOOL nonatomic;

/**
 * Boolean property telling whether the property is strong.
 */
@property (readonly, nonatomic, getter = isStrong) BOOL strong;

/**
 * Boolean property telling whether the property is readonly.
 */
@property (readonly, nonatomic, getter = isReadonly) BOOL readonly;

/**
 * Boolean property telling whether the property is copying.
 */
@property (readonly, nonatomic, getter = isCopied) BOOL copied;

/**
 *Boolean property telling whether the property is pointing to an object instead of a primitive value.
 */
@property (readonly, nonatomic, getter = isPrimitive) BOOL primitive;

/**
 * The declared class of the property if applicable.
 * For primitive types this is Nil.
 */
@property (readonly, nonatomic) Class typeClass;
/**
 * The protocol name of the property if applicable.
 * If the property haven't protocal ,this is Nil.
 */
@property (readonly, nonatomic) NSString *protocolName;
/**
 * Returns an array of info objects for the given class.
 * @param aClass The class to fetch the property infos for.
 * @result The array of filtered results.
 */
+ (NSArray *)propertiesForClass:(Class)aClass;
/**
 * Returns an array of info objects for the given class plus properties from superclasses limited with specified depth.
 * @param aClass The class to fetch the property infos for.
 * @param depth The depth of superclasses where properties should be gathered.
 * 1 - only current class, 0 - always returns no properties. Invoked on an instance of a class.
 * @result The array of filtered results.
 */
+ (NSArray *)propertiesForClass:(Class)aClass depth:(NSUInteger)depth;

/**
 * Returns an array of info objects for the given class filtered with the predicate.
 * @param aClass The class to fetch the infos for.
 * @param aPredicate The predicate to apply before returning the results.
 * @result The array of filtered results.
 */
+ (NSArray *)propertiesForClass:(Class)aClass withPredicate:(NSPredicate *)aPredicate;

/**
 * Fetches the specific info object corresponding to the property named for the given class.
 * @param name The name of the property field.
 * @param aClass The class to fetch the result for.
 * @result The info object.
 */
+ (HCPropertyInfo *)HC_propertyNamed:(NSString *)name forClass:(Class)aClass;

@end
