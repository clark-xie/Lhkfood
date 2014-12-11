//
//  MyPageControl.h
//  NewPageControl
//
//  Created by Miaohz on 11-8-31.
//  Copyright 2011 Etop. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyPageControl : UIPageControl {
	UIImage *imagePageStateNormal;
	UIImage *imagePageStateHightlighted;
    //UIColor *pageStateNormal;
    //UIColor *pageStateHightlighted;
}

- (id) initWithFrame:(CGRect)frame;

@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHightlighted;
//@property (nonatomic, retain) UIColor *pageStateNormal;
//@property (nonatomic, retain) UIColor *pageStateHightlighted;

@end
