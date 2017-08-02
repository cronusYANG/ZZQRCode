//
//  ZZCacheViewController.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZCacheViewController.h"
#import "ZZDataManager.h"
#import "ZZTextViewController.h"
#import "ZZWebViewController.h"

static NSString *cellID = @"cellID";
@interface ZZCacheViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *cacheArray;
@end

@implementation ZZCacheViewController

-(NSMutableArray *)cacheArray{
    if (!_cacheArray) {
        _cacheArray = [NSMutableArray array];
    }
    return _cacheArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"存档";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadLocalData];
    
    [self setupTableView];
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:_cacheArray forKey:@"title"];
//    
//    NSLog(@"%@",dic);
}

-(void)setupTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    [self.view addSubview:_tableView];
    
}

-(void)loadLocalData{
    
    
    id data = [ZZDataManager loadDataWithPath:CACHENAME];
    
    if (data) {

    self.cacheArray = [NSMutableArray arrayWithArray:data];
        
    NSLog(@"%@",self.cacheArray);
    }
    
    
}

#pragma mark - UITableViewDelegate  &  UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cacheArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.textLabel.text = self.cacheArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = self.cacheArray[indexPath.row];
    
    BOOL isURL = [self getUrlLink:str];
    
    if (isURL) {
        ZZWebViewController *vc = [[ZZWebViewController alloc] init];
        vc.url = str;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZZTextViewController *vc = [[ZZTextViewController alloc] init];
        vc.contentStr = str;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    [_cacheArray removeObjectAtIndex:indexPath.row];
    //重新缓存数据
    [ZZDataManager saveData:_cacheArray withFileName:CACHENAME];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 正则比配URL
- (BOOL)getUrlLink:(NSString *)link {
    
    NSString *regTags = @"((http[s]{0,1}|ftp|HTTP[S]|FTP)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regTags];
    
    BOOL isValid = [predicate evaluateWithObject:link];
    
    return isValid;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
