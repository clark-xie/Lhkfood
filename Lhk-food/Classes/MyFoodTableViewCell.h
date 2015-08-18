//
//  MyFoodTableViewCell.h
//  Lhk-food
//
//  Created by leadmap on 14/12/9.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *foodimageView;

@property (weak, nonatomic) IBOutlet UILabel *foodname;

@property (weak, nonatomic) IBOutlet UILabel *foodprice;
@property (weak, nonatomic) IBOutlet UITextView *fooddesc;
@end
