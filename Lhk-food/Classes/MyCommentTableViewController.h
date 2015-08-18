//
//  MyCommentTableViewController.h
//  Lhk-food
//
//  Created by leadmap on 14/11/3.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentTableViewController : UITableViewController<ASIHTTPRequestDelegate,ASIProgressDelegate>
@property  ASIFormDataRequest *asiFormDataRequest;

@end
