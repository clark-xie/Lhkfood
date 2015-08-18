//
//  ProvinceViewController.m
//  MapViewDemo
//
//  Created by leadmap on 1/21/13.
//
//

#import "ProvinceViewController.h"


@implementation ProvinceViewController
@synthesize cityNames;
-(id)initWithArray:(NSArray*)arr
{
    self.cityNames = arr;
}
#pragma mark -
#pragma mark Subclass

- (NSString *)title {
    return NSLocalizedString(@"湖北省",);
}

- (NSString *)titleContentForRow:(NSUInteger)row {
    NSDictionary *dict = [[self cityNames] objectAtIndex:row];
    return [dict objectForKey:@"name"];//[[self cityNames] objectAtIndex:row];
}

- (NSUInteger)contentNumberOfRow {
    return [[self cityNames] count];
}

- (void)didSelectContentCellAtRow:(NSUInteger)row {
    //Reaction to the selection
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

#pragma mark -
#pragma mark Getters

- (NSArray *)cityNames {
    if (cityNames == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Citys" withExtension:@"plist"];
        cityNames = [[NSArray arrayWithContentsOfURL:url] retain];
        //cityNames = [[NSArray alloc] initWithObjects:@"武汉市", @"黄石市", @"襄阳市", @"荆州市",@"宜昌市", @"黄冈市", @"十堰市", @"孝感市",@"荆门市", @"咸宁市", @"随州市", @"鄂州市",@"神农架市", @"恩施市", @"仙桃市", @"天门市",@"潜江市", nil];
    }
    return cityNames;
}
- (void)dealloc {
    [cityNames release];
    
    [super dealloc];
}

@end
