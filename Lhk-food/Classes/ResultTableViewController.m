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
#import "DOPDropDownMenu.h"

#import "UIImageView+WebCache.h"
//#import "MJTableViewController.h"
//#import "MJTestViewController.h"
#import "MJRefresh.h"

@interface ResultTableViewController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource,CLLocationManagerDelegate>
@property NSMutableArray *resultArray;  //搜索结果列表
@property NSArray *scope;
@property NSArray *scopeValue;
@property NSArray *category;
@property NSArray *categoryValue;
@property (nonatomic, strong) CLLocationManager *locationManager;  //要了解nonatomic和strong的意思

@property (nonatomic,strong) CLLocation * currentLocation; //当前位置
@property  NSInteger cellTag; //查询结构的celltag值

@property NSInteger selectid;
@property NSInteger selectRow;
@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //不显示后退按钮的标题
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    self.resultArray =[[NSMutableArray alloc] init];
    //初始页为1;
    
    if(self.shopSearchSpec ==nil)   //如果传递给过来的参数没有对shop赋值，则自己赋值
    {
        self.shopSearchSpec = [[ShopSearchSpec alloc] init];
    }
    self.shopSearchSpec.currentPage = 0;

    self.shopSearchSpec.lat = _currentLocation.coordinate.latitude;
    self.shopSearchSpec.lng= _currentLocation.coordinate.longitude;

    
//    self.tableView.rowHeight = 138;   //这个需要修改，以后再改吧
//    [self query];
    

    self.scope = [[NSArray alloc]initWithObjects:@"不限距离",@"200米",@"500米",@"1000米",@"1500米",@"2000米",nil];
    self.scopeValue  = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:200] ,[NSNumber numberWithInt:500],[NSNumber numberWithInt:1000],[NSNumber numberWithInt:1500],[NSNumber numberWithInt:2000],nil];
    self.category =[[NSArray alloc]initWithObjects:@"不限类别",@"中餐",@"西餐",@"饭店",@"茶馆",@"食品店",@"蛋糕店",@"特色饮食",nil];
    self.categoryValue = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],nil];

//    NSDictionary * dic
    
    //下来表格
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
    menu.dataSource = self;
    menu.delegate = self;
    
    //根据显示类型，做必要的初始化
//    [self initByResultTableStyle:_showtype];
    [self.tableView addSubview:menu];
    
    //开启定位功能
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
//    self.locationManager.desiredAccuracy = [setupInfo[kSetupInfoKeyAccuracy] doubleValue];
    
    // Once configured, the location manager must be "started"
    //
    // for iOS 8, specific user level permission is required,
    // "when-in-use" authorization grants access to the user's location
    //
    // important: be sure to include NSLocationWhenInUseUsageDescription along with its
    // explanation string in your Info.plist or startUpdatingLocation will not work.
    //
    //    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    //        [self.locationManager requestWhenInUseAuthorization];
    //    }
    [self.locationManager startUpdatingLocation];
    
    [self setupRefresh];
    
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;

//    [self.tableView frameForAlignmentRect: CGRectMake(0, 104, screenSize.width, screenSize.height - 104)];
//    self.navigationController
    
    
//    _shopSearchSpec = [[ShopSearchSpec alloc] init];
    
//    [self.tableView registerClass:[TDishViewController class] forCellReuseIdentifier:@"Cell"];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.navigationController.title
}

-(void) initByResultTableStyle:(ResultTableStyle) style
{
    //根据table类型，显示对应的主键
     if(style == ResultTableStyleMyShop)
     {
         self.navigationItem.title = @"我的店铺";
         
         UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                         target:self
                                         action:@selector(rightClick:)];
         rightButton.tag = 22;//不能为0,有个地方判断了tag值的
         self.navigationItem.rightBarButtonItem = rightButton;
         self.tabBarController.tabBar.hidden = NO;
        
         
//         self.rightBarItem
     }
    else if(style == ResultTableStyleSearch)
    {
        self.tabBarController.tabBar.hidden = YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self initByResultTableStyle:_showtype];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

-(void) rightClick:(id) sender
{
    NSLog(@"rightClient click");
    [self performSegueWithIdentifier:@"addShopSegue" sender:sender];

    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    
//    [super viewWillAppear:animated];
//    if(!self.pullTableView.pullTableIsRefreshing) {
//        self.pullTableView.pullTableIsRefreshing = YES;
//        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
//    }
//    
////    self.pullTableView.pullTableIsLoadingMore =YES;
//}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView footerBeginRefreshing];

    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"MJ哥正在帮你刷新中,不客气";
    
    self.tableView.footerPullToRefreshText = @"加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"加载更数据";
    self.tableView.footerRefreshingText = @"加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.fakeData insertObject:MJRandomData atIndex:0];
//    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.fakeData addObject:MJRandomData];
//    }
    
    //默认从第一也开始查询
//    if( self.shopSearchSpec.currentPage == 0)
//    {
//        self.shopSearchSpec.currentPage = 1;
//        [self query];
//
//    }
     if(self.shopSearchSpec.currentPage == 0 ||self.shopSearchSpec.totalCount >self.shopSearchSpec.currentPage * self.shopSearchSpec.numberPerPage )
    {
        self.shopSearchSpec.currentPage+=1;
        [self query];
    }
     else
     {
          [self.tableView footerEndRefreshing];
     }
//    
//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        
//        
//        
////        [self.tableView reloadData];
////        
////        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
////        [self.tableView footerEndRefreshing];
//    });
}


//- (void) refreshTable
//{
//    /*
//     
//     Code to actually refresh goes here.
//     
//     */
////    self.pullTableView.pullLastRefreshDate = [NSDate date];
////    self.pullTableView.pullTableIsRefreshing = NO;
//}
//
//
//- (void) loadMoreDataToTable
//{
//    /*
//     
//     Code to actually load more data goes here.
//     
//     */
//    
//    if(self.shopSearchSpec.resultCount >self.shopSearchSpec.currentpage * self.shopSearchSpec.numberPerPage )
//    {
//        self.shopSearchSpec.currentpage+=1;
//    }
//    
//    [self query];   //查询
////   self.pullTableView.pullTableIsLoadingMore = NO;
//}



// We want to get and store a location measurement that meets the desired accuracy.
// For this example, we are going to use horizontal accuracy as the deciding factor.
// In other cases, you may wish to use vertical accuracy, or both together.
//
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    //保存当前位置
    _currentLocation = newLocation;
    //比较距离，并加入到NSarray中
    
//    //更新每个点的距离，需要修改
//    for(int i=0 ; i<[_resultArray count]; i++)
//    {
//        
//        _resultArray re
//        CLLocationDistance meters=[current distanceFromLocation:before];
//
//    }
//    //第一个坐标
//    CLLocation *current=[[CLLocation alloc] initWithLatitude:32.178722 longitude:119.508619];
//    //第二个坐标
//    CLLocation *before=[[CLLocation alloc] initWithLatitude:32.206340 longitude:119.425600];
//    // 计算距离
//    CLLocationDistance meters=[current distanceFromLocation:before];
    
    // update the display with the new location data
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    //
    if ([error code] != kCLErrorLocationUnknown) {
        NSLog(@"location have error");
//        [self stopUpdatingLocationWithMessage:NSLocalizedString(@"Error", @"Error")];
    }
}

//返回两个值的距离
-(CLLocationDistance) distancewithLat:(double) x lot:(double) y
{
    CLLocation *locaton=[[CLLocation alloc] initWithLatitude:x longitude:y];
    return  [_currentLocation distanceFromLocation:locaton];   //对比两个距离的数值
}

- (void) query {
    
    
//    self.shopSearchSpec.currentpage  =1; //测试使用，最终要修改
    
    NSString *query;
    if(_showtype == ResultTableStyleSearch)
    {
        query = ShopList(self.shopSearchSpec.key,[self.shopSearchSpec.category intValue ],self.shopSearchSpec.lat,self.shopSearchSpec.lng,self.shopSearchSpec.scope,self.shopSearchSpec.currentPage);

    }
    else
    {
        query = Recommends(0.0,0.0,0,0.0,1);
    }
    
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];

//    [SVProgressHUD show];
    
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
//    [SVProgressHUD dismiss];

    NSLog(@"请求出错");
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error;
    if (data!=nil) {
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error] ;
        
        //        NSArray* arrayResult =[dic objectForKey:@"results"];
        
        
//        NSLog(@"%@",dic);
        
        NSArray *pageresultArray = [dic objectForKey:@"result"];

        //如果result直接为空值，则直接返回 判断dic中的值是否为空，得以下的方式
        if((NSNull *)pageresultArray == [NSNull null] ||pageresultArray == nil)
        {
            return;
        }
//        NSInteger shopid = [[tmps objectForKey:@"id"] integerValue];

        self.shopSearchSpec.totalCount = [[dic objectForKey:@"totalCount"] integerValue];
        self.shopSearchSpec.resultCount =[[dic objectForKey:@"resultCount"] integerValue];
        self.shopSearchSpec.currentPage =[[dic objectForKey:@"currentPage"] integerValue];

        self.shopSearchSpec.numberPerPage = [[dic objectForKey:@"numberPerPage"] integerValue];
        
        for(int i =0 ;i < [pageresultArray count] ; i++)
        {
            
            NSDictionary *dic = [pageresultArray objectAtIndex:i] ;

            Shop *shop = [[Shop alloc] initWithDictionary:dic];
//            NSString *name = [tmps objectForKey:@"shop_name"];
//            NSInteger shopid = [[tmps objectForKey:@"id"] integerValue];
//            NSString *address = [tmps objectForKey:@"address"];
//    //        NSNumber *rate = [tmps objectForKey:@"rate"];
//            
////            NSNumber *rate =[tmps objectForKey:@"rate"];
//    //        [NSNumber numberWithDouble:4.5];
//
//            Shop * shop = [[Shop alloc]init];
//            shop.name = name;
//            shop.address  = address;
//            shop.shopid = [NSNumber numberWithInteger:shopid];
//            shop.latitude = [Helper numberFromString:[tmps objectForKey:@"latitude"]];
//
//            shop.longitude = [Helper numberFromString:[tmps objectForKey:@"longitude"]];
//            
//            shop.rate = [Helper numberFromString:[tmps objectForKey:@"rate"]];
//            shop.shop_images = [tmps objectForKey:@"shop_images"];
//            shop.avg_spend = [Helper numberFromString:[tmps objectForKey:@"avg_spend"]];
            
//            shop.address =[tmps objectForKey:@"address"];
            
//            shop.rate =rate;
            
    //        self.shopSearchSpec.key = str;
    //        [resultArrary add]
            [self.resultArray addObject:shop];//临时使用，应该使用一个类代替
//            NSLog(@"%@",shop.address);

        }
//        NSLog(@"店铺数量是 %d",[dic count]);
//        _testLabel.text = str;
        [self.tableView  reloadData];
        
        [self.tableView footerEndRefreshing];

//        [SVProgressHUD dismiss];
        
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if(column == 0)
    {
        return [self.scope count];
    }
    return [self.category count];
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0: return [self.scope objectAtIndex:[indexPath row]];
            break;
        case 1: return [self.category objectAtIndex:[indexPath row]];
            break;
        default:
            return nil;
            break;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
//    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
//    NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);

    switch (indexPath.column) {
        case 0:

            //赋值查询参数
            self.shopSearchSpec.scope = [[self.scopeValue objectAtIndex:[indexPath row]] doubleValue];
            break;
        case 1:

            //赋值查询参数
            self.shopSearchSpec.category =  [self.categoryValue objectAtIndex:[indexPath row]] ;

            break;

            
        default:
            break;
    }

    //赋值x，y
    self.shopSearchSpec.lat = _currentLocation.coordinate.latitude;
    self.shopSearchSpec.lng= _currentLocation.coordinate.longitude;

    //重新查询时，从第一页开始查起
    self.shopSearchSpec.currentPage = 1;
    self.resultArray =[[NSMutableArray alloc] init];
//    [self.tableView reloadData];
    [self query];

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
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [self.resultArray count];
    }
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 0)
    {
        return  40;
    }
    return  104;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([indexPath section] == 0)
    {
        static NSString *CustomCellIdentifier = @"searchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        //表格项目的tag值
//
//        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
//        menu.dataSource = self;
//        menu.delegate = self;
//        [cell addSubview:menu];
//        cell
//        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        return cell;

    }
    else
    {
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
//        NSLog(@"%d",[self.resultArray count]);
    if (shop != nil)
    {
        cell.address.text =shop.address;
        
        cell.name.text = shop.name;
        //得到结果类型
        cell.foodtype.text = [shop categoryType];
        
        //判断latitude是否为空值
        if(!((NSNull *)shop.latitude ==[NSNull null]) && !((NSNull *)shop.longitude ==[NSNull null]))
        {
            double distance =[self distancewithLat:[shop.latitude doubleValue] lot:[shop.longitude doubleValue] ];
            
            cell.distance.text = [[NSString alloc]initWithFormat:@"%.f米",distance];
        }
        
        cell.rateImage.image = [Rate imageFromRate:shop.rate];
        //要对空值进行处理，要不然会报错
//        cell.address.text =@"测试";
//        cell.name.text = @"名称";

        
        cell.imageView.image = [Rate imageFromRate:shop.rate];
        
        //显示图片的
        NSString *str = [NSString stringWithFormat:@"http://111.47.52.51:3000/lhkfood/Upload/Thumbs/%@",shop.shop_images];
        [cell.shopimge sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed: @"foodexmaple"]];

        
        cell.tag = _cellTag;

//        [cell.imageView setImage:[Rate imageFromRate:shop.rate]];
        
//        [cell.rateImage setImage:[Rate imageFromRate:shop.rate]];
// UIImage imageNamed:@"shop"        cell.imageView setImage:[UIimage ]
//        NSLog(@"%f",cell.frame.size.height);
    }
        
//        cell addSubview:<#(UIView *)#>
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectRow = [indexPath row];
    static NSString *CustomCellIdentifier = @"searchResultCell";

    if(_showtype == ResultTableStyleMyShop)
    {
        if([indexPath section] == 1)
        {
            Shop * shop =[_resultArray objectAtIndex:[indexPath row]];
            _selectid =[shop.shopid integerValue];
            //        NSLog(@"selectid is %d",_selectid);
            
            SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
            [self performSegueWithIdentifier:@"addShopSegue" sender:cell];
        }
    }
    else
    {

    if([indexPath section] == 1)
    {
        Shop * shop =[_resultArray objectAtIndex:[indexPath row]];
        _selectid =[shop.shopid integerValue];
//        NSLog(@"selectid is %d",_selectid);
        
        SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];

        
        [self performSegueWithIdentifier:@"showDetailSegue" sender:cell];

    }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //    UIButton *button  = sender;
    //如果在我的商铺界面，则处理新增和编辑的功能
    if(_showtype == ResultTableStyleMyShop)
    {
        //如果试cell，则
        if([sender tag] == _cellTag)
        {
//            ShopDetailTableViewController *controller = [segue destinationViewController];
//            ShopSearchSpec *shpec = [[ShopSearchSpec alloc] init];
//            shpec.shopid = _selviewControllerectid;
//            controller.searchSpec =shpec;
            
            
            AddShopViewController * viewController = [segue destinationViewController];
            viewController.shop = [self.resultArray objectAtIndex:self.selectRow];
            //更新状态
            viewController.type = AddShopTypeUpdate;
        }
        
        else
        {
//            //给地图View赋值
//            ViewController *viewController =[segue destinationViewController];
//            viewController.resultArray = _resultArray; //给结果赋值
            
            
        }
        return;
    }
    
    //如果试cell，则
    if([sender tag] == _cellTag)
    {
        ShopDetailTableViewController *controller = [segue destinationViewController];
        ShopSearchSpec *shpec = [[ShopSearchSpec alloc] init];
        shpec.shopid = _selectid;
        controller.searchSpec =shpec;
    }
    
    else
    {
        //给地图View赋值
        ViewController *viewController =[segue destinationViewController];
        viewController.resultArray = _resultArray;
//        viewController.resultArray = _resultArray; //给结果赋值
        
    }
    
//    NSlog(@"tag id is %d",[])
    
    NSLog(@"select is  tag id is %d",[sender tag]);
    
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


//另一种下来列表的表示方法
//- (IBAction)onclick:(UIButton *)sender {
////    UISegmentedControl * ctl = (UISegmentedControl *)sender;
//    
//    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
//    NSArray *titles = @[@"item1", @"选项2", @"选项3",@"选项4",@"选项5"];
//    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
//    pop.selectRowAtIndex = ^(NSInteger index){
//        NSLog(@"select index:%d", index);
//    };
//    [pop show];
//    
//}
//
//- (IBAction)select:(id)sender {
//    
//    UISegmentedControl * ctl = (UISegmentedControl *)sender;
//    
//    CGPoint point = CGPointMake(ctl.frame.origin.x + ctl.frame.size.width/2, ctl.frame.origin.y + ctl.frame.size.height);
//    NSArray *titles = @[@"item1", @"选项2", @"选项3"];
//    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
//    pop.selectRowAtIndex = ^(NSInteger index){
//        NSLog(@"select index:%d", index);
//    };
//    [pop show];
//    
//}




//#pragma mark - PullTableViewDelegate
//
//- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
//{
//    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
//}
//
//- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
//{
//    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
//}

@end
