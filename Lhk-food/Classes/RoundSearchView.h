//
//  RoundSearchView.h
//  MapViewDemo
//
//  Created by 磊 李 on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "ViewController.h"
@class ASIHTTPRequest;

@protocol MoreTableViewDelegate
// 必选方法
- (void)passValue:(NSString *)name classCode:(NSString*)code;
// 可选方法
@optional

@end

@interface RoundSearchView : UITableViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,MoreTableViewDelegate>
{
    IBOutlet UIView *tableHeaderView;
    IBOutlet UILabel *myLocation;
    NSString *_searchContent;
    NSString *_strLocation;
    NSArray *_cates;
    AGSEnvelope *_curEnvelope;
    ASIHTTPRequest *requests;
    UISearchBar * _searchBar;
    AGSGraphic *_curGraphic;
    NSArray *_results;
    ViewController *_mainView;
    NSString *_searchCode;
    NSString *_keyword;
    NSString *_keycode;
    AGSPoint *_centerPoint;
    int _count;
}
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UILabel *myLocation;
@property (nonatomic, retain) NSString *strLocation;
@property (nonatomic, retain) NSString *searchContent;
@property (strong, nonatomic) NSArray *cates;
@property (strong, nonatomic) NSArray *results;
@property (nonatomic,retain)		   AGSEnvelope *curEnvelope;
@property (nonatomic, retain) IBOutlet UISearchBar * searchBar;
@property (nonatomic,retain) AGSGraphic *curGraphic;
@property (nonatomic,retain)		  ASIHTTPRequest *requests;
@property (nonatomic, retain)  ViewController *mainView;
@property (nonatomic, assign)  int count;
-(void)putEnvelope:(AGSEnvelope*)env;
-(void)putGraphic:(AGSGraphic*)graphic;
-(void)doRoundSearch:(AGSEnvelope*)env keyWord:(NSString*)keyword condition:(NSString*)where;
@end
