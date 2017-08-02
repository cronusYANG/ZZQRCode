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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITextView *tv = [[UITextView alloc] init];
    tv.font = [UIFont systemFontOfSize:20];
    tv.textColor = [UIColor blackColor];
    [tv setEditable:NO];
    tv.text = self.contentStr;
    [self.view addSubview:tv];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"扫描结果";
    
    [tv mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(64);
        make.bottom.offset(0);
    }];
}


//(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
