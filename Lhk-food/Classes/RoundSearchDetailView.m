//
//  RoundSearchDetailView.m
//  MapViewDemo
//
//  Created by leadmap on 12/4/12.
//
//

#import "RoundSearchDetailView.h"
#import "AppDelegate.h"
#import "ResultViewCell.h"
#import "JSONKit.h"
#import "YHCPickerView.h"
#import "DejalActivityView.h"
#import "ASIHTTPRequest.h"

@interface RoundSearchDetailView ()

@end

@implementation RoundSearchDetailView
@synthesize tableView = _tableView;
@synthesize feature=_feature;
@synthesize featureSet = _featureSet;
//@synthesize delegate;
@synthesize curPage;
@synthesize tableViewCell;
@synthesize footerView  =_footerView;
@synthesize leftBtn = _leftBtn,rightBtn=_rightBtn,lblPage=_lblPage;
@synthesize lblCount = _lblCount,headerView = _headerView;
@synthesize dataSet;
@synthesize mainController;
@synthesize multiPoint=_multiPoint;
@synthesize noResultView=_noResultView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)putDataSet:(NSArray *)featureSet {
	self.dataSet = featureSet;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked:)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    [self.navigationItem setRightBarButtonItem:rightbtn];
    [self.navigationItem setTitle: @""];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView = self.footerView;
    //self.tableView.tableHeaderView = self.headerView;
    
    [self.leftBtn addTarget:self action:@selector(preBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    
    self.multiPoint = [[NSMutableArray alloc]init];
    //self.multiPoint = [[AGSMutableMultipoint alloc] initWithSpatialReference:mainController.mapView.spatialReference];
    [self loadCurPageGraphics];
}
-(void)backButtonClicked:(id)sender
{
    [self.mainController.roundGraphicsLayer removeAllGraphics];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)rightBtnClicked:(id)sender
{
    [self showGraphicInMap];
    if ([self.multiPoint count]>0) {
        [self.mainController zoomToMultiPoint:self.multiPoint withLevel:8];
    }
}


-(void)showGraphicInMap
{
    ViewController *backGroundView = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    backGroundView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    backGroundView.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [backGroundView putQuery:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:backGroundView];
    [self presentModalViewController:nav animated: YES];
}


-(void)preBtnClicked
{
    self.curPage = self.curPage -1;
    [self changeBtnState];
    
    [self loadCurPageGraphics];
    [self.tableView reloadData];
}
-(void)nextBtnClicked
{
    
    int m = fmod(self.dataSet.count, 10);
    int n = floor(self.dataSet.count/10);//取整
    if (m==0&&self.curPage==n) {
        self.curPage = self.curPage;
    }
    else
    {
        self.curPage = self.curPage+1;
    }
    [self changeBtnState];
    
    [self loadCurPageGraphics];
    [self.tableView reloadData];
}



-(void)changeBtnState
{
    int n = floor(self.dataSet.count/10);//取整
    int m = fmod(self.dataSet.count, 10);
    NSString *pageNum =@"第";

    pageNum = [pageNum stringByAppendingFormat:[NSString stringWithFormat:@"%d",self.curPage],nil];
    pageNum = [pageNum stringByAppendingFormat:@"页",nil];
    self.lblPage.text = pageNum;
}


#pragma mark - Table view data source
//one section in this table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getCurPageNum];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ResultViewCell *cell = (ResultViewCell*)[tableView dequeueReusableCellWithIdentifier:kResultViewCellId];
    if (cell == nil)
    {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [[NSBundle mainBundle] loadNibNamed:@"ResultCell" owner:self options:nil];
        cell = (ResultViewCell*)self.tableViewCell;
        cell.delegate = self;
        
        self.tableViewCell = nil;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_icon_enter_map.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(269.0f, 11.0f, 35.0f, 35.0f);
    [cell addSubview:button];
    
    if (self.dataSet.count>0) {
        NSDictionary *feature = nil;
        
        AGSSimpleMarkerSymbol *symbol = nil;
        if (indexPath.row ==0) {
            //[cell.imageView setImage:[UIImage imageNamed:@"icon_marka.png"]];
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marka.png"]];
            [cell putImageName:@"icon_marka.png"];
        }
        else if (indexPath.row ==1) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markb.png"]];
            [cell  putImageName:@"icon_markb.png"];
        }
        else if (indexPath.row ==2) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markc.png"]];
            [cell  putImageName:@"icon_markc.png"];
        }
        else if (indexPath.row ==3) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markd.png"]];
            [cell  putImageName:@"icon_markd.png"];
        }
        else if (indexPath.row ==4) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marke.png"]];
            [cell  putImageName:@"icon_marke.png"];
        }
        else if (indexPath.row ==5) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markf.png"]];
            [cell  putImageName:@"icon_markf.png"];
        }
        else if (indexPath.row ==6) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markg.png"]];
            [cell  putImageName:@"icon_markg.png"];
        }
        else if (indexPath.row ==7) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markh.png"]];
            [cell  putImageName:@"icon_markh.png"];
        }else if (indexPath.row ==8) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marki.png"]];
            [cell  putImageName:@"icon_marki.png"];
        }
        else if (indexPath.row ==9) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markj.png"]];
            [cell  putImageName:@"icon_markj.png"];
        }
        
        NSInteger m = 10*(self.curPage-1)+indexPath.row;
        feature = [self.dataSet objectAtIndex:m];
        
        cell.queryTitle.text = [feature  valueForKey:@"name"];
        cell.queryCode.text = [feature valueForKey:@"addr"];
    }
    //cell.queryTitle.text =  [UIFont fontWithName:@"Arial-BoldItalicMT" size:12];
	
    
    return cell;
}

- (void)didTapButton:(UIButton *)sender
{
    /*
     CGRect buttonRect = sender.frame;
     for (ResultViewCell *cell in [self.tableView visibleCells])
     {
     if (CGRectIntersectsRect(buttonRect, cell.frame))
     {
     //cell就是所要获得的
     int n=0;
     n = cell.tag;
     }
     }*/
    ResultViewCell *owningCell = (ResultViewCell*)[sender superview];
    NSIndexPath *pathToCell = [self.tableView indexPathForCell:owningCell];
    int n=0;
    n = pathToCell.row;

    [self.mainController zoomToPoint:[self.multiPoint objectAtIndex:n] withLevel:12];
    [self showGraphicInMap];
    //[self.mainController dismissViewControllerAnimated:YES completion:^{}];
}

-(NSInteger)getCurPageNum
{
    NSInteger num=0;
    if (self.dataSet ==nil&&self.dataSet.count ==0) {
		
        self.curPage =0;
        [self.leftBtn setHidden:YES];
        [self.rightBtn setHidden:YES];
        num=0;
	}
    else
    {
        int n = floor(self.dataSet.count/10);//取整
        int m = fmod(self.dataSet.count, 10);//求余
        if (n==0&&m>=0) {
            
            [self.leftBtn setHidden:YES];
            [self.rightBtn setHidden:YES];
            num = self.dataSet.count;
        }
        else if(n>0&&m==0)
        {
            if (self.curPage==1) {
                [self.leftBtn setHidden:YES];
                [self.rightBtn setHidden:NO];
            }
            else if (self.curPage>0&&self.curPage<n-1)
            {
                [self.leftBtn setHidden:NO];
                [self.rightBtn setHidden:NO];
            }
            else if(self.curPage==n)
            {
                [self.leftBtn setHidden:NO];
                [self.rightBtn setHidden:YES];
            }
            
            num = 10;
        }
        else if(n>0&&m>0)
        {
            if (self.curPage==1) {
                [self.leftBtn setHidden:YES];
                [self.rightBtn setHidden:NO];
                num = 10;
            }
            else if (self.curPage>0&&self.curPage<n+1)
            {
                [self.leftBtn setHidden:NO];
                [self.rightBtn setHidden:NO];
                num = 10;
            }
            else if(self.curPage==n+1)
            {
                [self.leftBtn setHidden:NO];
                [self.rightBtn setHidden:YES];
                num = m;
            }
        }
    }
    return num;
}


-(void)loadCurPageGraphics
{
    AGSSimpleMarkerSymbol *symbol = nil;
    //[self.mainController.roundGraphicsLayer removeAllGraphics];
    [self.mainController clearAllGarphics];
    [self.multiPoint removeAllObjects];
    for (int i=0; i<[self getCurPageNum];i++) {
        if (i ==0) {
            //[cell.imageView setImage:[UIImage imageNamed:@"icon_marka.png"]];
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marka.png"]];
        }
        else if (i ==1) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markb.png"]];
        }
        else if (i ==2) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markc.png"]];
            
        }
        else if (i ==3) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markd.png"]];
        }
        else if (i ==4) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marke.png"]];
        }
        else if (i ==5) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markf.png"]];
        }
        else if (i ==6) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markg.png"]];
        }
        else if (i ==7) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markh.png"]];
        }else if (i ==8) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marki.png"]];
        }
        else if (i ==9) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markj.png"]];
        }
        NSDictionary *feature = nil;
        NSInteger m = 10*(self.curPage-1)+i;
        feature = [self.dataSet objectAtIndex:m];
        NSString *location = [feature objectForKey:@"location"];
        NSArray * array = [location componentsSeparatedByString: @","];
        NSString *x = array[1];
        NSString *y = array[0];
        AGSPoint * point =[AGSPoint pointWithX:[x doubleValue]
                                             y:[y doubleValue]
                              spatialReference:self.mainController.mapView.spatialReference];
        AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:point
                                                      symbol:symbol
                                                  attributes:[feature mutableCopy]
                                        infoTemplateDelegate:mainController];
        [self.mainController.roundGraphicsLayer addGraphic:graphic];
        [self.multiPoint addObject:point];
    }
    
    [self.mainController.roundGraphicsLayer refresh];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     ; *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    /*AGSGraphic *feature = [self.featureSet.features objectAtIndex:indexPath.row];
     MapViewDemoViewController *mainController = ((MapViewDemoAppDelegate*)[[UIApplication sharedApplication] delegate]).mainViewController;
     [mainController dismissViewControllerAnimated:YES completion:^{
     
     }];
     [mainController showAllGraphic:self.featureSet];
     [mainController zoomToPoint:feature withLevel:6];*/
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (void)viewDidAppear:(BOOL)animated
{
    if (self.dataSet ==nil&&self.dataSet.count ==0) {
        self.tableView.hidden=YES;
        self.noResultView.hidden = NO;
    }
    else
    {
        self.tableView.hidden=NO;
        self.noResultView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
