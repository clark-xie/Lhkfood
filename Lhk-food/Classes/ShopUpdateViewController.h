//
//  ShopUpdateViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/31.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopUpdateViewController : UIViewController
@property ASIFormDataRequest *asiFormDataRequest;
@property (weak, nonatomic) IBOutlet UITextField *shopName;
@property (weak, nonatomic) IBOutlet UITextField *shopType;
@property (weak, nonatomic) IBOutlet UITextField *shopAddress;
@property (weak, nonatomic) IBOutlet UITextField *shopPhone;
@property (weak, nonatomic) IBOutlet UITextField *shop_start;
@property (weak, nonatomic) IBOutlet UITextField *shop_end;
@property (weak, nonatomic) IBOutlet UITextField *avg_spend;

@property (nonatomic,strong) Shop *shop;

@end
