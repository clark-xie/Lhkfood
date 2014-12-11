//
//  WMTSmetadataParserDelegate.h
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile on 13-3-27.
//
//

#import <Foundation/Foundation.h>
@class AGSPoint;
@class AGSLOD;
@class AGSSpatialReference;
@class AGSTileInfo;
@class AGSEnvelope;
@interface WMTSmetadataParserDelegate : NSObject<NSXMLParserDelegate>{
@protected
	NSString *_currentElement;
	
	int _dpi;
	int _WKID;
	int _level;
	double _xmin, _ymin, _xmax, _ymax;
	double _resolution, _scale;
	int _startTileRow, _endTileRow, _startTileColumn, _endTileColumn;
	double _tileOriginX, _tileOriginY;
    
	CGSize _tileSize;
	CGFloat _tileWidth,  _tileHeight;
    
	NSString *_tileFormat;
    
	NSMutableString* _WKT;
	AGSPoint *_tileOrigin;
    
	AGSLOD *_lod;
	NSMutableArray *_lods;
    AGSSpatialReference *_spatialReference;
	
	AGSEnvelope* _fullEnvelope;
	AGSTileInfo* _tileCacheInfo;
	NSError* _error;
}
@property (nonatomic,strong,readwrite) NSString* currentElement;
@property (nonatomic,strong,readwrite) NSString* tileFormat;
@property (nonatomic,strong,readwrite) NSMutableString* WKT;
@property (nonatomic,strong,readwrite) AGSPoint* tileOrigin;
@property (nonatomic,strong,readwrite) AGSLOD* lod;
@property (nonatomic,strong,readwrite) NSMutableArray* lods;
@property (nonatomic,strong,readwrite) AGSSpatialReference* spatialReference;
@property (nonatomic,strong,readwrite) AGSEnvelope* fullEnvelope;
@property (nonatomic,strong,readwrite) AGSTileInfo* tileInfo;
@property (nonatomic,strong,readwrite) NSError* error;

@end
