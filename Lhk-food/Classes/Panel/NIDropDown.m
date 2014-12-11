//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "YHCPickerView.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "ResultViewCell.h"
#import "Commont.h"

#define NUMBERS @"123456789 \n"
@interface NIDropDown ()

@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@end

@implementation NIDropDown
@synthesize table=_table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;
@synthesize curPage;
@synthesize dataSet=_dataSet;
@synthesize lblPage=_lblPage;
@synthesize multiPoint=_multiPoint;
@synthesize mainController;
@synthesize preBtn=_preBtn,nextBtn=_nextBtn,lengthBtn=_lengthBtn;
@synthesize isKorR=_isKorR;
@synthesize keyCode=_keyCode,keyWord=_keyWord;
@synthesize centerPoint=_centerPoint;
@synthesize count=_count;
@synthesize selectcount=_selectcount;
@synthesize textField = _textField;

- (id)initDropDown:(UIButton *)b:(NSArray *)arr :(NSString*)key :(NSString*)select :(int)count{
    btnSender = b;
    self = [super init];
    if (self) {
        // Initialization code
        self.hidden =NO;
        self.curPage =1;
        self.count = count;
        self.dataSet = arr;
        _alldataSet = arr;
        self.isKorR = key;
        _curSeleted = select;
        self.mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
        self.multiPoint = [[NSMutableArray alloc] init];
       // CGRect btn = b.frame;
        
        //self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, 0, 0);
        self.frame = CGRectMake(30, 120, 0, 0);
        //self.list = [NSArray arrayWithArray:arr];
        self.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.9;
        
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(5, 88, 0, 0)];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.layer.cornerRadius = 5;
        self.table.backgroundColor = [UIColor whiteColor];
        self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        //[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.frame = CGRectMake(30, 120, 280, 573);
        if([self.isKorR isEqualToString:@"R"])
        {
            self.table.frame = CGRectMake(5, 88, 270, 480);
        }
        else
        {
            self.table.frame = CGRectMake(5, 49, 270, 519);
        }
        
        //b.frame = CGRectMake(btn.origin.x+320-44, btn.origin.y, 44, 44);
        [b setBackgroundImage:[UIImage imageNamed:@"close_panel.png"] forState:UIControlStateNormal];
        [UIView commitAnimations];
        
        
        //[self addSubview:b];
        
        UIView *btnBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 88)] ;
        //UILabel *lable = [[[UILabel alloc] initWithFrame:CGRectMake(110, 0, 320, 44)] autorelease];
        self.preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.preBtn addTarget:self action:@selector(preBtnClicked) forControlEvents:UIControlEventTouchDown];
        //[preBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        [self.preBtn setBackgroundImage:[UIImage imageNamed:@"btn_prev_normal.png"] forState:UIControlStateNormal];
        [self.preBtn setFrame:CGRectMake(5, 5, 53, 33)];
        [btnBottom addSubview:self.preBtn];
        self.preBtn.hidden = YES;
        
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchDown];
        //[preBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_next_normal.png"] forState:UIControlStateNormal];
        [self.nextBtn setFrame:CGRectMake(213, 5, 53, 33)];
        [btnBottom addSubview:self.nextBtn];
        
        self.lblPage = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 80, 33)];
        //[preBtn addTarget:self action:@selector(didClearButton) forControlEvents:UIControlEventTouchDown];
        //[preBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        self.lblPage.text = [NSString stringWithFormat:@"第%d/%d页",self.curPage,[self getPage]];
        [btnBottom addSubview:self.lblPage];
        
        
        UIView *btnHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 39)] ;
        self.lengthBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.lengthBtn addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchDown];
        [self.lengthBtn setTitle:_curSeleted forState:UIControlStateNormal];
        //[lengthBtn setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
        
        
        [self.lengthBtn setFrame:CGRectMake(60, 8, 150, 30)];
        [btnHeader addSubview:self.lengthBtn];
        self.table.tableFooterView = btnBottom;
        if([self.isKorR isEqualToString:@"R"])
        {
            [self addSubview:btnHeader];
        }
        [self addSubview:self.table];
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 270, 40)] ;
        if([self.isKorR isEqualToString:@"R"])
        {
            bottomView.frame = CGRectMake(5, 45, 270, 40);
        }
        else
        {
            bottomView.frame = CGRectMake(5, 5, 270, 40);
        }
        bottomView.backgroundColor =[UIColor whiteColor];
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(130, 10, 53, 23)];
         self.textField.text=@"1";
         self.textField.borderStyle = UITextBorderStyleRoundedRect;
         self.textField.textAlignment = UITextAlignmentCenter;
         self.textField.keyboardType = UIKeyboardTypeNumberPad;
        //self.textField.returnKeyType =UIReturnKeyDefault;
        self.textField.clearsOnBeginEditing = YES;
         self.textField.delegate = self;
        [bottomView addSubview: self.textField];
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 80, 33)];
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(185, 5, 80, 33)];
        leftLabel.text = @"跳转到第";
        rightLabel.text = @"页";
        [bottomView addSubview:leftLabel];
        [bottomView addSubview:rightLabel];
        
        [self addSubview:bottomView];
        [b.superview addSubview:self];
    }
    [self loadCurPageGraphics];
    [self changeBtnState];
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;  {
    NSCharacterSet *cs;
    if(textField == self.textField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入有效数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return NO;
        }
        int num = [textField.text intValue];
        if (num>[self getPage]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"超过总页数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            textField.text=@"";
            return NO;

        }
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起[textField resignFirstResponder];
    //查一下resign这个单词的意思就明白这个方法了
    NSCharacterSet *cs;
    if(textField == self.textField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [textField.text isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入有效数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return NO;
        }
        int num = [textField.text intValue];
        if (num>[self getPage]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"超过总页数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            textField.text=@"";
            return NO;
            
        }
    }

    if ([textField.text intValue] ==0 ) {
        self.curPage =1;
        textField.text=@"1";
    }
    else{
        self.curPage = [textField.text intValue];
    }
    //self.curPage = [textField.text intValue];
    NSString *text;
    if ([_curSeleted isEqualToString:@"当前可视范围"]) {
        
        [self doRoundSearch:self.mainController.mapView.visibleAreaEnvelope keyWord:self.keyWord condition:self.keyCode curPage: self.curPage];
    }
    else{
        if ([_curSeleted isEqualToString:@"2000米"]) {
            text=@"2000";
        }
        else if([_curSeleted isEqualToString:@"3000米"])
        {
            text=@"3000";
        }
        else if([_curSeleted isEqualToString:@"4000米"])
        {
            text=@"4000";
        }
        else {
            text=@"5000";
        }
        //text = [text stringByReplacingOccurrencesOfString:@"米" withString:@""];
        double tempLength = [text doubleValue]*1/111194.872221777;
        AGSMutableEnvelope *newEnv =
        [AGSMutableEnvelope envelopeWithXmin:self.centerPoint.x-tempLength
                                        ymin:self.centerPoint.y-tempLength
                                        xmax:self.centerPoint.x+tempLength
                                        ymax:self.centerPoint.y+tempLength
                            spatialReference:self.centerPoint.spatialReference];
        [self doRoundSearch:newEnv keyWord:self.keyWord condition:self.keyCode curPage: self.curPage];
    }
    [self changeBtnState];
    [self.textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    
    return NO;
}

-(void)putKorR:(NSString*)key
{
    self.isKorR = key;
}

-(void)putKeyWord:(NSString *)keyword {
	self.keyWord = keyword;
}

-(void)putKeyCode:(NSString *)keycode {
	self.keyCode = keycode;
}

-(void)putMapPont:(AGSPoint *)point {
	self.centerPoint = point;
}
-(void)putSelect:(NSString *)select {
	_curSeleted = select;
}

-(void)showPicker
{
   
        lengthsArray = [[NSMutableArray alloc] init];
        [lengthsArray addObject:@"当前可视范围"];
        [lengthsArray addObject:@"2000米"];
        [lengthsArray addObject:@"3000米"];
        [lengthsArray addObject:@"4000米"];
        [lengthsArray addObject:@"5000米"];
    
    YHCPickerView *objYHCPickerView = [[YHCPickerView alloc] initWithFrame:CGRectMake(0, 270, 280, 270) withNSArray:lengthsArray];
    
    objYHCPickerView.delegate = (YHCPickerView*)self;
    [self addSubview:objYHCPickerView];
    [objYHCPickerView showPicker:_curSeleted];
    //self.lengthBtn.titleLabel.text = _curSeleted;
}

-(void)selectedLength:(NSString *)text
{
    [self.lengthBtn setTitle:text forState:UIControlStateNormal];
    _curSeleted = text;
    self.curPage =1;
    if ([text isEqualToString:@"当前可视范围"]) {
       
        [self doRoundSearch:self.mainController.mapView.visibleAreaEnvelope keyWord:self.keyWord condition:self.keyCode curPage: self.curPage];
    }
    else{
        if ([text isEqualToString:@"2000米"]) {
            text=@"2000";
        }
        else if([text isEqualToString:@"3000米"])
        {
            text=@"3000";
        }
        else if([text isEqualToString:@"4000米"])
        {
            text=@"4000";
        }
        else if([text isEqualToString:@"5000米"])
        {
            text=@"5000";
        }
        //text = [text stringByReplacingOccurrencesOfString:@"米" withString:@""];
        double tempLength = [text doubleValue]*1/111194.872221777;
        AGSMutableEnvelope *newEnv =
        [AGSMutableEnvelope envelopeWithXmin:self.centerPoint.x-tempLength
                                        ymin:self.centerPoint.y-tempLength
                                        xmax:self.centerPoint.x+tempLength
                                        ymax:self.centerPoint.y+tempLength
                            spatialReference:self.centerPoint.spatialReference];
        [self doRoundSearch:newEnv keyWord:self.keyWord condition:self.keyCode curPage: self.curPage];
    }
    
}
-(void)hideDropDown:(UIButton *)b {
    self.frame = CGRectMake(30, 120, 280, 573);
    if([self.isKorR isEqualToString:@"R"])
    {
        self.table.frame = CGRectMake(5, 88, 270, 480);
    }
    else
    {
        self.table.frame = CGRectMake(5, 49, 270, 519);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(30, 120, 0, 0);
    self.table.frame = CGRectMake(5, 89, 270, 0);
    //b.frame = CGRectMake(btn.origin.x-320+44, btn.origin.y, 44, 44);
    [b setBackgroundImage:[UIImage imageNamed:@"open_panel.png"] forState:UIControlStateNormal];
    [UIView commitAnimations];
    self.hidden = YES;
}
-(void)showDropDown:(UIButton *)b{
    self.frame = CGRectMake(30, 120, 0, 0);
     self.table.frame = CGRectMake(5, 44, 270, 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //self.frame = CGRectMake(30, 120, 0, 0);
    //self.table.frame = CGRectMake(5, 44, 270, 0);
    self.frame = CGRectMake(30, 120, 280, 573);
    if([self.isKorR isEqualToString:@"R"])
    {
        self.table.frame = CGRectMake(5, 88, 270, 480);
    }
    else
    {
        self.table.frame = CGRectMake(5, 49, 270, 519);
    }
    self.hidden = NO;
    //b.frame = CGRectMake(btn.origin.x-320+44, btn.origin.y, 44, 44);
    [b setBackgroundImage:[UIImage imageNamed:@"close_panel.png"] forState:UIControlStateNormal];
    [UIView commitAnimations];
}

-(void)preBtnClicked
{
    self.curPage = self.curPage -1;
    [self changeBtnState];
    NSString *text;
    if ([_curSeleted isEqualToString:@"当前可视范围"]) {
        
        [self doRoundSearch:self.mainController.mapView.visibleAreaEnvelope keyWord:self.keyWord condition:self.keyCode curPage:self.curPage];
    }
    else{
        if ([_curSeleted isEqualToString:@"2000米"]) {
            text=@"2000";
        }
        else if([_curSeleted isEqualToString:@"3000米"])
        {
            text=@"3000";
        }
        else if([_curSeleted isEqualToString:@"4000米"])
        {
            text=@"4000";
        }
        else {
            text=@"5000";
        }
        double tempLength = [text doubleValue]*1/111194.872221777;
        AGSMutableEnvelope *newEnv =
        [AGSMutableEnvelope envelopeWithXmin:self.centerPoint.x-tempLength
                                        ymin:self.centerPoint.y-tempLength
                                        xmax:self.centerPoint.x+tempLength
                                        ymax:self.centerPoint.y+tempLength
                            spatialReference:self.centerPoint.spatialReference];
        [self doRoundSearch:newEnv keyWord:self.keyWord condition:self.keyCode curPage:self.curPage];
    }
    
   // [self loadCurPageGraphics];
   // [self.table reloadData];
    
}
-(void)nextBtnClicked
{
    /*int m = fmod(self.dataSet.count, 10);
    int n = floor(self.dataSet.count/10);//取整
    if (m==0&&sel
     
     .curPage==n) {
        self.curPage = self.curPage;
    }
    else
    {
        self.curPage = self.curPage+1;
    }*/
    self.curPage = self.curPage+1;
    [self changeBtnState];
    
    //[self loadCurPageGraphics];
    //[self.table reloadData];
    NSString *text;
    if ([_curSeleted isEqualToString:@"当前可视范围"]) {
        
        [self doRoundSearch:self.mainController.mapView.visibleAreaEnvelope keyWord:self.keyWord condition:self.keyCode curPage:self.curPage];
    }
    else{
        if ([_curSeleted isEqualToString:@"2000米"]) {
            text=@"2000";
        }
        else if([_curSeleted isEqualToString:@"3000米"])
        {
            text=@"3000";
        }
        else if([_curSeleted isEqualToString:@"4000米"])
        {
            text=@"4000";
        }
        else {
            text=@"5000";
        }
        double tempLength = [text doubleValue]*1/111194.872221777;
        AGSMutableEnvelope *newEnv =
        [AGSMutableEnvelope envelopeWithXmin:self.centerPoint.x-tempLength
                                        ymin:self.centerPoint.y-tempLength
                                        xmax:self.centerPoint.x+tempLength
                                        ymax:self.centerPoint.y+tempLength
                            spatialReference:self.centerPoint.spatialReference];
        [self doRoundSearch:newEnv keyWord:self.keyWord condition:self.keyCode curPage:self.curPage];
    }
}
-(int)getPage{
    int n = floor(self.count/10);//取整
    int m = fmod(self.count, 10);//求余
    //int page=0;
    if (n==0) {
        return 1;
    }
    if (n==1&&m>=0) {
        return 1;
    }
    else if(n>1&&m==0){
        return n;
    }
    else if(n>1&&m>0)
    {
        return n+1;
    }
    
}
-(void)changeBtnState
{
    self.lblPage.text = [NSString stringWithFormat:@"第%d/%d页",self.curPage,[self getPage]];
    self.textField.text=[NSString stringWithFormat:@"%d",self.curPage];
    if (self.dataSet ==nil&&self.dataSet.count ==0) {
		
        self.curPage =0;
        [self.preBtn setHidden:YES];
        [self.nextBtn setHidden:YES];
	}
    else
    {
        int n = floor(self.count/10);//取整
        int m = fmod(self.count, 10);//求余
        if (n==0) {
            [self.preBtn setHidden:YES];
            [self.nextBtn setHidden:YES];
        }
        if (n==1&&m>=0) {
            
            [self.preBtn setHidden:YES];
            [self.nextBtn setHidden:YES];
        }
        else if(n>1&&m==0)
        {
            if (self.curPage==1) {
                [self.preBtn setHidden:YES];
                [self.nextBtn setHidden:NO];
            }
            else if (self.curPage>0&&self.curPage<n-1)
            {
                [self.preBtn setHidden:NO];
                [self.nextBtn setHidden:NO];
            }
            else if(self.curPage==n)
            {
                [self.preBtn setHidden:NO];
                [self.nextBtn setHidden:YES];
            }
        }
        else if(n>1&&m>0)
        {
            if (self.curPage==1) {
                [self.preBtn setHidden:YES];
                [self.nextBtn setHidden:NO];
            }
            else if (self.curPage>0&&self.curPage<n+1)
            {
                [self.preBtn setHidden:NO];
                [self.nextBtn setHidden:NO];
            }
            else if(self.curPage==n+1)
            {
                [self.preBtn setHidden:NO];
                [self.nextBtn setHidden:YES];
            }
        }
    }
}

-(void)loadCurPageGraphics
{
    AGSSimpleMarkerSymbol *symbol = nil;
    //[self.mainController.keyGraphicsLayer removeAllGraphics];
    [self.mainController clearAllGarphics];
    [self.multiPoint removeAllObjects];
     NSDictionary *feature = nil;
    for (int i=0; i<self.dataSet.count;i++) {
        if (i ==0) {
            //[cell.imageView setImage:[UIImage imageNamed:@"icon_marka.png"]];
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marka.png"]];
        }
        else if (i ==1) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markb.png"]];
        }
        else if (i ==2) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markc.png"]];    
        }
        else if (i ==3) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markd.png"]];
        }
        else if (i ==4) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marke.png"]];
        }
        else if (i ==5) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markf.png"]];
        }
        else if (i ==6) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markg.png"]];
        }
        else if (i ==7) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markh.png"]];
        }else if (i ==8) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marki.png"]];
        }
        else if (i ==9) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markj.png"]];
        }
      
       // NSInteger m = 10*(self.curPage-1)+i;
       // feature = [self.dataSet objectAtIndex:m];
        feature = [self.dataSet objectAtIndex:i];
        NSString *location = [feature objectForKey:@"location"];
        NSArray * array = [location componentsSeparatedByString: @","];
        CGPoint pt;
        pt.x=[array[1] floatValue];
        pt.y=[array[0] floatValue];

        AGSPoint * point =[AGSPoint pointWithX:pt.x
                                             y:pt.y
                              spatialReference:self.mainController.mapView.spatialReference];
        AGSGraphic *graphic =[AGSGraphic graphicWithGeometry:point
                                                      symbol:symbol
                                                  attributes:[feature mutableCopy]
                                        infoTemplateDelegate:mainController];
        [self.mainController.keyGraphicsLayer addGraphic:graphic];
        [self.multiPoint addObject:point];
    }
    
    [self.mainController.keyGraphicsLayer refresh];
}

-(NSInteger)getCurPageNum
{
    NSInteger num=0;
    if (self.dataSet ==nil&&self.dataSet.count ==0) {
		
        self.curPage =0;
        [self.preBtn setHidden:YES];
        [self.nextBtn setHidden:YES];
        num=0;
	}
    else
    {
        int n = floor(self.count/10);//取整
        int m = fmod(self.count, 10);//求余
        if (n==0&&m>=0) {
            
            [self.preBtn setHidden:YES];
            [self.nextBtn setHidden:YES];
            num = self.dataSet.count;
        }
        else if(n>0&&m==0)
        {
            if (self.curPage==1) {
                [self.preBtn setHidden:YES];
                [self.nextBtn setHidden:NO];
            }
            else if (self.curPage>0&&self.curPage<n-1)
            {
                [self.preBtn setHidden:NO];
                [self.nextBtn setHidden:NO];
            }
            else if(self.curPage==n)
            {
                [self.preBtn setHidden:NO];
                [self.nextBtn setHidden:YES];
            }
            
            num = 10;
        }
        else if(n>0&&m>0)
        {
            if (self.curPage==1) {
                [self.preBtn setHidden:YES];
                [self.nextBtn setHidden:NO];
                num = 10;
            }
            else if (self.curPage>0&&self.curPage<n+1)
            {
                [self.preBtn setHidden:NO];
                [self.nextBtn setHidden:NO];
                num = 10;
            }
            else if(self.curPage==n+1)
            {
                [self.preBtn setHidden:NO];
                [self.nextBtn setHidden:YES];
                num = m;
            }
        }
    }
    return num;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSet.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResultViewCell *cell = (ResultViewCell*)[tableView dequeueReusableCellWithIdentifier:kResultViewCellId];
    if (cell == nil)
    {
        NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"ResultViewCell" owner:self options:nil];
        //NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ResultViewCell" owner:self options:nil];
        cell = [cells objectAtIndex:0];
        //cell.delegate = self;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_icon_enter_map.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(230.0f, 8.0f, 25.0f, 25.0f);
    button.tag = indexPath.row;
    [cell addSubview:button];
    
    if (self.dataSet.count>0) {
        NSDictionary *feature = nil;
        
        AGSSimpleMarkerSymbol *symbol = nil;
        if (indexPath.row ==0) {
            //[cell.imageView setImage:[UIImage imageNamed:@"icon_marka.png"]];
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marka.png"]];
            [cell putImageName:@"icon_marka.png"];
        }
        else if (indexPath.row ==1) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markb.png"]];
            [cell  putImageName:@"icon_markb.png"];
        }
        else if (indexPath.row ==2) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markc.png"]];
            [cell  putImageName:@"icon_markc.png"];
        }
        else if (indexPath.row ==3) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markd.png"]];
            [cell  putImageName:@"icon_markd.png"];
        }
        else if (indexPath.row ==4) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marke.png"]];
            [cell  putImageName:@"icon_marke.png"];
        }
        else if (indexPath.row ==5) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markf.png"]];
            [cell  putImageName:@"icon_markf.png"];
        }
        else if (indexPath.row ==6) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markg.png"]];
            [cell  putImageName:@"icon_markg.png"];
        }
        else if (indexPath.row ==7) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markh.png"]];
            [cell  putImageName:@"icon_markh.png"];
        }else if (indexPath.row ==8) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_marki.png"]];
            [cell  putImageName:@"icon_marki.png"];
        }
        else if (indexPath.row ==9) {
            symbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"icon_markj.png"]];
            [cell  putImageName:@"icon_markj.png"];
        }
       //NSInteger m = 10*(self.curPage-1)+indexPath.row;
        feature = [self.dataSet objectAtIndex:indexPath.row];
        cell.queryTitle.text = [feature  valueForKey:@"name"];
        cell.queryCode.text = [feature valueForKey:@"addr"];
    }
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }*/
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    //[btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate niDropDownDelegateMethod:self];
}


- (void)didTapButton:(UIButton *)sender
{
    /*
     CGRect buttonRect = sender.frame;
     for (ResultViewCell *cell in [self.tableView visibleCells])
     {
     if (CGRectIntersectsRect(buttonRect, cell.frame))
     {
     //cell就是所要获得的
     int n=0;
     n = cell.tag;
     }
     }*/
    //ResultViewCell *owningCell = (ResultViewCell*)[sender superview];
    //NSIndexPath *pathToCell = [self.table indexPathForCell:owningCell];
    int n=0;
    //n = pathToCell.row;
    n = sender.tag;
    [self.mainController zoomToPoint:[self.multiPoint objectAtIndex:n] withLevel:12];
    
    //[self.mainController dismissViewControllerAnimated:YES completion:^{}];
}

-(void)doRoundSearch:(AGSEnvelope*)env keyWord:(NSString*)keyword condition:(NSString*)where curPage:(int)page
{
    [DejalBezelActivityView activityViewForView:self.mainController.view withLabel:@"数据加载中"];
    CGPoint pt1,pt2;
    pt1.x=env.xmin;
    pt1.y=env.ymin;
    pt2.x=env.xmax;
    pt2.y=env.ymax;
    //pt1 = [Commont Mercator2lonLat:pt1];
    //pt2 = [Commont Mercator2lonLat:pt2];
    NSString *xmin = [[NSString alloc] initWithFormat:@"%f",pt1.x];
    NSString *ymin = [[NSString alloc] initWithFormat:@"%f",pt1.y];
    NSString *xmax = [[NSString alloc] initWithFormat:@"%f",pt2.x];
    NSString *ymax = [[NSString alloc] initWithFormat:@"%f",pt2.y];

    NSString *contion = nil;
    /* if (where!=nil&&![where isEqualToString:@""]) {
     NSRange r;
     r.location=2;
     r.length=4;
     NSString *str = [where substringWithRange:r];
     if([str isEqualToString:@"0000"])
     {
     where = [NSString stringWithFormat:@"yjbm:%@",where];
     }
     else{
     where = [NSString stringWithFormat:@"ejbm:%@",where];
     }
     contion = [NSString stringWithFormat:@"{%@",where];
     }
     if (keyword!=NULL)
     {
     keyword=[NSString stringWithFormat:@"type:%@",keyword];
     contion = [contion stringByAppendingFormat:@",%@}",keyword];
     }
     else{
     contion = [contion stringByAppendingFormat:@"}"];
     }
     */
    if (keyword!=NULL)
    {
        contion = [NSString stringWithFormat:@"%@ %@",where,keyword];
    }
    else{
        contion = [NSString stringWithFormat:@"%@",where];
    }
    
    NSString *params =RoundSearch(contion,ymin,xmin,ymax,xmax,(page-1)*10);
    NSLog(@"请求地址:%@",params);
    //URLS = [URLS stringByAppendingString:params];
    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urls = [NSURL URLWithString:params];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urls];
    [request setDelegate:self];
    // Start the request
    [request startSynchronous];
    
    //[self showQueryResult];
}
#pragma 网络请求委托
// 成功回调函数
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    if (responseData) {
        NSDictionary *resultsDictionary = [responseData objectFromJSONData];
        if (resultsDictionary!=nil) {
            self.dataSet = (NSArray*)[resultsDictionary objectForKey:@"list"];
            self.count = [(NSString*)[resultsDictionary objectForKey:@"count"] intValue];
            NSLog(@"结果数目:%@",(NSString*)[resultsDictionary objectForKey:@"count"]);
            if (self.dataSet.count>0) {
                
                self.mainController.results = self.dataSet;
                self.mainController.count = self.count;
                [self loadCurPageGraphics];
                [self.table reloadData];
                [self changeBtnState];
            } 
        }
        else
        {
            [DejalBezelActivityView activityViewForView:self.mainController.view withLabel:@"没有找到任何结果!"];
            NSLog(@"没有结果！");
        }
        [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:1.0];
    }
    
}
// 失败回调函数
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [self performSelector:@selector(changeActivityView) withObject:nil afterDelay:2.0];
}
- (void)changeActivityView;
{
    [DejalBezelActivityView activityViewForView:self.mainController.view withLabel:@"网络连接错误！"];
    [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:0.5];
    
}
-(void)removeActivityView
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

-(void)dealloc {
    [super dealloc];
    [self.table release];
    self.dataSet = nil;
    [self.dataSet release];
    [self release];
}

@end
