//
//  FoodAddViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/31.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodAddViewController : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property ASIFormDataRequest *asiFormDataRequest;
- (IBAction)chooseImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *foodname;
@property (weak, nonatomic) IBOutlet UITextField *foodprice;
@property (weak, nonatomic) IBOutlet UITextView *fooddesc;
- (IBAction)save:(id)sender;

@end
