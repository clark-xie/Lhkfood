//
//  CustemCalloutViewViewController.m
//  MapViewDemo
//
//  Created by leadmap on 12/3/12.
//
//

#import "CustemCalloutViewViewController.h"
#import "ViewController.h"

@interface CustemCalloutViewViewController ()

@end

@implementation CustemCalloutViewViewController
@synthesize stitle=_stitle;
@synthesize sdetail = _sdetail;
@synthesize mainController;
@synthesize dataSet;
@synthesize multiPoint=_multiPoint;
@synthesize curGraphic=_curGraphic;
@synthesize leftBtn,rightBtn;
@synthesize favorite=_favorite,favoriteDb=_favoriteDb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.userInteractionEnabled = YES;
        self.view.alpha = .9;
        self.favoriteDb = [[SFavoriteDB alloc] init];
        self.favorite = [SFavorite new];
        //self.stitle.frame = CGRectMake(15, 5, 250, 44);
        self.stitle.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:12];
        self.stitle.textColor = [UIColor blackColor];
        self.sdetail.frame = CGRectMake(15, 5, 250, 44);
    }
    return self;
}
-(void)putGraphic:(AGSGraphic*)graphic
{
    self.curGraphic = graphic;
    if (self.curGraphic.allAttributes!=nil) {
//        self.stitle.text = [self.curGraphic.allAttributes objectForKey:@"name"];
        self.stitle.text = @"testabc";
        self.sdetail.text = @"abcddef";
        self.sdetail.text = [self.curGraphic.allAttributes objectForKey:@"addr"];
        self.leftBtn.enabled = YES;
        self.rightBtn.enabled = YES;
        
        self.favorite.Name = [self.curGraphic.allAttributes objectForKey:@"name"];
        self.favorite.Address = [self.curGraphic.allAttributes objectForKey:@"addr"];
        
         AGSPoint *point = (AGSPoint*)self.curGraphic.geometry;
        //NSString *location = [self.curGraphic.allAttributes objectForKey:@"location"];
        //NSArray * array = [location componentsSeparatedByString: @","];
        
        self.favorite.x = [NSString stringWithFormat:@"%f",point.x];
        self.favorite.y = [NSString stringWithFormat:@"%f",point.y];
        [self.leftBtn setImage: [UIImage imageNamed:@"zhoubia.png"] forState:UIControlStateNormal];
        if([self.favoriteDb getFavorite:self.favorite]==nil)
        {
            //[self.favoriteDb deleteFavorite:[self.favoriteDb getFavorite:self.favorite]];
            [self.rightBtn setImage: [UIImage imageNamed:@"star_empty.png"] forState:UIControlStateNormal];
            [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(10.0, 0, 0, 0)];
            [self.rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
        }
        else
        {
            [self.rightBtn setImage: [UIImage imageNamed:@"star_full.png"] forState:UIControlStateNormal];
            [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(10.0, 0, 0, 0)];
            [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
            //[self.favoriteDb saveFavorite:self.favorite];
        }
    }
    else
    {
        [self.rightBtn setImage: [UIImage imageNamed:@"star_empty.png"] forState:UIControlStateNormal];
        [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(10.0, 0, 0, 0)];
        [self.rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
        self.stitle.text =@"我的位置";
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = NO;
    }
    
    
}
- (void)putDataSet:(NSArray *)featureSet
{
    self.dataSet = featureSet;
    self.multiPoint = [[AGSMutableMultipoint alloc] initWithSpatialReference:self.mainController.mapView.spatialReference];
    NSDictionary *feature = nil;
    AGSSimpleMarkerSymbol *symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"poiresult.png"]];
    if (self.dataSet.count>0) {
        for (int i=0; i<self.dataSet.count; i++) {
            feature = [self.dataSet objectAtIndex:i];
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
            [self.multiPoint addPoint:point];
            if (i==0) {
                self.curGraphic = graphic;
            }
        }
        
        
        //[self.mainController.queryGraphicsLayer addGraphic:graphic];
        self.stitle.text = [self.curGraphic.allAttributes objectForKey:@"name"];
        self.sdetail.text = [self.curGraphic.allAttributes objectForKey:@"addr"];
        self.favorite.Name = [self.curGraphic.allAttributes objectForKey:@"name"];
        self.favorite.Address = [self.curGraphic.allAttributes objectForKey:@"addr"];
        
        // AGSPoint *point = (AGSPoint*)self.curGraphic.geometry;
        NSString *location = [self.curGraphic.allAttributes objectForKey:@"location"];
        NSArray * array = [location componentsSeparatedByString: @","];
        NSString *x = array[1];
        NSString *y = array[0];

        self.favorite.x = array[1];;
        self.favorite.y = array[0];
        
        if([self.favoriteDb getFavorite:self.favorite]==nil)
        {
            //[self.favoriteDb deleteFavorite:[self.favoriteDb getFavorite:self.favorite]];
            [self.rightBtn setImage: [UIImage imageNamed:@"star_empty.png"] forState:UIControlStateNormal];
            [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(60.0, 0, 0, 0)];
            [self.rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
        }
        else
        {
            [self.rightBtn setImage: [UIImage imageNamed:@"star_full.png"] forState:UIControlStateNormal];
            [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(60.0, 0, 0, 0)];
            [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
            //[self.favoriteDb saveFavorite:self.favorite];
        }
        self.leftBtn.enabled = YES;
        self.rightBtn.enabled = YES;
    }
    else{
        self.stitle.text = @"附近没有找到信息！";
        self.sdetail.text = @"";
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = NO;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    //[self.rightBtn setImage: [UIImage imageNamed:@"detail_favorite.png"] forState:UIControlStateNormal];
    [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(60.0, 0, 0, 0)];
    [self.rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.textColor = [UIColor blackColor];
    //[self.leftBtn setImage: [UIImage imageNamed:@"detail_favorite.png"] forState:UIControlStateNormal];
    [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(60.0, 0.0, 0, 0)];
    [self.leftBtn setTitle:@"周边" forState:UIControlStateNormal];
    self.leftBtn.titleLabel.textColor = [UIColor blackColor];
}

-(IBAction)doSearch:(id)sender
{
    if (self.curGraphic !=nil) {
        [self.mainController showRoundSearch:self.curGraphic];
    }

}
-(IBAction)doDetail:(id)sender
{
    if (self.curGraphic !=nil) {
        //[self.mainController showDetailInfo:self.curGraphic];
        if([self.favoriteDb getFavorite:self.favorite]!=nil)
        {
            [self.favoriteDb deleteFavorite:[self.favoriteDb getFavorite:self.favorite]];
            [self.rightBtn setImage: [UIImage imageNamed:@"star_empty.png"] forState:UIControlStateNormal];
            [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(60.0, 0, 0, 0)];
            [self.rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [self.mainController loadAllFavorite];
            //[self.mainController showFavoriteAllWays:YES];
        }
        else
        {
            [self.rightBtn setImage: [UIImage imageNamed:@"star_full.png"] forState:UIControlStateNormal];
            [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(60.0, 0, 0, 0)];
            [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.favoriteDb saveFavorite:self.favorite];
            [self.mainController loadAllFavorite];
            [self.mainController showFavoriteAllWays:NO];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
