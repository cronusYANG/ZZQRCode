//
//  ZZTextViewController.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZTextViewController.h"

@interface ZZTextViewController ()

@end

@implementation ZZTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
   
}

-(void)setupUI{
    
    UILabel *label = [[UILabel alloc] init];
    
    [label sizeToFit];
    
    label.font = [UIFont systemFontOfSize:20];
    
    label.numberOfLines = 0;
    
    label.isCopyable = YES;
    
    label.textColor = [UIColor blackColor];
    
    label.text = self.contentStr;
    
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"扫描结果";
    
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.offset(4);
        make.right.offset(-4);
        make.top.offset(64);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
