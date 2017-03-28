//
//  NOMActiveRegion.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-01.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMActiveRegion.h"
#import "NOMCountryInfo.h"
#import "NOMActiveRegion+NYC.h"
#import "NOMActiveRegion+YYC.h"
#import "NOMActiveRegion+YEG.h"
#import "NOMActiveRegion+DMV.h"
#import "NOMActiveRegion+ORD.h"
#import "NOMActiveRegion+TPA.h"
#import "NOMActiveRegion+Default.h"

@implementation NOMActiveRegion

@synthesize m_CentralCity = _m_CentralCity;
@synthesize m_CentralCityKEY = _m_CentralCityKEY;
@synthesize m_CentralStateOrProvince = _m_CentralStateOrProvince;
@synthesize m_CentralStateOrProvinceKey = _m_CentralStateOrProvinceKey;
@synthesize m_CentralCountry = _m_CentralCountry;
@synthesize m_CentralCountryKey = _m_CentralCountryKey;

@synthesize m_NewsTopicName = _m_NewsTopicName;
@synthesize m_TrafficTopicName = _m_TrafficTopicName;
@synthesize m_TaxiTopicName = _m_TaxiTopicName;

//@synthesize m_NewsMessagePrefix = _m_NewsMessagePrefix;
//@synthesize m_TrafficMessagePrefix = _m_TrafficMessagePrefix;
//@synthesize m_TaxiMessagePrefix = _m_TaxiMessagePrefix;

@synthesize m_AppLatitude = _m_AppLatitude;
@synthesize m_AppLongitude = _m_AppLongitude;

@synthesize m_AppLongitudeStart = _m_AppLongitudeStart;
@synthesize m_AppLongitudeEnd = _m_AppLongitudeEnd;
@synthesize m_AppLatitudeStart = _m_AppLatitudeStart;
@synthesize m_AppLatitudeEnd = _m_AppLatitudeEnd;

@synthesize m_NewsQueryTwitterAcountList = _m_NewsQueryTwitterAcountList;
@synthesize m_TafficQueryTwitterAcountList = _m_TafficQueryTwitterAcountList;

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        _m_NewsQueryTwitterAcountList = nil;
        _m_TafficQueryTwitterAcountList = nil;
        [self CreateNewYorkRegion];
    }
    
    return self;
}

-(BOOL)InRegion:(double)dLatitude longitude:(double)dLongitude
{
    BOOL bRet = NO;
    
    if(_m_AppLatitudeStart <= dLatitude && dLatitude <= _m_AppLatitudeEnd &&
       _m_AppLongitudeStart <= dLongitude && dLongitude <= _m_AppLongitudeEnd)
    {
        bRet = YES;
    }
    
    return bRet;
}

-(BOOL)IntersectRectangle:(double)startLat endLatitude:(double)endLat startLongitude:(double)startLong endLongitude:(double)endLong
{
    BOOL bRet = NO;
    
    if(startLat <= _m_AppLatitudeStart && _m_AppLatitudeStart <= endLat &&
       startLong <= _m_AppLongitudeStart && _m_AppLongitudeStart <= endLong)
    {
        bRet = YES;
        return bRet;
    }

    if(startLat <= _m_AppLatitudeStart && _m_AppLatitudeStart <= endLat &&
       startLong <= _m_AppLongitudeEnd && _m_AppLongitudeEnd <= endLong)
    {
        bRet = YES;
        return bRet;
    }

    if(startLat <= _m_AppLatitudeEnd && _m_AppLatitudeEnd <= endLat &&
       startLong <= _m_AppLongitudeEnd && _m_AppLongitudeEnd <= endLong)
    {
        bRet = YES;
        return bRet;
    }

    if(startLat <= _m_AppLatitudeEnd && _m_AppLatitudeEnd <= endLat &&
       startLong <= _m_AppLongitudeStart && _m_AppLongitudeStart <= endLong)
    {
        bRet = YES;
        return bRet;
    }
    
    bRet = [self InRegion:startLat longitude:startLong];
    if(bRet == YES)
    {
        return bRet;
    }

    bRet = [self InRegion:startLat longitude:endLong];
    if(bRet == YES)
    {
        return bRet;
    }

    bRet = [self InRegion:endLat longitude:endLong];
    if(bRet == YES)
    {
        return bRet;
    }

    bRet = [self InRegion:endLat longitude:startLong];
    if(bRet == YES)
    {
        return bRet;
    }
    
    return bRet;
}

-(BOOL)IsDefaultRegion
{
    BOOL bRet = NO;
    
    if([_m_CentralCityKEY isEqualToString:[NOMActiveRegion GetDefaultKey]] == YES)
    {
        bRet = YES;
    }
    
    return bRet;
}

-(void)CreateDefaultRegion
{
    [self InternalCreateDefaultRegion];
}

-(void)CreateNewYorkRegion
{
    [self InternalCreateNewYorkRegion];
}

-(void)CreateCalgaryRegion
{
    [self InternalCreateCalgaryRegion];
}

-(void)CreateEdmontonRegion
{
    [self InternalCreateEdmontonRegion];
}

-(void)CreateWashingtonDCRegion
{
    [self InternalCreateWashingtonDCRegion];
}

-(void)CreateChicagoRegion
{
    [self InternalCreateChicagoRegion];
}

-(void)CreateTampaRegion
{
    [self InternalCreateTampaRegion];
}

@end
