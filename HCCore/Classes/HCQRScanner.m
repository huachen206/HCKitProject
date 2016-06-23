//
//  HCQRScanner.m
//  HCKitProject
//
//  Created by HuaChen on 16/6/21.
//  Copyright © 2016年 花晨. All rights reserved.
//

#import "HCQRScanner.h"
#import <AVFoundation/AVFoundation.h>
@interface HCQRScannerView()
@property (nonatomic,strong) HCQRScanner *scanner;
@property (nonatomic,weak) CALayer *previewLayer;
@end
@implementation HCQRScannerView

-(void)inView:(UIView *)inview scanner:(HCQRScanner *)scanner previewLayer:(CALayer *)prelayer{
    self.scanner = scanner;
    self.previewLayer = prelayer;
    [self.layer addSublayer:prelayer];
    
    [inview addSubview:self];

    // 禁止将 AutoresizingMask 转换为 Constraints
    self.translatesAutoresizingMaskIntoConstraints = NO;
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:inview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [inview addConstraint:leftConstraint];
    // 添加 right 约束
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:inview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [inview addConstraint:rightConstraint];
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:inview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [inview addConstraint:topConstraint];
    // 添加 bottom 约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:inview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [inview addConstraint:bottomConstraint];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.previewLayer) {
        self.previewLayer.frame=self.layer.bounds;
    }
}

@end

@interface HCQRScanner()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    ScannerResultBlock _resultBlock;
    
}
@property (nonatomic,weak) HCQRScannerView *scannerView;
@end

@implementation HCQRScanner
+(instancetype)inView:(UIView*)inview scannerResult:(ScannerResultBlock)resultBlock isStartNow:(BOOL)isStartNow{
    HCQRScanner *scanner = [[HCQRScanner alloc] init];
    [scanner inView:inview scannerResult:resultBlock isStartNow:isStartNow];
    return scanner;
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
    
    HCQRScannerView *scannerView = [[HCQRScannerView alloc] init];
    [scannerView inView:inview scanner:self previewLayer:layer];
    self.scannerView = scannerView;
    
    if (isStartNow) {
        [self start];
    }

}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        if (_resultBlock) {
            _resultBlock(self,metadataObject.stringValue);
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
    session = nil;
    _resultBlock = nil;
    if (self.scannerView) {
        [self.scannerView removeFromSuperview];
    }
}
@end
