//
//  AppliationConfigure.h
//  XXXX
//
//  Created by Zhaohui Xing on 2011-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@import UIKit;

#define DEBUG_LOG


#ifndef		APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE
#define		APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE			0
#endif

#ifndef		APPLICATION_ACTIVE_DEVICE_TYPE_IPAD
#define		APPLICATION_ACTIVE_DEVICE_TYPE_IPAD				1	
#endif

#define     APPLICATION_PRODUCT_SIMPLEGAMBLEWHEEL			0

#define     APPLICATION_RELEASE_VERSION_ONE                 0
#define     APPLICATION_RELEASE_VERSION_TWO                 1


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

+(void)SetGameCenterLoggingin:(BOOL)bYes;
+(BOOL)IsGameCenterLoggingin;


+(NSString*)GetSinaKey;
+(NSString*)GetSinaSecret;
+(int)GetSinaAutherID;

+(NSString*)GetRenRenKey;
+(NSString*)GetRenRenSecret;

+(int)GetSOMAPublisherID;
+(int)GetSOMAAdSpaceIDKey;

//Millennial Media SDK
+(NSString*)GetMMSDKBottomAdID;
+(NSString*)GetMMSDKSquareAdID;
+(NSString*)GetMMSDKFullScreenAdID;

+(NSString*)GetFacebookKey;
+(NSString*)GetFBURLSchemeSuffix;
+(NSString*)GetFacebookPostLinkURL;
+(NSString*)GetFacebookIconLinkURL;
+(BOOL)DefaultLanguageForSNPost;
+(void)SetDefaultLanguageForSNPost:(BOOL)bDefault;

+(BOOL)ShouldShutdownGame;
+(void)SetShutdownGame:(BOOL)bShutdown;

+(BOOL)IsOnSimulator;

+(void)EnableDebugMode:(BOOL)bEnable;
+(BOOL)IsDebugMode;
+(BOOL)SupportClickToEarn;
/*
+(void)SetMobclixAdviewType;
+(BOOL)IsMobclixAdviewType;
+(void)SetGoogleAdviewType;
+(BOOL)IsGoogleAdviewType;
+(void)SetAppleAdviewType;
+(BOOL)IsAppleAdviewType;
+(void)ClearAdViewType;
*/

+(void)EnableLaunchHouseAd;
+(void)DisableLaunchHouseAd;
+(BOOL)CanLaunchHouseAd;

+(BOOL)IsGoogleInterstitialEnable;
+(NSString*)GetGoogleInterstitialPublishKey;

+(void)SetRedeemPlayerSeat:(int)nSeat;
+(int)GetRedeemPlayerSeat;

+(int)GetCurrentReleaseVersion;
+(void)SetupLocationData;
+(BOOL)HaveLocationData;
+(CGFloat)GetLatitude;
+(CGFloat)GetLongitude;

+(void)SetModalPresentAccountable;
+(BOOL)IsModalPresentAccountable;
+(void)ClearModalPresentAccountable;

+(BOOL)EarnChipFromInApp;

//This is runtime check retina display or not
+(CGFloat)GetCurrentDisplayScale;


+(BOOL)CanSendEmail;
+(BOOL)CanSendTextMessage;
+(BOOL)CanSendTweet;


+(void)LogDebugInformation:(NSString*)szText;

@end
