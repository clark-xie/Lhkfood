//
//  AddShopViewController.h
//  Lhk-food
//
//  Created by leadmap on 14/10/31.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMImage.h"

typedef enum : NSUInteger {
    AddShopTypeAdd,
    AddShopTypeUpdate, //更新
    
} AddShopType;

@interface AddShopViewController : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LMImageDelegate>
@property ASIFormDataRequest *asiFormDataRequest;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectImage;
@property (weak, nonatomic) IBOutlet UITextField *shopname;
@property (weak, nonatomic) IBOutlet UITextField *shoptype;
@property (weak, nonatomic) IBOutlet UITextField *shopaddress;
@property (weak, nonatomic) IBOutlet UITextField *shopphone;
@property (weak, nonatomic) IBOutlet UITextField *starttime;
@property (weak, nonatomic) IBOutlet UITextField *endtime;
@property (weak, nonatomic) IBOutlet UITextField *avg_price;   //人均消费
@property (weak, nonatomic) IBOutlet UILabel *foodtype;

//店铺的值
@property (nonatomic,strong) Shop *shop;
//当前界面的类型
@property AddShopType type;


- (IBAction)insertPress:(id)sender;
- (IBAction)chooseImage:(id)sender;
@end
