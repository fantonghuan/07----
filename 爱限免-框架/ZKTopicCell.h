//
//  ZKTopicCell.h
//  爱限免-框架
//
//  Created by cyan on 15-3-12.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKTopicRightView;
@class ZKTopicModel;

@interface ZKTopicCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *leftView;
//@property (nonatomic, strong) ZKTopicRightView *rightView;
@property (nonatomic, strong) UIImageView *detailView;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) ZKTopicModel *topicModel;

+ (ZKTopicCell *)cellWithTableView:(UITableView *)tableView;


@end
