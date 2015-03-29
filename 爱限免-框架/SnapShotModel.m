//
//  SnapShotModel.m
//  爱限免-框架
//
//  Created by cyan on 15-3-11.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "SnapShotModel.h"

@implementation SnapShotModel

+ (SnapShotModel *)modelWithDic:(NSDictionary *)dic {
    return [[SnapShotModel alloc] initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
