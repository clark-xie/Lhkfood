//
//  ShopUpdateViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/10/31.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "ShopUpdateViewController.h"
#import "Helper.h"

@interface ShopUpdateViewController ()

@end

@implementation ShopUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shopName.text = self.shop.name;
    self.shopAddress.text = self.shop.address;
//    self.shopType.text = self.shopType
    self.shopPhone.text = self.shop.phone;
    self.shop_start.text = [Helper stringFromDate: self.shop.open_from];
    self.shop_end.text = [Helper stringFromDate: self.shop.opent_to];
    self.avg_spend.text = [NSString stringWithFormat:@"%.2f",[self.shop.avg_spend  floatValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dataPost {
    
    
    //    ASIFormDataRequest
    
    
    //需要id的参数
    NSString *query = ShopsUpdate(1);
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    [SVProgressHUD show];
    
    NSLog(@"%@",url);
    
    //    user_id
    //    name
    //    desc
    //    address
    //    phone
    //    open_from
    //    open_to
    //    avg_spend
    //    images
    
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.asiFormDataRequest setPostValue:@"abc" forKey:@"user_id" ];
    [self.asiFormDataRequest setPostValue:@"abc" forKey:@"name" ];
    [self.asiFormDataRequest setPostValue:@"abc@163" forKey:@"address" ];
    [self.asiFormDataRequest setPostValue:@"abc" forKey:@"open_from" ];
    [self.asiFormDataRequest setPostValue:@"abc" forKey:@"open_to" ];
    [self.asiFormDataRequest setPostValue:@"abc" forKey:@"avg_spend" ];
    [self.asiFormDataRequest setPostValue:@"abc" forKey:@"images" ];
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
        
        
        [SVProgressHUD dismiss];
        
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

@end
