//
//  NOMTrafficSpotSearchManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficSpotSearchManager.h"
#import "NOMTrafficSpotQueryService.h"
#import "NOMTrafficSpotDBHelper.h"

@interface NOMTrafficSpotSearchManager ()
{
    //NOMOperationManager*                m_SearchServiceManager;
    NSMutableArray*                             m_SearchServiceManager;
    id<INOMTrafficSpotQueryDelegate>            m_Delegate;
}

@end

@implementation NOMTrafficSpotSearchManager

-(id)initWithOperationManager:(NSMutableArray*)operMan
{
    self = [super init];
    if(self != nil)
    {
        m_SearchServiceManager = operMan;
        m_Delegate = nil;
    }
    return self;
}

-(void)RegisterDelegate:(id<INOMTrafficSpotQueryDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)SearchSpotRecords:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withType:(int16_t)nType
{
    NSString* szDomain = [NOMTrafficSpotDBHelper GetDBDomain:lonStart withLongitudeEnd:lonEnd withLatitudeStart:latStart withLatitudeEnd:latEnd withType:nType];
    CGRect rect = [NOMTrafficSpotDBHelper GetQueryRegion:lonStart withLongitudeEnd:lonEnd withLatitudeStart:latStart withLatitudeEnd:latEnd];
    
    double nlongStart = rect.origin.x;
    double nlongEnd = rect.origin.x + rect.size.width;
    double nlanStart = rect.origin.y;
    double nlanEnd = rect.origin.y + rect.size.height;


    NOMTrafficSpotQueryService* query = [[NOMTrafficSpotQueryService alloc] initWithDomain:szDomain fromLantitude:nlanStart toLantitude:nlanEnd fromLongitude:nlongStart toLongitude:nlongEnd];
    [query RegisterDelegate:m_Delegate];
    [query SetSpotType:nType];
    [m_SearchServiceManager addObject:query];
    [query StartQuery];
}

-(void)SearchSpotRecords:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withType:(int16_t)nType withSubType:(int16_t)nSubType
{
    NSString* szDomain = [NOMTrafficSpotDBHelper GetDBDomain:lonStart withLongitudeEnd:lonEnd withLatitudeStart:latStart withLatitudeEnd:latEnd withType:nType];
    CGRect rect = [NOMTrafficSpotDBHelper GetQueryRegion:lonStart withLongitudeEnd:lonEnd withLatitudeStart:latStart withLatitudeEnd:latEnd];
    
    double nlongStart = rect.origin.x;
    double nlongEnd = rect.origin.x + rect.size.width;
    double nlanStart = rect.origin.y;
    double nlanEnd = rect.origin.y + rect.size.height;


    NOMTrafficSpotQueryService* query = [[NOMTrafficSpotQueryService alloc] initWithDomain:szDomain fromLantitude:nlanStart toLantitude:nlanEnd fromLongitude:nlongStart toLongitude:nlongEnd withSubType:nSubType];
    [query RegisterDelegate:m_Delegate];
    [query SetSpotType:nType];
    [m_SearchServiceManager addObject:query];
    [query StartQuery];
}

@end
