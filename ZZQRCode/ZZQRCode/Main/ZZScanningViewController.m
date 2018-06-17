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
#import "ZZWebViewController.h"
#import "ZZCreateViewController.h"
#import "ZZOptionsView.h"
#import "ZZCacheViewController.h"
#import "ZZDataManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

@interface ZZScanningViewController () <AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,optionsButtonClickDelegete>

@property (nonatomic, strong) AVCaptureSession *session;

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *layer;

@property (strong,nonatomic) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureConnection *connection;

@property (nonatomic, assign) BOOL flashOpen;

@property (assign,nonatomic) CGFloat initialPinchZoom;

@property (strong,nonatomic) ZZMaskView *maskView;

@property (strong,nonatomic) NSMutableArray *scanningArray;

@property (strong,nonatomic) UIView *blckView;

@property (strong,nonatomic) UIButton *guideView;

@end

@implementation ZZScanningViewController

-(NSMutableArray *)scanningArray{
    if (!_scanningArray) {
        _scanningArray = [NSMutableArray array];
    }
    return _scanningArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.session startRunning];
    
    [self.maskView repetitionAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self dismissGuideView];
    
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码扫描";
    
    [self setupUI];
    
    [self setupNewbieGuide];
    
    [self loadLocalData];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imgButtonBeTouched:) name:@"openThePicker" object:nil];
    
}

-(void)loadLocalData{
    
    
    id data = [ZZDataManager loadDataWithPath:CACHENAME];
    
    if (data) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:data];
        
        self.scanningArray = arr;
        
    }
    
}


-(void)setupUI{
    
    _maskView = [ZZMaskView maskView];
    
    _maskView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    _maskView.sideImage = [UIImage imageNamed:@"img_test_wide"];
    _maskView.lineImage = [UIImage imageNamed:@"img_test_wire"];
    
    [self setUpGesture];
    
    [self.view addSubview:_maskView];
    
    _layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_layer atIndex:0];
    
    ZZOptionsView *optionView = [ZZOptionsView optionsView];
    optionView.frame = CGRectMake(0, HEIGHT/1.15, WIDTH, 50);
    optionView.backgroundColor = [UIColor clearColor];
    optionView.delegete = self;
    [self.view addSubview:optionView];

}

#pragma mark - 手势变焦
//添加手势
- (void)setUpGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    pinch.delegate = self;
    [self.maskView addGestureRecognizer:pinch];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [self.maskView addGestureRecognizer:doubleTap];
}



//双击
-(void)handleDoubleTap:(UITapGestureRecognizer *)recogniser {
    
    if (!_device)
        return;
    
    if (recogniser.state == UIGestureRecognizerStateBegan)
    {
        _initialPinchZoom = _device.videoZoomFactor;
    }
    
    NSError *error = nil;
    [_device lockForConfiguration:&error];
    
    if (!error) {
        CGFloat zoomFactor;
        
        if (_device.videoZoomFactor == 1.0f) {
            zoomFactor = 5.0f;
        }
        else{
            zoomFactor = 1.0f;
        }
        
        _device.videoZoomFactor = zoomFactor;
        
        [_device unlockForConfiguration];
        
    }
    
}

//双指触摸
- (void)pinchDetected:(UIPinchGestureRecognizer *)recogniser {
    
    if (!_device)
        return;
    
    if (recogniser.state == UIGestureRecognizerStateBegan)
    {
        _initialPinchZoom = _device.videoZoomFactor;
    }
    
    NSError *error = nil;
    [_device lockForConfiguration:&error];
    
    if (!error) {
        CGFloat zoomFactor;
        CGFloat scale = recogniser.scale;
        if (scale < 1.0f) {
            zoomFactor = _initialPinchZoom - pow(_device.activeFormat.videoMaxZoomFactor, 1.0f - recogniser.scale);
            
        }
        else{
            zoomFactor = _initialPinchZoom + pow(_device.activeFormat.videoMaxZoomFactor, (recogniser.scale - 1.0f) / 2.0f);
        }
        
        zoomFactor = MIN(10.0f, zoomFactor);
        zoomFactor = MAX(1.0f, zoomFactor);
        
        _device.videoZoomFactor = zoomFactor;
        
        [_device unlockForConfiguration];
        
        //        NSLog(@"%f",_device.videoZoomFactor);
    }
}

#pragma mark - 按钮
//相册按钮
-(void)imgButtonBeTouched:(id)sender{
    NSLog(@"相册");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"设备不支持访问相册"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
    }
    
}
//闪光灯按钮
-(void)lightButtonBeTouched:(UIButton *)sender{
    NSLog(@"闪光灯");
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
        
        [sender setImage:[UIImage imageNamed:@"flashk"] forState:UIControlStateNormal];
        
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
        
        [sender setImage:[UIImage imageNamed:@"flashg"] forState:UIControlStateNormal];
    }

}
//生成按钮
-(void)createButtonBeTouched:(id)sender{
//    NSLog(@"生成");
    ZZCreateViewController *vc = [[ZZCreateViewController alloc] init];
    [self .navigationController pushViewController:vc animated:YES];
    
}
//文件按钮
-(void)fileButtonBeTouched:(id)sender{
//    NSLog(@"文件");
    ZZCacheViewController *vc = [[ZZCacheViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    __weak __typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                  context:nil
                                                  options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1)
        {
            CIQRCodeFeature *feature = [features firstObject];
            
            [self.scanningArray addObject:feature.messageString];
            
            
            [ZZDataManager saveData:self.scanningArray withFileName:CACHENAME];
            
            BOOL isURL = [weakSelf getUrlLink:feature.messageString];
            
            if (isURL) {
                
                ZZWebViewController *webVC = [[ZZWebViewController alloc] init];
                
                webVC.url = feature.messageString;
                
                [weakSelf.navigationController pushViewController:webVC animated:YES];
                
            }else{
                ZZTextViewController *tVC = [[ZZTextViewController alloc] init];
                
                tVC.contentStr = feature.messageString;
                
                [weakSelf.navigationController pushViewController:tVC animated:YES];
            }
            
            
        }
        else
        {
            [weakSelf showAlertWithTitle:@"提示" message:@"没有发现二维码" handler:nil];
        }

    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动提示
    //提示音
    SystemSoundID soundIDTest = 1052;
    AudioServicesPlaySystemSound(soundIDTest);
    
    if (metadataObjects.count > 0)
    {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        
        [self.scanningArray addObject:metadataObject.stringValue];
        
        [ZZDataManager saveData:self.scanningArray withFileName:CACHENAME];
        
        BOOL isURL = [self getUrlLink:metadataObject.stringValue];
        
        if (isURL) {
            
            ZZWebViewController *webVC = [[ZZWebViewController alloc] init];
            
            webVC.url = metadataObject.stringValue;
            
            [self.navigationController pushViewController:webVC animated:YES];
            
        }else{
            
            ZZTextViewController *tVC = [[ZZTextViewController alloc] init];
            
            tVC.contentStr = metadataObject.stringValue;
            
            [self.navigationController pushViewController:tVC animated:YES];
        }
        
     
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
            _device = device;
            
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if (!input)
            {
                return nil;
            }
            
            //创建输出流
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            AVCaptureVideoDataOutput *sampleOutput = [[AVCaptureVideoDataOutput alloc] init];
            
            //设置代理 主线程刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [sampleOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
            //设置扫描区域
            CGFloat width = 300 / CGRectGetHeight(self.view.frame);
            CGFloat height = 300 / CGRectGetWidth(self.view.frame);
            output.rectOfInterest = CGRectMake((1 - width) / 2, (1- height) / 2, width, height);
            
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            [session addInput:input];
            [session addOutput:output];
            [session addOutput:sampleOutput];

            
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




#pragma mark - 正则比配URL
- (BOOL)getUrlLink:(NSString *)link {
    
    NSString *regTags = @"((http[s]{0,1}|ftp|HTTP[S]|FTP|HTTP)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regTags];
    
    BOOL isValid = [predicate evaluateWithObject:link];
    
    return isValid;
}

#pragma mark - 引导
-(void)setupNewbieGuide{
    
    NSString *currentVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveVersion"];
    
    //  测试用 >>> 让每次都显示
//          saveVersion = @"jksdhf";
    
    if (![currentVersion isEqualToString:saveVersion]) {
        
        [self yindao];
        //将当前的 Version 信息缓存到沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"saveVersion"];

    }
}

-(void)yindao{
    
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *myAppDelegate = (AppDelegate *)[application delegate];
    UIWindow *window = [myAppDelegate window] ;
    _blckView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _blckView.backgroundColor = [UIColor blackColor];
    _blckView.alpha = 0.7;
    [window addSubview:_blckView];
    
    UIButton *guideView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [guideView setImage:[UIImage imageNamed:@"yindao"] forState:UIControlStateNormal];
    [guideView addTarget:self action:@selector(dismissGuideView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:guideView];
    self.guideView = guideView;
    
}
-(void)dismissGuideView{
    
    [_blckView removeFromSuperview];
    [_guideView removeFromSuperview];
    _blckView = nil;
    _guideView = nil;
    
}

#pragma mark - 提示框
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^) (UIAlertAction *action))handler;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
