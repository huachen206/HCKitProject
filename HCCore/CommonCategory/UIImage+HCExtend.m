//
//  UIImage+HCExtend.m
//  HCKitProject
//
//  Created by HuaChen on 16/4/5.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "UIImage+HCExtend.h"
#import <Accelerate/Accelerate.h>
#import "HCUtilityMacro.h"

#define kPAMaxImageSizeMB 5.0f // The resulting image will be (x)MB of uncompressed image data.
#define kSourceImageTileSizeMB 5.0f // The tile size will be (x)MB of uncompressed image data.
#define bytesPerMB 1048576.0f
#define bytesPerPixel 4.0f
#define pixelsPerMB ( bytesPerMB / bytesPerPixel ) // 262144 pixels, for 4 bytes per pixel.
#define destSeemOverlap 2.0f // the numbers of pixels to overlap the seems where tiles meet.

#define kDefaultJPEGQuality 0.4


@implementation UIImage (HCExtend)
-(UIImage*)hc_imageToSize:(CGSize)size scaleType:(int)scaleType

{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    // 绘制改变大小的图片
    if (scaleType == 1) {
        UIGraphicsBeginImageContext(size);
        [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    }else{
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [self drawInRect:CGRectMake(0, 0, width, height)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(UIImage*)hc_imageWithCutRect:(CGRect)cutRect{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage,CGRectMake(cutRect.origin.x*self.scale, cutRect.origin.y*self.scale, cutRect.size.width*self.scale, cutRect.size.height*self.scale));
    UIImage *cutedImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    return cutedImage;
}

-(NSArray*)hc_imagesWithPercentage:(NSNumber *)p1,...{
    NSMutableArray *images = [NSMutableArray array];
    float width = self.size.width;
    float height = self.size.height;
    
    float pt;
    va_list args;
    va_start(args, p1);
    if (p1) {
        pt +=[p1 floatValue];
        [images addObject:[self hc_imageWithCutRect:CGRectMake(0, 0, pt*width, height)]];
        NSNumber *pn;
        while ((pn = va_arg(args, NSNumber *))) {
            [images addObject:[self hc_imageWithCutRect:CGRectMake(pt*width, height, [pn floatValue]*width, height)]];
            pt+=[pn floatValue];
        }
    }
    va_end(args);
    NSAssert(pt==1, @"百分比总值应该为1");
    
    
    return images;
}

-(float)hc_sizeInMB
{
    CGSize size = self.size;
    float dimention = size.width * size.height;
    float sizeInMB = ( dimention * bytesPerPixel ) / (1024 * 1024);
    return sizeInMB;
}


-(BOOL)hc_saveAsJPEGWithQuality:(float)quality toPath:(NSString*)path
{
    NSData* data = UIImageJPEGRepresentation(self, quality);
    
    BOOL b = [data writeToFile:path atomically:YES];
    
    if(!b)
    {
        NSLog(@"write to file:%@ failed!", path);
    }
    return b;
}

+(CGSize)hc_clampSizeTo:(CGSize)constraint size:(CGSize)rawSize
{
    if(rawSize.width <= constraint.width && rawSize.height <= constraint.height)
        return rawSize;
    
    CGFloat k1 = constraint.width / rawSize.width;
    CGFloat k2 = constraint.height / rawSize.height;
    
    CGFloat k = MIN(k1, k2);
    
    CGSize ret = rawSize;
    ret.width *= k;
    ret.height *= k;
    
    return ret;
}
-(UIImage*)hc_imageUnderMaxKb:(float)lengKb{
    UIImage *resultImage = self;
    CGSize size = self.size;
    NSData *imageData = UIImageJPEGRepresentation(self, 0.9);
    if (imageData.length > lengKb*1024) {
        float k = (lengKb*1024)/ imageData.length;
        k = sqrtf(k);
        size.height = size.height*k;
        size.width = size.width*k;
        resultImage = [self hc_imageToSize:size scaleType:0];
    }else{
        resultImage = self;
    }
    return resultImage;
}

- (UIImage *)hc_stretchableImage
{
    UIImage *stretchedImage = nil;
    CGFloat halfWidth = (NSInteger)self.size.width / 2;
    CGFloat halfHeight = (NSInteger)self.size.height / 2;
    
    if ([UIImage instancesRespondToSelector:@selector(resizableImageWithCapInsets:)]) {
        stretchedImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight,
                                                                            halfWidth,
                                                                            self.size.height - halfHeight - 1,
                                                                            self.size.width - halfWidth - 1)];
    }
    else {
        stretchedImage = [self stretchableImageWithLeftCapWidth:halfWidth topCapHeight:halfHeight];
    }
    
    return stretchedImage;
}

- (UIImage*)hc_imageWithGaussianBlur:(CGFloat)blurRadius{
    if ((blurRadius <= 0.0f) || (blurRadius > 1.0f)) {
        blurRadius = 0.5f;
    }
    
    int boxSize = (int)(blurRadius * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef rawImage = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(rawImage);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(rawImage);
    inBuffer.height = CGImageGetHeight(rawImage);
    inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(rawImage);
    outBuffer.height = CGImageGetHeight(rawImage);
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(self.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+(UIImage*)hc_imageFromContext:(CGContextRef) context orientation:(UIImageOrientation) orientation
{
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    UIImage* image = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:orientation];
    //    UIImage* image = [UIImage imageWithCGImage:cgImage];
    DebugAssert(image != nil, @"image is nil!");
    CGImageRelease(cgImage);
    
    return image;
}


@end
