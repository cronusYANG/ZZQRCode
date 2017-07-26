//
//  ZZWebViewController.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/7/26.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZWebViewController.h"

@interface ZZWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation ZZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:urlRequest];
    
    self.webView.delegate = self;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.title = [self getTitle];
    
}


- (NSString *)getTitle {
    NSString *str = [[NSString alloc]initWithFormat:@"document.title"];
    NSString *returnstr = [self.webView stringByEvaluatingJavaScriptFromString:str];
    if ([returnstr isEqualToString: @""]) {
        return @"详情";
    }
    return returnstr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
