//
//  MainViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/22.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITableViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

 @property   ASIHTTPRequest *asiRequest;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)press:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapBarButton;

@end

