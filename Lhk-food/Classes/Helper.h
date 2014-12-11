//
//  Helper.h
//  Lhk-food
//
//  Created by 谢超 on 14/11/17.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
+(NSDate *) dateFromString :(NSString *)str;
+(NSString *) stringFromDate :(NSDate *)date;
+(NSNumber *) numberFromString:(NSString *)str;


@end
