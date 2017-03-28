//
//  NOMTrafficRoutePoint.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/22/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficRoutePoint.h"
#import <AddressBook/ABPerson.h>


@interface NOMTrafficRoutePoint ()
{
@private
    double                                      m_dLatitude;
    double                                      m_dLongitude;
    CLLocation*                                 m_Location;
    id<NOMTrafficRoutePointLoadDelegate>        m_Delegate;
    
    MKMapItem*  m_PlaceMapItem;
    
#ifndef USING_SIMPLEROUTEPOINT
    NSString*   m_StreetNumber;
    NSString*   m_Street;
    NSString*   m_City;
    NSString*   m_County;
    NSString*   m_State;
    NSString*   m_ZipCode;
    NSString*   m_Country;
    
    NSString*   m_NameRawSource;
    
    BOOL                m_bFinished;
    BOOL                m_bSuccess;
    BOOL                m_bExecuting;
#endif
}
@end

@implementation NOMTrafficRoutePoint

@synthesize     m_dLatitude = m_dLatitude;
@synthesize     m_dLongitude = m_dLongitude;
@synthesize    m_NameRawSource = m_NameRawSource;

#ifndef USING_SIMPLEROUTEPOINT
@synthesize    m_StreetNumber = m_StreetNumber;
@synthesize    m_Street = m_Street;
@synthesize    m_City = m_City;
@synthesize    m_County = m_County;
@synthesize    m_State = m_State;
@synthesize    m_ZipCode = m_ZipCode;
@synthesize    m_Country = m_Country;
#endif

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_dLatitude = 0;
        m_dLongitude = 0;
        m_Location = nil;
        m_NameRawSource = nil;
        m_Delegate = nil;
        m_PlaceMapItem = nil;
        
#ifndef USING_SIMPLEROUTEPOINT
        m_StreetNumber = nil;
        m_Street = nil;
        m_City = nil;
        m_County = nil;
        m_State = nil;
        m_ZipCode = nil;
        m_Country = nil;
        
        
        m_bFinished = NO;
        m_bSuccess = NO;
        m_bExecuting = NO;
#endif
    }
    
    return self;
}

-(void)Reset
{
#ifndef USING_SIMPLEROUTEPOINT
    m_bFinished = NO;
    m_bSuccess = NO;
    m_bExecuting = NO;
    if(m_StreetNumber != nil)
    {
        m_StreetNumber = nil;
    }
    if(m_Street != nil)
    {
        m_Street = nil;
    }
    if(m_City != nil)
    {
        m_City = nil;
    }
    if(m_County != nil)
    {
        m_County = nil;
    }
    if(m_State != nil)
    {
        m_State = nil;
    }
    if(m_ZipCode != nil)
    {
        m_ZipCode = nil;
    }
    if(m_Country != nil)
    {
        m_Country = nil;
    }
    if(m_NameRawSource != nil)
    {
        m_NameRawSource = nil;
    }
#endif
    if(m_Location != nil)
    {
        m_Location = nil;
    }
    
    if(m_PlaceMapItem != nil)
    {
        m_PlaceMapItem = nil;
    }
}

#ifndef USING_SIMPLEROUTEPOINT
-(BOOL)IsSucceed
{
    return m_bSuccess;
}

-(BOOL)IsFinished
{
    return m_bFinished;
}

-(void)Finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    m_bExecuting = NO;
    m_bFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    if(m_Delegate != nil)
    {
        [m_Delegate TrafficPointLoadDone:self result:m_bSuccess];
    }
}
#endif

-(void)LoadData:(double)dLat longitude:(double)dLong
{
    [self Reset];
    m_dLatitude = dLat;
    m_dLongitude = dLong;
    m_Location = [[CLLocation alloc] initWithLatitude:dLat longitude:dLong];
    CLLocationCoordinate2D location = (CLLocationCoordinate2D) {m_dLatitude, m_dLongitude};
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
    m_PlaceMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    
#ifndef USING_SIMPLEROUTEPOINT
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    [self willChangeValueForKey:@"isExecuting"];
    m_bExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    
    
    [geocoder reverseGeocodeLocation:m_Location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"NOMTrafficRoutePoint Geocode failed with error: %@", error);
             m_bSuccess = NO;
             [self Finish];
             return;
         }
         if(placemarks && placemarks.count > 0)
         {
             //do something
             CLPlacemark *topResult = [placemarks objectAtIndex:0];
             
             if(topResult.locality != nil && 0 < topResult.locality.length)
                 m_City = topResult.locality;
             
             if(topResult.subAdministrativeArea != nil && 0 < topResult.subAdministrativeArea.length)
                 m_County = topResult.subAdministrativeArea;
             
             if(topResult.administrativeArea != nil && 0 < topResult.administrativeArea.length)
                 m_State = topResult.administrativeArea;
             
             if(topResult.country != nil && 0 < topResult.country.length)
                 m_Country = topResult.country ;
             
             if(topResult.thoroughfare != nil && 0 < topResult.thoroughfare.length)
                 m_Street = topResult.thoroughfare;
             
             if(topResult.postalCode != nil && 0 < topResult.postalCode.length)
                 m_ZipCode = topResult.postalCode;
             
             if(topResult.subThoroughfare != nil && 0 < topResult.subThoroughfare.length)
                 m_StreetNumber = topResult.subThoroughfare;

             m_bSuccess = YES;
             [self Finish];
             return;
         }
     }];
#endif
}

-(NSString*)RemoveAddtionExitString:(NSString*)szTemp
{
    NSString* szRet = szTemp;

    NSRange hasExit = [szTemp rangeOfString:@"/Exit "];
    if(hasExit.location == NSNotFound)
        return szRet;

    szRet = [szTemp stringByReplacingOccurrencesOfString:@"/Exit " withString:@""];
    
    int nSearchCount = szRet.length - hasExit.location;
    NSRange searchRange;
    searchRange.location = hasExit.location;
    searchRange.length = nSearchCount;
    
    NSRange emptyExit = [szRet rangeOfString:@" " options:NSCaseInsensitiveSearch range:searchRange];
    if(emptyExit.location != NSNotFound)
    {
        NSRange replaceRange;
        replaceRange.location = searchRange.location;
        replaceRange.length = emptyExit.location - searchRange.location;
        szRet = [szRet stringByReplacingCharactersInRange:replaceRange withString:@" "];
    }
    
    return szRet;
}

-(NSString*)RemoveAddtionExitStringToLeftBracket:(NSString*)szTemp
{
    NSString* szRet = szTemp;

    NSRange hasExit = [szTemp rangeOfString:@"/"];
    if(hasExit.location == NSNotFound)
        return szRet;
    
    NSRange hasLeftBracket = [szTemp rangeOfString:@"("];
    if(hasLeftBracket.location == NSNotFound)
        return szRet;
    
    NSRange replaceRange;
    replaceRange.location = hasExit.location;
    replaceRange.length = hasLeftBracket.location - hasExit.location;
    szRet = [szRet stringByReplacingCharactersInRange:replaceRange withString:@" "];
    
    return szRet;
}

#ifndef USING_SIMPLEROUTEPOINT
-(void)LoadData:(NSString*)rawAddresName inCity:(NSString*)city inState:(NSString*)state inCountry:(NSString*)country inZipCode:(NSString*)zipcode
{
    [self Reset];
    
    NSString* szTemp = rawAddresName;
    
    szTemp = [self RemoveAddtionExitStringToLeftBracket:szTemp];
    szTemp = [self RemoveAddtionExitString:szTemp];
    
    NSRange hasLeftBracket = [szTemp rangeOfString:@"("];
    if(hasLeftBracket.location != NSNotFound)
    {
        szTemp = [szTemp stringByReplacingOccurrencesOfString:@"(" withString:@" and "];
    }

    NSRange hasRightBracket = [szTemp rangeOfString:@")"];
    if(hasRightBracket.location != NSNotFound)
    {
        szTemp = [szTemp stringByReplacingOccurrencesOfString:@")" withString:@""];
    }

    NSRange hasDoubleEmpty = [szTemp rangeOfString:@"  "];
    if(hasDoubleEmpty.location != NSNotFound)
    {
        szTemp = [szTemp stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    
    m_City = city;
    m_State = state;
    m_Country = country;
    m_NameRawSource = szTemp;
    m_ZipCode = zipcode;
    
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        m_City, kABPersonAddressCityKey,
                                        m_State, kABPersonAddressStateKey,
                                        m_Country, kABPersonAddressCountryKey,
                                        m_NameRawSource, kABPersonAddressStreetKey,
                                        m_ZipCode, kABPersonAddressZIPKey,
                                        nil];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:locationDictionary completionHandler:^(NSArray *placemarks, NSError *error)
     {
         m_bSuccess = NO;
         if(0 < [placemarks count] && error == nil)
         {
             CLPlacemark *topResult = [placemarks objectAtIndex:0];
             CLLocation *location = topResult.location;
             if(location != nil)
             {
                 m_bSuccess = YES;
                 m_dLatitude = location.coordinate.latitude;
                 m_dLongitude = location.coordinate.longitude;
                 m_Location = [[CLLocation alloc] initWithLatitude:m_dLatitude longitude:m_dLongitude];
                 
                 CLLocationCoordinate2D location = (CLLocationCoordinate2D) {m_dLatitude, m_dLongitude};
                 
                 MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
                 m_PlaceMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                 
                 if(topResult.subAdministrativeArea != nil && 0 < topResult.subAdministrativeArea.length)
                     m_County = topResult.subAdministrativeArea;
                 
                 if(topResult.thoroughfare != nil && 0 < topResult.thoroughfare.length)
                     m_Street = topResult.thoroughfare;
                 
                 if(topResult.postalCode != nil && 0 < topResult.postalCode.length)
                     m_ZipCode = topResult.postalCode;
                 
                 if(topResult.subThoroughfare != nil && 0 < topResult.subThoroughfare.length)
                     m_StreetNumber = topResult.subThoroughfare;

                 NSLog(@"Route Point query succeeded %@: Lat:%f; Long:%f", m_NameRawSource, m_dLatitude, m_dLongitude);
             }
         }
         else
         {
             if(error != nil)
             {
                 NSLog(@"error:%@", [error description]);
             }
         }
         [self Finish];
     }];
}
#endif

-(void)RegisterDelegate:(id<NOMTrafficRoutePointLoadDelegate>)delegate
{
    m_Delegate = delegate;
}

-(MKMapItem*)GetPlaceMapItem
{
    return m_PlaceMapItem;
}

#ifdef DEBUG
-(void)DebugLogRouteSource
{
    NSLog(@"NOMTrafficRoutePoint\n");
    NSLog(@"m_dLatitude: %f", m_dLatitude);
    NSLog(@"m_dLongitude: %f", m_dLongitude);
    
    if(m_Location != nil)
    {
        NSLog(@"m_Location:Lat:%f, Long:%f", m_Location.coordinate.latitude, m_Location.coordinate.longitude);
    }
    else
    {
        NSLog(@"m_Location:is empty\n");
    }
    
#ifndef USING_SIMPLEROUTEPOINT
    if(m_NameRawSource != nil && 0 < m_NameRawSource.length)
    {
        NSLog(@"m_NameRawSource:%@", m_NameRawSource);
    }
    else
    {
        NSLog(@"m_NameRawSource invalid\n");
    }

    if(m_StreetNumber != nil && 0 < m_StreetNumber.length)
    {
        NSLog(@"m_StreetNumber:%@", m_StreetNumber);
    }
    else
    {
        NSLog(@"m_StreetNumber invalid\n");
    }

    if(m_Street != nil && 0 < m_Street.length)
    {
        NSLog(@"m_Street:%@", m_Street);
    }
    else
    {
        NSLog(@"m_Street invalid\n");
    }

    if(m_City != nil && 0 < m_City.length)
    {
        NSLog(@"m_City:%@", m_City);
    }
    else
    {
        NSLog(@"m_City invalid\n");
    }

    if(m_County != nil && 0 < m_County.length)
    {
        NSLog(@"m_County:%@", m_County);
    }
    else
    {
        NSLog(@"m_County invalid\n");
    }

    if(m_State != nil && 0 < m_State.length)
    {
        NSLog(@"m_State:%@", m_State);
    }
    else
    {
        NSLog(@"m_State invalid\n");
    }

    if(m_ZipCode != nil && 0 < m_ZipCode.length)
    {
        NSLog(@"m_ZipCode:%@", m_ZipCode);
    }
    else
    {
        NSLog(@"m_ZipCode invalid\n");
    }

    if(m_Country != nil && 0 < m_Country.length)
    {
        NSLog(@"m_Country:%@", m_Country);
    }
    else
    {
        NSLog(@"m_Country invalid\n");
    }
#endif
}

#endif

@end
