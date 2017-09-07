//
//  ZZQRCodeManager.h
//  ZZQRCode
//
//  Created by POPLAR on 2017/9/7.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZQRCodeManager : NSObject
//生成
+ (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size;
//改变颜色
+ (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor;
//添加icon
+ (UIImage *)addIconToCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale;
@end
