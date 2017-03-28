//
//  NOMAppRegionHelper.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMAppRegionHelper.h"
#import "NOMAppInfo.h"
#import "NOMPreference.h"


static MKMapView*  g_MainAppMapView = nil;

static NOMRealTimeRegionManager* g_Regionmanager = nil;

@implementation NOMAppRegionHelper

+(NOMRealTimeRegionManager*)GetRegionManager
{
    if(g_Regionmanager == nil)
    {
        @synchronized (self)
        {
            g_Regionmanager = [[NOMRealTimeRegionManager alloc] init];
            assert(g_Regionmanager != nil);
        }
    }
    return g_Regionmanager;
}

+(void)InitializeAppRegionSystem
{
    if(g_Regionmanager == nil)
    {
        @synchronized (self)
        {
            g_Regionmanager = [[NOMRealTimeRegionManager alloc] init];
            assert(g_Regionmanager != nil);
            if([NOMAppInfo IsCityBaseAppRegionOnly] == NO)
            {
                NSString* szRegionKey = [[NOMPreference GetSharedPreference] GetCurrentRegionKey];
                if(szRegionKey != nil && 0 < szRegionKey.length)
                {
                    [g_Regionmanager SetCurrentRegion:szRegionKey];
                }
            }
        }
    }
}

+(void)SetMainMapViewObject:(MKMapView*)mapView
{
    g_MainAppMapView = mapView;
}

+(NSString*)QueryRegionTrafficTopicName:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd
{
    //??????????????????????????????????????
    //??????????????????????????????????????
    //??????????????????????????????????????
    //??????????????????????????????????????
    //??????????????????????????????????????
    //??????????????????????????????????????
    //return [NOMAppInfo GetDefaultTrafficTopicName];
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan == nil)
    {
        return [NOMAppInfo GetDefaultTrafficTopicName];
    }
    
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        NOMActiveRegion* pRegion = [rgMan GetCityBaseAppRegion];
        if(pRegion == nil)
        {
            return [NOMAppInfo GetDefaultTrafficTopicName];
        }
        else
        {
            return pRegion.m_TrafficTopicName;
        }
    }
    else
    {
        NOMActiveRegion* pRegion = [rgMan GetCurrentRegion];
        if(pRegion == nil)
        {
            return [NOMAppInfo GetDefaultTrafficTopicName];
        }
        else
        {
            return pRegion.m_TrafficTopicName;
        }
    }
    
    return nil;
}


+(NSString*)GetCurrentRegionTrafficTopicName:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd
{
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan == nil)
    {
        return [NOMAppInfo GetDefaultTrafficTopicName];
    }
    
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        NOMActiveRegion* pRegion = [rgMan GetCityBaseAppRegion];
        if(pRegion == nil)
        {
            return [NOMAppInfo GetDefaultTrafficTopicName];
        }
        else
        {
            return pRegion.m_TrafficTopicName;
        }
    }
    else
    {
        NOMActiveRegion* pRegion = [rgMan GetCurrentRegion];
        if(pRegion == nil)
        {
            return [NOMAppInfo GetDefaultTrafficTopicName];
        }
        else
        {
            return pRegion.m_TrafficTopicName;
        }
    }
    
    return nil;
}


+(NSString*)GetCurrentRegionTrafficTopicName
{
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan == nil)
    {
        return [NOMAppInfo GetDefaultTrafficTopicName];
    }
    
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        NOMActiveRegion* pRegion = [rgMan GetCityBaseAppRegion];
        if(pRegion == nil)
        {
            return [NOMAppInfo GetDefaultTrafficTopicName];
        }
        else
        {
            return pRegion.m_TrafficTopicName;
        }
    }
    else
    {
        NOMActiveRegion* pRegion = [rgMan GetCurrentRegion];
        if(pRegion == nil)
        {
            return [NOMAppInfo GetDefaultTrafficTopicName];
        }
        else
        {
            return pRegion.m_TrafficTopicName;
        }
    }
}

+(NSString*)QueryCurrentMapViewRegionTaxiTopicName
{
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan == nil)
    {
        return [NOMAppInfo GetDefaultTaxiTopicName];
    }
    
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        NOMActiveRegion* pRegion = [rgMan GetCityBaseAppRegion];
        if(pRegion == nil)
        {
            return [NOMAppInfo GetDefaultTaxiTopicName];
        }
        else
        {
            return pRegion.m_TaxiTopicName;
        }
    }
    else
    {
        NOMActiveRegion* pRegion = [rgMan GetCurrentRegion];
        if(pRegion == nil)
        {
            return [NOMAppInfo GetDefaultTaxiTopicName];
        }
        else
        {
            return pRegion.m_TaxiTopicName;
        }
    }
}

+(NSString*)GetCurrentRegionTaxiTopicName
{
    return [NOMAppRegionHelper QueryCurrentMapViewRegionTaxiTopicName];
}

+(NSString*)GetCurrentRegionNewsTopicName
{
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan == nil)
    {
        return nil;
    }
    
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        NOMActiveRegion* pRegion = [rgMan GetCityBaseAppRegion];
        if(pRegion == nil)
        {
            return nil;
        }
        else
        {
            return pRegion.m_NewsTopicName;
        }
    }
    else
    {
        NOMActiveRegion* pRegion = [rgMan GetCurrentRegion];
        if(pRegion == nil)
        {
            return nil;
        }
        else
        {
            return pRegion.m_NewsTopicName;
        }
    }
}

+(BOOL)IsCurrentMapRegionChanged
{
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        return NO;
    }
    else
    {
        //??????????????????????????????????????
        //??????????????????????????????????????
        //??????????????????????????????????????
        //??????????????????????????????????????
        //??????????????????????????????????????
        //??????????????????????????????????????
        return NO;
    }
}
+(void)UpdateCachedMapRegionData
{
    //??????????????????????????????????????
    //??????????????????????????????????????
    //??????????????????????????????????????
    //??????????????????????????????????????
    //??????????????????????????????????????
    //??????????????????????????????????????
}

+(void)GetCurrentRegion:(double*)latStart toLatitude:(double*)latEnd fromLongitude:(double*)lonStart toLongitude:(double*)lonEnd
{
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
        if(rgMan == nil)
        {
            *lonStart = [NOMAppInfo GetAppLongitudeStart];
            *lonEnd = [NOMAppInfo GetAppLongitudeEnd];
            *latStart = [NOMAppInfo GetAppLatitudeStart];
            *latEnd = [NOMAppInfo GetAppLatitudeEnd];
            return;
        }
        
        NOMActiveRegion* pRegion = [rgMan GetCityBaseAppRegion];
        if(pRegion == nil)
        {
            *lonStart = [NOMAppInfo GetAppLongitudeStart];
            *lonEnd = [NOMAppInfo GetAppLongitudeEnd];
            *latStart = [NOMAppInfo GetAppLatitudeStart];
            *latEnd = [NOMAppInfo GetAppLatitudeEnd];
            return;
        }
        *lonStart = pRegion.m_AppLongitudeStart;
        *lonEnd = pRegion.m_AppLongitudeEnd;
        *latStart = pRegion.m_AppLatitudeStart;
        *latEnd = pRegion.m_AppLatitudeEnd;
        return;
    }
    else
    {
        *lonStart = -180.0;
        *lonEnd = 180.0;
        *latStart = -90.0;
        *latEnd = 90.0;
        NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
        if(rgMan != nil)
        {
            NOMActiveRegion* pRegion = [rgMan GetCurrentRegion];
            if(pRegion != nil)
            {
                *lonStart = pRegion.m_AppLongitudeStart;
                *lonEnd = pRegion.m_AppLongitudeEnd;
                *latStart = pRegion.m_AppLatitudeStart;
                *latEnd = pRegion.m_AppLatitudeEnd;
                return;
            }
        }
    }
}

+(BOOL)IsCurrentRegionDefault
{
    BOOL bRet = NO;
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        return bRet;
    }
    else
    {
        bRet = YES;
        NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
        if(rgMan != nil)
        {
            NOMActiveRegion* pRegion = [rgMan GetCurrentRegion];
            if(pRegion != nil)
            {
                bRet = [pRegion IsDefaultRegion];
            }
        }
    }
    return bRet;
}

+(void)SetCurrentRegion:(NSString*)regionKey
{
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES || regionKey == nil || regionKey.length <= 0)
    {
        return;
    }

    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan != nil)
    {
        [rgMan SetCurrentRegion:regionKey];
    }
}

+(NSString*)GetCurrentRegionKey
{
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        if(rgMan != nil)
        {
            return [rgMan GetCityBaseAppRegionKey];
        }
        return nil;
    }
    
    if(rgMan != nil)
    {
        return [rgMan GetCurrentRegionKey];
    }
    
    return nil;
}

+(NSString*)QueryRegionKey:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong
{
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        if(rgMan != nil)
        {
            return [rgMan GetCityBaseAppRegionKey];
        }
        return nil;
    }
    
    if(rgMan != nil)
    {
        if(endLat < startLat)
        {
            double dTemp = startLat;
            startLat = endLat;
            endLat = dTemp;
        }
        
        return [rgMan IntersectRegionKey:startLat endLatitude:endLat startLongitude:startLong endLongitude:endLong];
    }
    
    return nil;
}

+(BOOL)IsMapViewRegionCached
{
    BOOL bRet = NO;
    
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan != nil)
    {
        bRet = [rgMan IsMapViewRegionCached];
    }
    
    return bRet;
}

+(void)SetCachedMapViewRegion:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong
{
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan != nil)
    {
        [rgMan SetCachedMapViewRegion:startLat endLatitude:endLat startLongitude:startLong endLongitude:endLong];
    }
}

+(void)GetCachedMapViewRegion:(double*)startLat endLatitude:(double*)endLat startLongitude:(double*)startLong endLongitude:(double*)endLong
{
    NOMRealTimeRegionManager* rgMan = [NOMAppRegionHelper GetRegionManager];
    if(rgMan != nil)
    {
        [rgMan GetCachedMapViewRegion:startLat endLatitude:endLat startLongitude:startLong endLongitude:endLong];
    }
}

@end
