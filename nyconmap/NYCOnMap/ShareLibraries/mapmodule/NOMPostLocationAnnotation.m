//
//  NOMPostLocationAnnotation.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-06.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMPostLocationAnnotation.h"
#import "StringFactory.h"

@implementation NOMPostLocationAnnotation

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
    }
    
    return self;
}

-(int)GetAnnotationType
{
    return NOM_MAP_ANNOTATIONTYPE_PINLOCATION;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return m_Title;
}

// optional
- (NSString *)subtitle
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

@end
