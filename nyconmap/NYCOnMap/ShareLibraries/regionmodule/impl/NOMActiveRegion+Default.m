//
//  NOMActiveRegion+Default.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-06.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import "NOMActiveRegion+Default.h"

@implementation NOMActiveRegion (Default)

#define ONMAP_NEWS_TOPIC                     @"theappnewstopic"
#define ONMAP_NEWS_MESSAGE_PREFIX            @"theappnewsmessageprefix"

#define ONMAP_TRAFFIC_TOPIC                  @"theapptraffictopic"
#define ONMAP_TRAFFIC_MESSAGE_PREFIX         @"theapptrafficmessageprefix"

#define ONMAP_TAXI_TOPIC                     @"theapptaxitopic"
#define ONMAP_TAXI_MESSAGE_PREFIX            @"theapptaximessageprefix"

+(NSString*)GetDefaultKey
{
    return @"OnMap";
}

-(void)_InitializeDefaultNewsTwitterAccountList
{
    if(_m_NewsQueryTwitterAcountList == nil)
        _m_NewsQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_NewsQueryTwitterAcountList removeAllObjects];

    //????
}

-(void)_InitializeDefaultTrafficTwitterAccountList
{
    if(_m_TafficQueryTwitterAcountList == nil)
        _m_TafficQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_TafficQueryTwitterAcountList removeAllObjects];

    //????
}

-(void)_InitializeDefaultRegion
{
    _m_CentralCity = @"OnMap";
    _m_CentralCityKEY = [NOMActiveRegion GetDefaultKey];
    _m_CentralStateOrProvince = @"OnMap";
    _m_CentralStateOrProvinceKey = @"OnMap";
    _m_CentralCountry = @"NewsOnMap";
    _m_CentralCountryKey = @"NewsOnMap";
    
    _m_NewsTopicName = ONMAP_NEWS_TOPIC;
    _m_TrafficTopicName = ONMAP_TRAFFIC_TOPIC;
    _m_TaxiTopicName = ONMAP_TAXI_TOPIC;
    
    _m_NewsMessagePrefix = ONMAP_NEWS_MESSAGE_PREFIX;
    _m_TrafficMessagePrefix = ONMAP_TRAFFIC_MESSAGE_PREFIX;
    _m_TaxiMessagePrefix = ONMAP_TAXI_MESSAGE_PREFIX;
    
    _m_AppLatitude = 40.72437;
    _m_AppLongitude = -73.994024;
    
    _m_AppLongitudeStart = -180;
    _m_AppLongitudeEnd = 180;
    _m_AppLatitudeStart = -90;
    _m_AppLatitudeEnd = 90;
    
    [self _InitializeDefaultNewsTwitterAccountList];
    [self _InitializeDefaultTrafficTwitterAccountList];
}


-(void)InternalCreateDefaultRegion
{
    [self _InitializeDefaultRegion];
}

@end
