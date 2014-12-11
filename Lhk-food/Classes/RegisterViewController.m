//
//  RegisterViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/10/31.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//化
- (void)restService{
    
    
    //    ASIFormDataRequest
    
    NSString *query = Users;
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    [SVProgressHUD show];
    
    NSLog(@"%@",url);
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    NSString *name = self.username.text;
    [self.asiFormDataRequest setPostValue:name forKey:@"name" ];
    NSString *email = self.email.text;
    [self.asiFormDataRequest setPostValue:email forKey:@"email" ];
//    NSString *phone = self.username.text;

    //没有电话项目
    [self.asiFormDataRequest setPostValue:@"123244" forKey:@"phone" ];
    NSString *password= self.password.text;

    [self.asiFormDataRequest setPostValue:password forKey:@"password" ];
    [self.asiFormDataRequest setDelegate:self];
    [self.asiFormDataRequest startAsynchronous];
    
}


#pragma mark - Your actions


//- (void)requestFinished:(ASIHTTPRequest *)request;
//- (void)requestFailed:(ASIHTTPRequest *)request;

-(void) requestFailed:(ASIHTTPRequest *)request
{
//    [SVProgressHUD dismiss];
    
    NSLog(@"请求出错");
    [SVProgressHUD dismissWithSuccess:@"注册失败"];

}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (data!=nil) {
        NSObject *resultArrary = [data objectFromJSONData];
        
        
        NSLog(@"%@",resultArrary);
        
        
        [SVProgressHUD dismissWithSuccess:@"注册成功"];
      
        //注册成功后关闭注册窗口
        [self dismissViewControllerAnimated:YES
                                 completion:^(void){
                                     // Code
                                 }];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)userRegister:(id)sender {
    [self restService];

}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 // Code
                             }];
}



@end
