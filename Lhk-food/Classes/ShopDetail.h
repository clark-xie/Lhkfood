//
//  ShopDetail.h
//  Lhk-food
//
//  Created by leadmap on 14/10/24.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shop.h"
#import "Food.h"
#import "comment.h"
@interface ShopDetail : NSObject
@property Shop *shop;
@property NSMutableArray *foods;
@property NSMutableArray *comments;

@end
