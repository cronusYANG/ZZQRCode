//
//  ZZTextViewController.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZTextViewController.h"

#define WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ZZTextViewController ()

@end

@implementation ZZTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
   
}

-(void)setupUI{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    
//    [label sizeToFit];
    
    label.font = [UIFont systemFontOfSize:13];
    
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor blackColor];
    
    label.text = self.contentStr;
    
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"扫描结果";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
