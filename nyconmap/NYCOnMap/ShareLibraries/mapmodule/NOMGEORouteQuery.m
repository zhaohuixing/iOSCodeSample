//
//  NOMGEORouteQuery.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-05.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMGEORouteQuery.h"

@interface NOMGEORouteQuery ()
{
    MKRoute*                        m_QueryResult;
    CLLocationCoordinate2D          m_StartPoint;
    CLLocationCoordinate2D          m_EndPoint;

    BOOL                m_bExecuting;
    BOOL                m_bFinished;
    BOOL                m_bSuccess;
    
    int                             m_nID;
}

@end

@implementation NOMGEORouteQuery

-(void)SetQueryID:(int)qID
{
    m_nID = qID;
}

-(int)GetQueryID
{
    return m_nID;
}

-(BOOL)IsSuccess
{
    return m_bSuccess;
}

-(BOOL)isExecuting
{
    return m_bExecuting;
}

-(BOOL)isFinished
{
    return m_bFinished;
}

-(void)Finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    m_bExecuting = NO;
    m_bFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

-(id)initQuery:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint
{
    self = [super init];
    
    if(self != nil)
    {
        m_QueryResult = nil;
        m_StartPoint.latitude = startPoint.latitude;
        m_StartPoint.longitude = startPoint.longitude;
        
        m_EndPoint.latitude = endPoint.latitude;
        m_EndPoint.longitude = endPoint.longitude;

        m_bExecuting = NO;
        m_bFinished = NO;
        m_bSuccess = NO;
    
        m_nID = -1;
    }
    
    return self;
}

-(MKRoute*)GetResult
{
    return m_QueryResult;
}

-(void)start
{
    m_QueryResult = nil;
    m_bSuccess = NO;
    
    //Makes sure that start method always runs on the main thread.
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    m_bExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    // Creates the Bucket to put the Object.
    @try
    {
        MKPlacemark *startmark = [[MKPlacemark alloc] initWithCoordinate:m_StartPoint addressDictionary:nil];
        MKMapItem* startMapItem = [[MKMapItem alloc] initWithPlacemark:startmark];

        MKPlacemark *endmark = [[MKPlacemark alloc] initWithCoordinate:m_EndPoint addressDictionary:nil];
        MKMapItem* endMapItem = [[MKMapItem alloc] initWithPlacemark:endmark];
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        
        request.source = startMapItem;
        request.destination = endMapItem;
        request.requestsAlternateRoutes = NO;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
         {
             if(error || response == nil || response.routes == nil || 0 == response.routes.count)
             {
                 // Handle error
                 if(error)
                     NSLog(@"NOMGEORouteQuery error : [%@]", error.description);
                 if(response == nil || response.routes == nil || 0 == response.routes.count)
                     NSLog(@"NOMGEORouteQuery error : null respone");
                 
                 m_bSuccess = NO;
                 [self Finish];
                 return;
             }
             else
             {
                 m_bSuccess = YES;
                 m_QueryResult = [response.routes objectAtIndex:0];
                 [self Finish];
                 return;
             }
         }];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"NOMGEORouteQuery Exception : [%@]", exception);
        m_bSuccess = NO;
        return;
    }
    m_bSuccess = YES;
}

@end
