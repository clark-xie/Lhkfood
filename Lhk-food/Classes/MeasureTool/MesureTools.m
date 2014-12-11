//
//  MesureTools.m
//  ParkManger
//
//  Created by iphone42 on 11-5-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MesureTools.h"


@implementation MesureTools
@synthesize activeGraphic=_activeGraphic;@synthesize delegate;
@synthesize sketchGeometry=_sketchGeometry;
- (id)initWithMesureTool:(AGSMapView*) mapView graphicsLayer:(AGSGraphicsLayer*)graphicsLayer	
{
    self = [super init];
    if (self) {
		
		//hold references to the mapView, graphicsLayer, and sketchLayer
		_mapView = mapView;
		_graphicsLayer = graphicsLayer;
		//Register for "Geometry Changed" notifications 
		//We want to enable/disable UI elements when sketch geometry is modified
		_geoEngine = [AGSGeometryEngine defaultGeometryEngine];
		_numOfPoints = 0;

	}
    return self;
}



-(void) clear
{
	[_graphicsLayer removeAllGraphics];
	[_graphicsLayer refresh];
	_numOfPoints = 0;
	_selectTool = 0;
	self.activeGraphic = nil;
	self.sketchGeometry = nil;
	//_mapView.touchDelegate  = nil;
}
- (void) toolSelected:(int)tooIndex {
	[self clear];
	_selectTool = tooIndex;
	_mapView.touchDelegate = self; 
	
}

- (void)mapView:(AGSMapView *)mapView 
didEndTapAndHoldAtPoint:(CGPoint)screen 
	   mapPoint:(AGSPoint *)mappoint 
	   graphics:(NSDictionary *)graphics 
{
		NSLog(@"aa");
}
- (void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics 
{
	NSLog(@"bb");
}
- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
	AGSCompositeSymbol* composite = [AGSCompositeSymbol compositeSymbol];
	AGSSimpleMarkerSymbol* markerSymbol = [[AGSSimpleMarkerSymbol alloc] init];
	markerSymbol.style = AGSSimpleMarkerSymbolStyleSquare;
	markerSymbol.color = [UIColor greenColor];
	[composite.symbols arrayByAddingObject:markerSymbol];
	AGSSimpleLineSymbol* lineSymbol = [[AGSSimpleLineSymbol alloc] init];
	lineSymbol.color= [UIColor   
					   colorWithRed:3.0/255   
					   green:177.0/255   
					   blue:1.0/255   
					   alpha:1] ;
	lineSymbol.width = 4;
	[composite.symbols arrayByAddingObject:lineSymbol];
	 AGSSimpleFillSymbol* fillSymbol = [[AGSSimpleFillSymbol alloc] init];
	fillSymbol.color =[UIColor   
					   colorWithRed:3.0/255   
					   green:177.0/255   
					   blue:1.0/255   
					   alpha:0.5];
	
	 [composite.symbols arrayByAddingObject:fillSymbol];
	 AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:composite];
	 _graphicsLayer.renderer = renderer;

	
	[_graphicsLayer addGraphic:[[AGSGraphic alloc] initWithGeometry:mappoint symbol:markerSymbol attributes:nil infoTemplateDelegate:nil]];
	[_graphicsLayer refresh];
	if (_selectTool == 1) {
		if (_numOfPoints == 0) 
		{			
			self.sketchGeometry= [[[AGSMutablePolyline alloc] initWithSpatialReference:_mapView.spatialReference] autorelease];
			AGSMutablePolyline *line = (AGSMutablePolyline*)self.sketchGeometry;
			[line addPathToPolyline];
			[line addPoint:mappoint toPath:0];
		}
		else  
		{
			
			
			AGSMutablePolyline *line = (AGSMutablePolyline*)self.sketchGeometry;
			[line addPoint:mappoint toPath:0];
			if (self.activeGraphic !=nil) {
				[_graphicsLayer removeGraphic:self.activeGraphic];
			}
			
			self.activeGraphic = [[AGSGraphic alloc] initWithGeometry:line symbol:lineSymbol attributes:nil infoTemplateDelegate:nil];
			[_graphicsLayer addGraphic:self.activeGraphic];
			[_graphicsLayer refresh];
			if (delegate != nil) {
                AGSGeometry *ppolyline = [_geoEngine projectGeometry:line toSpatialReference:[[AGSSpatialReference alloc] initWithWKID:102100]];
				[delegate LengthChanged:self length:[_geoEngine lengthOfGeometry:ppolyline]];
			}
		}
		_numOfPoints++;
		
	}else if (_selectTool == 2) {
		if (_numOfPoints == 0) 
		{
			self.sketchGeometry = [[[AGSMutablePolygon alloc] initWithSpatialReference:_mapView.spatialReference] autorelease];
			AGSMutablePolygon *polygon = (AGSMutablePolygon*)self.sketchGeometry;
			[polygon addRingToPolygon];
			[polygon addPoint:mappoint toRing:0];
			[polygon addPoint:mappoint toRing:0];
		}
		else 
		{
			AGSMutablePolygon *polygon = (AGSMutablePolygon*)self.sketchGeometry;
		//	[polygon addRingToPolygon];
			[polygon insertPoint:mappoint onRing:0 atIndex:_numOfPoints];
		
			
			if (self.activeGraphic !=nil) {
				[_graphicsLayer removeGraphic:self.activeGraphic];
			}
			
			self.activeGraphic = [[AGSGraphic alloc] initWithGeometry:polygon symbol:fillSymbol attributes:nil infoTemplateDelegate:nil];
			[_graphicsLayer addGraphic:self.activeGraphic];
			
			[_graphicsLayer refresh];
			if (_numOfPoints >1) {
				if (delegate != nil) {
					AGSGeometry *ppolygon = [_geoEngine projectGeometry:polygon toSpatialReference:[[AGSSpatialReference alloc] initWithWKID:102100]];
					[delegate AreaChanged:self area:[_geoEngine areaOfGeometry:[_geoEngine simplifyGeometry:ppolygon]]];
				}
			}
		}
		_numOfPoints++;
	}	
	
}


@end
