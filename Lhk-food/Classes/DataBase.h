//
//  DataBase.h
//  爱普笔记
//
//  Created by ldci on 14-6-24.
//  Copyright (c) 2014年 ldci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBase : NSObject


@property sqlite3 *database;

@property (strong,nonatomic) NSString *dbname;

+(DataBase *) database;
+(DataBase *)databaseWithDBName:(NSString*)dbName;
//创建库
-(BOOL)createDBWithName:(NSString*)dbName;
-(BOOL)closeDB;
@end
