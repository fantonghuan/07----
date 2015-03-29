//
//  CategoryCell.m
//  爱限免-框架
//
//  Created by cyan on 15-3-12.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "CategoryCell.h"
#import "ZKCategoryModel.h"

@implementation CategoryCell

- (void)setMyModel:(ZKCategoryModel *)myModel {
    _myModel = myModel;
    NSString *string = [NSString stringWithFormat:@"category_%@.jpg", myModel.category_name];
    _leftView.image = [UIImage imageNamed:string];
    
    _nameLabel.text = myModel.category_cname;
    
    _detailLabel.text = [NSString stringWithFormat:@"去哦那个有%@款应用，其中限免%@款", myModel.category_count, myModel.limited];
    
    
}

+ (CategoryCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ident = @"Cell";
    
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat leftGap = 10;
        CGFloat gap = 5;
        
        //添加背景
        UIImageView *background = [[UIImageView alloc] initWithFrame:self.bounds];
        background.image = [UIImage imageNamed:@"cate_list_bg"];
        self.backgroundView = background;
        
        //左边的图片
        _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(leftGap, gap, 80, 80)];
        _leftView.clipsToBounds = YES;
        _leftView.layer.cornerRadius = 10;
        [self.contentView addSubview:_leftView];
        
        //名称
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame)+gap, gap, 200, 40)];
        
        [self.contentView addSubview:_nameLabel];
        
        //详情
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame)+gap, CGRectGetMaxY(_nameLabel.frame), 220, 40)];
        
        [self.contentView addSubview:_detailLabel];
        _detailLabel.font = UIFONT13;
        
        
    }
    return self;
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
