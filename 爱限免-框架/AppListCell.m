//
//  AppListCell.m
//  爱限免-框架
//
//  Created by cyan on 15-3-11.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "AppListCell.h"
#import "StarView.h"
#import "UIKit+AFNetworking.h"
#import "AppListModel.h"

@implementation AppListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //背景视图cate_list_bg2
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_list_bg2"]];
        
        self.backgroundView = backgroundView;
        
        //左边的图片
        CGFloat leftGap = 15;
        CGFloat gap = 10;
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftGap, gap, 60, 60)];
//        _leftImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_leftImageView];
        
        //软件名称
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame)+gap, gap, 120, 30)];
//        _nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.font = UIBOLDFONT16;
        
        //星星
        _myStarView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame)+gap, CGRectGetMaxY(_nameLabel.frame), 80, 25)];
        
        [self.contentView addSubview:_myStarView];
        
        //大小
        _fileSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), 15, 70, 25)];
//        _fileSizeLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_fileSizeLabel];
        _categoryLabel.font = UIFONT13;
        
        //属性
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), CGRectGetMaxY(_fileSizeLabel.frame), 50, 25)];
//        _categoryLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_categoryLabel];
        _categoryLabel.font = UIFONT13;
        
        //分享
        _sharedLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftGap, CGRectGetMaxY(_leftImageView.frame), 100, 20)];
//        _sharedLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_sharedLabel];
        _sharedLabel.font = UIFONT13;
        //收藏
        _collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sharedLabel.frame), CGRectGetMaxY(_leftImageView.frame), 100, 25)];
//        _collectLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_collectLabel];
        _collectLabel.font = UIFONT13;
        
        //下载
        _downLoadLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), CGRectGetMaxY(_leftImageView.frame), 100, 25)];
//        _downLoadLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_downLoadLabel];
        _downLoadLabel.font = UIFONT13;
        
    }
    return self;
}

- (void)setMyModel:(AppListModel *)MyModel {
    _MyModel = MyModel;
    [_leftImageView setImageWithURL:[NSURL URLWithString:MyModel.iconUrl]];
    //图形切成圆角
    _leftImageView.clipsToBounds = YES;
    _leftImageView.layer.cornerRadius = 10;
    
    _nameLabel.text = MyModel.name;
    [_myStarView setStar:[MyModel.starCurrent floatValue]];
    
    
    _fileSizeLabel.text = [NSString stringWithFormat:@"%@MB",MyModel.fileSize];
    
    _categoryLabel.text = MyModel.categoryName;
    
    _sharedLabel.text = [NSString stringWithFormat:@"分享%@", MyModel.shares];
    
    _collectLabel.text = [NSString stringWithFormat:@"收藏%@", MyModel.favorites];
    
    _downLoadLabel.text = [NSString stringWithFormat:@"下载%@", MyModel.downloads];
    
}

+ (AppListCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ident = @"Cell";
    
    AppListCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        cell = [[AppListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
