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


@interface ApplicationConfigure : NSObject 
{
}

+(void)SetActiveDeviceType:(int)type;
+(BOOL)iPhoneDevice;
+(BOOL)iPADDevice;
+(void)SetCurrentProduct:(int)productID;
+(int)GetCurrentProduct;
+(void)SetAdViewsState:(BOOL)bEnable;
+(BOOL)GetAdViewsState;
+(void)SetGameCenterEnable:(BOOL)bEnable;
+(BOOL)IsGameCenterEnable;

+(NSString*)GetFacebookKey;
+(NSString*)GetFBURLSchemeSuffix;
+(NSString*)GetFacebookPostLinkURL;
+(NSString*)GetFacebookIconLinkURL;

+(NSString*)GetSinaKey;
+(NSString*)GetSinaSecret;
+(int)GetSinaAutherID;

+(NSString*)GetRenRenKey;
+(NSString*)GetRenRenSecret;

+(BOOL)ShouldShutdownGame;
+(void)SetShutdownGame:(BOOL)bShutdown;

+(BOOL)IsOnSimulator;
+(BOOL)IsFor91DotCom;

+(void)EnableDebugMode:(BOOL)bEnable;
+(BOOL)IsDebugMode;

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

+(void)SetModalPresentAccountable;
+(BOOL)IsModalPresentAccountable;
+(void)ClearModalPresentAccountable;
+(void)SetAsRedeemModalPresent;
+(BOOL)IsRedeemModalPresent;
+(void)ClearRedeemModalPresent;


+(void)SetCurrentTimeStample:(float)fCurTime;
+(float)GetCurrentTimeStample;

+(float)GetCurrentDisplayScale;

+(BOOL)CanSendEmail;
+(BOOL)CanSendTextMessage;
+(BOOL)CanSendTweet;

+(BOOL)DefaultLanguageForSNPost;
+(void)SetDefaultLanguageForSNPost:(BOOL)bDefault;

+(int)GetDefaultAWSMessageRetentionTime;
@end
