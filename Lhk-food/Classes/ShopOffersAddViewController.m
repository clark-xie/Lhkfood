//
//  ShopOffersAddViewController.m
//  Lhk-food
//
//  Created by leadmap on 14/10/31.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "ShopOffersAddViewController.h"

@interface ShopOffersAddViewController ()
@property Food *food;
@end

@implementation ShopOffersAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.food = [[Food alloc ]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataPost {
    
    
    //    ASIFormDataRequest
    
    
    //需要id的参数
    NSString *query = FoodsOffersAdd(1);
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    [SVProgressHUD show];
    
    NSLog(@"%@",url);
 
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    

    [self.asiFormDataRequest setPostValue:@"test" forKey:@"valid_from" ];
    [self.asiFormDataRequest setPostValue:@"abc@163" forKey:@"valid_to" ];
    [self.asiFormDataRequest setPostValue:self.food.price forKey:@"new_price" ];

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



//id
//valid_from
//valid_to
//new_price

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {
    //要判断是否在输入框中输入文字，这里没有还没有加
    
    if(self.food ==nil)
    {
        self.food = [[Food alloc]init];
    }
//    self.food.onSalePrice = self.foodonSaleprice.text ;
    [self dataPost];

}
@end
