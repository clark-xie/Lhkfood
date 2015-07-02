//
//  Offers.m
//  Lhk-food
//
//  Created by lwb on 14/10/30.
//  Copyright (c) 2014年 huwei. All rights reserved.
//  美食优惠信息

#import "Offers.h"

@implementation Offers

//"id": "1",
//"food_id": "1",
//"is_valid": "1",
//"valid_from": "2014-10-19",
//"valid_to": "2014-10-22",
//"new_price": "22",
//"comment": null,
//"shop_id": "1",
//"food_name": "鱼香肉食",
//"food_desc": "的飞洒的",

-(id) initWithDictionary:(NSDictionary *)dic
{
    
    self = [super init];
    if(dic == nil)
    {
        NSLog(@"初始化为空");
    }
    
    self.offer_id = [dic objectForKey:@"id"];
    self.food_id  = [dic objectForKey:@"food_id"];
    self.is_valid = [dic objectForKey:@"is_valid"];
    self.valid_from = [dic objectForKey:@"valid_from"];
    self.valid_to = [dic objectForKey:@"valid_to"];
    self.newprice = [Helper numberFromString: [dic objectForKey:@"new_price"]];
    
    self.food = [[Food  alloc ]initWithDictionary:dic];
    

//    self.name = name;
//    self.address  = address;
//    self.shopid = [NSNumber numberWithInteger:shopid];
//    self.latitude = [Helper numberFromString:[dic objectForKey:@"latitude"]];
//    
//    self.longitude = [Helper numberFromString:[dic objectForKey:@"longitude"]];
//    
//    self.rate = [Helper numberFromString:[dic objectForKey:@"rate"]];
//    self.shop_images = [dic objectForKey:@"shop_images"];
//    self.avg_spend = [Helper numberFromString:[dic objectForKey:@"avg_spend"]];
//    self.phone = [dic objectForKey:@"phone"];
//    self.open_from = [Helper dateFromString:[dic objectForKey:@"open_from"]];
//    self.opent_to = [Helper dateFromString:[dic objectForKey:@"open_to"]];
//    self.category =[NSNumber numberWithInt:[[dic objectForKey:@"category"] intValue]];
    return self;
}

@end
