//
//  ApplicationConfigure.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ApplicationConfigure.h"
#import "BTFileConstant.h"
#import <Twitter/Twitter.h>
#import "StringFactory.h"

static  int		m_DeviceType = APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE;

//#define ADMOB_PUBLISHKEY_BUBBLETILE_IPHONE			@"xxxxxxxxxxxxxxx"
//#define ADMOB_PUBLISHKEY_BUBBLETILE_IPAD			@"xxxxxxxxxxxxxxx"
#define ADMOB_PUBLISHKEY_BUBBLETILE_IPHONE			@"xxxxxxxxxxxxxxx"
#define ADMOB_PUBLISHKEY_BUBBLETILE_IPAD			@"xxxxxxxxxxxxxxx"
#define MOBCLIX_PUBLISHKEY_BUBBLETILE               @"xxxxxxxxxxxxxxx"

#define FACEBOOK_APPLICATIONKEY_FLYINGCOW			@"xxxxxxxxxxxxxxx"
#define FACEBOOK_APPLICATIONKEY_LUCKYCOMPASS		@"xxxxxxxxxxxxxxx"

#define FACEBOOK_APPLICATIONKEY_BUBBLETILE          @"xxxxxxxxxxxxxxx"
#define FACEBOOK_URLSCHEMESUFFIX_BUBBLETILE         @"bubbletile"


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

static int      m_nAdViewType = ADVIEW_TYPE_NONE;

@implementation ApplicationConfigure

+(void)SetActiveDeviceType:(int)type
{
	m_DeviceType = type;
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
		szKey = ADMOB_PUBLISHKEY_BUBBLETILE_IPHONE;
	}
	else 
	{
        szKey = ADMOB_PUBLISHKEY_BUBBLETILE_IPAD;
	}

	return szKey;
}

+(NSString*)GetCurrentMobClixPublishKey
{
	NSString* szKey = @"";
	
	szKey = MOBCLIX_PUBLISHKEY_BUBBLETILE;
    
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
    return FACEBOOK_APPLICATIONKEY_BUBBLETILE;
}

+(NSString*)GetFBURLSchemeSuffix
{
    return FACEBOOK_URLSCHEMESUFFIX_BUBBLETILE;
}

#define BUBBLETILE_ITUNES_URL               @"http://itunes.apple.com/app/bubble-tile/xxxxxxxxxxxx"
#define BUBBLETILE_FBAPPCENTER_URL          @"https://m.facebook.com/appcenter/?app=xxxxxxxxxxxx"

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

+(NSString*)GetDeviceName
{
    //return [[UIDevice currentDevice] name];
    return @"HumanOnTheEarth";
}

+(NSString*)GetAppVersion
{
    NSString *versionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]; 
    return versionNumber;
}    

+(int)GetDeviceID
{
    if([ApplicationConfigure iPADDevice])
        return BT_DEVICEID_IPAD;
    else
        return BT_DEVICEID_IPHONE;
}

+(NSString*)GetDeviceTypeString
{
    if([ApplicationConfigure iPADDevice])
        return @"iPad";
    else
        return @"iPhone/iPod Touch";
}


static BOOL m_bSetupLocation = NO;
static float m_fLatitude = 0.0;
static float m_fLongitude = 0.0;

+(void)SetupLocationData:(float)fLatidude withLongitude:(float)fLongitude
{
    m_bSetupLocation = YES;
    m_fLatitude = fLatidude;
    m_fLongitude =fLongitude;
}

+(BOOL)HaveLocationData
{
    return m_bSetupLocation;
}

+(float)GetLatitude
{
    return m_fLatitude;
}

+(float)GetLongitude
{
    return m_fLongitude;
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
    return ((0 <= m_nTemporaryAccessDayLeft));
}

+(int)GetDefaultTemporaryAccessDayLimit
{
    if([ApplicationConfigure CanClickToEarn])
        return 2;
    
    return 3;
}

+(int)GetTemporaryAccessDayLeft
{
    return m_nTemporaryAccessDayLeft;
}

+(void)SetTemporaryAccessDayLeft:(int)nDays
{
    m_nTemporaryAccessDayLeft = nDays;
}

+(BOOL)CanClickToEarn
{
    BOOL bRet = NO;
    
    if([StringFactory IsOSLangES] || [StringFactory IsOSLangIT] || [StringFactory IsOSLangFR] || [StringFactory IsOSLangKO] || [StringFactory IsOSLangZH] || [StringFactory IsOSLangPT] || [StringFactory IsOSLangRU])
        bRet = YES;
    
    return bRet;
}

+(NSString*)GetMMSDKBottomAdID
{
    return @"83681";
}

+(NSString*)GetMMSDKSquareAdID
{
    return @"83682";
}

+(NSString*)GetMMSDKFullScreenAdID
{
    return @"83683";
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

+(int)GetDefaultAWSMessageRetentionTime
{
    return 604800;
}

@end
