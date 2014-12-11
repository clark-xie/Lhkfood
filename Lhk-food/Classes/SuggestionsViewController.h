//
//  SuggestionsViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/10/30.
//  Copyright (c) 2014年 huwei. All rights reserved.

//  提交建议模块


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

//@interface SuggestionsViewController : BaseViewController<ASIProgressDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,UITextViewDelegate>

@interface SuggestionsViewController : UIViewController<ASIProgressDelegate,ASIHTTPRequestDelegate>

@property ASIHTTPRequest *asiRequest;
@property ASIFormDataRequest *asiFormDataRequest;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *suggestion;
- (IBAction)cancel:(id)sender;

- (IBAction)insert:(id)sender;
@end
