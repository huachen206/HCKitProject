//
//  NSObject+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSObject+HCExtend.h"

@implementation NSObject (HCExtend)

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


@end
@implementation NSObject (HCRuntime)
+(NSArray *)hc_modelListWithDicArray:(NSArray *)array{
    NSMutableArray *modelList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        [modelList addObject:[[self alloc] hc_initWithDictionary:dic]];
    }
    return modelList;
}
-(id)hc_initWithDictionary:(NSDictionary *)dic{
    if (self == [self init]) {
        [[HCPropertyInfo propertiesForClass:[self class]] enumerateObjectsUsingBlock:^(HCPropertyInfo *info, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = [dic objectForKey:info.propertyName];
            if (value) {
                [self setValue:value forKey:info.propertyName];
            }
        }];
    }
    return self;
}

-(id)hc_initWithDictionary:(NSDictionary *)dic addOther:(NSDictionary *)ortherDic{
    NSMutableDictionary *totalDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [totalDic setDictionary:ortherDic];
    return [self hc_initWithDictionary:totalDic];
}

+ (NSArray *)hc_propertyNameList
{
    return [self hc_propertyNameListWithdepth:1];
}
+ (NSArray *)hc_propertyNameListWithdepth:(NSInteger)depth
{
    return [[self hc_propertyInfosWithdepth:depth] hc_enumerateObjectsForArrayUsingBlock:^id _Nullable(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HCPropertyInfo *pi = (HCPropertyInfo *)obj;
        return pi.propertyName;
    }];
}

+(NSArray <HCPropertyInfo *>*)hc_propertyInfos{
    return [HCPropertyInfo propertiesForClass:[self class]];
}

+(NSArray <HCPropertyInfo *>*)hc_propertyInfosWithdepth:(NSInteger)depth{
    return [HCPropertyInfo propertiesForClass:[self class] depth:depth];
}
@end


@interface NSObject ()
@property (nonatomic,strong) NSMutableDictionary *hc_userInfo;
@end
@implementation NSObject (HCObject)
static char const *const hc_observerKey = "hc_userInfo";

-(NSMutableDictionary *)hc_userInfo{
    if (!objc_getAssociatedObject(self, hc_observerKey)) {
        objc_setAssociatedObject(self, hc_observerKey, [[NSMutableDictionary alloc] init], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, hc_observerKey);
}
-(void)hc_setObject:(id)aObject forKey:(NSString *)aKey{
    [self.hc_userInfo setObject:aObject forKey:aKey];
}
-(id)hc_objectForKey:(NSString *)aKey{
    return [self.hc_userInfo objectForKey:aKey];
}
-(void)hc_removeObjectForKey:(NSString *)aKey{
    [self.hc_userInfo removeObjectForKey:aKey];
}

@end