//
//  LableNewView.h
//  MapViewDemo
//
//  Created by leadmap on 12/11/12.
//
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "SFavoriteDB.h"
#import "LabelObject.h"
#import "ViewController.h"
@interface LabelNewView : UIViewController
{
    UITextField *_x;
    UITextField *_y;
    UITextField *_name;
    UITextField *_level;
    AGSPoint *curPoint;
    SFavoriteDB *_favoriteDb;
}
@property (nonatomic, retain) IBOutlet UITextField *x;
@property (nonatomic, retain) IBOutlet UITextField *y;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *level;
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  ViewController *mainController;

-(void)putPoint:(AGSPoint*)point;
-(void)putLevel:(NSString*)lvl;
@end
