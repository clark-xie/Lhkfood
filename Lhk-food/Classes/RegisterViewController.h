//
//  RegisterViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/31.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property ASIFormDataRequest *asiFormDataRequest;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *affirmpassword;
- (IBAction)userRegister:(id)sender;

- (IBAction)cancel:(id)sender;
@end
