//
//  SUser.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SFavorite.h"

@implementation SFavorite
@synthesize Address,FavoriteName,Name,uid,x,y;



-(NSMutableDictionary*)getAttributes
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject: uid forKey: @"uid"];
    [dict setObject: FavoriteName forKey: @"FavoriteName"];
    [dict setObject: Address forKey: @"Address"];
    [dict setObject: Name forKey: @"Name"];
    [dict setObject: x forKey: @"x"];
    [dict setObject: y forKey: @"y"];
    return dict;
}
@end
