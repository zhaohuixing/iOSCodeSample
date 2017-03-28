//
//  NOMActiveRegion+DMV.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-05.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMActiveRegion+DMV.h"
#import "NOMCountryInfo.h"

@implementation NOMActiveRegion (WashingtonDC)

#define DMVONMAP_NEWS_TOPIC                     @"xxxx"
#define DMVONMAP_NEWS_MESSAGE_PREFIX            @"xxxx"

#define DMVONMAP_TRAFFIC_TOPIC                  @"xxxx"
#define DMVONMAP_TRAFFIC_MESSAGE_PREFIX         @"xxxx"

#define DMVONMAP_TAXI_TOPIC                     @"xxxx"
#define DMVONMAP_TAXI_MESSAGE_PREFIX            @"xxxx"

+(NSString*)GetDMVKey
{
    return @"DMV";
}

-(void)_InitializeDMVNewsTwitterAccountList
{
    if(_m_NewsQueryTwitterAcountList == nil)
        _m_NewsQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_NewsQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeDMVTrafficTwitterAccountList
{
    if(_m_TafficQueryTwitterAcountList == nil)
        _m_TafficQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_TafficQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeDMVRegion
{
    _m_CentralCity = @"Washington D.C.";
    _m_CentralCityKEY = [NOMActiveRegion GetDMVKey];
    _m_CentralStateOrProvince = @"Washington D.C.";
    _m_CentralStateOrProvinceKey = @"DC";
    _m_CentralCountry = NOM_COUNTRY_USA;
    _m_CentralCountryKey = NOM_COUNTRY_KEY_USA;
    
    _m_NewsTopicName = DMVONMAP_NEWS_TOPIC;
    _m_TrafficTopicName = DMVONMAP_TRAFFIC_TOPIC;
    _m_TaxiTopicName = DMVONMAP_TAXI_TOPIC;
    
    _m_NewsMessagePrefix = DMVONMAP_NEWS_MESSAGE_PREFIX;
    _m_TrafficMessagePrefix = DMVONMAP_TRAFFIC_MESSAGE_PREFIX;
    _m_TaxiMessagePrefix = DMVONMAP_TAXI_MESSAGE_PREFIX;
    
    _m_AppLatitude = 38.895111;
    _m_AppLongitude = -77.036667;
    
    _m_AppLongitudeStart = -77.611679;
    _m_AppLongitudeEnd = -76.482833;
    _m_AppLatitudeStart = 38.545133;
    _m_AppLatitudeEnd = 39.227122;
    
    [self _InitializeDMVNewsTwitterAccountList];
    [self _InitializeDMVTrafficTwitterAccountList];
}

-(void)InternalCreateWashingtonDCRegion
{
    [self _InitializeDMVRegion];
}

@end
