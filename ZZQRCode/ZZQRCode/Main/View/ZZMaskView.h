//
//  ZZMaskView.h
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZMaskView : UIView

//扫描区域大小(正方形,只传一个值即可)(不传默认为0.8倍屏宽)
@property (assign,nonatomic) CGFloat scanSize;
//扫描框图片(不传默认为一个蓝色框)
@property (strong,nonatomic) UIImage *sideImage;
//扫描线图片(不传没有!!!)
@property (strong,nonatomic) UIImage *lineImage;
//扫描线动画时间[秒](不传默认为2秒)
@property (assign,nonatomic) CGFloat lineDuration;

//四周颜色(不传默认黑色)
@property (strong,nonatomic) UIColor *allAroundColor;
//四周透明度(不传默认0.4)
@property (assign,nonatomic) CGFloat allAroundAlpha;

//创建
+ (instancetype)maskView;
//开始动画
- (void)repetitionAnimation;
//停止动画
- (void)stopAnimation;
@end
