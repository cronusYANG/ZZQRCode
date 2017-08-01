//
//  ZZCacheViewController.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZCacheViewController.h"

static NSString *cellID = @"cellID";
@interface ZZCacheViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation ZZCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"存档";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
}

-(void)setupTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableViewDelegate  &  UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
