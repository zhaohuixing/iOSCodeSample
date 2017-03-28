//
//  NOMGEOPlanLine.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-31.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMGEOPlanLine.h"

@interface NOMGEOPlanLine ()
{
    NSString*           m_szID;
}

@end

@implementation NOMGEOPlanLine

-(id)initWith:(MKMapPoint *)points withCount:(NSUInteger)count
{
    self = (NOMGEOPlanLine *)[NOMGEOPlanLine polylineWithPoints:points count:count];
    if(self != nil)
    {
        m_szID = nil;
    }
    return self;
}

-(id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    self = (NOMGEOPlanLine *)[NOMGEOPlanLine polylineWithCoordinates:coords count:count];
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
