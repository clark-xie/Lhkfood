//
//  MapViewController.h
//  Lhk-food
//
//  Created by 谢超 on 14/11/16.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface MapViewController : UIViewController<AGSCalloutDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property (strong ,nonatomic) TianDiTuWMTSLayer* TianDiTuLyr;
@property (strong ,nonatomic) TianDiTuWMTSLayer* TianDiTuLyr_Anno;
@property (strong ,nonatomic) TianDiTuWMTSLayer* TianDiTuimgLyr;
@property (strong ,nonatomic) TianDiTuWMTSLayer* TianDiTuimgLyr_Anno;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) AGSGraphicsLayer	*keyGraphicsLayer;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *shopname;
@property (weak, nonatomic) IBOutlet UILabel *shopother;
@property (weak, nonatomic) IBOutlet UIImageView *shopDetail;
@property (weak, nonatomic) IBOutlet UIImageView *rateimage;


- (IBAction)zoomin:(id)sender ;
- (IBAction)zoomout:(id)sender ;
- (IBAction)showLocation:(id)sender;
@end

