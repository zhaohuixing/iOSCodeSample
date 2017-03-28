//
//  NOMTrafficRouteSource.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/22/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMTrafficRouteSource.h"
#import <AddressBook/ABPerson.h>
#import <MapKit/MapKit.h>

#define GEODECODE_TIMER_INTERVAL            2

@interface NOMTrafficRouteSource ()
{
@private
    NSString*                   m_SourceID;
    NOMTrafficRoutePoint*       m_StartPoint;
    NOMTrafficRoutePoint*       m_EndPoint;
    NOMTrafficRoutePoint*       m_BasePoint;
    
    int16_t                     m_TrafficType;
    
    NSString*                   m_StartPointName;
    NSString*                   m_EndPointName;
    NSString*                   m_CityReference;
    NSString*                   m_StateReference;
    NSString*                   m_CountryReference;
    double                      m_BasePointLatitude;
    double                      m_BasePointLongitude;
    
    BOOL                        m_bBaseFinished;
    BOOL                        m_bBaseSuccess;
    BOOL                        m_bBaseExecuting;
    
    BOOL                        m_bStartFinished;
    BOOL                        m_bStartSuccess;
    BOOL                        m_bStartExecuting;
    
    BOOL                        m_bEndFinished;
    BOOL                        m_bEndSuccess;
    BOOL                        m_bEndExecuting;
    
    id<NOMTrafficRouteSourceLoadDelegate>       m_Delegate;
    
    NSString*                   m_TrafficIssueDetail;
    NSString*                   m_TrafficCause;
    NSString*                   m_TrafficIssueRoadNumber;
    NSString*                   m_TrafficIssueCountryCode;
    
    int                         m_TrafficIssueLength;
    int                         m_TrafficIssueDelay;
    
    NSTimer*                    m_IntervalTimer1;
    NSTimer*                    m_IntervalTimer2;
    NSTimer*                    m_IntervalTimerRoute;
    
    
    MKDirectionsResponse*       m_RouteList;
}

@end



@implementation NOMTrafficRouteSource

#ifndef USING_SIMPLEROUTEPOINT
-(void)StopIntervalTimerRoute
{
    if(m_IntervalTimerRoute != nil)
	{
		[m_IntervalTimerRoute invalidate];
		m_IntervalTimerRoute = nil;
	}
}

-(void)StopIntervalTimer1
{
    if(m_IntervalTimer1 != nil)
	{
		[m_IntervalTimer1 invalidate];
		m_IntervalTimer1 = nil;
	}
}

- (void)handleIntervalTimer1:(NSTimer*)timer
{
    [self StopIntervalTimer1];
    NSLog(@"Query Route Start Point: %@", m_StartPointName);
    
    if(m_TrafficIssueRoadNumber != nil)
    {
        NSString* szTemp = m_StartPointName;
        
        NSRange hasLeftBracket = [szTemp rangeOfString:@"/"];
        if(hasLeftBracket.location != NSNotFound)
        {
            NSRange range = NSMakeRange(0, hasLeftBracket.location);
            szTemp = [szTemp substringWithRange:range];
        }
        
        hasLeftBracket = [szTemp rangeOfString:@"("];
        if(hasLeftBracket.location != NSNotFound)
        {
            NSRange range = NSMakeRange(0, hasLeftBracket.location);
            szTemp = [szTemp substringWithRange:range];
        }
        
        NSString* address = [NSString stringWithFormat:@"%@ and %@", m_TrafficIssueRoadNumber, szTemp];
        [m_StartPoint LoadData:address inCity:m_CityReference inState:m_StateReference inCountry:m_CountryReference inZipCode:m_BasePoint.m_ZipCode];
    }
    else
    {
        [m_StartPoint LoadData:m_StartPointName inCity:m_CityReference inState:m_StateReference inCountry:m_CountryReference inZipCode:m_BasePoint.m_ZipCode];
    }
}

-(void)StartIntervalTimer1
{
	if(m_IntervalTimer1 == nil)
	{
		srandom(time(0));
		m_IntervalTimer1 = [NSTimer scheduledTimerWithTimeInterval:GEODECODE_TIMER_INTERVAL
                                                   target:self
                                                 selector:@selector(handleIntervalTimer1:)
                                                 userInfo:nil
                                                  repeats: NO
                   ];
	}
}

-(void)StopIntervalTimer2
{
    if(m_IntervalTimer2 != nil)
	{
		[m_IntervalTimer2 invalidate];
		m_IntervalTimer2 = nil;
	}
}

- (void)handleIntervalTimer2:(NSTimer*)timer
{
    [self StopIntervalTimer2];
    NSLog(@"Query Route End Point: %@", m_EndPoint);
    if(m_TrafficIssueRoadNumber != nil)
    {
        NSString* szTemp = m_EndPointName;
        
        NSRange hasLeftBracket = [szTemp rangeOfString:@"/"];
        if(hasLeftBracket.location != NSNotFound)
        {
            NSRange range = NSMakeRange(0, hasLeftBracket.location);
            szTemp = [szTemp substringWithRange:range];
        }
        hasLeftBracket = [szTemp rangeOfString:@"("];
        if(hasLeftBracket.location != NSNotFound)
        {
            NSRange range = NSMakeRange(0, hasLeftBracket.location);
            szTemp = [szTemp substringWithRange:range];
        }
        
        NSString* address = [NSString stringWithFormat:@"%@ and %@", m_TrafficIssueRoadNumber, szTemp];
        [m_EndPoint LoadData:address inCity:m_CityReference inState:m_StateReference inCountry:m_CountryReference inZipCode:m_BasePoint.m_ZipCode];
    }
    else
    {
        [m_EndPoint LoadData:m_EndPointName inCity:m_CityReference inState:m_StateReference inCountry:m_CountryReference inZipCode:m_BasePoint.m_ZipCode];
    }
}

-(void)StartIntervalTimer2
{
	if(m_IntervalTimer2 == nil)
	{
		srandom((unsigned)time(0));
		m_IntervalTimer2 = [NSTimer scheduledTimerWithTimeInterval:GEODECODE_TIMER_INTERVAL
                                                            target:self
                                                          selector:@selector(handleIntervalTimer2:)
                                                          userInfo:nil
                                                           repeats: NO
                            ];
	}
}
#endif

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_StartPoint = [[NOMTrafficRoutePoint alloc] init];
        [m_StartPoint RegisterDelegate:self];
        m_EndPoint = [[NOMTrafficRoutePoint alloc] init];
        [m_EndPoint RegisterDelegate:self];
        m_BasePoint = [[NOMTrafficRoutePoint alloc] init];
        [m_BasePoint RegisterDelegate:self];
        
        m_TrafficType = -1;
        
        m_StartPointName = nil;
        m_EndPointName = nil;
        m_CityReference = nil;
        m_StateReference = nil;
        m_CountryReference = nil;
        m_BasePointLatitude = 0;
        m_BasePointLongitude = 0;
        
        m_bBaseFinished = NO;
        m_bBaseSuccess = NO;
        m_bBaseExecuting = NO;
        
        m_bStartFinished = NO;
        m_bStartSuccess = NO;
        m_bStartExecuting = NO;
        
        m_bEndFinished = NO;
        m_bEndSuccess = NO;
        m_bEndExecuting = NO;
        m_Delegate = nil;
        m_TrafficIssueDetail = nil;
        
        m_TrafficCause = nil;
        m_TrafficIssueRoadNumber = nil;
        m_TrafficIssueCountryCode = nil;
        
        m_TrafficIssueLength = 0;
        m_TrafficIssueDelay = 0;
        
        m_IntervalTimer1 = nil;
        m_IntervalTimer2 = nil;
        m_IntervalTimerRoute = nil;
        m_RouteList = nil;
        
        m_SourceID = [[NSUUID UUID] UUIDString];
    }
    
    return self;
}

/*
-(void)dealloc
{
    if(m_StartPoint != nil)
        [m_StartPoint RegisterDelegate:nil];
    if(m_EndPoint != nil)
        [m_EndPoint RegisterDelegate:nil];
    if(m_BasePoint != nil)
        [m_BasePoint RegisterDelegate:nil];
    
    [self StopIntervalTimer1];
    [self StopIntervalTimer2];
    [self StopIntervalTimerRoute];
}
*/
 
-(NSString*)GetTrafficDetail
{
    return m_TrafficIssueDetail;
}

-(int16_t)GetTrafficType
{
    return m_TrafficType;
}

-(void)SetTrafficDetail:(NSString*)trafficDetail withCause:(NSString*)trafficCause withType:(int16_t)nType
{
    m_TrafficCause = nil;
    m_TrafficIssueDetail = nil;
    if(trafficDetail != nil)
    {
        m_TrafficIssueDetail = trafficDetail;
    }
    if(trafficCause != nil)
    {
        m_TrafficCause = trafficCause;
    }
    m_TrafficType = nType;
}

-(void)SetTrafficIssueRoadNumber:(NSString*)trafficRoadNumber withCountryCode:(NSString*)trafficCountryCode
{
    m_TrafficIssueRoadNumber = nil;
    m_TrafficIssueCountryCode = nil;
    
    if(trafficRoadNumber != nil)
    {
        m_TrafficIssueRoadNumber = trafficRoadNumber;
    }

    if(trafficCountryCode != nil)
    {
        m_TrafficIssueRoadNumber = trafficCountryCode;
    }

}

-(void)SetTrafficIssueLength:(int)trafficIssueLength withDelay:(int)trafficDelay
{
    m_TrafficIssueLength = trafficIssueLength;
    m_TrafficIssueDelay = trafficDelay;
}


-(void)LoadBasePoint:(double)dLat longitude:(double)dLong
{
    [m_BasePoint LoadData:dLat longitude:dLong];
}

-(BOOL)IsSucceed
{
    BOOL bRet = (m_TrafficIssueDetail != nil && 0 < m_TrafficIssueDetail.length && m_BasePoint.m_dLatitude != 0 && m_BasePoint.m_dLongitude != 0); //m_bBaseSuccess; //(m_bBaseSuccess == YES && m_bStartSuccess == YES && m_bEndSuccess == YES);
    return bRet;
}

-(BOOL)IsFinished
{
    BOOL bRet = (m_bBaseFinished == YES && m_bStartFinished == YES && m_bEndFinished == YES);
    return bRet;
}

-(void)SetGEOReference:(NSString*)city state:(NSString*)state country:(NSString*)country
{
    m_CityReference = city;
    m_StateReference = state;
    m_CountryReference = country;
}


-(void)TrafficPointLoadDone:(NOMTrafficRoutePoint*)pPoint result:(BOOL)bSucceed
{
#ifndef USING_SIMPLEROUTEPOINT
    if(m_BasePoint == pPoint)
    {
        m_bBaseFinished = YES;
        m_bBaseSuccess = bSucceed;
        m_bBaseExecuting = NO;
        if([m_BasePoint IsSucceed] == YES)
        {
            m_CityReference = m_BasePoint.m_City;
            m_StateReference = m_BasePoint.m_State;
            m_CountryReference = m_BasePoint.m_Country;
        }
        //[m_StartPoint LoadData:m_StartPointName inCity:m_CityReference inState:m_StateReference inCountry:m_CountryReference];
        [self StartIntervalTimer1];
    }
    else if(m_StartPoint == pPoint)
    {
        m_bStartFinished = YES;
        m_bStartSuccess = bSucceed;
        m_bStartExecuting = NO;
        //[m_EndPoint LoadData:m_EndPointName inCity:m_CityReference inState:m_StateReference inCountry:m_CountryReference];
        [self StartIntervalTimer2];
    }
    else if(m_EndPoint == pPoint)
    {
        m_bEndFinished = YES;
        m_bEndSuccess = bSucceed;
        m_bEndExecuting = NO;
    }
#endif
    
    if(m_Delegate != nil && [self IsFinished] == YES)
    {
        [m_Delegate TrafficRouteSourceLoadDone:self];
    }
}

-(void)LoadSource:(double)dLat longitude:(double)dLong startName:(NSString*)startPoint endName:(NSString*)endPoint
{
    m_bBaseFinished = NO;
    m_bBaseSuccess = NO;
    m_bBaseExecuting = YES;
    
    m_bStartFinished = NO;
    m_bStartSuccess = NO;
    m_bStartExecuting = YES;
    
    m_bEndFinished = NO;
    m_bEndSuccess = NO;
    m_bEndExecuting = YES;
    
    m_StartPointName = startPoint;
    m_EndPointName = endPoint;
    
    m_BasePointLatitude = dLat;
    m_BasePointLongitude = dLong;

    //[self LoadBasePoint:m_BasePointLatitude longitude:m_BasePointLongitude];
}

-(void)RegisterDelegate:(id<NOMTrafficRouteSourceLoadDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)StartPorcessDetail
{
    [self LoadBasePoint:m_BasePointLatitude longitude:m_BasePointLongitude];
}

-(NSString*)GetID
{
    return m_SourceID;
}

-(double)GetBaseLatitude
{
    double dLat = 0.0;
    
    if(m_BasePoint != nil)
    {
        dLat = m_BasePointLatitude;
    }
    
    return dLat;
}

-(double)GetBaseLongitude
{
    double dLong = 0.0;
    
    if(m_BasePoint != nil)
    {
        dLong = m_BasePointLongitude;
    }
    
    return dLong;
}

-(NSString*)GetTrafficCause
{
    return m_TrafficCause;
}

-(NSString*)GetTrafficIssueContent
{
    NSString* szRet = @"";
    
    if(m_TrafficIssueDetail != nil && 0 < m_TrafficIssueDetail.length)
    {
        szRet = [NSString stringWithFormat:@"%@", m_TrafficIssueDetail];
    }
    else if(m_TrafficCause != nil && 0 < m_TrafficCause.length)
    {
        szRet = [NSString stringWithFormat:@"%@", m_TrafficCause];
    }
    
    if(m_TrafficIssueRoadNumber != nil)
    {
        szRet = [NSString stringWithFormat:@"%@ along %@", szRet, m_TrafficIssueRoadNumber];
    }
    
    szRet = [NSString stringWithFormat:@"%@ from %@ to %@", szRet, m_StartPointName, m_EndPointName];

    szRet = [NSString stringWithFormat:@"%@ for %d meters", szRet, m_TrafficIssueLength];

//    if(0 < m_TrafficIssueDelay)
//        szRet = [NSString stringWithFormat:@"%@ and %d minutes delay", szRet, m_TrafficIssueDelay];
    
    return szRet;
}

-(int)GetValidPointCount
{
    int nRet = 0;
    
    if(m_StartPoint != nil && [m_StartPoint GetPlaceMapItem] != nil)
        ++nRet;
    
    if(m_EndPoint != nil && [m_EndPoint GetPlaceMapItem] != nil)
        ++nRet;
    
    if(m_BasePoint != nil && [m_BasePoint GetPlaceMapItem] != nil)
        ++nRet;
    
    return nRet;
}

-(MKMapItem*)GetStartPointMapItem
{
    MKMapItem* pItem = [m_StartPoint GetPlaceMapItem];
    
    if(pItem == nil)
        pItem = [m_BasePoint GetPlaceMapItem];
    
    return pItem;
}

-(MKMapItem*)GetEndPointMapItem
{
    MKMapItem* pItem = [m_EndPoint GetPlaceMapItem];
    
    if(pItem == nil)
        pItem = [m_BasePoint GetPlaceMapItem];
    
    return pItem;
}

-(void)CreateRouteFinished:(MKDirectionsResponse*)result
{
    if(result != nil)
    {
        m_RouteList = result;
        if(m_Delegate)
            [m_Delegate TrafficRouteCreationDone:self];
    }
}

- (void)handleIntervalTimerRoute:(NSTimer*)timer
{
#ifndef USING_SIMPLEROUTEPOINT
    [self StopIntervalTimerRoute];
    [self StartCreateRoute];
#endif
}

-(void)StartIntervalTimerRoute
{
	if(m_IntervalTimerRoute == nil)
	{
		srandom(time(0));
		m_IntervalTimerRoute = [NSTimer scheduledTimerWithTimeInterval:GEODECODE_TIMER_INTERVAL
                                                            target:self
                                                          selector:@selector(handleIntervalTimerRoute:)
                                                          userInfo:nil
                                                           repeats: NO
                            ];
	}
}

-(void)DelayStartCreateRoute
{
    [self StartIntervalTimerRoute];
}

-(void)StartCreateRoute
{
    int nCount = [self GetValidPointCount];
    if(nCount <= 1)
    {
        if(m_Delegate)
            [m_Delegate TrafficRouteCreationDone:self];
        return;
    }
    MKMapItem* startItem = [self GetStartPointMapItem];
    MKMapItem* endItem = [self GetEndPointMapItem];
    
    if(startItem == nil || endItem == nil)
    {
        if(m_Delegate)
            [m_Delegate TrafficRouteCreationDone:self];
        return;
    }
    
    if(startItem.placemark == nil || endItem.placemark == nil)
    {
        if(m_Delegate)
            [m_Delegate TrafficRouteCreationDone:self];
        return;
    }

    if(startItem.placemark.coordinate.latitude == endItem.placemark.coordinate.latitude &&
       startItem.placemark.coordinate.longitude == endItem.placemark.coordinate.longitude)
    {
        if(m_Delegate)
            [m_Delegate TrafficRouteCreationDone:self];
        return;
    }
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = startItem;
    request.destination = endItem;
    request.requestsAlternateRoutes = NO;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
    {
         if(error)
         {
             // Handle error
             NSLog(@"StartCreateRoute error:%@", [error description]);
         }
         else
         {
             [self CreateRouteFinished:response];
         }
     }];
    
}

-(MKDirectionsResponse*)GetRouteList
{
    return m_RouteList;
}

#ifdef DEBUG
-(void)DebugLogRouteSource
{
    NSLog(@"NOMTrafficRouteSource information:\n");

    if(m_TrafficIssueDetail != nil && 0 < m_TrafficIssueDetail.length)
    {
        NSLog(@"m_TrafficIssueDetail:%@", m_TrafficIssueDetail);
    }
    else
    {
        NSLog(@"m_TrafficIssueDetail invalid\n");
    }
    
    if(m_StartPointName != nil && 0 < m_StartPointName.length)
    {
        NSLog(@"m_StartPointName:%@", m_StartPointName);
    }
    else
    {
        NSLog(@"m_StartPointName invalid\n");
    }

    if(m_EndPointName != nil && 0 < m_EndPointName.length)
    {
        NSLog(@"m_EndPointName:%@", m_EndPointName);
    }
    else
    {
        NSLog(@"m_EndPointName invalid\n");
    }

    if(m_CityReference != nil && 0 < m_CityReference.length)
    {
        NSLog(@"m_CityReference:%@", m_CityReference);
    }
    else
    {
        NSLog(@"m_CityReference invalid\n");
    }
    
    if(m_StateReference != nil && 0 < m_StateReference.length)
    {
        NSLog(@"m_StateReference:%@", m_StateReference);
    }
    else
    {
        NSLog(@"m_StateReference invalid\n");
    }

    if(m_CountryReference != nil && 0 < m_CountryReference.length)
    {
        NSLog(@"m_CountryReference:%@", m_CountryReference);
    }
    else
    {
        NSLog(@"m_CountryReference invalid\n");
    }
    
    NSLog(@"m_BasePointLatitude: %f", m_BasePointLatitude);
    NSLog(@"m_BasePointLongitude: %f", m_BasePointLongitude);
    
    
    NSLog(@"m_StartPoint information:\n");
    if(m_StartPoint != nil)
        [m_StartPoint DebugLogRouteSource];
    else
        NSLog(@"Invalid m_StartPoint\n");
    
    NSLog(@"m_EndPoint information:\n");
    if(m_EndPoint != nil)
        [m_EndPoint DebugLogRouteSource];
    else
        NSLog(@"Invalid m_EndPoint\n");
    
    NSLog(@"m_BasePoint information:\n");
    if(m_BasePoint != nil)
        [m_BasePoint DebugLogRouteSource];
    else
        NSLog(@"Invalid m_BasePoint\n");
    
}
#endif

@end
