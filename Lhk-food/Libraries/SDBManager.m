//
//  SDBManager.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SDBManager.h"
#import "FMDatabase.h"

#define kDefaultDBName @"hbch"

@interface SDBManager ()

@end

@implementation SDBManager

static SDBManager * _sharedDBManager;

+ (SDBManager *) defaultDBManager {
	if (!_sharedDBManager) {
		_sharedDBManager = [[SDBManager alloc] init];
	}
	return _sharedDBManager;
}



- (id) init {
    self = [super init];
    if (self) {
        int state = [self initializeDBWithName:kDefaultDBName];
        if (state == -1) {
            NSLog(@"数据库初始化失败");
        } else {
            NSLog(@"数据库初始化成功");
        }
    }
    return self;
}

/**
 * @brief 初始化数据库操作
 * @param name 数据库名称
 * @return 返回数据库初始化状态， 0 为 已经存在，1 为创建成功，-1 为创建失败
 */
- (int) initializeDBWithName : (NSString *) name {
    if (!name) {
		return -1;  // 返回数据库创建失败
	}
    // 沙盒Docu目录
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
	_name = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@%@",name,@".sqlite"]];
	NSFileManager * fileManager = [NSFileManager defaultManager];
    NSLog(@"%@",_name);
    BOOL exist = [fileManager fileExistsAtPath:_name];
    [self connect];
    if (!exist) {
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:name ofType:@"sqlite"];
        if (backupDbPath == nil) {
            // couldn't find backup db to copy, bail
            return NO;
        } else {
            BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:_name error:nil];
            if (copiedBackupDb) {
                // copying backup db failed, bail
                NSLog(@"%@",@"复制成功");
            }
        }
        return 0;
    } else {
        return 1;          // 返回 数据库已经存在
        
	}
    
}

//判断数据库是否存在，不存在Copy
- (void)CopyDatabaseIfNeeded{
	
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
    //查看文件目录
    NSLog(@"%@",documentFolderPath);
    NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:@"hbch.db"];
    //END:code.DatabaseShoppingList.findDocumentsDirectory

    //START:code.DatabaseShoppingList.copyDatabaseFileToDocuments
    if (! [[NSFileManager defaultManager] fileExistsAtPath: dbFilePath]) {
        // didn't find db, need to copy
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"hbch" ofType:@"db"];
        if (backupDbPath == nil) {
            // couldn't find backup db to copy, bail
            
        } else {
            BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
            if (! copiedBackupDb) {
                // copying backup db failed, bail
            }
            else{
                [self connect];
            }
        }
    }
	else {
		[self connect];
	}
}


/// 连接数据库
- (void) connect {
	if (!_dataBase) {
		_dataBase = [[FMDatabase alloc] initWithPath:_name];
	}
	if (![_dataBase open]) {
		NSLog(@"不能打开数据库");
	}
}
/// 关闭连接
- (void) close {
	[_dataBase close];
    _sharedDBManager = nil;
}

@end
