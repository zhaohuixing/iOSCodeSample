//
//  NOMGEOPlanRouteLineSegment.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMGEOPlanRouteLineSegment.h"

@interface NOMGEOPlanRouteLineSegment ()
{
    NSString*           m_szID;
}
@end

@implementation NOMGEOPlanRouteLineSegment

-(id)initWithPolyline:(MKPolyline*)pline
{
    self = nil;
    
    if(pline != nil)
    {
        int nCount = pline.pointCount;
        MKMapPoint* pPoints = [pline points];
        self = [NOMGEOPlanRouteLineSegment polylineWithPoints:pPoints count:nCount];
        if(self != nil)
        {
            m_szID = nil;
        }
    }
    
    return self;
}

-(id)initWith:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint
{
    CLLocationCoordinate2D pts[2];
    pts[0].latitude = startPoint.latitude;
    pts[0].longitude = startPoint.longitude;
    pts[1].latitude = endPoint.latitude;
    pts[1].longitude = endPoint.longitude;
    self = [NOMGEOPlanRouteLineSegment polylineWithCoordinates:(CLLocationCoordinate2D *)pts count:2];
    if(self != nil)
    {
        m_szID = nil;
    }
    return self;
}

-(id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    self = (NOMGEOPlanRouteLineSegment *)[NOMGEOPlanRouteLineSegment polylineWithCoordinates:coords count:count];
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
