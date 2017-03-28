//
//  NOMActiveRegion+ORD.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-05.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMActiveRegion+ORD.h"
#import "NOMCountryInfo.h"

@implementation NOMActiveRegion (Chicago)

#define ORDONMAP_NEWS_TOPIC                     @"xxxx"
#define ORDONMAP_NEWS_MESSAGE_PREFIX            @"xxxx"

#define ORDONMAP_TRAFFIC_TOPIC                  @"xxxx"
#define ORDONMAP_TRAFFIC_MESSAGE_PREFIX         @"xxxx"

#define ORDONMAP_TAXI_TOPIC                     @"xxxx"
#define ORDONMAP_TAXI_MESSAGE_PREFIX            @"xxxx"

+(NSString*)GetORDKey
{
    return @"ORD";
}

-(void)_InitializeORDNewsTwitterAccountList
{
    if(_m_NewsQueryTwitterAcountList == nil)
        _m_NewsQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_NewsQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeORDTrafficTwitterAccountList
{
    if(_m_TafficQueryTwitterAcountList == nil)
        _m_TafficQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_TafficQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeORDRegion
{
    _m_CentralCity = @"Chicago";
    _m_CentralCityKEY = [NOMActiveRegion GetORDKey];
    _m_CentralStateOrProvince = @"Illinois";
    _m_CentralStateOrProvinceKey = @"IL";
    _m_CentralCountry = NOM_COUNTRY_USA;
    _m_CentralCountryKey = NOM_COUNTRY_KEY_USA;
    
    _m_NewsTopicName = ORDONMAP_NEWS_TOPIC;
    _m_TrafficTopicName = ORDONMAP_TRAFFIC_TOPIC;
    _m_TaxiTopicName = ORDONMAP_TAXI_TOPIC;
    
    _m_NewsMessagePrefix = ORDONMAP_NEWS_MESSAGE_PREFIX;
    _m_TrafficMessagePrefix = ORDONMAP_TRAFFIC_MESSAGE_PREFIX;
    _m_TaxiMessagePrefix = ORDONMAP_TAXI_MESSAGE_PREFIX;
    
    _m_AppLatitude = 41.836944;
    _m_AppLongitude = -87.684722;
    
    _m_AppLongitudeStart = -88.638897;
    _m_AppLongitudeEnd = -87.526489;
    _m_AppLatitudeStart = 41.024898;
    _m_AppLatitudeEnd = 42.494707;
    
    [self _InitializeORDNewsTwitterAccountList];
    [self _InitializeORDTrafficTwitterAccountList];
}

-(void)InternalCreateChicagoRegion
{
    [self _InitializeORDRegion];
}

@end
