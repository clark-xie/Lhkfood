//
//  OffersTableViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/30.
//  Copyright (c) 2014年 huwei. All rights reserved.
//  优惠信息

#import <UIKit/UIKit.h>

@interface OffersTableViewController : UITableViewController<ASIHTTPRequestDelegate,ASIProgressDelegate>
//@property OffersTableViewCell *cells;
@property ASIFormDataRequest *asiRequest;

@end
