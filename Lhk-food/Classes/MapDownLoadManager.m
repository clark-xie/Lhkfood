//
//  MapDownLoadManager.m
//  MapViewDemo
//
//  Created by leadmap on 1/21/13.
//
//

#import "MapDownLoadManager.h"
#import "MapDownManagerView.h"
#import "MapDownViewController.h"

@interface MapDownLoadManager ()
@property (retain, nonatomic) IBOutlet UIView *tableViewContainer;

@end

@implementation MapDownLoadManager
@synthesize segmentedController=_segmentedController;
@synthesize mapDownManagerView=_mapDownManagerView;
@synthesize mapDownViewController=_mapDownViewController;

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
    //[self.navigationController setToolbarHidden:NO];
    NSArray *array = [NSArray arrayWithObjects:@"离线地图",@"下载管理", nil];
    self.segmentedController = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentedController.segmentedControlStyle = UISegmentedControlSegmentCenter;
    
    [self.segmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
    self.navigationItem.titleView = self.segmentedController;
    self.segmentedController.selectedSegmentIndex = 0;
    // [array release];
    UIBarButtonItem* searchBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    [self.navigationItem setLeftBarButtonItem:searchBtn];
    
    self.mapDownManagerView =  [[MapDownManagerView alloc] initWithNibName:@"MapDownManagerView" bundle:nil];
    //self.mapDownManagerView.edgesForExtendedLayout = UIRectEdgeNone;
    self.mapDownViewController =  [[MapDownViewController alloc] initWithNibName:@"MapDownViewController" bundle:nil];
    //self.mapDownViewController.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableViewContainer addSubview:self.mapDownManagerView.view];
    [self.tableViewContainer addSubview:self.mapDownViewController.view];
}

-(void)backBtnClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


-(void)segmentAction:(id)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            self.mapDownManagerView.view.hidden=YES;
            self.mapDownViewController.view.hidden=NO;
        }
            break;
        case 1:
        {
            self.mapDownManagerView.view.hidden=NO;
            [self.mapDownManagerView refreshTable];
            self.mapDownViewController.view.hidden=YES;
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
