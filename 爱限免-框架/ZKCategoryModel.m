//
//  ZKCategoryModel.m
//  爱限免-框架
//
//  Created by cyan on 15-3-12.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "ZKCategoryModel.h"

@implementation ZKCategoryModel

+ (ZKCategoryModel *)modelWithDic:(NSDictionary *)dic {
    return [[ZKCategoryModel alloc] initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _category_id = dic[@"category_id"];
        _category_name = dic[@"category_name"];
        _limited = dic[@"limited"];
        _free = dic[@"free"];
        _category_cname = dic[@"category_cname"];
        _category_count = dic[@"category_count"];
        
    }
    return self;
}

@end
