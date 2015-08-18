//
//  ResultViewCell.h
//  MapViewDemo
//
//  Created by leadmap on 11/22/12.
//
//

#import <UIKit/UIKit.h>

extern NSString *kResultViewCellId;
@class ResultViewCell;
//声明表格委托
@protocol CustomCellDelegate
- (void)cunstomCell:(ResultViewCell *)cell didTapButton:(UIButton *)button;
@optional

@end
@interface ResultViewCell : UITableViewCell<CustomCellDelegate>
{
    IBOutlet UIImageView* imageView;
    IBOutlet UILabel  *queryTitle;
    IBOutlet UILabel *queryCode;
    IBOutlet UIButton *locateBtn;
    __unsafe_unretained NSObject<CustomCellDelegate> * delegate; 
}
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UILabel  *queryTitle;
@property (nonatomic, retain) IBOutlet UILabel *queryCode;
@property (nonatomic, retain) IBOutlet UIButton *locateBtn;
@property(nonatomic, assign) NSObject<CustomCellDelegate> * delegate;
-(void)putImageName:(NSString*)imagename;
-(IBAction)doLocation:(id)sender;
@end
