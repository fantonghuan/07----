//
//  ZKDetailViewController.h
//  爱限免-框架
//
//  Created by cyan on 15-3-11.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "ZKRootViewController.h"
#import "LookSnapShotViewController.h"
@class AppListModel;

@interface ZKDetailViewController : ZKRootViewController

@property (nonatomic, strong) AppListModel *detailModel;
@property (nonatomic, copy) NSString *proTitle;

@end
