//
//  CommentViewController.m
//  Lhk-food
//  评论
//  Created by 谢超 on 14/10/31.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "CommentViewController.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"

@interface CommentViewController ()
//4个评分框
@property RatingBar *barRate;
@property RatingBar *barTaste;
@property RatingBar *barEnvironment;
@property RatingBar *barService;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.name.text = self.shop.name;
//    self.rateImage.image = [Rate imageFromRate:self.shop.rate];
    
//    self.startendtime.text =[NSString string:@"%@-%@": self.shop.open_from,self.shop.opent_to];  这个要修改
    self.price.text = [NSString stringWithFormat:@"%@",self.shop.avg_spend];
    
    self.address.text = self.shop.address;
    self.name.text = self.shop.name;
    
    self.price.text =  [ NSString stringWithFormat:@"%.2f",[self.shop.avg_spend floatValue]];
    //显示图片
    NSString *str = [NSString stringWithFormat:@"http://114.215.158.76/foodmap2/Upload/Images/%@",self.shop.shop_images];
    
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed: @"foodexmaple"]];
    
     self.barRate = [[RatingBar alloc] initWithFrame:CGRectMake(125, 253, 180, 30)];
    [self.view addSubview:self.barRate];
    
    self.barTaste = [[RatingBar alloc] initWithFrame:CGRectMake(125, 299, 180, 30)];
    [self.view addSubview:self.barTaste];
    
    self.barEnvironment = [[RatingBar alloc] initWithFrame:CGRectMake(125, 347, 180, 30)];
    [self.view addSubview:self.barEnvironment];
    
    self.barService = [[RatingBar alloc] initWithFrame:CGRectMake(125, 405, 180, 30)];
    [self.view addSubview:self.barService];
    
    
   // bar.center = self.view.center;
//    self.bar1.c = self.ratiaLabel.frame.origin
    
//    RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(50, 50, 180, 30)];
//    [self.view addSubview:bar];
//    
//    // bar.center = self.view.center;
//    bar.center = CGPointMake(125.f, 299.0f);
//    
//    RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(50, 50, 180, 30)];
//    [self.view addSubview:bar];
//    
//    // bar.center = self.view.center;
//    bar.center = CGPointMake(125.f, 253.f);
//    
//    RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(50, 50, 180, 30)];
//    [self.view addSubview:bar];
//    
//    // bar.center = self.view.center;
//    bar.center = CGPointMake(125.f, 253.f);
//    
//    RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(50, 50, 180, 30)];
//    [self.view addSubview:bar];
//    
//    // bar.center = self.view.center;
//    bar.center = CGPointMake(125.f, 253.f);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





//查询初始化
- (void)postData {
    
    
    //    ASIFormDataRequest
    
//    id
//    user_id
//    overall
//    taste
//    environment
//    service
//
    
   // NSString *str = [NSString stringWithFormat: @"%d", self.shop.shopid];
    int shopid = [self.shop.shopid intValue];
    NSString *query =ShopComments( shopid ) ; //这个要修改
    
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    [SVProgressHUD show];
    
    //    url= [NSURL URLWithString:[NSString stringWithFormat:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=%@&category=%d&lat=%.3f&lng=%.3f&scope=%d",str,123,.0,.0,0] ];
    
    //    url=[NSURL URLWithString:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=abc&category=&lat=&lng=&scope="];
    
    NSLog(@"%@",url);
    
    //    self.asiRequest = [ASIHTTPRequest requestWithURL:url];
    //    self.asiRequest setPostBody:(NSMutableData *)
    //    [self.asiRequest setDelegate:self];
    //    [self.asiRequest startAsynchronous];
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    
    //读取保存在本地的用户id
    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat:@"%d",[[User defaultUserid] integerValue]] forKey:@"user_id" ];
    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat: @"%d", self.barRate.starNumber ] forKey:@"overall" ];
    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat: @"%d", self.barTaste.starNumber ] forKey:@"taste" ];

    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat: @"%d", self.barEnvironment.starNumber ] forKey:@"environment" ];

    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat: @"%d", self.barService.starNumber ] forKey:@"service" ];

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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    MapViewController *viewController = [segue destinationViewController];
    viewController.resultArray = [[NSMutableArray alloc]init];
    [viewController.resultArray addObject:self.shop];
}

- (IBAction)call:(id)sender {
    //要加判定，看是否为正确的电话号码
    [[UIApplication sharedApplication]openURL:[NSURL  URLWithString: [NSString stringWithFormat: @"tel://%@",self.shop.phone] ]];
}

- (IBAction)insertPress:(id)sender {
    [self postData];
}
@end
