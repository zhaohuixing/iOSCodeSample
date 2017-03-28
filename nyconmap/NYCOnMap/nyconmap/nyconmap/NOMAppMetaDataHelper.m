//
//  NOMAppMetaDataHelper.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMAppMetaDataHelper.h"
#import "NOMAppWatchDataHelper.h"

static  BOOL	m_bIPadDevice = YES;
static  BOOL	m_bOnSimulator = NO;
static  BOOL    m_bRetinaDisplay = NO;

#ifdef DEBUG
static  BOOL	m_bShowAdBanner = YES;
#else
static  BOOL	m_bShowAdBanner = YES;
#endif

#define DEFAULT_GOOGLE_ADBANNER_UNITID  @"xxxxxxxxxxxxxxxxxxxxx"
#define DEFAULT_GOOGLE_ADLOCATION_LATITUDE      40.72437
#define DEFAULT_GOOGLE_ADLOCATION_LONGITUDE     -73.994024
#define DEFAULT_GOOGLE_ADLOCATION_RADIUS        50000
#define DEFAULT_APP_COVER_RADIUS                4

#define DEFAULT_APPLOCATION_LATITUDE_START      40.405518
#define DEFAULT_APPLOCATION_LATITUDE_END        41.503956
#define DEFAULT_APPLOCATION_LONGITUDE_START     -74.893547
#define DEFAULT_APPLOCATION_LONGITUDE_END       -69.771446

#define DEFAULT_TRAFFIC_TOPIC               @"xxxxxxxxxxxx"
#define DEFAULT_TRAFFIC_MESSAGE_KEY         @"xxxxxxxxxxxx_key"
#define DEFAULT_TRAFFIC_MESSAGE_PREFIX      @"xxxxxxxxxxxx_"



#define DEFAULT_TAXI_TOPIC                  @"xxxxxxxxxxxx"
#define DEFAULT_TAXI_MESSAGE_KEY            @"xxxxxxxxxxxx_key"
#define DEFAULT_TAXI_MESSAGE_PREFIX         @"xxxxxxxxxxxx_"



#define DEFAULT_PLATFORM_APPLICATION_ARN               @"arn:aws:sns:us-xxxx-1:xxxxxxxxxxxx:app/xxxxxxxxxxxx"
#define DEFAULT_PLATFORM_APPLICATION_ARN_DEBUG         @"arn:aws:sns:us-xxxx-1:xxxxxxxxxxxx:app/xxxxxxxxxxxxxxxx"

#define DEFAULT_PLATFORM_DEVICETOKEN_KEY           @"xxxxxxxxxxxx_key"
#define DEFAULT_PLATFORM_DEVICETOKEN_KEY_DEBUG     @"xxxxxxxxxxxx_key_debug"

#define DEFAULT_PLATFORM_ENDPOINT_ARN_KEY           @"xxxxxxxxxxxx_key"
#define DEFAULT_PLATFORM_ENDPOINT_ARN_KEY_DEBUG     @"xxxxxxxxxxxx_key_debug"

#define CURRENT_APP_KEY                             @"xxxxxxxxxxxx"

#define CURRENT_APP_TERMOFUSE_KEY                   @"xxxxxxxxxxxx_key";

#define CURRENT_APP_DISPLAYNAME                     @"NewYork OnMap"


#define DEFAULT_SIMULATOR_FAKE_DEVICETOKEN     @"xxxxxxxxxxxxxxxxxx"

#define ONMAPTWEET_CONSUMER_KEY                 @"xxxxxxxxxxxxxxxxx"
#define ONMAPTWEET_CONSUMER_SECRET              @"yourskey"


#define ONMAPTWEET_ACCESS_TOKEN                 @"youraccesstoken"
#define ONMAPTWEET_ACCESS_TOKEN_SECRET          @"yoursxxxxxxxxxxxx"

#define ONMAPTWEET_ACCOUNT_NAME                 @"XXXXXXXX"
#define ONMAPTWEET_APP_HASHKEY                  @"#NYT@"
#define ONMAPTWEET_APP_CITYKEY                  @"#NYC"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

static double m_dOSVersionLevel = 4.0;

static BOOL m_bAcceptTermOfUse = NO;

#define APP_APPLESTORE_URL                  @"https://itunes.apple.com/us/app/new-york-onmap/id939326122?ls=1&mt=8"


@implementation NOMAppMetaDataHelper

+(NSString*)GetAppStoreURL
{
    return APP_APPLESTORE_URL;
}

+(NSString*)GetAppDisplayName
{
    return CURRENT_APP_DISPLAYNAME;
}

+(NSString*)GetAppKey
{
    return CURRENT_APP_KEY;
}

+(NSString*)GetTermOfUseKey
{
    return CURRENT_APP_TERMOFUSE_KEY;
}

+(void)AcceptTermOfUse
{
    m_bAcceptTermOfUse = YES;
    
    NSString* sKey = [NOMAppMetaDataHelper GetTermOfUseKey];
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:m_bAcceptTermOfUse forKey:sKey];
    [prefs synchronize];
}

+(BOOL)GetTermOfUse
{
    return m_bAcceptTermOfUse;
}

+(void)InitializeSystemConfiguration
{
    NSString *deviceModel = (NSString*)[UIDevice currentDevice].model;
    
    if ([deviceModel hasPrefix:@"iPad"] == YES || [deviceModel hasSuffix:@"iPad"] == YES)
    {
        m_bIPadDevice = YES;
    }
    else
    {
        m_bIPadDevice = NO;
    }
    
    if([deviceModel rangeOfString:@"Simulator"].location == NSNotFound)
    {
        m_bOnSimulator = NO;
    }
    else
    {
        NSLog(@"Test Current Running Env: %@",deviceModel);
        m_bOnSimulator = YES;
    }
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        m_dOSVersionLevel = 8.0;
    }
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        m_dOSVersionLevel = 7.0;
    }
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        m_dOSVersionLevel = 6.0;
    }
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
    {
        m_dOSVersionLevel = 5.0;
    }
   
    if(1.0 < (double)[UIScreen mainScreen].scale)
    {
        m_bRetinaDisplay = YES;
    }
    else
    {
        m_bRetinaDisplay = NO;
    }
    
    m_bAcceptTermOfUse = NO;
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* sKey = [NOMAppMetaDataHelper GetTermOfUseKey];
    m_bAcceptTermOfUse = [prefs boolForKey:sKey];
    
}

+(BOOL)IsDeviceIPad
{
    return m_bIPadDevice;
}

+(BOOL)IsDeviceIPhone
{
    return !m_bIPadDevice;
}

+(BOOL)IsOnSimulator
{
    return m_bOnSimulator;
}

+(BOOL)IsRetinaDisplay
{
    return m_bRetinaDisplay;
}

+(BOOL)CanScaleMapElement
{
    return YES;
/*
    if(m_bIPadDevice == NO)
        return NO;
    
    if(m_bRetinaDisplay == NO)
        return NO;
        
    return YES;
*/
}

+(BOOL)ShowAdBanner
{
    return m_bShowAdBanner;
}

+(void)SetAdBannerShow:(BOOL)bShow
{
    m_bShowAdBanner = bShow;
}

+(BOOL)IsCityBaseAppRegionOnly
{
#ifdef _SINGLE_CITYAPP_
    return YES;
#else
    return NO;
#endif
}

+(int)GetAppRegionCountryIndex
{
    return 0;
}

+(NSString*)GetGoogleADUnitID
{
    return DEFAULT_GOOGLE_ADBANNER_UNITID;
}

+(double)GetGoogleADAccuracy
{
    return DEFAULT_GOOGLE_ADLOCATION_RADIUS;
}

+(double)GetAppLatitude
{
    return DEFAULT_GOOGLE_ADLOCATION_LATITUDE;
}

+(double)GetAppLongitude
{
    return DEFAULT_GOOGLE_ADLOCATION_LONGITUDE;
}

+(double)GetAppRegionRangeDegree
{
    return DEFAULT_APP_COVER_RADIUS;
}


+(double)GetAppLongitudeStart
{
    return DEFAULT_APPLOCATION_LONGITUDE_START;
}

+(double)GetAppLongitudeEnd
{
    return DEFAULT_APPLOCATION_LONGITUDE_END;
}

+(double)GetAppLatitudeStart
{
    return DEFAULT_APPLOCATION_LATITUDE_START;
}

+(double)GetAppLatitudeEnd
{
    return DEFAULT_APPLOCATION_LATITUDE_END;
}


+(NSString*)GetDefaultTrafficTopicName
{
    return DEFAULT_TRAFFIC_TOPIC;
}

+(NSString*)GetTrafficMessageQueueKey
{
    return DEFAULT_TRAFFIC_MESSAGE_KEY;
}

+(NSString*)GetTrafficMessageQueueNamePrefix
{
    return DEFAULT_TRAFFIC_MESSAGE_PREFIX;
}

+(NSString*)GetDefaultTaxiTopicName
{
    return DEFAULT_TAXI_TOPIC;
}

+(NSString*)GetTaxiMessageQueueKey
{
    return DEFAULT_TAXI_MESSAGE_KEY;
}

+(NSString*)GetTaxiMessageQueueNamePrefix
{
    return DEFAULT_TAXI_MESSAGE_PREFIX;
}

+(NSString*)GetPlatformApplicationARN
{
//#ifdef DEBUG
//    return DEFAULT_PLATFORM_APPLICATION_ARN_DEBUG;
//#else
    return DEFAULT_PLATFORM_APPLICATION_ARN;
//#endif
}

+(NSString*)GetAWSDeviceTokenPrefKey
{
//#ifdef DEBUG
//    return DEFAULT_PLATFORM_DEVICETOKEN_KEY_DEBUG;
//#else
    return DEFAULT_PLATFORM_DEVICETOKEN_KEY;
//#endif
}

+(NSString*)GetAWSMobileEndPointARNPrefKey
{
//#ifdef DEBUG
//    return DEFAULT_PLATFORM_ENDPOINT_ARN_KEY_DEBUG;
//#else
    return DEFAULT_PLATFORM_ENDPOINT_ARN_KEY;
//#endif
}

+(NSString*)GetSimulatorFakeToken
{
    return DEFAULT_SIMULATOR_FAKE_DEVICETOKEN;
}

+(void)SetSimpleSearchMode:(BOOL)bSimpleMode
{
    [NOMAppWatchDataHelper SetSimpleSearchMode:bSimpleMode];
}

+(BOOL)IsSimpleSearchMode
{
    return [NOMAppWatchDataHelper IsSimpleSearchMode];
}

+(NSString*)GetAppTwitterCustomerKey
{
    return ONMAPTWEET_CONSUMER_KEY;
}

+(NSString*)GetAppTwitterCustomerSecret
{
    return ONMAPTWEET_CONSUMER_SECRET;
}

+(NSString*)GetAppTwitterAccessToken
{
    return ONMAPTWEET_ACCESS_TOKEN;
}

+(NSString*)GetAppTwitterAccessTokenSecret
{
    return ONMAPTWEET_ACCESS_TOKEN_SECRET;
}

+(NSString*)GetAppTwitterDevUserName
{
    return ONMAPTWEET_ACCOUNT_NAME;
}

+(NSString*)GetAppTwitterHashKey
{
    return ONMAPTWEET_APP_HASHKEY;
}

+(NSString*)GetCurrentCityTwitterHashKey
{
    return ONMAPTWEET_APP_CITYKEY;
}

+(BOOL)IsVersion8
{
    if(8.0 <= m_dOSVersionLevel)
        return YES;
    
    return NO;
}

+(BOOL)IsVersion7
{
    if(7.0 <= m_dOSVersionLevel && m_dOSVersionLevel < 8.0)
        return YES;
    
    return NO;
}

+(BOOL)IsVersion6
{
    if(6.0 <= m_dOSVersionLevel && m_dOSVersionLevel < 7.0)
        return YES;
    
    return NO;
}

+(BOOL)IsVersion5
{
    if(5.0 <= m_dOSVersionLevel && m_dOSVersionLevel < 6.0)
        return YES;
    
    return NO;
}

+(BOOL)IsVersion4
{
    if(m_dOSVersionLevel < 5.0)
        return YES;
    
    return NO;
}

+(int16_t)GetAppDefaultCountryIndex
{
    return 0;
}


#define DEFAULT_APP_AWS_ACCOUNID                @"xxxxxxxxxx"
#define DEFAULT_APP_AWS_COGNITOPOOLID           @"us-east-1:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#define DEFAULT_APP_AWS_COGNITOROLEAUTH         @"arn:aws:iam::xxxxxxxxxxxxx:role/Cognito_xxxxxxxxxxxxxx"
#define DEFAULT_APP_AWS_COGNITOROLEUNAUTH       @"arn:aws:iam::xxxxxxxxxxxxx:role/Cognito_xxxxxxxxxxxxxxxx"

+(NSString*)GetAWSAccountID
{
    return DEFAULT_APP_AWS_ACCOUNID;
}

+(NSString*)GetAWSCognitoPoolID
{
    return DEFAULT_APP_AWS_COGNITOPOOLID;
}

+(NSString*)GetAWSCognitoRoleAuth
{
    return DEFAULT_APP_AWS_COGNITOROLEAUTH;
}

+(NSString*)GetAWSCognitoRoleUnauth
{
    return DEFAULT_APP_AWS_COGNITOROLEUNAUTH;
}

#define DEFAULT_APP_AWS_ARN_PREFIX  @"arn:aws:sqs:us-east-1:"
+(NSString*)GetAppAWSARNPrefix
{
    return DEFAULT_APP_AWS_ARN_PREFIX;
}

+(NSArray*)GetHardCodedRecommededTrafficTwitterScreenNameList
{
    NSArray* accountList = nil;
    
    accountList = [NSArray arrayWithObjects:
                   @"511NYC",
                   @"511nyLongIsland",
                   @"Z100Traffic",
                   @"MTA",
                   @"NYCTBus",
                   @"NYCTSubway",
                   @"NYC_DOT",
                   @"NotifyNYC",
                   @"News12BKTW",
                   nil];
    
    return accountList;
}

@end
