//
//  SUser.h
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFavorite : NSObject

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * Name;
@property (nonatomic, copy) NSString * Address;
@property (nonatomic, copy) NSString * FavoriteName;
@property (nonatomic, copy) NSString * x;
@property (nonatomic, copy) NSString * y;
-(NSMutableDictionary*)getAttributes;
@end
