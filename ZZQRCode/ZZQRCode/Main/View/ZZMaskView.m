//
//  ZZMaskView.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZMaskView.h"


#define screenW CGRectGetWidth([UIScreen mainScreen].bounds)
#define screenH CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ZZMaskView ()

@property (nonatomic, strong) CALayer *lineLayer;

@property (strong,nonatomic) UIImageView *sideImageView;
@property (strong,nonatomic) UIView *topView;
@property (strong,nonatomic) UIView *bottomView;
@property (strong,nonatomic) UIView *leftView;
@property (strong,nonatomic) UIView *rightView;

@end

@implementation ZZMaskView

+ (instancetype)maskView {
    
    ZZMaskView *maskView = [[ZZMaskView alloc] init];
    
    return maskView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
    
}

-(void)setupUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    if (!_allAroundColor) {
        _allAroundColor = [UIColor blackColor];
    }
    
    if (!_allAroundAlpha) {
        _allAroundAlpha = 0.4;
    }
    
    if (!_sideImage) {
        _sideImage = [UIImage imageNamed:@"img_test_wide"];
    }
    
    if (!_lineImage) {
        _lineImage = [UIImage imageNamed:@"img_test_wire"];
    }
    
    //扫描区域
    UIImageView *sideImageView = [[UIImageView alloc] init];
    sideImageView.image = _sideImage;
    
    //上
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = _allAroundColor;
    topView.alpha = _allAroundAlpha;
    
    //下
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = _allAroundColor;
    bottomView.alpha = _allAroundAlpha;
    
    //左
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = _allAroundColor;
    leftView.alpha = _allAroundAlpha;
    
    //右
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = _allAroundColor;
    rightView.alpha = _allAroundAlpha;
    
    
   //--------布局
    
    if (!_scanSize) {
        _scanSize = screenW * 0.8;
    }
    
    CGFloat topAndBottomViewH = (screenH - _scanSize)/2;
    CGFloat leftAndRightViewW = (screenW - _scanSize)/2;
    CGFloat leftAndRightViewH = screenH - (topAndBottomViewH*2);
    
    sideImageView.frame = CGRectMake((screenW - _scanSize)/2, (screenH-_scanSize)/2, _scanSize, _scanSize);
    topView.frame = CGRectMake(0, 0, screenW,topAndBottomViewH);
    bottomView.frame = CGRectMake(0, screenH-topAndBottomViewH, screenW, topAndBottomViewH);
    leftView.frame = CGRectMake(0, topAndBottomViewH, leftAndRightViewW, leftAndRightViewH);
    rightView.frame = CGRectMake(screenW-leftAndRightViewW, topAndBottomViewH, leftAndRightViewW, leftAndRightViewH);
    
    [self addSubview:sideImageView];
    [self addSubview:topView];
    [self addSubview:bottomView];
    [self addSubview:leftView];
    [self addSubview:rightView];

    //线
    self.lineLayer = [CALayer layer];
    self.lineLayer.contents = (id)_lineImage.CGImage;
    [self.layer addSublayer:self.lineLayer];
    [self repetitionAnimation];
    
    _sideImageView = sideImageView;
    _topView = topView;
    _bottomView = bottomView;
    _leftView = leftView;
    _rightView = rightView;

}

-(void)setScanSize:(CGFloat)scanSize{
    
    _scanSize = scanSize;
    
    CGFloat topAndBottomViewH = (screenH - scanSize)/2;
    CGFloat leftAndRightViewW = (screenW - scanSize)/2;
    CGFloat leftAndRightViewH = screenH - (topAndBottomViewH*2);
    
    _sideImageView.frame = CGRectMake((screenW - scanSize)/2, (screenH-scanSize)/2, scanSize, scanSize);
    _topView.frame = CGRectMake(0, 0, screenW,topAndBottomViewH);
    _bottomView.frame = CGRectMake(0, screenH-topAndBottomViewH, screenW, topAndBottomViewH);
    _leftView.frame = CGRectMake(0, topAndBottomViewH, leftAndRightViewW, leftAndRightViewH);
    _rightView.frame = CGRectMake(screenW-leftAndRightViewW, topAndBottomViewH, leftAndRightViewW, leftAndRightViewH);
    
   
}

-(void)setSideImage:(UIImage *)sideImage{
    _sideImage = sideImage;
    _sideImageView.image = _sideImage;
}

-(void)setLineImage:(UIImage *)lineImage{
    _lineImage = lineImage;
    _lineLayer.contents = (id)_lineImage.CGImage;
}

-(void)setLineDuration:(CGFloat)lineDuration{
    _lineDuration = lineDuration;
}

-(void)setAllAroundColor:(UIColor *)allAroundColor{
    _allAroundColor = allAroundColor;
    
    _topView.backgroundColor = allAroundColor;
    _bottomView.backgroundColor = allAroundColor;
    _leftView.backgroundColor = allAroundColor;
    _rightView.backgroundColor = allAroundColor;
}

-(void)setAllAroundAlpha:(CGFloat)allAroundAlpha{
    _allAroundAlpha = allAroundAlpha;
    
    _topView.alpha = allAroundAlpha;
    _bottomView.alpha = allAroundAlpha;
    _leftView.alpha = allAroundAlpha;
    _rightView.alpha = allAroundAlpha;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
    
    self.lineLayer.frame = CGRectMake((self.frame.size.width - _scanSize) / 2, (self.frame.size.height - _scanSize) / 2, _scanSize, 2);
}

- (void)stopAnimation
{
    [self.lineLayer removeAnimationForKey:@"translationY"];
}

- (void)repetitionAnimation
{
    if (!_lineDuration) {
        _lineDuration = 2;
    }
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basic.fromValue = @(0);
    basic.toValue = @(_scanSize);
    basic.duration = _lineDuration;
    basic.repeatCount = NSIntegerMax;
    [self.lineLayer addAnimation:basic forKey:@"translationY"];
}




@end
