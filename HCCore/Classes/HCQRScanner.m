//
//  HCQRScanner.m
//  HCKitProject
//
//  Created by HuaChen on 16/6/21.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCQRScanner.h"
#import <AVFoundation/AVFoundation.h>
@interface HCQRScanner()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    ScannerResultBlock _resultBlock;
    AVCaptureVideoPreviewLayer *_layer;
    
}
@end

@implementation HCQRScanner

+(instancetype)scanner{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(void)inView:(UIView*)inview scannerResult:(ScannerResultBlock)resultBlock isStartNow:(BOOL)isStartNow{
    _resultBlock = resultBlock;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=inview.layer.bounds;
    [inview.layer addSublayer:layer];
    _layer = layer;
    if (isStartNow) {
        [self start];
    }
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        BOOL *dontStop = (BOOL *)malloc(sizeof(BOOL));
        *dontStop = NO;
        if (_resultBlock) {
            _resultBlock(self,metadataObject.stringValue,dontStop);
        }
        if (!*dontStop) {
            [self stop];
        }
    }
}

-(void)start{
    //开始捕获
    [session startRunning];
}
-(void)stop{
    [session stopRunning];
}
-(void)clear{
    [self stop];
    [_layer removeFromSuperlayer];
}
@end
