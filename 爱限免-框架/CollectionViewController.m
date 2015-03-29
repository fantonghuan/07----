//
//  CollectionViewController.m
//  爱限免-框架
//
//  Created by cyan on 15-3-13.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "CollectionViewController.h"
#import "AppListModel.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

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
    
    [self setUI];
}

- (void)setUI {
    
    DataCenter *center = [DataCenter singleInstance];
    
    NSArray *array = [center getApplistWithRecondType:RecondTypeWithCollection];
    
    CGFloat w = 80;
    CGFloat h = 80;
    
    CGFloat gap = 20;
    
    for (int i = 0; i < array.count; i++) {
        
        CGFloat row = i/3;
        CGFloat col = i%3;
        
//        UIImageView
        
        AppListModel *model = array[i];
        
        ZKButton *button = [ZKButton buttonWithFrame:CGRectMake(gap+(w+gap)*col, 70+row*(h+gap*2), w, h) type:UIButtonTypeCustom title:nil backgroundImage:nil image:nil andBlock:^(ZKButton *button) {
            
            if (0 == i) {
                NSLog(@"%i", i);
            }
            
        }];
        
        [button setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.iconUrl]];
        
//        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.iconUrl]];
        
        [self.view addSubview:button];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(gap+(w+gap)*col, 70+row*(h+gap*2)+85, w, 30)];
        
        name.text = model.name;
        
        [self.view addSubview:name];
    }
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
