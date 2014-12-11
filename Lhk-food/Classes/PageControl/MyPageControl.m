//
//  MyPageControl.m
//  NewPageControl
//
//  Created by Miaohz on 11-8-31.
//  Copyright 2011 Etop. All rights reserved.
//

#import "MyPageControl.h"

@interface MyPageControl(private)

- (void) updateDots;
//- (void) updateDotsColor;

@end


@implementation MyPageControl

@synthesize imagePageStateNormal;
@synthesize imagePageStateHightlighted;
//@synthesize pageStateNormal,pageStateHightlighted;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void) setImagePageStateNormal:(UIImage *)image
{
	[imagePageStateNormal release];
	imagePageStateNormal = [image retain];
	[self updateDots];
}

- (void) setImagePageStateHightlighted:(UIImage *)image
{
	[imagePageStateHightlighted release];
	imagePageStateHightlighted = [image retain];
	[self updateDots];
}
/*
-(void)setPageStateNormalColor:(UIColor *)color
{
    [pageStateNormal release];
    pageStateNormal = color;
    [self updateDotsColor];
}
-(void)setPageStateHightlightedColor:(UIColor *)color
{
    [pageStateHightlighted release];
	pageStateHightlighted = color;
    [self updateDotsColor];
}*/
- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	[self updateDots];
    //[self updateDotsColor];
}

- (void) updateDots
{
	if (imagePageStateNormal || imagePageStateHightlighted) {
		NSArray *subView = self.subviews;
		
		for (int i = 0; i < [subView count]; i++) {
            //if ([[subView objectAtIndex:i] isMemberOfClass:[UIImageView class]]) {
                UIImageView *dot = [subView objectAtIndex:i];
                //dot.image = (self.currentPage == i ? imagePageStateHightlighted : imagePageStateNormal);
            //}
		}
	}
}
/*
- (void) updateDotsColor
{
	if (pageStateNormal || pageStateHightlighted) {
		NSArray *subView = self.subviews;
		
		for (int i = 0; i < [subView count]; i++) {
			UIImageView *dot = [subView objectAtIndex:i];
			dot.backgroundColor = (self.currentPage == i ? pageStateHightlighted : pageStateNormal);
		}
	}
}*/
- (void)dealloc {
	[imagePageStateNormal release];
	imagePageStateNormal = nil;
	[imagePageStateHightlighted release];
	imagePageStateHightlighted = nil;
    [super dealloc];
}


@end
