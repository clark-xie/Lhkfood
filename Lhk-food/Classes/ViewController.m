//
//  ViewController.m
//  DigitHuBei_IPhone
//
//  Created by leadmap on 7/8/13.
//  Copyright (c) 2013 leadmap. All rights reserved.
//

#import "ViewController.h"
#import "TianDiTuWMTSLayer.h"
//#import "RoundSearchView.h"
//#import "KeyWordSearchView.h"
//#import "BookMarksViewController.h"
//#import "KSearchDetailsView.h"
//#import "BackGroundView.h"
//#import "FavoriteMangerView.h"
//#import "LabelMangerView.h"
//#import "LabelNewView.h"
#import "PopoverView.h"
//#import "Commont.h"
//#import "CMPopTipView.h"
@interface ViewController ()

@property (nonatomic, strong) HYActivityView *activityView;


@end

@implementation ViewController
@synthesize mapView=_mapView;
@synthesize locationManager=locationManager;
@synthesize searchBar = _searchBar;
@synthesize graphicsLayer = _graphicsLayer;
//@synthesize queryTask = _queryTask, query = _query, featureSet = _featureSet;
@synthesize isQuery;
//@synthesize favoriteDb=_favoriteDb;
//@synthesize custemCallout=_custemCallout;
@synthesize curEnvelope = _curEnvelope;
//@synthesize request;
@synthesize currentPopTipViewTarget;
@synthesize visiblePopTipViews;
//@synthesize popTipView;
@synthesize toolbar=_toolbar;
@synthesize isAddLabel;
@synthesize btnView;
@synthesize measureView;
@synthesize labelLayer = _labelLayer;
@synthesize keyGraphicsLayer = _keyGraphicsLayer;
@synthesize roundGraphicsLayer = _roundGraphicsLayer;
@synthesize popViewController=_popViewController;
@synthesize btnSelect;
@synthesize results= _results;
@synthesize selectLength=_selectLength;
@synthesize count=_count;
@synthesize deja=_deja;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the client ID
    NSError *error;
    NSString* clientID = @"Zk6oCtlQy4hEmSwQ";
    [AGSRuntimeEnvironment setClientID:clientID error:&error];
    if(error){
        // We had a problem using our client ID
        NSLog(@"Error using client ID : %@",[error localizedDescription]);
    }
    
//    self.favoriteDb = [[SFavoriteDB alloc] init];
//    self.mapView.layerDelegate = self;
//    self.mapView.calloutDelegate = self;
//    self.mapView.touchDelegate = self;
//    self.searchBar.delegate = self;
    self.selectLength = @"当前可视范围";
//    [self.navigationController  setNavigationBarHidden:YES animated:NO];
    NSError* err;
	// Do any additional setup after loading the view, typically from a nib.
    TianDiTuLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_2000 LocalServiceURL:nil error:&err];
    TianDiTuLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_ANNOTATION_CHINESE_2000 LocalServiceURL:nil error:&err];
    TianDiTuimgLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_IMAGE_2000 LocalServiceURL:nil error:&err];
    TianDiTuimgLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_IMAGE_ANNOTATION_CHINESE_2000 LocalServiceURL:nil error:&err];
    if(TianDiTuLyr!=nil && TianDiTuLyr_Anno !=nil){
        [self.mapView addMapLayer:TianDiTuimgLyr withName:@"TianDiTuimg Layer"];
        [self.mapView addMapLayer:TianDiTuimgLyr_Anno withName:@"TianDiTuimg Annotation Layer"];
        [self.mapView addMapLayer:TianDiTuLyr withName:@"TianDiTu Layer"];
        [self.mapView addMapLayer:TianDiTuLyr_Anno withName:@"TianDiTu Annotation Layer"];
        TianDiTuLyr.visible = YES;
        TianDiTuLyr_Anno.visible = YES;
        TianDiTuimgLyr.visible = NO;
        TianDiTuimgLyr_Anno.visible = NO;
	}else{
		//layer encountered an error
		NSLog(@"Error encountered: %@", err);
	}

    //增加标绘图层
    self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
    
    self.keyGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.keyGraphicsLayer withName:@"kGraphics Layer"];
    
    self.roundGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.roundGraphicsLayer withName:@"rGraphics Layer"];
    
    self.favoriteLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.favoriteLayer withName:@"fGraphics Layer"];
    
    self.labelLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.labelLayer withName:@"lGraphics Layer"];
    self.simpleMarkerSymbol =
    [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"poiresult.png"]];
    
    UINavigationController *nav = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController;
    [nav setNavigationBarHidden:YES animated:YES];
    //[self.navigationController  setToolbarHidden:NO animated:YES];
    
    
//	self.custemCallout = [[CustemCalloutViewViewController alloc] initWithNibName:@"CustemCalloutViewViewController" bundle:nil];
//    self.visiblePopTipViews = [NSMutableArray array];
//    
//    
//    self.isAddLabel= NO;
//    
//    _mTools = [[MesureTools alloc] initWithMesureTool:self.mapView graphicsLayer:self.graphicsLayer];
//	_mTools.delegate = self;
    [self loadAllFavorite];
    [self loadAllLabels];
    [self showLabelPoints:NO];
    [self initToolbar];
    
    
    [self loadCurPageGraphics];
    
    //初始化范围
    CGPoint pt1,pt2;
    pt1.x =43.63;
    pt1.y =3.35;
    pt2.x =175.083;
    pt2.y =48.55;
    //pt1 = [Commont lonLat2Mercator:pt1];
    //pt2 = [Commont lonLat2Mercator:pt2];
    AGSMutableEnvelope *newEnv =
    [AGSMutableEnvelope envelopeWithXmin:pt1.x
                                    ymin:pt1.y
                                    xmax:pt2.x
                                    ymax:pt2.y
                        spatialReference:self.mapView.spatialReference];
    
    [self.mapView zoomToEnvelope:newEnv animated:YES];
    _bLocate = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
}
-(void)putQuery:(BOOL)isquery
{
    self.isQuery = isquery;
}
-(void)clearAllGarphics
{
    //[self.graphicsLayer removeAllGraphics];
    [self.roundGraphicsLayer removeAllGraphics];
    [self.keyGraphicsLayer removeAllGraphics];
    //[self.graphicsLayer refresh];
    [self.roundGraphicsLayer refresh];
    [self.keyGraphicsLayer refresh];
//    [_mTools clear];
    [self.measureView setHidden:YES];
    self.toolbar.hidden = YES;
    self.mapView.touchDelegate = self;
    self.measureRsult.text=@"";
    [self.mapView.callout dismiss];
}
-(void) zoomToPoint:(AGSPoint *) mappoint withLevel:(int) level
{
    //[self.mapView centerAtPoint:mappoint animated:YES];
    
    AGSLOD* lod = [TianDiTuLyr.tileInfo.lods objectAtIndex:level];
    
    float zoomFactor = lod.resolution/self.mapView.resolution;
    
    AGSMutableEnvelope *newEnv =
    [AGSMutableEnvelope envelopeWithXmin:mappoint.x-0.0125
                                    ymin:mappoint.y-0.0125
                                    xmax:mappoint.x+0.0125
                                    ymax:mappoint.y+0.0125
                        spatialReference:self.mapView.spatialReference];
    
    //[newEnv expandByFactor:zoomFactor];
    [self.mapView zoomToEnvelope:newEnv animated:YES];
}

//放大到所有点的位置
-(void) zoomToMultiPoint:(NSArray *) mappoints withLevel:(int) level
{
    AGSPoint *point = [mappoints objectAtIndex:0];
    [self.mapView centerAtPoint:point animated:YES];
    AGSLOD* lod = [TianDiTuLyr.tileInfo.lods objectAtIndex:level];
    float zoomFactor = lod.resolution/self.mapView.resolution;
    AGSMutableEnvelope *newEnv =
    [AGSMutableEnvelope envelopeWithXmin:self.mapView.maxEnvelope.xmin
                                    ymin:self.mapView.maxEnvelope.ymin
                                    xmax:self.mapView.maxEnvelope.xmax
                                    ymax:self.mapView.maxEnvelope.ymax
                        spatialReference:self.mapView.spatialReference];
    
    [newEnv expandByFactor:zoomFactor];
    [self.mapView zoomToEnvelope:newEnv animated:YES];
}

-(void)enableLabel
{
    self.isAddLabel = YES;
}
-(IBAction)showKSearch:(id)sender
{
    [self.measureView setHidden:YES];
    self.toolbar.hidden = YES;
    [self showFavoriteAllWays:NO];
    [self showLabelPoints:NO];
    [self showKeyWordSearch];
}
//初始化工具栏
-(void)initToolbar{
    
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(enableLabel)];
    UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showLabels)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:one];
    [items addObject:flexItem];
    [items addObject:two];
    [self.toolbar setItems:items];
    [self.toolbar setHidden:YES];
    //[self setToolbarItems:[NSArray arrayWithObjects:one, flexItem, two, flexItem, three, flexItem, four, nil]];
}
//-(IBAction)showMore:(id)sender
//{
//   
//    [self.measureView setHidden:YES];
//    [_mTools clear];
//    self.toolbar.hidden = YES;
//    [self showFavoriteAllWays:NO];
//    [self showLabelPoints:NO];
//    [self dismissAllPopTipViews];
//    if (sender == currentPopTipViewTarget) {
//		// Dismiss the popTipView and that is all
//		self.currentPopTipViewTarget = nil;
//	}
//    else
//    {
//        UIView *popview = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 260, 44)];
//        popview.backgroundColor = [UIColor whiteColor];
//        
//        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button1 setImage:[UIImage imageNamed:@"bus_map.png"] forState:UIControlStateNormal] ;
//        [button1 addTarget:self action:@selector(changeLayer) forControlEvents:UIControlEventTouchDown];
//        [button1 setFrame:CGRectMake(15, 5, 30, 30)];
//        [popview addSubview:button1];
//        
//        yLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 25, 33, 21)];
//        yLabel.text = @"影像图";
//        yLabel.font = [UIFont boldSystemFontOfSize:10];
//        yLabel.adjustsFontSizeToFitWidth = YES;
//        yLabel.backgroundColor = [UIColor clearColor];
//        [popview addSubview:yLabel];
//        
//        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button2 setImage:[UIImage imageNamed:@"map_menu_localmap.png"] forState:UIControlStateNormal] ;
//        [button2 addTarget:self action:@selector(showMapDownLoad) forControlEvents:UIControlEventTouchDown];
//        [button2 setFrame:CGRectMake(65, 5, 30, 30)];
//        [popview addSubview:button2];
//        
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(63, 26, 33, 21)];
//        label2.text = @"离线地图";
//        label2.font = [UIFont boldSystemFontOfSize:12];
//        label2.adjustsFontSizeToFitWidth = YES;
//        label2.backgroundColor = [UIColor clearColor];
//        [popview addSubview:label2];
//        
//        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button3 setImage:[UIImage imageNamed:@"favor_mark.png"] forState:UIControlStateNormal] ;
//        [button3 addTarget:self action:@selector(showFavoriteManger) forControlEvents:UIControlEventTouchDown];
//        [button3 setFrame:CGRectMake(115, 5, 30, 30)];
//        [popview addSubview:button3];
//        
//        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(115, 25, 33, 21)];
//        label3.text = @"收藏夹";
//        label3.font = [UIFont boldSystemFontOfSize:10];
//        label3.adjustsFontSizeToFitWidth = YES;
//        label3.backgroundColor = [UIColor clearColor];
//        [popview addSubview:label3];
//        
//        UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button4 setImage:[UIImage imageNamed:@"maplayers.png"] forState:UIControlStateNormal] ;
//        [button4 addTarget:self action:@selector(showMeasure) forControlEvents:UIControlEventTouchDown];
//        [button4 setFrame:CGRectMake(165, 5, 30, 30)];
//        [popview addSubview:button4];
//        
//        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(170, 25, 33, 21)];
//        label4.text = @"测量";
//        label4.font = [UIFont boldSystemFontOfSize:10];
//        label4.adjustsFontSizeToFitWidth = YES;
//        label4.backgroundColor = [UIColor clearColor];
//        [popview addSubview:label4];
//        
//        UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button5 setImage:[UIImage imageNamed:@"poi_category_market.png"] forState:UIControlStateNormal] ;
//        [button5 addTarget:self action:@selector(clearAllGarphics) forControlEvents:UIControlEventTouchDown];
//        [button5 setFrame:CGRectMake(215, 5, 30, 30)];
//        [popview addSubview:button5];
//        
//        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(216, 25, 33, 21)];
//        label5.text = @"清空图区";
//        label5.font = [UIFont boldSystemFontOfSize:12];
//        label5.adjustsFontSizeToFitWidth = YES;
//        label5.backgroundColor = [UIColor clearColor];
//        [popview addSubview:label5];
//        
//        self.popTipView = [[CMPopTipView alloc] initWithCustomView:popview];
//        self.popTipView.delegate = self;
//        self.popTipView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
//        UIButton *button = (UIButton *)sender;
//        [popTipView presentPointingAtView:button inView:self.view animated:YES];
//        [self.visiblePopTipViews addObject:self.popTipView];
//        self.currentPopTipViewTarget = sender;
//    }
//
//}


-(void)showMapDownLoad
{
    MapDownLoadManager *mapDownLoad = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).mapDownLoadManager;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:mapDownLoad];
    
    navigation.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigation.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentModalViewController: navigation animated:NO];
    //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
    //or if you want to change it's position also, then:
    navigation.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-260, [[UIScreen mainScreen] bounds].size.height/2-200, 560, 320);

}


-(void)showLabels
{
    /*
    [_mTools clear];
    LabelMangerView *labelManger = [[LabelMangerView alloc]initWithNibName:@"LabelMangerView" bundle:nil];
    labelManger.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    labelManger.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:labelManger];
    
    navigation.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navigation.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentModalViewController: navigation animated:NO];
    //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
    //or if you want to change it's position also, then:
    navigation.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-240, [[UIScreen mainScreen] bounds].size.height/2-180, 560, 320);
    
     */
}
-(void)showFavoriteManger{
//    [_mTools clear];
//    FavoriteMangerView *favoriteView = [[FavoriteMangerView alloc]initWithNibName:@"FavoriteMangerView" bundle:nil];
//    favoriteView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    favoriteView.modalPresentationStyle = UIModalPresentationCurrentContext;
//    
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:favoriteView];
    
//    navigation.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    navigation.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentModalViewController: navigation animated:NO];
//    //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
//    //or if you want to change it's position also, then:
//    navigation.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-260, [[UIScreen mainScreen] bounds].size.height/2-200, 560, 320);

}

- (IBAction)zoomin:(id)sender {
    [self.mapView zoomIn:YES];
}

- (IBAction)zoomout:(id)sender {
    [self.mapView zoomOut:YES];
}
-(void)showDetailInfo:(AGSGraphic*)graphic{
//    BookMarksViewController *bookmarksView = [[BookMarksViewController alloc]initWithNibName:@"BookMarksViewController" bundle:nil];
//    
//    [bookmarksView putGrapic:graphic];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:bookmarksView];
//    
//    navigation.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    navigation.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentModalViewController: navigation animated:NO];
//    
//    navigation.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-240, [[UIScreen mainScreen] bounds].size.height/2-180, 360, 320);
//    [navigation.navigationItem setHidesBackButton:NO animated:NO];
    
}

-(void)showKeyWordSearch{
//    [_mTools clear];
//    //if (!self.searchBar.becomeFirstResponder) {
//    //    [self.searchBar resignFirstResponder];
//    //}
//    if (dropDown!=nil) {
//        [dropDown hideDropDown:self.btnSelect];
//        [self rel];
//    }
//    KeyWordSearchView *keySearchView = [[KeyWordSearchView alloc]initWithNibName:@"KeyWordSearchView" bundle:nil];
//    // keySearchView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    //keySearchView.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [keySearchView putEnvelope:self.mapView.visibleAreaEnvelope];
//    keySearchView.view.frame = CGRectMake(0, 0, 460, 360);
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:keySearchView];
//    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    nav.modalPresentationStyle = UIModalPresentationFormSheet;
//   // [self.navigationController presentModalViewController: nav animated:NO];
//    //[self presentModalViewController:nav animated:NO];
//    nav.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2+400, 480, 360);
//    [self presentViewController:nav animated:YES completion:^{}];
//    //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
//    //or if you want to change it's position also, then:
//    

    //nav.view.superview.frame = CGRectMake(200, 200, 320, 260);
    
}
//周边查询
-(void)showRoundSearch{
    //[self enableLocation];
//    [_mTools clear];
//    if (dropDown!=nil) {
//        [dropDown hideDropDown:self.btnSelect];
//        [self rel];
//    }
//     AGSSimpleMarkerSymbol *symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"poiresult.png"]];
//    RoundSearchView *roundSearchView = [[RoundSearchView alloc]initWithNibName:@"RoundSearchView" bundle:nil];
//    //roundSearchView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    //roundSearchView.modalPresentationStyle = UIModalPresentationCurrentContext;
//    AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:[self.mapView.visibleArea.envelope center]
//                                                  symbol:nil
//                                              attributes:nil
//                                    infoTemplateDelegate:nil];
//    [roundSearchView putGraphic:nil];
//    [roundSearchView putEnvelope:self.mapView.visibleAreaEnvelope];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:roundSearchView];
//    
//    navigation.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    navigation.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentModalViewController: navigation animated:NO];
//    //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
//    //or if you want to change it's position also, then:
//    navigation.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-260, [[UIScreen mainScreen] bounds].size.height/2-200, 560, 320);
}
//周边查询
-(void)showRoundSearch:(AGSGraphic*)graphic{
//    [_mTools clear];
//    if (dropDown!=nil) {
//        [dropDown hideDropDown:self.btnSelect];
//        [self rel];
//    }
//    RoundSearchView *roundSearchView = [[RoundSearchView alloc]initWithNibName:@"RoundSearchView" bundle:nil];
//    [roundSearchView putGraphic:graphic];
//    [roundSearchView putEnvelope:self.mapView.visibleArea.envelope];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:roundSearchView];
//    
//    navigation.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    navigation.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentModalViewController: navigation animated:NO];
//    //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
//    //or if you want to change it's position also, then:
//    navigation.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-240, [[UIScreen mainScreen] bounds].size.height/2-180, 560, 320);
}


-(void)showMeasure
{
    BOOL ishide = self.measureView.hidden;
    [self.measureView setHidden:!ishide];
    self.toolbar.hidden = YES;
//    [_mTools clear];
    
}

//地图切换
-(void)changeLayer{
    NSArray *arry=self.mapView.mapLayers;
    for (int i=0; i<[arry count]; i++) {
        AGSLayer *lyr=[arry objectAtIndex:i];
        if ([lyr.name isEqualToString:@"TianDiTu Layer"]||[lyr.name isEqualToString:@"TianDiTu Annotation Layer"]) {
            //[self.mapView removeMapLayerWithName:lyrView.name];
            BOOL ishid = lyr.visible;
            [lyr setVisible:!ishid];
            if (ishid) {
                if (ishid) {
                    yLabel.text=@"矢量图";
                }
                else{
                    yLabel.text=@"影像图";
                }
            }
        }
        else if([lyr.name isEqualToString:@"TianDiTuimg Layer"]||[lyr.name isEqualToString:@"TianDiTuimg Annotation Layer"]){
            BOOL ishid = lyr.visible;
            [lyr setVisible:!ishid];
            if (ishid) {
                yLabel.text=@"影像图";
            }
            else{
                yLabel.text=@"矢量图";
            }
        }
        else if([lyr.name isEqualToString:@"Graphics Layer"]){
            //self.graphicsLayer = [arry objectAtIndex:i];
            //[self.mapView removeMapLayerWithName:lyrView.name];
        }
    }
}


#pragma mark - searchbar委托方法
//关闭导航栏
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self showKeyWordSearch];
}

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    [self searchBarTextDidBeginEditing:self.searchBar];
//}
-(IBAction)showRSearch:(id)sender
{
    [self.measureView setHidden:YES];
    self.toolbar.hidden = YES;
    [self showFavoriteAllWays:NO];
    [self showLabelPoints:NO];
    [self showRoundSearch];
}

-(BOOL)getFavoriteState
{
    BOOL ishid;
    NSArray *dict=self.mapView.mapLayers;
    
    for (int i=0; i<[dict count]; i++) {
        AGSGraphicsLayer *lyrView=[dict objectAtIndex:i];
        if([lyrView.name isEqualToString:@"fGraphics Layer"]){
            ishid = lyrView.visible;
        }
    }
    return ishid;
}

-(void)showLabelPoints:(BOOL)ishide
{
    [self.measureView setHidden:YES];
    
    NSArray *dict=self.mapView.mapLayers;
    
    for (int i=0; i<[dict count]; i++) {
        AGSGraphicsLayer *lyrView=[dict objectAtIndex:i];
        if([lyrView.name isEqualToString:@"lGraphics Layer"]){
            BOOL ishid = lyrView.visible;
           [lyrView setVisible:ishide];
        }
    }
}
-(void)loadAllLabels
{
//    NSArray *labels = [self.favoriteDb getAllLabel];
//    AGSSimpleMarkerSymbol *symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"pins.png"]];
//    [self.labelLayer removeAllGraphics];
//    CGPoint pt;
//    for (int i=0; i<labels.count; i++) {
//        LabelObject *label =[labels objectAtIndex:i];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject: label.uid forKey: @"uid"];
//        [dict setObject: label.Name forKey: @"name"];
//        pt.x=[(NSNumber*)label.X doubleValue];
//        pt.y=[(NSNumber*)label.Y doubleValue];
//        //pt = [Commont lonLat2Mercator:pt];
//        AGSPoint * point =[AGSPoint pointWithX:pt.x
//                                             y:pt.y
//                              spatialReference:self.mapView.spatialReference];
//        AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:point
//                                                      symbol:symbol
//                                                  attributes:dict
//                                        infoTemplateDelegate:self];
//        [self.labelLayer addGraphic:graphic];
//    }
//    [self.labelLayer refresh];
//    //;
}
-(IBAction)showLabelManeger:(id)sender
{
    [self.measureView setHidden:YES];
    BOOL ishid = self.toolbar.hidden;
    self.toolbar.hidden = !ishid;
    if (self.toolbar.hidden ) {
        self.isAddLabel = NO;
        [self showLabelPoints:NO];
    }
    else
    {
        [self showLabelPoints:YES];
    }
}


-(IBAction)showLocation:(id)sender
{
    [self enableLocation];
}



-(void)showQueryResults:(NSArray*)results:(NSString*)key :(NSString*)keyword :(NSString*)keycode :(AGSPoint *)point :(int)count
{
//    [self.btnSelect setHidden:NO];
//    self.count = count;
//    if(dropDown == nil) {
//        isKorR=key;
//        dropDown = [[NIDropDown alloc] initDropDown:self.btnSelect :results :key :self.selectLength :count];
//        [dropDown putKeyCode:keycode];
//        [dropDown putKeyWord:keyword];
//        [dropDown putMapPont:point];
//        dropDown.count = count;
//        // [dropDown putSelect:self.selectLength];
//        dropDown.delegate = self;
//        
//    }
//    else {
//        if (![isKorR isEqualToString:key]) {
//            isKorR=key;
//            [dropDown hideDropDown:self.btnSelect];
//            [self rel];
//            dropDown = [[NIDropDown alloc] initDropDown:self.btnSelect :self.results :key :self.selectLength :count];
//            [dropDown putKeyCode:keycode];
//            [dropDown putKeyWord:keyword];
//            [dropDown putMapPont:point];
//
//            //[dropDown putSelect:self.selectLength];
//            dropDown.delegate = self;
//            
//        }
//        else
//        {
//            [dropDown hideDropDown:self.btnSelect];
//        }
    
//    }
}



//开启定位功能
- (void)enableLocation{
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        NSLog(@"定位功能已经打开");
        
         //[self.mapView.locationDisplay startDataSource];
         //self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
        
        CLLocation *location = self.locationManager.location;
        CGPoint mecPoint;
        mecPoint.y = location.coordinate.latitude;
        mecPoint.x= location.coordinate.longitude;
        //坐标转换
        //CGPoint mecPoint = [self lonLat2Mercator:pnt];
        _bLocate= YES;
        
        [self LocationMap:mecPoint];
//
//        
//        NSURL *url = [NSURL URLWithString:LocalURL(mecPoint.x,mecPoint.y)];
//        
////        NSLog(Location(mecPoint.x,mecPoint.y));
//        asiRequest = [ASIHTTPRequest requestWithURL:url];
//        [asiRequest setDelegate:self];
//        [asiRequest setDidFinishSelector:@selector(GetResult:)];
//        [asiRequest setDidFailSelector:@selector(GetErr:)];
//        [asiRequest startAsynchronous];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"GPRS定位功能未打开，请在设备的设置里面打开定位功能"
                                                       delegate:self
                                              cancelButtonTitle:@"了解"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"定位功能未打开");
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
    
    NSLog(@"%f",newLocation.coordinate.latitude);
    if(howRecent < -30) return ; //离上次更新的时间少于10秒
    CLLocation *location = self.locationManager.location;
    CGPoint mecPoint;
   // mecPoint.y = location.coordinate.latitude;
    //mecPoint.x= location.coordinate.longitude;
    mecPoint.y = newLocation.coordinate.latitude;
    mecPoint.x= newLocation.coordinate.longitude;
    //坐标转换
    //CGPoint mecPoint = [self lonLat2Mercator:pnt];
    
    [self LocationMap:mecPoint];
//    NSURL *url = [NSURL URLWithString:LocalURL(mecPoint.x,mecPoint.y)];
//    asiRequest = [ASIHTTPRequest requestWithURL:url];
//    [asiRequest setDelegate:self];
//    [asiRequest setDidFinishSelector:@selector(GetResult:)];
//    [asiRequest setDidFailSelector:@selector(GetErr:)];
//    [asiRequest startAsynchronous];

    
    
    
    //NSLog(@"location ok");
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    //
    if ([error code] != kCLErrorLocationUnknown) {
        NSLog(@"%@",@"有错误产生");
//        [self stopUpdatingLocationWithMessage:NSLocalizedString(@"Error", @"Error")];
    }
}


#pragma mark - Your actions


-(void) GetErr:(ASIHTTPRequest *)request
{
    NSLog(@"请求出错");
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
   // NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (data!=nil) {
        NSDictionary *resultsDictionary = [data objectFromJSONData];
        CGPoint mecPoint;
        mecPoint.x = [[resultsDictionary objectForKey:@"x"] floatValue] ;
        mecPoint.y = [[resultsDictionary objectForKey:@"y"] floatValue] ;
        //mecPoint = [Commont lonLat2Mercator:mecPoint];//转投影
        //NSLog(@"经度:%f   纬度:%f",mecPoint.x,mecPoint.y);
        
        [self LocationMap:mecPoint];
        
//        AGSPoint *mappoint =[[AGSPoint alloc] initWithX:mecPoint.x y:mecPoint.y spatialReference:self.mapView.spatialReference];
//        if(_bLocate){
//            double size =0.0125;
//            AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:mappoint.x - size
//                                                             ymin:mappoint.y - size
//                                                             xmax:mappoint.x + size
//                                                             ymax:mappoint.y + size
//                                                 spatialReference:self.mapView.spatialReference];
//            [self.mapView zoomToEnvelope:envelope animated:YES];
//        }
//        
//        
//        //newPoint = (AGSPoint*)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:newPoint toSpatialReference:self.mapView.spatialReference];
//        [ self.graphicsLayer removeAllGraphics];
//        
//        // Create a marker symbol using the Location.png graphic
//        AGSPictureMarkerSymbol *markerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"location.png"];
//        
//        // Create a new graphic using the location and marker symbol
//        AGSGraphic* graphic = [AGSGraphic graphicWithGeometry:mappoint symbol:markerSymbol attributes:nil];
//        
//        // Add the graphic to the graphics layer
//        [ self.graphicsLayer addGraphic:graphic];
//        [ self.graphicsLayer refresh];
//        _bLocate= NO;
    }
    else{
        
    }
    
}

-(void) LocationMap:(CGPoint ) point
{

    //mecPoint = [Commont lonLat2Mercator:mecPoint];//转投影
    //NSLog(@"经度:%f   纬度:%f",mecPoint.x,mecPoint.y);
    AGSPoint *mappoint =[[AGSPoint alloc] initWithX:point.x y:point.y spatialReference:self.mapView.spatialReference];
    if(_bLocate){
        double size =0.0125;
        AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:mappoint.x - size
                                                         ymin:mappoint.y - size
                                                         xmax:mappoint.x + size
                                                         ymax:mappoint.y + size
                                             spatialReference:self.mapView.spatialReference];
        [self.mapView zoomToEnvelope:envelope animated:YES];
    }
    
    
    //newPoint = (AGSPoint*)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:newPoint toSpatialReference:self.mapView.spatialReference];
    [ self.graphicsLayer removeAllGraphics];
    
    // Create a marker symbol using the Location.png graphic
    AGSPictureMarkerSymbol *markerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"location.png"];
    
    // Create a new graphic using the location and marker symbol
    AGSGraphic* graphic = [AGSGraphic graphicWithGeometry:mappoint symbol:markerSymbol attributes:nil];
    
    // Add the graphic to the graphics layer
    [ self.graphicsLayer addGraphic:graphic];
    [ self.graphicsLayer refresh];
    _bLocate= NO;
}


//初始化导航栏
-(void)initNavigationBar{
    
    if(!self.isQuery)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        //[self.navigationController  setToolbarHidden:NO animated:YES];
        [self.searchBar setHidden:NO];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(backBaseMap)];
        self.navigationItem.leftBarButtonItem = leftButton;
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        //self.btnLocation.frame = CGRectMake(4, 410, 45, 45);
        //self.btnMore.frame = CGRectMake(269, 410, 45, 45);
        //self.btnView.frame = CGRectMake(53, 410, 212, 45);
    }
    else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        //[self.navigationController  setToolbarHidden:NO animated:YES];
        [self.searchBar setHidden:YES];
        UIBarButtonItem* searchBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
        UIBarButtonItem* listbtn = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(listbtnClicked:)];
        [self.navigationItem setLeftBarButtonItem:searchBtn];
        [self.navigationItem setRightBarButtonItem:listbtn];

        //self.btnLocation.frame = CGRectMake(4, 365, 45, 45);
        //self.btnMore.frame = CGRectMake(269, 365, 45, 45);
        //self.btnView.frame = CGRectMake(53, 365, 212, 45);
    }
    [self.navigationController  setToolbarHidden:YES animated:NO];
}
-(void)backBtnClicked:(id)sender
{
    ViewController *backGroundView = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
    backGroundView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    backGroundView.modalPresentationStyle = UIModalPresentationFormSheet;
    [backGroundView putQuery:NO];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:backGroundView];
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
    [backGroundView dismissViewControllerAnimated:YES completion:^{
    }];
    [self clearAllGarphics];
    
}
-(void)listbtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark measureDelegate methods

//- (void)LengthChanged:(MesureTools *)mTool length:(double )length
//{
//	self.measureRsult.text = [NSString stringWithFormat:@"当前距离为:%lf公里",length/1000];
//}
//- (void)AreaChanged:(MesureTools *)mTool area:(double )area
//{
//	self.measureRsult.text = [NSString stringWithFormat:@"当前面积为:%lf平方公里",area/1000000];
//}
//
//-(IBAction)meaesureLength:(id)sender
//{
//    [_mTools toolSelected:1];
//}
//-(IBAction)meaesureArea:(id)sender
//{
//    [_mTools toolSelected:2];
//}
//
//
//#pragma mark visible buttons methods
//
//-(IBAction)selectClicked:(id)sender
//{
//    
//    if(dropDown == nil) {
//        dropDown = [[NIDropDown alloc] initDropDown:sender  :self.results :isKorR :self.selectLength :self.count];
//        dropDown.delegate = self;
//    }
//    else {
//        if (dropDown.hidden) {
//            [dropDown showDropDown:sender];
//        }
//        else
//        {
//            [dropDown hideDropDown:sender];
//        }
//    }
//    
//}
//- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
//    [self rel];
//}
//
//-(void)rel{
//    dropDown = nil;
//}
//
//
//
//#pragma mark CMPopTipViewDelegate methods
//
//- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
//	[visiblePopTipViews removeObject:popTipView];
//	self.currentPopTipViewTarget = nil;
//}
//- (void)dismissAllPopTipViews {
//	while ([self.visiblePopTipViews count] > 0) {
//		CMPopTipView *popTipViews = [visiblePopTipViews objectAtIndex:0];
//		[self.visiblePopTipViews removeObjectAtIndex:0];
//		[popTipViews dismissAnimated:YES];
//	}
//}
//
//-(void)loadAllFavorite
//{
//    NSArray *favorites = [self.favoriteDb getAllFavorite];
//    AGSSimpleMarkerSymbol *symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"star_full.png"]];
//    [self.favoriteLayer removeAllGraphics];
//    CGPoint pt;
//    for (int i=0; i<favorites.count; i++) {
//        SFavorite *favorite =[favorites objectAtIndex:i];
//        pt.x=[(NSNumber*)favorite.x doubleValue];
//        pt.y=[(NSNumber*)favorite.y doubleValue];
//        //pt = [Commont lonLat2Mercator:pt];
//        AGSPoint * point =[AGSPoint pointWithX:pt.x
//                                             y:pt.y
//                              spatialReference:self.mapView.spatialReference];
//        AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:point
//                                                      symbol:symbol
//                                                  attributes:[self getAttributes:favorite]
//                                        infoTemplateDelegate:self];
//        [self.favoriteLayer addGraphic:graphic];
//    }
//    [self.favoriteLayer refresh];
//    [self showFavoriteAllWays:NO];
//}
//-(void)showFavoriteAllWays:(BOOL) ishide
//{
//    [self.measureView setHidden:YES];
//    self.toolbar.hidden = YES;
//    NSArray *dict=self.mapView.mapLayers;
//    
//    for (int i=0; i<[dict count]; i++) {
//        AGSGraphicsLayer *lyr=[dict objectAtIndex:i];
//        if([lyr.name isEqualToString:@"fGraphics Layer"]){
//            //BOOL ishid = lyrView.hidden;
//            [lyr setVisible:ishide] ;
//        }
//    }
//}
//
//-(NSMutableDictionary*)getAttributes:(SFavorite*)favorite
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    if (favorite.uid!=nil) {
//        [dict setObject: favorite.uid forKey: @"uid"];
//    }
//    if(favorite.FavoriteName!=nil) {
//        [dict setObject: favorite.FavoriteName forKey: @"FavoriteName"];
//    }
//    if(favorite.Address!=nil) {
//        [dict setObject: favorite.Address forKey: @"addr"];
//    }
//    if(favorite.Name!=nil) {
//        [dict setObject: favorite.Name forKey: @"name"];
//    }
//    if(favorite.x!=nil) {
//        [dict setObject: favorite.x forKey: @"x"];
//    }
//    if(favorite.y!=nil) {
//        [dict setObject: favorite.y forKey: @"y"];
//    }
//    
//    
//    return dict;
//}

//单机事件
- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    //[self dismissAllPopTipViews];
    if ([self.graphicsLayer.graphics count]>0) {
       // [self.graphicsLayer removeAllGraphics];
       // [self.graphicsLayer refresh];
    }
    
    if (self.isAddLabel) {
//        LabelNewView *labelNew = [[LabelNewView alloc]initWithNibName:@"LabelNewView" bundle:nil] ;
        //labelNew.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //labelNew.modalPresentationStyle = UIModalPresentationCurrentContext;
//        [labelNew putPoint:mappoint];
        
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:labelNew];
//        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        
        //nav.view.superview.bounds = CGRectMake(0, 0, 280, 320);
        //or if you want to change it's position also, then:
//        nav.view.superview.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-240, [[UIScreen mainScreen] bounds].size.height/2-180, 460, 320);
        //[self.navigationController presentModalViewController:nav  animated:YES];
//        [self.navigationController presentModalViewController: nav animated:NO];
        self.isAddLabel = NO;
    }

    
}

- (BOOL)mapView:(AGSMapView *)mapView shouldShowCalloutForGraphic:(AGSGraphic *)graphic {
    if (graphic.allAttributes!=nil) {
//        [self.custemCallout putGraphic:graphic];
//        self.mapView.callout.customView = self.custemCallout.view;
//       [self.mapView.callout showCalloutAtPoint:(AGSPoint*)graphic.geometry forGraphic:graphic animated:YES];
    }
    return YES;
}

- (void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
     NSLog(@"经度:%f   纬度:%f",mappoint.x,mappoint.y);
}
//设置图层可见
-(void)setLayerVisible:(NSString*) lyrname isVisible:(BOOL)ishidden
{
    NSArray *arry=self.mapView.mapLayers;
    
    for (int i=0; i<[arry count]; i++) {
        AGSLayer *lyrView=[arry objectAtIndex:i];
        if ([lyrView.name isEqualToString:lyrname]) {
            [lyrView setVisible:ishidden];
        }
        
    }
}
-(BOOL)getLayerVisible:(NSString*) lyrname
{
    BOOL ishid = NO;
     NSArray *arry=self.mapView.mapLayers;
    
    for (int i=0; i<[arry count]; i++) {
        AGSLayer *lyrView=[arry objectAtIndex:i];
        if ([lyrView.name isEqualToString:lyrname]) {
            ishid = lyrView.visible;
        }
        
    }
    return ishid;
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"autoPanMode"]) {
        NSLog(@"Location updated to %@", [self.mapView.locationDisplay mapLocation]);
    }
}



- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return  ( UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight );
}
///iOS6.0
- (BOOL)shouldAutorotate
{
    return YES;
}
#pragma mark AGSMapViewLayerDelegate methods

-(void) mapViewDidLoad:(AGSMapView*)mapView {
    
	// comment to disable the GPS on start up
	//[self.mapView.locationDisplay startDataSource];
    //self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
}
- (void)viewWillAppear:(BOOL)animated{
    
//    self.locationManager = [[CLLocationManager alloc] init];
//	self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//	self.locationManager.delegate = self;
//    [self.locationManager startUpdatingLocation];
}


//progam mark 以下是自己添加


//指定查询结果的位置
-(void)loadCurPageGraphics
{
    AGSSimpleMarkerSymbol *symbol = nil;
    //[self.mainController.keyGraphicsLayer removeAllGraphics];
    [self clearAllGarphics];
//    [self.multiPoint removeAllObjects];
    NSDictionary *feature = nil;
    
//    int i=0;
    
    if(_resultArray ==nil)
    {
        return;
    }
    
    
    for (int i=0; i<_resultArray.count;i++)
    {
        //赋符号
        symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_gcoding"]];
         Shop *shop = [_resultArray objectAtIndex:i];
        
        
//        if (i ==0) {
//            //[cell.imageView setImage:[UIImage imageNamed:@"icon_marka.png"]];
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_gcoding"]];
//        }
//        else if (i ==1) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markb.png"]];
//        }
//        else if (i ==2) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markc.png"]];
//        }
//        else if (i ==3) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markd.png"]];
//        }
//        else if (i ==4) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marke.png"]];
//        }
//        else if (i ==5) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markf.png"]];
//        }
//        else if (i ==6) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markg.png"]];
//        }
//        else if (i ==7) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markh.png"]];
//        }else if (i ==8) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marki.png"]];
//        }
//        else if (i ==9) {
//            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markj.png"]];
//        }
//        
        // NSInteger m = 10*(self.curPage-1)+i;
        // feature = [self.dataSet objectAtIndex:m];
//        feature = [self.dataSet objectAtIndex:i];
//        feature = @"abc";
//        NSString *location = [feature objectForKey:@"location"];
//        NSArray * array = [location componentsSeparatedByString: @","];
//        CGPoint pt;
//        pt.x=[array[1] floatValue];
//        pt.y=[array[0] floatValue];
        
        AGSPoint * point =[AGSPoint pointWithX:[shop.longitude doubleValue]
                                             y:[shop.latitude doubleValue ]
                              spatialReference:self.mapView.spatialReference];
        
//        AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:point
//                                                      symbol:symbol
//                                                  attributes:[feature mutableCopy]
//                                        infoTemplateDelegate:self];
        
        AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:point
                                                      symbol:symbol
                                                  attributes:[feature mutableCopy]];

//        graphic.layer.
        
        [self.keyGraphicsLayer addGraphic:graphic];
//        [self.multiPoint addObject:point];
    }
    
    [self.keyGraphicsLayer refresh];
}


- (BOOL) callout:(AGSCallout *)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable> *)layer mapPoint:(AGSPoint *)mapPoint
{
    
    AGSGraphic* graphic = (AGSGraphic*)feature;
    
                CGRect frame = CGRectMake(0, 0, 300, 50);
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = frame;
                [button setTitle:@"新添加的动态按钮" forState: UIControlStateNormal];
                button.backgroundColor = [UIColor blueColor];
                button.tag = 2000;
//                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:button];
    
                [self.mapView addSubview:button];
    
    return  YES;
}


- (IBAction)showAroundSearch:(id)sender {
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 6;
        
        ButtonView *bv = [[ButtonView alloc]initWithText:@"全部" image:[UIImage imageNamed:@"1"] handler:^(ButtonView *buttonView){
            NSLog(@"全部美食");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"中餐" image:[UIImage imageNamed:@"2"] handler:^(ButtonView *buttonView){
            NSLog(@"点击Email");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"西餐" image:[UIImage imageNamed:@"3"] handler:^(ButtonView *buttonView){
            NSLog(@"点击印象笔记");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"饭店" image:[UIImage imageNamed:@"4"] handler:^(ButtonView *buttonView){
            NSLog(@"点击QQ");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"茶馆" image:[UIImage imageNamed:@"5"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"食品店" image:[UIImage imageNamed:@"6"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信朋友圈");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"蛋糕店" image:[UIImage imageNamed:@"7"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"特色饮食" image:[UIImage imageNamed:@"8"] handler:^(ButtonView *buttonView){
            NSLog(@"点击微信朋友圈");
        }];
        [self.activityView addButtonView:bv];
        
    }
    
    [self.activityView show];
}


- (void)viewDidUnload {
    self.mapView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
