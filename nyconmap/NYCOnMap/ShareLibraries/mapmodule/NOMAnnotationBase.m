//
//  NOMAnnotationBase.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-05.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMAnnotationBase.h"

@implementation NOMAnnotationBase

@synthesize coordinate = m_Coordinate;

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Title = @"";
        m_CountryCode = @"__";
        m_City = @"__";
        m_Community = @"__";
    }
    
    return self;
}

-(void)UpdateLocationCountryCode
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc]
                            initWithLatitude:m_Coordinate.latitude longitude:m_Coordinate.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"NOMAnnotationBase reverseGeocodeLocation:completionHandler: Completion Handler called!");
         
         if (error)
         {
             NSLog(@"NOMAnnotationBase Geocode failed with error: %@", error);
             m_CountryCode = @"__";
             return;
         }
         if(placemarks && placemarks.count > 0)
         {
             //do something
             CLPlacemark *topResult = [placemarks objectAtIndex:0];
             m_CountryCode = [topResult ISOcountryCode];
             m_City = [topResult locality];
             m_Community = [topResult subLocality];
         }
     }];
}

-(int)GetAnnotationType
{
    return NOM_MAP_ANNOTATIONTYPE_NONE;
}

-(CLLocationCoordinate2D)GetCoordinate
{
    return m_Coordinate;
}

-(void)SetCoordinate:(CLLocationCoordinate2D)coordinate
{
    m_Coordinate.latitude = coordinate.latitude;
    m_Coordinate.longitude = coordinate.longitude;
    [self UpdateLocationCountryCode];
}

-(void)SetCoordinate:(double)longitude withLatitude:(double)latitude
{
    m_Coordinate.latitude = latitude;
    m_Coordinate.longitude = longitude;
//    [self UpdateLocationCountryCode];
}

- (CLLocationCoordinate2D)coordinate
{
    return m_Coordinate;
}

-(void)SetTitle:(NSString*)title
{
    m_Title = [title copy];
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    [self SetCoordinate:newCoordinate];
}

-(NSString*)GetCountryCode
{
    return m_CountryCode;
}

-(NSString*)GetCity
{
    return m_City;
}

-(NSString*)GetCommunity
{
    return m_Community;
}

@end
