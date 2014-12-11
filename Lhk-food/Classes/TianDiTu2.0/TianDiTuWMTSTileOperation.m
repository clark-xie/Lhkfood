//
//  TiandituTileOperation.m
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile_MaY on 13-3-27.
//
//

#import "TianDiTuWMTSTileOperation.h"
#import "TianDiTuWMTSLayerInfoDelegate.h"
#define kURLGetTile @"%@?service=wmts&request=gettile&version=1.0.0&layer=%@&format=tiles&tilematrixset=%@&tilecol=%d&tilerow=%d&tilematrix=%d"

@implementation TianDiTuWMTSTileOperation
@synthesize tileKey=_tileKey;
@synthesize target=_target;
@synthesize action=_action;
@synthesize imageData = _imageData;
@synthesize layerInfo = _layerInfo;

- (id)initWithTileKey:(AGSTileKey *)tileKey TiledLayerInfo:(TianDiTuWMTSLayerInfo *)layerInfo target:(id)target action:(SEL)action{
	
	if (self = [super init]) {
		self.target = target;
		self.action = action;
		self.tileKey = tileKey;
		self.layerInfo = layerInfo;
	}
    return self;
}

-(void)main {
	//Fetch the tile for the requested Level, Row, Column
	@try {
        if (self.tileKey.level > self.layerInfo.maxZoomLevel ||self.tileKey.level < self.layerInfo.minZoomLevel) {
            return;
        }
        NSString *baseUrl;
        NSURL* aURL;
        NSData *data;
        // NSString *baseUrl= [NSString stringWithFormat:kURLGetTile,self.layerInfo.url,self.layerInfo.layerName,self.layerInfo.tileMatrixSet,self.tileKey.column,self.tileKey.row,(self.tileKey.level + 2)];
        if (![self.layerInfo.localPath isEqual:[NSNull null]]) {
        
            //得到湖北的数据
//            if (self.tileKey.level>13 && self.tileKey.level<17) {
//                baseUrl= [self getHubeiLocalTile];
//                // NSLog(@"%@",baseUrl);
//                self.imageData = [[NSData alloc] initWithContentsOfFile:baseUrl];
//            }
//            else if (self.tileKey.level>=17 && self.tileKey.level<20) {
//                baseUrl= [self getdishiTileURL];
//                aURL = [NSURL URLWithString:baseUrl];
//                data = [[NSData alloc] initWithContentsOfURL:aURL];
//                if([baseUrl isEqual:nil]||data.length ==1229 )
//               {
//                    baseUrl= [self getChinaLocalTile];
//                    self.imageData = [[NSData alloc] initWithContentsOfFile:baseUrl];
//                }
//                else{
//                    self.imageData = data;
//                }
//                
//                NSLog(@"%d",data.length);
//            }
//
//            else
            
            
            {
                baseUrl= [self getChinaLocalTile];
                // NSLog(@"%@",baseUrl);
                self.imageData = [[NSData alloc] initWithContentsOfFile:baseUrl];
            }
            //baseUrl= [self getChinaLocalTile];
            //self.imageData = [[NSData alloc] initWithContentsOfFile:baseUrl];
           // aURL = [NSURL URLWithString:baseUrl];
           // data = [[NSData alloc] initWithContentsOfURL:aURL];
           // self.imageData = [[NSData alloc] initWithContentsOfURL:aURL];
            //[data release];
        }
        else{
            
            //得到湖北的数据
//            if (self.tileKey.level >13 && self.tileKey.level<17) {
//                baseUrl= [self getHubeiTileURL];
//            }
//            else if (self.tileKey.level>=17 && self.tileKey.level<20) {
//                baseUrl= [self getdishiTileURL];
//                aURL = [NSURL URLWithString:baseUrl];
//                data = [[NSData alloc] initWithContentsOfURL:aURL];
//                if([baseUrl isEqual:nil]||data.length ==1229 )
//                {
//                    baseUrl= [self getChinaTileURL];
//                    // baseUrl =[NSString stringWithFormat:@"http://www.tianditu.cn/images/map/index/blankbg.gif"];
//                }
//                
//               // NSLog(@"%d",data.length);
//            }
//            else
            
            
            {
                baseUrl= [self getChinaTileURL];
            }
            aURL = [NSURL URLWithString:baseUrl];
            data = [[NSData alloc] initWithContentsOfURL:aURL];
            self.imageData = [[NSData alloc] initWithContentsOfURL:aURL];
            NSLog(@"当前显示级别:%d",self.tileKey.level);
           // [data release];
        }
        
        //NSLog(baseUrl);
		//NSURL* aURL = [NSURL URLWithString:baseUrl];
		//self.imageData = [[NSData alloc] initWithContentsOfURL:aURL];
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
	}
	@finally {
		//Invoke the layer's action method
		[_target performSelector:_action withObject:self];
	}
    
}


-(NSString*)getHubeiTileURL
{
    NSString *baseUrl= nil;
    if (self.layerInfo.layerType==8) {
        baseUrl = hubeiURLGetTile(@"http://113.57.161.161:8081/newmap/ogc/HBMAP/hbvector/wmts",@"hbvector",@"TileMatrixSet_0",(self.tileKey.level -14),self.tileKey.row,self.tileKey.column);
    }
    else if(self.layerInfo.layerType==9) {
        baseUrl = hubeiURLGetTile(@"http://113.57.161.161:8081/newmap/ogc/HBMAP/hbvectorlabel/wmts",@"hbvectorlabel",@"TileMatrixSet_0",(self.tileKey.level -14),self.tileKey.row,self.tileKey.column);
    }
    else if(self.layerInfo.layerType==11) {
        baseUrl = hubeiURLGetTile(@"http://113.57.161.161:8081/newmap/ogc/HBMAP/hbimage/wmts",@"hbimage",@"TileMatrixSet_0",(self.tileKey.level -14),self.tileKey.row,self.tileKey.column);
    }
    else if(self.layerInfo.layerType==12) {
        baseUrl = hubeiURLGetTile(@"http://113.57.161.161:8081/newmap/ogc/HBMAP/hbimagelabel/wmts",@"hbimagelabel",@"TileMatrixSet_0",(self.tileKey.level -14),self.tileKey.row,self.tileKey.column);
    }
    return baseUrl;
}

-(NSString*)getdishiTileURL
{
    NSString *baseUrl= nil;
    if (self.layerInfo.layerType==8) {
        baseUrl = hubeiURLGetTile(@"http://www.tiandituhubei.com/newmapserver4/ogc/city/ezhouVector/wmts",@"ezhouVector",@"TileMatrixSet_0",(self.tileKey.level -17),self.tileKey.row,self.tileKey.column);
    }
    else if(self.layerInfo.layerType==9) {
        //baseUrl = hubeiURLGetTile(@"http://www.tiandituhubei.com/newmapserver4/ogc/HBWMTS/hubeiVectorLabel/wmts",@"hubeiVectorLabel",@"TileMatrixSet_0",(self.tileKey.level -14),self.tileKey.row,self.tileKey.column);
    }
    else if(self.layerInfo.layerType==11) {
        baseUrl = hubeiURLGetTile(@"http://www.tiandituhubei.com/newmapserver4/ogc/EZWMTS/EZImage/wmts",@"hubeiImage",@"TileMatrixSet_0",(self.tileKey.level -17),self.tileKey.row,self.tileKey.column);
    }
    else if(self.layerInfo.layerType==12) {
        // baseUrl = hubeiURLGetTile(@"http://www.tiandituhubei.com/newmapserver4/ogc/HBWMTS/hubeiImageLabel/wmts",@"hubeiImageLabel",@"TileMatrixSet_0",(self.tileKey.level -14),self.tileKey.row,self.tileKey.column);
    }
    return baseUrl;
}


-(NSString *)getChinaTileURL{
    NSString *baseUrl= chinaURLGetTile(self.layerInfo.url,self.layerInfo.layerName,self.layerInfo.tileMatrixSet,self.tileKey.column,self.tileKey.row,(self.tileKey.level + 1));
    return baseUrl;
}

-(NSString *)getChinaLocalTile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
   // NSString *tileImagePath= NULL;
    
    NSString *hexCol = [NSString stringWithFormat:@"C%d.png",self.tileKey.column];
    
    NSString* baseUrl=NULL;
    NSString *path =@"china";
    NSString *chinaPath = [documentpath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
    
    if (![fileManager fileExistsAtPath:chinaPath]) {
        [fileManager createDirectoryAtPath:chinaPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (self.layerInfo.layerType==8)
    {
        chinaPath = [chinaPath stringByAppendingFormat:@"/%@Vector/Layers/_alllayers",path];
    }
    else if(self.layerInfo.layerType==9)
    {
        chinaPath = [chinaPath stringByAppendingFormat:@"/%@Anno/Layers/_alllayers",path];
    }
    else if (self.layerInfo.layerType ==11)
    {
        chinaPath = [chinaPath stringByAppendingFormat:@"/%@Image/Layers/_alllayers",path];
    }else if (self.layerInfo.layerType ==12)
    {
        chinaPath = [chinaPath stringByAppendingFormat:@"/%@ImageAnno/Layers/_alllayers",path];
    }
    
    if (![fileManager fileExistsAtPath:chinaPath])
    {
        [fileManager createDirectoryAtPath:chinaPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    chinaPath = [chinaPath stringByAppendingFormat:@"/L%d",self.tileKey.level+2];
    if (![fileManager fileExistsAtPath:chinaPath])
    {
        [fileManager createDirectoryAtPath:chinaPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    chinaPath = [chinaPath stringByAppendingFormat:@"/R%d",self.tileKey.row];
    if (![fileManager fileExistsAtPath:chinaPath])
    {
        [fileManager createDirectoryAtPath:chinaPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    chinaPath = [chinaPath stringByAppendingFormat:@"/%@",hexCol];
    
    //判断文件是否存在
    if ([fileManager fileExistsAtPath:chinaPath]) {
        //_tile.image = [[UIImage alloc] initWithContentsOfFile:chinaPath];
        return chinaPath;
    }
    else//如果没有
    {
        baseUrl= [self getChinaTileURL];
       // NSLog(@"国家切片地址%@",baseUrl);
        NSURL* aURL = [NSURL URLWithString:baseUrl];
        NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
        // NSLog(@"%lu",(unsigned long)data.length);
        if (data == nil||data.length==1229) {
            baseUrl =@"http://www.tianditu.cn/images/map/index/blankbg.gif";
            //aURL = [NSURL URLWithString:baseUrl];
           // data = [[NSData alloc] initWithContentsOfURL:aURL];
            return baseUrl;
        }
        else{
            [UIImagePNGRepresentation([UIImage imageWithData:data]) writeToFile:chinaPath options:NSAtomicWrite error:nil];
            //_tile.image = [UIImage imageWithData:data];
            return chinaPath;
        }
        //[data release];
        
    }
}
-(NSString *)getHubeiLocalTile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    //NSString *tileImagePath= NULL;
    
    NSString *hexCol = [NSString stringWithFormat:@"C%d.png",self.tileKey.column];
    
    NSString* baseUrl=NULL;
    NSString *path =@"hubei";
    NSString *hubeiPath = [documentpath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
    
    if (![fileManager fileExistsAtPath:hubeiPath]) {
        [fileManager createDirectoryAtPath:hubeiPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (self.layerInfo.layerType==8)
    {
        hubeiPath = [hubeiPath stringByAppendingFormat:@"/%@Vector/Layers/_alllayers",path];
    }
    else if(self.layerInfo.layerType==9)
    {
        hubeiPath = [hubeiPath stringByAppendingFormat:@"/%@Anno/Layers/_alllayers",path];
    }
    else if (self.layerInfo.layerType ==11)
    {
        hubeiPath = [hubeiPath stringByAppendingFormat:@"/%@Image/Layers/_alllayers",path];
    }else if (self.layerInfo.layerType ==12)
    {
        hubeiPath = [hubeiPath stringByAppendingFormat:@"/%@ImageAnno/Layers/_alllayers",path];
    }
    
    if (![fileManager fileExistsAtPath:hubeiPath])
    {
        [fileManager createDirectoryAtPath:hubeiPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    hubeiPath = [hubeiPath stringByAppendingFormat:@"/L%d",self.tileKey.level+1];
    if (![fileManager fileExistsAtPath:hubeiPath])
    {
        [fileManager createDirectoryAtPath:hubeiPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    hubeiPath = [hubeiPath stringByAppendingFormat:@"/R%d",self.tileKey.row];
    if (![fileManager fileExistsAtPath:hubeiPath])
    {
        [fileManager createDirectoryAtPath:hubeiPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    hubeiPath = [hubeiPath stringByAppendingFormat:@"/%@",hexCol];
    
    //判断文件是否存在
    if ([fileManager fileExistsAtPath:hubeiPath]) {
        //_tile.image = [[UIImage alloc] initWithContentsOfFile:chinaPath];
        return hubeiPath;
    }
    else//如果没有
    {
        baseUrl= [self getHubeiTileURL];
      //  NSLog(@"湖北切片地址%@",baseUrl);
        NSURL* aURL = [NSURL URLWithString:baseUrl];
        NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
        //NSLog(@"%lu",(unsigned long)data.length);
        if (data.length==1229) {
            return [self getChinaLocalTile];;
        }
        else{
            [UIImagePNGRepresentation([UIImage imageWithData:data]) writeToFile:hubeiPath options:NSAtomicWrite error:nil];
            //_tile.image = [UIImage imageWithData:data];
            return hubeiPath;
        }
        //[data release];
        
    }
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

@end
