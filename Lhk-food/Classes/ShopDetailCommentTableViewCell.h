//
//  ShopDetailCommentTableViewCell.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/24.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UIImageView *rateImage;

@property (weak, nonatomic) IBOutlet UILabel *rateAll;
@end
