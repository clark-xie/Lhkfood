//
//  User.m
//  Lhk-food
//
//  Created by 谢超 on 14/11/13.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "User.h"

@implementation User


+(User *) currentUser
{
    NSArray *array  = [NSArray  arrayWithObjects:@"username",  @"password", nil ];
    NSUserDefaults *userDefaults = [NSUserDefaults  standardUserDefaults];
    
    //保存数据
    [userDefaults setObject:array  forKey:@"userInfo" ];
    
    //加载数据
    array = [userDefaults objectForKey:@"userInfo"];
    if(array !=nil && [array count] !=0)
    {
        return nil;
    }
    else
    {
        //没有写完的代码
        NSLog(@"login name :  %s",[ [ array objectAtIndex:0] UTF8String ]);

    }
    
//    //删除数据
//    [userDefaults removeObjectForKey:@"userInfo"];
    
    //退出程序后再次运行程序获取上一次保存的数据
//    [userDefaults synchronize];     //重点
}

//保存登录信息和登录密码
+(void) saveUser:(NSNumber *)userid user: (NSString *) user password:(NSString *)password
{
    NSArray *array  = [NSArray  arrayWithObjects:userid,user,password, nil ];
    NSUserDefaults *userDefaults = [NSUserDefaults  standardUserDefaults];
    
    //保存数据
    [userDefaults setObject:array  forKey:@"userInfo" ];
    
    //加载数据
//    array = [userDefaults objectForKey:@"userInfo"];

    NSLog(@"login name :  %s",[ [ array objectAtIndex:1] UTF8String ]);
    
    //删除数据
//    [userDefaults removeObjectForKey:@"userInfo"];
    
    //退出程序后再次运行程序获取上一次保存的数据
    [userDefaults synchronize];     //重点
//    [self defaultUserid];
}

//得到保存的用户信息
+(NSNumber *)defaultUserid
{
//    NSArray *array  = [NSArray  arrayWithObjects:user,password, nil ];
    NSArray *array;
    NSUserDefaults *userDefaults = [NSUserDefaults  standardUserDefaults];
    
    //保存数据
//    [userDefaults setObject:array  forKey:@"userInfo" ];
    
    //加载数据
     array = [userDefaults objectForKey:@"userInfo"];
    return [array objectAtIndex:0];
}
+(NSString *)defaultUserName
{
    //    NSArray *array  = [NSArray  arrayWithObjects:user,password, nil ];
    NSArray *array;
    NSUserDefaults *userDefaults = [NSUserDefaults  standardUserDefaults];
    
    //保存数据
    //    [userDefaults setObject:array  forKey:@"userInfo" ];
    
    //加载数据
    array = [userDefaults objectForKey:@"userInfo"];
    return [array objectAtIndex:1];
}

//删除登录用户
+(BOOL)deleteDefaultUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults  standardUserDefaults];

    [userDefaults removeObjectForKey:@"userInfo"];

}

@end
