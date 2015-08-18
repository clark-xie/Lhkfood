//
//  CommentViewController.h
//  Lhk-food
//
//  Created by leadmap on 14/10/31.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RatingBar.h"

@interface CommentViewController : UIViewController
@property ASIFormDataRequest *asiFormDataRequest;
- (IBAction)insertPress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *startendtime;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *ratiaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rateImage;
@property (nonatomic,strong) Shop *shop;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *location;
@property (weak, nonatomic) IBOutlet UIButton *call;
@end
