//
//  NSArray+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/22.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSArray+HCExtend.h"

@implementation NSArray (HCExtend)
-(NSArray *)hc_objectAlsoIn:(NSArray *)array{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",array];
    NSArray * filter = [self filteredArrayUsingPredicate:filterPredicate];
    return filter;
}
-(NSArray *)hc_objectWithOut:(NSArray *)array{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",array];
    NSArray * filter = [self filteredArrayUsingPredicate:filterPredicate];
    return filter;
}

-(NSArray*)hc_map:(id(^)(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop))usingBlock{
    NSMutableArray *results = [NSMutableArray array];
    BOOL *stop = (BOOL *)malloc(sizeof(BOOL));
    *stop = NO;
    for (NSUInteger i = 0; i<self.count; i++) {
        id obj = self[i];
        id result =usingBlock(obj,i,stop);
        if (result) {
            [results addObject:result];
        }
        if (*stop) {
            break;
        }
    }
    return results;
}
@end

@implementation NSArray (HCJSON)
- (NSString *)hc_jsonString {
    NSData *data = self.hc_jsonData;
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
- (NSData *)hc_jsonData{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) return nil;
    return result;
}

@end

