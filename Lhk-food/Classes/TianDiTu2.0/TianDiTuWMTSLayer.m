//
//  TiandituWMTSLayer_Vec.m
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile_MaY on 13-3-27.
//
//

#import "TianDiTuWMTSLayer.h"
#import "TianDiTuWMTSTileOperation.h"
#import "TianDiTuWMTSLayerInfo.h"
#import "TianDiTuWMTSLayerInfoDelegate.h"

#define kGetablility "%@?SERVICE=WMTS&REQUEST=getcapabilities"
@implementation TianDiTuWMTSLayer
-(AGSUnits)units{
	return _units;
}

-(AGSSpatialReference *)spatialReference{
	return _fullEnvelope.spatialReference;
}

-(AGSEnvelope *)fullEnvelope{
	return _fullEnvelope;
}

-(AGSEnvelope *)initialEnvelope{
	//Assuming our initial extent is the same as the full extent
	return _fullEnvelope;
}

-(AGSTileInfo*) tileInfo{
	return _tileInfo;
}

#pragma mark -
-(id)initWithLayerType:(TianDiTuLayerTypes) tiandituType LocalServiceURL:(NSString *)url error:(NSError**) outError{
    if (self = [super init]) {
        
        requestQueue = [[NSOperationQueue alloc] init];
        [requestQueue setMaxConcurrentOperationCount:6];
        /*get the currect layer info
         */
        layerInfo = [[TianDiTuWMTSLayerInfoDelegate alloc]getLayerInfo:tiandituType];
        layerInfo.layerType = tiandituType;
        if ([url isEqual:[NSNull null]]) {
            layerInfo.url = url;
        }

        layerInfo.localPath = url;
        AGSSpatialReference* sr = [AGSSpatialReference spatialReferenceWithWKID:layerInfo.srid];
        _fullEnvelope = [[AGSEnvelope alloc] initWithXmin:layerInfo.xMin
                                                     ymin:layerInfo.yMin
                                                     xmax:layerInfo.xMax
                                                     ymax:layerInfo.yMax
                                         spatialReference:sr];
        
        _tileInfo = [[AGSTileInfo alloc]
                     initWithDpi:layerInfo.dpi
                     format :@"PNG"
                     lods:layerInfo.lods
                     origin:layerInfo.origin
                     spatialReference :self.spatialReference
                     tileSize:CGSizeMake(layerInfo.tileWidth,layerInfo.tileHeight)
                     ];
        [_tileInfo computeTileBounds:self.fullEnvelope];
        [super layerDidLoad];
    }
    return self;
}

#pragma mark -
#pragma AGSTiledLayer (ForSubclassEyesOnly)
- (void)requestTileForKey:(AGSTileKey *)key{
    //Create an operation to fetch tile from local cache
	TianDiTuWMTSTileOperation *operation =
    [[TianDiTuWMTSTileOperation alloc] initWithTileKey:key
                                        TiledLayerInfo:layerInfo
                                                target:self
                                                action:@selector(didFinishOperation:)];
    
    
	//Add the operation to the queue for execution
    //[ [AGSRequestOperation sharedOperationQueue] addOperation:operation]; //you do bad things
    [requestQueue addOperation:operation];
    //[requestQueue autorelease];
}


- (void)cancelRequestForKey:(AGSTileKey *)key{
    //Find the OfflineTileOperation object for this key and cancel it
 /*   for(NSOperation* op in [AGSRequestOperation sharedOperationQueue].operations){
        if( [op isKindOfClass:[TianDiTuWMTSTileOperation class]]){
            TianDiTuWMTSTileOperation* offOp = (TianDiTuWMTSTileOperation*)op;
            if([offOp.tileKey isEqualToTileKey:key]){
                [offOp cancel];
            }
        }
    }*/
}

- (void) didFinishOperation:(TianDiTuWMTSTileOperation*)op {
    //... pass the tile's data to the super class
    [super setTileData: op.imageData  forKey:op.tileKey];
}

/*- (NSURL*)urlForTileKey:(AGSTileKey *)key
{
    NSString *baseUrl= [NSString stringWithFormat:@"%@?service=wmts&request=gettile&version=1.0.0&layer=%@&format=tiles&tilematrixset=%@&tilecol=%d&tilerow=%d&tilematrix=%d",layerInfo.url,layerInfo.layerName,layerInfo.tileMatrixSet,key.column,key.row,key.level+2];
    //NSLog(baseUrl);
    return [NSURL URLWithString:baseUrl];
}*/
#pragma mark -
- (void)dealloc {
	
	//[_fullEnvelope release];
	//[_tileInfo release];
    [super dealloc];
}

@end
