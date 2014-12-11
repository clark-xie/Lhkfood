//
//  MyCommentTableViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/11/3.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "MyCommentTableViewController.h"
#import "UIImageView+WebCache.h"

#define Comment_Row_Height 66;

@interface MyCommentTableViewController ()

@property NSMutableArray * resultArrary;
@property bool deleteing;
@end

@implementation MyCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = Comment_Row_Height;
    self.deleteing = false;  //进来时不是编辑状态
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.resultArrary = [[NSMutableArray alloc]init];
    [self restService];
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
    return [self.resultArrary count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentTableViewCell *cell = (MyCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    if(cell != nil)
    {
        Comment *comment = [self.resultArrary objectAtIndex:[indexPath row]];
        
        cell.shopName.text = comment.shop.name;
        
        NSString *str = [NSString stringWithFormat:@"http://114.215.158.76/foodmap2/Upload/Images/%@",comment.shop.shop_images];
        [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed: @"foodexmaple"]];
        
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
    
        Comment *comment =[self.resultArrary objectAtIndex:[indexPath row]];
        
        [self.resultArrary removeObjectAtIndex:[indexPath row]];
//        shop.resultArrary
        [self deleteComment:comment.commentid];
        self.deleteing = true;
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
    NSString *query = UserComments(9);
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSLog(@"%@",url);
    
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];

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
    NSLog(@"%@",data);
    if (data!=nil)
    {
    if(!self.deleteing)
    {
        NSArray *resultArrary = [data objectFromJSONData];
        
        for(int i =0 ; i < [resultArrary count];i++)
        {
            NSDictionary * dic = [resultArrary objectAtIndex:i];
            Comment *commnet = [[Comment alloc]init];
            commnet.commentid = [dic  objectForKey:@"id"];
            
            Shop *shop = [[Shop alloc]initWithDictionary:dic];
            
//            Shop *shop = [[Shop alloc] init];
//            shop.shopid = [dic  objectForKey:@"shop_id"];
//            shop.name = [dic objectForKey:@"shop_name"];
//            shop.address =[dic objectForKey:@"address"];
//            shop.shop_images = [dic objectForKey:@"shop_images"];
            commnet.shop = shop;
            [self.resultArrary addObject:commnet];
            NSLog(@"%@",resultArrary);
        }
        
        //        [SVProgressHUD showSuccessWithStatus:@"得到数据成功"];
        //        [self dismissModalViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES
//                                 completion:^(void){
//                                     // Code
//                                 }];
        //        [self.tableView reload]
        [self.tableView reloadData];
        //        [SVProgressHUD dismiss];
    }
    }
    
}


//删除
- (void)deleteComment:(NSNumber *)commentid {
    
   
    //查询收藏
    NSString *query = CommentsDelete( [commentid integerValue]);  //row 测试阶段为1
    
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSLog(@"%@",url);
    
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [self.asiFormDataRequest setRequestMethod:@"DELETE"];
    [self.asiFormDataRequest setDelegate:self];
    [self.asiFormDataRequest startAsynchronous];
    
}


@end
