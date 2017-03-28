//
//  NOMTrafficSpotDBHelper.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficSpotDBHelper.h"
#import "NOMSystemConstants.h"
//#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"

@implementation NOMTrafficSpotDBHelper

+(NSString*)GetPhotoRadarDBDomain:(double)sx1 srcY:(double)sy1
{
    NSString* szDBDomain = NOM_TRAFFICSPOT_PHOTORADAR_PREFIX;
    
    int16_t nIndex = 0;
    
    if(sx1 <= 0 && -180 <= sx1 && 0 <= sy1)
    {
        nIndex = 0;
    }
    else if(0 <= sx1 && sx1 <= 180 && 0 <= sy1)
    {
        nIndex = 1;
    }
    else if(sy1 < 0)
    {
        nIndex = 2;
    }
    
    szDBDomain = [NSString stringWithFormat:@"%@%i", NOM_TRAFFICSPOT_PHOTORADAR_PREFIX, nIndex];
    
    return szDBDomain;
}

+(NSString*)GetSchoolZoneDBDomain:(double)sx1 srcY:(double)sy1
{
    NSString* szDBDomain = NOM_TRAFFICSPOT_SCHOOLZONE_PREFIX;
    
    int16_t nIndex = 0;
    
    if(sx1 <= 0 && -180 <= sx1 && 0 <= sy1)
    {
        nIndex = 0;
    }
    else if(0 <= sx1 && sx1 <= 180 && 0 <= sy1)
    {
        nIndex = 1;
    }
    else if(sy1 < 0)
    {
        nIndex = 2;
    }
    
    szDBDomain = [NSString stringWithFormat:@"%@%i", NOM_TRAFFICSPOT_SCHOOLZONE_PREFIX, nIndex];
    
    return szDBDomain;
}

+(NSString*)GetPlaygroundDBDomain:(double)sx1 srcY:(double)sy1
{
    NSString* szDBDomain = NOM_TRAFFICSPOT_PLAYGROUND_PREFIX;
    
    int16_t nIndex = 0;
    
    if(sx1 <= 0 && -180 <= sx1 && 0 <= sy1)
    {
        nIndex = 0;
    }
    else if(0 <= sx1 && sx1 <= 180 && 0 <= sy1)
    {
        nIndex = 1;
    }
    else if(sy1 < 0)
    {
        nIndex = 2;
    }
    
    szDBDomain = [NSString stringWithFormat:@"%@%i", NOM_TRAFFICSPOT_PLAYGROUND_PREFIX, nIndex];
    
    return szDBDomain;
}

+(NSString*)GetGasStationDBDomain:(double)sx1 srcY:(double)sy1
{
    NSString* szDBDomain = NOM_TRAFFICSPOT_GASSTATION_PREFIX;
    
    int16_t nIndex = 0;
    
    if(sx1 <= 0 && -180 <= sx1 && 0 <= sy1)
    {
        nIndex = 0;
    }
    else if(0 <= sx1 && sx1 <= 180 && 0 <= sy1)
    {
        nIndex = 1;
    }
    else if(sy1 < 0)
    {
        nIndex = 2;
    }
    
    szDBDomain = [NSString stringWithFormat:@"%@%i", NOM_TRAFFICSPOT_GASSTATION_PREFIX, nIndex];
    
    return szDBDomain;
}

+(NSString*)GetParkingDBDomain
{
    return NOM_TRAFFICSPOT_PARKING_DOMAIN;
}

+(NSString*)GetDBDomain:(double)sx1 srcY:(double)sy1 withType:(int16_t)nType
{
    NSString* szDBDomain = @"";

    if(nType == NOM_TRAFFICSPOT_PHOTORADAR)
    {
        szDBDomain = [NOMTrafficSpotDBHelper GetPhotoRadarDBDomain:sx1 srcY:sy1];
    }
    else if(nType == NOM_TRAFFICSPOT_SCHOOLZONE)
    {
        szDBDomain = [NOMTrafficSpotDBHelper GetSchoolZoneDBDomain:sx1 srcY:sy1];
    }
    else if(nType == NOM_TRAFFICSPOT_PLAYGROUND)
    {
        szDBDomain = [NOMTrafficSpotDBHelper  GetPlaygroundDBDomain:sx1 srcY:sy1];
    }
    else if(nType == NOM_TRAFFICSPOT_GASSTATION)
    {
        szDBDomain = [NOMTrafficSpotDBHelper  GetGasStationDBDomain:sx1 srcY:sy1];
    }
    else if(nType == NOM_TRAFFICSPOT_PARKINGGROUND)
    {
        szDBDomain = [NOMTrafficSpotDBHelper GetParkingDBDomain];
    }
    
    return szDBDomain;
}

+(NSString*)GetDBDomain:(CLLocationDegrees)longitude withLatitude:(CLLocationDegrees)lantitude withType:(int16_t)nType
{
    NSString* szDBDomain = [NOMTrafficSpotDBHelper GetDBDomain:longitude srcY:lantitude withType:nType];
    return szDBDomain;
}

+(NSString*)GetDBDomain:(CLLocationDegrees)longitudeStart withLongitudeEnd:(CLLocationDegrees)longitudeEnd withLatitudeStart:(CLLocationDegrees)lantitudeStart withLatitudeEnd:(CLLocationDegrees)lantitudeEnd withType:(int16_t)nType
{
    NSString* szDBDomain = @"";

    double sx = (longitudeStart + longitudeEnd)*0.5;
    double sy = (lantitudeStart + lantitudeEnd)*0.5;
    
    szDBDomain = [NOMTrafficSpotDBHelper GetDBDomain:sx srcY:sy withType:nType];
    
    return szDBDomain;
}

+(CGRect)GetQueryRegion:(CLLocationDegrees)longitudeStart withLongitudeEnd:(CLLocationDegrees)longitudeEnd withLatitudeStart:(CLLocationDegrees)lantitudeStart withLatitudeEnd:(CLLocationDegrees)lantitudeEnd
{
    CGRect rect = CGRectMake(0, 0, -1, -1);
    
    double sx = (longitudeStart + longitudeEnd)*0.5;
    double sy = (lantitudeStart + lantitudeEnd)*0.5;
    
    double m_LongitudeStart = -1, m_LantitudeStart = -1, m_LongitudeEnd = 0, m_LantitudeEnd = 0;
    
    if(sx <= 0 && -180 <= sx && 0 <= sy)
    {
        m_LongitudeStart = -180;
        m_LantitudeStart = 0;
        m_LongitudeEnd = 0;
        m_LantitudeEnd = 90;
    }
    else if(0 <= sx && sx <= 180 && 0 <= sy)
    {
        m_LongitudeStart = 0;
        m_LantitudeStart = 0;
        m_LongitudeEnd = 180;
        m_LantitudeEnd = 90;
    }
    else if(sy < 0)
    {
        m_LongitudeStart = -180;
        m_LantitudeStart = -90;
        m_LongitudeEnd = 180;
        m_LantitudeEnd = 0;
    }
    
    double ls = longitudeStart;
    double le = longitudeEnd;
    if(ls < -180)
    {
        if(-180 < longitudeEnd && longitudeEnd < 0)
            ls = -180;
        else
        {
            ls = 360 + longitudeStart;
            if(0 < ls && le < 0)
                le = 180;
        }
    }
    else if(180 < ls)
    {
        ls = 180 - longitudeStart;
    }
    
    if(180 < le)
        le = 180;
    
    double dLeft = MAX(ls, m_LongitudeStart);
    
    double dRight = MIN(le, m_LongitudeEnd);
    
    double dTop = MAX(lantitudeStart, m_LantitudeStart);
    double dBottom = MIN(lantitudeEnd, m_LantitudeEnd);
    
    double dWidth = dRight - dLeft;
    double dHeight = dBottom - dTop;
    
    if(0 < dWidth && 0 < dHeight)
    {
        rect = CGRectMake(dLeft, dTop, dWidth, dHeight);
    }

    return rect;
}

@end
