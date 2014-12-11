//
//  LoginViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/11/13.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<ASIHTTPRequestDelegate,ASIProgressDelegate>
@property  ASIFormDataRequest *asiFormDataRequest;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)cancel:(id)sender;

@end
