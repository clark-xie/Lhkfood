//
//  GroupTable.m
//  爱普笔记
//
//  Created by ldci on 14-6-24.
//  Copyright (c) 2014年 ldci. All rights reserved.
//

#import "GroupTable.h"


@implementation GroupTable

static GroupTable *group;
+(GroupTable*)groupTable
{
    if (group == nil) {
        group = [[GroupTable alloc] init];
    }
    return group;
}

-(id)init
{
    if (self == [super init]) {
        if ([self initDatabase]) {
            NSLog(@"数据库初始化成功");
            if ([self createTable]) {
                NSLog(@"数据表group创建成功");
            }
            else NSLog(@"数据表group创建失败");
            
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
    NSString *sql = @"create table if not exists groupTable (ID integer Primary Key Autoincrement, title text UNIQUE not null,date text);";
    sqlite3_stmt *stmt;
    //    char *erro;
    //    if (sqlite3_exec(sql, [createStringSql UTF8String], NULL, NULL, &erro) != SQLITE_OK) {
    //        return NO;
    //    }
    //准备SQL语句：将nsstring类型sql语句转换为可执行语句，复制给stmt
    if (sqlite3_prepare_v2(self.data.database, [sql UTF8String], -1, &stmt, nil) != SQLITE_OK) {
        return NO;
    }
    //执行stmt中的在prepare中生成的sql语句
    sqlite3_step(stmt);
    //释放stmt指针，防止内存泄漏
    sqlite3_finalize(stmt);
    return YES;
}
#pragma  mark - insert
//插入数据
-(BOOL)insertDataWithTitle:(NSString*)title
{

    NSString *date = [self getCurrentDate];
    
    NSString *str = [NSString stringWithFormat:@"insert or replace into grouptable(title,date)values('%@','%@')",title,date];
    NSLog(@"%@",str);
    
  
    char *error;
    if (sqlite3_exec(self.data.database, [str UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"insertData error is %s",error);
        return NO;
    }
    
    return YES;
}
-(BOOL)insertDataWithID:(int)idNum Title:(NSString*)title
{

    NSString *date = [self getCurrentDate];
    
    char *insert = "insert or replace into grouptable values(?,?,?);";//?问号会使用下面的数字1，2，3代替"
    NSLog(@"%@",[NSString stringWithUTF8String:insert]);
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(self.data.database, insert, -1, &stmt, nil) != SQLITE_OK) {
        
        sqlite3_finalize(stmt);
        return NO;
    }
    sqlite3_bind_int(stmt, 1, idNum);
    sqlite3_bind_text(stmt, 2, [title UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [date UTF8String], -1, NULL);
    
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);

        return NO;
    }
    
    return YES;
/*
   
    NSString *str = [NSString stringWithFormat:@"insert or replace into grouptable(id,title)values(%d,'%@')",idNum,title];
    NSLog(@"%@",str);
    char *error;
    if (sqlite3_exec(self.data.database, [str UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"insertData error is %s",error);
        return NO;
    }
      
    return YES;
 */
}


-(BOOL)deleteDataWithTitle:(NSString*)title
{
    NSString *str = [NSString stringWithFormat:@"delete from grouptable where title = %@",title];
    NSLog(@"%@",str);
    char *error;
    if(sqlite3_exec(self.data.database, [str UTF8String], NULL, NULL, &error) != SQLITE_OK)//使用exec方法sql语句就不能用？,如果想用的话就必须使用字符串拼接
    {
        NSLog(@"deleteData error is %s",error);
        return NO;
    }
    
    return YES;
}
#pragma mark - update
//更新数据
-(BOOL)updateGroupTitle:(NSString*)title AtID:(int)idNum
{
    
    NSString *str = [NSString stringWithFormat:@"update grouptable set title = '%@' where id = %d",title,idNum];
    NSLog(@"%@",str);
    
    char *error;
    if (sqlite3_exec(self.data.database, [str UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"%s",error);
        return NO;
    }
    return YES;
}
-(BOOL)updateGroupTitle:(NSString*)title withNewTitle:(NSString*)newTitle
{
    NSString *str = [NSString stringWithFormat:@"update grouptable set title = '%@' where id = '%@'",title,newTitle];
    NSLog(@"%@",str);
    
    char *error;
    if (sqlite3_exec(self.data.database, [str UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"%s",error);
        return NO;
    }
    return YES;
}
#pragma mark - select
//选择数据
-(NSArray *)selectAllData
{
    char *sql = "select * from grouptable";
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(self.data.database, sql , -1, &stmt,NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int idNum = sqlite3_column_int(stmt, 0);
            char *title = (char *)sqlite3_column_text(stmt, 1);
            char *date = (char *)sqlite3_column_text(stmt, 2);
             
            NSArray *array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",idNum],[NSString stringWithUTF8String:title], [NSString stringWithUTF8String:date], nil];
            
            [mutArray addObject:array];
        }
        sqlite3_finalize(stmt);
        return mutArray;

    }
    else
    {
        sqlite3_finalize(stmt);
        NSLog(@"select data is fail");
        return nil;
    }
    
}

-(NSArray *)selectDataAtID:(int)groupId
{
    NSString *sql = [NSString stringWithFormat:@"select * from grouptable where id = %d",groupId];
    NSLog(@"%@",sql);
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(self.data.database, [sql UTF8String] , -1, &stmt,NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int idNum = sqlite3_column_int(stmt, 0);
            char *title = (char *)sqlite3_column_text(stmt, 1);
            char *date = (char *)sqlite3_column_text(stmt, 2);
            
            NSArray *array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",idNum],[NSString stringWithUTF8String:title], [NSString stringWithUTF8String:date], nil];
            
            [mutArray addObject:array];
        }
        sqlite3_finalize(stmt);
        return mutArray;
        
    }
    else
    {
        sqlite3_finalize(stmt);
        NSLog(@"select data is fail");
        return nil;
    }
}

-(NSArray *)selectDataTitle:(NSString*)title
{
    char *sql = "select * from grouptable";
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(self.data.database, sql , -1, &stmt,NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int idNum = sqlite3_column_int(stmt, 0);
            char *title = (char *)sqlite3_column_text(stmt, 1);
            char *date = (char *)sqlite3_column_text(stmt, 2);
            
            NSArray *array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",idNum],[NSString stringWithUTF8String:title], [NSString stringWithUTF8String:date], nil];
            
            [mutArray addObject:array];
        }
        sqlite3_finalize(stmt);
        return mutArray;
        
    }
    else
    {
        sqlite3_finalize(stmt);
        NSLog(@"select data is fail");
        return nil;
    }
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
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    NSDateFormatter *formater  = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *date = [formater stringFromDate:datePicker.date];
    return date;
}
@end
