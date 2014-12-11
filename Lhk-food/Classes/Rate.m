//
//  Rate.m
//  Lhk-food
//
//  Created by 谢超 on 14/11/6.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "Rate.h"

@implementation Rate

+ (UIImage *) imageFromRate:(NSNumber *) rate
{
    
    NSString *imagestr ;
    
    if(rate == nil || (NSNull *)rate == [NSNull null])
    {
        imagestr = @"ShopStart0";
    }
    else
    {
        
        float ratefloat = [rate floatValue];
        
        //按照4舍5入
        if(ratefloat <0.5)
        {
            imagestr = @"ShopStar0";
        }
        else if(ratefloat >=0.5 && ratefloat <1.5)
        {
            imagestr = @"ShopStar10";
        }
        else if(ratefloat >=1.5 && ratefloat <2.5)
        {
            imagestr = @"ShopStar20";

        }
        else if(ratefloat >=2.5 && ratefloat <3.5)
        {
            imagestr = @"ShopStar30";

        }
        else if(ratefloat >=3.5 && ratefloat <4.5)
        {
            imagestr = @"ShopStar40";

        }

        else if(ratefloat >=4.5)
        {
            imagestr = @"ShopStar50";
        }
    }
    
    return  [UIImage imageNamed:imagestr];
    //rate值为float类型
    
    
//    float ratefloat = [rate floatValue];
//    
//    //这个可以改进的，不用判断语句，zhij  [@“ShopStar%d”,？*10]
//    else if ([rate isEqualToNumber:[NSNumber numberWithDouble:0]]) {
//        return [UIImage imageNamed:@"ShopStar0"];
//        
//    }
//    else if([rate isEqualToNumber:[NSNumber numberWithDouble:1]])
//    {
//        return [UIImage imageNamed:@"ShopStar10"];
//    }
//    else if([rate isEqualToNumber:[NSNumber numberWithDouble:2]])
//    {
//        return [UIImage imageNamed:@"ShopStar20"];
//    }
//    else if([rate isEqualToNumber:[NSNumber numberWithDouble:3]])
//    {
//        return [UIImage imageNamed:@"ShopStar30"];
//    }
//    else if([rate isEqualToNumber:[NSNumber numberWithDouble:3.5]])
//    {
//        return [UIImage imageNamed:@"ShopStar35"];
//    }
//    else if([rate isEqualToNumber:[NSNumber numberWithDouble:4]])
//    {
//        return [UIImage imageNamed:@"ShopStar40"];
//    }
//    else if([rate isEqualToNumber:[NSNumber numberWithDouble:4.5]])
//    {
//        return [UIImage imageNamed:@"ShopStar45"];
//    }
//    else if([rate isEqualToNumber:[NSNumber numberWithDouble:5]])
//    {
//        return [UIImage imageNamed:@"ShopStar50"];
//    }
//
//    else return [UIImage imageNamed:@"ShopStar0"];
    
}

@end
