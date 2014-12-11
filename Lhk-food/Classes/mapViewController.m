//
//  MapViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/11/16.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "MapViewController.h"
#import "TianDiTuWMTSLayer.h"
@interface MapViewController()

@property Shop *shop;

@property BOOL bLocate;
@property (nonatomic, strong) AGSGraphicsLayer	*graphicsLayer;
@property (nonatomic,strong)  CLLocationManager *locationManager;


@end


@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSError *error;
    NSString* clientID = @"Zk6oCtlQy4hEmSwQ";
    [AGSRuntimeEnvironment setClientID:clientID error:&error];
    if(error){
        // We had a problem using our client ID
        NSLog(@"Error using client ID : %@",[error localizedDescription]);
    }
    
    [self.messageView setHidden:YES];
    
    
    
//    NSError* err;
//    ///* sr:Mercator(102100)
//    TianDiTuWMTSLayer* TianDiTuLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_MERCATOR LocalServiceURL:nil error:&err];
//    TianDiTuWMTSLayer* TianDiTuLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_ANNOTATION_CHINESE_MERCATOR LocalServiceURL:nil error:&err];
//    
//    
//    //If layer was initialized properly, add to the map
//    if(TianDiTuLyr!=nil && TianDiTuLyr_Anno !=nil){
//        [self.mapView addMapLayer:TianDiTuLyr withName:@"TianDiTu Layer"];
//        [self.mapView addMapLayer:TianDiTuLyr_Anno withName:@"TianDiTu Annotation Layer"];
//        
//    }else{
//        //layer encountered an error
//        NSLog(@"Error encountered: %@", err);
//    }
//    
    
//    self.selectLength = @"当前可视范围";
    //    [self.navigationController  setNavigationBarHidden:YES animated:NO];
    NSError* err;
    // Do any additional setup after loading the view, typically from a nib.
    _TianDiTuLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_2000 LocalServiceURL:nil error:&err];
    _TianDiTuLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_ANNOTATION_CHINESE_2000 LocalServiceURL:nil error:&err];
    _TianDiTuimgLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_IMAGE_2000 LocalServiceURL:nil error:&err];
    _TianDiTuimgLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_IMAGE_ANNOTATION_CHINESE_2000 LocalServiceURL:nil error:&err];
    if(_TianDiTuLyr!=nil && _TianDiTuLyr_Anno !=nil){
        [self.mapView addMapLayer:_TianDiTuimgLyr withName:@"TianDiTuimg Layer"];
        [self.mapView addMapLayer:_TianDiTuimgLyr_Anno withName:@"TianDiTuimg Annotation Layer"];
        [self.mapView addMapLayer:_TianDiTuLyr withName:@"TianDiTu Layer"];
        [self.mapView addMapLayer:_TianDiTuLyr_Anno withName:@"TianDiTu Annotation Layer"];
        _TianDiTuLyr.visible = YES;
        _TianDiTuLyr_Anno.visible = YES;
        _TianDiTuimgLyr.visible = NO;
        _TianDiTuimgLyr_Anno.visible = NO;
    }else{
        //layer encountered an error
        NSLog(@"Error encountered: %@", err);
    }
    
    //设置回调
    self.mapView.callout.delegate = self;

    
    //添加标绘图层
    self.keyGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.keyGraphicsLayer withName:@"kGraphics Layer"];
    
    //添加定位图层
    self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
    //画点
    [self loadCurPageGraphics];
    
    //添加定位功能
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self enableLocationAndGotoPoint:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//指定查询结果的位置
-(void)loadCurPageGraphics
{
    AGSSimpleMarkerSymbol *symbol = nil;
    //[self.mainController.keyGraphicsLayer removeAllGraphics];
//    [self clearAllGarphics];
    //    [self.multiPoint removeAllObjects];
    NSDictionary *feature = nil;
    
    //    int i=0;
    
    if(_resultArray ==nil)
    {
        return;
    }
    
//    Shop *zoomPointShop  = [_resultArray objectAtIndex:1];

    AGSPoint * zoomPoint;
    
    for (int i=0; i<_resultArray.count;i++)
    {
        //赋符号
        symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"restaurant"]];
        Shop *shop = [_resultArray objectAtIndex:i];
//        self.shop = shop;
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:i],@"type", nil];
//        [dic setValue:shop forKey:@"1"];
        
        //        if (i ==0) {
        //            //[cell.imageView setImage:[UIImage imageNamed:@"icon_marka.png"]];
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_gcoding"]];
        //        }
        //        else if (i ==1) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markb.png"]];
        //        }
        //        else if (i ==2) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markc.png"]];
        //        }
        //        else if (i ==3) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markd.png"]];
        //        }
        //        else if (i ==4) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marke.png"]];
        //        }
        //        else if (i ==5) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markf.png"]];
        //        }
        //        else if (i ==6) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markg.png"]];
        //        }
        //        else if (i ==7) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markh.png"]];
        //        }else if (i ==8) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marki.png"]];
        //        }
        //        else if (i ==9) {
        //            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markj.png"]];
        //        }
        //
        // NSInteger m = 10*(self.curPage-1)+i;
        // feature = [self.dataSet objectAtIndex:m];
        //        feature = [self.dataSet objectAtIndex:i];
        //        feature = @"abc";
        //        NSString *location = [feature objectForKey:@"location"];
        //        NSArray * array = [location componentsSeparatedByString: @","];
        //        CGPoint pt;
        //        pt.x=[array[1] floatValue];
        //        pt.y=[array[0] floatValue];
        
        AGSPoint * point =[AGSPoint pointWithX:[shop.longitude doubleValue]
                                             y:[shop.latitude doubleValue ]
                              spatialReference:self.mapView.spatialReference];
        
        if(i == 0)
        {
            zoomPoint = point;
        }
        //        AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:point
        //                                                      symbol:symbol
        //                                                  attributes:[feature mutableCopy]
        //                                        infoTemplateDelegate:self];
        
        AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:point
                                                      symbol:symbol
                                                  attributes:dic];
        
        //        graphic.layer.
        
        [self.keyGraphicsLayer addGraphic:graphic];
        //        [self.multiPoint addObject:point];
    }
    
    
    [self zoomToAGSPoint:zoomPoint];
    [self.keyGraphicsLayer refresh];
}

- (BOOL) callout:(AGSCallout *)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable> *)layer mapPoint:(AGSPoint *)mapPoint
{
    AGSGraphic *graphice = (AGSGraphic *)feature;
    NSNumber *number = (NSNumber *) [graphice attributeForKey :@"type"];
//    
 Shop *shop = [_resultArray objectAtIndex:[number integerValue]];
//    Shop * shop = [dic objectForKeyedSubscript:@"1"]; //得到商店的信息
//    Shop *shop = self.shop;
    [self.messageView setHidden:NO];
    self.shopname.text = shop.name;
    //下面的函数要改进，还是有问题
    self.rateimage.image = [Rate imageFromRate:shop.rate];

    CGFloat avg = [shop.avg_spend floatValue];
    
    self.shopother.text =[NSString stringWithFormat:@"人均%.2f元",avg];
    
    
    return  NO;
}

- (IBAction)zoomin:(id)sender {
    [self.mapView zoomIn:YES];
}

- (IBAction)zoomout:(id)sender {
    [self.mapView zoomOut:YES];
}

- (IBAction)showLocation:(id)sender {
    [self enableLocationAndGotoPoint:YES];
//    self zoomToPoint:(CGPoint)
}

//定位到指定点
-(void)zoomToPoint:(CGPoint) point
{
    AGSPoint *mappoint =[[AGSPoint alloc] initWithX:point.x y:point.y spatialReference:self.mapView.spatialReference];
    [self zoomToAGSPoint:mappoint];
    

}

-(void)zoomToAGSPoint:(AGSPoint*)mappoint;
{
    
    //    if(_bLocate){
    double size =0.0125;
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:mappoint.x - size
                                                     ymin:mappoint.y - size
                                                     xmax:mappoint.x + size
                                                     ymax:mappoint.y + size
                                         spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:envelope animated:YES];
    
    //    }
}

-(void) LocationMap:(CGPoint ) point
{
    
    //newPoint = (AGSPoint*)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:newPoint toSpatialReference:self.mapView.spatialReference];
    [ self.graphicsLayer removeAllGraphics];
    
    AGSPoint *mappoint =[[AGSPoint alloc] initWithX:point.x y:point.y spatialReference:self.mapView.spatialReference];

    
    // Create a marker symbol using the Location.png graphic
    AGSPictureMarkerSymbol *markerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"location.png"];
    
    // Create a new graphic using the location and marker symbol
    AGSGraphic* graphic = [AGSGraphic graphicWithGeometry:mappoint symbol:markerSymbol attributes:nil];
    
    // Add the graphic to the graphics layer
    [ self.graphicsLayer addGraphic:graphic];
    [ self.graphicsLayer refresh];
    _bLocate= NO;
}


//定位功能
//开启定位功能
- (void)enableLocationAndGotoPoint:(bool) showPoint{
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        NSLog(@"定位功能已经打开");
        
        //[self.mapView.locationDisplay startDataSource];
        //self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
        
        CLLocation *location = self.locationManager.location;
        CGPoint mecPoint;
        mecPoint.y = location.coordinate.latitude;
        mecPoint.x= location.coordinate.longitude;
        //坐标转换
        //CGPoint mecPoint = [self lonLat2Mercator:pnt];
        _bLocate= showPoint;
        
        [self LocationMap:mecPoint];
        //如果要去当前位置
        if(showPoint)
        {
            [self zoomToPoint:mecPoint];
        }
        
        //
        //
        //        NSURL *url = [NSURL URLWithString:LocalURL(mecPoint.x,mecPoint.y)];
        //
        ////        NSLog(Location(mecPoint.x,mecPoint.y));
        //        asiRequest = [ASIHTTPRequest requestWithURL:url];
        //        [asiRequest setDelegate:self];
        //        [asiRequest setDidFinishSelector:@selector(GetResult:)];
        //        [asiRequest setDidFailSelector:@selector(GetErr:)];
        //        [asiRequest startAsynchronous];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"GPRS定位功能未打开，请在设备的设置里面打开定位功能"
                                                       delegate:self
                                              cancelButtonTitle:@"了解"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"定位功能未打开");
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
    
    NSLog(@"%f",newLocation.coordinate.latitude);
    if(howRecent < -30) return ; //离上次更新的时间少于10秒
    CLLocation *location = self.locationManager.location;
    CGPoint mecPoint;
    // mecPoint.y = location.coordinate.latitude;
    //mecPoint.x= location.coordinate.longitude;
    mecPoint.y = newLocation.coordinate.latitude;
    mecPoint.x= newLocation.coordinate.longitude;
    //坐标转换
    //CGPoint mecPoint = [self lonLat2Mercator:pnt];
    
    [self LocationMap:mecPoint];
    //    NSURL *url = [NSURL URLWithString:LocalURL(mecPoint.x,mecPoint.y)];
    //    asiRequest = [ASIHTTPRequest requestWithURL:url];
    //    [asiRequest setDelegate:self];
    //    [asiRequest setDidFinishSelector:@selector(GetResult:)];
    //    [asiRequest setDidFailSelector:@selector(GetErr:)];
    //    [asiRequest startAsynchronous];
    
    //NSLog(@"location ok");
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    //
    if ([error code] != kCLErrorLocationUnknown) {
        NSLog(@"%@",@"有错误产生");
        //        [self stopUpdatingLocationWithMessage:NSLocalizedString(@"Error", @"Error")];
    }
}


//放大到指定的点
-(void) zoomToPoint:(AGSPoint *) mappoint withLevel:(int) level
{
    //[self.mapView centerAtPoint:mappoint animated:YES];
    
//    AGSLOD* lod = [_TianDiTuLyr.tileInfo.lods objectAtIndex:level];
    
//    float zoomFactor = lod.resolution/self.mapView.resolution;
    [self zoomToAGSPoint:mappoint];
    
//    AGSMutableEnvelope *newEnv =
//    [AGSMutableEnvelope envelopeWithXmin:mappoint.x-0.0125
//                                    ymin:mappoint.y-0.0125
//                                    xmax:mappoint.x+0.0125
//                                    ymax:mappoint.y+0.0125
//                        spatialReference:self.mapView.spatialReference];
//    
//    //[newEnv expandByFactor:zoomFactor];
//    [self.mapView zoomToEnvelope:newEnv animated:YES];
}

//放大到所有点的位置
-(void) zoomToMultiPoint:(NSArray *) mappoints withLevel:(int) level
{
    AGSPoint *point = [mappoints objectAtIndex:0];
    [self.mapView centerAtPoint:point animated:YES];
    AGSLOD* lod = [_TianDiTuLyr.tileInfo.lods objectAtIndex:level];
    float zoomFactor = lod.resolution/self.mapView.resolution;
    AGSMutableEnvelope *newEnv =
    [AGSMutableEnvelope envelopeWithXmin:self.mapView.maxEnvelope.xmin
                                    ymin:self.mapView.maxEnvelope.ymin
                                    xmax:self.mapView.maxEnvelope.xmax
                                    ymax:self.mapView.maxEnvelope.ymax
                        spatialReference:self.mapView.spatialReference];
    
    [newEnv expandByFactor:zoomFactor];
    [self.mapView zoomToEnvelope:newEnv animated:YES];
}



@end
