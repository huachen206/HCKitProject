//
//  HCMethodInfo.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/17.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCMethodInfo.h"
#import <objc/runtime.h>
#import "HCTypeDecoder.h"

static NSUInteger const kRFMethodArgumentOffset = 2;
@interface HCMethodInfo() {
    NSString * _name;
    NSString * _className;
    Class _hostClass;
    NSUInteger _numberOfArguments;
    NSString * _returnType;
    BOOL _classMethod;
    
    NSArray * _argumentTypes;
    
    Method _method;
}
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *className;
@property (assign, nonatomic) Class hostClass;
@property (assign, nonatomic) NSUInteger numberOfArguments;
@property (copy, nonatomic) NSString *returnType;
@property (assign, nonatomic, getter = isClassMethod) BOOL classMethod;

@end
@implementation HCMethodInfo
#pragma mark - Initialization

+ (NSArray *)methodsOfClass:(Class)aClass {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    unsigned int numberOfInstanceMethods = 0;
    Method *instanceMethods = class_copyMethodList(aClass, &numberOfInstanceMethods);
    [result addObjectsFromArray:[self methodInfoList:instanceMethods count:numberOfInstanceMethods ofClass:aClass areClassMethods:NO]];
    free(instanceMethods);
    
    unsigned int numberOfClassMethods = 0;
    Method *classMethods = class_copyMethodList(object_getClass(aClass), &numberOfClassMethods);
    [result addObjectsFromArray:[self methodInfoList:classMethods count:numberOfClassMethods ofClass:aClass areClassMethods:YES]];
    free(classMethods);
    
    return result;
}

+ (NSArray *)methodInfoList:(const Method *)methods count:(unsigned int)numberOfMethods ofClass:(Class)aClass areClassMethods:(const BOOL)areClassMethods {
    NSMutableArray * const result = [[NSMutableArray alloc] init];
    HCMethodInfo *info;
    
    for (unsigned int index = 0; index < numberOfMethods; index++) {
        info = [self methodInfo:methods[index] forClass:aClass];
        info.classMethod = areClassMethods;
        [result addObject:info];
    }
    
    return result;
}

+ (HCMethodInfo *)instanceMethodNamed:(NSString *)methodName forClass:(Class)aClass {
    Method method = class_getInstanceMethod(aClass, NSSelectorFromString(methodName));
    HCMethodInfo *info = [self methodInfo:method forClass:aClass];
    info.classMethod = NO;
    return info;
}

+ (HCMethodInfo *)classMethodNamed:(NSString *)methodName forClass:(Class)aClass {
    Method method = class_getClassMethod(aClass, NSSelectorFromString(methodName));
    HCMethodInfo *info = [self methodInfo:method forClass:aClass];
    info.classMethod = YES;
    return info;
}

+ (HCMethodInfo *)methodInfo:(Method)method forClass:(Class)aClass {
    HCMethodInfo *info = [[HCMethodInfo alloc] initWithMethod:method];
    info.hostClass = aClass;
    info.name = NSStringFromSelector(method_getName(method));
    info.numberOfArguments = (NSUInteger)method_getNumberOfArguments(method) - kRFMethodArgumentOffset;
    
    return info;
}

+ (NSArray *)argumentsTypeNamesOfMethod:(Method)method numberOfArguments:(NSUInteger)numberOfArguments {
    NSMutableArray * const array = [[NSMutableArray alloc] init];
    
    for (unsigned int index = kRFMethodArgumentOffset; index < numberOfArguments + kRFMethodArgumentOffset; index++) {
        char *argEncoding = method_copyArgumentType(method, index);
        [array addObject:[HCTypeDecoder nameFromTypeEncoding:@(argEncoding)]];
        free(argEncoding);
    }
    
    return array;
}

+ (NSString *)returnTypeNameOfMethod:(Method)method {
    char *returnTypeEncoding = method_copyReturnType(method);
    NSString * const result = @(returnTypeEncoding);
    free(returnTypeEncoding);
    return [HCTypeDecoder nameFromTypeEncoding:result];
}

- (id)initWithMethod:(Method)method {
    self = [super init];
    if (self) {
        _method = method;
    }
    
    return self;
}

- (NSString *)typeOfArgumentAtIndex:(const NSUInteger)anIndex {
    if (!_argumentTypes) {
        _argumentTypes = [[self class] argumentsTypeNamesOfMethod:_method numberOfArguments:_numberOfArguments];
    }
    return _argumentTypes[anIndex];
}


#pragma mark - Specifiers

- (NSString *)className {
    if (!_className) {
        _className = NSStringFromClass(_hostClass);
    }
    
    return _className;
}

- (NSString *)returnType {
    if (!_returnType) {
        _returnType = [[self class] returnTypeNameOfMethod:_method];
    }
    
    return _returnType;
}

@end
