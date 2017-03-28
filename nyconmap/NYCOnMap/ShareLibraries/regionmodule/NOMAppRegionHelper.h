//
//  NOMAppRegionHelper.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMRealTimeRegionManager.h"

@interface NOMAppRegionHelper : NSObject

+(NOMRealTimeRegionManager*)GetRegionManager;

+(void)InitializeAppRegionSystem;
+(void)SetMainMapViewObject:(MKMapView*)mapView;
+(NSString*)GetCurrentRegionTrafficTopicName:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd;

+(NSString*)GetCurrentRegionTrafficTopicName;
+(NSString*)GetCurrentRegionTaxiTopicName;
+(NSString*)GetCurrentRegionNewsTopicName;

+(BOOL)IsCurrentMapRegionChanged;
+(void)UpdateCachedMapRegionData;
+(void)GetCurrentRegion:(double*)latStart toLatitude:(double*)latEnd fromLongitude:(double*)lonStart toLongitude:(double*)lonEnd;
+(BOOL)IsCurrentRegionDefault;

+(void)SetCurrentRegion:(NSString*)regionKey;
+(NSString*)GetCurrentRegionKey;

+(NSString*)QueryRegionKey:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong;

+(BOOL)IsMapViewRegionCached;
+(void)SetCachedMapViewRegion:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong;
+(void)GetCachedMapViewRegion:(double*)startLat endLatitude:(double*)endLat startLongitude:(double*)startLong endLongitude:(double*)endLong;

@end
