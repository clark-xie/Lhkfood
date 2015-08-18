//
//  MapDownViewController.m
//  MapViewDemo
//
//  Created by leadmap on 1/21/13.
//
//

#import "MapDownViewController.h"
#import "ProvinceViewController.h"
#import "HttpRequest.h"
#import "ZipArchive.h"
#import "MapDownLoadManager.h"
@interface MapDownViewController ()

@end

@implementation MapDownViewController
@synthesize simpleController;
@synthesize favoriteDb=_favoriteDb;
@synthesize cityNames=_cityNames;
@synthesize curFile=_curFile,curPath=_curPath;
@synthesize tableview = _tableview;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    simpleController = [[ProvinceViewController alloc] initWithViewController:self];
    self.mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progressView.frame = CGRectMake(70, 20, 200, 10);
	progressView.progress = 0.0;
    NSUserDefaults	*userDefault = [NSUserDefaults standardUserDefaults];
    downLoadedCitys = [[NSMutableArray alloc] initWithArray:[userDefault arrayForKey:@"downloadCitys"]];
    
    [self initCitys];
    
}

-(void)initCitys
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Citys" withExtension:@"plist"];
    self.cityNames = [NSArray arrayWithContentsOfURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    /* if (section == 0) {
     return @"湖北省市数据";
     }
     else
     {
     return @"湖北全省数据";
     }*/
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        GCRetractableSectionController* sectionController = self.simpleController;
        return sectionController.numberOfRow;
    }
    else
    {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        GCRetractableSectionController* sectionController = self.simpleController;
        return [sectionController cellForRow:indexPath.row];
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //cell.imageView.image = [UIImage imageNamed:@"map_menu_localmap.png"];
        cell.textLabel.text = @"湖北省";
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"map_menu_localmap.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(5.0f, 5.0f, 20.0f, 20.0f);
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        btnView.backgroundColor = [UIColor whiteColor];
        [btnView addSubview:button];
        cell.accessoryView = btnView;
        //cell.detailTextLabel.text = @"300M";
        // Configure the cell...
        
        return cell;
    }
}
-(void)didTapButton:(UIButton *)sender
{
    NSDictionary *dict = [self.cityNames objectAtIndex:0];
    MapDownLoadManager *mapDownLoad = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).mapDownLoadManager;
    [mapDownLoad.mapDownManagerView putCityName:dict];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        GCRetractableSectionController* sectionController = self.simpleController;
        [sectionController didSelectCellAtRow:indexPath.row];
        UITableViewCell *cell=nil;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *spath = [paths objectAtIndex:0];
        //spath = [spath stringByAppendingFormat:@"/",nil];
        NSString *savePath = NULL;
        
        if (indexPath.row!=0) {
            cell = [sectionController contentCellForRow:indexPath.row-1];
            //NSString *title = cell.textLabel.text;
            NSDictionary *dict = [self.cityNames objectAtIndex:indexPath.row-1];
            savePath = [spath stringByAppendingFormat:@"/%@",[dict objectForKey:@"url"],nil];
            //if (![fileManager fileExistsAtPath:savePath])
            // {
            MapDownLoadManager *mapDownLoad = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).mapDownLoadManager;
            [mapDownLoad.mapDownManagerView putCityName:dict];
            //}
            
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


-(void)zipFile
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    if( [zip UnzipOpenFile:self.curFile] )
    {
        BOOL ret = [zip UnzipFileTo:self.curPath overWrite:YES];
        if( NO==ret )
        {
        }
        else
        {
            NSLog(@"解压成功!");
        }
        [zip UnzipCloseFile];
    }

}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

@end
