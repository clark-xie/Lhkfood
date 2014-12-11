//
//  MoreTableView.h
//  MapViewDemo
//
//  Created by huwei on 12/6/12.
//
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "RoundSearchView.h"
#import "KeyWordSearchView.h"

@interface MoreTableView : UIViewController<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate,MoreTableViewDelegate,KeyWordViewDelegate>{
    UITableView* _tableView;
    NSInteger _currentSection;
    NSInteger _currentRow;
    NSArray   *_category;
   __unsafe_unretained NSObject<MoreTableViewDelegate> * mdelegate;
   __unsafe_unretained NSObject<KeyWordViewDelegate> * kdelegate;
   __unsafe_unretained NSString *isKorM;
    
}
@property(nonatomic, retain) NSMutableArray* headViewArray;
@property(nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSArray   *category;
@property(nonatomic, assign) NSObject<MoreTableViewDelegate> * mdelegate;
@property(nonatomic, assign) NSObject<KeyWordViewDelegate> * kdelegate;
@property(nonatomic, assign) NSString *isKorM;
@end
