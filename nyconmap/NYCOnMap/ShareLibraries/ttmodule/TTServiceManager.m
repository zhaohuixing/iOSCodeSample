//
//  TTServiceManager.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/20/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "TTServiceManager.h"
#import "TTTrafficSearch.h"
#import "TTConstants.h"
#import "NOMOperationManager.h"

//static TTServiceManager*   g_TTServiceManager = nil;

@interface TTServiceManager()
{
    id<TTServiceManagerDelegate>                m_Delegate;

#ifdef _USING_GCD_TTT_SEARCH
    NSMutableArray*                             m_OperationManager;
#else
    NOMOperationManager*                        m_OperationManager;
#endif
}

@end

@implementation TTServiceManager

+(void)RegisterTTService
{
    [[TTSDKContext sharedContext] setDeveloperKey:TTSDK_API_KEY];
}

/*
+(TTServiceManager*)getServiceManager
{
    if(g_TTServiceManager == nil)
    {
        @synchronized (self)
        {
            g_TTServiceManager = [[TTServiceManager alloc] init];
            assert(g_TTServiceManager != nil);
        }
    }
    
    return g_TTServiceManager;
}

+(void)InitializeTTService:(id<TTServiceManagerDelegate>)delegate
{
    if(g_TTServiceManager == nil)
    {
        @synchronized (self)
        {
            g_TTServiceManager = [[TTServiceManager alloc] init];
            assert(g_TTServiceManager != nil);
        }
    }
    
    [g_TTServiceManager RegisterDelegate:delegate];
}
*/

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Delegate = nil;
#ifdef _USING_GCD_TTT_SEARCH
        m_OperationManager = [[NSMutableArray alloc] init];
#else
        m_OperationManager = [[NOMOperationManager alloc] init];
        [m_OperationManager SetOperationDelegate:self];
#endif
    }
    
    return self;
}


-(void)RegisterDelegate:(id<TTServiceManagerDelegate>)delegate
{
    m_Delegate = delegate;
}

#ifdef _USING_GCD_TTT_SEARCH
-(void)TrafficSearchDone:(id)pTTSearch withResult:(BOOL)bSucceed
{
    if(bSucceed && pTTSearch != nil && [pTTSearch isKindOfClass:[TTTrafficSearch class]] == YES)
    {
        TTTrafficSearch* searchTask = (TTTrafficSearch*)pTTSearch;
        [m_Delegate TrafficSearchDone:[searchTask GetRecordList] withResult:YES];
    }
    [m_OperationManager removeObject:pTTSearch];
}
#else
-(void)OperationDone:(NSOperation *)searchTask
{
    if(searchTask != nil && [searchTask isKindOfClass:[TTTrafficSearch class]] == YES && m_Delegate != nil)
    {
        bool bSuccess = [(TTTrafficSearch*)searchTask IsSucceeded];
        [m_Delegate TrafficSearchDone:[(TTTrafficSearch*)searchTask GetRecordList] withResult:bSuccess];
    }
}
#endif

-(void)SearchTraffic:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withZoom:(double)dZoom
{
#ifdef _USING_GCD_TTT_SEARCH
    TTTrafficSearch* searchTask = [[TTTrafficSearch alloc] initWith:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withZoom:dZoom];
    [searchTask RegisterDelegate:self];
    [m_OperationManager addObject:searchTask];
    [searchTask StartSearch];
#else
    TTTrafficSearch* searchTask = [[TTTrafficSearch alloc] initWith:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withZoom:dZoom];
    [searchTask RegisterDelegate:self];
    [m_OperationManager addOperation:searchTask];
#endif
}

@end
