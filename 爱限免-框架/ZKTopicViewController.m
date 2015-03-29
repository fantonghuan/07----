//
//  ZKTopicViewController.m
//  爱限免-框架
//
//  Created by cyan on 15-3-10.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "ZKTopicViewController.h"
#import "ZKTopicModel.h"
#import "ZKTopicCell.h"

@interface ZKTopicViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZKTopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //请求数据
    _page = 1;
    _datas = [[NSMutableArray alloc] init];
    [self downloadData];
    
    //见表
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
}

#pragma mark -- tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZKTopicCell *cell = [ZKTopicCell cellWithTableView:tableView];
    
    ZKTopicModel *model = _datas[indexPath.row];
    
    cell.topicModel = model;
//    cell.textLabel.text = model.title;
    
    return cell;
}


- (void)downloadData {
    NSString *path = [NSString stringWithFormat:TOPIC_URL, _page];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //解析
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@", arr);
        
        for (NSDictionary *dic in arr) {
            ZKTopicModel *model = [ZKTopicModel topicModelWithDic:dic];
            
            [_datas addObject:model];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
