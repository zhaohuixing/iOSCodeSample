//
//  NOMRTSSourceService.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-12-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NOMRTSSourceService;

@protocol NOMRTSSourceServiceLoadDelegate <NSObject>

@optional
-(void)RealTimeTrafficSourceLoadDone:(NOMRTSSourceService*)pSource withResult:(BOOL)bOK;

@end


@interface NOMRTSSourceService : NSObject

-(void)RegisterDelegate:(id<NOMRTSSourceServiceLoadDelegate>)delegate;

-(void)SetTrafficDetail:(NSString*)trafficDetail withCause:(NSString*)trafficCause withType:(int16_t)nType;
-(void)SetTrafficIssueRoadNumber:(NSString*)trafficRoadNumber withCountryCode:(NSString*)trafficCountryCode;
-(void)SetTrafficIssueLength:(int)trafficIssueLength withDelay:(int)trafficDelay;
-(void)SetTrafficIssueStart:(NSString*)incentStartName issueEnd:(NSString*)incentEndName;
-(void)SetRouteType:(BOOL)bLineRoute;
-(void)SetBasePoint:(double)dLat longitude:(double)dLong;
-(void)AddRoutePoint:(double)dLat longitude:(double)dLong;


-(NSString*)GetTrafficIssueContent;
-(NSString*)GetTrafficCause;
-(NSString*)GetTrafficDetail;
-(int16_t)GetTrafficType;
-(NSString*)GetID;
-(double)GetBaseLatitude;
-(double)GetBaseLongitude;


-(NSArray*)GetPoints;
-(BOOL)IsLineRoute;
-(NSString*)GetRouteKML:(int)lineWidth lineColor:(UIColor *)color;

-(void)Finish;

@end
