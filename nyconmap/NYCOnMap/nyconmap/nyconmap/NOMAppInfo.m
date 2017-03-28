//
//  NOMAppInfo.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 2014-03-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMAppInfo.h"
#import "TwitterTweetLocationParser.h"
#import "NOMAppMetaDataHelper.h"

static id<IImageSelectorDelegate>           g_ImageResourceSelector = nil;
static id<IImageReceiverDelegate>           m_CurrentImageResourceReceiver = nil;

@implementation NOMAppInfo

+(NSString*)GetAppStoreURL
{
    return [NOMAppMetaDataHelper GetAppStoreURL];
}

+(NSString*)GetAppDisplayName
{
    return [NOMAppMetaDataHelper GetAppDisplayName];
}

+(NSString*)GetAppKey
{
    return [NOMAppMetaDataHelper GetAppKey];
}

+(void)InitializeSystemConfiguration
{
    [NOMAppMetaDataHelper InitializeSystemConfiguration];
}

+(BOOL)IsDeviceIPad
{
    return [NOMAppMetaDataHelper IsDeviceIPad];
}

+(BOOL)IsDeviceIPhone
{
    return [NOMAppMetaDataHelper IsDeviceIPhone];
}

+(BOOL)IsOnSimulator
{
    return [NOMAppMetaDataHelper IsOnSimulator];
}

+(BOOL)IsRetinaDisplay
{
    return [NOMAppMetaDataHelper IsRetinaDisplay];
}

+(BOOL)CanScaleMapElement
{
    return [NOMAppMetaDataHelper CanScaleMapElement];
}

+(BOOL)ShowAdBanner
{
    return [NOMAppMetaDataHelper ShowAdBanner];
}

+(void)SetAdBannerShow:(BOOL)bShow
{
    [NOMAppMetaDataHelper SetAdBannerShow:bShow];
}

+(BOOL)IsCityBaseAppRegionOnly
{
    return [NOMAppMetaDataHelper IsCityBaseAppRegionOnly];
}

+(int)GetAppRegionCountryIndex
{
    return [NOMAppMetaDataHelper GetAppRegionCountryIndex];
}

+(NSString*)GetGoogleADUnitID
{
    return [NOMAppMetaDataHelper GetGoogleADUnitID];
}

+(double)GetGoogleADAccuracy
{
    return [NOMAppMetaDataHelper GetGoogleADAccuracy];
}

+(double)GetAppLatitude
{
    return [NOMAppMetaDataHelper GetAppLatitude];
}

+(double)GetAppLongitude
{
    return [NOMAppMetaDataHelper GetAppLongitude];
}

+(double)GetAppRegionRangeDegree
{
    return [NOMAppMetaDataHelper GetAppRegionRangeDegree];
}


+(double)GetAppLongitudeStart
{
    return [NOMAppMetaDataHelper GetAppLongitudeStart];
}

+(double)GetAppLongitudeEnd
{
    return [NOMAppMetaDataHelper GetAppLongitudeEnd];
}

+(double)GetAppLatitudeStart
{
    return [NOMAppMetaDataHelper GetAppLatitudeStart];
}

+(double)GetAppLatitudeEnd
{
    return [NOMAppMetaDataHelper GetAppLatitudeEnd];
}

+(BOOL)IsLocationInAppRegion:(CLLocationCoordinate2D)point
{
    BOOL bRet = NO;
    
    double latStart = [NOMAppInfo GetAppLatitudeStart];
    double latEnd = [NOMAppInfo GetAppLatitudeEnd];
    double longStart = [NOMAppInfo GetAppLongitudeStart];
    double longEnd = [NOMAppInfo GetAppLongitudeEnd];
    
    if(latStart <= point.latitude && point.latitude <= latEnd && longStart <= point.longitude && point.longitude <= longEnd)
        bRet = YES;
    else
        bRet = NO;
    
    return bRet;
}

+(NSString*)GetDefaultTrafficTopicName
{
    return [NOMAppMetaDataHelper GetDefaultTrafficTopicName];
}

+(NSString*)GetTrafficMessageQueueKey
{
    return [NOMAppMetaDataHelper GetTrafficMessageQueueKey];
}

+(NSString*)GetTrafficMessageQueueNamePrefix
{
    return [NOMAppMetaDataHelper GetTrafficMessageQueueNamePrefix];
}

+(NSString*)GetDefaultTaxiTopicName
{
    return [NOMAppMetaDataHelper GetDefaultTaxiTopicName];
}

+(NSString*)GetTaxiMessageQueueKey
{
    return [NOMAppMetaDataHelper GetTaxiMessageQueueKey];
}

+(NSString*)GetTaxiMessageQueueNamePrefix
{
    return [NOMAppMetaDataHelper GetTaxiMessageQueueNamePrefix];
}

+(NSString*)GetPlatformApplicationARN
{
    return [NOMAppMetaDataHelper GetPlatformApplicationARN];
}

+(NSString*)GetAWSDeviceTokenPrefKey
{
    return [NOMAppMetaDataHelper GetAWSDeviceTokenPrefKey];
}

+(NSString*)GetAWSMobileEndPointARNPrefKey
{
    return [NOMAppMetaDataHelper GetAWSMobileEndPointARNPrefKey];
}

+(NSString*)GetSimulatorFakeToken
{
    return [NOMAppMetaDataHelper GetSimulatorFakeToken];
}


+(void)RegisterImageResourceSelector:(id<IImageSelectorDelegate>)imageSelector
{
    g_ImageResourceSelector = imageSelector;
}

+(id<IImageSelectorDelegate>)GetImageResourceSelector
{
    return g_ImageResourceSelector;
}

+(void)SetCurrentImageResourceReceiver:(id<IImageReceiverDelegate>)imageReceiver
{
    m_CurrentImageResourceReceiver = imageReceiver;
}

+(id<IImageReceiverDelegate>)GetCurrentImageResourceReceiver
{
    return m_CurrentImageResourceReceiver;
}

+(void)SetSimpleSearchMode:(BOOL)bSimpleMode
{
    [NOMAppMetaDataHelper SetSimpleSearchMode:bSimpleMode];
}

+(BOOL)IsSimpleSearchMode
{
    return [NOMAppMetaDataHelper IsSimpleSearchMode];
}

+(NSString*)GetAppTwitterCustomerKey
{
    return [NOMAppMetaDataHelper GetAppTwitterCustomerKey];
}

+(NSString*)GetAppTwitterCustomerSecret
{
    return [NOMAppMetaDataHelper GetAppTwitterCustomerSecret];
}

+(NSString*)GetAppTwitterAccessToken
{
    return [NOMAppMetaDataHelper GetAppTwitterAccessToken];
}

+(NSString*)GetAppTwitterAccessTokenSecret
{
    return [NOMAppMetaDataHelper GetAppTwitterAccessTokenSecret];
}

+(NSString*)GetAppTwitterDevUserName
{
    return [NOMAppMetaDataHelper GetAppTwitterDevUserName];
}

+(NSString*)GetAppTwitterHashKey
{
    return [NOMAppMetaDataHelper GetAppTwitterHashKey];
}

+(NSString*)GetCurrentCityTwitterHashKey
{
    return [NOMAppMetaDataHelper GetCurrentCityTwitterHashKey];
}

+(id<IPlainTextLocationParser>)CreatePlainTextLocationParser
{
    id<IPlainTextLocationParser> parser = [[TwitterTweetLocationParser alloc] init];
    return parser;
}

+(BOOL)IsVersion8
{
    return [NOMAppMetaDataHelper IsVersion8];
}

+(BOOL)IsVersion7
{
    return [NOMAppMetaDataHelper IsVersion7];
}

+(BOOL)IsVersion6
{
    return [NOMAppMetaDataHelper IsVersion6];
}

+(BOOL)IsVersion5
{
    return [NOMAppMetaDataHelper IsVersion5];
}

+(BOOL)IsVersion4
{
    return [NOMAppMetaDataHelper IsVersion4];
}

+(void)AcceptTermOfUse
{
    [NOMAppMetaDataHelper AcceptTermOfUse];
}

+(BOOL)GetTermOfUse
{
    return [NOMAppMetaDataHelper GetTermOfUse];
}

+(int16_t)GetAppDefaultCountryIndex
{
    return [NOMAppMetaDataHelper GetAppDefaultCountryIndex];
}

+(NSString*)GetAWSAccountID
{
    return [NOMAppMetaDataHelper GetAWSAccountID];
}

+(NSString*)GetAWSCognitoPoolID
{
    return [NOMAppMetaDataHelper GetAWSCognitoPoolID];
}

+(NSString*)GetAWSCognitoRoleAuth
{
    return [NOMAppMetaDataHelper GetAWSCognitoRoleAuth];
}

+(NSString*)GetAWSCognitoRoleUnauth
{
    return [NOMAppMetaDataHelper GetAWSCognitoRoleUnauth];
}

+(NSString*)GetAppAWSARNPrefix
{
    return [NOMAppMetaDataHelper GetAppAWSARNPrefix];
}

+(NSArray*)GetHardCodedRecommededTrafficTwitterScreenNameList
{
    return [NOMAppMetaDataHelper GetHardCodedRecommededTrafficTwitterScreenNameList];
}

@end
