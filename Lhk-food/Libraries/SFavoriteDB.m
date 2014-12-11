//
//  SUserDB.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SFavoriteDB.h"

#define kFavoriteTableName @"Favorite"
#define kHistoryTableName @"History"
#import "FMDatabase.h"

@implementation SFavoriteDB

- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
        _db = [SDBManager defaultDBManager].dataBase;
        
    }
    return self;
}

/**
 * @brief 创建数据库表
 */
- (void) createFavoritDataBase {
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kFavoriteTableName]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
         NSLog(@"数据库已经存在");
    } else {
        // TODO: 插入新的数据库
        NSString * dropfsql = @"drop table Favorite";
        NSString * fsql = @"CREATE TABLE Favorite (uid INTEGER PRIMARY KEY  AUTOINCREMENT NOT NULL ,FavoriteName VARCHAR(30),Name VARCHAR(60),AddrName VARCHAR(60),x VARCHAR(30),y VARCHAR(30),level VARCHAR(30))";
        BOOL fres = [_db executeUpdate:fsql];
        if (!fres) {
            NSLog(@"数据库创建失败");
            //[_db executeUpdate:dropfsql];
            //[_db executeUpdate:fsql];
        } else {
              NSLog(@"数据库书签表创建成功");
        }
        NSString *drophsql = @"drop table History";
        NSString * hsql = @"CREATE TABLE History (uid INTEGER PRIMARY KEY  AUTOINCREMENT NOT NULL ,name VARCHAR(30))";
        BOOL hres = [_db executeUpdate:hsql];
        if (!hres) {
            NSLog(@"数据库创建失败");
            //[_db executeUpdate:drophsql];
            //[_db executeUpdate:hsql];
        } else {
            NSLog(@"数据库历史搜索表创建成功");
        }
        
        NSString * lsql = @"CREATE TABLE Label (uid INTEGER PRIMARY KEY  AUTOINCREMENT NOT NULL ,Name VARCHAR(60),x VARCHAR(30),y VARCHAR(30),level VARCHAR(30))";
        BOOL lres = [_db executeUpdate:lsql];
        if (!lres) {
            NSLog(@"数据库创建失败");
            //[_db executeUpdate:dropfsql];
            //[_db executeUpdate:fsql];
        } else {
            NSLog(@"数据库标注表创建成功");
        }
    }
}

/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (BOOL) saveFavorite:(SFavorite *) favorite {
    BOOL isSave=NO;
   // NSMutableString * allquery = [NSMutableString stringWithFormat:@"SELECT * FROM Favorite WHERE FavoriteName = '%@'",favorite.favoriteName];
    if ([self getFavorite:favorite]==nil) {
        [self insertFavorite:favorite];
        isSave = YES;
    }
    else
    {
        [self updataFavorite:favorite];
    }
    
    return isSave;
}
-(void)insertFavorite:(SFavorite *) favorite{
    BOOL isSave=NO;
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO Favorite"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
    if (favorite.FavoriteName) {
        [keys appendString:@"FavoriteName,"];
        [values appendString:@"?,"];
        [arguments addObject:favorite.FavoriteName];
    }
    if (favorite.Name) {
        [keys appendString:@"Name,"];
        [values appendString:@"?,"];
        [arguments addObject:favorite.Name];
    }
    if (favorite.Address) {
        [keys appendString:@"AddrName,"];
        [values appendString:@"?,"];
        [arguments addObject:favorite.Address];
    }
    if (favorite.x) {
        [keys appendString:@"x,"];
        [values appendString:@"?,"];
        [arguments addObject:favorite.x];
    }
    if (favorite.y) {
        [keys appendString:@"y,"];
        [values appendString:@"?,"];
        [arguments addObject:favorite.y];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    NSLog(@"%@",query);
    
    if([_db executeUpdate:query withArgumentsInArray:arguments])
    {
        isSave = YES;
    }
}

-(NSString*)getFavorite:(SFavorite *) favorite
{
    NSMutableString * query = [NSString stringWithFormat:@"SELECT * FROM Favorite where "];
    NSString *uid=nil;
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    if (favorite.FavoriteName) {
        [temp appendFormat:@"FavoriteName = '%@'",favorite.FavoriteName];
    } 
    [temp appendFormat:@"name = '%@'",favorite.Name];
    [temp appendFormat:@"and x = '%@'",favorite.x];
    [temp appendFormat:@"and y = '%@'",favorite.y];
    query = [query stringByAppendingFormat: [NSString stringWithFormat:@"%@",temp]];
    NSLog(@"%@",query);
    FMResultSet * rs = [_db executeQuery:query];
    if (rs.next) {
        uid=[rs stringForColumn:@"uid"];
    }
    return uid;
}
/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (BOOL) deleteFavorite:(NSString *) uid {
   // NSString *uid = [self getFavorite:favorite];
    NSString * query = [NSString stringWithFormat:@"DELETE FROM Favorite WHERE uid = '%@'",uid];
   return [_db executeUpdate:query];
}

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
- (BOOL) updataFavorite:(SFavorite *) favorite {
    favorite.uid = [self getFavorite:favorite];
    if (!favorite.uid) {
        return NO;
    }
    NSString * query = @"UPDATE Favorite SET";
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    // xxx = xxx;
    if (favorite.FavoriteName) {
        [temp appendFormat:@" FavoriteName = '%@',",favorite.FavoriteName];
    }
    if (favorite.Name) {
        [temp appendFormat:@" Name = '%@',",favorite.Name];
    }
    if (favorite.Address) {
        [temp appendFormat:@" AddrName = '%@',",favorite.Address];
    }
    if (favorite.x) {
        [temp appendFormat:@" x = '%@',",favorite.x];
    }
    if (favorite.y) {
        [temp appendFormat:@" y = '%@',",favorite.y];
    }
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE uid = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],favorite.uid];
    NSLog(@"%@",query);
    
    return [_db executeUpdate:query];
}

-(NSArray*)getAllFavorite
{
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM Favorite"];
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
	while ([rs next]) {
        SFavorite * favorite = [SFavorite new];
        favorite.uid = [rs stringForColumn:@"uid"];
        favorite.Name = [rs stringForColumn:@"Name"];
        favorite.FavoriteName = [rs stringForColumn:@"FavoriteName"];
        favorite.Address = [rs stringForColumn:@"AddrName"];
        favorite.x = [rs stringForColumn:@"x"];
        favorite.y = [rs stringForColumn:@"y"];
        [array addObject:favorite];
	}
	[rs close];
    return array;
    
}

-(void)saveHistory:(SHistory*)history
{
    NSString * gquery = [NSString stringWithFormat:@"SELECT * FROM History WHERE name = '%@'",history.name];
     NSLog(@"%@",gquery);
    FMResultSet * rs = [_db executeQuery:gquery];

    if (![rs next]) {
        NSMutableString * uquery = [NSMutableString stringWithFormat:@"INSERT INTO History"];
        NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
        if (history.name) {
            [keys appendString:@"name,"];
            [values appendString:@"?,"];
            [arguments addObject:history.name];
        }
        [keys appendString:@")"];
        [values appendString:@")"];
        [uquery appendFormat:@" %@ VALUES%@",
         [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
         [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
        NSLog(@"%@",uquery);
        
        [_db executeUpdate:uquery withArgumentsInArray:arguments];
    }
    [rs close];
}


-(void)deleteAllHistory
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM History"];
    [_db executeUpdate:query];
}
-(NSArray*)getAllHistory
{
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM History"];

    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
	while ([rs next]) {
        SHistory * history = [SHistory new];
        history.uid = [rs stringForColumn:@"uid"];
        history.name = [rs stringForColumn:@"name"];
        [array addObject:history];
	}
	[rs close];
    return array;

}




/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (BOOL) saveLabel:(LabelObject *) label {
    BOOL isSave=NO;
    // NSMutableString * allquery = [NSMutableString stringWithFormat:@"SELECT * FROM Favorite WHERE FavoriteName = '%@'",favorite.favoriteName];
    if ([self getLabel:label]==nil) {
        [self insertLabel:label];
        isSave = YES;
    }
    else
    {
        [self updataLabel:label];
    }
    
    return isSave;
}
-(void)insertLabel:(LabelObject *) label{
    BOOL isSave=NO;
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO Label"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];

    if (label.Name) {
        [keys appendString:@"Name,"];
        [values appendString:@"?,"];
        [arguments addObject:label.Name];
    }
    /*if (label.Level) {
        [keys appendString:@"level,"];
        [values appendString:@"?,"];
        [arguments addObject:label.Level];
    }*/
    if (label.X) {
        [keys appendString:@"x,"];
        [values appendString:@"?,"];
        [arguments addObject:label.X];
    }
    if (label.Y) {
        [keys appendString:@"y,"];
        [values appendString:@"?,"];
        [arguments addObject:label.Y];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    NSLog(@"%@",query);
    
    if([_db executeUpdate:query withArgumentsInArray:arguments])
    {
        isSave = YES;
    }
}

-(NSString*)getLabel:(LabelObject *) Label
{
    NSMutableString * query = [NSString stringWithFormat:@"SELECT * FROM Label where "];
    NSString *uid=nil;
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    if (Label.Name) {
        [temp appendFormat:@"Name = '%@'",Label.Name];
    }
    //[temp appendFormat:@"level = '%@'",Label.Level];
    [temp appendFormat:@"and x = '%@'",Label.X];
    [temp appendFormat:@"and y = '%@'",Label.Y];
    query = [query stringByAppendingFormat: [NSString stringWithFormat:@"%@",temp]];
    NSLog(@"%@",query);
    FMResultSet * rs = [_db executeQuery:query];
    if (rs.next) {
        uid=[rs stringForColumn:@"uid"];
    }
    return uid;
}
/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (BOOL) deleteLabel:(NSString *) uid {
    // NSString *uid = [self getFavorite:favorite];
    NSString * query = [NSString stringWithFormat:@"DELETE FROM Label WHERE uid = '%@'",uid];
    return [_db executeUpdate:query];
}

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
- (BOOL) updataLabel:(LabelObject *) label {
    label.uid = [self getLabel:label];
    if (!label.uid) {
        return NO;
    }
    NSString * query = @"UPDATE Label SET";
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    // xxx = xxx;
    if (label.Name) {
        [temp appendFormat:@" Name = '%@',",label.Name];
    }
    /*if (label.Level) {
        [temp appendFormat:@" level = '%@',",label.Level];
    }*/
    if (label.X) {
        [temp appendFormat:@" x = '%@',",label.X];
    }
    if (label.Y) {
        [temp appendFormat:@" y = '%@',",label.Y];
    }
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE uid = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],label.uid];
    NSLog(@"%@",query);
    
    return [_db executeUpdate:query];
}

-(NSArray*)getAllLabel
{
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM Label"];
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
	while ([rs next]) {
        LabelObject * label = [LabelObject new];
        label.uid = [rs stringForColumn:@"uid"];
        label.Name = [rs stringForColumn:@"Name"];
       // label.Level = [rs stringForColumn:@"level"];
        label.X = [rs stringForColumn:@"x"];
        label.Y = [rs stringForColumn:@"y"];
        [array addObject:label];
	}
	[rs close];
    return array;
    
}
/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */
/*- (NSArray *) findWithUid:(NSString *) uid limit:(int) limit {
    NSString * query = @"SELECT uid,name,description FROM SUser";
    if (!uid) {
        query = [query stringByAppendingFormat:@" ORDER BY uid DESC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" WHERE uid > %@ ORDER BY uid DESC limit %d",uid,limit];
    }

    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
	while ([rs next]) {
        SUser * user = [SUser new];
        user.uid = [rs stringForColumn:@"uid"];
        user.name = [rs stringForColumn:@"name"];
        user.description = [rs stringForColumn:@"description"];
        [array addObject:user];
	}
	[rs close];
    return array;
}*/

@end
