//
//  NOMTrafficRoutePoint.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/22/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class NOMTrafficRoutePoint;

@protocol NOMTrafficRoutePointLoadDelegate <NSObject>

@optional
-(void)TrafficPointLoadDone:(NOMTrafficRoutePoint*)pPoint result:(BOOL)bSucceed;

@end

@interface NOMTrafficRoutePoint : NSObject

@property (nonatomic, readonly)double      m_dLatitude;
@property (nonatomic, readonly)double      m_dLongitude;
@property (nonatomic, readonly)NSString*   m_NameRawSource;

#ifndef USING_SIMPLEROUTEPOINT
@property (nonatomic, readonly)NSString*   m_StreetNumber;
@property (nonatomic, readonly)NSString*   m_Street;
@property (nonatomic, readonly)NSString*   m_City;
@property (nonatomic, readonly)NSString*   m_County;
@property (nonatomic, readonly)NSString*   m_State;
@property (nonatomic, readonly)NSString*   m_ZipCode;
@property (nonatomic, readonly)NSString*   m_Country;
#endif

-(void)LoadData:(double)dLat longitude:(double)dLong;
-(void)RegisterDelegate:(id<NOMTrafficRoutePointLoadDelegate>)delegate;

#ifndef USING_SIMPLEROUTEPOINT
-(void)LoadData:(NSString*)rawAddresName inCity:(NSString*)city inState:(NSString*)state inCountry:(NSString*)country inZipCode:(NSString*)zipcode;
-(BOOL)IsSucceed;
-(BOOL)IsFinished;
#endif

-(MKMapItem*)GetPlaceMapItem;

#ifdef DEBUG
-(void)DebugLogRouteSource;
#endif

@end
