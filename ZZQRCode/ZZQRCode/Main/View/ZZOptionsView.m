//
//  ZZOptionsView.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZOptionsView.h"

@implementation ZZOptionsView

+(instancetype)optionsView{
    ZZOptionsView *view = [[ZZOptionsView alloc] init];
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
    
}

-(void)setupUI{
    NSArray *imgArray = [NSArray array];
    
//    imgArray = @[@"img",@"flashg",@"QRcode",@"file"];
    imgArray = @[@"img",@"flashg",@"QRcode"];
    
    CGFloat wh = 50;
    
    
    for (int i = 0; i < imgArray.count; i++) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.3;
        view.layer.cornerRadius = 25;
        view.layer.masksToBounds = YES;
        UIButton *btn = [[UIButton alloc] init];
        btn.center = view.center;
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        [view addSubview:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.bottom.right.left.offset(0);
        }];
        
        
        NSInteger colCount = imgArray.count;
        
        
        // 间距
        CGFloat margin = ((WIDTH - (colCount * wh)) / (colCount + 1));
        
        // 行号
        NSInteger row = i / colCount;
        // 列号
        NSInteger col = i % colCount;
        
        // !!!!!!
        
        CGFloat x = (col + 1) * (margin) + col * wh;
        CGFloat y = (row + 1) * (margin-35) + row * wh;
        
        view.frame = CGRectMake(x, y, wh, wh);
        
        [self addSubview:view];
        
        
    }
    
    
}

-(void)btnClick:(UIButton *)sender{
    
    if (sender.tag == 100) {
        
        if ([self.imgDelegate respondsToSelector:@selector(imgButtonBeTouched:)]) {
            [self.imgDelegate imgButtonBeTouched:self];
        }
        
    }else if (sender.tag == 101){
        
        if ([self.lightDelegate respondsToSelector:@selector(lightButtonBeTouched:)]) {
            [self.lightDelegate lightButtonBeTouched:sender];
        }
        
        
    }else if (sender.tag == 102){
        
        if ([self.createDelegate respondsToSelector:@selector(createButtonBeTouched:)]) {
            [self.createDelegate createButtonBeTouched:self];
        }
        
        
    }else if (sender.tag == 103){
        
        if ([self.fileDelegate respondsToSelector:@selector(fileButtonBeTouched:)]) {
            [self.fileDelegate fileButtonBeTouched:self];
        }
        
        
    }
    
    
}

@end
