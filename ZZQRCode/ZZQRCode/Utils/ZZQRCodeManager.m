//
//  ZZQRCodeManager.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/9/7.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZQRCodeManager.h"

@implementation ZZQRCodeManager
#pragma mark - 绘制二维码
+ (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size{
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIImage *codeImage = [self createQRImageWithFilter:qrFilter size:size];
    
    return codeImage;
}

+ (UIImage *)createQRImageWithFilter:(CIFilter *)filter size:(CGSize)size{
    
    CIImage *qrImage = filter.outputImage;
    //放大并绘制二维码
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转图片
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

#pragma mark - 改变颜色
+ (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor {
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",[CIImage imageWithCGImage:image.CGImage],
                             @"inputColor0",[CIColor colorWithCGColor:frontColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backColor.CGColor],
                             nil];
    
    
    UIImage *codeImage =  [self createQRImageWithFilter:colorFilter size:CGSizeMake(imageWidth, imageHeight)];
    
    
    return codeImage;
}


#pragma mark - 二维码加图标
+ (UIImage *)addIconToCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale{
    
    UIGraphicsBeginImageContext(image.size);
    
    //按比例添加icon
    CGFloat widthOfImage = image.size.width;
    CGFloat heightOfImage = image.size.height;
    CGFloat widthOfIcon = widthOfImage/scale;
    CGFloat heightOfIcon = heightOfImage/scale;
    
    [image drawInRect:CGRectMake(0, 0, widthOfImage, heightOfImage)];
    [icon drawInRect:CGRectMake((widthOfImage-widthOfIcon)/2, (heightOfImage-heightOfIcon)/2,
                                widthOfIcon, heightOfIcon)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}



@end
