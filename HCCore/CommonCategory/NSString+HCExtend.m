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

-(NSString *)hc_base64EncodedString {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

-(unsigned long)hc_hexValue{
    NSString *hexStr = nil;
    if (![self hasPrefix:@"0x"]) {
        hexStr = [NSString stringWithFormat:@"0x%@",self];
    }else{
        hexStr = self;
    }
    NSUInteger value = strtoul([hexStr UTF8String],0,16);
    return value;
}
extern NSString *NSStringOfHexFromValue(unsigned long value){
    return [NSString stringWithFormat:@"%lx",value];
}

@end

#import "NSData+HCExtend.h"
@implementation NSString (HCJSON)
- (id )hc_jsonValue {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return data.hc_jsonValue;
}

@end

//#import "NSString+HCExtend.h"
#import <CommonCrypto/CommonCryptor.h>  //DES 加密

@implementation NSString(HCDES)
/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:@"%@",nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}


-(NSString *)TripleDESWithEncryptOrDecrypt:(CCOperation )encryptOrDecrypt key:(NSString*)key{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [[self class] dataWithBase64EncodedString:self];

        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"01234567";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if (ccStatus == kCCSuccess) NSLog(@"DES SUCCESS");
    else if (ccStatus == kCCParamError) return @"DES PARAM ERROR";
    else if (ccStatus == kCCBufferTooSmall) return @"DES BUFFER TOO SMALL";
    else if (ccStatus == kCCMemoryFailure) return @"DES MEMORY FAILURE";
    else if (ccStatus == kCCAlignmentError) return @"DES ALIGNMENT";
    else if (ccStatus == kCCDecodeError) return @"DES DECODE ERROR";
    else if (ccStatus == kCCUnimplemented) return @"DES UNIMPLEMENTED";
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    }
    
    return result;
}
+ (NSString *) hc_encryptStr:(NSString *)str key:(NSString *)key
{
    return[str TripleDESWithEncryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *) hc_decryptStr:(NSString *)str key:(NSString *)key
{
    return[str TripleDESWithEncryptOrDecrypt:kCCDecrypt key:key];
}


@end


