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
    
    BOOL isURL = [self getUrlLink:self.contentStr];
    
    if (isURL) {
        label.textColor = [UIColor redColor];
    }
    
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"扫描结果";
    
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.offset(4);
        make.right.offset(-4);
        make.top.offset(64);
    }];
}

- (BOOL)getUrlLink:(NSString *)link {
    
    NSString *regTags = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regTags];
    
    BOOL isValid = [predicate evaluateWithObject:link];
    
    return isValid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
