//
//  MapDownLoadView.h
//  MapViewDemo
//
//  Created by leadmap on 12/13/12.
//
//

#import <UIKit/UIKit.h>
#import "SFavoriteDB.h"
#import "ViewController.h"
#import "HttpRequest.h"

@interface MapDownLoadView : UIViewController<HttpRequestDelegate>
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
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  NSArray *cityNames;
@property (nonatomic, retain)  IBOutlet UITableView *tableview;
@property (nonatomic, retain)  ViewController *mainController;
@property (nonatomic, retain)  UIProgressView	*progressView;
@property (nonatomic, retain)  NSString * curPath;
@property (nonatomic, retain)  NSString *curFile;
@end
