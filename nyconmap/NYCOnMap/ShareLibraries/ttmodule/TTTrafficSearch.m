//
//  TTTrafficSearch.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/22/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "TTTrafficSearch.h"
#import "TTSDKHelper.h"
#import "NOMGEOConfigration.h"
#import "NOMRTSSourceService.h"
#import "NOMRTSSourcePoint.h"


@interface TTTrafficSearch ()
{
@private
    BOOL                m_bExecuting;
    BOOL                m_bFinished;
    BOOL                m_bSuccess;
    
    TTAPITraffic*                       m_TrafficSearchAgent;
    TTBBox*                             m_ScreenWGSBBox;
    int                                 m_nZoomLevel;
    
    NSMutableArray*                     m_RecordList;
    double                              m_dLatitudeStart;
    double                              m_dLatitudeEnd;
    double                              m_dLongitudeStart;
    double                              m_dLongitudeEnd;
    
    id<TTTrafficSearchDelegate>         m_Delegate;
}

@end

@implementation TTTrafficSearch

-(void)SearchTraffic:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withZoom:(double)dZoom
{
    [self SetTrafficSearchParameters:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withZoom:dZoom];
#ifdef _USING_GCD_TTT_SEARCH
    [self StartSearch];
#endif
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_TrafficSearchAgent = [[TTAPITraffic alloc] init];
        m_ScreenWGSBBox = nil;
        m_bExecuting = NO;
        m_bFinished = NO;
        m_bSuccess = NO;
        m_nZoomLevel = 11;
        m_RecordList = [[NSMutableArray alloc] init];
        m_dLatitudeStart = 0;
        m_dLatitudeEnd = 0;
        m_dLongitudeStart = 0;
        m_dLongitudeEnd = 0;
        
        m_Delegate = nil;
    }
    
    return self;
}

-(id)initWith:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withZoom:(double)dZoom
{
    self = [super init];
    
    if(self != nil)
    {
        m_TrafficSearchAgent = [[TTAPITraffic alloc] init];
        m_ScreenWGSBBox = nil;
        m_bExecuting = NO;
        m_bFinished = NO;
        m_bSuccess = NO;
        m_nZoomLevel = 11;
        m_RecordList = [[NSMutableArray alloc] init];
        m_Delegate = nil;
        [self SetTrafficSearchParameters:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withZoom:dZoom];
    }
    
    return self;
}

-(void)RegisterDelegate:(id<TTTrafficSearchDelegate>)delegate
{
    m_Delegate = delegate;
}

-(BOOL)IsSucceeded
{
    return m_bSuccess;
}

-(BOOL)IsCompleted
{
    return m_bFinished;
}

-(BOOL)isConcurrent
{
    return YES;
}

-(BOOL)isExecuting
{
    return m_bExecuting;
}

-(BOOL)isFinished
{
    return m_bFinished;
}

#ifdef _USING_GCD_TTT_SEARCH
-(void)HandleSearchCompletion
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(HandleSearchCompletion) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(m_Delegate != nil)
    {
        [m_Delegate TrafficSearchDone:self withResult:m_bSuccess];
    }
}
#endif

-(void)Finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    m_bExecuting = NO;
    m_bFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
#ifdef _USING_GCD_TTT_SEARCH
    [self HandleSearchCompletion];
#endif
}

-(NSArray*)GetRecordList
{
    return m_RecordList;
}

-(void)start
{
    m_bSuccess = NO;
    m_bFinished = NO;
    
    if(m_ScreenWGSBBox == nil || m_TrafficSearchAgent == nil)
    {
        return;
    }
    
#ifdef _USING_GCD_TTT_SEARCH
    //Makes sure that start method always runs on the main thread.
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
#endif
    
    [self willChangeValueForKey:@"isExecuting"];
    m_bExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [m_TrafficSearchAgent getTraffic:m_ScreenWGSBBox withZoomLevel:m_nZoomLevel pixelExtent:[TTAPITraffic defaultPixelExtent] trafficModelId:[NSNumber numberWithInt:-1] andNotifyDelegate:self withPayload:nil];
    
}

//
//TTAPITrafficDelegate method
//
-(double)CheckProperLatitude:(double)dSrcLat withVar2:(double)dSrcLong
{
    double dRet = dSrcLat;
    double dMin = MIN(m_dLatitudeStart, m_dLatitudeEnd);
    double dMax = MAX(m_dLatitudeStart, m_dLatitudeEnd);
    
    if(dMin <= dSrcLat && dSrcLat <= dMax)
    {
        return dSrcLat;
    }
    else if (dMin <= dSrcLong && dSrcLong <= dMax)
    {
        return dSrcLong;
    }
    
    return dRet;
}


-(double)CheckProperLongitude:(double)dSrcLong withVar2:(double)dSrcLat
{
    double dRet = dSrcLong;
    double dMin = MIN(m_dLongitudeStart, m_dLongitudeEnd);
    double dMax = MAX(m_dLongitudeStart, m_dLongitudeEnd);

    if (dMin <= dSrcLong && dSrcLong <= dMax)
    {
        return dSrcLong;
    }
    else if(dMin <= dSrcLat && dSrcLat <= dMax)
    {
        return dSrcLat;
    }
    
    return dRet;
}

#ifdef DEBUG
-(void)TraceTrafficShape:(TTAPITrafficShape*)trafficShape
{
    if(trafficShape != nil)
    {
        NSLog(@"TTAPITrafficShape object information trace begin\n");
 
        NSLog(@"trafficShape.width is %i\n", (int)trafficShape.width);
        if(trafficShape.shapePoints != nil)
        {
            NSLog(@"trafficShape.shapePoints is %@\n", trafficShape.shapePoints);
        }
        else
        {
            NSLog(@"trafficShape.shapePoints is null\n");
        }
        
        NSLog(@"TTAPITrafficShape object information trace end\n");
    }
    else
    {
        NSLog(@"TTAPITrafficShape object is null\n");
    }
}

-(void)TraceTrafficPoi:(TTAPITrafficPoi *)poi
{
    if(poi != nil)
    {
        NSLog(@"TTAPITrafficPoi object information trace begin\n");
        
        if(poi.poiPosition != nil)
        {
            NSLog(@"poi.poiPosition latitude:%f  longitude:%f\n", [poi.poiPosition.latitude doubleValue], [poi.poiPosition.longitude doubleValue]);
        }
        else
        {
            NSLog(@"poi.poiPosition is null\n");
        }
        
        NSLog(@"poi.iconCategory is %i\n", (int)poi.iconCategory);
        NSLog(@"poi.trafficType is %i\n", (int)poi.trafficType);

        if(poi.clusterBottomLeftPosition != nil)
        {
            NSLog(@"poi.clusterBottomLeftPosition latitude:%f  longitude:%f\n", [poi.clusterBottomLeftPosition.latitude doubleValue], [poi.clusterBottomLeftPosition.longitude doubleValue]);
        }
        else
        {
            NSLog(@"poi.clusterBottomLeftPosition is null\n");
        }
        
        if(poi.clusterTopRightPosition != nil)
        {
            NSLog(@"poi.clusterTopRightPosition latitude:%f  longitude:%f\n", [poi.clusterTopRightPosition.latitude doubleValue], [poi.clusterTopRightPosition.longitude doubleValue]);
        }
        else
        {
            NSLog(@"poi.clusterTopRightPosition is null\n");
        }

        NSLog(@"poi.clusterSize is %i\n", (int)poi.clusterSize);
 
        if(poi.clusterPois != nil && 0 < (int)poi.clusterPois.count)
        {
            for(int i = 0; i < (int)poi.clusterPois.count; ++i)
            {
                NSLog(@"poi.clusterPois index is %i\n", i);
                id element = [poi.clusterPois objectAtIndex:i];
                if(element != nil && [element isKindOfClass:[TTAPITrafficPoi class]] == YES)
                {
                    TTAPITrafficPoi* pSubPoi = (TTAPITrafficPoi*)element;
                    [self TraceTrafficPoi:pSubPoi];
                }
                else
                {
                    NSLog(@"poi.clusterPois element is not valid\n");
                }
            }
        }
        
        [self TraceTrafficShape:poi.trafficShape];
        
        if(poi.incidentDescription != nil)
        {
            NSLog(@"poi.incidentDescription is:%@\n", poi.incidentDescription);
        }
        else
        {
            NSLog(@"poi.incidentDescription is null\n");
        }
       
        if(poi.incidentCause != nil)
        {
            NSLog(@"poi.incidentCause is:%@\n", poi.incidentCause);
        }
        else
        {
            NSLog(@"poi.incidentCause is null\n");
        }

        if(poi.incidentFromName != nil)
        {
            NSLog(@"poi.incidentFromName is:%@\n", poi.incidentFromName);
        }
        else
        {
            NSLog(@"poi.incidentFromName is null\n");
        }

        if(poi.incidentToName != nil)
        {
            NSLog(@"poi.incidentToName is:%@\n", poi.incidentToName);
        }
        else
        {
            NSLog(@"poi.incidentToName is null\n");
        }
        
        NSLog(@"poi.incidentLength is %i\n", (int)poi.incidentLength);
        NSLog(@"poi.incidentDelay is %i\n", (int)poi.incidentDelay);

        if(poi.incidentRoadNumber != nil)
        {
            NSLog(@"poi.incidentRoadNumber is:%@\n", poi.incidentRoadNumber);
        }
        else
        {
            NSLog(@"poi.incidentRoadNumber is null\n");
        }

        if(poi.incidentCountryCode != nil)
        {
            NSLog(@"poi.incidentCountryCode is:%@\n", poi.incidentCountryCode);
        }
        else
        {
            NSLog(@"poi.incidentCountryCode is null\n");
        }
        
        NSLog(@"TTAPITrafficPoi object information trace end\n");
    }
    else
    {
        NSLog(@"TTAPITrafficPoi object is null\n");
    }
}
#endif


-(void)ProcessTrafficPoi:(TTAPITrafficPoi *)poi
{
#ifdef DEBUG
    [self TraceTrafficPoi:poi];
#endif
    if(poi != nil && poi.incidentDescription != nil && poi.poiPosition != nil && poi.poiPosition.latitude != nil && poi.poiPosition.longitude != nil && (poi.incidentFromName != nil && 0 < poi.incidentFromName.length) && (poi.incidentToName != nil && 0 < poi.incidentToName.length))
    {
        NOMRTSSourceService* pRecord = [[NOMRTSSourceService alloc] init];
        int16_t nType = [TTSDKHelper ConvertTrafficType:poi.iconCategory];
        [pRecord SetTrafficDetail:poi.incidentDescription withCause:poi.incidentCause withType:nType];
        [pRecord SetTrafficIssueRoadNumber:poi.incidentRoadNumber withCountryCode:poi.incidentCountryCode];
        [pRecord SetTrafficIssueLength:(int)poi.incidentLength withDelay:(int)poi.incidentDelay];
        [pRecord SetTrafficIssueStart:poi.incidentFromName issueEnd:poi.incidentToName];
        double dLat = [self CheckProperLatitude:[poi.poiPosition.latitude doubleValue] withVar2:[poi.poiPosition.longitude doubleValue]];
        double dLong = [self CheckProperLongitude:[poi.poiPosition.longitude doubleValue] withVar2:[poi.poiPosition.latitude doubleValue]];
        [pRecord SetBasePoint:dLat longitude:dLong];
        
        if(poi.clusterPois != nil && 0 < (int)poi.clusterPois.count)
        {
            for(int i = 0; i < (int)poi.clusterPois.count; ++i)
            {
                id element = [poi.clusterPois objectAtIndex:i];
                if(element != nil && [element isKindOfClass:[TTAPITrafficPoi class]] == YES)
                {
                    TTAPITrafficPoi* pSubPoi = (TTAPITrafficPoi*)element;
                    double dRouteLat = [self CheckProperLatitude:[pSubPoi.poiPosition.latitude doubleValue] withVar2:[pSubPoi.poiPosition.longitude doubleValue]];
                    double dRouteLong = [self CheckProperLongitude:[pSubPoi.poiPosition.longitude doubleValue] withVar2:[pSubPoi.poiPosition.latitude doubleValue]];
                    [pRecord AddRoutePoint:dRouteLat longitude:dRouteLong];
                }
            }
        }
        
        [m_RecordList addObject:pRecord];
    }

}

-(void) handleTraffic:(TTAPITrafficData *)model withPayload:(id)payload
{
    if(model == nil)
    {
        m_bSuccess = YES;
        [self Finish];
        return;
    }

    
    NSArray *currentListOfIncidents = [model getTrafficPois];
    if(currentListOfIncidents != nil && 0 < currentListOfIncidents.count)
    {
        for(TTAPITrafficPoi *poi in currentListOfIncidents)
        {
            if(poi != nil && poi.incidentDescription != nil) // ignore clusters ( when more than one incident are too close and they get in a group )
            {
                [self ProcessTrafficPoi:poi];
            }
        }
    }
    m_bSuccess = YES;
    [self Finish];
}

-(void)SetTrafficSearchParameters:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withZoom:(double)dZoom
{
    m_dLatitudeStart = latStart;
    m_dLatitudeEnd = latEnd;
    m_dLongitudeStart = lonStart;
    m_dLongitudeEnd = lonEnd;
    
    
    NSNumber*   ls = [NSNumber numberWithDouble:latStart];
    NSNumber*   ln = [NSNumber numberWithDouble:latEnd];
    NSNumber*   lw = [NSNumber numberWithDouble:lonStart];
    NSNumber*   le = [NSNumber numberWithDouble:lonEnd];
    
    //    NSNumber*   ln = [NSNumber numberWithDouble:latStart];
    //    NSNumber*   ls = [NSNumber numberWithDouble:latEnd];
    //    NSNumber*   le = [NSNumber numberWithDouble:lonStart];
    //    NSNumber*   lw = [NSNumber numberWithDouble:lonEnd];
    
    m_ScreenWGSBBox = nil;
    
    m_ScreenWGSBBox = [[TTBBox alloc] initWithLatitudeSouth:ls latitudeNorth:ln longitudeWest:lw longitudeEast:le];
    m_nZoomLevel = (int)(dZoom + 1.0);
}

#ifdef _USING_GCD_TTT_SEARCH
-(void)StartSearch
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void)
    {
        [self start];
    });
}
#endif

@end
