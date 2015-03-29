//
//  DataCache.m
//  爱限免-框架
//
//  Created by cyan on 15-3-13.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "DataCache.h"
#import "NSString+Hashing.h"

@implementation DataCache

static DataCache *cache = nil;

+ (DataCache *)shareDataCache {
    @synchronized(self){//线程安全
        if (cache == nil) {//两种方式都可以
            cache = [[DataCache alloc] init];
            
//            cache = [[[self class] alloc] init];
        }
    }
    
    return cache;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    if (cache == nil) {
        cache = [super allocWithZone:zone];
    }
    
    return cache;
}

+ (void)releaseDataCache {
    if (cache != nil) {
        cache = nil;
    }
}

- (void)saveDaata:(NSData *)data withUrlString:(NSString *)url {
    
    //完整的路径
    NSString *path = [NSString stringWithFormat:@"%@/Documents/DataCache/", NSHomeDirectory()];
    
    //文件管理类
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建当前的文件夹
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    //加密MD5 通过加密可以得到一个固定（16）长度的值，每个值都是唯一的
    //1.可以加密 2.得到一个固定长度的值
    NSString *str = [url MD5Hash];
    
    BOOL isSuc = [data writeToFile:[NSString stringWithFormat:@"%@%@", path, str] atomically:YES];
    
    if (isSuc) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败");
    }
    
    
    
    
    
}

- (NSData *)getDataWithUrlString:(NSString *)url {
    
    //找路径
    NSString *path = [NSString stringWithFormat:@"%@/Documents/DataCache/%@", NSHomeDirectory(), [url MD5Hash]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isExit = [fileManager fileExistsAtPath:path];
    
    //判断是否存在
    if (!isExit) {
        return nil;
    }
    
    //判断时间(数据是否是有效数据)
    NSTimeInterval timeInte = [[NSDate date] timeIntervalSinceDate:[self getmodifyTime:path]];
    
    //与设置好的时间进行比较
    if (timeInte >= 60) {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return data;
}

//取最后一次存入数据的时间
- (NSDate *)getmodifyTime:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary *dic = [fileManager attributesOfItemAtPath:path error:nil];
    
    NSLog(@"%@", dic);
    /*
     {
     NSFileCreationDate = "2015-03-13 07:04:10 +0000";
     NSFileExtensionHidden = 0;
     NSFileGroupOwnerAccountID = 20;
     NSFileGroupOwnerAccountName = staff;
     NSFileModificationDate = "2015-03-13 07:04:10 +0000";
     NSFileOwnerAccountID = 501;
     NSFilePosixPermissions = 420;
     NSFileReferenceCount = 1;
     NSFileSize = 17086;
     NSFileSystemFileNumber = 2063719;
     NSFileSystemNumber = 16777218;
     NSFileType = NSFileTypeRegular;
     }
     */
    
    return dic[@"NSFileModificationDate"];
}

@end
