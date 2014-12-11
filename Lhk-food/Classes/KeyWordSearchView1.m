//
//  KeyWordSearchView.m
//  MapViewDemo
//
//  Created by huwei on 11/12/12.
//
//

#import "KeyWordSearchView.h"
#import "KSearchDetailsView.h"
#import "ViewController.h"
#import "JSONKit.h"
#import "AddressObject.h"
#import "ASIHTTPRequest.h"
#import "SFavoriteDB.h"
#import "MoreTableView.h"
#import "DejalActivityView.h"

@interface KeyWordSearchView ()

@end

@implementation KeyWordSearchView
@synthesize searchBar=_searchBar;
@synthesize cates = _cates;
@synthesize scrollView = _scrollView;
@synthesize pageControl=_pageControl;
@synthesize tableView = _tableView;
@synthesize queryTask = _queryTask, query = _query, featureSet = _featureSet;
@synthesize kSearchDetailsView = _kSearchDetailsView;
@synthesize request;
@synthesize favoriteDb=_favoriteDb;
@synthesize history=_history;
@synthesize results=_results;
@synthesize mainView=_mainView;
@synthesize curEnvelope=_curEnvelope;
@synthesize code=_code;
@synthesize count=_count;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favoriteDb = [[SFavoriteDB alloc] init];
    self.history = [SHistory new];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    [barButton setTitle:@"地图"];
    [self.navigationItem setLeftBarButtonItem:barButton];

    self.searchBar.delegate = self;
    [self initcates];
    [self initScrollView];
    //[self initQueryTask];
    self.mainView = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
}

-(void)putEnvelope:(AGSEnvelope*)env
{
    self.curEnvelope = env;
}

- (void)passValue:(NSString *)name classCode:(NSString*)code
{
    
    //[DejalKeyboardActivityView activityViewWithLabel:@"数据加载中"];
    self.searchBar.text = name;
    self.code = code;
    [self doSearchByTxt:name queryWhere:code envelope:self.curEnvelope];
    self.history.name = name;
    [self.favoriteDb saveHistory:self.history];//搜索历史入库
}

-(void)initScrollView{
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 55, 320, 548)];//初始化scrollview的界面 （坐标x，坐标y，宽度，高度）屏幕左上角为原点
    [self.scrollView setContentSize:CGSizeMake(960, 260)];//设置scrollview画布的大小，此设置为三页的宽度，380的高度。用来实现三页照片的转换。
    self.scrollView.pagingEnabled=YES;//立刻翻页到下一页 没中间的拖动过程
    self.scrollView.bounces=NO;//去掉翻页中的白屏
    [self.scrollView setDelegate:self];
    self.scrollView.showsHorizontalScrollIndicator=NO;//不现实水平滚动条
    self.scrollView.showsVerticalScrollIndicator=YES;//不现实水平滚动条
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    [self initPage1];
    [self initPage2];
    [self initPage3];
    
    //将pagecontrol添加到scrollview中
    self.pageControl=[[MyPageControl alloc]initWithFrame:CGRectMake(40, 33, 60, 36)];
    self.pageControl.numberOfPages=3;
    self.pageControl.currentPage=1;
    self.pageControl.backgroundColor = [UIColor clearColor];
    //self.pageControl.viewForBaselineLayout.alpha = 0.9;
    [self.pageControl setImagePageStateNormal:[UIImage imageNamed:@"BluePoint.png"]];
	[self.pageControl setImagePageStateHightlighted:[UIImage imageNamed:@"RedPoint.png"]];
    [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    //设置scrollview 初始化视图
    CGSize viewsize=self.scrollView.frame.size;
    CGRect rect=CGRectMake(viewsize.width, 0, viewsize.width, viewsize.height);
    [self.scrollView scrollRectToVisible:rect animated:NO];
}

//pagecontrol的点跟着页数改变
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scView{
    CGPoint offset=scView.contentOffset;
    CGRect bounds=scView.frame;
    [self.pageControl setCurrentPage:offset.x/bounds.size.width];
}
#pragma mark -
#pragma mark UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)_scrollView
{
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
	self.pageControl.currentPage = page;
	if (page ==1) {
        if (self.searchBar.resignFirstResponder) {
            [self.searchBar resignFirstResponder];
        }
    }
	NSArray *subView = self.pageControl.subviews;     // UIPageControl的每个点
    
	for (int i = 0; i < [subView count]; i++) {
        //if ([[subView objectAtIndex:i] isMemberOfClass:[UIImageView class]]) {
            UIImageView *dot = [subView objectAtIndex:i];
            //dot.image = (self.pageControl.currentPage == i ? [UIImage imageNamed:@"RedPoint.png"] : [UIImage imageNamed:@"BluePoint.png"]);
        //}
	}
	
}
//点击pagecontrol的点 跳到那一页的实现
- (IBAction)pageTurn:(UIPageControl *)sender {
    CGSize viewsize=self.scrollView.frame.size;
    CGRect rect=CGRectMake(sender.currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    
}

-(void)initcates
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"KeyWords" withExtension:@"plist"];
    self.cates = [NSArray arrayWithContentsOfURL:url];
}
//初始化搜索历史
-(void)initPage1{
    UIView *subview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 320, 300)];
    subview1.backgroundColor = [UIColor clearColor];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 2, 320, 280)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = YES;
    self.tableView.scrollEnabled  = YES;
    //table.backgroundColor=[UIColor redColor];
    UIView *labelview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //UILabel *lable = [[[UILabel alloc] initWithFrame:CGRectMake(110, 0, 320, 44)] autorelease];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button addTarget:self action:@selector(didClearButton) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(-5, -1, 330, 46)];
    [labelview addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 320, 44)];
    label.text = @"清空搜索历史";
    
    [labelview addSubview:label];
    
    self.tableView.tableFooterView =labelview;
    //添加到view窗体上
    [subview1 addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.scrollView addSubview:subview1];
    //[subview release];
}

-(void)didClearButton
{
    //[[CDataContainer Instance] deleteAllHistoryToDatabase];
    [self.favoriteDb deleteAllHistory];
    [self.tableView reloadData];
}
-(void)initPage2{
    int total = self.cates.count;
#define ROWHEIHT 50
    //int rows = (total / 2) + ((total % 2) > 0 ? 1 : 0);
    
    for (int i=0; i<total; i++) {
        int row = i % 2;
        int column = i / 2;
        NSDictionary *data = [self.cates objectAtIndex:i];
        
        UIView *subview2 = [[UIView alloc] initWithFrame:CGRectMake(80*column+330, ROWHEIHT*row, 40, ROWHEIHT)];
        subview2.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 15, 25, 25);
        btn.tag = i;
        //添加事件
        [btn addTarget:self action:@selector(CateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setBackgroundImage:[UIImage imageNamed:[[data objectForKey:@"imageName"] stringByAppendingFormat:@".png"]]
                       forState:UIControlStateNormal];
        
        [subview2 addSubview:btn];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 40, 14)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.textColor = [UIColor colorWithRed:100/255.0
                                        green:149/255.0
                                         blue:237/255.0
                                        alpha:1.0];
        lbl.font = [UIFont systemFontOfSize:12.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = [data objectForKey:@"name"];
        [subview2 addSubview:lbl];
        
        [self.scrollView addSubview:subview2];
        //[subview release];
    }
    
}
-(void)initPage3{
    int total = self.cates.count/2;
#define ROWHEIHT 50
    //int rows = (total / 2) + ((total % 2) > 0 ? 1 : 0);
    
    for (int i=total; i<self.cates.count; i++) {
        int row = i % 2;
        int column = i / 2;
        NSDictionary *data = [self.cates objectAtIndex:i];
        
        UIView *subview3 = [[UIView alloc] initWithFrame:CGRectMake(80*column+650, ROWHEIHT*row, 40, ROWHEIHT)];
        subview3.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 15, 25, 25);
        btn.tag = i;
        //添加事件
        [btn addTarget:self action:@selector(CateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setBackgroundImage:[UIImage imageNamed:[[data objectForKey:@"imageName"] stringByAppendingFormat:@".png"]]
                       forState:UIControlStateNormal];
        
        [subview3 addSubview:btn];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 40, 14)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.textColor = [UIColor colorWithRed:155/255.0
                                        green:155/255.0
                                         blue:195/255.0
                                        alpha:1.0];
        lbl.font = [UIFont systemFontOfSize:12.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = [data objectForKey:@"name"];
        [subview3 addSubview:lbl];
        
        [self.scrollView addSubview:subview3];
        //[subview release];
    }
    
}
-(void)CateBtnAction:(UIButton *)btn
{
    
    NSDictionary *Cate = [self.cates objectAtIndex:btn.tag];
    NSString *name =[Cate objectForKey:@"name"];
    NSLog(@"%@",name);
    if ([name isEqualToString:@"更多分类"]) {
        MoreTableView *moreTable = [[MoreTableView alloc] initWithNibName:@"MoreTableView" bundle:nil] ;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:moreTable];
        moreTable.isKorM=@"k";
        moreTable.kdelegate = self;
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;

        //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
        //or if you want to change it's position also, then:
        
        [self presentModalViewController:navigationController animated:YES];
        navigationController.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-30, [[UIScreen mainScreen] bounds].size.height/2-400, 320, 560);

    }
    else
    {
        [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"数据加载中"];
        NSString * str=[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //if ([str isEqualToString:@""]) {
        self.searchBar.text = name;
        //}
        self.code = [Cate objectForKey:@"code"];
        [self doSearchByTxt:self.searchBar.text queryWhere:[Cate objectForKey:@"code"] envelope:self.curEnvelope];
        self.history.name = self.searchBar.text;
        [self.favoriteDb saveHistory:self.history];//搜索历史入库
    }
    
    /*
     UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"信息"
     message:[NSString stringWithFormat:@"名称:%@",name]
     delegate:nil
     cancelButtonTitle:@"确认"
     otherButtonTitles:nil];
     [Notpermitted show];
     [Notpermitted release];*/
}

//收起键盘
-(void)backButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    /*
    MapViewDemoViewController *backGroundView = ((MapViewDemoAppDelegate*)[[UIApplication sharedApplication] delegate]).mainViewController;
    backGroundView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    backGroundView.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [backGroundView putQuery:NO];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:backGroundView] autorelease];
    ((MapViewDemoAppDelegate*)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;*/
    //[backGroundView release];
    //[nav release];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.favoriteDb getAllHistory] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    //cell.accessoryType = UITableViewCellAccessoryNone;
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //AGSGraphic *feature = [self.featureSet.features objectAtIndex:indexPath.row];
	//HistoryObject *ho = (HistoryObject*)[[CDataContainer Instance].searchHistorys objectAtIndex:indexPath.row];
    for (int i=0; i<[[self.favoriteDb getAllHistory] count]; i++) {
        if (i==indexPath.row) {
            SHistory *history = (SHistory*)[[self.favoriteDb getAllHistory] objectAtIndex:i];
            cell.textLabel.text = history.name;
        }
    }
    
	cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if view controller not created, create it, set up the field names to display
    
    UITableViewCell        *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.searchBar.text = cell.textLabel.text;
    [self doSearchByTxt:self.searchBar.text queryWhere:@"" envelope:self.curEnvelope];
    if (self.searchBar.resignFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}


#pragma mark UISearchBarDelegate

//when the user searches
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
    [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"数据加载中"];
	NSString * str=[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![str isEqualToString:@""]) {
        
        self.history.name = str;
        [self.favoriteDb saveHistory:self.history];//搜索历史入库
        [self doSearchByTxt:self.searchBar.text queryWhere:@"" envelope:self.curEnvelope];
    }
    if (self.searchBar.resignFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    if (self.searchBar.resignFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}


#pragma mark AGSQueryTaskDelegate

-(void)initQueryTask
{
    NSString *poiLayerURL = poiURL;
	
	//set up query task against layer, specify the delegate
	self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:poiLayerURL]];
	self.queryTask.delegate = self;
	
	//return all fields in query
	self.query = [AGSQuery query];
	self.query.outFields = [NSArray arrayWithObjects:@"*", nil];
    self.query.returnGeometry = YES;
}

-(void)doSearchTxt:(NSString*)searchtxt
{
    //display busy indicator, get search string and execute query
	self.query.text = searchtxt;
	[self.queryTask executeWithQuery:self.query];
}


//results are returned
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet {
	//get feature, and load in to table
	self.featureSet = featureSet;
    
    KSearchDetailsView *kSearchDetailsView = [[KSearchDetailsView alloc]initWithNibName:@"KSearchDetailsView" bundle:nil];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:kSearchDetailsView];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentModalViewController:navigationController animated: YES];

}

//if there's an error with the query display it to the user
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}


/*
-(void)doSearchByTxt:(NSString *)searchTxt queryWhere:(NSString*)where
{
   //[DejalKeyboardActivityView activityViewWithLabel:@"数据加载中"];
    
    NSString *params = @"http://www.tiandituhubei.com/newmapserver4/rest/services/HB_WMTS/whPOI/GeoCodeServer/geocode?str=";
    NSString *txt = [searchTxt stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    params = [params stringByAppendingString:txt];
    params = [params stringByAppendingFormat:@"&offset=0&limit=50&max=50&where="];
    if (where!=nil&&![where isEqualToString:@""]) {
        NSRange r;
        r.location=2;
        r.length=4;
        NSString *str = [where substringWithRange:r];
        if([str isEqualToString:@"0000"])
        {
            params = [params stringByAppendingFormat:@"type='"];
        }
        else{
            params = [params stringByAppendingFormat:@"type2='"];
        }
        
        params = [params stringByAppendingString:[[NSString alloc] initWithFormat:@"%@",where]];
        params = [params stringByAppendingFormat:@"'"];
    }
    params = [params stringByAppendingFormat:@"&bbox=&format=json"];
    //URLS = [URLS stringByAppendingString:params];
    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urls = [NSURL URLWithString:params];
    
    ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:urls];
    //Customise our user agent, for no real reason
    //[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requests setDelegate:self];
    // Start the request
    [requests startSynchronous];
    
    //[self showQueryResult];
}*/
-(void)doSearchByTxt:(NSString *)searchTxt queryWhere:(NSString*)where envelope:(AGSEnvelope*)env
{
    [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"数据加载中"];
    NSString *xmin = [[NSString alloc] initWithFormat:@"%f",env.xmin];
    NSString *ymin = [[NSString alloc] initWithFormat:@"%f",env.ymin];
    NSString *xmax = [[NSString alloc] initWithFormat:@"%f",env.xmax];
    NSString *ymax = [[NSString alloc] initWithFormat:@"%f",env.ymax];
    NSString *contion = nil;
    if (searchTxt!=NULL)
    {
        contion = [NSString stringWithFormat:@"%@ %@",where,searchTxt];
    }
    else{
        contion = [NSString stringWithFormat:@"%@",where];
    }
    
    NSString *params =RoundSearch(contion,ymin,xmin,ymax,xmax,0);
    NSLog(@"请求地址:%@",params);
    //NSString *params = KewWordSearch(where,searchTxt);
    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urls = [NSURL URLWithString:params];
    
    ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:urls];
    //Customise our user agent, for no real reason
    //[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requests setDelegate:self];
    // Start the request
    [requests startSynchronous];
}


#pragma 网络请求委托
// 成功回调函数
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    if (responseData) {
        NSDictionary *resultsDictionary = [responseData objectFromJSONData];
        if (resultsDictionary!=nil) {
            self.results = (NSArray*)[resultsDictionary objectForKey:@"list"];
            self.count = [(NSString*)[resultsDictionary objectForKey:@"count"] intValue];
            NSLog(@"结果数目:%@",(NSString*)[resultsDictionary objectForKey:@"count"]);
            self.mainView.results = self.results;
            self.mainView.count = self.count;
            [self dismissModalViewControllerAnimated:YES];
            if (self.results.count>0) {
                [self.mainView showQueryResults: self.results :@"K" :self.searchBar.text :self.code :self.curEnvelope.center :self.count];
            }
            else
            {
                [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"没有找到任何结果!"];
            }
            
        }
        [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:1.0];
    }
 

}
// 失败回调函数
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSError *error = [request error];
    [self performSelector:@selector(changeActivityView) withObject:nil afterDelay:2.0];
}
- (void)changeActivityView;
{
    [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"网络连接错误！"];
    [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.5];
    
}
-(void)removeActivityView
{
    [DejalBezelActivityView removeViewAnimated:YES];
}
//获取查询数列
-(NSArray *)getDataSet
{
    NSArray *results =nil;
    if (request) {
        if ([request responseString]) {
            NSData *result = [request responseString];
            NSDictionary *resultsDictionary = [result objectFromJSONData];
            if (resultsDictionary!=nil) {
                results = (NSArray*)[resultsDictionary objectForKey:@"list"];
            }
            
        }
    }
    return results;
}


-(void)showQueryResult
{
    //if (self.searchBar.resignFirstResponder) {
     //   [self.searchBar resignFirstResponder];
    //}
    [DejalBezelActivityView removeViewAnimated:YES];
    KSearchDetailsView *ksearch = [[KSearchDetailsView alloc] initWithNibName:@"KSearchDetailsView" bundle:nil];
    
	[ksearch putDataSet: self.results];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ksearch];
	//display the feature attributes
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
    //or if you want to change it's position also, then:
    navigationController.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-240, [[UIScreen mainScreen] bounds].size.height/2-180, 360, 320);
    [self.navigationController presentModalViewController:navigationController animated:YES];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self.searchBar becomeFirstResponder];
    self.view.superview.bounds = CGRectMake(0, 0, 280, 320);
    CGPoint centerPoint = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    self.view.superview.center = centerPoint;
    //self.view.superview.frame =  CGRectMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2, 280, 320);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
