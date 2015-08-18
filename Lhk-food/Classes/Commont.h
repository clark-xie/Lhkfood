//
//  Commont.h
//  DigitHubei_IPad
//
//  Created by leadmap on 7/11/13.
//  Copyright (c) 2013 leadmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commont : NSObject

+(CGPoint )lonLat2Mercator:(CGPoint ) lonLat;
+(CGPoint )Mercator2lonLat:(CGPoint ) mercator;
+(AGSEnvelope *)lonLat4Mercator:(AGSEnvelope *) env;
+(AGSEnvelope *)Mercator4lonLat:(AGSEnvelope *) env;
@end
