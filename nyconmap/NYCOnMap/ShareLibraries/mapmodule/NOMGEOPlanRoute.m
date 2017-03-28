//
//  NOMGEOPlanRoute.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMGEOPlanRoute.h"
#import "NOMOperationManager.h"
#import "NOMGEORouteQuery.h"
#import "NOMGEOPlanRouteLineSegment.h"

@interface NOMGEOPlanRoute ()
{
    NOMOperationManager*        m_GEORouteQueryService;
    NSMutableArray*             m_Routes;
    NOMGEOPlanView*             m_Parent;
    NSString*                   m_szID;
}

@end


@implementation NOMGEOPlanRoute

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_GEORouteQueryService = [[NOMOperationManager alloc] init];
        [m_GEORouteQueryService SetOperationDelegate:self];
        m_Routes = [[NSMutableArray alloc] init];
        m_Parent = nil;
        m_szID = nil;
    }
    
    return self;
}

-(void)OperationDone:(NSOperation *)operation
{
    if(operation != nil && [operation isKindOfClass:[NOMGEORouteQuery class]])
    {
        NOMGEORouteQuery* pQuery = (NOMGEORouteQuery*)operation;
        
        if([pQuery IsSuccess] == NO)
            return;
        
        int nID = [pQuery GetQueryID];
        MKRoute* pRoute = [pQuery GetResult];
        if(0 <= nID && pRoute != nil && pRoute.polyline != nil)
        {
            MKPolyline* pLine = (MKPolyline*)[m_Routes objectAtIndex:nID];
            if(m_Parent != nil)
            {
                [m_Parent RemoveOverlay:pLine];
            }
            [m_Routes removeObjectAtIndex:nID];
            NOMGEOPlanRouteLineSegment* pSegment = [[NOMGEOPlanRouteLineSegment alloc] initWithPolyline:pRoute.polyline];
            if(m_szID != nil)
                [pSegment SetID:m_szID];
            [m_Parent AddOverlay:pSegment];
            [m_Routes insertObject:pSegment atIndex:nID];
        }
    }
}

-(void)AddRoute:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint
{
    NOMGEOPlanRouteLineSegment* pSegment = [[NOMGEOPlanRouteLineSegment alloc] initWith:startPoint end:endPoint];
    [m_Parent AddOverlay:pSegment];
    [m_Routes addObject:pSegment];
    int nID = m_Routes.count - 1;
    
    NOMGEORouteQuery* pQuery = [[NOMGEORouteQuery alloc] initQuery:startPoint end:endPoint];
    [pQuery SetQueryID:nID];
    [m_GEORouteQueryService addOperation:pQuery];
}

-(void)RegisterParent:(NOMGEOPlanView*)parent
{
    m_Parent = parent;
}

-(NSArray*)GetRoutes
{
    return m_Routes;
}

-(void)Undo
{
    [m_GEORouteQueryService cancelAllOperations];
    int nLastId = m_Routes.count -1;
    if(0 <= nLastId)
    {
        NOMGEOPlanRouteLineSegment* pSegment = [m_Routes objectAtIndex:nLastId];
        [m_Parent RemoveOverlay:pSegment];
        [m_Routes removeLastObject];
    }
}

-(void)Reset
{
    [m_GEORouteQueryService cancelAllOperations];
    [m_Parent RemoveOverlays:m_Routes];
    [m_Routes removeAllObjects];
}

-(void)SetID:(NSString*)overlayID
{
    m_szID = overlayID;
    if(m_Routes != nil && 0 < m_Routes.count)
    {
        for(int i = 0; i < m_Routes.count; ++i)
        {
            [((NOMGEOPlanRouteLineSegment*)[m_Routes objectAtIndex:i]) SetID:m_szID];
        }
    }
}

-(NSString*)GetID
{
    return m_szID;
}

@end
