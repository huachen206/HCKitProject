//
//  HCMethodInfo.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/17.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCMethodInfo : NSObject

/**
 * The name of the method.
 */
@property (readonly, nonatomic) NSString *name;

/**
 * The name of the class the method was declared to be a member of.
 */
@property (readonly, nonatomic) NSString *className;
/**
 * The type of the host class.
 */
@property (readonly, nonatomic) Class hostClass;

/**
 * The number of arguments for the method.
 */
@property (readonly, nonatomic) NSUInteger numberOfArguments;

/**
 * The string value describing the return value's type.
 */
@property (readonly, nonatomic) NSString *returnType;

/**
 * Boolean value telling if the method was a class method.
 */
@property (readonly, nonatomic, getter = isClassMethod) BOOL classMethod;


/**
 * Returns an array of info objects for all the declared methods of the given class.
 * @param aClass The class for which to return the method info.
 * @result All info objects for the declared methods.
 */
+ (NSArray *)methodsOfClass:(Class)aClass;

/**
 * Returns an info object corresponding to a class method of the given name.
 * @param methodName The name of the method.
 * @param aClass The class for which to return a method info.
 * @result The info object.
 */
+ (HCMethodInfo *)classMethodNamed:(NSString *)methodName forClass:(Class)aClass;

/**
 * Returns an info object corresponding to an instance method of the given name.
 * @param methodName The name of the method.
 * @param aClass The class for which to return a method info.
 * @result The info object.
 */
+ (HCMethodInfo *)instanceMethodNamed:(NSString *)methodName forClass:(Class)aClass;

/**
 * The type of the argument at the specified index.
 * @param anIndex The index of the argument. If the index is out of range (not between 0 and number of arguments), the method throws an exception.
 * @result The type string.
 */
- (NSString *)typeOfArgumentAtIndex:(NSUInteger)anIndex;


@end
