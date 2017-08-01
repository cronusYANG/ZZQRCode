//
//  ZZCreateViewController.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZCreateViewController.h"

#define qrImageSize CGSizeMake(300,300)

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRandomColor kRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface ZZCreateViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *caeateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeColorBtn;

@end

@implementation ZZCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.saveBtn.hidden = YES;
    self.changeColorBtn.hidden = YES;
    
    [self.textView becomeFirstResponder];
}

- (IBAction)createBtnClick:(id)sender {
    
    [self.textView resignFirstResponder];
    
    if (self.textView.text.length > 0)
    {
        self.imgView.image = [self createQRImageWithString:self.textView.text size:qrImageSize];
        self.saveBtn.hidden = NO;
        self.changeColorBtn.hidden = NO;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入文字"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
    }

    
}

//保存二维码到相册
- (IBAction)saveBtnClick:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
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

- (IBAction)changeColorClick:(id)sender {
    
    self.imgView.image = [self createQRImageWithString:self.textView.text size:qrImageSize];
    
    self.imgView.image = [self changeColorForQRImage:self.imgView.image backColor:kRandomColor frontColor:kRandomColor];
    
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
