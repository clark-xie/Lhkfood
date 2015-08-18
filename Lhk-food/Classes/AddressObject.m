//
//  AddressObject.m
//  MapViewDemo
//
//  Created by leadmap on 11/20/12.
//
//

#import "AddressObject.h"
#import <ArcGIS/ArcGIS.h>

@implementation AddressObject
@synthesize favoriteName=_favoriteName;
@synthesize name=_name;
@synthesize addrName=_addrName;
@synthesize x=_x;
@synthesize y=_y;
@synthesize rowid;

- (id)init {
    self = [super init];
    if (self)
    {
        
    }
    return self;
}
@end