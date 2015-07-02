//
//  MyFavoritesTableViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/11/3.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "MyFavoritesTableViewController.h"
#import "UIImageView+WebCache.h"

#define Favorites_Number_OF_Section  1;
#define Favorites_Row_Height 100;
//#define Favorites_

@interface MyFavoritesTableViewController ()
@property NSMutableArray *resultArrary;
@end

@implementation MyFavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = Favorites_Row_Height;
    [self restService];
    self.resultArrary = [[NSMutableArray alloc] init];
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
    return Favorites_Number_OF_Section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.resultArrary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyFavoritesTableViewCell *cell = (MyFavoritesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"favoritesCell" forIndexPath:indexPath];
    if(cell != NULL)
    {
        Shop *shop = [self.resultArrary objectAtIndex:[indexPath row]];
        cell.shopname.text =shop.name;
        cell.address.text = shop.address;
//        cell.shopImage.text = 
        NSString *str = [NSString stringWithFormat:@"http://111.47.52.51:3000/lhkfood/Upload/Thumbs/%@",shop.shop_images];
        [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed: @"foodexmaple"]];
        cell.rateImage.image = [Rate imageFromRate:shop.rate];
    }
    
    // Configure the cell...
    
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.resultArrary removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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


//查询初始化
- (void)restService {
    
    //查询收藏
    NSString *query = Collections(9);
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSLog(@"%@",url);
    
    //    self.asiRequest = [ASIHTTPRequest requestWithURL:url];
    //    self.asiRequest setPostBody:(NSMutableData *)
    //    [self.asiRequest setDelegate:self];
    //    [self.asiRequest startAsynchronous];
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
//    NSString *strname = self.name.text;
//    NSString *strcontent = self.suggestion.text;
//    [self.asiFormDataRequest setPostValue:strname forKey:@"name" ];
//    [self.asiFormDataRequest setPostValue:strcontent forKey:@"content" ];
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
        NSArray *resultArrary = [data objectFromJSONData];
        
        
        for(int i =0 ; i < [resultArrary count];i++)
        {
            NSDictionary * dic = [resultArrary objectAtIndex:i];
            //shop初始化
            Shop *shop = [[Shop alloc]initWithDictionary:dic];
//            Shop *shop = [[Shop alloc] init];
//            shop.shopid = [dic  objectForKey:@"shop_id"];
//            shop.name = [dic objectForKey:@"shop_name"];
//            shop.address =[dic objectForKey:@"address"];
//            shop.shop_images = [dic objectForKey:@""];
            [self.resultArrary addObject:shop];
//            NSLog(@"%@",resultArrary);
        }
        
//        [SVProgressHUD showSuccessWithStatus:@"得到数据成功"];
        //        [self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES
                                 completion:^(void){
                                     // Code
                                 }];
//        [self.tableView reload]
        [self.tableView reloadData];
//        [SVProgressHUD dismiss];
    }
    
}

@end
