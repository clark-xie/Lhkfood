//
//  ProvinceViewController.h
//  MapViewDemo
//
//  Created by huwei on 1/21/13.
//
//

#import "GCRetractableSectionController.h"

@interface ProvinceViewController : GCRetractableSectionController


@property (nonatomic, retain) NSArray* cityNames;
-(id)initWithArray:(NSArray*)arr;
@end
