//
//  LookSnapShotViewController.m
//  爱限免-框架
//
//  Created by cyan on 15-3-11.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "LookSnapShotViewController.h"
#import "SnapShotModel.h"

@implementation LookSnapShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]  initWithFrame:self.view.bounds];
    
    [imageView setImageWithURL:[NSURL URLWithString:_snapShotModel.originalUrl]];
    
    [self.view addSubview:imageView];
}

@end
