//
//  NOMGEOPlanRect.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMGEOPlanRect.h"

@interface NOMGEOPlanRect ()
{
    NSString*           m_szID;
}

@end
@implementation NOMGEOPlanRect

- (id)initWithStart:(CLLocationCoordinate2D)startpoint end:(CLLocationCoordinate2D)endpoint
{
    CLLocationDegrees latMin = MIN(startpoint.latitude, endpoint.latitude);
    CLLocationDegrees latMax = MAX(startpoint.latitude, endpoint.latitude);
    CLLocationDegrees longMin = MIN(startpoint.longitude, endpoint.longitude);
    CLLocationDegrees longMax = MAX(startpoint.longitude, endpoint.longitude);
    
    CLLocationCoordinate2D pts[4];
    
    pts[0].latitude = latMin;
    pts[0].longitude = longMin;

    pts[1].latitude = latMin;
    pts[1].longitude = longMax;

    pts[2].latitude = latMax;
    pts[2].longitude = longMax;
    
    pts[3].latitude = latMax;
    pts[3].longitude = longMin;
    
    self = (NOMGEOPlanRect *)[NOMGEOPlanRect polygonWithCoordinates:(CLLocationCoordinate2D*)pts count:4];
    if(self != nil)
    {
        m_szID = nil;
    }
    return self;
}

-(void)SetID:(NSString*)overlayID
{
    m_szID = overlayID;
}

-(NSString*)GetID
{
    return m_szID;
}

@end
