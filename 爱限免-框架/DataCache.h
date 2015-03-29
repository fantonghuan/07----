//
//  DataCache.h
//  爱限免-框架
//
//  Created by cyan on 15-3-13.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject

//通过类方法得到唯一的类方法
+ (DataCache *)shareDataCache;

//释放对象
+(void)releaseDataCache;

//存数据
- (void)saveDaata:(NSData *)data withUrlString:(NSString *)url;

//取数据
- (NSData *)getDataWithUrlString:(NSString *)url;

@end
