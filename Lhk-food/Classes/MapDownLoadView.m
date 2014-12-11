//
//  MapDownLoadView.m
//  MapViewDemo
//
//  Created by huwei on 12/13/12.
//
//

#import "MapDownLoadView.h"
#import "HttpRequest.h"
#import "ZipArchive.h"

@interface MapDownLoadView ()

@end

@implementation MapDownLoadView
@synthesize favoriteDb=_favoriteDb;
@synthesize cityNames=_cityNames;
@synthesize tableview=_tableview;
@synthesize progressView;
@synthesize curFile=_curFile,curPath=_curPath;

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
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* searchBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    [self.navigationItem setLeftBarButtonItem:searchBtn];
    
    self.mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progressView.frame = CGRectMake(100, 20, 200, 10);
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

-(void)backBtnClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.cityNames.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return @"湖北省";
    }
    else
    {
        return @"已下载";
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSDictionary *dict = [self.cityNames objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"download.png"];
    cell.textLabel.text = [dict objectForKey:@"name"];
    // Configure the cell...
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell   *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.tableview.userInteractionEnabled = NO;
    NSDictionary  *dict =[self.cityNames objectAtIndex:indexPath.row];
	downloadCityName = [NSString stringWithString:[dict objectForKey:@"name"]];
	downloadCityCode = [NSString stringWithString:[dict objectForKey:@"code"]];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *spath = [paths objectAtIndex:0];
    
   // spath = [spath stringByAppendingFormat:@"/",nil];
    if (![fileManager fileExistsAtPath:spath])
    {
        [fileManager createDirectoryAtPath:spath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *shipath = [spath stringByAppendingFormat:@"/%@",downloadCityName,nil];

    if (![fileManager fileExistsAtPath:shipath])
    {
        [fileManager createDirectoryAtPath:shipath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
	NSString *tempPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[dict objectForKey:@"url"]];
	self.curPath = shipath;
	
	progressView.hidden = NO;
	progressView.progress = 0.0;
	[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:progressView];
    
    
     NSString *savePath = [spath stringByAppendingFormat:@"/%@.zip",downloadCityName,nil];
    self.curFile = savePath;
	[[HttpRequest sharedRequest] sendDownloadDatabaseRequest:[dict objectForKey:@"url"] desPath:tempPath shiPath:savePath];
}


-(void)zipFile
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString* l_zipfile = [documentpath stringByAppendingString:@"/test.zip"] ;
    NSString* unzipto = [documentpath stringByAppendingString:@"/test"] ;
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
	[[HttpRequest sharedRequest] setRequestDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[HttpRequest sharedRequest] setRequestDelegate:nil];
}

// 开始发送请求,通知外部程序
- (void)connectionStart:(HttpRequest *)request
{
	NSLog(@"开始发送请求,通知外部程序");
}

// 连接错误,通知外部程序
- (void)connectionFailed:(HttpRequest *)request error:(NSError *)error
{
	NSLog(@"连接错误,通知外部程序");
	
	self.tableview.userInteractionEnabled = YES;
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:@"连接错误"
												   delegate:self
										  cancelButtonTitle:@"确定"
										  otherButtonTitles:nil];
	[alert show];
}

// 开始下载，通知外部程序
- (void)connectionDownloadStart:(HttpRequest *)request
{
	NSLog(@"开始下载，通知外部程序");
}

// 下载结束，通知外部程序
- (void)connectionDownloadFinished:(HttpRequest *)request
{
	NSLog(@"下载结束，通知外部程序");
	
	self.progressView.hidden = YES;
	self.tableview.userInteractionEnabled = YES;
	NSUserDefaults	*userDefault = [NSUserDefaults standardUserDefaults];
    [self zipFile];
	/*BOOL	isNotAlready = YES;
	
	for(NSDictionary *dict in self.cityNames){
		if ([[dict objectForKey:@"name"] isEqualToString:downloadCityName]) {
			isNotAlready = NO;
		}
	}
	
	if (isNotAlready) {
		[downLoadedCitys addObject:downloadCityName];
		[userDefault setObject:downLoadedCitys forKey:@"downloadCitys"];
		[userDefault synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"下载完成"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        //
	}*/

	
    
}

// 更新下载进度，通知外部程序
- (void)connectionDownloadUpdateProcess:(HttpRequest *)request process:(CGFloat)process
{
	NSLog(@"Process = %f", process);
	progressView.progress = process;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
