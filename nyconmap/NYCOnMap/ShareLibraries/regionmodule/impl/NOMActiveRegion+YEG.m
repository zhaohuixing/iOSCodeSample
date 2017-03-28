//
//  NOMActiveRegion+YEG.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-05.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMActiveRegion+YEG.h"
#import "NOMCountryInfo.h"

@implementation NOMActiveRegion (Edmonton)

#define YEGONMAP_NEWS_TOPIC                     @"xxxx"
#define YEGONMAP_NEWS_MESSAGE_PREFIX            @"xxxx"

#define YEGONMAP_TRAFFIC_TOPIC                  @"xxxx"
#define YEGONMAP_TRAFFIC_MESSAGE_PREFIX         @"xxxx"

#define YEGONMAP_TAXI_TOPIC                     @"xxxx"
#define YEGONMAP_TAXI_MESSAGE_PREFIX            @"xxxx"

+(NSString*)GetYEGKey
{
    return @"YEG";
}

-(void)_InitializeYEGNewsTwitterAccountList
{
    if(_m_NewsQueryTwitterAcountList == nil)
        _m_NewsQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_NewsQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeYEGTrafficTwitterAccountList
{
    if(_m_TafficQueryTwitterAcountList == nil)
        _m_TafficQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_TafficQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeYEGRegion
{
    _m_CentralCity = @"Edmonton";
    _m_CentralCityKEY = [NOMActiveRegion GetYEGKey];
    _m_CentralStateOrProvince = @"Alberta";
    _m_CentralStateOrProvinceKey = @"AB";
    _m_CentralCountry = NOM_COUNTRY_CANADA;
    _m_CentralCountryKey = NOM_COUNTRY_KEY_CANADA;
    
    _m_NewsTopicName = YEGONMAP_NEWS_TOPIC;
    _m_TrafficTopicName = YEGONMAP_TRAFFIC_TOPIC;
    _m_TaxiTopicName = YEGONMAP_TAXI_TOPIC;
    
    _m_NewsMessagePrefix = YEGONMAP_NEWS_MESSAGE_PREFIX;
    _m_TrafficMessagePrefix = YEGONMAP_TRAFFIC_MESSAGE_PREFIX;
    _m_TaxiMessagePrefix = YEGONMAP_TAXI_MESSAGE_PREFIX;
    
    _m_AppLatitude = 53.540910;
    _m_AppLongitude = -113.499227;
    
    _m_AppLongitudeStart = -115.019439;
    _m_AppLongitudeEnd = -112.355254;
    _m_AppLatitudeStart = 52.875493;
    _m_AppLatitudeEnd = 53.879797;
    
    [self _InitializeYEGNewsTwitterAccountList];
    [self _InitializeYEGTrafficTwitterAccountList];
}

-(void)InternalCreateEdmontonRegion
{
    [self _InitializeYEGRegion];
}

@end
