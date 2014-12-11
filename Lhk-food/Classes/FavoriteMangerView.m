//
//  FavoriteMangerView.m
//  MapViewDemo
//
//  Created by huwei on 12/3/12.
//
//

#import "FavoriteMangerView.h"
#import "SFavoriteDB.h"
#import "SFavorite.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface FavoriteMangerView ()

@end

@implementation FavoriteMangerView
@synthesize favoriteDb=_favoriteDb;
@synthesize favoriteObjects=_favoriteObjects;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
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
    UIBarButtonItem* searchBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    UIBarButtonItem* listbtn = [[UIBarButtonItem alloc] initWithTitle:@"显示收藏" style:UIBarButtonItemStylePlain target:self action:@selector(editbtnClicked:)];
    [self.navigationItem setLeftBarButtonItem:searchBtn];
    [self.navigationItem setRightBarButtonItem:listbtn];
    
    self.favoriteDb = [[SFavoriteDB alloc] init];
    self.favoriteObjects = [self.favoriteDb getAllFavorite];
    
    self.mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    if ([self.mainController getFavoriteState]) {
        listbtn.title = @"关闭收藏";
    }
    else
    {
        listbtn.title = @"显示收藏";
    }
}
-(void)backBtnClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    //[self dismissOverViewControllerAnimated:YES];
}
-(void)editbtnClicked:(id)sender
{
    UIBarButtonItem *btn = (UIBarButtonItem *)sender;
    if ([self.mainController getFavoriteState]) {
        btn.title = @"关闭收藏";
        [self.mainController showFavoriteAllWays:NO];
    }
    else{
        btn.title = @"显示收藏";
        [self.mainController showFavoriteAllWays:YES];
    }
    [self dismissModalViewControllerAnimated:YES];
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
        SFavorite *favorite = [self.favoriteObjects objectAtIndex:indexPath.row];
        [self.favoriteDb deleteFavorite:favorite.uid];
        self.favoriteObjects = [self.favoriteDb getAllFavorite];
        [self.mainController loadAllFavorite];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.favoriteObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    SFavorite *favorite = nil;
    for (int i=0; i<self.favoriteObjects.count; i++) {
        if (indexPath.row==i) {
            favorite= [self.favoriteObjects objectAtIndex:i];
        }
    }
    
    cell.imageView.image = [UIImage imageNamed:@"star_full.png"];
    cell.textLabel.text = favorite.Name;
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
    SFavorite *favorite = [self.favoriteObjects objectAtIndex:indexPath.row];
    AGSPoint * point =[AGSPoint pointWithX:[(NSNumber*)favorite.x doubleValue]
                                         y:[(NSNumber*)favorite.y doubleValue]
                          spatialReference:self.mainController.mapView.spatialReference];
    [self.mainController zoomToPoint:point withLevel:12];
    [self.mainController showFavoriteAllWays:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
