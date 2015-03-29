//
//  DataCenter.m
//  爱限免-框架
//
//  Created by cyan on 15-3-13.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "DataCenter.h"
#import "AppListModel.h"
#import "FMDatabase.h"

@interface DataCenter ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation DataCenter

static DataCenter *center = nil;

+ (DataCenter *)singleInstance {
    @synchronized(self) {
        if (center == nil) {
            center = [[DataCenter alloc] init];
        }
    }
    
    return center;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!center) {
        center = [super allocWithZone:zone];
    }
    return center;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/Database.rdb", NSHomeDirectory()];
        
        //创建数据库
        _database = [[FMDatabase alloc] initWithPath:path];
        
        //打开数据库
        if (_database.open == NO) {
            NSLog(@"打开失败");
            
            return nil;
        }
        
        //创建表
        NSString *sql = @"create table if not exists applist ("
        " id integer primary key autoincrement not null, "
        " recordType varchar(32), "
        " applicationId integer not null, "
        " name varchar(128), "
        " iconUrl varchar(1024), "
        " type varchar(32) ,"
        " lastPrice integer, "
        " currentPrice integer "
        ");";
        
        BOOL isSuc = [_database executeUpdate:sql];
        
        if (isSuc == NO) {
            NSLog(@"创建失败");
        }
    }
    return self;
    
    
}

//增加
- (void)addApplistModel:(AppListModel *)model andRecondType:(RecondType)type {
    NSString *sql = @"insert into applist(recordType,applicationId,name,iconUrl,type,lastPrice,currentPrice) values(?,?,?,?,?,?,?)";
    
    BOOL isSuc = [self.database executeUpdate:sql,[NSString stringWithFormat:@"%i",type],model.applicationId,model.name,model.iconUrl,@"limit",model.lastPrice,model.currentPrice];
    
    if (isSuc == NO) {
        NSLog(@"增加失败");
    } else {
        NSLog(@"增加成功");
    }
}

//删除
- (void)deleteApplistModel:(AppListModel *)model andRecondType:(RecondType)type {
    NSString *sql = @"delete from applist where applicationId=? and recordType=?";
    
    BOOL isSuc = [self.database executeUpdate:sql,model.applicationId,[NSString stringWithFormat:@"%i",type]];
    
    if (isSuc == NO) {
        NSLog(@"删除失败");
    } else {
        NSLog(@"删除成功");
    }
}

//查找
- (BOOL)selectAppListModel:(AppListModel *)model andRecondType:(RecondType)type {
    
    NSString *sql = @"select count(*) from applist where applicationId=? and recordType=?";
    
    //结果集
    FMResultSet *set = [self.database executeQuery:sql,model.applicationId,[NSString stringWithFormat:@"%i",type]];
    int count = 0;
    if ([set next]) {
        count = [set intForColumnIndex:0];
    }
    return count;
}

//获取
- (NSArray *)getApplistWithRecondType:(RecondType)type {
 
    NSString *sql = @"select * from applist where recordType=?";
    
    //结果集
    FMResultSet *set = [self.database executeQuery:sql,[NSString stringWithFormat:@"%i",type]];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set next]) {
        AppListModel *model = [[AppListModel alloc]init];
        
        model.applicationId = [set stringForColumn:@"applicationId"];
        model.name = [set stringForColumn:@"name"];
        model.iconUrl = [set stringForColumn:@"iconUrl"];
        
//        model.applicationId = [set stringForColumnIndex:1];
//        model.name = [set stringForColumnIndex:2];
//        model.iconUrl = [set stringForColumnIndex:3];
        
        [array addObject:model];
        
    }
    
    return array;
}

@end
