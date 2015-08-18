//
//  ResultViewCell.m
//  MapViewDemo
//
//  Created by leadmap on 11/22/12.
//
//

#import "ResultViewCell.h"
#import "AppDelegate.h"
#import "ViewController.h"

NSString *kResultViewCellId = @"ResultViewCellIdentifier";

@implementation ResultViewCell
@synthesize imageView;
@synthesize queryTitle ,queryCode;
@synthesize delegate;
@synthesize locateBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)putImageName:(NSString *)imagename
{
    UIImage* image=[UIImage imageNamed:imagename];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    [self.imageView setImage:image];
} 

-(IBAction)doLocation:(id)sender
{
   // if ([self.delegate respondsToSelector:@selector(customCell:didTapButton:)])
   // {
        [self.delegate performSelector:@selector(customCell:didTapButton:) withObject:self   withObject:self.locateBtn];
    //}
}

@end
