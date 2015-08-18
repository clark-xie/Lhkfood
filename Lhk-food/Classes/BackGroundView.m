//
//  BackGroundView.m
//  MapViewDemo
//
//  Created by leadmap on 11/27/12.
//
//

#import "BackGroundView.h"
#import "ViewController.h"

@interface BackGroundView ()

@end

@implementation BackGroundView


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
    UIBarButtonItem* searchBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    UIBarButtonItem* listbtn = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(listbtnClicked:)];
    [self.navigationItem setLeftBarButtonItem:searchBtn];
    [self.navigationItem setRightBarButtonItem:listbtn];
    
}
-(void)backBtnClicked:(id)sender
{
    ViewController *mainController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).viewController;
   [mainController.navigationController popViewControllerAnimated:YES];
   [mainController clearAllGarphics];
}

-(void)listbtnClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    //[self dismissOverViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
