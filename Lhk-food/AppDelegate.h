//
//  AppDelegate.h
//  DigitHubei_IPad
//
//  Created by leadmap on 7/9/13.
//  Copyright (c) 2013 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class MapDownLoadManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *navigationController;
    ViewController *_viewController;
    MapDownLoadManager * _mapDownLoadManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) ViewController *viewController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain)MapDownLoadManager * mapDownLoadManager;
@end
