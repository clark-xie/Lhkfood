//
//  MyFavoritesTableViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/11/3.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFavoritesTableViewController : UITableViewController<ASIHTTPRequestDelegate,ASIProgressDelegate>
@property  ASIFormDataRequest *asiFormDataRequest;
@end
