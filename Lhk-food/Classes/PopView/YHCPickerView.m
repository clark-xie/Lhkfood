//
//  YHCPickerView.m
//  TestDB
//
//  Created by Yashesh Chauhan on 01/10/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import "YHCPickerView.h"

@implementation YHCPickerView
@synthesize arrRecords,delegate;


-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrRecords = arrValues;
    }
    return self;
    
}
-(void)showPicker:(NSString*)curSelect{
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
    
    
    self.userInteractionEnabled = TRUE;
    self.backgroundColor = [UIColor clearColor];
    
    copyListOfItems = [[NSMutableArray alloc] init];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 280, 0)];
    
    //[picketView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    picketToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    picketToolbar.barStyle = UIBarStyleBlackOpaque;
    //[picketToolbar sizeToFit];
    
    txtSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 7, 240, 31)];
    txtSearch.tag = 1;
    txtSearch.barStyle = UIBarStyleBlackTranslucent;
    txtSearch.backgroundColor = [UIColor clearColor];
    txtSearch.delegate = self;
    txtSearch.userInteractionEnabled = TRUE;
    
    for (UIView *subview in txtSearch.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonSystemItemCancel  target:self action:@selector(btnDoneClick)];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel  target:self action:@selector(btnCancelClick)];
    //[picketToolbar addSubview:txtSearch];
    NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:btnCancel,flexible,btnDone, nil];
    [picketToolbar setItems:arrBarButtoniTems];
    [self addSubview:pickerView];
    [self addSubview:picketToolbar];
    curIndex = [self.arrRecords indexOfObject:curSelect];
    [pickerView selectRow:curIndex inComponent:0 animated:NO];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = NO;
	letUserSelectRow = NO;
    ////    if (pickerView) {
    ////        [pickerView removeFromSuperview];
    ////    }
    //    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    //    pickerView.showsSelectionIndicator = YES;
    //    pickerView.delegate = self;
    //    pickerView.dataSource = self;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
        
		searching = YES;
		letUserSelectRow = YES;
        
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;
        
	}
	
	[pickerView reloadAllComponents];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self btnDoneClick];
}

- (void) searchTableView {
	
	NSString *searchText = txtSearch.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
	
	for (NSString *sTemp in self.arrRecords)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0){
			[copyListOfItems addObject:sTemp];
        }
	}
    [pickerView reloadAllComponents];
	
	[searchArray release];
	searchArray = nil;
}

-(void)keyboardWillShowNotification:(id)sender{
    
    //pickerView.frame = CGRectMake(0, 44, 280, 216);
    //picketToolbar.frame = CGRectMake(0, 0, 280, 44);
}

-(void)keyboardWillHideNotification:(id)sender{
    
    //pickerView.frame = CGRectMake(0.0, 200, 280, 216);
    //picketToolbar.frame = CGRectMake(0, 156, 280, 44);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)btnCancelClick{
    [self removeFromSuperview];
}

-(void)btnDoneClick{
    
    NSString *strSelectedValue;
    
    strSelectedValue = [arrRecords objectAtIndex:[pickerView selectedRowInComponent:0]];
    [self.delegate selectedLength:strSelectedValue];
    
    [self removeFromSuperview];
    
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (searching) {
        return copyListOfItems.count;
    }else{
        return self.arrRecords.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (searching) {
        return [copyListOfItems objectAtIndex:row];
    }else{
        return [self.arrRecords objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

@end
