# ZZQRCode

一款简单的二维码扫描,包含了手机图片识别,自动识别链接二维码并打开,生成自定义文字二维码,手势变焦

对扫描界面做了单独封装,可以直接使用,支持自定义修改,包括扫描框大小,图片,扫描线,四周颜色透明图等
使用方法:
		将ZZMaskView拖进项目,#import "ZZMaskView.h"
		创建:
		
		_maskView = [ZZMaskView maskView];
    	_maskView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    	_maskView.sideImage = [UIImage imageNamed:@"img_test_wide"];
    	_maskView.lineImage = [UIImage imageNamed:@"img_test_wire"];
    	[self.view addSubview:_maskView];
    	
 属性:
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



A simple qr code scanning.Contains the phone photo identification,Automatic identification URL qr code and open,To generate a custom text qr code.



![](http://www.cronusyang.com/wp-content/uploads/2017/07/IMG_0960-1.png)

