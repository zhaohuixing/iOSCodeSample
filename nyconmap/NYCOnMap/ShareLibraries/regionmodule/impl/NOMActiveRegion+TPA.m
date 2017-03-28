//
//  NOMActiveRegion+TPA.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-05.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMActiveRegion+TPA.h"
#import "NOMCountryInfo.h"

@implementation NOMActiveRegion (Tampa)

#define TPAONMAP_NEWS_TOPIC                     @"xxxx"
#define TPAONMAP_NEWS_MESSAGE_PREFIX            @"xxxx"

#define TPAONMAP_TRAFFIC_TOPIC                  @"xxxx"
#define TPAONMAP_TRAFFIC_MESSAGE_PREFIX         @"xxxx"

#define TPAONMAP_TAXI_TOPIC                     @"xxxx"
#define TPAONMAP_TAXI_MESSAGE_PREFIX            @"xxxx"

+(NSString*)GetTPAKey
{
    return @"TPA";
}

-(void)_InitializeTPANewsTwitterAccountList
{
    if(_m_NewsQueryTwitterAcountList == nil)
        _m_NewsQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_NewsQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeTPATrafficTwitterAccountList
{
    if(_m_TafficQueryTwitterAcountList == nil)
        _m_TafficQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_TafficQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeTPARegion
{
    _m_CentralCity = @"Tampa";
    _m_CentralCityKEY = [NOMActiveRegion GetTPAKey];
    _m_CentralStateOrProvince = @"Florida";
    _m_CentralStateOrProvinceKey = @"FL";
    _m_CentralCountry = NOM_COUNTRY_USA;
    _m_CentralCountryKey = NOM_COUNTRY_KEY_USA;
    
    _m_NewsTopicName = TPAONMAP_NEWS_TOPIC;
    _m_TrafficTopicName = TPAONMAP_TRAFFIC_TOPIC;
    _m_TaxiTopicName = TPAONMAP_TAXI_TOPIC;
    
    _m_NewsMessagePrefix = TPAONMAP_NEWS_MESSAGE_PREFIX;
    _m_TrafficMessagePrefix = TPAONMAP_TRAFFIC_MESSAGE_PREFIX;
    _m_TaxiMessagePrefix = TPAONMAP_TAXI_MESSAGE_PREFIX;
    
    _m_AppLatitude = 27.947222;
    _m_AppLongitude = -82.458611;
    
    _m_AppLongitudeStart = -82.973518;
    _m_AppLongitudeEnd = -82.209968;
    _m_AppLatitudeStart = 27.230352;
    _m_AppLatitudeEnd = 28.536414;
    
    [self _InitializeTPANewsTwitterAccountList];
    [self _InitializeTPATrafficTwitterAccountList];
}

-(void)InternalCreateTampaRegion
{
    [self _InitializeTPARegion];
}

@end
