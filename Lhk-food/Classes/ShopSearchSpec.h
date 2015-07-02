//
//  ShopSearchSpec.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/22.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, CategoryType) {
    CategoryTypeAll = 0,//所有食物类型，需要更新
    CategoryTypeFood = 1,
    CategoryTypeFood1,
    CategoryTypeFood2,
};





//查询店铺是的关键字
@interface ShopSearchSpec : NSObject

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong)NSNumber *category;
@property double lat;
@property double lng;
@property double scope;
@property NSInteger shopid;

@property NSInteger totalCount; //总数
@property NSInteger currentPage;
@property NSInteger numberPerPage;
@property NSInteger resultCount;

//"totalCount":"16","numberPerPage":10,"currentPage":"1","resultCount":10
@end
