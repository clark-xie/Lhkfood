//
//  ShopDetailTableViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/10/23.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "ShopDetailTableViewController.h"
#import "SVProgressHUD.h"
#import "Shop.h"
#import "ShopDetail.h"
#import "ShopDetailFoodTableViewCell.h"
#import "ShopDetailTableViewCell.h"
#import "ShopDetailCommentTableViewCell.h"
#import "ShopAddressPhonelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"


@interface ShopDetailTableViewController ()
@property ShopDetail *shopDetail;  //搜索结果

@end

@implementation ShopDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //不显示后退按钮的标题
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    
    NSLog ( @"shopdetail View did Load%@" , self .navigationController .viewControllers );
//    self.navigationController.navigationBar..title = @"";
//    self.navigationItem.lef

    self.shopDetail = [[ShopDetail alloc]init];
    //如果没有给searchSpec 传值，则初始化
    if(self.searchSpec == nil)
    {
        self.searchSpec = [[ShopSearchSpec alloc] init];
    }

    [self initQuery];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillDisappear:(BOOL)animated
{
    //关闭进度条
    [SVProgressHUD dismiss];
}


- (void)initQuery {
    
    
    //NSString *query = TestGetMessage(self.shopSearchSpec.key,self.shopSearchSpec.category,self.shopSearchSpec.lat,self.shopSearchSpec.lng,self.shopSearchSpec.scope);
    
    //根据id好查询美食详情
    NSString *query=ShopDetail(self.searchSpec.shopid);
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
//    self.shopDetail = [[ShopDetail alloc] init];

    [SVProgressHUD show];
    
    //    url= [NSURL URLWithString:[NSString stringWithFormat:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=%@&category=%d&lat=%.3f&lng=%.3f&scope=%d",str,123,.0,.0,0] ];
    
    //    url=[NSURL URLWithString:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=abc&category=&lat=&lng=&scope="];
    
    NSLog(@"%@",url);
    
    self.asiRequest = [ASIHTTPRequest requestWithURL:url];
    [self.asiRequest setDelegate:self];
    [self.asiRequest startAsynchronous];
    
}


-(void) requestFinished:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (data!=nil) {
       // NSArray *resultArrary = [data objectFromJSONData];
        
        //        NSArray* arrayResult =[dic objectForKey:@"results"];
        
        
        NSDictionary *dic = [data objectFromJSONData];
        Shop *shop = [[Shop alloc] initWithDictionary:dic];

        NSLog(@"%@",dic);
//        NSString *name = [tmps objectForKey:@"shop_name"];
//        NSString *address = [tmps objectForKey:@"address"];
//        NSString *desc = [tmps objectForKey:@"shop_desc"];
//        NSNumber *shopid = [NSNumber numberWithInt:[[tmps objectForKey:@"id"] intValue]];
////        NS
//    
//        Shop * shop = [[Shop alloc]init];
//        shop.name = name;
//        shop.address  = address;
//        shop.desc = desc;
//        shop.shopid = shopid;
//        shop.rate = [tmps objectForKey:@"desc"];
//        shop.phone = [tmps objectForKey:@"phone"];
//        shop.latitude = [Helper numberFromString:[tmps objectForKey:@"latitude"]];
//        
//        shop.longitude = [Helper numberFromString:[tmps objectForKey:@"longitude"]];
//        
//        shop.rate = [Helper numberFromString:[tmps objectForKey:@"rate"]];
//        shop.shop_images = [tmps objectForKey:@"shop_images"];
        self.shopDetail.shop = shop;
        
        int i =0;
        //食物
        NSArray *tmp2 = [dic objectForKey:@"foods"];
        
        if((NSNull *)tmp2 != [NSNull null] &&tmp2 !=nil )
        {
            for (i=0; i< tmp2.count ;i++) {
                NSDictionary *tmp21 = [tmp2 objectAtIndex:i];
                
                Food *food = [[Food alloc] init];
                food.name= [tmp21 objectForKey:@"food_name"];
                food.desc = [tmp21 objectForKey:@"food_desc"];
                food.image = [tmp21 objectForKey:@"food_images"];
                food.rate =[tmp21 objectForKey:@"rate"];
                [self.shopDetail.foods addObject:food];
                
                
                
            }
        }
        
        NSArray *tmp3 = [dic objectForKey:@"comments"];

        if((NSNull *)tmp3 != [NSNull null] && tmp3!=nil)
        {
            NSLog(@"tmp3 is %d",[tmp3 count]);
            
            for (i=0; i< [tmp3 count] ;i++) {
                NSDictionary *tmp31 = [tmp3 objectAtIndex:i];
                
                Comment *comment = [[Comment alloc] init];
                comment.user= [tmp31 objectForKey:@"username"];
                comment.rate= [tmp31 objectForKey:@"overall"];
                comment.taste= [tmp31 objectForKey:@"taste"];
                comment.enviroment= [tmp31 objectForKey:@"environment"];
                comment.service= [tmp31 objectForKey:@"service"];


                [self.shopDetail.comments addObject:comment];
                
            }
        }

        
        
        
        
#warning 要填写shopDetail的其他值
        
        
        //        self.shopSearchSpec.key = str;
        //        [resultArrary add]
//        [self.resultArray addObject:shop];//临时使用，应该使用一个类代替
        //        _testLabel.text = str;
        NSLog(@"%@",shop.address);
        [self.tableView  reloadData];
        [SVProgressHUD dismiss];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    NSLog(@"section in number of is %d",section);
    if(section == 0 || section == 1 || section == 2)
    {
        return 1;
    }
    else if(section == 3)
    {
        return  [self.shopDetail.foods count];
    }
    else if(section ==4)
    {
        return  [self.shopDetail.comments count];
    }
    else return  0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell ;
    NSLog(@"section is %d",[indexPath section]);
    
    if ([indexPath section] == 0)
    {
    
        ShopDetailTableViewCell *cell = (ShopDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        cell.name.text = self.shopDetail.shop.name;
        cell.avgMoney.text =  [ NSString stringWithFormat:@"%.2f",[self.shopDetail.shop.avg_spend floatValue]];
        //显示图片的
        NSString *str = [NSString stringWithFormat:@"http://114.215.158.76/foodmap2/Upload/Images/%@",self.shopDetail.shop.shop_images];
        
        [cell.detailimg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed: @"userImage"]];
        cell.rateImage.image = [Rate imageFromRate:self.shopDetail.shop.rate];
        return  cell;
        
    }
    else if([indexPath section] ==1)
    {
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.textLabel.text =self.shopDetail.shop.address;
        
//       ShopAddressPhonelTableViewCell *cell = (ShopAddressPhonelTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
//        cell.address.text =self.shopDetail.shop.address;
       return  cell;

    }
    else if([indexPath section] ==2)
    {
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.textLabel.text =self.shopDetail.shop.phone;
    
//        ShopAddressPhonelTableViewCell *cell = (ShopAddressPhonelTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
//        cell.address.text = self.shopDetail.shop.address;
        return  cell;
        
    }
    else if([indexPath section] ==3){
        ShopDetailFoodTableViewCell *cell=(ShopDetailFoodTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
         Food *food= [self.shopDetail.foods objectAtIndex:[indexPath row]];
        cell.name.text = food.name;
        cell.desc.text = food.desc;
        //显示图片的
        NSString *str = [NSString stringWithFormat:@"http://114.215.158.76/foodmap2/Upload/Images/%@",food.image];
        
        [cell.image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed: @"foodexmaple"]];
        return cell;
    }
    else if ([indexPath section] == 4){
        ShopDetailCommentTableViewCell  *cell = (ShopDetailCommentTableViewCell  *)[tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
        
        Comment *comment = [self.shopDetail.comments objectAtIndex:[indexPath row]];
        cell.user.text = comment.user;
        //comment.rate 不能为字母
//        cell.rateImage.image= [Rate imageFromRate:comment.rate];
        cell.rateAll.text = [NSString stringWithFormat:@"口味%@  环境%@  服务%@",comment.taste,comment.enviroment,comment.service];
        cell.user.text = comment.user;
        cell.rateImage.image = [Rate imageFromRate:comment.rate];
        
//        NSNumber * taste = [[self.shopDetail.comments objectAtIndex:[indexPath row]] rate];
//        NSNumber *enviroment = [[self.shopDetail.comments objectAtIndex:[indexPath row]] rate];
//        cell.rateAll.text =
        return cell;

        
    }
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 1)
    {
        //定位
    }
    else if([indexPath section] ==2 )
    {
        //拨打电话
        [[UIApplication sharedApplication]openURL:[NSURL  URLWithString: [NSString stringWithFormat: @"tel://%@",self.shopDetail.shop.phone] ]];

    }
}

//- (MyCell*)getCellFromIndexPath:(NSIndexPath*)indexPath
//{
//    static NSString *CellIdentifier = @"MyCell";
//    //注意在heightForRowAtIndexPath:indexPath无法使用dequeueReusableCellWithIdentifier:forIndexPath:
//    MyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    //用dequeueReusableCellWithIdentifier:就得判断Cell为nil的情况
//    //如果在Storyboard中Prototype Cells中设置了具体Table View Cell的Identifier也是"MyCell"（也就是重用ID），那这里不会有返回nil的情况
//    if (!cell)
//    {
//        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    //这里把数据设置给Cell
//    cell.titleLabel.text = [_dataSource objectAtIndex:indexPath.row];
//    
//    return cell;
//}




- (UITableViewCell*)getCellFromIndexPath:(NSIndexPath*)indexPath
{
    NSString *CellIdentifier;
    if([indexPath section]==0)
    {
        CellIdentifier = @"cell1";
    }
    else if([indexPath section] ==1)
    {
        CellIdentifier = @"cell2";

    }
    else if([indexPath section] ==2)
    {
        CellIdentifier = @"cell3";
        
    }
    else if([indexPath section] ==3)
    {
        CellIdentifier = @"cell4";

    }
    else
    {
        CellIdentifier = @"cell5";

    }
    return [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
}

- (CGFloat )cellheightForIndexPath:(NSIndexPath*)indexPath
{
//    NSString *CellIdentifier;
    if([indexPath section]==0)
    {
        return 116.0;
    }
    else if([indexPath section] ==1)
    {
        return 45.0;
    }
    else if([indexPath section] ==2)
    {
        return 45;
    }
    else
    {
        return 63;
    }
    
}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //获取Cell
//    UITableViewCell *cell = [self getCellFromIndexPath:indexPath];
//    
//    //更新UIView的layout过程和Autolayout
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    [cell.contentView setNeedsLayout];
//    [cell.contentView layoutIfNeeded];
//    
//    //通过systemLayoutSizeFittingSize返回最低高度
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    NSLog(@"cell height is %f",height);
//    return height;
//}

//没有内容的控件，默认不计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return [self cellheightForIndexPath:indexPath];

//    UITableViewCell *cell = [self getCellFromIndexPath:indexPath];
////    cell.t.text = [self.tableData objectAtIndex:indexPath.row];
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    NSLog(@"h=%f", size.height + 1);
//    return 1  + size.height;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if(section == 0)
//    {
//        return 10;
//    }
//    else
//        return 20;
//    
//}

//-(UIView *)tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGRect frameRect = CGRectMake(0,0,100,20);
//    UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
//    label.text = @"特色美食";
//    return label;
//    
//    
//}

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if(section ==3)
    {
        return  @"特色美食";
    }
    else if(section == 4)
    {
        return @"用户评价";
    }
    else return  nil;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //    UIButton *button  = sender;
    
//    NSLog(@"tag id is %d",[sender tag]);
////    if(sender is)
//    //要判断当前的按钮是
//    CommentViewController * controller =(CommentViewController * )[segue destinationViewController];
//    controller.shop = self.shopDetail.shop;
//
    //101是评论的tag
    
    NSLog ( @"shopDetailTableViewCOntroller.m %@" , self .navigationController .viewControllers );
    

    if([sender tag] !=101 )
    {
        MapViewController *viewController = [segue destinationViewController];
        viewController.resultArray = [[NSMutableArray alloc]init];
        [viewController.resultArray addObject:self.shopDetail.shop];
        //需要给下一个界面传递userid
        
    }
    //tag为101，就是按的评论按钮
    else if([sender tag] == 101)
    {
        if(User.defaultUserid == nil || [User.defaultUserid integerValue] <0)
        {
            
        }
        else
        {
            CommentViewController *commentViewController = [segue destinationViewController];
            //给shop赋值
            commentViewController.shop = self.shopDetail.shop;
        }
    }
    

}


- (IBAction)call:(id)sender {
    
    //要加判定，看是否为正确的电话号码
    [[UIApplication sharedApplication]openURL:[NSURL  URLWithString: [NSString stringWithFormat: @"tel://%@",self.shopDetail.shop.phone] ]];
}

- (IBAction)press:(id)sender {
    
    if(User.defaultUserid == nil || [User.defaultUserid integerValue] <0)
    {
        NSLog(@"还没有登录过");
        [self performSegueWithIdentifier:@"loginSegue" sender:sender];
        return;
    }
    else
    {
        //如果已经登录，则直接去用户评论界面
//        [sender tag] = 102;
        [self performSegueWithIdentifier:@"commentSegue" sender:sender];
        

    }
    
}



#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}


@end
