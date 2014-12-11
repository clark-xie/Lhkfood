//
//  ResultTableViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/10/22.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "ResultTableViewController.h"
#import "SearchResultTableViewCell.h"
#import "Shop.h"
#import "SVProgressHUD.h"
@interface ResultTableViewController ()
@property NSMutableArray *resultArray;  //搜索结果列表

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultArray =[[NSMutableArray alloc] init];
    
    if(self.shopSearchSpec ==nil)   //如果传递给过来的参数没有对shop赋值，则自己赋值
    {
        self.shopSearchSpec = [[ShopSearchSpec alloc] init];
    }
    
    
    self.tableView.rowHeight = 138;   //这个需要修改，以后再改吧
    [self initQuery];
    
//    self.navigationController 
    
    
//    _shopSearchSpec = [[ShopSearchSpec alloc] init];
    
//    [self.tableView registerClass:[TDishViewController class] forCellReuseIdentifier:@"Cell"];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initQuery {
    
    
    NSString *query = ShopList(self.shopSearchSpec.key,self.shopSearchSpec.category,self.shopSearchSpec.lat,self.shopSearchSpec.lng,self.shopSearchSpec.scope);
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];

    [SVProgressHUD show];
    
    //    url= [NSURL URLWithString:[NSString stringWithFormat:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=%@&category=%d&lat=%.3f&lng=%.3f&scope=%d",str,123,.0,.0,0] ];
    
    //    url=[NSURL URLWithString:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=abc&category=&lat=&lng=&scope="];
    
    NSLog(@"%@",url);
    
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
        NSArray *resultArrary = [data objectFromJSONData];
        
        //        NSArray* arrayResult =[dic objectForKey:@"results"];
        
        
        NSDictionary *tmps = [resultArrary objectAtIndex:0] ;
        NSString *name = [tmps objectForKey:@"name"];
        NSString *address = [tmps objectForKey:@"address"];
        

        
        Shop * shop = [[Shop alloc]init];
        shop.name = name;
        shop.address  = address;
        
#warning 要填写shop的其他值
        
        
//        self.shopSearchSpec.key = str;
//        [resultArrary add]
        [self.resultArray addObject:shop];//临时使用，应该使用一个类代替
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
//    return [self.resultArray count];
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return  [self.resultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([indexPath section] == 0)
    {
        static NSString *CustomCellIdentifier = @"searchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        return cell;

    }
    else{
    static NSString *CustomCellIdentifier = @"searchResultCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //ResultViewCell *cell = (ResultViewCell*)[tableView dequeueReusableCellWithIdentifier:kResultViewCellId];
    
//    SearchResultTableViewCell *cell = (SearchResultTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier forIndexPath:indexPath];

    //nib注册，给tableView 添加cell
//     BOOL nibsRegistered = NO;
//    if (!nibsRegistered) {
//        UINib *nib = [UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
//        nibsRegistered = YES;
//    }
    
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    Shop * shop = [self.resultArray objectAtIndex:[indexPath row]];
    if (shop != nil)
    {
        cell.address.text =shop.address;
        cell.name.text = shop.name;
        
        NSLog(@"%f",cell.frame.size.height);
    }
        
        return cell;

    }

    
//    if (cell == nil)
//    {
//        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        [[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil];
//        cell = (SearchResultTableViewCell*)self.searchResultTableViewCell;
//        //cell.delegate = self;
//        
//        self.searchResultTableViewCell = nil;
//    }
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchDown];
//    [button setTitle:@"" forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"btn_icon_enter_map.png"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(269.0f, 11.0f, 35.0f, 35.0f);
//    [cell addSubview:button];
    
    // Configure the cell...
    
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
    
    NSLog(@"tag id is %d",[sender tag]);
    
//    ResultTableViewController *resultController = [segue destinationViewController];
//    
//    ShopSearchSpec * shpec = [[ShopSearchSpec alloc] init];
//    shpec.key = @""; //默认查询参数，不应该在这里写
//    //    shpec.lat = 0.0;
//    
//    
//    
//    //shpec.category = [sender tag]; 最后使用
//    //shpec.category = CategoryTypeAll; //测试使用
//    
//    //    switch ([sender tag]) {
//    //        case 1:
//    //            shpec.category=CategoryTypeAll;
//    //            break;
//    //
//    //        default:
//    //            shpec.category= CategoryTypeFood;
//    //            break;
//    //    }
//    
//    
//    resultController.shopSearchSpec = shpec;
}


- (IBAction)onclick:(UIButton *)sender {
//    UISegmentedControl * ctl = (UISegmentedControl *)sender;
    
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    NSArray *titles = @[@"item1", @"选项2", @"选项3",@"选项4",@"选项5"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%d", index);
    };
    [pop show];
    
}

- (IBAction)select:(id)sender {
    
    UISegmentedControl * ctl = (UISegmentedControl *)sender;
    
    CGPoint point = CGPointMake(ctl.frame.origin.x + ctl.frame.size.width/2, ctl.frame.origin.y + ctl.frame.size.height);
    NSArray *titles = @[@"item1", @"选项2", @"选项3"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        NSLog(@"select index:%d", index);
    };
    [pop show];
    
}
@end
