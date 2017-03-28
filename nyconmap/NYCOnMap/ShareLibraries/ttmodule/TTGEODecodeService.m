//
//  TTGEODecodeService.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/20/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "TTGEODecodeService.h"
#import <TomTomLBS/TTLBSSDK.h>

static TTGEODecodeService*   g_TTGEODecodeService = nil;

@interface TTGEODecodeService()
{
    TTAPILocation*                      m_GEODcoder;
    NSNumber*                           m_LatSouth;
    NSNumber*                           m_LatNorth;
    NSNumber*                           m_LongWest;
    NSNumber*                           m_LongEast;
    
    NSNumber*                           m_LatCenter;
    NSNumber*                           m_LongCenter;
    
    TTCoordinates*                      m_CenterLocation;
    
    TTBBox*                             m_QueryRegion;
    
    TTAPIGeocodeOptionalParameters*     m_OptParams;
    
    TTAPIGeocodeData*                   m_pResult;
    
    id<TTGEODecodeServiceDelegate>      m_Delegate;
}

@end


@implementation TTGEODecodeService

+(TTGEODecodeService*)getSharedService
{
    if(g_TTGEODecodeService == nil)
    {
        @synchronized (self)
        {
            g_TTGEODecodeService = [[TTGEODecodeService alloc] init];
            assert(g_TTGEODecodeService != nil);
        }
    }
    
    return g_TTGEODecodeService;
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_GEODcoder = [[TTAPILocation alloc] init];
        m_LatSouth = nil;
        m_LatNorth = nil;
        m_LongWest = nil;
        m_LongEast = nil;
        
        m_LatCenter = nil;
        m_LongCenter = nil;
        
        m_CenterLocation = nil;
        
        m_QueryRegion = nil;
        
        m_OptParams = nil;
        
        m_pResult = nil;
        
        m_Delegate = nil;
    }
    
    return self;
}

/*
-(void)dealloc
{
    [m_GEODcoder release];

    if(m_LatSouth != nil)
        [m_LatSouth release];
    
    if(m_LatNorth != nil)
        [m_LatNorth release];
        
    if(m_LongWest != nil)
        [m_LongWest release];
    
    if(m_LongEast != nil)
        [m_LongEast release];
    
    if(m_LatCenter != nil)
        [m_LatCenter release];
    
    if(m_LongCenter != nil)
        [m_LongCenter release];
    
    if(m_CenterLocation != nil)
        [m_CenterLocation release];
    
    if(m_QueryRegion != nil)
        [m_QueryRegion release];
    
    if(m_OptParams != nil)
        [m_OptParams release];
    
//    if(m_pResult != nil)
//        [m_pResult release];
    
    m_Delegate = nil;
   
#ifndef  ARC_COMPILING
    [super dealloc];
#endif
}
*/ 
 

-(BOOL)ParseLocation:(NSString*)address withStartLat:(double)startLat withEndLat:(double)endLat withStartLong:(double)startLong withEndLong:(double)endLong withResultLat:(double *)pLat withResultLong:(double *)pLong
{
    BOOL    bRet = NO;
 
    m_LatSouth = [[NSNumber alloc] initWithDouble:startLat];
    m_LatNorth = [[NSNumber alloc] initWithDouble:endLat];
    m_LongWest = [[NSNumber alloc] initWithDouble:startLong];
    m_LongEast = [[NSNumber alloc] initWithDouble:endLong];
    
    m_LatCenter = [[NSNumber alloc] initWithDouble:(startLat+endLat)/2.0];
    m_LongCenter = [[NSNumber alloc] initWithDouble:(startLong+endLong)/2.0];
    
    m_CenterLocation = [[TTCoordinates alloc] initWithLatitude:m_LatCenter andLongitude:m_LongCenter];
    
    m_QueryRegion = [TTBBox boxWithLatitudeSouth:m_LatSouth latitudeNorth:m_LatNorth longitudeWest:m_LongWest longitudeEast:m_LongEast];
    
    m_OptParams = [[TTAPIGeocodeOptionalParameters alloc] init];
    
    m_OptParams.bbox = m_QueryRegion;
    m_OptParams.biasPoint = m_CenterLocation;
    m_OptParams.order = TTLocationOrderProximity;
    
/*
    TTAPIGeocodeData* pResult = [m_GEODcoder geocode:address withOptionalParameters:m_OptParams];
    
    if(pResult != nil)
    {
        NSArray* geoResults = [pResult getGeoResults];
        if(0 < geoResults.count)
        {
            TTAPIGeoResult* geoResult = [geoResults objectAtIndex:0];
            if(geoResult != nil)
            {
                if(geoResult.latitude != nil && geoResult.longitude != nil)
                {
                    *pLat = geoResult.latitude.doubleValue;
                    *pLong = geoResult.longitude.doubleValue;
                    bRet = YES;
                }
            }
        }
    }
    
    //[pResult release];
*/
    m_pResult = [m_GEODcoder geocode:address withOptionalParameters:m_OptParams];
    
    if(m_pResult != nil)
    {
        NSArray* geoResults = [m_pResult getGeoResults];
        if(0 < geoResults.count)
        {
            TTAPIGeoResult* geoResult = [geoResults objectAtIndex:0];
            if(geoResult != nil)
            {
                if(geoResult.latitude != nil && geoResult.longitude != nil)
                {
                    *pLat = geoResult.latitude.doubleValue;
                    *pLong = geoResult.longitude.doubleValue;
                    bRet = YES;
                }
            }
        }
    }
    
    if(m_Delegate != nil)
    {
        [m_Delegate TTGEODecodeDone:self withResult:bRet];
    }
    
    return bRet;
}

-(BOOL)ParseLocation:(NSString*)address
{
    BOOL bRet = NO;
    m_pResult = [m_GEODcoder geocode:address withOptionalParameters:m_OptParams];
    
    if(m_pResult != nil)
    {
        bRet = YES;
    }
    else
    {
        bRet = NO;
    }
    
    if(m_Delegate != nil)
    {
        [m_Delegate TTGEODecodeDone:self withResult:bRet];
    }
    
    return bRet;
}

-(void)RegisterDelegate:(id<TTGEODecodeServiceDelegate>)delegate
{
    m_Delegate = delegate;
}

-(double)GetQueryLatitude
{
    double dLat = 0.0;
    
    if(m_pResult != nil)
    {
        NSArray* geoResults = [m_pResult getGeoResults];
        if(0 < geoResults.count)
        {
            TTAPIGeoResult* geoResult = [geoResults objectAtIndex:0];
            if(geoResult != nil)
            {
                if(geoResult.latitude != nil && geoResult.longitude != nil)
                {
                    dLat = geoResult.latitude.doubleValue;
                }
            }
        }
    }
    
    return dLat;
}

-(double)GetQueryLongitude
{
    double dLong = 0.0;
    
    if(m_pResult != nil)
    {
        NSArray* geoResults = [m_pResult getGeoResults];
        if(0 < geoResults.count)
        {
            TTAPIGeoResult* geoResult = [geoResults objectAtIndex:0];
            if(geoResult != nil)
            {
                if(geoResult.latitude != nil && geoResult.longitude != nil)
                {
                    dLong = geoResult.longitude.doubleValue;
                }
            }
        }
    }
    
    return dLong;
}

@end
