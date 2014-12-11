//
//  MesureTools.h
//  ParkManger
//
//  Created by iphone42 on 11-5-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@class MesureTools;
@protocol MesureToolsDelegate

- (void)LengthChanged:(MesureTools *)mTool length:(double )length ;
- (void)AreaChanged:(MesureTools *)mTool area:(double )area ;
@end
@interface MesureTools : NSObject<AGSMapViewTouchDelegate> {
	AGSGeometry           *_sketchGeometry;
	AGSMapView* _mapView;
	AGSGraphicsLayer* _graphicsLayer;
	AGSGraphic* _activeGraphic;
	int         _selectTool;
	id <MesureToolsDelegate> delegate;
	AGSGeometryEngine  *_geoEngine;
	int _numOfPoints;
	
}
@property (nonatomic,retain) id <MesureToolsDelegate> delegate;
@property (nonatomic,retain) AGSMapView* mapView;
@property (nonatomic,retain) AGSGraphic* activeGraphic;
@property (nonatomic,retain) AGSGeometry           *sketchGeometry;
- (id)initWithMesureTool:(AGSMapView*) mapView graphicsLayer:(AGSGraphicsLayer*)graphicsLayer;
-(void) clear;
- (void) toolSelected:(int)tooIndex ;

@end
