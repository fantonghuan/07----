//
//  SnapShotModel.h
//  爱限免-框架
//
//  Created by cyan on 15-3-11.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnapShotModel : NSObject

@property (nonatomic, copy) NSString *smallUrl;
@property (nonatomic, copy) NSString *originalUrl;

+ (SnapShotModel *)modelWithDic:(NSDictionary *)dic;

@end
