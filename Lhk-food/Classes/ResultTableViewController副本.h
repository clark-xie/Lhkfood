//
//  ResultTableViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/22.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchResultTableViewCell.h"
#import "ShopSearchSpec.h"
@interface ResultTableViewController : UITableViewController<ASIProgressDelegate,ASIHTTPRequestDelegate>


@property ShopSearchSpec *shopSearchSpec;
@property ASIHTTPRequest *asiRequest;
- (IBAction)onclick:(UIButton *)sender;


- (IBAction)select:(id)sender;
@property (nonatomic, strong) SearchResultTableViewCell *searchResultTableViewCell;
@end
