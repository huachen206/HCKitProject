//
//  NSString+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/3/25.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "NSString+HCExtend.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSArray+HCExtend.h"

#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation NSString (HCExtend)
-(NSString*)hc_MD5{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
+(NSString*)hc_MD5WithFilePath:(NSString*)path

{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}


CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    
    CFStringRef result = NULL;
    
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    
    CFURLRef fileURL =
    
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  
                                  (CFStringRef)filePath,
                                  
                                  kCFURLPOSIXPathStyle,
                                  
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    
    if (!chunkSizeForReadingData) {
        
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    
    // Check if the read operation succeeded
    
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
        
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    return result;
    
}
//将中文转为拼音. 为提升效率, 加入缓存(注:CFStringTransform很消耗时间)
-(NSString *)hc_toPinyin
{
    static NSMutableDictionary *pinyinCacheStripDiacritics = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pinyinCacheStripDiacritics = [NSMutableDictionary dictionaryWithCapacity:128];
    });
    
    
    NSString *sourceString = [self lowercaseString];
    NSString *cachedString = nil;
    //get from cache
    cachedString = pinyinCacheStripDiacritics[sourceString];
    //no cache?
    if (cachedString == nil) {
        NSMutableString *source = [sourceString mutableCopy];
        CFStringTransform((CFMutableStringRef)source,
                          NULL,
                          kCFStringTransformMandarinLatin,
                          NO);
        CFStringTransform((CFMutableStringRef)source,
                          NULL,
                          kCFStringTransformStripDiacritics,
                          NO);
        cachedString = [NSString stringWithString:source];
        if (cachedString) {
            pinyinCacheStripDiacritics[sourceString] = cachedString;
        }
    }
    
    //    NSLog(@"transform %@ to %@",sourceString,cachedString);
    
    return cachedString;
}


// 匹配英文、拼音、拼音首字母
- (BOOL)hc_isMatchedForSearchText:(NSString *)searchText
{
    if (searchText.length == 0 || self.length == 0) {
        return NO;
    }
    NSString *lowerSelf = [self lowercaseString];
    NSString *lowerSearchText = [searchText lowercaseString];
    if ([lowerSelf rangeOfString:lowerSearchText].length > 0) {
        return YES;
    }
    NSString *pinyinSelf = [lowerSelf hc_toPinyin];
    
    
    NSString *pinyinWithoutSpaceSelf = [pinyinSelf stringByReplacingOccurrencesOfString:@" " withString:@""];
    lowerSearchText = [lowerSearchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (lowerSearchText.length == 0) {
        return NO;
    }
    
    NSArray *pinyinArraySelf = [pinyinSelf componentsSeparatedByString:@" "];
    NSArray *firstPinyinArray = [pinyinArraySelf hc_map:^id _Nullable(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *pinyin = (NSString*)obj;
        return pinyin.length > 0 ? [pinyin substringToIndex:1] : @"";
    }];

    NSString *firstPinyinSelf = [firstPinyinArray componentsJoinedByString:@""];
    if ([firstPinyinSelf rangeOfString:lowerSearchText].length > 0) {
        return YES;
    }
    
    NSUInteger firstLoc = [firstPinyinSelf rangeOfString:[lowerSearchText substringToIndex:1]].location;
    if (firstLoc != NSNotFound) {
        NSString *matchedWord = [pinyinArraySelf objectAtIndex:firstLoc];
        NSUInteger realFirstLoc1 = [pinyinSelf rangeOfString:matchedWord].location;
        NSUInteger realFirstLoc2 = [pinyinWithoutSpaceSelf rangeOfString:matchedWord].location;
        NSUInteger matchLoc1 = [pinyinSelf rangeOfString:lowerSearchText].location;
        NSUInteger matchLoc2 = [pinyinWithoutSpaceSelf rangeOfString:lowerSearchText].location;
        if (matchLoc1 != NSNotFound && matchLoc1==realFirstLoc1) {
            return YES;
        }
        if (matchLoc2 != NSNotFound && matchLoc2==realFirstLoc2) {
            return YES;
        }
    }
    return NO;
}
- (NSString *)hc_urlencodedValue
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":/?#[]@!$&'()*+,;="]];
//    NSString *urlencodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8));
//    return urlencodedString;
}

- (NSString *)hc_urldecodedValue
{
    NSString *urldecodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)self, (CFStringRef)@""));
    return urldecodedString;
}

//取字符串中的一串数字字符
static inline NSRegularExpression *NumberRegularExpression() {
    static NSRegularExpression *_regularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _regularExpression = [[NSRegularExpression alloc] initWithPattern:@"[0-9]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return _regularExpression;
}
-(NSString*)hc_subStringOfNumber{
    NSRegularExpression *expression= NumberRegularExpression();
    NSTextCheckingResult *firstMatch = [expression firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (firstMatch) {
        NSRange resultRange = [firstMatch rangeAtIndex:0];
        return [self substringWithRange:resultRange];
    }
    return nil;
}

@end
