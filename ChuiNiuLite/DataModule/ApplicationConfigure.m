//
//  ApplicationConfigure.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>
#import "ApplicationConfigure.h"

static  int		m_DeviceType = APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE;

#define FACEBOOK_APPLICATIONKEY_FLYINGCOW			@"xxxxxxxxxxxx"

#define FACEBOOK_URLSCHEMESUFFIX_FLYINGCOW         @"xxxxxxxxxxxx"

#define SINA_OAUTHKYEY_FLYINGCOW                    @"xxxxxxxxxxxx"
#define SINA_OAUTHSECRET_FLYINGCOW                  @"xxxxxxxxxxxx"
#define SINA_OAUTHKYEY_LUCKYCOMPASS                 @"xxxxxxxxxxxx"
#define SINA_OAUTHSECRET_LUCKYCOMPASS               @"xxxxxxxxxxxx"

#define SINA_AUTHERID                               1111111

#define RENREN_APPLICATIONKEY_FLYINGCOW             @"xxxxxxxxxxxx"
#define RENREN_APPLICATIONSECRET_FLYINGCOW          @"xxxxxxxxxxxx"

#define RENREN_APPLICATIONKEY_LUCKYCOMPASS          @"xxxxxxxxxxxx"
#define RENREN_APPLICATIONSECRET_LUCKYCOMPASS       @"xxxxxxxxxxxx"


#define ADVIEW_TYPE_NONE            -1
#define ADVIEW_TYPE_MOBCLIX         0
#define ADVIEW_TYPE_GOOGLE          1
#define ADVIEW_TYPE_APPLE           2

static  int		m_ProductID = APPLICATION_PRODUCT_FLYINGCOW;
static  BOOL	m_AdViewsEnable = NO;
static  BOOL	m_GameCenterEnable = NO;
static  BOOL    m_bShouldShutdown = YES;

static  BOOL	m_DebugMode = NO;

static int      m_nAdViewType = ADVIEW_TYPE_NONE;
static  float   m_fScreenScale = 1.0;

@implementation ApplicationConfigure

+(void)SetActiveDeviceType:(int)type
{
	m_DeviceType = type;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) 
    {
        // Retina display
        m_fScreenScale = 2.0;
    } 
    else
    {
        m_fScreenScale = 1.0;
    }
}

+(BOOL)iPhoneDevice
{
	BOOL bRet = (m_DeviceType == APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE);
	return bRet;
}

+(BOOL)iPADDevice
{
	BOOL bRet = (m_DeviceType == APPLICATION_ACTIVE_DEVICE_TYPE_IPAD);
	return bRet;
}

+(void)SetCurrentProduct:(int)productID
{
	m_ProductID = productID;
}

+(int)GetCurrentProduct
{
	return m_ProductID; 
}	


+(void)SetAdViewsState:(BOOL)bEnable
{
	m_AdViewsEnable = bEnable;
}

+(BOOL)GetAdViewsState
{
	return m_AdViewsEnable;
}	

+(NSString*)GetFacebookKey
{
	//if(m_ProductID == APPLICATION_PRODUCT_LUCKYCOMPASS)
	//{
	//	return FACEBOOK_APPLICATIONKEY_LUCKYCOMPASS;
	//}	

    return FACEBOOK_APPLICATIONKEY_FLYINGCOW;
}


+(NSString*)GetFBURLSchemeSuffix
{
    return FACEBOOK_URLSCHEMESUFFIX_FLYINGCOW;
}


//?????????
//?????????
//????????
#define BUBBLETILE_ITUNES_URL               @"http://itunes.apple.com/app/bubble-tile/id445302495"
#define BUBBLETILE_FBAPPCENTER_URL          @"https://m.facebook.com/appcenter/?app=282351838506719"

#define USE_ITUNES_URL

+(NSString*)GetFacebookPostLinkURL
{
#ifdef USE_ITUNES_URL 
    return BUBBLETILE_ITUNES_URL;
#else    
    return BUBBLETILE_FBAPPCENTER_URL;
#endif
}

+(NSString*)GetFacebookIconLinkURL
{
    return [[NSBundle mainBundle] pathForResource:@"icon4.png" ofType:nil];
}

+(NSString*)GetSinaKey
{
	if(m_ProductID == APPLICATION_PRODUCT_LUCKYCOMPASS)
	{
		return SINA_OAUTHKYEY_LUCKYCOMPASS;
	}	
    
    return SINA_OAUTHKYEY_FLYINGCOW;
}

+(NSString*)GetSinaSecret
{
	if(m_ProductID == APPLICATION_PRODUCT_LUCKYCOMPASS)
	{
		return SINA_OAUTHSECRET_LUCKYCOMPASS;
	}	
        
    return SINA_OAUTHSECRET_FLYINGCOW;
}

+(int)GetSinaAutherID
{
    return SINA_AUTHERID;
}

+(NSString*)GetRenRenKey
{
	if(m_ProductID == APPLICATION_PRODUCT_LUCKYCOMPASS)
	{
		return RENREN_APPLICATIONKEY_LUCKYCOMPASS;
	}	
    return RENREN_APPLICATIONKEY_FLYINGCOW;
}

+(NSString*)GetRenRenSecret
{
	if(m_ProductID == APPLICATION_PRODUCT_LUCKYCOMPASS)
	{
		return RENREN_APPLICATIONSECRET_LUCKYCOMPASS;
	}	
    return RENREN_APPLICATIONSECRET_FLYINGCOW;
}

+(void)SetGameCenterEnable:(BOOL)bEnable
{
    m_GameCenterEnable = bEnable;
}

+(BOOL)IsGameCenterEnable
{
    return m_GameCenterEnable;
}

+(BOOL)ShouldShutdownGame
{
    return m_bShouldShutdown;    
}

+(void)SetShutdownGame:(BOOL)bShutdown
{
    m_bShouldShutdown = bShutdown;    
}

+(BOOL)IsOnSimulator
{
    BOOL bRet = NO;
    
    NSString* szDevice = [[UIDevice currentDevice] model];
    if([szDevice rangeOfString:@"Simulator"].location == NSNotFound)
    {    
        bRet = NO;
    }
    else
    {
        NSLog(@"Test Current Running Env: %@",szDevice);
        bRet = YES;
    }
    
    return bRet;
}

+(void)EnableDebugMode:(BOOL)bEnable
{
    m_DebugMode = bEnable;
}

+(BOOL)IsDebugMode
{
    return m_DebugMode;
}

+(void)SetMobclixAdviewType
{
    m_nAdViewType = ADVIEW_TYPE_MOBCLIX;
}

+(BOOL)IsMobclixAdviewType
{
    BOOL bRet = (m_nAdViewType == ADVIEW_TYPE_MOBCLIX);
    return bRet;
}

+(void)SetGoogleAdviewType
{
    m_nAdViewType = ADVIEW_TYPE_GOOGLE;
}

+(BOOL)IsGoogleAdviewType
{
    BOOL bRet = (m_nAdViewType == ADVIEW_TYPE_GOOGLE);
    return bRet;
}

+(void)SetAppleAdviewType
{
    m_nAdViewType = ADVIEW_TYPE_APPLE;
}

+(BOOL)IsAppleAdviewType
{
    BOOL bRet = (m_nAdViewType == ADVIEW_TYPE_APPLE);
    return bRet;
}

+(void)ClearAdViewType
{
    m_nAdViewType = ADVIEW_TYPE_NONE;
}


static BOOL m_bCanLaunchHouseAd = NO;
+(void)EnableLaunchHouseAd
{
    m_bCanLaunchHouseAd = YES;
}

+(void)DisableLaunchHouseAd
{
    m_bCanLaunchHouseAd = NO;
}

+(BOOL)CanLaunchHouseAd
{
    return m_bCanLaunchHouseAd;
}

static BOOL m_bAdViewClickThrough = NO;

+(void)SetModalPresentAccountable
{
    m_bAdViewClickThrough = YES;
}

+(BOOL)IsModalPresentAccountable
{
    return m_bAdViewClickThrough;
}

+(void)ClearModalPresentAccountable
{
    m_bAdViewClickThrough = NO;
}

static BOOL m_bRedeemAdViewClickThrough = NO;
+(void)SetAsRedeemModalPresent
{
    m_bRedeemAdViewClickThrough = YES;
}

+(BOOL)IsRedeemModalPresent
{
    return m_bRedeemAdViewClickThrough;
}

+(void)ClearRedeemModalPresent
{
    m_bRedeemAdViewClickThrough = NO;
}

static float m_fCurrentTimeStample = 0;
+(void)SetCurrentTimeStample:(float)fCurTime
{
    m_fCurrentTimeStample = fCurTime;
}

+(float)GetCurrentTimeStample
{
    return m_fCurrentTimeStample;
}

+(BOOL)IsFor91DotCom
{
    return NO;
}

//This is runtime check retina display or not
+(float)GetCurrentDisplayScale
{
    return m_fScreenScale;
}


+(BOOL)CanSendEmail
{
    BOOL bRet = [MFMailComposeViewController canSendMail];
    return bRet;
}

+(BOOL)CanSendTextMessage
{
    BOOL bRet = [MFMessageComposeViewController canSendText];
    return bRet;
}

+(BOOL)CanSendTweet
{
    BOOL bRet = [TWTweetComposeViewController canSendTweet];
    return bRet;
}

static  BOOL	m_bUseDefaultLanguage = YES;

+(BOOL)DefaultLanguageForSNPost
{
    return m_bUseDefaultLanguage;
}

+(void)SetDefaultLanguageForSNPost:(BOOL)bDefault
{
    m_bUseDefaultLanguage = bDefault;
}

+(int)GetDefaultAWSMessageRetentionTime
{
    return 14400;
}

@end
