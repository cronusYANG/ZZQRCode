//
//  ZZMaskView.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZMaskView.h"

@interface ZZMaskView ()

@property (nonatomic, strong) CALayer *lineLayer;

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
    
    self.lineLayer = [CALayer layer];
    self.lineLayer.contents = (id)[UIImage imageNamed:@"scanningLine"].CGImage;
    [self.layer addSublayer:self.lineLayer];
    [self repetitionAnimation];
    
    UIButton *lightBtn = [[UIButton alloc] init];
    lightBtn.backgroundColor = [UIColor redColor];
    [self addSubview:lightBtn];
    
    [lightBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.bottom.offset(-50);
        make.height.width.offset(50);
    }];
    
    self.lightBtn = lightBtn;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat pickingFieldWidth = 300;
    CGFloat pickingFieldHeight = 300;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.35);
    CGContextSetLineWidth(contextRef, 3);
    
    CGRect pickingFieldRect = CGRectMake((width - pickingFieldWidth) / 2, (height - pickingFieldHeight) / 2, pickingFieldWidth, pickingFieldHeight);
    
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:pickingFieldRect];
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    [bezierPathRect appendPath:pickingFieldPath];
    //填充使用奇偶法则
    bezierPathRect.usesEvenOddFillRule = YES;
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetRGBStrokeColor(contextRef, 27/255.0, 181/255.0, 254/255.0, 1);
    [pickingFieldPath stroke];
    
    CGContextRestoreGState(contextRef);
    self.layer.contentsGravity = kCAGravityCenter;
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
    
    self.lineLayer.frame = CGRectMake((self.frame.size.width - 300) / 2, (self.frame.size.height - 300) / 2, 300, 2);
}

- (void)stopAnimation
{
    [self.lineLayer removeAnimationForKey:@"translationY"];
}

- (void)repetitionAnimation
{
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basic.fromValue = @(0);
    basic.toValue = @(300);
    basic.duration = 1.5;
    basic.repeatCount = NSIntegerMax;
    [self.lineLayer addAnimation:basic forKey:@"translationY"];
}




@end
