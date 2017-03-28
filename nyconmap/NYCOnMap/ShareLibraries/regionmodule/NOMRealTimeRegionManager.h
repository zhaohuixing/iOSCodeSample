//
//  NOMRealTimeRegionManager.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-01.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMActiveRegion.h"

@interface NOMRealTimeRegionManager : NSObject

-(void)SetCurrentRegion:(NSString*)regionKey;
-(NOMActiveRegion*)GetRegion:(NSString*)regionKey;
-(NOMActiveRegion*)GetCurrentRegion;
-(NOMActiveRegion*)GetDefaultRegion;

-(NSArray*)GetCanadianRegions;
-(NSArray*)GetUSARegions;

-(NSString*)GetCurrentRegionKey;
-(NSString*)GetRegionKey:(double)dLatitude longitude:(double)dLongitude;

-(void)SetCityBaseAppRegionKey:(NSString*)regionKey;
-(NSString*)GetCityBaseAppRegionKey;
-(NOMActiveRegion*)GetCityBaseAppRegion;

-(NSString*)IntersectRegionKey:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong;

-(BOOL)IsMapViewRegionCached;
-(void)SetCachedMapViewRegion:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong;
-(void)GetCachedMapViewRegion:(double*)startLat endLatitude:(double*)endLat startLongitude:(double*)startLong endLongitude:(double*)endLong;

@end
