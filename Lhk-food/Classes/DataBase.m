//
//  DataBase.m
//  爱普笔记
//
//  Created by ldci on 14-6-24.
//  Copyright (c) 2014年 ldci. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase

static DataBase *data;
+(DataBase *) database
{
    if (data) {
        return data;
    }
    data = [[DataBase alloc] initWithDBName:@"database.sqlite3"];
    return data;
}

+(DataBase *)databaseWithDBName:(NSString*)dbName
{
    if (data) {
        return data;
    }
    data = [[DataBase alloc] initWithDBName:dbName];
    return data;
}

-(id)initWithDBName:(NSString*)dbName
{

    if (self == [super init]) {
        [self createDBWithName:dbName];
    }
    return self;
}

//获取沙盒中数据库的路径
-(NSString*)getPath:(NSString*)fileName
{
    // 获取路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray lastObject];
    return  [path stringByAppendingPathComponent:fileName];
    
}

//创建数据库
-(BOOL)createDBWithName:(NSString*)dbName
{
    
    NSString *pathForSQL = [self getPath:dbName];
    
    if (sqlite3_open([pathForSQL UTF8String], &_database) != SQLITE_OK){
        sqlite3_close(_database);
        return NO;
    }
    return YES;
}
//关闭数据库
-(BOOL)closeDB
{
    if(sqlite3_close(self.database) == SQLITE_OK)
    {
        return YES;
    }
    else return NO;
    
}

@end
