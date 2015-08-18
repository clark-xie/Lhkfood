//
//  Helper.m
//  Lhk-food
//
//  Created by leadmap on 14/11/17.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "Helper.h"

@implementation Helper

//把string转为date
+(NSDate *) dateFromString :(NSString *)str
{
    if((NSNull *) str != [NSNull null] )
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        NSDate *date = [dateFormatter dateFromString:str];
        NSLog(@"date is %@",date);
        return  date;
    }
    return  nil;

}
//把date转date
+(NSString *) stringFromDate :(NSDate *)date
{
    if((NSNull *) date != [NSNull null] && date != nil)
    {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *str = [dateFormatter stringFromDate:date];
    NSLog(@"%@",str);
    return str;
    }
    return  nil;
}


//把字符串转为number类型
+(NSNumber *) numberFromString:(NSString *)str
{
    //    NSString * str = [tmps objectForKey:@"rate" ];
    
    //如果字符串为空，则返回0
    if(str ==nil || (NSNull *)str == [NSNull null])
    {
        return [NSNumber numberWithFloat:0.0];
    }
    id result;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    result=[f numberFromString:str];
    if(!(result))
    {
        result=str;
    }
    NSLog(@"%.2f",[result floatValue]);
    return [NSNumber numberWithFloat:[result floatValue]];
}
@end
