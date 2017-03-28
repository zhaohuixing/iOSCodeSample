//
//  NOMGEOPlanPolygon.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMGEOPlanPolygon.h"

@interface NOMGEOPlanPolygon ()
{
    NSString*           m_szID;
}

@end

@implementation NOMGEOPlanPolygon

- (id)initWithPoints:(MKMapPoint *)points count:(NSUInteger)count
{
    self = (NOMGEOPlanPolygon *)[NOMGEOPlanPolygon polygonWithPoints:points count:count];
    if(self != nil)
    {
        m_szID = nil;
    }
    return self;
}

- (id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    self = (NOMGEOPlanPolygon *)[NOMGEOPlanPolygon polygonWithCoordinates:coords count:count];
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
