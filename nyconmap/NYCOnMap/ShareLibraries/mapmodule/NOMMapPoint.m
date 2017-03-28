//
//  NOMMapPoint.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-03.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMMapPoint.h"

@interface NOMMapPoint ()
{
    CLLocationCoordinate2D      m_Coordinate;
}

@end

@implementation NOMMapPoint

@synthesize coordinate = m_Coordinate;

-(id)initWithLatitude:(CLLocationDegrees)lat withLongitude:(CLLocationDegrees)lon
{
    self = [super init];
    
    if(self != nil)
    {
        m_Coordinate.latitude = lat;
        m_Coordinate.longitude = lon;
    }
    
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    
    if(self != nil)
    {
        m_Coordinate.latitude = coordinate.latitude;
        m_Coordinate.longitude = coordinate.longitude;
    }
    
    return self;
}

@end
