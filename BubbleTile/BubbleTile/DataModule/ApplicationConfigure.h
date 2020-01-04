//
//  AppliationConfigure.h
//  XXXX
//
//  Created by Zhaohui Xing on 2011-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef		APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE
#define		APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE			0
#endif

#ifndef		APPLICATION_ACTIVE_DEVICE_TYPE_IPAD
#define		APPLICATION_ACTIVE_DEVICE_TYPE_IPAD				1	
#endif

#define     APPLICATION_PRODUCT_FLYINGCOW					0
#define     APPLICATION_PRODUCT_LUCKYCOMPASS				1
#define     APPLICATION_PRODUCT_MINDFIRE                    2


//#ifndef DEBUG
//#define DEBUG
//#endif


@interface ApplicationConfigure : NSObject 
{
}

+(void)SetActiveDeviceType:(int)type;
+(BOOL)iPhoneDevice;
+(BOOL)iPADDevice;
+(void)SetCurrentProduct:(int)productID;
+(int)GetCurrentProduct;
+(NSString*)GetAdMobPublishKey;
+(NSString*)GetMobClixPublishKey;
+(void)SetAdViewsState:(BOOL)bEnable;
+(BOOL)GetAdViewsState;
+(void)SetGameCenterEnable:(BOOL)bEnable;
+(BOOL)IsGameCenterEnable;

+(NSString*)GetFacebookKey;
+(NSString*)GetFBURLSchemeSuffix;
+(NSString*)GetFacebookPostLinkURL;
+(NSString*)GetFacebookIconLinkURL;
+(BOOL)DefaultLanguageForSNPost;
+(void)SetDefaultLanguageForSNPost:(BOOL)bDefault;

+(NSString*)GetSinaKey;
+(NSString*)GetSinaSecret;
+(int)GetSinaAutherID;

+(NSString*)GetRenRenKey;
+(NSString*)GetRenRenSecret;

+(BOOL)ShouldShutdownGame;
+(void)SetShutdownGame:(BOOL)bShutdown;

+(BOOL)IsOnSimulator;

+(void)SetMobclixAdviewType;
+(BOOL)IsMobclixAdviewType;
+(void)SetGoogleAdviewType;
+(BOOL)IsGoogleAdviewType;
+(void)SetAppleAdviewType;
+(BOOL)IsAppleAdviewType;
+(void)ClearAdViewType;

+(void)EnableLaunchHouseAd;
+(void)DisableLaunchHouseAd;
+(BOOL)CanLaunchHouseAd;
+(BOOL)IsChineseVersion;
+(void)SetChineseVersion;

+(NSString*)GetDeviceName;
+(NSString*)GetDeviceTypeString;
+(NSString*)GetAppVersion;
+(int)GetDeviceID;


+(void)SetupLocationData:(float)fLatidude withLongitude:(float)fLongitude;
+(BOOL)HaveLocationData;
+(float)GetLatitude;
+(float)GetLongitude;

+(BOOL)CanSendEmail;
+(BOOL)CanSendTextMessage;
+(BOOL)CanSendTweet;

+(BOOL)CanClickToEarn;
+(BOOL)CanTemporaryAccessPaidFeature;
+(int)GetDefaultTemporaryAccessDayLimit;
+(int)GetTemporaryAccessDayLeft;
+(void)SetTemporaryAccessDayLeft:(int)nDays;

+(void)SetModalPresentAccountable;
+(BOOL)IsModalPresentAccountable;
+(void)ClearModalPresentAccountable;
+(void)SetAsRedeemModalPresent;
+(BOOL)IsRedeemModalPresent;
+(void)ClearRedeemModalPresent;

//Millennial Media SDK
+(NSString*)GetMMSDKBottomAdID;
+(NSString*)GetMMSDKSquareAdID;
+(NSString*)GetMMSDKFullScreenAdID;


+(int)GetDefaultAWSMessageRetentionTime;

@end
