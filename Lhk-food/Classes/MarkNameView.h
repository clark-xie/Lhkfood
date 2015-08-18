//
//  MarkNameView.h
//  MapViewDemo
//
//  Created by leadmap on 11/19/12.
//
//

#import <UIKit/UIKit.h>
#import "BookMarksViewController.h"
#import "SFavoriteDB.h"
#import <ArcGIS/ArcGIS.h>

@interface MarkNameView : UIViewController<UITextFieldDelegate,BookMarksViewDelegate>
{
    UITextField *_tField;
    __unsafe_unretained NSObject<BookMarksViewDelegate> * delegate;
    SFavoriteDB *_favoriteDb;
    AGSGraphic *_curGraphic;
    SFavorite *_favorite;
}
@property (nonatomic, retain) IBOutlet UITextField *tField;
@property(nonatomic, assign) NSObject<BookMarksViewDelegate> * delegate;
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  AGSGraphic *curGraphic;
@property (nonatomic, retain)  SFavorite *favorite;
- (void)putValue:(NSString *)value;
-(void)putGrapic:(AGSGraphic*)graphic;

@end
