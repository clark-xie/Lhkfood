//
//  FirstViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/10/20.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()



@end

@implementation FirstViewController

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

- (IBAction)TestShowMessage:(id)sender {
    

//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really reset?" message:@"Do you really want to reset this game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        // optional - add more buttons:
//        [alert addButtonWithTitle:@"Yes"];
//        [alert show];
    
    
//    NSString *query = [NSString stringWithFormat:ShopList(@"",0,0.3,0.3,2000,1)];
//    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:strUrl];
////     *url = [NSURL URLWithString:TestGetMessage(@"0",0,0.3,0.3,0)];
////    NSLog(TestGetMessage(@"0",0,0.3,0.3,0));
////    NSLog(url);
//    
////    NSString *str = @"七";
//    
//    
//
//    
//    
////    url= [NSURL URLWithString:[NSString stringWithFormat:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=%@&category=%d&lat=%.3f&lng=%.3f&scope=%d",str,123,.0,.0,0] ];
//    
////    url=[NSURL URLWithString:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=abc&category=&lat=&lng=&scope="];
//    
//    NSLog(@"%@",url);
//    
//    asiRequest = [ASIHTTPRequest requestWithURL:url];
//    [asiRequest setDelegate:self];
//    [asiRequest setDidFinishSelector:@selector(GetResult:)];
//    [asiRequest setDidFailSelector:@selector(GetErr:)];
//    [asiRequest startAsynchronous];
//
}


#pragma mark - Your actions


-(void) GetErr:(ASIHTTPRequest *)request
{
    NSLog(@"请求出错");
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
//     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (data!=nil) {
       NSArray *resultArrary = [data objectFromJSONData];
        
//        NSArray* arrayResult =[dic objectForKey:@"results"];

    
        NSDictionary *tmps = [resultArrary objectAtIndex:0] ;
        NSString *str = [tmps objectForKey:@"name"];
        
        _testLabel.text = str;
        NSLog(@"%@",str);

    }
    
}





//- (void)dealloc {
//    [_testLabel release];
//    [super dealloc];
//}
@end
