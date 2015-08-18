//
//  FavoriteMangerView.h
//  MapViewDemo
//
//  Created by leadmap on 12/3/12.
//
//

#import <UIKit/UIKit.h>
#import "SFavoriteDB.h"
#import "ViewController.h"
#import <ArcGIS/ArcGIS.h>

@interface FavoriteMangerView : UIViewController
{
    SFavoriteDB *_favoriteDb;
    NSArray *_favoriteObjects;
    UITableView *_tableview;
}
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  NSArray *favoriteObjects;
@property (nonatomic, retain)  IBOutlet UITableView *tableview;
@property (nonatomic, retain)  ViewController *mainController;
@end
