//
//  Commont.m
//  DigitHubei_IPad
//
//  Created by leadmap on 7/11/13.
//  Copyright (c) 2013 leadmap. All rights reserved.
//

#import "Commont.h"
#import <ArcGIS/ArcGIS.h>

@implementation Commont

//经纬度转墨卡托
+(CGPoint )lonLat2Mercator:(CGPoint ) lonLat
{
    CGPoint  mercator;
    double x = lonLat.x *20037508.34/180;
    double y = log(tan((90+lonLat.y)*M_PI/360))/(M_PI/180);
    y = y *20037508.34/180;
    mercator.x = x;
    mercator.y = y;
    return mercator ;
}
//墨卡托转经纬度
+(CGPoint )Mercator2lonLat:(CGPoint ) mercator
{
    CGPoint lonLat;
    double x = mercator.x/20037508.34*180;
    double y = mercator.y/20037508.34*180;
    y= 180/M_PI*(2*atan(exp(y*M_PI/180))-M_PI/2);
    lonLat.x = x;
    lonLat.y = y;
    return lonLat;
}
//经纬度转墨卡托
+(AGSEnvelope *)lonLat4Mercator:(AGSEnvelope *) env{
   
    double xmin = env.xmin *20037508.34/180;
    double xmax = env.xmax *20037508.34/180;
    double ymin = log(tan((90+env.ymin)*M_PI/360))/(M_PI/180);
    double ymax = log(tan((90+env.ymax)*M_PI/360))/(M_PI/180);
    ymin = ymin *20037508.34/180;
    ymax = ymax *20037508.34/180;
    AGSMutableEnvelope *newEnv =
    [AGSMutableEnvelope envelopeWithXmin:xmin
                                    ymin:ymin
                                    xmax:xmax
                                    ymax:ymax
                        spatialReference:env.spatialReference];
    return newEnv ;
}
//经纬度转墨卡托
+(AGSEnvelope *)Mercator4lonLat:(AGSEnvelope *) env{
    double xmin = env.xmin/20037508.34*180;
    double xmax = env.xmax/20037508.34*180;
    double ymin = env.ymin/20037508.34*180;
    double ymax = env.ymax/20037508.34*180;
    ymin= 180/M_PI*(2*atan(exp(ymin*M_PI/180))-M_PI/2);
    ymax= 180/M_PI*(2*atan(exp(ymax*M_PI/180))-M_PI/2);
    AGSMutableEnvelope *newEnv =
    [AGSMutableEnvelope envelopeWithXmin:xmin
                                    ymin:ymin
                                    xmax:xmax
                                    ymax:ymax
                        spatialReference:env.spatialReference];
    return newEnv ;
}

@end
