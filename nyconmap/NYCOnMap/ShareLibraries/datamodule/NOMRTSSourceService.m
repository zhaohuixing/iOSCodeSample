//
//  NOMRTSSourceService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-12-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMRTSSourceService.h"
#import "NOMRTSSourcePoint.h"
#import "NOMKMLHelper.h"
#import "NOMMapConstants.h"

@interface NOMRTSSourceService ()
{
    NSString*                   m_SourceID;
    NSString*                   m_TrafficIssueDetail;
    NSString*                   m_TrafficCause;
    NSString*                   m_TrafficIssueRoadNumber;
    NSString*                   m_TrafficIssueCountryCode;

    NSString*                   m_TrafficIssueStartName;
    NSString*                   m_TrafficIssueEndName;
    
    int                         m_TrafficIssueLength;
    int                         m_TrafficIssueDelay;

    NOMRTSSourcePoint*          m_BasePoint;
    int16_t                     m_TrafficType;

    NSMutableArray*             m_PointsList;
    BOOL                        m_bLineTypeRoute;
    
    id<NOMRTSSourceServiceLoadDelegate>     m_Delegate;
}

@end

@implementation NOMRTSSourceService

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_SourceID = [[NSUUID UUID] UUIDString];
        m_TrafficIssueDetail = nil;
        m_TrafficCause = nil;
        m_TrafficIssueRoadNumber = nil;
        m_TrafficIssueCountryCode = nil;
     
        m_TrafficIssueStartName = nil;
        m_TrafficIssueEndName = nil;
        
        m_TrafficIssueLength = 0;
        m_TrafficIssueDelay = 0;
        
        m_BasePoint = nil;
        m_TrafficType = 0;
        
        m_PointsList = [[NSMutableArray alloc] init];
        m_bLineTypeRoute = YES;
        
        m_Delegate = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<NOMRTSSourceServiceLoadDelegate>)delegate
{
    m_Delegate = delegate;
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

-(void)SetTrafficIssueStart:(NSString*)incentStartName issueEnd:(NSString*)incentEndName
{
    m_TrafficIssueStartName = incentStartName;
    m_TrafficIssueEndName = incentEndName;
}

-(void)SetRouteType:(BOOL)bLineRoute
{
    m_bLineTypeRoute = bLineRoute;
}

-(void)SetBasePoint:(double)dLat longitude:(double)dLong
{
    if(m_BasePoint == nil)
    {
        m_BasePoint = [[NOMRTSSourcePoint alloc] initWith:dLat longitude:dLong];
    }
    else
    {
        [m_BasePoint SetData:dLat longitude:dLong];
    }
}

-(void)AddRoutePoint:(double)dLat longitude:(double)dLong
{
    if(m_PointsList == nil)
    {
        m_PointsList = [[NSMutableArray alloc] init];
    }
    
    CLLocation* point = [[CLLocation alloc] initWithLatitude:dLat longitude:dLong];
    [m_PointsList addObject:point];
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
    
    szRet = [NSString stringWithFormat:@"%@ from %@ to %@", szRet, m_TrafficIssueStartName, m_TrafficIssueEndName];
    
    szRet = [NSString stringWithFormat:@"%@ for %d meters", szRet, m_TrafficIssueLength];
    
    return szRet;
}

-(NSString*)GetTrafficCause
{
    return m_TrafficCause;
}

-(NSString*)GetTrafficDetail
{
    return m_TrafficIssueDetail;
}

-(int16_t)GetTrafficType
{
    return m_TrafficType;
}

-(NSString*)GetID
{
    return m_SourceID;
}

-(double)GetBaseLatitude
{
    double dRet = 0.0;
    
    if(m_BasePoint != nil)
        dRet = [m_BasePoint GetLatitude];
    
    return dRet;
}

-(double)GetBaseLongitude
{
    double dRet = 0.0;

    if(m_BasePoint != nil)
        dRet = [m_BasePoint GetLongitude];
    
    return dRet;
}

-(NSArray*)GetPoints
{
    return m_PointsList;
}

-(BOOL)IsLineRoute
{
    return m_bLineTypeRoute;
}

-(NSString*)GetRouteKML:(int)lineWidth lineColor:(UIColor *)color
{
    NSString* kml = nil;
    
    if(m_PointsList != nil && 0 < m_PointsList.count)
    {
        if(m_bLineTypeRoute)
        {
            KMLRoot* kmlObject = [KMLRoot new];
        
            KMLDocument *kmlDocument = [KMLDocument new];
            kmlObject.feature = kmlDocument;
            kmlDocument.name = MAP_PLAN_ROUTE_ID;
        
            KMLSchema* idSchema = [KMLSchema new];
            idSchema.objectID = MAP_PLAN_ROUTE_ID;
            idSchema.name = MAP_PLAN_ROUTE_ID;
            [kmlDocument addSchema:idSchema];
        
            for(int i = 0; i < m_PointsList.count; ++i)
            {
                KMLPlacemark *poitPlacemark = [NOMKMLHelper KMLPointWithTag:KML_TAG_POINT coordinate:((CLLocation*)[m_PointsList objectAtIndex:i]).coordinate];
                [kmlDocument addFeature:poitPlacemark];
            }
            if(2 <= m_PointsList.count)
            {
                KMLPlacemark *linePlacemark = [NOMKMLHelper KMLLineWithTag:KML_TAG_MARKLINE withCoordinates:m_PointsList lineWidth:lineWidth lineColor:color];
                [kmlDocument addFeature:linePlacemark];
            }
            kml = kmlObject.kml;
        }
        else
        {
            KMLRoot* kmlObject = [KMLRoot new];
            
            KMLDocument *kmlDocument = [KMLDocument new];
            kmlObject.feature = kmlDocument;
            kmlDocument.name = MAP_PLAN_POLY_ID;
            
            KMLSchema* idSchema = [KMLSchema new];
            idSchema.objectID = MAP_PLAN_POLY_ID;
            idSchema.name = MAP_PLAN_POLY_ID;
            [kmlDocument addSchema:idSchema];
            
            for(int i = 0; i < m_PointsList.count; ++i)
            {
                KMLPlacemark *poitPlacemark = [NOMKMLHelper KMLPointWithTag:KML_TAG_POINT coordinate:((CLLocation*)[m_PointsList objectAtIndex:i]).coordinate];
                [kmlDocument addFeature:poitPlacemark];
            }
            if(2 <= m_PointsList.count)
            {
                KMLPlacemark *polyPlacemark = [NOMKMLHelper KMLPolygonWithTag:KML_TAG_MARKPOLY withCoordinates:m_PointsList lineWidth:lineWidth withColor:color];
                [kmlDocument addFeature:polyPlacemark];
            }
            kml = kmlObject.kml;
        }
    }
    
    return kml;
}

-(void)Finish
{
    if(m_Delegate != nil)
    {
        [m_Delegate RealTimeTrafficSourceLoadDone:self withResult:YES];
    }
}
@end
