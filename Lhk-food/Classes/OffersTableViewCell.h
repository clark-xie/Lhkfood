//
//  OffersTableViewCell.h
//  Lhk-food
//
//  Created by leadmap on 14/10/30.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *foodImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *offerDate;
@property (weak, nonatomic) IBOutlet UILabel *foodType;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *foodOffers;
@property (weak, nonatomic) IBOutlet UIImageView *rateImage;

@end
