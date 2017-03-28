//
//  NOMRealTimeRegionManager.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-01.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMRealTimeRegionManager.h"
#import "NOMActiveRegion.h"
#import "NOMRegionCommons.h"
#import "NOMCountryInfo.h"
#import "NOMAppInfo.h"

@interface NOMRealTimeRegionManager ()
{
    NSMutableDictionary*    m_RegionList;
    NSString*               m_CurrentRegionKey;
    NSString*               m_CityBaseAppRegionKey;
    
    BOOL                    m_bCachedMapVisableRegion;
    double                  m_bCachedLongitudeStart;
    double                  m_bCachedLongitudeEnd;
    double                  m_bCachedLatitudeStart;
    double                  m_bCachedLatitudeEnd;
    
}

-(void)InitializeDefaultOnMapRegion;
-(void)InitializeCanadaRegions;
-(void)InitializeUSARegions;
-(void)InitializeRegionList;

@end


@implementation NOMRealTimeRegionManager

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_bCachedMapVisableRegion = NO;
        m_bCachedLongitudeStart = 0;
        m_bCachedLongitudeEnd = 0;
        m_bCachedLatitudeStart = 0;
        m_bCachedLatitudeEnd = 0;
        
        m_CityBaseAppRegionKey = nil;
        m_RegionList = [[NSMutableDictionary alloc] init];
        [self InitializeRegionList];
        m_CurrentRegionKey = [NOMActiveRegion GetDefaultKey];
    }
    
    return self;
}

-(void)SetCurrentRegion:(NSString*)regionKey
{
    m_CurrentRegionKey = regionKey;
}

-(NOMActiveRegion*)GetRegion:(NSString*)regionKey
{
    NOMActiveRegion* pRegion = nil;
    if(regionKey != nil && 0 < regionKey.length)
    {
        pRegion = [m_RegionList objectForKey:regionKey];
    }
    return pRegion;
}

-(NOMActiveRegion*)GetCurrentRegion
{
    NOMActiveRegion* pRegion = nil;
    if(m_CurrentRegionKey != nil && 0 < m_CurrentRegionKey.length)
    {
        pRegion = [m_RegionList objectForKey:m_CurrentRegionKey];
    }
    return pRegion;
}

-(NOMActiveRegion*)GetDefaultRegion
{
    NOMActiveRegion* pRegion = nil;
    pRegion = [m_RegionList objectForKey:[NOMActiveRegion GetDefaultKey]];
    return pRegion;
}

-(NSArray*)GetCanadianRegions
{
    NSMutableArray* array = nil;
    NSArray* cityList = [m_RegionList allValues];
    if(cityList != nil && 0 < cityList.count)
    {
        array = [[NSMutableArray alloc] init];
        for(NOMActiveRegion* pRegion in cityList)
        {
            if(pRegion.m_CentralCountryKey != nil && 0 < pRegion.m_CentralCountryKey.length)
            {
                if([pRegion.m_CentralCountryKey isEqualToString:NOM_COUNTRY_KEY_CANADA] == YES)
                {
                    [array addObject:pRegion];
                }
            }
        }
    }
    
    return array;
}

-(NSArray*)GetUSARegions
{
    NSMutableArray* array = nil;
    NSArray* cityList = [m_RegionList allValues];
    if(cityList != nil && 0 < cityList.count)
    {
        array = [[NSMutableArray alloc] init];
        for(NOMActiveRegion* pRegion in cityList)
        {
            if(pRegion.m_CentralCountryKey != nil && 0 < pRegion.m_CentralCountryKey.length)
            {
                if([pRegion.m_CentralCountryKey isEqualToString:NOM_COUNTRY_KEY_USA] == YES)
                {
                    [array addObject:pRegion];
                }
            }
        }
    }
    
    return array;
}

-(NSString*)GetCurrentRegionKey
{
    return m_CurrentRegionKey;
}

-(NSString*)GetRegionKey:(double)dLatitude longitude:(double)dLongitude
{
    NSString* szKey = nil;
    
    NOMActiveRegion* pCurrentRegion = [self GetCurrentRegion];
    if(pCurrentRegion != nil && [pCurrentRegion IsDefaultRegion] == NO)
    {
        if([pCurrentRegion InRegion:dLatitude longitude:dLongitude] == YES)
        {
            szKey = pCurrentRegion.m_CentralCityKEY;
            return szKey;
        }
    }
    
    NSArray* cityList = [m_RegionList allValues];
    if(cityList != nil && 0 < cityList.count)
    {
        for(NOMActiveRegion* pRegion in cityList)
        {
            if([pRegion IsDefaultRegion] == NO && [pRegion InRegion:dLatitude longitude:dLongitude] == YES)
            {
                szKey = pRegion.m_CentralCityKEY;
                return szKey;
            }
        }
    }
    return szKey;
}

-(void)SetCityBaseAppRegionKey:(NSString*)regionKey
{
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        m_CityBaseAppRegionKey = regionKey;
    }
}

-(NSString*)GetCityBaseAppRegionKey
{
    return m_CityBaseAppRegionKey;
}

-(NOMActiveRegion*)GetCityBaseAppRegion
{
    NOMActiveRegion* pRegion = nil;
    
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
         pRegion = [m_RegionList objectForKey:m_CityBaseAppRegionKey];
    }
    
    return pRegion;
}

-(NSString*)IntersectRegionKey:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong
{
    NSString* szKey = nil;
    
    NOMActiveRegion* pCurrentRegion = [self GetCurrentRegion];
    if(pCurrentRegion != nil && [pCurrentRegion IsDefaultRegion] == NO)
    {
        if([pCurrentRegion IntersectRectangle:startLat endLatitude:endLat startLongitude:startLong endLongitude:endLong] == YES)
        {
            szKey = pCurrentRegion.m_CentralCityKEY;
            return szKey;
        }
    }
    
    NSArray* cityList = [m_RegionList allValues];
    if(cityList != nil && 0 < cityList.count)
    {
        for(NOMActiveRegion* pRegion in cityList)
        {
            if([pRegion IsDefaultRegion] == NO && [pRegion IntersectRectangle:startLat endLatitude:endLat startLongitude:startLong endLongitude:endLong] == YES)
            {
                szKey = pRegion.m_CentralCityKEY;
                return szKey;
            }
        }
    }
    return szKey;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//Initialize Default region
//
-(void)InitializeDefaultOnMapRegion
{
    NOMActiveRegion* defualtRegion = [[NOMActiveRegion alloc] init];
    [defualtRegion CreateDefaultRegion];
    [m_RegionList setObject:defualtRegion forKey:defualtRegion.m_CentralCityKEY];
}

//?????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????
//
//Initialize Canada region list
//
//?????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????
-(void)InitializeCanadaRegions
{
    //Calgary
    NOMActiveRegion* calgaryRegion = [[NOMActiveRegion alloc] init];
    [calgaryRegion CreateCalgaryRegion];
    [m_RegionList setObject:calgaryRegion forKey:calgaryRegion.m_CentralCityKEY];

    //Edmonton
    NOMActiveRegion* edmontonRegion = [[NOMActiveRegion alloc] init];
    [edmontonRegion CreateEdmontonRegion];
    [m_RegionList setObject:edmontonRegion forKey:edmontonRegion.m_CentralCityKEY];

}

//?????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????
//
//Initialize USA region list
//
//?????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????
-(void)InitializeUSARegions
{
    //New York
    NOMActiveRegion* newyorkRegion = [[NOMActiveRegion alloc] init];
    [newyorkRegion CreateNewYorkRegion];
    [m_RegionList setObject:newyorkRegion forKey:newyorkRegion.m_CentralCityKEY];

    //Chicago
    NOMActiveRegion* chicagoRegion = [[NOMActiveRegion alloc] init];
    [chicagoRegion CreateChicagoRegion];
    [m_RegionList setObject:chicagoRegion forKey:chicagoRegion.m_CentralCityKEY];

    //Washington DC
    NOMActiveRegion* dcRegion = [[NOMActiveRegion alloc] init];
    [dcRegion CreateWashingtonDCRegion];
    [m_RegionList setObject:dcRegion forKey:dcRegion.m_CentralCityKEY];

    //Tampa
    NOMActiveRegion* tampaRegion = [[NOMActiveRegion alloc] init];
    [tampaRegion CreateTampaRegion];
    [m_RegionList setObject:tampaRegion forKey:tampaRegion.m_CentralCityKEY];
    
}

//?????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????
//
//Initialize region list
//
//?????????????????????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????????????????????
-(void)InitializeRegionList
{
    [self InitializeDefaultOnMapRegion];
    [self InitializeCanadaRegions];
    [self InitializeUSARegions];
}

-(BOOL)IsMapViewRegionCached
{
    return m_bCachedMapVisableRegion;
}

-(void)SetCachedMapViewRegion:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong
{
    m_bCachedMapVisableRegion = YES;
    m_bCachedLongitudeStart = startLong;
    m_bCachedLongitudeEnd = endLong;
    m_bCachedLatitudeStart = startLat;
    m_bCachedLatitudeEnd = endLat;
}

-(void)GetCachedMapViewRegion:(double*)startLat endLatitude:(double*)endLat startLongitude:(double*)startLong endLongitude:(double*)endLong
{
    *startLong = m_bCachedLongitudeStart;
    *endLong = m_bCachedLongitudeEnd;
    *startLat = m_bCachedLatitudeStart;
    *endLat = m_bCachedLatitudeEnd;
}

@end
