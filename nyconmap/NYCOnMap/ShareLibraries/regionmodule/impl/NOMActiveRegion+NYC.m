//
//  NOMActiveRegion+NYC.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-04.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMActiveRegion+NYC.h"
#import "NOMCountryInfo.h"

@implementation NOMActiveRegion (NewYork)

#define NYCONMAP_NEWS_TOPIC                     @"xxxx"
#define NYCONMAP_NEWS_MESSAGE_PREFIX            @"xxxx"

#define NYCONMAP_TRAFFIC_TOPIC                  @"xxxx"
#define NYCONMAP_TRAFFIC_MESSAGE_PREFIX         @"xxxx"

#define NYCONMAP_TAXI_TOPIC                     @"xxxx"
#define NYCONMAP_TAXI_MESSAGE_PREFIX            @"xxxx"

+(NSString*)GetNYCKey
{
    return @"NYC";
}

-(void)_InitializeNYCNewsTwitterAccountList
{
    if(_m_NewsQueryTwitterAcountList == nil)
        _m_NewsQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_NewsQueryTwitterAcountList removeAllObjects];
}

-(void)_InitializeNYCTrafficTwitterAccountList
{
    if(_m_TafficQueryTwitterAcountList == nil)
        _m_TafficQueryTwitterAcountList = [[NSMutableArray alloc] init];
    
    [_m_TafficQueryTwitterAcountList removeAllObjects];
    
    [_m_TafficQueryTwitterAcountList addObjectsFromArray:
    [NSArray arrayWithObjects:
    @"511NYC",
    @"511nyLongIsland",
    @"Z100Traffic",
    @"MTA",
    @"NYCTBus",
    @"NYCTSubway",
    @"NYC_DOT",
    @"NotifyNYC",
    @"News12BKTW",
     nil]];
}

-(void)_InitializeNYCRegion
{
    _m_CentralCity = @"New York";
    _m_CentralCityKEY = [NOMActiveRegion GetNYCKey];
    _m_CentralStateOrProvince = @"New York";
    _m_CentralStateOrProvinceKey = @"NY";
    _m_CentralCountry = NOM_COUNTRY_USA;
    _m_CentralCountryKey = NOM_COUNTRY_KEY_USA;
    
    _m_NewsTopicName = NYCONMAP_NEWS_TOPIC;
    _m_TrafficTopicName = NYCONMAP_TRAFFIC_TOPIC;
    _m_TaxiTopicName = NYCONMAP_TAXI_TOPIC;
    
    _m_NewsMessagePrefix = NYCONMAP_NEWS_MESSAGE_PREFIX;
    _m_TrafficMessagePrefix = NYCONMAP_TRAFFIC_MESSAGE_PREFIX;
    _m_TaxiMessagePrefix = NYCONMAP_TAXI_MESSAGE_PREFIX;
    
    _m_AppLatitude = 40.72437;
    _m_AppLongitude = -73.994024;
    
    _m_AppLongitudeStart = -74.893547;
    _m_AppLongitudeEnd = -69.771446;
    _m_AppLatitudeStart = 40.405518;
    _m_AppLatitudeEnd = 41.503956;
    
    [self _InitializeNYCNewsTwitterAccountList];
    [self _InitializeNYCTrafficTwitterAccountList];
}

-(void)InternalCreateNewYorkRegion
{
    [self _InitializeNYCRegion];
}

@end
