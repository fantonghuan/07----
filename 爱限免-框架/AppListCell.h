//
//  AppListCell.h
//  爱限免-框架
//
//  Created by cyan on 15-3-11.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarView;
@class AppListModel;

@interface AppListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *fileSizeLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *sharedLabel;
@property (nonatomic, strong) UILabel *collectLabel;
@property (nonatomic, strong) UILabel *downLoadLabel;

+ (AppListCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) StarView *myStarView;

@property (nonatomic, strong) AppListModel *MyModel;

@end
