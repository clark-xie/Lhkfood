//
//  OffersTableViewController.m
//  Lhk-food
//
//  Created by leadmap on 14/10/30.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "OffersTableViewController.h"
#import "OffersTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Helper.h"

@interface OffersTableViewController ()
@property NSMutableArray *resultArray;  //搜索结果列表

@end

@implementation OffersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self postData];
    
    self.resultArray = [[NSMutableArray alloc]init]; //搜寻结果初始化
    self.tableView.rowHeight = 125;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.resultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" ];
    OffersTableViewCell *cell1 = (OffersTableViewCell *)cell;
    
    if(cell1 !=NULL)
    {
        Offers *offer =[self.resultArray objectAtIndex:[indexPath row]];
        cell1.shopName.text = offer.shop.name;
        cell1.foodOffers.text = offer.food.food_name;
        cell1.address.text = offer.shop.address;
        NSString *str = [NSString stringWithFormat:@"http://111.47.52.51:3000/lhkfood/Upload/Thumbs/%@",offer.shop.shop_images];
        [cell1.foodImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed: @"foodexmaple"]];
        
        cell1.offerDate.text = [NSString stringWithFormat:@"优惠日期  %@-%@",[Helper stringFromDate:offer .valid_from ], [Helper stringFromDate:offer.valid_to] ];
        cell1.rateImage.image = [Rate imageFromRate:offer.shop.rate];
    }
    
    // Configure the cell...
    
    return cell;
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
//    int shopid = [self.shop.shopid intValue];
//    NSString *query =Offers( shopid ) ; //这个要修改
    
    //这个洪要修改
    NSString *query = Offers(0.0,0.0,0,2000.0,1);
    
//        NSString *query = Offers(self.shopSearchSpec.key,self.shopSearchSpec.category,self.shopSearchSpec.lat,self.shopSearchSpec.lng,self.shopSearchSpec.scope);
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
    
//    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
//    
//    [self.asiFormDataRequest setPostValue:@"1" forKey:@"user_id" ]; //这个还要修改，改为从本地保存的数据用户名得到
//    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat: @"%d", self.barRate.starNumber ] forKey:@"overall" ];
//    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat: @"%d", self.barTaste.starNumber ] forKey:@"taste" ];
//    
//    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat: @"%d", self.barEnvironment.starNumber ] forKey:@"environment" ];
//    
//    [self.asiFormDataRequest setPostValue:[NSString stringWithFormat: @"%d", self.barService.starNumber ] forKey:@"service" ];
    self.asiRequest = [ASIHTTPRequest requestWithURL:url];

    [self.asiRequest setDelegate:self];
    [self.asiRequest startAsynchronous];
    
    
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
        NSDictionary *dic = [data objectFromJSONData];
        
        NSLog(@"%@",dic);

        NSArray *resultArrary = [dic objectForKey:@"result"];
        if((NSNull *)resultArrary != [NSNull null] && resultArrary != nil && resultArrary.count !=0)
        {

        for(int i =0 ;i < [resultArrary count] ; i++)
        {
            NSDictionary *tmps = [resultArrary objectAtIndex:i] ;
            NSString *name = [tmps objectForKey:@"shop_name"];
            NSString *address = [tmps objectForKey:@"address"];
            NSString *foodname = [tmps objectForKey:@"food_name"];
            NSString *date_from = [tmps objectForKey:@"valid_from"] ;
            NSString *date_to= [tmps objectForKey:@"valid_to"] ;
            NSString *image = [tmps objectForKey:@"shop_images"];
            
            
//            NSlog(@"%@" ,[dateF ])
            //        NSNumber *rate = [tmps objectForKey:@"rate"];
            
            //            NSNumber *rate =[tmps objectForKey:@"rate"];
            //        [NSNumber numberWithDouble:4.5];
            
            Offers * offer = [[Offers alloc] init];
            Shop * shop = [[Shop alloc]init];
            Food *food = [[Food alloc]init];
            
            shop.name = name;
            shop.address  = address;
            food.food_name = foodname;
            shop.shop_images = image;
            //设置rate
            shop.rate = [Helper numberFromString: [tmps objectForKey:@"rate"]];
            offer.valid_from = [Helper dateFromString:date_from];
            offer.valid_to =[Helper dateFromString:date_to];
            
            offer.shop = shop;
            offer.food = food;
            
            [self.resultArray addObject:offer];//临时使用，应该使用一个类代替
            NSLog(@"%@",shop.address);
            
        }
        NSLog(@"店铺数量是 %d",[resultArrary count]);
        //        _testLabel.text = str;
        [self.tableView  reloadData];
        }
        [SVProgressHUD dismiss];

        
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
