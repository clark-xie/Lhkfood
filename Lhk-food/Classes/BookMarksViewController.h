//
//  BookMarksViewController.h
//  MapViewDemo
//
//  Created by huwei on 11/16/12.
//
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "SFavoriteDB.h"

@protocol BookMarksViewDelegate
// 必选方法
- (void)passValue:(NSString *)value;
// 可选方法
-(void)insertData;
@optional

@end

@interface BookMarksViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,BookMarksViewDelegate>
{
    UITableView *_tableView;
    UIView *_tableHeaderView;
    UILabel *_lblName;
    UIButton *_btnFavorite;
    AGSGraphic *_curGraphic;
    SFavoriteDB *_favoriteDb;
    SFavorite *_favorite;
    BOOL isFavorite;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UIButton *btnFavorite;
@property (nonatomic, retain)  AGSGraphic *curGraphic;
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  SFavorite *favorite;
@property (nonatomic)   BOOL isFavorite;
-(IBAction)addBookMark:(id)sender;
- (void)passValue:(NSString *)value;
-(void)putGrapic:(AGSGraphic*)graphic;
@end
