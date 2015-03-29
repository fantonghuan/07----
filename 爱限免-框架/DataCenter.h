//
//  DataCenter.h
//  爱限免-框架
//
//  Created by cyan on 15-3-13.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppListModel;
//#import "AppListModel.h"

typedef enum {
    RecondTypeWithCollection = 1,
    RecondTypeWithAttention,
    RecondTypeWithDownload
}RecondType;

@interface DataCenter : NSObject

//得到当前类的对象
+ (DataCenter *)singleInstance;

//增加
- (void)addApplistModel:(AppListModel *)model andRecondType:(RecondType)type;

//删除
- (void)deleteApplistModel:(AppListModel *)model andRecondType:(RecondType)type;

//查找
- (BOOL)selectAppListModel:(AppListModel *)model andRecondType:(RecondType)type;

//获取
- (NSArray *)getApplistWithRecondType:(RecondType)type;

@end
