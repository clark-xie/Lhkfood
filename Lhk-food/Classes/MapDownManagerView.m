//
//  MapDownManagerView.m
//  MapViewDemo
//
//  Created by leadmap on 1/21/13.
//
//

#import "MapDownManagerView.h"
#import "HttpRequest.h"
#import "ZipArchive.h"
#import "CMActionSheet.h"
//#define BaseURL	@"http://27.17.60.3:8080/Mobile_Tiled_Zip/"
#define BaseURL	@"http://59.175.169.211:7003/offlinemap/"
@interface MapDownManagerView ()

@end

@implementation MapDownManagerView
@synthesize dataset=_dataset;
@synthesize cityNames=_cityNames;
@synthesize favoriteDb=_favoriteDb;
@synthesize progressView;
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

-(void)putCityName:(NSDictionary*)dict
{
    BOOL isadd= YES;
    for (int i=0;i< downLoadingCitys.count; i++) {
        if ([[dict objectForKey:@"name"] isEqualToString:[[downLoadingCitys objectAtIndex:i] objectForKey:@"name"]])  {
            isadd = NO;
        }
    }
    if (isadd) {
        [downLoadingCitys addObject: dict];
        [self.tableview reloadData];
    }
}

-(void)refreshTable
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *spath = [paths objectAtIndex:0];
    
   // spath = [spath stringByAppendingFormat:@"/",nil];
    NSString *savePath = NULL;
    [downLoadedCitys removeAllObjects];
    for (int i=0; i<self.cityNames.count; i++) {
        NSDictionary *dict = [self.cityNames objectAtIndex:i];
        downloadCityName = [dict objectForKey:@"name"];
        savePath = [spath stringByAppendingFormat:@"/%@",[dict objectForKey:@"url"],nil];
        if ([fileManager fileExistsAtPath:savePath])
        {
            [downLoadedCitys addObject:dict];
        }
    }

    [self.tableview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progressView.frame = CGRectMake(80, 18, 180, 10);
	progressView.progress = 0.0;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *spath = [paths objectAtIndex:0];
    
   // spath = [spath stringByAppendingFormat:@"/",nil];
    NSString *savePath = NULL;
    downLoadedCitys = [[NSMutableArray alloc] init];
    downLoadingCitys = [[NSMutableArray alloc] init];
    [self initCitys];
   /* for (int i=0; i<self.cityNames.count; i++) {
        NSDictionary *dict = [self.cityNames objectAtIndex:i];
        downloadCityName = [dict objectForKey:@"name"];
        savePath = [spath stringByAppendingFormat:@"/%@",[dict objectForKey:@"url"],nil];
        if ([fileManager fileExistsAtPath:savePath])
        {
            [downLoadedCitys addObject:dict];
        }
    }*/
    
    //创建队列
    queue = [[ASINetworkQueue alloc] init];
    //   [queue reset];//重置
    [queue setShowAccurateProgress:YES];//高精度进度
    [queue go];//启动
}
-(void)initCitys
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"hbcitys" withExtension:@"plist"];
    self.cityNames = [NSArray arrayWithContentsOfURL:url];
}

-(void)deleteDownLoadingNames:(NSDictionary*)dict
{
    for (NSDictionary *tdict in downLoadingCitys) {
        if ([[dict objectForKey:@"name"] isEqualToString:[tdict objectForKey:@"name"]])  {
            [downLoadingCitys removeObject: dict];
        }
    }
    BOOL isadd= YES;
    for (int i=0;i< downLoadedCitys.count; i++) {
        if ([[dict objectForKey:@"name"] isEqualToString:[[downLoadedCitys objectAtIndex:i] objectForKey:@"name"]])  {
            isadd = NO;
        }
    }
    if (isadd) {
        [downLoadedCitys addObject: dict];
    }
    
    [self.tableview reloadData];
}

-(void)deleteFilesFromName:(NSString*)filename
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *spath = [paths objectAtIndex:0];
    
   // spath = [spath stringByAppendingFormat:@"/",nil];
    spath = [spath stringByAppendingFormat:@"/%@",filename,nil];
    [fileManager removeItemAtPath:spath error:nil];
}
-(void)deleteZipsFromName:(NSString*)filename
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *spath = [paths objectAtIndex:0];
    
    //spath = [spath stringByAppendingFormat:@"/",nil];
    spath = [spath stringByAppendingFormat:@"/%@.zip",filename,nil];
    [fileManager removeItemAtPath:spath error:nil];
}

-(void)startDownLoad:(NSDictionary *)dict{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *spath = [paths objectAtIndex:0];
    
    //spath = [spath stringByAppendingFormat:@"/",nil];
    if (![fileManager fileExistsAtPath:spath])
    {
        [fileManager createDirectoryAtPath:spath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *tempPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[dict objectForKey:@"url"]];
    tempPath =  [tempPath stringByAppendingFormat:@".zip",nil];
    self.curPath = spath;
    NSString *savePath = [spath stringByAppendingFormat:@"/%@.zip",downloadCityName,nil];
    self.curFile = savePath;
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@", BaseURL, [dict objectForKey:@"url"]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *downloadURL = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:downloadURL];
    request.delegate = self;//代理
    [request setDownloadDestinationPath:savePath];//下载路径
    [request setTemporaryFileDownloadPath:tempPath];//缓存路径
    [request setAllowResumeForFileDownloads:YES];//断点续传
    request.downloadProgressDelegate = self;//下载进度代理
    //设置基本信息
    [request setUserInfo:dict];
    [queue addOperation:request];//添加到队列，队列启动后不需重新启动
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到头部！");
    NSLog(@"%f",request.contentLength/1024.0/1024.0);
    NSLog(@"%@",responseHeaders);
    //if (fileLength == 0) {
    //fileLength = request.contentLength/1024.0/1024.0;
    //totalPro.text = [NSString stringWithFormat:@"%.2fM",fileLength];
    //}
}

- (void)setProgress:(float)newProgress
{
    progressView.progress = newProgress;
    //currentPro.text = [NSString stringWithFormat:@"%.2fM",fileLength*newProgress];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"下载开始！");
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"下载成功！");
    NSDictionary *dict = request.userInfo;
    progressView.hidden=YES;
    [self deleteDownLoadingNames:dict];
    [self zipFile:dict];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败！");
   //NSDictionary *dict = request.userInfo;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
//点击删除按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog（＠"commitEditingStyle"）;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section ==0) {
            [downLoadingCitys removeObjectAtIndex:indexPath.row];
        }
        else
        {
            NSDictionary *dict = [downLoadedCitys objectAtIndex:indexPath.row];
            [self deleteFilesFromName:[dict objectForKey:@"url"]];
            [self deleteZipsFromName:[dict objectForKey:@"name"]];
            [downLoadedCitys removeObjectAtIndex:indexPath.row];
        }
        [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableview reloadData];
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//当 tableview 为 editing 时,左侧按钮的 style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return @"正在下载";
    }
    else
    {
        return @"已下载";
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return downLoadingCitys.count;
    }
    else
    {
        if (downLoadedCitys==nil&&downLoadedCitys==NULL) {
            return 0;
        }
        else
        {
            return downLoadedCitys.count;
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0) {
        self.tableview.userInteractionEnabled = YES;
        NSDictionary  *dict =[downLoadingCitys objectAtIndex:indexPath.row];
        downloadCityName = [dict objectForKey:@"name"];
        cell.textLabel.text =downloadCityName;
        progressView.hidden = NO;
        progressView.progress = 0.0;
        //[[self.tableview cellForRowAtIndexPath:indexPath].contentView addSubview:progressView];
        [cell.contentView addSubview:progressView];
        [self startDownLoad:dict];
        //downloadCityCode = [NSString stringWithString:[dict objectForKey:@"code"]];
        /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSFileManager *fileManager = [NSFileManager defaultManager];
         
         NSString *spath = [paths objectAtIndex:0];
         
         spath = [spath stringByAppendingFormat:@"/湖北省",nil];
         if (![fileManager fileExistsAtPath:spath])
         {
         [fileManager createDirectoryAtPath:spath withIntermediateDirectories:YES attributes:nil error:nil];
         }
         
         NSString *tempPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[dict objectForKey:@"url"]];
         tempPath =  [tempPath stringByAppendingFormat:@".zip",nil];
         self.curPath = spath;
         NSString *savePath = [spath stringByAppendingFormat:@"/%@.zip",downloadCityName,nil];
         self.curFile = savePath;
         
         progressView.hidden = NO;
         progressView.progress = 0.0;
         [[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:progressView];
         [[HttpRequest sharedRequest] sendDownloadDatabaseRequest:[dict objectForKey:@"url"] desPath:tempPath shiPath:savePath];*/
    }
    else
    {
        NSDictionary  *dict =[downLoadedCitys objectAtIndex:indexPath.row];
        cell.textLabel.text =[dict objectForKey:@"name"];
    }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    if (indexPath.section==0) {
        //[self showActionSheet];
    }
    else
    {
    }
    
}

- (void)showActionSheet {
    CMActionSheet *actionSheet = [[CMActionSheet alloc] init];
    //actionSheet.title = @"Test Action sheet";
    
    // Customize
    [actionSheet addButtonWithTitle:@"开始下载" type:CMActionSheetButtonTypeWhite block:^{
        NSLog(@"Dismiss action sheet with \"First Button\"");
    }];
    [actionSheet addButtonWithTitle:@"删除" type:CMActionSheetButtonTypeWhite block:^{
        NSLog(@"Dismiss action sheet with \"First Button\"");
    }];
    [actionSheet addSeparator];
    [actionSheet addButtonWithTitle:@"取消" type:CMActionSheetButtonTypeBlue block:^{
        NSLog(@"Dismiss action sheet with \"Close Button\"");
    }];
    
    // Present
    [actionSheet present];
}


-(void)zipFile:(NSDictionary*)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *spath = [paths objectAtIndex:0];
    
    spath = [spath stringByAppendingFormat:@"/",nil];
    if (![fileManager fileExistsAtPath:spath])
    {
        [fileManager createDirectoryAtPath:spath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //self.curPath = spath;
    NSString *savePath = [spath stringByAppendingFormat:@"/%@.zip",[dict objectForKey:@"name"],nil];
    //self.curFile = savePath;
    ZipArchive* zip = [[ZipArchive alloc] init];
    
    if( [zip UnzipOpenFile:savePath] )
    {
        BOOL ret = [zip UnzipFileTo:spath overWrite:YES];
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
