//
//  SearchResultTableViewCell.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/22.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *foodtype;  //需要重type中得到

@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *shopimge;
@property (weak, nonatomic) IBOutlet UIImageView *rateImage;

@end
