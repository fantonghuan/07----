//
//  ZKAppListViewController.m
//  爱限免-框架
//
//  Created by cyan on 15-3-10.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "ZKAppListViewController.h"
#import "ZKButton.h"
#import "AFNetworking.h"
#import "AppListModel.h"
#import "AppListCell.h"
#import "ZKDetailViewController.h"
#import "SearchAppViewController.h"
#import "CategoryViewController.h"
#import "DataCache.h"
#import "SetViewController.h"
#import "MMProgressHUD.h"

@interface ZKAppListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int categeryId;
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ZKAppListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self downLoadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self getNavigationItem];
    
    //请求数据
    _page = 1;
    _categeryId = 0;
    
    //搜索栏
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    _searchBar.placeholder = @"60万款应用有你好看";
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    //见表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), 320, self.view.frame.size.height-CGRectGetMaxY(_searchBar.frame)-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    
}

#pragma mark -- searchBarDelete
//点击清楚按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //隐藏删除按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
}

//开始编辑的时候要做一些事情
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    //当编辑的时候，显示删除按钮
    [searchBar setShowsCancelButton:YES animated:YES];
}

//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    SearchAppViewController *seachApp = [[SearchAppViewController alloc] init];
    
    seachApp.text = searchBar.text;
    
    [self.navigationController pushViewController:seachApp animated:YES];
}

#pragma mark -- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppListCell *cell = [AppListCell cellWithTableView:tableView];
    AppListModel *model = _datas[indexPath.row];
    
    cell.MyModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKDetailViewController *detail = [[ZKDetailViewController alloc] init];
    
    detail.detailModel = _datas[indexPath.row];
    
    detail.proTitle = self.title;
    
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)downLoadData {
    NSString *path = [NSString stringWithFormat:_urlString,_page,_categeryId];
    
    //获取单例的对象
    DataCache *cache = [DataCache shareDataCache];
    
    NSData *data = [cache getDataWithUrlString:path];
    
    //初始化datas
    _datas = [[NSMutableArray alloc] init];//在viewDidLode与在downLoadData中有什么不同
    
    //如果存在，直接使用数据
    if (data) {
        
        [self getModeArrayWithNSData:data];
        
        return;
    }

#pragma mark ---
    /*提示*/
    static BOOL isPro = NO;
    
    if (isPro == NO) {
        isPro = YES;
    } else {
        //用户第一次加载数据不显示提示框
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
        
        //第一个参数：提示框的类型 第二个：标题 第三个：当前状态
        [MMProgressHUD showProgressWithStyle:MMProgressHUDProgressStyleIndeterminate title:self.title status:@"正在下载"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //保存数据，对数据进行缓存
        [cache saveDaata:responseObject withUrlString:path];
        
        [self getModeArrayWithNSData:responseObject];
#pragma mark ---
        /*提示*/
        [MMProgressHUD dismissWithSuccess:@"下载成功"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#pragma mark ---
        [MMProgressHUD dismissWithSuccess:@"下载失败"];
        
        NSLog(@"失败");
    }];
    
}

//解析数据
- (void)getModeArrayWithNSData:(NSData *)data {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array = dic[@"applications"];
    
    for (NSDictionary *dic in array) {
        AppListModel *model = [AppListModel applistModelWithDic:dic];
        
        [_datas addObject:model];
    }
    //刷新表要再block的内部
    [_tableView reloadData];
}

- (void)getNavigationItem {
    
    //设置左边是的分类按钮
    ZKButton *cateGoryButton = [ZKButton buttonWithFrame:CGRectMake(0, 0, 60, 30) type:UIButtonTypeCustom title:@"分类" backgroundImage:@"buttonbar_action" image:nil andBlock:^(ZKButton *button) {
        //        NSLog(@"写将来的设置的内容");
        //        [self presentViewController:[CategoryViewController new] animated:YES completion:^{
        //
        //        }];
        
        [self.navigationController pushViewController:[CategoryViewController new] animated:YES];
    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cateGoryButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //设置右边的设置按钮
    ZKButton *setButton = [ZKButton buttonWithFrame:CGRectMake(0, 0, 60, 30) type:UIButtonTypeCustom title:@"设置" backgroundImage:@"buttonbar_edit" image:nil andBlock:^(ZKButton *button) {
        //        NSLog(@"写将来的设置的内容");
        
        SetViewController *set = [[SetViewController alloc] init];
        
        [self.navigationController pushViewController:set animated:YES];
        
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
