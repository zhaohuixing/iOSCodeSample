//
//  NOMAddressMapAnnotation.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-07.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMAddressMapAnnotation.h"
#import "StringFactory.h"

@implementation NOMAddressMapAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    return m_Coordinate;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    NSString* szLat = @"";
    NSString* szLon = @"";
    
    if(0 <= m_Coordinate.latitude)
    {
        szLat = [NSString stringWithFormat:@"%@:%f N", [StringFactory GetString_LantitudeABV], m_Coordinate.latitude];
    }
    else
    {
        szLat = [NSString stringWithFormat:@"%@:%f S", [StringFactory GetString_LantitudeABV], fabs(m_Coordinate.latitude)];
    }
    if(0 <= m_Coordinate.longitude)
    {
        szLon = [NSString stringWithFormat:@"%@:%f E", [StringFactory GetString_LongitudeABV], m_Coordinate.longitude];
    }
    else
    {
        szLon = [NSString stringWithFormat:@"%@:%f W", [StringFactory GetString_LongitudeABV], fabs(m_Coordinate.longitude)];
    }
    
    NSString* szRet = [NSString stringWithFormat:@"%@; %@", szLat, szLon];
    
    return szRet;
}

// optional
- (NSString *)subtitle
{
    NSString* szLat = @"";
    
/*    if(0 <= m_Coordinate.longitude)
    {
        szLat = [NSString stringWithFormat:@"%@:%f E", [StringFactory GetString_LongitudeABV], m_Coordinate.longitude];
    }
    else
    {
        szLat = [NSString stringWithFormat:@"%@:%f W", [StringFactory GetString_LongitudeABV], fabs(m_Coordinate.longitude)];
    }*/
    
    return szLat;
}

-(void)SetCoordinate:(CLLocationCoordinate2D)coordinate
{
    m_Coordinate.latitude = coordinate.latitude;
    m_Coordinate.longitude = coordinate.longitude;
}


@end
