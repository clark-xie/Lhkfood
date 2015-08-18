//
//  ShopDetailFoodTableViewCell.h
//  Lhk-food
//
//  Created by leadmap on 14/10/24.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailFoodTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *rateImage;
@end
