//
//  HistoryObject.h
//  MapViewDemo
//
//  Created by huwei on 11/29/12.
//
//

#import <Foundation/Foundation.h>

@interface HistoryObject : NSObject
{
    NSString *_historyName;
    NSInteger rowid;
}

@property (nonatomic, retain) NSString *historyName;
@property (nonatomic) NSInteger rowid;
@end