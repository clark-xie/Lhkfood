//
//  DataTableSeachMessege.m
//  DataTable
//
//  Created by hongda on 14-11-13.
//  Copyright (c) 2014年 ZHYD. All rights reserved.
//

#import "DataTableSeachMessege.h"
#import "DataBase.h"

@interface DataTableSeachMessege ()

@property (strong,nonatomic) DataBase *data;

@end

@implementation DataTableSeachMessege

static DataTableSeachMessege *group;
+(DataTableSeachMessege*)dataTableSeachMessege
{
    if (group == nil) {
        group = [[DataTableSeachMessege alloc] init];
    }
    return group;
}

-(id)init
{
    if (self == [super init]) {
        if ([self initDatabase]) {
            NSLog(@"数据库初始化成功");
            if ([self createTable]) {
                NSLog(@"数据表dataTableSeachMessege创建成功");
            }
            else NSLog(@"数据表dataTableSeachMessege创建失败");
            
        }
        else NSLog(@"数据库初始化失败");
    }
    return self;
}
//初始化数据库
-(BOOL)initDatabase
{
    self.data = [DataBase database];
    if (self.data != nil) {
        return YES;
    }
    else return  NO;
}
#pragma  mark - create
//创建表
-(BOOL)createTable
{
    NSString *sql = @"create table if not exists searchPastMesTable (searchID integer Primary Key Autoincrement, searchWorld text UNIQUE not null,searchDate text);";
    return [self excuteSQL:sql];
}
-(BOOL) insertTableWith:(NSString*)keyWorld
{
    NSString *time = [self getCurrentDate];
    NSString *sql = [NSString stringWithFormat:@"insert or replace into searchPastMesTable(searchWorld,searchDate)values('%@','%@')",keyWorld,time];
   return  [self excuteSQL:sql];
}
-(NSArray*)selectSearchMesWihtNum:(NSInteger)num
{
    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:num];
    NSString *sql = [NSString stringWithFormat:@"select * from searchPastMesTable order by searchID desc limit 0,%ld;",num];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(self.data.database, [sql UTF8String] , -1, &stmt,NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            char *keyWorld = (char *)sqlite3_column_text(stmt, 1);
            
            [mutArray addObject:[NSString stringWithUTF8String:keyWorld]];
        }
        sqlite3_finalize(stmt);
        NSLog(@"select data is success");
        return mutArray;
        
    }
    else
    {
        sqlite3_finalize(stmt);
        NSLog(@"select data is fail");
        return nil;
    }
}
-(BOOL)deleteAllData
{
    NSString *sql = @"delete from searchPastMesTable";
    return  [self excuteSQL:sql];
}
-(BOOL)excuteSQL:(NSString*)sql
{
    char *error;
    NSLog(@"sql:%@",sql);
    if (sqlite3_exec(self.data.database, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK)
    {
            NSLog(@"error:%s",error);
            return NO;
    }
    return YES;
}

#pragma mark - closeDB
//关闭数据库
-(BOOL)closeDB
{
    return [self.data closeDB];
}
#pragma mark - getdate
-(NSString*)getCurrentDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formater  = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formater stringFromDate:date];
    return currentTime;
}

@end
