//
//  ZZScanningViewController.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ZZScanningViewController.h"
#import "ZZMaskView.h"
#import "ZZTextViewController.h"


@interface ZZScanningViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, strong) AVCaptureConnection *connection;

@property (nonatomic, assign) BOOL flashOpen;

@property (strong,nonatomic) ZZMaskView *maskView;

@end

@implementation ZZScanningViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.session startRunning];
    
    [self.maskView repetitionAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码扫描";
    
    [self setupUI];
    
    
    self.view.backgroundColor = [UIColor blueColor];
    
}

#pragma mark 设置焦距
- (void)setFocalLength:(CGFloat)lengthScale
{
    [UIView animateWithDuration:0.5 animations:^{
        [_layer setAffineTransform:CGAffineTransformMakeScale(lengthScale, lengthScale)];
        _connection.videoScaleAndCropFactor = lengthScale;
    }];
}


-(void)setupUI{
    
    _maskView = [ZZMaskView maskView];
    
    _maskView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    [self.view addSubview:_maskView];
    
    _layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_layer atIndex:0];

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0)
    {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        
        ZZTextViewController *tVC = [[ZZTextViewController alloc] init];
        
        tVC.contentStr = metadataObject.stringValue;
        
        [self.navigationController pushViewController:tVC animated:YES];
     
    }
}


#pragma mark - session
- (AVCaptureSession *)session
{
    if (!_session)
    {
        _session = ({
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if (!input)
            {
                return nil;
            }
            
            //创建输出流
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            //设置代理 主线程刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            //设置扫描区域
            CGFloat width = 300 / CGRectGetHeight(self.view.frame);
            CGFloat height = 300 / CGRectGetWidth(self.view.frame);
            output.rectOfInterest = CGRectMake((1 - width) / 2, (1- height) / 2, width, height);
            
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            [session addInput:input];
            [session addOutput:output];

            
            //设置编码 二维&条形
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode128Code];
            
            session;
        });
    }
    
    return _session;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
