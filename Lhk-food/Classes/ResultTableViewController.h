//
//  ResultTableViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/22.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchResultTableViewCell.h"
#import "ShopSearchSpec.h"
#import "PullTableView.h"

//结果列表的样式种类
typedef NS_ENUM(NSUInteger, ResultTableStyle) {
    ResultTableStyleNo = 0,
    ResultTableStyleSearch = 1,//所有基本查询结构
    ResultTableStyleComment = 2,  //显示推荐列表，有待实现
    ResultTableStyleOnSale=3,     //显示优惠列表
    ResultTableStyleMyFavorites,
    ResultTableStyleMyComment,
    ResultTableStyleMyShop,
    //ResultTableStyle,
};



@interface ResultTableViewController : UITableViewController<ASIProgressDelegate,ASIHTTPRequestDelegate,UITableViewDataSource, PullTableViewDelegate>


@property (nonatomic,strong) ShopSearchSpec *shopSearchSpec;
@property (nonatomic,strong)ASIHTTPRequest *asiRequest;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarItem;
@property ResultTableStyle showtype; //tableview的类型，决定显示的项目内容
//- (IBAction)onclick:(UIButton *)sender;
//@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;


//- (IBAction)select:(id)sender;
@property (nonatomic, strong) SearchResultTableViewCell *searchResultTableViewCell;
@end
