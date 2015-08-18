//
//  ShopDetailTableViewController.h
//  Lhk-food
//
//  Created by leadmap on 14/10/23.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailTableViewController : UITableViewController<ASIHTTPRequestDelegate>

@property ASIHTTPRequest *asiRequest;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property ShopSearchSpec *searchSpec;

@property (weak, nonatomic) IBOutlet UILabel *desc;
- (IBAction)call:(id)sender;
- (IBAction)press:(id)sender;
@end
