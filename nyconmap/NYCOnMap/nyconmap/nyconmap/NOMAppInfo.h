//
//  NOMAppInfo.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 2014-03-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMImageHelper.h"
#import "IPlainTextLocationParser.h"

@interface NOMAppInfo : NSObject
{
}

+(void)InitializeSystemConfiguration;
+(BOOL)IsDeviceIPad;
+(BOOL)IsDeviceIPhone;
+(BOOL)IsOnSimulator;
+(BOOL)IsRetinaDisplay;
+(BOOL)CanScaleMapElement;

+(BOOL)ShowAdBanner;

+(BOOL)IsCityBaseAppRegionOnly;
+(int)GetAppRegionCountryIndex;


+(NSString*)GetGoogleADUnitID;

+(double)GetAppLatitude;
+(double)GetAppLongitude;
+(double)GetGoogleADAccuracy;
+(double)GetAppRegionRangeDegree;

+(double)GetAppLongitudeStart;
+(double)GetAppLongitudeEnd;
+(double)GetAppLatitudeStart;
+(double)GetAppLatitudeEnd;
+(BOOL)IsLocationInAppRegion:(CLLocationCoordinate2D)point;


+(NSString*)GetDefaultTrafficTopicName;
+(NSString*)GetTrafficMessageQueueKey;
+(NSString*)GetTrafficMessageQueueNamePrefix;

+(NSString*)GetDefaultTaxiTopicName;
+(NSString*)GetTaxiMessageQueueKey;
+(NSString*)GetTaxiMessageQueueNamePrefix;


+(NSString*)GetPlatformApplicationARN;
+(NSString*)GetAWSDeviceTokenPrefKey;
+(NSString*)GetAWSMobileEndPointARNPrefKey;
+(NSString*)GetSimulatorFakeToken;

+(NSString*)GetAppDisplayName;
+(NSString*)GetAppKey;

+(void)RegisterImageResourceSelector:(id<IImageSelectorDelegate>)imageSelector;
+(id<IImageSelectorDelegate>)GetImageResourceSelector;
+(void)SetCurrentImageResourceReceiver:(id<IImageReceiverDelegate>)imageReceiver;
+(id<IImageReceiverDelegate>)GetCurrentImageResourceReceiver;

+(BOOL)IsSimpleSearchMode;
+(void)SetSimpleSearchMode:(BOOL)bSimpleMode;

+(NSString*)GetAppTwitterCustomerKey;
+(NSString*)GetAppTwitterCustomerSecret;

+(NSString*)GetAppTwitterAccessToken;
+(NSString*)GetAppTwitterAccessTokenSecret;
+(NSString*)GetAppTwitterDevUserName;
+(NSString*)GetAppTwitterHashKey;
+(NSString*)GetCurrentCityTwitterHashKey;

+(id<IPlainTextLocationParser>)CreatePlainTextLocationParser;

+(BOOL)IsVersion8;
+(BOOL)IsVersion7;
+(BOOL)IsVersion6;
+(BOOL)IsVersion5;
+(BOOL)IsVersion4;
+(void)AcceptTermOfUse;
+(BOOL)GetTermOfUse;
+(int16_t)GetAppDefaultCountryIndex;

+(NSString*)GetAWSAccountID;
+(NSString*)GetAWSCognitoPoolID;
+(NSString*)GetAWSCognitoRoleAuth;
+(NSString*)GetAWSCognitoRoleUnauth;

+(NSString*)GetAppAWSARNPrefix;

+(NSArray*)GetHardCodedRecommededTrafficTwitterScreenNameList;

+(NSString*)GetAppStoreURL;

@end

