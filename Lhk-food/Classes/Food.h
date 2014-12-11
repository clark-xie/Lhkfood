//
//  Food.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/24.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSNumber *rate; //食物的评分
@property (nonatomic,strong) NSNumber *price;   //价格
@property (nonatomic,strong) NSNumber *onSalePrice; //原价
@end
