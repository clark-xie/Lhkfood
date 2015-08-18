//
//  Comment.h
//  Lhk-food
//
//  Created by leadmap on 14/10/24.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property NSNumber *commentid; //评论的id
@property NSString *user;
@property NSNumber *rate;
@property NSNumber *taste;
@property NSNumber *enviroment;
@property NSNumber *service;
@property Shop  *shop;//店铺类型

-(id) initWithDictionary:(NSDictionary *)dic;
@end
