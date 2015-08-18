//
//  CustemCalloutViewViewController.h
//  MapViewDemo
//
//  Created by leadmap on 12/3/12.
//
//

#import <UIKit/UIKit.h>


@interface CustemCalloutViewViewController : UIViewController
{
    UILabel *_stitle;
    UILabel *_sdetail;
    NSArray *dataSet;
    AGSMutableMultipoint *_multiPoint;
    AGSGraphic *_curGraphic;
    SFavoriteDB *_favoriteDb;
    SFavorite *_favorite;
}
@property (nonatomic, retain) IBOutlet UILabel *stitle;
@property (nonatomic, retain) IBOutlet UILabel *sdetail;
@property (nonatomic, retain) IBOutlet UIButton *leftBtn;
@property (nonatomic, retain) IBOutlet UIButton *rightBtn;
@property (nonatomic, retain) ViewController *mainController;
@property (nonatomic, retain) NSArray *dataSet;
@property (nonatomic, retain) AGSMutableMultipoint *multiPoint;
@property (nonatomic, retain) AGSGraphic *curGraphic;
@property (nonatomic, retain)  SFavoriteDB *favoriteDb;
@property (nonatomic, retain)  SFavorite *favorite;

- (id)initWithFrame:(CGRect)frame;
-(IBAction)doSearch:(id)sender;
-(IBAction)doDetail:(id)sender;
- (void)putDataSet:(NSArray *)featureSet;
-(void)putGraphic:(AGSGraphic*)graphic;
@end
