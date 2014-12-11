//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@class NIDropDown;
@class  ViewController;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
-(void) selectedLength:(NSString *)text;
@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    NSString *_isKorR;
    NSArray *_dataSet;
    NSArray *_alldataSet;
    UILabel *_lblPage;
    NSMutableArray *_multiPoint;
    UIButton *_preBtn;
    UIButton *_nextBtn;
    UIButton *_lengthBtn;
    NSMutableArray * lengthsArray;
    UIPickerView *pickerView;
    UIToolbar *picketToolbar;
    NSString *_curSeleted;
    NSString *_keyWord;
    NSString *_keyCode;
    AGSPoint *_centerPoint;
    UITableView *_table;
    NSString *selected;
    NSString *mapPoint;
    NSString *KorR;
    int _count;
    int _selectcount;
    BOOL _hidden;
    UITextField *_textField;
}
@property(nonatomic, retain) UITableView *table;
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *isKorR;
@property (nonatomic) NSInteger curPage;
@property (nonatomic, retain) NSArray *dataSet;
@property (nonatomic, retain) UILabel *lblPage;
@property (nonatomic, retain) NSMutableArray *multiPoint;
@property (nonatomic, retain) ViewController *mainController;
@property (nonatomic, retain) UIButton *preBtn;
@property (nonatomic, retain) UIButton *nextBtn;
@property (nonatomic, retain) UIButton *lengthBtn;
@property (nonatomic, retain) NSString *keyWord;
@property (nonatomic, retain) NSString *keyCode;
@property (nonatomic, retain) AGSPoint *centerPoint;
@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) AGSPoint *mapPoint;
@property (nonatomic, retain) NSString *KorR;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int selectcount;
@property (nonatomic, assign) BOOL _hidden;
@property (nonatomic, retain) UITextField *textField;

-(void)hideDropDown:(UIButton *)b;
-(void)showDropDown:(UIButton *)b;
- (id)initDropDown:(UIButton *)b:(NSArray *)arr :(NSString*)key :(NSString*)select :(int)count;
-(void)putKorR:(NSString*)key;
-(void)putKeyWord:(NSString *)keyword;
-(void)putKeyCode:(NSString *)keycode;
-(void)putMapPont:(AGSPoint *)point;
-(void)putSelect:(NSString *)select;
@end
