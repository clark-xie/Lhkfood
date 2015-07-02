//
//  KeyWordSearchView.h
//  MapViewDemo
//
//  Created by huwei on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "MyPageControl.h"
#import "ViewController.h"
#define poiURL @"http://192.168.33.10:8080/RemoteRest/services/WH_POI/MapServer/0"

@class KSearchDetailsView;
@class ASIHTTPRequest;

@protocol KeyWordViewDelegate
// 必选方法
- (void)passValue:(NSString *)name classCode:(NSString*)code;
// 可选方法
@optional

@end
@interface KeyWordSearchView : UIViewController<UISearchBarDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,KeyWordViewDelegate>
{
    UISearchBar * _searchBar;
    NSArray *_cates;
    UIScrollView *_scrollView;
    MyPageControl *_pageControl;
    UITableView *_tableView;
    AGSQueryTask *_queryTask;
    
	AGSQuery *_query;
	AGSFeatureSet *_featureSet;
    KSearchDetailsView *_kSearchDetailsView;
    NSArray* collection;
    NSURLConnection* collectionConnection;
    NSMutableData* collectionData;
    NSArray *result;
    ASIHTTPRequest *requests;
    SFavoriteDB *_favoriteDb;
    SHistory *_history;
    NSArray *_results;
    ViewController *_mainView;
    AGSEnvelope *_curEnvelope;
    NSString *_code;
    int _count;
}
@property (nonatomic, retain) IBOutlet UISearchBar * searchBar;
@property (strong, nonatomic) NSArray *cates;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) MyPageControl *pageControl;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic,retain) AGSQueryTask *queryTask;
@property (nonatomic,retain) AGSQuery *query;
@property (nonatomic,retain) AGSFeatureSet *featureSet;
@property (nonatomic,retain) KSearchDetailsView *kSearchDetailsView;
@property (nonatomic, retain) NSArray* collection;
@property (nonatomic, retain) NSURLConnection* collectionConnection;
@property (nonatomic, retain) NSMutableData* collectionData;
@property (retain, nonatomic) ASIHTTPRequest *request;
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  SHistory *history;
@property (nonatomic, retain)  NSArray *results;
@property (nonatomic, retain)  ViewController *mainView;
@property (nonatomic,retain)		   AGSEnvelope *curEnvelope;
@property (nonatomic,retain)		   NSString *code;
@property (nonatomic,assign)	int count;

-(void)putEnvelope:(AGSEnvelope*)env;
@end
