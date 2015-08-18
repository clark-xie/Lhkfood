//
//  Food.m
//  Lhk-food
//
//  Created by leadmap on 14/10/24.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "Food.h"

@implementation Food


//"id": "1",
//"shop_id": "1",
//"food_name": "鱼香肉食",
//"food_desc": "的飞洒的",
//"food_price": "31",
//"food_images": null

-(id) initWithDictionary:(NSDictionary *) dic
{
    self = [super init];

    if(dic == nil)
    {
        NSLog(@"初始化为空");
    }

    self.food_name =[dic objectForKey:@"food_name"];
//    self.food_name = [dic obj]
    //食物描述信息
    self.desc = [dic objectForKey:@"food_desc"];
    self.price = [dic objectForKey:@"food_price"];
    self.image = [dic objectForKey:@"food_images"];
    return self;
}
@end
