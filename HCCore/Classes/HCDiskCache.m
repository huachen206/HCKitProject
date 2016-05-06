//
//  HCDiskCache.m
//  PAQZZ
//
//  Created by 花晨 on 14-2-14.
//  Copyright (c) 2014年 平安付. All rights reserved.
//

#import "HCDiskCache.h"
#import "HCUtilityMacro.h"
#import "HCFileHelper.h"
#define DiskCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"DiskCache"]

@interface HCDiskCache()
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSMutableDictionary *sourceList;
@end

@implementation HCDiskCache
+ (instancetype)diskCache
{
    static dispatch_once_t onceToken;
    static HCDiskCache *__diskCache;
    dispatch_once(&onceToken, ^{
        __diskCache = [[HCDiskCache alloc] init];
    });
    return __diskCache;
}

+(HCDiskCache *)diskCacheWithUserID:(NSString *)userID
{
    static dispatch_once_t onceToken;
    static NSMutableArray *__userCaches;
    dispatch_once(&onceToken, ^{
        __userCaches = [[NSMutableArray alloc] init];
    });
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"DiskCache%@",userID]];
    for (HCDiskCache *cache in __userCaches) {
        if ([cache.filePath isEqualToString:path]) {
            return cache;
        }
    }
    HCDiskCache *cache = [[HCDiskCache alloc] init];
    [__userCaches addObject:cache];
    cache.filePath = path;
    return cache;
}

+(BOOL)supportsSecureCoding{
    return YES;
}
-(id)init
{
    self = [super init];
    if(self){
        self.filePath = DiskCachePath;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
//        self.sourceList = [aDecoder decodeObjectForKey:@"sourceList"];
        self.sourceList = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"sourceList"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.sourceList forKey:@"sourceList"];
}

-(NSMutableDictionary*)sourceList{
    if (!_sourceList) {
        if (![HCFileHelper isExistAtPath:self.filePath]) {
            [HCFileHelper createFileAtPath:self.filePath];
            _sourceList = [[NSMutableDictionary alloc] init];
        }else{
            NSData *data = [NSData dataWithContentsOfFile:self.filePath];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"diskCach"];
            [unarchiver finishDecoding];
            _sourceList = [[NSMutableDictionary alloc] initWithDictionary:myDictionary];
        }
    }
    return _sourceList;
}
-(void)save{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.sourceList forKey:@"diskCach"];
    [archiver finishEncoding];
    [data writeToFile:self.filePath atomically:YES];
}

-(void)addObject:(id)obj key:(NSString *)keyName{
    DebugAssert([obj conformsToProtocol:@protocol(NSCoding)], @"obj must be inherit <NSCoding>!");
    if (![obj conformsToProtocol:@protocol(NSCoding)]) {
        return;
    }
    [self.sourceList setObject:obj forKey:keyName];
    [self save];
}
-(id)objectForKey:(NSString *)keyName{
    return [self.sourceList objectForKey:keyName];
}
-(void)removeObjectForKey:(NSString *)keyName{
    [self.sourceList removeObjectForKey:keyName];
    [self save];
}




@end
