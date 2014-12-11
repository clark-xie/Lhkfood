//
//  BookMarksViewController.m
//  MapViewDemo
//
//  Created by huwei on 11/16/12.
//
//

#import "BookMarksViewController.h"
#import "MacroUtils.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "MarkNameView.h"

@interface BookMarksViewController ()
@property (nonatomic, retain) NSString * dbPath;
@end

@implementation BookMarksViewController
@synthesize dbPath;
@synthesize tableView = _tableView;
@synthesize tableHeaderView = _tableHeaderView;
@synthesize lblName=_lblName;
@synthesize curGraphic=_curGraphic;
@synthesize btnFavorite=_btnFavorite;
@synthesize favorite=_favorite,favoriteDb=_favoriteDb;
@synthesize  isFavorite;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isFavorite = NO;
        self.favoriteDb = [[SFavoriteDB alloc] init];
        self.favorite = [SFavorite new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self createTable];
    
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    [self.navigationItem setTitle: @"简介"];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.lblName.text = [self.curGraphic.allAttributes objectForKey:@"Name"];
    
    [self.btnFavorite setBackgroundImage:[UIImage imageNamed:@"star_empty.png"] forState:UIControlStateNormal];
    [self.btnFavorite setBackgroundImage:[UIImage imageNamed:@"star_full.png"] forState:UIControlStateSelected];
}

- (void)passValue:(NSString *)value
{
    self.lblName.text = value;
}

-(void)putGrapic:(AGSGraphic*)graphic
{
    self.curGraphic = graphic;
    self.favorite.Name = [self.curGraphic.allAttributes objectForKey:@"name"];
    self.favorite.Address = [self.curGraphic.allAttributes objectForKey:@"addr"];
    
   // AGSPoint *point = (AGSPoint*)self.curGraphic.geometry;
    self.favorite.x = [self.curGraphic.allAttributes objectForKey:@"x"];
    self.favorite.y = [self.curGraphic.allAttributes objectForKey:@"y"];

}
-(void)backButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)addBookMark:(id)sender
{
  
    if([self.favoriteDb getFavorite:self.favorite]!=nil)
    {
        [self.favoriteDb deleteFavorite:[self.favoriteDb getFavorite:self.favorite]]; 
    }
    else
    {
        MarkNameView *markNameView = [[MarkNameView alloc]initWithNibName:@"MarkNameView" bundle:nil];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:markNameView];

        markNameView.delegate = self;
        [markNameView putValue:self.lblName.text];
        [markNameView putGrapic:self.curGraphic];
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        
        nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
        //or if you want to change it's position also, then:
        nav.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-240, [[UIScreen mainScreen] bounds].size.height/2-180, 360, 320);
        [self.navigationController presentModalViewController:nav animated:YES];

    }
   
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger num=0;
    if (section ==0) {
        num=2;
    }
    else{
        num=1;
    }
    return num;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section ==0) {
        if (indexPath.row==0) {
            NSString *lbl = @"地址:";
            if ([self.curGraphic.allAttributes objectForKey:@"addr"]!=nil) {
                lbl  =[lbl stringByAppendingFormat:[self.curGraphic.allAttributes objectForKey:@"addr"]];
            }
            
            cell.textLabel.text =lbl;
        }
        else{
            cell.textLabel.text = @"电话:(暂无)";
        }
        
    }
    else{
        cell.textLabel.text = @"简介:(暂无)";
    }
    
    //cell.textLabel.font =  [UIFont fontWithName:@"Arial-BoldItalicMT" size:12];
    //cell.imageView.image = [UIImage imageNamed:[[self.cates objectAtIndex:indexPath.row] objectForKey:@"imageName"]];  
    return cell;
}
-(void)insertData
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"insert into bookmarks (name, address,x,y) values(?,?,?,?) ";
       
        BOOL res = [db executeUpdate:sql, self.lblName.text, @"boy",@"124.0000",@"48.0000"];
        if (!res) {
            debugLog(@"error to insert data");
        } else {
            debugLog(@"succ to insert data");
        }
        [db close];
    }

}

#pragma 创建数据库
- (void)createTable {
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"userdb.sqlite"];
    self.dbPath = path;
    
    debugMethod();
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE 'bookmarks' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30),'code' VARCHAR(30), 'x' VARCHAR(30),'y' VARCHAR(30))";;
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                debugLog(@"error when creating db table");
            } else {
                debugLog(@"succ to creating db table");
            }
            [db close];
        } else {
            debugLog(@"error when open db");
        }
    }
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
