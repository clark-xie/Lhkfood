//
//  Commont.h
//  DigitHubei_IPad
//
//  Created by huwei on 7/11/13.
//  Copyright (c) 2013 huwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commont : NSObject

+(CGPoint )lonLat2Mercator:(CGPoint ) lonLat;
+(CGPoint )Mercator2lonLat:(CGPoint ) mercator;
+(AGSEnvelope *)lonLat4Mercator:(AGSEnvelope *) env;
+(AGSEnvelope *)Mercator4lonLat:(AGSEnvelope *) env;
@end
