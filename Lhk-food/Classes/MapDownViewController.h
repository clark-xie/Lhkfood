//
//  MapDownViewController.h
//  MapViewDemo
//
//  Created by huwei on 1/21/13.
//
//

#import <UIKit/UIKit.h>
#import "ProvinceViewController.h"
#import "SFavoriteDB.h"
#import "HttpRequest.h"
#import "ViewController.h"
@class MapDownLoadManager;
@interface MapDownViewController : UITableViewController
{
    SFavoriteDB *_favoriteDb;
    NSArray *_cityNames;
    UITableView *_tableview;
    UIProgressView	*progressView;
    NSString		*downloadCityName;
    NSString		*downloadCityCode;
    NSMutableArray   *downLoadedCitys;
    NSString * _curPath;
    NSString *_curFile;
}
@property (nonatomic, retain) ProvinceViewController* simpleController;
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  NSArray *cityNames;
@property (nonatomic, retain)  ViewController *mainController;
@property (nonatomic, retain)  NSString * curPath;
@property (nonatomic, retain)  NSString *curFile;
@property (nonatomic, retain)  IBOutlet UITableView *tableview;
@end
