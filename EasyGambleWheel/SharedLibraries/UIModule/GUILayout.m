//
//  GUILayout.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GUILayout.h"
#import "ApplicationConfigure.h"
//#import "MainApplicationDelegateTemplate.h"

static float		m_MainUIWidth = 320;
static float		m_MainUIHeight = 480;
static float		m_GlossyMenuSize_IPhone = 60; //40
static float		m_GlossyMenuSize_IPad = 100; //60
static float		m_GlossyMenuRadium_IPhone = 90;
static float		m_GlossyMenuRadium_IPad = 140;

static float		m_AdBannerHeight_IPhone = 50;
static float		m_AdBannerHeight_IPad = 90;
static float		m_AdBannerWidth_IPhone = 320;
static float		m_AdBannerWidth_IPad = 768;

static float		m_AdBigBannerHeight_IPhone = 250;
static float		m_AdBigBannerWidth_IPhone = 300;
static float		m_AdBigBannerHeight_IPad = 250;
static float		m_AdBigBannerWidth_IPad = 600;


#define  LISTCELL_HEIGHT_DEFAULT                40
#define  SWITCHICONCELL_HEIGHT_DEFAULT          70
#define  LISTCELL_MARGIN_DEFAULT                4
#define  LISTCELL_STROKE_DEFAULT                1

#define  TITLEBAR_HEIGHT_DEFAULT                30
#define  TITLEBAR_HEIGHT_IPAD                   60

#define  TEXTMSG_SENDBTN_WIDTH_IPHONE           45
#define  TEXTMSG_SENDBTN_WIDTH_IPAD             60

#define  TEXTMSG_SENDBTN_HEIGHT_IPHONE          30
#define  TEXTMSG_SENDBTN_HEIGHT_IPAD            40

#define  TEXTMSG_VIEW_WIDTH_IPHONE              200
#define  TEXTMSG_VIEW_WIDTH_IPAD                300

#define  TEXTMSG_VIEW_HEIGHT_IPHONE             100    //150
#define  TEXTMSG_VIEW_HEIGHT_IPAD               200

#define  TEXTMSG_VIEW_ROUNDRADIUM_RATIO         0.1
#define  TEXTMSG_VIEW_ARCHORSIZE_RATIO          0.1


#define  TEXTMSG_BOARD_WIDTH_IPHONE              100
#define  TEXTMSG_BOARD_WIDTH_IPAD                240

#define  TEXTMSG_BOARD_HEIGHT_IPHONE             150
#define  TEXTMSG_BOARD_HEIGHT_IPAD               240

#define  AVATAR_WIDTH_IPHONE                     50
#define  AVATAR_WIDTH_IPAD                       100

#define  AVATAR_HEIGHT_IPHONE                    50
#define  AVATAR_HEIGHT_IPAD                      100


#define  CLOSEBUTTON_SIZE_IPHONE                 20
#define  CLOSEBUTTON_SIZE_IPAD                   30

#define  EXTEND_ADVIEW_WIDTH_IPHONE             300
#define  EXTEND_ADVIEW_HEIGHT_IPHONE            240

#define  EXTEND_ADVIEW_WIDTH_IPAD               720
#define  EXTEND_ADVIEW_HEIGHT_IPAD              538

#define  EXTEND_ADVIEW_CORNER_WIDTH_IPHONE      75
#define  EXTEND_ADVIEW_CORNER_WIDTH_IPAD        120
#define  EXTEND_ADVIEW_CORNER_HEIGHT_IPHONE     50        
#define  EXTEND_ADVIEW_CORNER_HEIGHT_IPAD       90


#define  REDEEM_ADVIEW_WIDTH                   300
#define  REDEEM_ADVIEW_HEIGHT                  250
#define  REDEEM_ADVIEW_DISPLAY_TIME            10


@implementation GUILayout

+(void)SetMainUIDimension:(float)width withHeight:(float)height
{
	m_MainUIWidth = width;
	m_MainUIHeight = height;
}

+(float)GetMainUIWidth
{
	
    return m_MainUIWidth;
}

+(float)GetMainUIHeight
{
	return m_MainUIHeight;
}

+(BOOL)IsProtrait
{
	BOOL bRet = NO;
	if(m_MainUIWidth < m_MainUIHeight)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsLandscape
{
	BOOL bRet = NO;
	if(m_MainUIHeight < m_MainUIWidth)
		bRet = YES;
	
	return bRet;
}	


+(float)GetGlossyMenuSize
{
	if([ApplicationConfigure iPhoneDevice])
		return m_GlossyMenuSize_IPhone;
	else 
		return m_GlossyMenuSize_IPad;
}	

+(float)GetDefaultGlossyMenuLayoutRadium
{
	if([ApplicationConfigure iPhoneDevice])
		return m_GlossyMenuRadium_IPhone;
	else 
		return m_GlossyMenuRadium_IPad;
}

+(float)GetContentViewWidth
{
	return [GUILayout GetMainUIWidth];
}	

+(float)GetContentViewHeight
{
    float h = [GUILayout GetMainUIHeight]; //??? - [GUILayout GetAdBannerHeight];
	return h;
}

+(float)GetContentViewMinDimension
{
    float w = [GUILayout GetContentViewWidth];
    float h = [GUILayout GetContentViewHeight];
    float r = MIN(w, h);
    return r;
}

+(float)GetAdBannerHeight
{
	float h = 0;
//	if([ApplicationConfigure GetAdViewsState] == YES)
//	{
		if([ApplicationConfigure iPhoneDevice] == YES)
		{
			h = m_AdBannerHeight_IPhone;
		}
		else 
		{
			h = m_AdBannerHeight_IPad;
		}
//	}
	
	return h;
}	

+(float)GetAdBannerWidth
{
	float w = 0;
//	if([ApplicationConfigure GetAdViewsState] == YES)
//	{
		if([ApplicationConfigure iPhoneDevice] == YES)
		{
			w = m_AdBannerWidth_IPhone;
		}
		else 
		{
			w = m_AdBannerWidth_IPad;
		}
//	}
	return w;
}

+(float)GetAdBigBannerHeight
{
	float h = 0;
//	if([ApplicationConfigure GetAdViewsState] == YES)
//	{
		if([ApplicationConfigure iPhoneDevice] == YES)
		{
			h = m_AdBigBannerHeight_IPhone;
		}
		else 
		{
			h = m_AdBigBannerHeight_IPad;
		}
//	}
	
	return h;
}

+(float)GetAdBigBannerWidth
{
	float w = 0;
//	if([ApplicationConfigure GetAdViewsState] == YES)
//	{
		if([ApplicationConfigure iPhoneDevice] == YES)
		{
			w = m_AdBigBannerWidth_IPhone;
		}
		else 
		{
			w = m_AdBigBannerWidth_IPad;
		}
//	}
	
	return w;
}

+(float)GetDefaultTitleBarHeight
{
    return TITLEBAR_HEIGHT_DEFAULT;
}

+(float)GetTitleBarHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return TITLEBAR_HEIGHT_DEFAULT;
    }
    else
    {
        return TITLEBAR_HEIGHT_IPAD;
    }
}

+(float)GetDefaultListCellHeight
{
	return LISTCELL_HEIGHT_DEFAULT; 
}	

+(float)GetDefaultListCellMargin
{
	return LISTCELL_MARGIN_DEFAULT;
}	

+(float)GetDefaultListCellStroke
{
	return LISTCELL_STROKE_DEFAULT;
}

+(float)GetDefaulSwitchIconCellHeight
{
	return SWITCHICONCELL_HEIGHT_DEFAULT; 
}

+(float)GetDefaultExtendAdViewWidth
{
    if([ApplicationConfigure iPhoneDevice])
        return EXTEND_ADVIEW_WIDTH_IPHONE;            
    else
        return EXTEND_ADVIEW_WIDTH_IPAD;
}

+(float)GetDefaultExtendAdViewHeight
{
    if([ApplicationConfigure iPhoneDevice])
        return EXTEND_ADVIEW_HEIGHT_IPHONE;            
    else
        return EXTEND_ADVIEW_HEIGHT_IPAD;
}

+(float)GetExtendAdViewCornerWidth
{
    if([ApplicationConfigure iPhoneDevice])
        return EXTEND_ADVIEW_CORNER_WIDTH_IPHONE;            
    else
        return EXTEND_ADVIEW_CORNER_WIDTH_IPAD;
}

+(float)GetExtendAdViewCornerHeight
{
    if([ApplicationConfigure iPhoneDevice])
        return EXTEND_ADVIEW_CORNER_HEIGHT_IPHONE;            
    else
        return EXTEND_ADVIEW_CORNER_HEIGHT_IPAD;
}

+(float)GetDefaultExtendAdViewDisplayTime
{
    return 2.0;
}

+(float)GetDefaultHouseAdDisplayTime
{
    return 6.0;
}

+(float)GetDefaultHouseAdViewDisplayTime
{
    return 24.0;
}

+(float)GetDefaultHouseAdViewDisplayInterval
{
    return 300;
}

+(float)GetRedeemAdViewWidth
{
    return (REDEEM_ADVIEW_WIDTH+2*[GUILayout GetDefaultAlertUIEdge]);
}

+(float)GetRedeemAdViewHeight
{
    return (REDEEM_ADVIEW_HEIGHT+2*[GUILayout GetDefaultAlertUIEdge]);
}

+(float)GetDefaultRedeemAdViewDisplayTime
{
    return REDEEM_ADVIEW_DISPLAY_TIME;
}

#define CASH_BAG_BUTTON_SIZE    200
+(float)GetFullScreenAdButtonSize
{
    return CASH_BAG_BUTTON_SIZE;
}

#define CASH_BAG_LABEL_HEIGHT    30
+(float)GetFullScreenAdLabelHeight
{
    return CASH_BAG_LABEL_HEIGHT; 
}

#define CASH_BAG_LABEL_FONT    30
+(float)GetFullScreenAdLabelFont
{
    return CASH_BAG_LABEL_FONT; 
}

#define CASH_BAG_IMAGE_SIZE    180
+(float)GetFullScreenAdButtonImageSize
{
    return CASH_BAG_IMAGE_SIZE;
}

static UIViewController* g_GameView = nil;

+(UIViewController *)GetGameViewController
{
    return g_GameView;
}

+(void)SetGameViewController:(UIViewController *)view
{
    g_GameView = view;
}

static UIViewController* g_RootView = nil;
+(UIViewController *)GetRootViewController
{
    return g_RootView;
}

+(void)SetRootViewController:(UIViewController *)view
{
    g_RootView = view;
}


/*
+(Facebook*)GetFacebookInstance
{
    Facebook* pFacebook = nil;
    id<MainStdAdApplicationDelegateTemplate> pDelegate = ((id<MainStdAdApplicationDelegateTemplate>)[[UIApplication sharedApplication] delegate]);
    
    if(pDelegate != nil)
    {
        pFacebook = [pDelegate GetFacebookInstance];
    }
    
    return pFacebook;
}

+(StdAdPostAppDelegate*)GetApplicationDelegate
{
    StdAdPostAppDelegate* pDelegate = ((StdAdPostAppDelegate*)[[UIApplication sharedApplication] delegate]);
    
    return pDelegate;
}
*/

+(float)GetTMSButtonWidth
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return TEXTMSG_SENDBTN_WIDTH_IPHONE;
    }
    else
    {    
        return TEXTMSG_SENDBTN_WIDTH_IPAD;
    }    
}

+(float)GetTMSButtonHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return TEXTMSG_SENDBTN_HEIGHT_IPHONE;
    }
    else
    {    
        return TEXTMSG_SENDBTN_HEIGHT_IPAD;
    }    
}

+(float)GetTextMsgViewWidth
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return TEXTMSG_VIEW_WIDTH_IPHONE;
    }
    else
    {    
        return TEXTMSG_VIEW_WIDTH_IPAD;
    }
}

+(float)GetTextMsgViewHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return TEXTMSG_VIEW_HEIGHT_IPHONE;
    }
    else
    {    
        return TEXTMSG_VIEW_HEIGHT_IPAD;
    }    
}

+(float)GetTMSViewRoundRatio
{
    return TEXTMSG_VIEW_ROUNDRADIUM_RATIO;
}

+(float)GetTMSViewAchorRatio
{
    return TEXTMSG_VIEW_ARCHORSIZE_RATIO;
}

+(float)GetCloseButtonSize
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CLOSEBUTTON_SIZE_IPHONE;
    }
    else
    {    
        return CLOSEBUTTON_SIZE_IPAD;
    }    
}

+(float)GetMsgBoardViewWidth
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return TEXTMSG_BOARD_WIDTH_IPHONE;
    }
    else
    {    
        return TEXTMSG_BOARD_WIDTH_IPAD;
    }    
}

+(float)GetMsgBoardViewHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return TEXTMSG_BOARD_HEIGHT_IPHONE;
    }
    else
    {    
        return TEXTMSG_BOARD_HEIGHT_IPAD;
    }    
}


+(float)GetAvatarWidth
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return AVATAR_WIDTH_IPHONE;
    }
    else
    {    
        return AVATAR_WIDTH_IPAD;
    }
}

+(float)GetAvatarHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return AVATAR_HEIGHT_IPHONE;
    }
    else
    {    
        return AVATAR_HEIGHT_IPAD;
    }    
}

+(float)GetPlayerBadgetRatioToAvatar
{
    return 0.6;
}

#define  CASH_FAUCET_SIZE_IPAD                  80
#define  CASH_FAUCET_SIZE_IPHONE                40


+(float)GetCashFaucetSize
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_FAUCET_SIZE_IPHONE;
    }
    else
    {    
        return CASH_FAUCET_SIZE_IPAD;
    }    
}

#define  CASH_COIN_WIDTH_IPAD                  90
#define  CASH_COIN_WIDTH_IPHONE                45

+(float)GetGoldenCoinBoundWidth
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_COIN_WIDTH_IPHONE;
    }
    else
    {    
        return CASH_COIN_WIDTH_IPAD;
    }    
}

#define  CASH_COIN_HEIGHT_IPAD                 72
#define  CASH_COIN_HEIGHT_IPHONE               36

+(float)GetGoldenCoinBoundHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_COIN_HEIGHT_IPHONE;
    }
    else
    {    
        return CASH_COIN_HEIGHT_IPAD;
    }    
}

#define  CASH_COIN_MIN_WIDTH_IPAD                30
#define  CASH_COIN_MIN_WIDTH_IPHONE              15
+(float)GetGoldenCoinMinBoundWidth
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_COIN_MIN_WIDTH_IPHONE;
    }
    else
    {    
        return CASH_COIN_MIN_WIDTH_IPAD;
    }    
}

#define  CASH_COIN_MIN_HEIGHT_IPAD                 24
#define  CASH_COIN_MIN_HEIGHT_IPHONE               12
+(float)GetGoldenCoinMinBoundHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_COIN_MIN_HEIGHT_IPHONE;
    }
    else
    {    
        return CASH_COIN_MIN_HEIGHT_IPAD;
    }    
}


#define  CASH_BAG_SIZE_IPAD                  100
#define  CASH_BAG_SIZE_IPHONE                50

+(float)GetCashBagSize
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_BAG_SIZE_IPHONE;
    }
    else
    {    
        return CASH_BAG_SIZE_IPAD;
    }    
}

#define  CASH_BAG_MIN_SIZE_IPAD               80
#define  CASH_BAG_MIN_SIZE_IPHONE             40
+(float)GetCashBagMinSize
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_BAG_MIN_SIZE_IPHONE;
    }
    else
    {    
        return CASH_BAG_MIN_SIZE_IPAD;
    }    
}

#define  CASH_BAG_LABEL_HEIGHT_IPAD           40
#define  CASH_BAG_LABEL_HEIGHT_IPHONE         20

+(float)GetCashBagLabelHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_BAG_LABEL_HEIGHT_IPHONE;
    }
    else
    {    
        return CASH_BAG_LABEL_HEIGHT_IPAD;
    }    
}

#define  CASH_MIN_BAG_LABEL_HEIGHT_IPAD        20
#define  CASH_MIN_BAG_LABEL_HEIGHT_IPHONE      10

+(float)GetCashBagLabelMinHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_MIN_BAG_LABEL_HEIGHT_IPHONE;
    }
    else
    {    
        return CASH_MIN_BAG_LABEL_HEIGHT_IPAD;
    }    
}

#define  CASH_BAG_LABEL_FONT_IPAD           40
#define  CASH_BAG_LABEL_FONT_IPHONE         20
+(float)GetCashBagLabelFont
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_BAG_LABEL_FONT_IPHONE;
    }
    else
    {    
        return CASH_BAG_LABEL_FONT_IPAD;
    }    
}

#define  CASH_MIN_BAG_LABEL_FONT_IPAD           20
#define  CASH_MIN_BAG_LABEL_FONT_IPHONE         10

+(float)GetCashBagLabelMinFont
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASH_MIN_BAG_LABEL_FONT_IPHONE;
    }
    else
    {    
        return CASH_MIN_BAG_LABEL_FONT_IPAD;
    }    
}

#define  AVATAR_IMAGE_SIZE_IPAD                 156
#define  AVATAR_IMAGE_SIZE_IPHONE               78

+(float)GetAvatarImageSize
{
    //if([ApplicationConfigure iPhoneDevice] == YES)
    //{
    //    return AVATAR_IMAGE_SIZE_IPHONE;
    //}
    //else
    //{    
        return AVATAR_IMAGE_SIZE_IPAD;
    //}    
}

#define  CHIP_IMAGE_SIZE_IPAD                   78
#define  CHIP_IMAGE_SIZE_IPHONE                 36

+(float)GetChipImageSize
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CHIP_IMAGE_SIZE_IPHONE;
    }
    else
    {    
        return CHIP_IMAGE_SIZE_IPAD;
    }    
}

#define  AVATAR_DISPLAY_SIZE_IPAD                 100
#define  AVATAR_DISPLAY_SIZE_IPHONE               60
+(float)GetAvatarDislaySize
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return AVATAR_DISPLAY_SIZE_IPHONE;
    }
    else
    {    
        return AVATAR_DISPLAY_SIZE_IPAD;
    }    
}

#define  AVATAR_DISPLAY_MARGIN_VERTICAL_PROTRAIT_IPHONE     40
#define  AVATAR_DISPLAY_MARGIN_VERTICAL_LANDSCAPE_IPHONE    6
#define  AVATAR_DISPLAY_MARGIN_VERTICAL_PROTRAIT_IPAD       100
#define  AVATAR_DISPLAY_MARGIN_VERTICAL_LANDSCAPE_IPAD      20
+(float)GetAvatarDislayVerticalMargin
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        if([GUILayout IsProtrait])
            return AVATAR_DISPLAY_MARGIN_VERTICAL_PROTRAIT_IPHONE;
        else
            return AVATAR_DISPLAY_MARGIN_VERTICAL_LANDSCAPE_IPHONE;
    }
    else
    {    
        if([GUILayout IsProtrait])
            return AVATAR_DISPLAY_MARGIN_VERTICAL_PROTRAIT_IPAD;
        else
            return AVATAR_DISPLAY_MARGIN_VERTICAL_LANDSCAPE_IPAD;
    }    
}

#define  AVATAR_DISPLAY_MARGIN_HORIZONTAL_PROTRAIT_IPHONE     5
#define  AVATAR_DISPLAY_MARGIN_HORIZONTAL_LANDSCAPE_IPHONE    60
#define  AVATAR_DISPLAY_MARGIN_HORIZONTAL_PROTRAIT_IPAD       50
#define  AVATAR_DISPLAY_MARGIN_HORIZONTAL_LANDSCAPE_IPAD      150
+(float)GetAvatarDislayHorizontalMargin
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        if([GUILayout IsProtrait])
            return AVATAR_DISPLAY_MARGIN_HORIZONTAL_PROTRAIT_IPHONE;
        else
            return AVATAR_DISPLAY_MARGIN_HORIZONTAL_LANDSCAPE_IPHONE;
    }
    else
    {    
        if([GUILayout IsProtrait])
            return AVATAR_DISPLAY_MARGIN_HORIZONTAL_PROTRAIT_IPAD;
        else
            return AVATAR_DISPLAY_MARGIN_HORIZONTAL_LANDSCAPE_IPAD;
    }    
}

+(float)GetWinnerAnimatorDislayRatio
{
    return 0.55;
}

#define  CASHMACHINE_SIZE_DEFAULT                36
#define  CASHMACHINE_SIZE_IPAD                   60

+(float)GetCashMachineSize
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return CASHMACHINE_SIZE_DEFAULT;
    }
    else
    {
        return CASHMACHINE_SIZE_IPAD;
    }
}

+(float)GetCashEarnDislayImageWidth
{
    return 100;
}

+(float)GetCashEarnDislayImageIconHeight
{
    return 73;
}

+(float)GetCashEarnDislayIPhoneRatio
{
    return 0.5;
}

+(float)GetCashEarnDislayWidth
{
    float fRet = [GUILayout GetCashEarnDislayImageWidth];
    if([ApplicationConfigure iPhoneDevice])
        fRet *= [GUILayout GetCashEarnDislayIPhoneRatio];
    return fRet;
}

+(float)GetCashEarnDislayIconHeight
{
    float fRet = [GUILayout GetCashEarnDislayImageIconHeight];
    if([ApplicationConfigure iPhoneDevice])
        fRet *= [GUILayout GetCashEarnDislayIPhoneRatio];
    return fRet;
}

+(float)GetLuckyNumberPickViewWidth
{
    float fRet = ([GUILayout GetCashEarnDislayWidth])*4.0;
    return fRet;
}

+(float)GetLuckyNumberPickViewIconHeight
{
    float ficonw = [GUILayout GetCashEarnDislayWidth];
    float ficonh = [GUILayout GetCashEarnDislayIconHeight];

    float fRet = ficonh+ficonw;
    return fRet;
}

+(float)GetLuckyNumberPickViewLabelHeight
{
    float fRet = 24;
    if([ApplicationConfigure iPhoneDevice])
        fRet = 10;
    return fRet;
    
}

+(float)GetLuckyNumberPickViewPikcerHeight
{
    float fRet = [GUILayout GetLuckyNumberPickViewWidth]*0.75;
    return fRet;
}

+(float)GetLuckyNumberPickViewHeight;
{
    float fRet = [GUILayout GetLuckyNumberPickViewPikcerHeight] + [GUILayout GetLuckyNumberPickViewLabelHeight] + [GUILayout GetLuckyNumberPickViewIconHeight];
    return fRet;
}

+(float)GetPlayerPopuoMenueHeightRatio
{
    return 0.36;
}

+(float)GetDefaultCloseButtonSize
{
    return 30;
}

+(float)GetDefaultAlertUIConner
{
    return 30;
}

+(float)GetDefaultAlertUIEdge
{
    return 6;
}

#define ALERT_WIDTH_IPAD                400
#define ALERT_WIDTH_IPHONE_LANDSCAPE    400
#define ALERT_WIDTH_IPHONE_PROTRAIT     240


+(float)GetDefaultAlertWidth:(BOOL)bLandScape
{
    if([ApplicationConfigure iPADDevice])
    {    
        return ALERT_WIDTH_IPAD;
    }    
    else
    {    
        if(bLandScape)
            return ALERT_WIDTH_IPHONE_LANDSCAPE;
        else
            return ALERT_WIDTH_IPHONE_PROTRAIT;
    }    
}

#define ALERT_LABEL_HEIGHT_IPAD         30
#define ALERT_LABEL_HEIGHT_IPHONE       24
+(float)GetDefaultAlertLabelLineHeight
{
    if([ApplicationConfigure iPADDevice])
    {    
        return ALERT_LABEL_HEIGHT_IPAD;
    }    
    else
    {    
        return ALERT_LABEL_HEIGHT_IPHONE;
    }    
}


#define ALERT_BUTTON_HEIGHT_IPAD         30
#define ALERT_BUTTON_HEIGHT_IPHONE       24
+(float)GetDefaultAlertButtonHeight
{
    if([ApplicationConfigure iPADDevice])
    {    
        return ALERT_BUTTON_HEIGHT_IPAD;
    }    
    else
    {    
        return ALERT_BUTTON_HEIGHT_IPHONE;
    }    
}

#define ALERT_BUTTON_WIDTH_IPAD         100
#define ALERT_BUTTON_WIDTH_IPHONE       80
+(float)GetDefaultAlertButtonWidth
{
    if([ApplicationConfigure iPADDevice])
    {    
        return ALERT_BUTTON_WIDTH_IPAD;
    }    
    else
    {    
        return ALERT_BUTTON_WIDTH_IPHONE;
    }    
}

#define ALERT_FONTSIZE_IPAD         24
#define ALERT_FONTSIZE_IPHONE       16
+(float)GetDefaultAlertFontSize
{
    if([ApplicationConfigure iPADDevice])
    {    
        return ALERT_FONTSIZE_IPAD;
    }    
    else
    {    
        return ALERT_FONTSIZE_IPHONE;
    }    
}

#define ALERT_OPRION_BUTTON_HEIGHT_IPAD         48
#define ALERT_OPRION_BUTTON_HEIGHT_IPHONE       30
+(float)GetOptionalAlertButtonHeight
{
    if([ApplicationConfigure iPADDevice])
    {    
        return ALERT_OPRION_BUTTON_HEIGHT_IPAD;
    }    
    else
    {    
        return ALERT_OPRION_BUTTON_HEIGHT_IPHONE;
    }    
}

#define ALERT_OPRION_BUTTON_WIDTH_IPAD         300
#define ALERT_OPRION_BUTTON_WIDTH_IPHONE       160
+(float)GetOptionalAlertButtonWidth
{
    if([ApplicationConfigure iPADDevice])
    {    
        return ALERT_OPRION_BUTTON_WIDTH_IPAD;
    }    
    else
    {    
        return ALERT_OPRION_BUTTON_WIDTH_IPHONE;
    }    
}

+(float)GetOptionalAlertUIConner
{
    if([ApplicationConfigure iPADDevice])
    {    
        return 30;
    }    
    else
    {    
        return 20;
    }    
}

+(float)GetFileSaveUIButtonHeight
{
    if([ApplicationConfigure iPADDevice])
    {    
        return 40;
    }    
    else
    {    
        return 30;
    }    
}

+(float)GetFileSaveUIButtonWidth
{
    if([ApplicationConfigure iPADDevice])
    {    
        return 120;
    }    
    else
    {    
        return 80;
    }    
}

+(float)GetStatusBarWidth
{
    if([ApplicationConfigure iPADDevice])
    {    
        return 400;
    }    
    else
    {    
        return 170;
    }    
}

+(float)GetStatusBarHeight
{
    if([ApplicationConfigure iPADDevice])
    {    
        return 42;
    }    
    else
    {    
        return 30;
    }    
}

#define DEFAULT_TEXTEDITOR_WIDTH_IPHONE         280
#define DEFAULT_TEXTEDITOR_WIDTH_IPAD           400

+(float)GetDefaultTextEditorWidth
{
    if([ApplicationConfigure iPADDevice])
    {
        return DEFAULT_TEXTEDITOR_WIDTH_IPAD;
    }
    else
    {
        return DEFAULT_TEXTEDITOR_WIDTH_IPHONE;
    }
}

#define DEFAULT_TEXTEDITOR_HEIGHT_IPHONE         120
#define DEFAULT_TEXTEDITOR_HEIGHT_IPAD           200
+(float)GetDefaultTextEditorHeight
{
    float fRet = [GUILayout GetDefaultTextEditorHeightMargin]*3+[GUILayout GetDefaultAlertUIEdge]*2+[GUILayout GetDefaultTextEditorButtonHeight]*2;
    
    return fRet;
}

#define DEFAULT_TEXTEDITOR_BUTTON_WIDTH_IPHONE         70
#define DEFAULT_TEXTEDITOR_BUTTON_WIDTH_IPAD           120
+(float)GetDefaultTextEditorButtonWidth
{
    if([ApplicationConfigure iPADDevice])
    {
        return DEFAULT_TEXTEDITOR_BUTTON_WIDTH_IPAD;
    }
    else
    {
        return DEFAULT_TEXTEDITOR_BUTTON_WIDTH_IPHONE;
    }
}

#define DEFAULT_TEXTEDITOR_BUTTON_HEIGHT_IPHONE         30
#define DEFAULT_TEXTEDITOR_BUTTON_HEIGHT_IPAD           40
+(float)GetDefaultTextEditorButtonHeight
{
    if([ApplicationConfigure iPADDevice])
    {
        return DEFAULT_TEXTEDITOR_BUTTON_HEIGHT_IPAD;
    }
    else
    {
        return DEFAULT_TEXTEDITOR_BUTTON_HEIGHT_IPHONE;
    }
}

+(float)GetDefaultTextEditorHeightMargin
{
    float margin = [GUILayout GetDefaultAlertUIEdge]*2.0;
    if([ApplicationConfigure iPADDevice])
        margin *= 2.0;
    
    return margin;
    
}

+(float)GetDefaultKeyboardHeight
{
    if([ApplicationConfigure iPADDevice])
    {
        if([GUILayout IsProtrait])
        {
            return 264;
        }
        else
        {
            return 350;
        }
    }
    else
    {
        if([GUILayout IsProtrait])
        {
            return 216;
        }
        else
        {
            return 162;
        }
    }
}

@end
