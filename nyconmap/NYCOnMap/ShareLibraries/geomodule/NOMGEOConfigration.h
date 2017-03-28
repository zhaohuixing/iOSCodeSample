//
//  NOMGEOConfigration.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-21.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NOMQueryAnnotationDataDelegate.h"

@interface NOMGEOConfigration : NSObject

+(double)toRadian:(double)val;
+(double)GetMaxQueryGEOSpanDegree;
+(double)GetQueryGEOSpanLimit;
+(double)LongitudeDifferenceByDistance:(double)distKM alongLantitude:(double)lanCenter;
+(double)LantitudeDifferenceByDistance:(double)distKM;
+(double)GetAnnotationIntervalLimitInMapView;
+(double)GetAnnotationDistanceOnMapView:(double)dGEODistance viewWidth:(double)dUIWidth geoSpan:(double)dGEPSpan;


+(NSString*)GetCountry:(int)index;
+(NSString*)GetCountryKey:(int)index;

+(void)SetCurrentCountryCode:(NSString*)ISOCountryCode;
+(void)SetCurrentCity:(NSString*)city;
+(void)SetCurrentCounty:(NSString*)county;
+(void)SetCurrentState:(NSString*)state;
+(void)SetCurrentCountry:(NSString*)country;
+(void)SetCurrentStreet:(NSString*)street;
+(void)SetCurrentZipCode:(NSString*)zipcode;
+(void)SetCurrentStreetNumber:(NSString*)streetNumber;

+(NSString*)GetCurrentCountryCode;
+(NSString*)GetCurrentCity;
+(NSString*)GetCurrentCounty;
+(NSString*)GetCurrentState;
+(NSString*)GetCurrentCountry;
+(NSString*)GetCurrentStreet;
+(NSString*)GetCurrentZipCode;
+(NSString*)GetCurrentStreetNumber;

+(void)SetCurrentMapRegion:(double)southLat northLat:(double)northLat westLong:(double)westLong eastLong:(double)northLong;
+(void)GetCurrentMapRegion:(double*)southLat northLat:(double*)northLat westLong:(double*)westLong eastLong:(double*)northLong;

+(BOOL)iAdAvailability;
+(BOOL)IsChinaCountryCode:(NSString*)ISOCountryCode;
+(BOOL)IsSameCountryCode:(NSString*)szCode1 with:(NSString*)szCode2;
+(BOOL)IsUSCountryCode:(NSString*)ISOCountryCode;
+(BOOL)IsCurrentCountryUS;

+(void)SetCachedCurrentReadingLocationData:(NSString*)city with:(NSString*)community;
+(NSString*)GetCachedCurrentReadingLocationCity;
+(NSString*)GetCachedCurrentReadingLocationCommunity;

+(double)GetTrafficAlertParameter;
+(void)SetTrafficAlertParameter:(double)distance;

+(void)SetMapZoomFactor:(double)dZoom;
+(double)GetMapZoomFactor;


+(void)RegisterNOMQueryAnnotationDataDelegate:(id<NOMQueryAnnotationDataDelegate>)delegate;
+(id<NOMQueryAnnotationDataDelegate>)GetNOMQueryAnnotationDataDelegate;


@end
