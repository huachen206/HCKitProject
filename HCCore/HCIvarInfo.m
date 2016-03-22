//
//  HCIvarInfo.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCIvarInfo.h"
#import <objc/runtime.h>
#import "HCTypeDecoder.h"


@interface HCIvarInfo () {
    NSString * _name;
    NSString * _typeName;
    BOOL _primitive;
    NSString * _className;
    Class _hostClass;
    
    Ivar _ivar;
    BOOL _isPrimitiveFilled;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *typeName;
@property (assign, nonatomic, getter = isPrimitive) BOOL primitive;
@property (copy, nonatomic) NSString *className;
@property (assign, nonatomic) Class hostClass;

@end

@implementation HCIvarInfo

+ (NSArray *)ivarsOfClass:(Class)aClass {
    unsigned int memberCount = 0;
    Ivar * const ivarList = class_copyIvarList(aClass, &memberCount);
    NSMutableArray *array = [NSMutableArray array];
    
    for (unsigned int index = 0; index < memberCount; index++) {
        HCIvarInfo *descriptor = [self HC_infoFromIvar:ivarList[index]];
        descriptor.className = NSStringFromClass(aClass);
        descriptor.hostClass = aClass;
        [array addObject:descriptor];
    }
    
    free(ivarList);
    return array;
}

+ (HCIvarInfo *)HC_ivarNamed:(NSString *const)ivarName forClass:(Class)aClass {
    Ivar anIvar = class_getInstanceVariable(aClass, [ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    HCIvarInfo *descriptor = [self HC_infoFromIvar:anIvar];
    descriptor.className = NSStringFromClass(aClass);
    descriptor.hostClass = aClass;
    return descriptor;
}

+ (HCIvarInfo *)HC_infoFromIvar:(Ivar)anIvar {
    HCIvarInfo * const info = [[HCIvarInfo alloc] initWithIvar:anIvar];
    info.name = @(ivar_getName(anIvar));
    
    return info;
}

- (id)initWithIvar:(Ivar)ivar {
    self = [super init];
    if (self) {
        _ivar = ivar;
        _isPrimitiveFilled = NO;
    }
    return self;
}


- (BOOL)isPrimitive {
    if (!_isPrimitiveFilled) {
        NSString *typeEncoding = @(ivar_getTypeEncoding(_ivar));
        _primitive = [HCTypeDecoder HC_isPrimitiveType:typeEncoding];
        _isPrimitiveFilled = YES;
    }
    
    return _primitive;
}

- (NSString *)typeName {
    if (!_typeName) {
        NSString *typeEncoding = @(ivar_getTypeEncoding(_ivar));
        _typeName = [HCTypeDecoder nameFromTypeEncoding:typeEncoding];
    }
    
    return _typeName;
}

@end
