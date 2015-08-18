//
//  LableMangerView.h
//  MapViewDemo
//
//  Created by leadmap on 12/11/12.
//
//

#import <UIKit/UIKit.h>
#import "SFavoriteDB.h"
#import "ViewController.h"
#import "LabelObject.h"
@interface LabelMangerView : UIViewController
{
    SFavoriteDB *_favoriteDb;
    NSArray *_labelObjects;
    UITableView *_tableview;
}
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  NSArray *labelObjects;
@property (nonatomic, retain)  IBOutlet UITableView *tableview;
@property (nonatomic, retain)  ViewController *mainController;
@end
