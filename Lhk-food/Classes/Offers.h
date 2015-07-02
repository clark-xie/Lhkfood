//
//  Offers.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/30.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offers : NSObject

@property (nonatomic,strong) NSNumber *offer_id;
@property (nonatomic,strong) NSNumber *food_id;
@property (nonatomic,strong) NSNumber *is_valid;
@property (nonatomic,strong) NSDate *valid_from;
@property (nonatomic,strong) NSDate *valid_to;
@property (nonatomic,strong) NSNumber *newprice;
@property (nonatomic,strong) NSString *comment;


@property (nonatomic,strong) Food *food;  //食物信息
@property (nonatomic,strong) Shop *shop;   //店铺信息


-(id) initWithDictionary:(NSDictionary *)dic;

//@property NSNumber *shopid;
//@property NSString *name;
//@property NSNumber *rate;  //可能是有问题的定义
//@property NSNumber *category;
//@property NSString *address;
//@property NSNumber *longitude;
//@property NSNumber *latitude;
//@property NSString *phone;
//@property NSDate *open_from;
//@property NSDate *opent_to;
//@property NSNumber *avg_spend;
//@property NSString *desc; //描述
//
//
//
//"id": "1",
//"food_id": "1",
//"is_valid": "1",
//"valid_from": "2014-10-19",
//"valid_to": "2014-10-22",
//"new_price": "22",
//"comment": null,
//
//
//"food_name": "鱼香肉食",
//"food_desc": "的飞洒的",
//"food_price": "31",
//"food_images": null,
//
//
//"shop_id": "1",
//
//"user_id": "1",
//"shop_name": "七里香土菜馆",
//"category_id": "0",
//"shop_desc": "放大放大爽肤水",
//"address": "休息休息",
//"longitude": "112.34",
//"latittude": "45.89",
//"phone": "18674047043",
//"rate": "4.1",
//"open_from": "0900",
//"open_to": "2300",
//"avg_spend": "52",
//"shop_images": "1.png,2.png"



@end
