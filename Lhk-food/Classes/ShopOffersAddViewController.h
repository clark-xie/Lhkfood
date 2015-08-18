//
//  ShopOffersAddViewController.h
//  Lhk-food
//
//  Created by leadmap on 14/10/31.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopOffersAddViewController : UITableViewController
@property ASIFormDataRequest *asiFormDataRequest;
@property (weak, nonatomic) IBOutlet UITextField *foodname;
@property (weak, nonatomic) IBOutlet UITextField *foodprice;  //原价
@property (weak, nonatomic) IBOutlet UITextField *foodonSaleprice;  //打折后的价格
- (IBAction)save:(id)sender;

@end
