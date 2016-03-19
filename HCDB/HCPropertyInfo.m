//
//  HCPropertyInfo.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/16.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCPropertyInfo.h"
#import <objc/runtime.h>
#import "HCTypeDecoder.h"
@interface HCPropertyInfo(){
    NSString * _propertyName;
    NSString * _className;
    Class _hostClass;
    NSString * _typeName;
    Class _typeClass;
    NSString *_typeEncoding;
    NSString *_protocolName;
    NSString * _setterName;
    NSString * _getterName;

    BOOL _dynamic;
    BOOL _weak;
    BOOL _nonatomic;
    BOOL _strong;
    BOOL _readonly;
    BOOL _copied;
    BOOL _primitive;

    
    objc_property_t _property;
    BOOL _isSpecifiersFilled;
    BOOL _isAttributeNameFilled;
}
@property (copy, nonatomic) NSString *propertyName;
@property (assign, nonatomic) Class hostClass;

@end

@implementation HCPropertyInfo
+ (NSArray *)propertiesForClass:(Class)aClass {
    return [self propertiesForClass:aClass depth:1];
}

+ (NSArray *)propertiesForClass:(Class)aClass depth:(NSUInteger)depth {
    if (depth <= 0) {
        return @[];
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    unsigned int numberOfProperties = 0;
    objc_property_t *propertiesArray = class_copyPropertyList(aClass, &numberOfProperties);
    
    for (unsigned int idx = 0; idx < numberOfProperties; idx++) {
        [result addObject:[self property:propertiesArray[idx] forClass:aClass]];
    }
    
    free(propertiesArray);
    
    [result addObjectsFromArray:[self propertiesForClass:class_getSuperclass(aClass) depth:--depth]];
    
    return result;
}

+ (HCPropertyInfo *)property:(objc_property_t)property forClass:(Class)class {
    HCPropertyInfo * const info = [[HCPropertyInfo alloc] initWithProperty:property];
    info.hostClass = class;
    
    return info;
}
+ (HCPropertyInfo *)HC_propertyNamed:(NSString *)name forClass:(Class)aClass {
    objc_property_t prop = class_getProperty(aClass, [name cStringUsingEncoding:NSUTF8StringEncoding]);
    HCPropertyInfo *result = nil;
    
    if (prop != NULL) {
        result = [self property:prop forClass:aClass];
    }
    
    return result;
}

+ (NSArray *)propertiesForClass:(Class)class withPredicate:(NSPredicate *)aPredicate {
    NSArray *result = [self propertiesForClass:class];
    return [result filteredArrayUsingPredicate:aPredicate];
}
+ (NSString *)propertyAttributeNameForField:(const char *)fieldName property:(const objc_property_t)property {
    NSString *result;
    char *name = property_copyAttributeValue(property, fieldName);
    
    if (name != NULL) {
        result = @(name);
        free(name);
    }
    
    return result;
}

+ (BOOL)property:(const objc_property_t)property containsSpecifier:(const char *)specifier {
    char *attributeValue = property_copyAttributeValue(property, specifier);
    BOOL const result = attributeValue != NULL;
    free(attributeValue);
    return result;
}


- (id)initWithProperty:(objc_property_t)property {
    self = [super init];
    if (self) {
        _property = property;
        _isSpecifiersFilled = NO;
        _isAttributeNameFilled = NO;
    }
    return self;
}
#pragma mark - Specifiers

- (NSString *)propertyName {
    if (!_propertyName) {
        _propertyName = @(property_getName(_property));
    }
    
    return _propertyName;
}

- (NSString *)className {
    if (!_className) {
        _className = NSStringFromClass(self.hostClass);
    }
    
    return _className;
}

- (NSString *)typeName {
    if (!_isAttributeNameFilled) {
        [self fillAttributeName];
    }
    
    return _typeName;
}

- (Class)typeClass {
    if (!_typeClass) {
        if (!_isAttributeNameFilled) {
            [self fillAttributeName];
        }
        _typeClass = NSClassFromString([HCTypeDecoder HC_classNameFromTypeName:_typeName]);
    }
    
    return _typeClass;
}
-(NSString *)typeEncoding{
    if (!_typeEncoding) {
        if (!_isAttributeNameFilled) {
            [self fillAttributeName];
        }
    }
    return _typeEncoding;
}
-(NSString *)protocolName{
    if (!_protocolName) {
        if (!_isAttributeNameFilled) {
            [self fillAttributeName];
        }
        _protocolName = [HCTypeDecoder HC_typeProtocolNameFromTypeName:_typeName];
    }
    return _protocolName;
}
- (BOOL)isPrimitive {
    if (!_isAttributeNameFilled) {
        [self fillAttributeName];
    }
    
    return _primitive;
}

- (BOOL)isDynamic {
    if (!_isSpecifiersFilled) {
        [self fillSpecifiers];
    }
    
    return _dynamic;
}

- (BOOL)isWeak {
    if (!_isSpecifiersFilled) {
        [self fillSpecifiers];
    }
    
    return _weak;
}

- (BOOL)isNonatomic {
    if (!_isSpecifiersFilled) {
        [self fillSpecifiers];
    }
    
    return _nonatomic;
}

- (BOOL)isReadonly {
    if (!_isSpecifiersFilled) {
        [self fillSpecifiers];
    }
    
    return _readonly;
}

- (BOOL)isStrong {
    if (!_isSpecifiersFilled) {
        [self fillSpecifiers];
    }
    
    return _strong;
}

- (BOOL)isCopied {
    if (!_isSpecifiersFilled) {
        [self fillSpecifiers];
    }
    
    return _copied;
}
- (NSString *)getterName {
    if (!_getterName) {
        _getterName = [[self class] propertyAttributeNameForField:"G" property:_property];
    }
    
    return _getterName;
}

- (NSString *)setterName {
    if (!_setterName) {
        _setterName = [[self class] propertyAttributeNameForField:"S" property:_property];
    }
    
    return _setterName;
}

#pragma mark - Utility methods


static const char * kPropertyInfoDynamicSpecifier = "D";
static const char * kPropertyInfoWeakSpecifier = "W";
static const char * kPropertyInfoNonatomicSpecifier = "N";
static const char * kPropertyInfoReadonlySpecifier = "R";
static const char * kPropertyInfoStrongSpecifier = "&";
static const char * kPropertyInfoCopiedSpecifier = "C";


- (void)fillSpecifiers {
    _dynamic = [[self class] property:_property containsSpecifier:kPropertyInfoDynamicSpecifier];
    _weak = [[self class] property:_property containsSpecifier:kPropertyInfoWeakSpecifier];
    _nonatomic = [[self class] property:_property containsSpecifier:kPropertyInfoNonatomicSpecifier];
    _readonly = [[self class] property:_property containsSpecifier:kPropertyInfoReadonlySpecifier];
    _strong = [[self class] property:_property containsSpecifier:kPropertyInfoStrongSpecifier];
    _copied = [[self class] property:_property containsSpecifier:kPropertyInfoCopiedSpecifier];
    
    _isSpecifiersFilled = YES;
}

- (void)fillAttributeName {
    NSString *attributeName = [[self class] propertyAttributeNameForField:"T" property:_property];
    _typeEncoding = attributeName;
    _typeName = [HCTypeDecoder nameFromTypeEncoding:attributeName];
    _primitive = [HCTypeDecoder HC_isPrimitiveType:attributeName];
    
    _isAttributeNameFilled = YES;
}
- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"------------------------\n%@: hostClass = %@,\nis primitive       = %@\nproperty name      = %@,\ntype class         = %@,\ntype Protocol name = %@,\ntype name          = %@\n---------------------------", NSStringFromClass([self class]),NSStringFromClass([self hostClass]),self.isPrimitive?@"YES":@"NO", self.propertyName,NSStringFromClass([self typeClass]),self.protocolName,self.typeName];
}

@end
