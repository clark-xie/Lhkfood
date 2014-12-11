//
//  MainViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/10/22.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "MainViewController.h"
#import "ResultTableViewController.h"
#import "InputHelper.h"
#import "KeyboardManager.h"

@interface MainViewController ()

@property NSMutableArray *searchHistory;
@property ShopSearchSpec * shpec;
@property DataTableSeachMessege *dateTable;
@end

@implementation MainViewController


bool searchBarClick =false;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置键盘不进行上下移动
//    [[IQKeyboardManager sharedManager] setEnable:NO];

//    [inputHelper setupInputHelperForView:self.view withDismissType:InputHelperDismissTypeTapGusture doneBlock:^(id res){
//        
//        NSLog(@"Hello! inputHelper");
//    }];
//    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    //查询历史数据库初始化
   self.dateTable = [DataTableSeachMessege dataTableSeachMessege];
    
    self.searchHistory = [[NSMutableArray alloc] initWithCapacity:3];

//    switch (num) {
//        case 1://插入
//        {
//            [dateTable insertTableWith:self.insertText.text];
//        }
//            
//            break;
//        case 2://查询
//        {
//            [self.mutArray setArray:[dateTable selectSearchMesWihtNum:[self.selectText.text integerValue]]];
    
    
                                    // [[NSMutableArray alloc]initWithObjects:@"老河口",@"美食",@"有名", nil];
    self.searchBar.delegate = self;
    self.shpec= [[ShopSearchSpec alloc] init]; //查询参数初始化
    
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//[self.navigationController.interactivePopGestureRecognizer]

    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog ( @"%@" , self .navigationController .viewControllers );
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    
//    UIButton *button  = sender;
    
    //需要判断tag是否为UIview，只有UIview才有tag属性
    
    NSLog(@"tag id is %d",[sender tag]);

//    if([sender tag] == self.mapBarButton.tag)  //如果是显示地图的tag，则显示地图
//        
//    {
//        
//    }
//    else
    {
    
        ResultTableViewController *resultController = [segue destinationViewController];
        resultController.shopSearchSpec = _shpec;//查询参数
        resultController.showtype = ResultTableStyleSearch;
    
//    self.shpec.key = @""; //默认查询参数，不应该在这里写
//    shpec.lat = 0.0;
    
    
    
    //shpec.category = [sender tag]; 最后使用
    //shpec.category = CategoryTypeAll; //测试使用
    
//    switch ([sender tag]) {
//        case 1:
//            shpec.category=CategoryTypeAll;
//            break;
//            
//        default:
//            shpec.category= CategoryTypeFood;
//            break;
//    }
    

        resultController.shopSearchSpec = self.shpec;
    }
}


//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 1;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//   static NSString *kCellID = @"CellIdentifier";
//    
//    // dequeue a cell from self's table view
//    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
//
////    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID];
//    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    //ResultViewCell *cell = (ResultViewCell*)[tableView dequeueReusableCellWithIdentifier:kResultViewCellId];
//    
//    //    SearchResultTableViewCell *cell = (SearchResultTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier forIndexPath:indexPath];
//    
//    //nib注册，给tableView 添加cell
//    //     BOOL nibsRegistered = NO;
//    //    if (!nibsRegistered) {
//    //        UINib *nib = [UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil];
//    //        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
//    //        nibsRegistered = YES;
//    //    }
//    
////    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
//    
////    Shop * shop = [self.resultArray objectAtIndex:[indexPath row]];
////    if (shop != nil)
////    {
////        cell.address.text =shop.address;
////        cell.name.text = shop.name;
////        
////        NSLog(@"%f",cell.frame.size.height);
////    }
//    
//    cell.textLabel.text = @"test";
//    
//    
//    
//    //    if (cell == nil)
//    //    {
//    //        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    //        [[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil];
//    //        cell = (SearchResultTableViewCell*)self.searchResultTableViewCell;
//    //        //cell.delegate = self;
//    //
//    //        self.searchResultTableViewCell = nil;
//    //    }
//    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchDown];
//    //    [button setTitle:@"" forState:UIControlStateNormal];
//    //    [button setImage:[UIImage imageNamed:@"btn_icon_enter_map.png"] forState:UIControlStateNormal];
//    //    button.frame = CGRectMake(269.0f, 11.0f, 35.0f, 35.0f);
//    //    [cell addSubview:button];
//    
//    // Configure the cell...
//    
//    return cell;
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    
    //如果是查询界面，则显示查询历史
    if(searchBarClick == true)
    {
        return [self.searchHistory count];
    }
    return 1;
}


//设置行高
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(searchBarClick == true)
    {
        return 66;
    }
    else return 500;
//    UIFont *font = [UIFont systemFontOfSize:14.0];
//    CGSize size = [dataString sizeWithFont:font constrainedToSize:CGSizeMake(contentLabelWidth, 1000)
//                             lineBreakMode:UILineBreakModeWordWrap];
//    return size.height + 5; // 5即消息上下的空间，可自由调整
    
}

//查询界面的历史查询
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(searchBarClick )
    {
        self.shpec = [[ShopSearchSpec alloc]init];
        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        self.shpec.key =cell.textLabel.text;  //赋值
        //查询的类型默认为0
        self.shpec.category = [NSNumber numberWithInt:0];
        [self performSegueWithIdentifier:@"searchResultSegue" sender:cell];
//        [self.searchBar resignFirstResponder];

            [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    


    if (searchBarClick )
    {
        NSString *cellIdentifier = @"cell2";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.textLabel.text = [self.searchHistory objectAtIndex:[indexPath row]];
        return cell;
    }
    else
    {
        NSString *cellIdentifier = @"cell1";

        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        return  cell;
    }
    
    
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    
    // Configure the cell...
    
//    return cell;
}



- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBarClick = true;
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.searchHistory setArray: [self.dateTable selectSearchMesWihtNum:10]];  //设置查询历史结果

    [self.tableView reloadData];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBarClick = false;
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
//    [liveViewAreaTable searchDataBySearchString:nil];// 搜索tableView数据
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self controlAccessoryView:0];// 隐藏遮盖层。
    searchBar.text = @""; //把searchBar的文字去除
    [self.tableView reloadData];

    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"您点击了键盘上的Search按钮");
    [self.dateTable insertTableWith:searchBar.text];
    self.shpec = [[ShopSearchSpec alloc]init];
    self.shpec.key = searchBar.text;  //设置查询参数
    self.shpec.category = [NSNumber numberWithInt:0];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self performSegueWithIdentifier:@"searchResultSegue" sender:searchBar];
}



- (IBAction)press:(id)sender {
    
    //根据button 的tag，设置对应的参数
    self.shpec = [[ShopSearchSpec alloc]init];
//    Shop *shop = [[Shop alloc ]init ];
//    NSNumber * nu =
//    self.shpec.key =[shop categoryTypeById: [NSNumber numberWithInt:[sender tag] - 100]  ];
    self.shpec.category = [NSNumber numberWithInt:[sender tag] -100];
    self.shpec.key = @""; //查询任意值
    [self performSegueWithIdentifier:@"searchResultSegue" sender:sender];
    
}

@end
