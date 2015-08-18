//
//  ShopDetail.m
//  Lhk-food
//
//  Created by leadmap on 14/10/24.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "ShopDetail.h"

@implementation ShopDetail

-(id) init
{
    if (self = [super init]){
        self.shop = [[Shop alloc]init];
        self.foods = [[NSMutableArray alloc] init];
        self.comments = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
