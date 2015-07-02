//
//  MyFoodTableViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/12/9.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFoodTableViewController : UITableViewController<ASIHTTPRequestDelegate>
@property  ASIFormDataRequest *asiFormDataRequest;
//查询参数
@property (nonatomic,strong) ShopSearchSpec *shopSearchSpec;

@end
