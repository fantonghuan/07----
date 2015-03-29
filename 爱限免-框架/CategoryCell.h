//
//  CategoryCell.h
//  爱限免-框架
//
//  Created by cyan on 15-3-12.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKCategoryModel;

@interface CategoryCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) ZKCategoryModel *myModel;

+ (CategoryCell *)cellWithTableView:(UITableView *)tableView;

@end
