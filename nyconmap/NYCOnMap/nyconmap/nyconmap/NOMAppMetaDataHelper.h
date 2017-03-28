//
//  NOMAppMetaDataHelper.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMAppMetaDataHelper : NSObject

+(NSString*)GetAppDisplayName;
+(NSString*)GetAppKey;
+(void)InitializeSystemConfiguration;
+(BOOL)IsDeviceIPad;
+(BOOL)IsDeviceIPhone;
+(BOOL)IsOnSimulator;
+(BOOL)IsRetinaDisplay;
+(BOOL)CanScaleMapElement;
+(BOOL)ShowAdBanner;
+(void)SetAdBannerShow:(BOOL)bShow;
+(BOOL)IsCityBaseAppRegionOnly;
+(int)GetAppRegionCountryIndex;
+(NSString*)GetGoogleADUnitID;
+(double)GetGoogleADAccuracy;
+(double)GetAppLatitude;
+(double)GetAppLongitude;
+(double)GetAppRegionRangeDegree;
+(double)GetAppLongitudeStart;
+(double)GetAppLongitudeEnd;
+(double)GetAppLatitudeStart;
+(double)GetAppLatitudeEnd;

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
+(void)SetSimpleSearchMode:(BOOL)bSimpleMode;
+(BOOL)IsSimpleSearchMode;
+(NSString*)GetAppTwitterCustomerKey;
+(NSString*)GetAppTwitterCustomerSecret;
+(NSString*)GetAppTwitterAccessToken;
+(NSString*)GetAppTwitterAccessTokenSecret;
+(NSString*)GetAppTwitterDevUserName;
+(NSString*)GetAppTwitterHashKey;
+(NSString*)GetCurrentCityTwitterHashKey;

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
