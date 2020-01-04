//
//  ApplicationConfigure.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ApplicationConfigure.h"
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>

static  int		m_DeviceType = APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE;

#define ADMOB_PUBLISHKEY_FLYINGCOW_IPHONE			@"xxxxxxxxxxxxxxx"
#define ADMOB_PUBLISHKEY_FLYINGCOW_IPAD				@"xxxxxxxxxxxxxxx"
#define MOBCLIX_PUBLISHKEY_FLYINGCOW				@"xxxxxxxxxxxxxxx"
#define MOBCLIX_PUBLISHKEY_LUCKYCOMPASS				@"xxxxxxxxxxxxxxx"
#define MOBCLIX_PUBLISHKEY_MINDFIRE                 @"xxxxxxxxxxxxxxx"

#define MOBFOX_PUBLISHKEY_FLYINGCOW                 @"xxxxxxxxxxxxxxx"

#define FACEBOOK_APPLICATIONKEY_FLYINGCOW			@"xxxxxxxxxxxxxxx"
#define FACEBOOK_APPLICATIONKEY_LUCKYCOMPASS		@"xxxxxxxxxxxxxxx"


#define FACEBOOK_APPLICATIONKEY_PANDACARDS		@"xxxxxxxxxxxxxxx"
#define FACEBOOK_URLSCHEMESUFFIX_PANDACARDS		@"xxxxxxxxxxxxxxx"


#define SINA_OAUTHKYEY_FLYINGCOW                    @"xxxxxxxxxxxxxxx"	
#define SINA_OAUTHSECRET_FLYINGCOW                  @"xxxxxxxxxxxxxxx"	
#define SINA_OAUTHKYEY_LUCKYCOMPASS                 @"xxxxxxxxxxxxxxx"	
#define SINA_OAUTHSECRET_LUCKYCOMPASS               @"xxxxxxxxxxxxxxx"	

#define SINA_AUTHERID                               xxxxxxxxxxxxxxx	

#define RENREN_APPLICATIONKEY_FLYINGCOW             @"xxxxxxxxxxxxxxx"
#define RENREN_APPLICATIONSECRET_FLYINGCOW          @"xxxxxxxxxxxxxxx"

#define RENREN_APPLICATIONKEY_LUCKYCOMPASS          @"xxxxxxxxxxxxxxx"
#define RENREN_APPLICATIONSECRET_LUCKYCOMPASS       @"xxxxxxxxxxxxxxx"

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

+(NSString*)GetCurrentAdMobPublishKey
{
	NSString* szKey = @"";
	
	if(m_DeviceType == APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE)
	{
		//if(m_ProductID == APPLICATION_PRODUCT_FLYINGCOW)
		//{
			szKey = ADMOB_PUBLISHKEY_FLYINGCOW_IPHONE;
		//}	
	}
	else 
	{
		//if(m_ProductID == APPLICATION_PRODUCT_FLYINGCOW)
		//{
			szKey = ADMOB_PUBLISHKEY_FLYINGCOW_IPAD;
		//}	
	}

	return szKey;
}

+(NSString*)GetCurrentMobClixPublishKey
{
	NSString* szKey = @"";
	
	/*if(m_ProductID == APPLICATION_PRODUCT_FLYINGCOW)
	{
		szKey = MOBCLIX_PUBLISHKEY_FLYINGCOW;
	}	
	else if(m_ProductID == APPLICATION_PRODUCT_LUCKYCOMPASS)
	{
		szKey = MOBCLIX_PUBLISHKEY_LUCKYCOMPASS;
	}	
	else if(m_ProductID == APPLICATION_PRODUCT_MINDFIRE)*/
    //{
		szKey = MOBCLIX_PUBLISHKEY_MINDFIRE;
    //}
    
	return szKey;
}

+(NSString*)GetMobFoxPublishKey
{
	NSString* szKey = MOBFOX_PUBLISHKEY_FLYINGCOW;
    
	return szKey;
}

+(NSString*)GetAdMobPublishKey
{
	return [ApplicationConfigure GetCurrentAdMobPublishKey];
}

+(NSString*)GetMobClixPublishKey
{
	return [ApplicationConfigure GetCurrentMobClixPublishKey];
}	

+(int)GetSOMAPublisherID
{
    return 923827251;
}

+(int)GetSOMAAdSpaceIDKey
{
    return 65732124;
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
   return FACEBOOK_APPLICATIONKEY_PANDACARDS;
}

+(NSString*)GetFBURLSchemeSuffix
{
    return FACEBOOK_URLSCHEMESUFFIX_PANDACARDS;
}

#define PANDACARDS_ITUNES_URL               @"http://itunes.apple.com/us/app/panda-cards/id517550842"
#define PANDACARDS_FBAPPCENTER_URL          @"https://m.facebook.com/appcenter/?app=200380596746593"

#define USE_ITUNES_URL

+(NSString*)GetFacebookPostLinkURL
{
#ifdef USE_ITUNES_URL 
    return PANDACARDS_ITUNES_URL;
#else    
    return PANDACARDS_FBAPPCENTER_URL;
#endif
}

+(NSString*)GetFacebookIconLinkURL
{
   // return @"https://fbcdn-photos-a.akamaihd.net/photos-ak-snc7/v85005/81/307174856027841/app_104_307174856027841_1835701552.png";
    return [[NSBundle mainBundle] pathForResource:@"icon4.png" ofType:nil];
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

static BOOL m_bChinese = NO;
+(BOOL)IsChineseVersion
{
    return m_bChinese;
}

+(void)SetChineseVersion
{
    m_bChinese = YES;
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

static int m_nTemporaryAccessDayLeft = -1;
+(BOOL)CanTemporaryAccessPaidFeature
{
    return ((0 <= m_nTemporaryAccessDayLeft) || [ApplicationConfigure GetOneTimeTemporaryAccess]);
}

+(int)GetDefaultTemporaryAccessDayLimit
{
    return 7;
}

+(int)GetTemporaryAccessDayLeft
{
    return m_nTemporaryAccessDayLeft;
}

+(void)SetTemporaryAccessDayLeft:(int)nDays
{
    m_nTemporaryAccessDayLeft = nDays;
}


static  BOOL m_bOneTimeTemporaryAccess = NO;
+(BOOL)GetOneTimeTemporaryAccess
{
    return m_bOneTimeTemporaryAccess;
}

+(void)SetOneTimeTemporaryAccess:(BOOL)bEnable
{
    m_bOneTimeTemporaryAccess = bEnable;
}




//This is runtime check retina display or not
+(float)GetCurrentDisplayScale
{
    return m_fScreenScale;
}

+(void)LogDebugInformation:(NSString*)szText
{
    NSLog(@"%@",szText);
}

@end
