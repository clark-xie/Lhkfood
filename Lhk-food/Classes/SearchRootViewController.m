//
//  SearchRootViewController.m
//  Lhk-food
//
//  Created by leadmap on 14/11/14.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "SearchRootViewController.h"
#import "MainViewController.h"
#import "ViewController.h"
@interface SearchRootViewController ()

@property MainViewController *mainViewController;
@property ViewController *mapViewController;

@end

@implementation SearchRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainViewController = [self.storyboard
                               instantiateViewControllerWithIdentifier:
                               @"mainViewControllerIdentity"];
    
    
    [self.view insertSubview:self.mainViewController.view atIndex:0];
    // Do view setup here.
}

- (IBAction)touchPress:(id)sender {
    
    //mapViewControllerIdentity
    
    [UIView beginAnimations:@"View Flip" context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (!self.mapViewController.view.superview) {
        if (!self.mapViewController) {
            self.mapViewController = [self.storyboard
                                         instantiateViewControllerWithIdentifier:@"mapViewControllerIdentity"];
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        [self.mainViewController.view removeFromSuperview];
        [self.view insertSubview:self.mapViewController.view atIndex:0];
//        self.barButtonItem.title = @"黄色";
        self.barButtonItem.image =[UIImage imageNamed:@"Nav_map"];
        //        [self.navigationController popViewControllerAnimated:NO];
        //
        //        [self.navigationController pushViewController:self.blueViewController animated:NO];
        
    } else {
        if (!self.mainViewController) {
            self.mainViewController = [self.storyboard
                                       instantiateViewControllerWithIdentifier:@"mainViewControllerIdentity"];
            
            //            self.blueViewController.view.frame = [CGRectMake
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:self.view cache:YES];
        [self.mapViewController.view removeFromSuperview];
//        [self.navigationController popViewControllerAnimated:NO];
        [self.view insertSubview:self.mainViewController.view atIndex:0];
        self.barButtonItem.image =[UIImage imageNamed:@"Nav_more"];

//        self.barButtonItem.title = @"绿色";
        
        //        [self.navigationController pushViewController:self.blueViewController animated:NO];
        
    }
    [UIView commitAnimations];
}
@end
