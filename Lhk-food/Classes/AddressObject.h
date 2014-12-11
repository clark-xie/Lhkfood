//
//  AddressObject.h
//  MapViewDemo
//
//  Created by huwei on 11/20/12.
//
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface AddressObject : NSObject
{
    NSString *_favoriteName;
    NSString *_name;
    NSString *_addrName;
    NSString *_x;
    NSString *_y;
    NSInteger rowid;
}

@property (nonatomic, retain) NSString *favoriteName;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *addrName;
@property (nonatomic, retain) NSString *x;
@property (nonatomic, retain) NSString *y;;
@property (nonatomic) NSInteger rowid;
@end
