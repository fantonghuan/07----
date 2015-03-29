//
//  ZKTopicModel.h
//  爱限免-框架
//
//  Created by cyan on 15-3-12.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKTopicModel : NSObject

@property (nonatomic, strong) NSArray *applications;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *desc_img;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *title;

+ (ZKTopicModel *)topicModelWithDic:(NSDictionary *)dic;

@end
