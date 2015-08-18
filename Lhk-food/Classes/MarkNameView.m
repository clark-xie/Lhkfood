//
//  MarkNameView.m
//  MapViewDemo
//
//  Created by leadmap on 11/19/12.
//
//

#import "MarkNameView.h"
#import "BookMarksViewController.h"
#import "SFavorite.h"
#import "ViewController.h"

@interface MarkNameView ()

@end

@implementation MarkNameView
@synthesize tField=_tField;
@synthesize delegate;
@synthesize favoriteDb=_favoriteDb;
@synthesize curGraphic=_curGraphic;
@synthesize favorite=_favorite;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.favoriteDb = [[SFavoriteDB alloc] init];
        self.favorite = [SFavorite new];
    }
    return self;
}
-(void)putGrapic:(AGSGraphic*)graphic
{
    self.curGraphic = graphic;
    
    self.favorite.FavoriteName = self.tField.text;
    self.favorite.Name = [self.curGraphic.allAttributes objectForKey:@"Name"];
    self.favorite.Address = [self.curGraphic.allAttributes objectForKey:@"Address"];
    
    AGSPoint *point = (AGSPoint*)self.curGraphic.geometry;
    self.favorite.x = [NSString stringWithFormat:@"%f",point.x];
    self.favorite.y = [NSString stringWithFormat:@"%f",point.y];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked:)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    [self.navigationItem setRightBarButtonItem:rightbtn];
    [self.navigationItem setTitle: @"添加到收藏"];

    self.tField.delegate = self;
    
   
}



-(void)backButtonClicked:(id)sender
{
    BookMarksViewController *markView = [[BookMarksViewController alloc]initWithNibName:@"BookMarksViewController" bundle:nil];
    //[markView.btnFavorite setTitle:@"" forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)rightBtnClicked:(id)sender
{
    ViewController *mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;

    //[self.delegate passValue:self.tField.text];
    
    self.favorite.favoriteName = self.tField.text;
    [self.favoriteDb saveFavorite:self.favorite];//搜索历史入库
    //self.favorite.uid = [self.favoriteDb getFavorite:self.favorite];
    [self dismissModalViewControllerAnimated:YES];
    [mainController loadAllFavorite];
}
- (void)putValue:(NSString *)value{
    self.tField.text = value;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.tField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.delegate = nil;
}

@end
