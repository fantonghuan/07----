//
//  SearchAppViewController.m
//  爱限免-框架
//
//  Created by cyan on 15-3-12.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "SearchAppViewController.h"

@interface SearchAppViewController () <UIAlertViewDelegate>

@end

@implementation SearchAppViewController

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
    
    self.title = @"搜索界面";
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self downloadData];
}

#pragma mark -- alerViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)downloadData {
    
    //小技巧,将输入的中文转化成计算机可以操作的形式
    NSString *string = [_text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *path = [NSString stringWithFormat:SEARCH_URL,string];
    NSLog(@"%@", path);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *subDic = dic[@"appcount"];
        
        NSNumber *appCount = subDic[@"all"];
        
        if ([appCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，咩有找到相关的应用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        } else {
            NSLog(@"创建表");
        }
        
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
