//
//  FirstViewController.h
//  Lhk-food
//
//  Created by leadmap on 14/10/20.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<ASIHTTPRequestDelegate>
{

ASIHTTPRequest *asiRequest;
}
@property (retain, nonatomic) IBOutlet UILabel *testLabel;

- (IBAction)TestShowMessage:(id)sender;
@end

