//
//  TestViewController.m
//  Lhk-food
//
//  Created by leadmap on 14/11/4.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property CLLocationManager *locationManager;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// We want to get and store a location measurement that meets the desired accuracy.
// For this example, we are going to use horizontal accuracy as the deciding factor.
// In other cases, you may wish to use vertical accuracy, or both together.
//
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // store all of the measurements, just so we can see what kind of data we might receive

    NSLog(@"new loction is%f",newLocation.coordinate.latitude);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
