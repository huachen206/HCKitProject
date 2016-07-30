//
//  HCIvarInfo.h
//  HCKitProject
//
//  Created by HuaChen on 16/3/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCIvarInfo : NSObject
/**
 * The name of the ivar.
 */
@property (readonly, nonatomic) NSString *name;

/**
 * The name of the type of the variable.
 */
@property (readonly, nonatomic) NSString *typeName;

/**
 * Boolean value telling whether the ivar was of primitive (value) type or not.
 */
@property (readonly, nonatomic, getter = isPrimitive) BOOL primitive;

/**
 * The name of the class to which the ivar belongs to.
 */
@property (readonly, nonatomic) NSString *className;

/**
 * The type of the host class.
 */
@property (readonly, nonatomic) Class hostClass;


/**
 * Returns an array of info objects.
 * @param aClass The class to return the list of infos to.
 * @result An array of info objects.
 */
+ (NSArray *)ivarsOfClass:(Class)aClass;

/**
 * Returns an info objects for the given ivar name.
 * @param ivarName The name of the ivar.
 * @param aClass The class to which the ivar belongs to.
 * @result The info object.
 */
+ (HCIvarInfo *)HC_ivarNamed:(NSString *)ivarName forClass:(Class)aClass;


@end
