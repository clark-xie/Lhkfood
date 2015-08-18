//
//  LoginViewController.m
//  Lhk-food
//
//  Created by leadmap on 14/11/13.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property User *user;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[User alloc]init];
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
    
    //查询收藏
    NSString *query = CheckLogin;  //检查用户状态
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];

    [self.asiFormDataRequest setPostValue:self.user.userName forKey:@"username" ];
    [self.asiFormDataRequest setPostValue:self.user.password forKey:@"password" ];

//    [self.asiFormDataRequest setPostValue:@"liwenbo" forKey:@"username" ];
//    [self.asiFormDataRequest setPostValue:@"e10adc3949ba59abbe56e057f20f883e" forKey:@"password" ];
    
    
    NSLog(@"%@",url);
    
    
    [self.asiFormDataRequest setDelegate:self];
    [self.asiFormDataRequest startAsynchronous];
    
    
}


#pragma mark - Your actions


//- (void)requestFinished:(ASIHTTPRequest *)request;
//- (void)requestFailed:(ASIHTTPRequest *)request;

-(void) requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
    NSLog(@"登录出错，检查网络等其他设备");
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError *error =nil;
    NSLog(@"%@",data);
    
//登录接口有问题，需要修改
    if(data!=nil)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error] ;
        //[data objectFromJSONData];
        NSLog(@"%@",dic);
        
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if(code == 0) //0为登录成功
        {
            //得到用户id
            NSInteger userid = [[dic objectForKey:@"detail"] integerValue];
                [User saveUser:[NSNumber numberWithInt:userid] user: self.user.userName password:self.user.password];
            //返回登录前的界面
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//            [self dismissViewControllerAnimated:YES  completion:nil];
            
                    [self dismissViewControllerAnimated:YES
                                             completion:^(void){
                                                 // Code
                                             }];

        }
        else
        {
            NSLog(@"登录失败");
        }
    }


    
    
//    if (data!=nil)
//    {
//        if(!self.deleteing)
//        {
//            NSArray *resultArrary = [data objectFromJSONData];
//            
//            for(int i =0 ; i < [resultArrary count];i++)
//            {
//                NSDictionary * dic = [resultArrary objectAtIndex:i];
//                Comment *commnet = [[Comment alloc]init];
//                commnet.commentid = [dic  objectForKey:@"id"];
//                Shop *shop = [[Shop alloc] init];
//                shop.shopid = [dic  objectForKey:@"shop_id"];
//                shop.name = [dic objectForKey:@"shop_name"];
//                shop.address =[dic objectForKey:@"address"];
//                
//                commnet.shop = shop;
//                [self.resultArrary addObject:commnet];
//                NSLog(@"%@",resultArrary);
//            }
//            
//            //        [SVProgressHUD showSuccessWithStatus:@"得到数据成功"];
//            //        [self dismissModalViewControllerAnimated:YES];
//            [self dismissViewControllerAnimated:YES
//                                     completion:^(void){
//                                         // Code
//                                     }];
//            //        [self.tableView reload]
//            [self.tableView reloadData];
//            //        [SVProgressHUD dismiss];
//        }
//    }
    
}


- (IBAction)login:(id)sender {
    if(self.user ==nil)
    {
        self.user = [[User alloc] init];
    }
    self.user.userName = self.username.text;
    self.user.password = [MyMD5 md5:self.password.text];
    [self restService];
}

//取消登录
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 // Code
                             }];

}
@end
