//
//  SUserDB.h
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SDBManager.h"
#import "SFavorite.h"
#import "SHistory.h"
#import "LabelObject.h"

@interface SFavoriteDB : NSObject {
    FMDatabase * _db;
    
}


/**
 * @brief 创建数据库
 */
- (void) createFavoritDataBase;
/**
 * @brief 保存一条用户记录
 * 
 * @param user 需要保存的用户数据
 */
- (BOOL) saveFavorite:(SFavorite *) favorite;

/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (BOOL) deleteFavorite:(NSString *) uid ;

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
- (BOOL) updataFavorite:(SFavorite *) favorite;
-(NSString*)getFavorite:(SFavorite *) favorite;
-(NSArray*)getAllFavorite;
-(void)saveHistory:(SHistory*)history;
-(void)deleteAllHistory;
-(NSArray*)getAllHistory;


- (BOOL) saveLabel:(LabelObject *) label ;
-(void)insertLabel:(LabelObject *) label;
-(NSString*)getLabel:(LabelObject *) Label;
- (BOOL) deleteLabel:(NSString *) uid;
- (BOOL) updataLabel:(LabelObject *) label;
-(NSArray*)getAllLabel;
/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid 
 * @param limit 每页取多少个
 */
//- (NSArray *) findWithUid:(NSString *) uid limit:(int) limit;

@end
