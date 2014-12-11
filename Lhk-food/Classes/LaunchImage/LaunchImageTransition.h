//
//  LaunchImageTransition.h
//  Created by http://github.com/iosdeveloper
//

#import <UIKit/UIKit.h>
#define degreesToRadians(x) (M_PI*(x)/180.0)
@interface LaunchImageTransition : UIViewController {
	
}

- (id)initWithViewController:(UIViewController *)controller animation:(UIModalTransitionStyle)transition;
- (id)initWithViewController:(UIViewController *)controller animation:(UIModalTransitionStyle)transition delay:(NSTimeInterval)seconds;

@end