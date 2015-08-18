//
//  ViewController.h
//  DigitHubei_IPad
//
//  Created by leadmap on 7/9/13.
//  Copyright (c) 2013 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "NIDropDown.h"
#import "CustemCalloutViewViewController.h"
#import "TianDiTuWMTSLayer.h"

#import "HYActivityView.h"

//@interface ViewController : UIViewController<AGSMapViewLayerDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,AGSMapViewCalloutDelegate,AGSMapViewTouchDelegate,AGSPopupsContainerDelegate,AGSInfoTemplateDelegate,CLLocationManagerDelegate,CMPopTipViewDelegate,NIDropDownDelegate,ASIHTTPRequestDelegate,AGSCalloutDelegate>{


@interface ViewController : UIViewController<AGSCalloutDelegate>
//<AGSMapViewLayerDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,AGSMapViewTouchDelegate,AGSPopupsContainerDelegate,CLLocationManagerDelegate,CMPopTipViewDelegate,NIDropDownDelegate,ASIHTTPRequestDelegate,AGSCalloutDelegate>
{
	AGSMapView *_mapView;
    AGSGraphicsLayer	*_graphicsLayer;
    AGSGraphicsLayer	*_favoriteLayer;
    AGSGraphicsLayer	*_labelLayer;
    AGSGraphicsLayer	*_keyGraphicsLayer;
    AGSGraphicsLayer	*_roundGraphicsLayer;
    CLLocationManager *locationManager;
    //http请求
    ASIHTTPRequest *asiRequest;
    UIToolbar *_toolbar;
	CMPopTipView *popTipView;
	//this map has a dynamic layer, need a view to act as a container for it
    UISearchBar * _searchBar;
    BOOL risHidden;
    
	AGSFeatureSet *_featureSet;
    AGSSimpleMarkerSymbol *_simpleMarkerSymbol;
    
    BOOL isQuery;
    SFavoriteDB *_favoriteDb;
    CustemCalloutViewViewController *_custemCallout;//自定义气泡
    AGSEnvelope *_curEnvelope;
    //ASIHTTPRequest *request;
    NSMutableArray	*visiblePopTipViews;
    BOOL isAddLabel;
    UIView *btnView;
    //UIButton *btnLocation;
    //UIButton *btnMore;
    UIView *btnLocation;
    UIView *btnMore;
    MesureTools      *_mTools;
    UIView  *measureView;
    UILabel *measureRsult;
    UIPopoverController *_popViewController;
    UIButton *btnSelect;
    NIDropDown *dropDown;
    NSArray *_results;
    NSString *isKorR;
    NSString *_selectLength;
    TianDiTuWMTSLayer* TianDiTuLyr;
    TianDiTuWMTSLayer* TianDiTuLyr_Anno;
    TianDiTuWMTSLayer* TianDiTuimgLyr;
    TianDiTuWMTSLayer* TianDiTuimgLyr_Anno;
    BOOL _bLocate;
    int _count;
    DejalBezelActivityView *_deja;
    UILabel *yLabel;
    NSMutableArray *resultArray;
}
- (IBAction)close:(id)sender;
@property (nonatomic, retain) IBOutlet AGSMapView *mapView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIView *btnView;
@property (nonatomic, retain) IBOutlet UIView *measureView;
@property (nonatomic, retain) IBOutlet UILabel *measureRsult;
@property (nonatomic, retain) IBOutlet UIView *btnLocation;
@property (nonatomic, retain) IBOutlet UIView *btnMore;
@property (nonatomic, retain) IBOutlet UIButton *btnKSearch;
@property (nonatomic, retain) IBOutlet UIButton *btnRSearch;
@property (nonatomic, retain) IBOutlet UIButton *btnLable;
@property (nonatomic, retain) AGSGraphicsLayer	*graphicsLayer;
@property (nonatomic, retain) AGSGraphicsLayer	*favoriteLayer;
@property (nonatomic,retain)  AGSGraphicsLayer	*keyGraphicsLayer;
@property (nonatomic,retain)  AGSGraphicsLayer	*roundGraphicsLayer;
@property (nonatomic,retain)  AGSGraphicsLayer	*labelLayer;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UISearchBar * searchBar;
@property (nonatomic, retain) AGSPopupsContainerViewController *popupVC;
@property (nonatomic, retain) UIPopoverController *popViewController;
@property (nonatomic,retain) AGSQueryTask *queryTask;
@property (nonatomic,retain) AGSQuery *query;
@property (nonatomic,retain) AGSFeatureSet *featureSet;
@property (nonatomic,retain) AGSSimpleMarkerSymbol *simpleMarkerSymbol;
@property (nonatomic)  BOOL isQuery;
@property (nonatomic,retain)		   SFavoriteDB *favoriteDb;
@property (nonatomic,retain)		   CustemCalloutViewViewController *custemCallout;
@property (nonatomic,retain)		   AGSEnvelope *curEnvelope;
//@property (nonatomic,retain)		  ASIHTTPRequest *request;
@property (nonatomic, retain)	id				currentPopTipViewTarget;
@property (nonatomic, retain)	NSMutableArray	*visiblePopTipViews;
@property (nonatomic, retain)	CMPopTipView *popTipView;
@property (nonatomic)	BOOL isAddLabel;
@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
@property (nonatomic, retain)  NSArray *results;
@property (nonatomic, retain)  NSString *selectLength;
@property (nonatomic, assign)  int count;
@property (nonatomic, retain) DejalBezelActivityView *deja;

//add by tc 查询结果保存
@property (nonatomic, strong) NSMutableArray *resultArray;

- (IBAction)selectClicked:(id)sender;

-(void)changeLayer;
-(void) zoomToPoint:(AGSPoint *) mappoint withLevel:(int) level;
-(void) zoomToMultiPoint:(NSArray *) mappoint withLevel:(int) level;
- (void)showGraphic:(AGSGraphic*)graphic;
- (void)showAllGraphic:(AGSFeatureSet*)featureSet;
-(void)putQuery:(BOOL)isquery;
-(void)showRoundSearch:(AGSGraphic*)graphic;
-(void)showDetailInfo:(AGSGraphic*)graphic;
-(void)loadAllFavorite;
-(void)clearAllGarphics;
-(void)showFavoriteManger;
- (IBAction)zoomin:(id)sender;
- (IBAction)zoomout:(id)sender;

-(IBAction)showLocation:(id)sender;
-(IBAction)showKSearch:(id)sender;
-(IBAction)showRSearch:(id)sender;
//-(IBAction)showMore:(id)sender;
-(IBAction)showLabelManeger:(id)sender;
-(IBAction)meaesureLength:(id)sender;
-(IBAction)meaesureArea:(id)sender;
-(BOOL)showFavoritePoints;
-(void)loadAllLabels;
-(void)showFavoriteAllWays:(BOOL) ishide;
-(BOOL)getFavoriteState;
-(void)showQueryResults:(NSArray*)results:(NSString*)key :(NSString*)keyword :(NSString*)keycode :(AGSPoint *)point :(int)count;
-(void)putRsults:(NSArray*)results;
@end
