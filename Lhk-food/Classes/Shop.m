//
//  Shop.m
//  Lhk-food
//
//  Created by leadmap on 14/10/23.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "Shop.h"

@implementation Shop


//-(void) setLatitude:(NSNumber *)latitude
//{
//    if ((NSNull *)latitude ==[NSNull null])
//    {
//        _latitude = [NSNumber numberWithInt:0];
//    }
//    
//}

//初始化函数
-(id) initWithDictionary:(NSDictionary *)dic
{
    
    self = [super init];
    if(dic == nil)
    {
        NSLog(@"初始化为空");
    }
    NSString *name = [dic objectForKey:@"shop_name"];
    NSInteger shopid = [[dic objectForKey:@"id"] integerValue];
    NSString *address = [dic objectForKey:@"address"];
    //        NSNumber *rate = [tmps objectForKey:@"rate"];
    
    //            NSNumber *rate =[tmps objectForKey:@"rate"];
    //        [NSNumber numberWithDouble:4.5];
    
//    Shop * shop = [[Shop alloc]init];
    self.name = name;
    self.address  = address;
    self.shopid = [NSNumber numberWithInteger:shopid];
    self.latitude = [Helper numberFromString:[dic objectForKey:@"latitude"]];
    
    self.longitude = [Helper numberFromString:[dic objectForKey:@"longitude"]];
    
    self.rate = [Helper numberFromString:[dic objectForKey:@"rate"]];
    self.shop_images = [dic objectForKey:@"shop_images"];
    self.avg_spend = [Helper numberFromString:[dic objectForKey:@"avg_spend"]];
    self.phone = [dic objectForKey:@"phone"];
    self.open_from = [Helper dateFromString:[dic objectForKey:@"open_from"]];
    self.opent_to = [Helper dateFromString:[dic objectForKey:@"open_to"]];
    self.category =[NSNumber numberWithInt:[[dic objectForKey:@"category"] intValue]];
    return self;
}

-(NSString *) categoryTypeById:(NSNumber *) categoryid;
{
    switch ([categoryid integerValue]) {
        case 0:
            return @"";
            break;
        case 1:
            return @"中餐";
            break;
        case 2:
            return @"西餐";
            break;
        case 3:
            return @"饭店";
            break;
        case 4:
            return @"茶馆";
            break;
        case 5:
            return @"食品店";
            break;

        case 6:
            return @"蛋糕店";
            break;

        case 7:
            return @"特色饮食";
            break;
            
        default:
            return  @"";
            break;
    }
}

-(NSString *)categoryType
{
    return [self categoryTypeById:_category];
}


@end
