//
//  Shop.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/23.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
@property (nonatomic,strong) NSNumber *shopid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *rate;  //可能是有问题的定义
@property (nonatomic,strong) NSNumber *category;  //食物分类代码
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSNumber *longitude;
@property (nonatomic,strong) NSNumber *latitude;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSDate *open_from;
@property (nonatomic,strong) NSDate *opent_to;
@property (nonatomic,strong) NSNumber *avg_spend;
@property  (nonatomic,strong) NSString *desc; //描述
@property double  scope; //离当前点的距离
@property (nonatomic,strong)  NSString *shop_images; //店铺图片列表

-(id) initWithDictionary:(NSDictionary *)dic;

//根据id得到食物的类型名称
-(NSString *) categoryType;
-(NSString *) categoryTypeById:(NSNumber *) categoryid;

@end
