//
//  YHCPickerView.h
//  TestDB
//
//  Created by Yashesh Chauhan on 01/10/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIDropDown.h"


@interface YHCPickerView : UIView<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate,NIDropDownDelegate>{
    
    UIPickerView *pickerView;
    UIToolbar *picketToolbar;
    UISearchBar *txtSearch;
    NSArray *arrRecords;
    UIActionSheet *aac;
    
    NSMutableArray *copyListOfItems;
    BOOL searching;
	BOOL letUserSelectRow;
    NSObject<NIDropDownDelegate> * delegate;
    NSInteger curIndex;
}


@property (nonatomic, retain) NSArray *arrRecords;
@property (nonatomic, retain) NSObject<NIDropDownDelegate> * delegate;

-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues;
-(void)showPicker:(NSString*)curSelect;
- (void)searchTableView;
-(void)btnDoneClick;
@end
