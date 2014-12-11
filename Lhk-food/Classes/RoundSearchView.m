//
//  RoundSearchView.m
//  MapViewDemo
//
//  Created by 磊 李 on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundSearchView.h"
#import "RoundSearchDetailView.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "MoreTableView.h"
#import "DejalActivityView.h"

@interface RoundSearchView ()

@end

@implementation RoundSearchView
@synthesize tableHeaderView;
@synthesize myLocation;
@synthesize strLocation=_strLocation;
@synthesize searchContent = _searchContent;
@synthesize cates = _cates;
@synthesize curEnvelope=_curEnvelope;
@synthesize searchBar =_searchBar;
@synthesize curGraphic=_curGraphic;
@synthesize requests;
@synthesize results=_results;
@synthesize mainView=_mainView;
@synthesize count=_count;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _keyword=nil;
        _keycode=nil;
    }
    return self;
}

-(void)putEnvelope:(AGSEnvelope*)env
{
    self.curEnvelope = env;
}

-(void)putGraphic:(AGSGraphic*)graphic
{
    self.curGraphic =graphic;
   // double tempLength = 5000*1/111194.872221777;
   /* self.curEnvelope = [AGSMutableEnvelope envelopeWithXmin:((AGSPoint*)self.curGraphic.geometry).x-tempLength
                                                       ymin:((AGSPoint*)self.curGraphic.geometry).y-tempLength
                        
                                                       xmax:((AGSPoint*)self.curGraphic.geometry).x+tempLength
                        
                                                       ymax:((AGSPoint*)self.curGraphic.geometry).y+tempLength
                        
                                           spatialReference:graphic.geometry.spatialReference];*/
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchBar.delegate = self;
    
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    [barButton setTitle:@"地图"];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
    self.tableView.tableHeaderView = tableHeaderView;
    [self initcates];
    self.mainView = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    
}
-(void)initcates
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"KeyWords" withExtension:@"plist"];
    self.cates = [NSArray arrayWithContentsOfURL:url];
}
-(void)backButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
   /* MapViewDemoViewController *backGroundView = ((MapViewDemoAppDelegate*)[[UIApplication sharedApplication] delegate]).mainViewController;
    backGroundView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    backGroundView.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [backGroundView putQuery:NO];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:backGroundView];
    ((MapViewDemoAppDelegate*)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
    [backGroundView release];
    [nav release];*/
}

- (void)passValue:(NSString *)name classCode:(NSString*)code
{
    [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"数据加载中"];
    self.searchBar.text = name;
    [self doRoundSearch:self.curEnvelope keyWord:name condition:code];
    if (self.searchBar.resignFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}
/*
-(void)doRoundSearch:(AGSEnvelope*)env keyWord:(NSString*)keyword condition:(NSString*)where
{
   //[DejalBezelActivityView activityViewForView:self.view withLabel:@"数据加载中"];
    NSString *params = @"http://www.tiandituhubei.com/newmapserver4/rest/services/HB_WMTS/whPOI2/GeoCodeServer/geocode?str=";
    NSString *txt = [keyword stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if (txt==nil) {
        txt=@"湖北";
    }
    _keyword = txt;
    params = [params stringByAppendingString:[[NSString alloc] initWithFormat:@"%@",txt]];
    params = [params stringByAppendingFormat:@"&offset=0&limit=20&max=100&where="];
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
     _keycode = where;
    params = [params stringByAppendingFormat:@"&bbox="];
    if (env!=nil) {
        params = [params stringByAppendingString:[[NSString alloc] initWithFormat:@"%f",env.xmin]];
        params = [params stringByAppendingFormat:@","];
        params = [params stringByAppendingString:[[NSString alloc] initWithFormat:@"%f",env.ymin]];
        params = [params stringByAppendingFormat:@","];
        params = [params stringByAppendingString:[[NSString alloc] initWithFormat:@"%f",env.xmax]];
        params = [params stringByAppendingFormat:@","];
        params = [params stringByAppendingString:[[NSString alloc] initWithFormat:@"%f",env.ymax]];
    }
    
    params = [params stringByAppendingFormat:@"&format=json"];
        
    //URLS = [URLS stringByAppendingString:params];
    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urls = [NSURL URLWithString:params];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urls];
    [request setDelegate:self];
    // Start the request
    [request startSynchronous];
    
    //[self showQueryResult];
}*/

-(void)doRoundSearch:(AGSEnvelope*)env keyWord:(NSString*)keyword condition:(NSString*)where
{
   [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"数据加载中"];
    CGPoint pt1,pt2;
    pt1.x=env.xmin;
    pt1.y=env.ymin;
    pt2.x=env.xmax;
    pt2.y=env.ymax;
    //pt1 = [Commont Mercator2lonLat:pt1];
    //pt2 = [Commont Mercator2lonLat:pt2];
    NSString *xmin = [[NSString alloc] initWithFormat:@"%f",pt1.x];
    NSString *ymin = [[NSString alloc] initWithFormat:@"%f",pt1.y];
    NSString *xmax = [[NSString alloc] initWithFormat:@"%f",pt2.x];
    NSString *ymax = [[NSString alloc] initWithFormat:@"%f",pt2.y];
    NSString *contion = nil;
    if (keyword!=NULL)
    {
        contion = [NSString stringWithFormat:@"%@ %@",where,keyword];
    }
    else{
        contion = [NSString stringWithFormat:@"%@",where];
    }
    
    NSString *params =RoundSearch(contion,ymin,xmin,ymax,xmax,0);
    
    //URLS = [URLS stringByAppendingString:params];
    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urls = [NSURL URLWithString:params];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urls];
    [request setDelegate:self];
    // Start the request
    [request startSynchronous];
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
           // [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:1];
            self.results = (NSArray*)[resultsDictionary objectForKey:@"list"];
            self.count = [(NSString*)[resultsDictionary objectForKey:@"count"] intValue];
            self.mainView.results = self.results;
            self.mainView.count =  self.count;
            [self dismissModalViewControllerAnimated:YES];
            if (self.results.count>0) {
                if (self.curGraphic!=nil) {
                    [self.mainView showQueryResults: self.results :@"R" : _keyword :_keycode :(AGSPoint*)self.curGraphic.geometry :self.count];
                }
                else
                {
                    AGSPoint* point = self.curEnvelope.center;
                    //[self.mainView showQueryResults: self.results :@"R" :_keyword:_keycode  :point];
                    [self.mainView showQueryResults: self.results :@"R" : _keyword :_keycode :point :self.count];
                }

            }
            else{
                [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"没有找到任何结果!"];
            }
            [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:1];
            
        }else
        {
            
            [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"没有查询到记录！"];
            [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:1];
        }
        //[self performSelector:@selector(showQueryResult) withObject:nil afterDelay:2.0];
    }

}
// 失败回调函数
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
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
        [self dismissModalViewControllerAnimated:YES];
}
//获取查询数列
-(NSArray *)getDataSet
{
    NSArray *results =nil;
    if (requests) {
        if ([requests responseString]) {
            NSData *result = [requests responseString];
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
    [DejalBezelActivityView removeViewAnimated:YES];
    RoundSearchDetailView *searchView = [[RoundSearchDetailView alloc] initWithNibName:@"RoundSearchDetailView" bundle:nil] ;
	
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchView];
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
    //or if you want to change it's position also, then:
    navigationController.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-240, [[UIScreen mainScreen] bounds].size.height/2-180, 560, 320);
    [self.navigationController presentModalViewController:navigationController animated:YES];
    
    if (self.searchBar.resignFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark UISearchBarDelegate

//when the user searches
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString * str=[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![str isEqualToString:@""]) {
        [self doRoundSearch:self.curEnvelope keyWord:str condition:@""];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.cates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[self.cates objectAtIndex:indexPath.row] objectForKey:@"name"];
    //cell.textLabel.font =  [UIFont fontWithName:@"Arial-BoldItalicMT" size:12];
    cell.imageView.image = [UIImage imageNamed:[[self.cates objectAtIndex:indexPath.row] objectForKey:@"imageName"]];

    
    return cell;
}


- (void)viewWillAppear:(BOOL)animated{
    if ([self.curGraphic.allAttributes objectForKey:@"name"]!=nil) {
        NSString *location = @"在‘";
        location = [location stringByAppendingFormat:[NSString stringWithFormat:@"%@",[self.curGraphic.allAttributes objectForKey:@"name"]],nil];
        location = [location stringByAppendingFormat:@"'附近",nil];
        self.myLocation.text = location;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell   *cell = [tableView cellForRowAtIndexPath:indexPath];
    
   if([cell.textLabel.text isEqualToString:@"更多分类"])
   {
       MoreTableView *moreTable = [[MoreTableView alloc] initWithNibName:@"MoreTableView" bundle:nil];
       moreTable.isKorM = @"m";
       moreTable.mdelegate = self;
       UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:moreTable];
       navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
       navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
       
       //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
       //or if you want to change it's position also, then:
      // navigationController.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-240, [[UIScreen mainScreen] bounds].size.height/2-180, 560, 320);
       [self.navigationController presentModalViewController:navigationController animated:YES];
       navigationController.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2+10, [[UIScreen mainScreen] bounds].size.height/2-390, 320, 560);
   }
   else{
       [DejalBezelActivityView activityViewForView:self.mainView.view withLabel:@"数据加载中"];
       NSString * str=[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
       if (![str isEqualToString:@""]) {
           self.searchBar.text = [[self.cates objectAtIndex:indexPath.row] objectForKey:@"name"];
       }
       //[[self.cates objectAtIndex:indexPath.row] objectForKey:@"code"]
       _keycode = [[self.cates objectAtIndex:indexPath.row] objectForKey:@"code"];
       _keyword = [[self.cates objectAtIndex:indexPath.row] objectForKey:@"name"];
       [self doRoundSearch:self.curEnvelope keyWord:_keyword condition:_keycode];
       
   }
       
    
    if (self.searchBar.resignFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

@end
