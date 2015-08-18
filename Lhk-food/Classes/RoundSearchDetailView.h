//
//  RoundSearchDetailView.h
//  MapViewDemo
//
//  Created by leadmap on 12/4/12.
//
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "ViewController.h"

@interface RoundSearchDetailView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    AGSGraphic *_feature;
    AGSFeatureSet *_featureSet;
   // NSObject<MapViewDelegate> * delegate;
    IBOutlet UITableViewCell *tableViewCell;
    UIView *_footerView;//底部视图
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    UILabel *_lblPage;
    UILabel *_lblCount;
    UIView  *_headerView;
    
    NSArray *result;
    NSArray *dataSet;
    NSMutableArray *_multiPoint;
    UIView *_noResultView;
    
    UIPickerView *pickerView;
    UIToolbar *picketToolbar;
    NSMutableArray * lengthsArray;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) AGSGraphic *feature;
@property (nonatomic,retain) AGSFeatureSet *featureSet;
@property (nonatomic) NSInteger curPage;
//@property(nonatomic, assign) NSObject<MapViewDelegate> * delegate;
@property (nonatomic, retain) IBOutlet UITableViewCell *tableViewCell;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) IBOutlet UIButton *leftBtn;
@property (nonatomic, retain) IBOutlet UIButton *rightBtn;
@property (nonatomic, retain) IBOutlet UILabel *lblPage;
@property (nonatomic, retain) IBOutlet UILabel *lblCount;
@property (nonatomic, retain) IBOutlet UIView  *headerView;
@property (nonatomic, retain) IBOutlet UIView  *noResultView;
@property (nonatomic, retain) IBOutlet UIButton *lengthBtn;

@property (nonatomic, retain) NSArray *dataSet;
@property (nonatomic, retain) NSMutableArray *multiPoint;
@property (nonatomic, retain) ViewController *mainController;

- (void)putDataSet:(NSArray *)featureSet;
@end
