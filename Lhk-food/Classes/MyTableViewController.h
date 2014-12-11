//
//  MyTableViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/11/26.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewController : UITableViewController

- (IBAction)loginInAndLoginOut:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property (weak, nonatomic) IBOutlet UIButton *loginLabel;
@end
