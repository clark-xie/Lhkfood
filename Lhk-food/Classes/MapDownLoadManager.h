//
//  MapDownLoadManager.h
//  MapViewDemo
//
//  Created by huwei on 1/21/13.
//
//

#import <UIKit/UIKit.h>
#import "MapDownManagerView.h"
#import "MapDownViewController.h"

@interface MapDownLoadManager : UIViewController
{
    UISegmentedControl *_segmentedController;
    MapDownManagerView *_mapDownManagerView;
    MapDownViewController *_mapDownViewController;
}
@property (nonatomic, retain) UISegmentedControl *segmentedController;
@property (nonatomic, retain) MapDownManagerView *mapDownManagerView;
@property (nonatomic, retain) MapDownViewController *mapDownViewController;
@end
