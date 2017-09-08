//
//  ZZCreateViewController.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZCreateViewController.h"
#import "ZZQRCodeManager.h"

#define qrImageSize CGSizeMake(300,300)

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRandomColor kRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface ZZCreateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *caeateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeColorBtn;
@property (strong,nonatomic) UIImage *iconImage;

@end

@implementation ZZCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.iconBtn.hidden = YES;
    self.changeColorBtn.hidden = YES;
    
    [self.textView becomeFirstResponder];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0 ,0 ,30 ,30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButton;
}

//保存二维码到相册
-(void)rightBarButtonClick:(UIButton *)sender{
    
    UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
}

//生成
- (IBAction)createBtnClick:(id)sender {
    
    [self.textView resignFirstResponder];
    
    if (self.textView.text.length > 0)
    {
        self.imgView.image = [ZZQRCodeManager createQRImageWithString:self.textView.text size:qrImageSize];
        self.changeColorBtn.hidden = NO;
        self.iconBtn.hidden = NO;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入文字"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
    }

    
}

//添加icon
- (IBAction)iconBtnClick:(id)sender {
    
    
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

//改变颜色
- (IBAction)changeColorClick:(id)sender {
    
    self.imgView.image = [ZZQRCodeManager createQRImageWithString:self.textView.text size:qrImageSize];
    
    self.imgView.image = [ZZQRCodeManager changeColorForQRImage:self.imgView.image backColor:kRandomColor frontColor:kRandomColor];
    
    self.imgView.image = [ZZQRCodeManager addIconToCodeImage:self.imgView.image withIcon:_iconImage withScale:6];
    
}


//保存回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }
    
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    _iconImage = info[UIImagePickerControllerOriginalImage];
    self.imgView.image = [ZZQRCodeManager addIconToCodeImage:self.imgView.image withIcon:_iconImage withScale:6];
        
}

#pragma mark - 绘制二维码
- (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size{
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
 
    UIImage *codeImage = [self createQRImageWithFilter:qrFilter size:size];
  
    
    return codeImage;
}

- (UIImage *)createQRImageWithFilter:(CIFilter *)filter size:(CGSize)size{
    
    CIImage *qrImage = filter.outputImage;
    //放大并绘制二维码 (上面生成的二维码很小，需要放大)
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;

}

#pragma mark - 改变颜色
- (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor
{
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",[CIImage imageWithCGImage:image.CGImage],
                             @"inputColor0",[CIColor colorWithCGColor:frontColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backColor.CGColor],
                             nil];
    

    UIImage *codeImage =  [self createQRImageWithFilter:colorFilter size:qrImageSize];

    
    return codeImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
