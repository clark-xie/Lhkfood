//
//  LaunchImageTransition.m
//  Created by http://github.com/iosdeveloper
//

#import "LaunchImageTransition.h"

@implementation LaunchImageTransition

- (id)initWithViewController:(UIViewController *)controller animation:(UIModalTransitionStyle)transition {
	return [self initWithViewController:controller animation:transition delay:3.0];
}

- (id)initWithViewController:(UIViewController *)controller animation:(UIModalTransitionStyle)transition delay:(NSTimeInterval)seconds {
	self = [super init];
	
	if (self) {
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		
		NSString *launchImageFile = [infoDictionary objectForKey:@"NSMainNibFile"];
		
		NSString *launchImageFileiPhone = [infoDictionary objectForKey:@"UILaunchImageFile~iphone"];
		/*if ([launchImageFile isEqualToString:@"MainWindow"]) {
            UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingImage.png"]] autorelease];
            [image setFrame:CGRectMake(0, 0, 320, 460)];
            image.contentMode = UIViewContentModeScaleToFill;
			[self.view addSubview:image];
        }
        else if ([launchImageFile isEqualToString:@"MainWindow-iPad"]) {
            UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingImage-pad"]] autorelease];
            [image setFrame:CGRectMake(0, 0, 1024, 768)];
            image.contentMode = UIViewContentModeScaleToFill;
            //image.transform = CGAffineTransformIdentity;
           // image.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
			[self.view addSubview:image];
        }*/
        UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingImage-pad"]] autorelease];
        [image setFrame:CGRectMake(0, 0, 1024, 768)];
        UIInterfaceOrientation *intertface=[[UIApplication sharedApplication] statusBarOrientation];
        NSLog(@"@%",intertface);
        if (intertface == UIInterfaceOrientationLandscapeRight) {
            
            //image.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
        }
        else if(intertface==UIInterfaceOrientationLandscapeLeft){
            //[image setFrame:CGRectMake(0, 0, 768, 1024)];
            //image.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
        }
    

        image.contentMode = UIViewContentModeScaleToFill;
        //image.transform = CGAffineTransformIdentity;
        // image.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
        [self.view addSubview:image];

		/*if (launchImageFile != nil) {
			[self.view addSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImageFile]] autorelease]];
		} else if (launchImageFileiPhone != nil) {
			[self.view addSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImageFileiPhone]] autorelease]];
		} else {
            UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingImage.png"]] autorelease];
            [image setFrame:CGRectMake(0, 0, 320, 460)];
            image.contentMode = UIViewContentModeScaleToFill; 
			[self.view addSubview:image];
		}*/
		
		//[controller setModalTransitionStyle:transition];
		
		[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerFireMethod:) userInfo:controller repeats:NO];
	}
	
	return self;
}


- (void)timerFireMethod:(NSTimer *)theTimer {
	[self presentModalViewController:[theTimer userInfo] animated:YES];
}
- (NSUInteger) supportedInterfaceOrientations{
    
    return ( UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight );;
    
}

- (BOOL) shouldAutorotate {
    
    return YES;
    
}

@end