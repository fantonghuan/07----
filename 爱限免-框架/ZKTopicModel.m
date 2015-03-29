//
//  ZKTopicModel.m
//  爱限免-框架
//
//  Created by cyan on 15-3-12.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "ZKTopicModel.h"
#import "AppListModel.h"

@implementation ZKTopicModel

+ (ZKTopicModel *)topicModelWithDic:(NSDictionary *)dic {
    return [[ZKTopicModel alloc] initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        //先利用kvc转化外层字典
        [self setValuesForKeysWithDictionary:dic];
        
        NSMutableArray *mutArray = [NSMutableArray array];
        
        //转化内层字典
        for (NSDictionary *subDic in _applications) {
            AppListModel *model = [AppListModel applistModelWithDic:subDic];
            
            [mutArray addObject:model];
        }
        
        _applications = mutArray;
        
    }
    return self;
}


@end
