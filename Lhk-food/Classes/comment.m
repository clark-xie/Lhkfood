//
//  Comment.m
//  Lhk-food
//
//  Created by leadmap on 14/10/24.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "Comment.h"
#import "Helper.h"

@implementation Comment

//初始化函数
-(id) initWithDictionary:(NSDictionary *)dic
{
    
    self = [super init];
    if(dic == nil)
    {
        NSLog(@"初始化为空");
    }
    
    self.commentid =[dic  objectForKey:@"id"];
    //overall为整体情况
    self.rate = [Helper numberFromString :[dic objectForKey:@"overall"] ];
    self.taste = [Helper numberFromString:[dic objectForKey:@"taste"]];
    self.enviroment = [Helper numberFromString:[dic objectForKey:@"environment"]];
    self.service = [Helper numberFromString:[dic objectForKey:@"service"]];
    
//    @property NSNumber *commentid; //评论的id
//    @property NSString *user;
//    @property NSNumber *rate;
//    @property NSNumber *taste;
//    @property NSNumber *enviroment;
//    @property NSNumber *service;
    
    return self;
}


@end
