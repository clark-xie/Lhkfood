//
//  MapDownManagerView.h
//  MapViewDemo
//
//  Created by huwei on 1/21/13.
//
//

#import <UIKit/UIKit.h>
#import "SFavoriteDB.h"
#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
@interface MapDownManagerView : UITableViewController<ASIHTTPRequestDelegate>
{
    ASINetworkQueue *queue;
    SFavoriteDB *_favoriteDb;
    NSArray *_dataset;
    NSArray *_cityNames;
    NSString		*downloadCityName;
    NSMutableArray   *downLoadedCitys;
    NSMutableArray   *downLoadingCitys;
    NSString * _curPath;
    NSString *_curFile;
    UITableView *_tableview;
    UIProgressView	*progressView;
}
@property (nonatomic, retain) NSArray *dataset;
@property (nonatomic, retain)  NSArray *cityNames;
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  ViewController *mainController;
@property (nonatomic, retain)  UIProgressView	*progressView;
@property (nonatomic, retain)  NSString * curPath;
@property (nonatomic, retain)  NSString *curFile;
@property (nonatomic, retain)  IBOutlet UITableView *tableview;
-(void)putCityName:(NSDictionary*)dict;
-(void)refreshTable;
@end
