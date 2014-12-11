//
//  SuggestionsViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/10/30.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "SuggestionsViewController.h"
//#import "IQKeyboardManager.h"

@interface SuggestionsViewController ()

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//查询初始化
- (void)restService {
    
    
//    ASIFormDataRequest 
    
    NSString *query = Suggestions;
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
//    [SVProgressHUD show];
    
    //    url= [NSURL URLWithString:[NSString stringWithFormat:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=%@&category=%d&lat=%.3f&lng=%.3f&scope=%d",str,123,.0,.0,0] ];
    
    //    url=[NSURL URLWithString:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=abc&category=&lat=&lng=&scope="];
    
    NSLog(@"%@",url);
    
//    self.asiRequest = [ASIHTTPRequest requestWithURL:url];
//    self.asiRequest setPostBody:(NSMutableData *)
//    [self.asiRequest setDelegate:self];
//    [self.asiRequest startAsynchronous];
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    NSString *strname = self.name.text;
    NSString *strcontent = self.suggestion.text;
    [self.asiFormDataRequest setPostValue:strname forKey:@"name" ];
    [self.asiFormDataRequest setPostValue:strcontent forKey:@"content" ];
    [self.asiFormDataRequest setDelegate:self];
    [self.asiFormDataRequest startAsynchronous];

    
}


#pragma mark - Your actions


//- (void)requestFinished:(ASIHTTPRequest *)request;
//- (void)requestFailed:(ASIHTTPRequest *)request;

-(void) requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
    NSLog(@"请求出错");
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (data!=nil) {
        NSObject *resultArrary = [data objectFromJSONData];

        
        NSLog(@"%@",resultArrary);
        
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//        [self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES
                                 completion:^(void){
                                     // Code
                                 }];
//        [SVProgressHUD dismiss];
        
    }
    
}


//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 // Code
                             }];
}

- (IBAction)insert:(id)sender {
    [self restService];
    
}
@end
