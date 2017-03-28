//
//  NOMActiveRegion+YYC.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-04.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMActiveRegion+YYC.h"
#import "NOMCountryInfo.h"

@implementation NOMActiveRegion (Calgary)

#define YYCONMAP_NEWS_TOPIC                     @"xxxx"
#define YYCONMAP_NEWS_MESSAGE_PREFIX            @"xxxx"

#define YYCONMAP_TRAFFIC_TOPIC                  @"xxxx"
#define YYCONMAP_TRAFFIC_MESSAGE_PREFIX         @"xxxx"

#define YYCONMAP_TAXI_TOPIC                     @"xxxx"
#define YYCONMAP_TAXI_MESSAGE_PREFIX            @"xxxx"

+(NSString*)GetYYCKey
{
    return @"YYC";
}

-(void)_InitializeYYCNewsTwitterAccountList
{
    if(_m_NewsQueryTwitterAcountList == nil)
        _m_NewsQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_NewsQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeYYCTrafficTwitterAccountList
{
    if(_m_TafficQueryTwitterAcountList == nil)
        _m_TafficQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_TafficQueryTwitterAcountList removeAllObjects];
    //?????
}

-(void)_InitializeYYCRegion
{
    _m_CentralCity = @"Calgary";
    _m_CentralCityKEY = [NOMActiveRegion GetYYCKey];
    _m_CentralStateOrProvince = @"Alberta";
    _m_CentralStateOrProvinceKey = @"AB";
    _m_CentralCountry = NOM_COUNTRY_CANADA;
    _m_CentralCountryKey = NOM_COUNTRY_KEY_CANADA;
    
    _m_NewsTopicName = YYCONMAP_NEWS_TOPIC;
    _m_TrafficTopicName = YYCONMAP_TRAFFIC_TOPIC;
    _m_TaxiTopicName = YYCONMAP_TAXI_TOPIC;
    
    _m_NewsMessagePrefix = YYCONMAP_NEWS_MESSAGE_PREFIX;
    _m_TrafficMessagePrefix = YYCONMAP_TRAFFIC_MESSAGE_PREFIX;
    _m_TaxiMessagePrefix = YYCONMAP_TAXI_MESSAGE_PREFIX;
    
    _m_AppLatitude = 51.050819;
    _m_AppLongitude = -114.070612;
    
    _m_AppLongitudeStart = -114.590513;
    _m_AppLongitudeEnd = -113.193876;
    _m_AppLatitudeStart = 50.333419;
    _m_AppLatitudeEnd = 51.315818;
    
    [self _InitializeYYCNewsTwitterAccountList];
    [self _InitializeYYCTrafficTwitterAccountList];
}

-(void)InternalCreateCalgaryRegion
{
    [self _InitializeYYCRegion];
}

@end
