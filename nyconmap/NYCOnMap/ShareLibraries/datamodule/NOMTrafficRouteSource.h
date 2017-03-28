//
//  NOMTrafficRouteSource.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/22/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMTrafficRoutePoint.h"


@class NOMTrafficRouteSource;

@protocol NOMTrafficRouteSourceLoadDelegate <NSObject>

@optional
-(void)TrafficRouteSourceLoadDone:(NOMTrafficRouteSource*)pRoute;
-(void)TrafficRouteCreationDone:(NOMTrafficRouteSource*)pRoute;

@end

@interface NOMTrafficRouteSource : NSObject<NOMTrafficRoutePointLoadDelegate>

-(NSString*)GetTrafficDetail;
-(NSString*)GetTrafficCause;
-(int16_t)GetTrafficType;
-(void)SetTrafficDetail:(NSString*)trafficDetail withCause:(NSString*)trafficCause withType:(int16_t)nType;
-(void)SetTrafficIssueRoadNumber:(NSString*)trafficRoadNumber withCountryCode:(NSString*)trafficCountryCode;
-(void)SetTrafficIssueLength:(int)trafficIssueLength withDelay:(int)trafficDelay;

-(void)LoadSource:(double)dLat longitude:(double)dLong startName:(NSString*)startPoint endName:(NSString*)endPoint;
-(BOOL)IsSucceed;
-(BOOL)IsFinished;
-(void)RegisterDelegate:(id<NOMTrafficRouteSourceLoadDelegate>)delegate;

-(void)TrafficPointLoadDone:(NOMTrafficRoutePoint*)pPoint result:(BOOL)bSucceed;

-(void)SetGEOReference:(NSString*)city state:(NSString*)state country:(NSString*)country;

-(void)StartPorcessDetail;

-(NSString*)GetID;
-(double)GetBaseLatitude;
-(double)GetBaseLongitude;

-(NSString*)GetTrafficIssueContent;

-(void)StartCreateRoute;
-(void)DelayStartCreateRoute;

-(MKDirectionsResponse*)GetRouteList;


#ifdef DEBUG
-(void)DebugLogRouteSource;
#endif

@end
