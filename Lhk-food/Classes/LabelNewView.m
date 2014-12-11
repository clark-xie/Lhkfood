//
//  LableNewView.m
//  MapViewDemo
//
//  Created by huwei on 12/11/12.
//
//

#import "LabelNewView.h"


@interface LabelNewView ()

@end

@implementation LabelNewView
@synthesize x=_x,y=_y,name=_name,level=_level;
@synthesize favoriteDb=_favoriteDb;
@synthesize mainController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked:)];
    [self.navigationItem setLeftBarButtonItem:barButton];
    [self.navigationItem setRightBarButtonItem:rightbtn];
    self.x.text = [NSString stringWithFormat:@"%f",curPoint.x];
    self.y.text = [NSString stringWithFormat:@"%f",curPoint.y];
    self.favoriteDb = [[SFavoriteDB alloc] init];
    self.mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
}

-(void)backButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)rightBtnClicked:(id)sender
{
    NSString * str=[self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![str isEqualToString:@""]) {
        LabelObject *label = [LabelObject new];
        label.Name = self.name.text;
        CGPoint pt;
        pt.x = [self.x.text floatValue];
        pt.y = [self.y.text floatValue];
        //pt = [Commont Mercator2lonLat:pt];
        label.X = [NSString stringWithFormat:@"%f",pt.x];
        label.Y = [NSString stringWithFormat:@"%f",pt.y];
        [self.favoriteDb saveLabel:label];
        [self dismissModalViewControllerAnimated:YES];
        [self.mainController loadAllLabels];
    }
    else
    {
        self.name.text = @"";
    }
}

-(void)putPoint:(AGSPoint*)point
{
    curPoint = point;
    
}
-(void)putLevel:(NSString*)lvl
{
    self.level.text = lvl;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.name becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
