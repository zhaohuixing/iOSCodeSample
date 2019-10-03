//
//  ApplicationConfigure.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
//#import <Twitter/Twitter.h>

#import "ApplicationConfigure.h"
//#import "StringFactory.h"

static  int		m_DeviceType = APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE;

#define ADMOB_PUBLISHKEY_GAMBLEWHEEL_IPHONE			@"xxxxxxxxxxxxxxx"
#define ADMOB_PUBLISHKEY_GAMBLEWHEEL_IPAD			@"xxxxxxxxxxxxxxx"
#define MOBCLIX_PUBLISHKEY_GAMBLEWHEEL				@"xxxxxxxxxxxxxxx"

#define FACEBOOK_APPLICATIONKEY_FLYINGCOW			@"xxxxxxxxxxxxxxx"
#define FACEBOOK_APPLICATIONKEY_LUCKYCOMPASS		@"xxxxxxxxxxxxxxx"

#define FACEBOOK_APPLICATIONKEY_SIMPLEGAMBLEWHEEL		@"xxxxxxxxxxxxxxx"

#define FACEBOOK_URLSCHEMESUFFIX_SIMPLEGAMBLEWHEEL  @"easygamblewheel"

#define SINA_OAUTHKYEY_FLYINGCOW                    @"xxxxxxxxxxxxxxx"
#define SINA_OAUTHSECRET_FLYINGCOW                  @"xxxxxxxxxxxxxxx"
#define SINA_OAUTHKYEY_LUCKYCOMPASS                 @"xxxxxxxxxxxxxxx"
#define SINA_OAUTHSECRET_LUCKYCOMPASS               @"xxxxxxxxxxxxxxx"

#define SINA_AUTHERID                               11111111

#define RENREN_APPLICATIONKEY_FLYINGCOW             @"xxxxxxxxxxxxxxx"
#define RENREN_APPLICATIONSECRET_FLYINGCOW          @"xxxxxxxxxxxxxxx"

#define RENREN_APPLICATIONKEY_LUCKYCOMPASS          @"xxxxxxxxxxxxxxx"
#define RENREN_APPLICATIONSECRET_LUCKYCOMPASS       @"xxxxxxxxxxxxxxx"



static  int		m_ProductID = APPLICATION_PRODUCT_SIMPLEGAMBLEWHEEL;
static  BOOL	m_AdViewsEnable = NO;
static  BOOL	m_GameCenterEnable = NO;
static  BOOL	m_bGameCenterLogin = NO;
static  BOOL    m_bShouldShutdown = YES;

static  BOOL	m_DebugMode = NO;
static  CGFloat   m_fScreenScale = 1.0;

/*
#define ADVIEW_TYPE_NONE            -1
#define ADVIEW_TYPE_MOBCLIX         0
#define ADVIEW_TYPE_GOOGLE          1
#define ADVIEW_TYPE_APPLE           2

static int      m_nAdViewType = ADVIEW_TYPE_NONE;
*/
@implementation ApplicationConfigure

+(void)SetActiveDeviceType:(int)type
{
	m_DeviceType = type;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) 
    {
        // Retina display
        m_fScreenScale = 2.0;
//??        if([ApplicationConfigure iPADDevice] == YES)
//??            m_fScreenScale = 2.0;
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
		szKey = ADMOB_PUBLISHKEY_GAMBLEWHEEL_IPHONE;
	}
	else 
	{
		szKey = ADMOB_PUBLISHKEY_GAMBLEWHEEL_IPAD;
	}

	return szKey;
}

+(NSString*)GetCurrentMobClixPublishKey
{
	NSString* szKey = @"";
	
	szKey = MOBCLIX_PUBLISHKEY_GAMBLEWHEEL;
    
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
    return FACEBOOK_APPLICATIONKEY_SIMPLEGAMBLEWHEEL;
}

+(NSString*)GetFBURLSchemeSuffix
{
    return FACEBOOK_URLSCHEMESUFFIX_SIMPLEGAMBLEWHEEL;
}

#define SIMPLEGAMBLEWHEEL_ITUNES_URL               @"xxxxxxxxxxxxxxxxxx"
#define SIMPLEGAMBLEWHEEL_FBAPPCENTER_URL          @"xxxxxxxxxxxxxxxxxx"

#define USE_ITUNES_URL

+(NSString*)GetFacebookPostLinkURL
{
#ifdef USE_ITUNES_URL 
    return SIMPLEGAMBLEWHEEL_ITUNES_URL;
#else    
    return SIMPLEGAMBLEWHEEL_FBAPPCENTER_URL;
#endif
}

+(NSString*)GetFacebookIconLinkURL
{
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
    return SINA_OAUTHKYEY_FLYINGCOW;
}

+(NSString*)GetSinaSecret
{
    return SINA_OAUTHSECRET_FLYINGCOW;
}

+(int)GetSinaAutherID
{
    return SINA_AUTHERID;
}

+(NSString*)GetRenRenKey
{
    return RENREN_APPLICATIONKEY_FLYINGCOW;
}

+(NSString*)GetRenRenSecret
{
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

+(void)SetGameCenterLoggingin:(BOOL)bYes
{
    m_bGameCenterLogin = bYes;
}

+(BOOL)IsGameCenterLoggingin
{
    return m_bGameCenterLogin;
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



/*
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
*/

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

+(BOOL)IsGoogleInterstitialEnable
{
    return YES;
}

+(NSString*)GetGoogleInterstitialPublishKey
{
    return [ApplicationConfigure GetAdMobPublishKey];
}


static int m_nRedeemSeat = 0;
+(void)SetRedeemPlayerSeat:(int)nSeat
{
    m_nRedeemSeat = nSeat;
}

+(int)GetRedeemPlayerSeat
{
    return m_nRedeemSeat;
}


static int m_nCurrentReleaseVersion = APPLICATION_RELEASE_VERSION_TWO;
+(int)GetCurrentReleaseVersion
{
    return m_nCurrentReleaseVersion;
}

static BOOL m_bSetupLocation = NO;
static CGFloat m_fLatitude = 0.0;
static CGFloat m_fLongitude = 0.0;

+(void)SetupLocationData
{
/*
//    CLLocationManager* locManager = [[CLLocationManager alloc] init];
//	if (locManager && [CLLocationManager locationServicesEnabled])
//	{
//        m_fLatitude = (CGFloat)locManager.location.coordinate.latitude;
//        m_fLongitude = (CGFloat)locManager.location.coordinate.longitude;
//        m_bSetupLocation = YES;
	}*/
//    else
//    {
        m_bSetupLocation = NO; 
//    }
}

+(BOOL)HaveLocationData
{
    return m_bSetupLocation;
}

+(CGFloat)GetLatitude
{
    return m_fLatitude;
}

+(CGFloat)GetLongitude
{
    return m_fLongitude;
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

+(BOOL)EarnChipFromInApp
{
    return YES;
}

+(BOOL)SupportClickToEarn
{
//    if([StringFactory IsOSLangZH] || [StringFactory IsOSLangES] || [StringFactory IsOSLangPT] || [StringFactory IsOSLangIT] || [StringFactory IsOSLangFR] || [StringFactory IsOSLangGR] || [StringFactory IsOSLangJP])
//        return YES;
//    else
        return NO;
}

//This is runtime check retina display or not
+(CGFloat)GetCurrentDisplayScale
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
    BOOL bRet = NO;
/*    NSString *reqSysVer = @"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {    
        bRet = [TWTweetComposeViewController canSendTweet];
    } */    
    return bRet;
}

+(void)LogDebugInformation:(NSString*)szText
{
#ifdef DEBUG
    NSLog(@"%@",szText);
#endif    
}

@end
