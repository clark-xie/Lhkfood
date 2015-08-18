//
//  User.h
//  Lhk-food
//
//  Created by leadmap on 14/11/13.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSNumber *userid; //用户的id号
@property NSString *userName;
@property NSString *password; //使用md5编码的password
@property NSString *loginTime; //登录时间

//得到当前的账号
+(User *) currentUser;//

//保存登录信息和登录密码，和用户id号
+(void) saveUser:(NSNumber *)userid user: (NSString *) user password:(NSString *)password;

+(NSNumber *)defaultUserid;
+(NSString *)defaultUserName;
+(BOOL) deleteDefaultUser;
@end
