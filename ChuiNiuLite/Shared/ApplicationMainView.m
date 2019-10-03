//
//  ApplicationMainView.m
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 2010-09-05.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "ApplicationMainView.h"
#import "GameScene.h"
#import "Configuration.h"
#import "ImageLoader.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
#import "ScoreRecord.h"
#import "StringFactory.h"
#import "UIDevice-Reachability.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "NSData-Base64.h"
#import "GameCenterConstant.h"
#import "GameCenterManager.h"
#import "RenderHelper.h"
#import "CustomModalAlertView.h"
#import "ApplicationController.h"
#import "StringFactory.h"

#define NOTIFY_AND_LEAVE(X) {NSLog(X); return;}

#define PRODUCT_ID	@"com.xgadget.ChuiNiuLite.PaidVersion"
#define SANDBOX			NO

#define MAX_FALSHADDISPLAY          600
#define STATUSBAR_WIDTH_IPHONE      300
#define STATUSBAR_HEIGHT_IPHONE     50
#define STATUSBAR_WIDTH_IPAD      500
#define STATUSBAR_HEIGHT_IPAD     60

@implementation ApplicationMainView

@synthesize log;

- (BOOL)IsFreeOnlineADVersion
{
	//return m_bFreeVersion;
	BOOL bRet = YES;
	if([ScoreRecord CheckPaymentState])
		bRet = NO;
	
	return bRet;
}	

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		m_LandscapeCheckerImage = [ImageLoader CreateLandScapeBKImage];
		m_ProtraitCheckerImage = [ImageLoader CreateProtraitBKImage];
        m_bFlashAdShowing = NO;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        m_bAdsLoad = NO;
        self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}	

- (void)drawColorBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSetRGBFillColor(context, 0.55, 0.55, 1.0, 1.00);
    CGContextFillRect(context, rect);
}

- (void)drawPaperBackground:(CGContextRef)context inRect:(CGRect)rect
{
	if([GUILayout IsProtrait])
		CGContextDrawImage(context, rect, m_ProtraitCheckerImage);
	else
		CGContextDrawImage(context, rect, m_LandscapeCheckerImage);
}

- (void)drawNightBackground:(CGContextRef)context inRect:(CGRect)rect
{
    float fAlpha = 1.0;
    CGRect rt;
    [RenderHelper DrawStartPattern1Fill:context withAlpha:fAlpha atRect:rect];
    float miny = rect.size.width < rect.size.height ? rect.size.width : rect.size.height; 
    float moonh = miny/10.0;
    float moonw = moonh*0.6; 
    miny = miny/2.0;
    
    float minx = rect.size.width/4.0; 
    
    for(int i = 0; i < 4; ++i)
    { 
        fAlpha = 0.5+0.2*(i%3);
        float x = rect.origin.x + minx*i;
        float y = rect.origin.y + miny*0.1*(i%2);
        
        rt = CGRectMake(x, y, minx*0.8, miny*0.6);
        [RenderHelper DrawStartPattern2Fill:context withAlpha:fAlpha atRect:rt];
    }
    rt = CGRectMake(rect.origin.x+minx*0.5, rect.origin.y+miny*0.3, moonw, moonh);
    [RenderHelper DrawMoon:context atRect:rt];
}

-(void)drawGround:(CGContextRef)context inRect:(CGRect)rect
{
    [RenderHelper DrawGroundMud:context atRect:rect];
}

- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	int nMode = [Configuration getBackgroundSetting];

	if(nMode == GAME_BACKGROUND_NIGHT)
		[self drawNightBackground:context inRect:rect];
	else if(nMode == GAME_BACKGROUND_CHECKER)
		[self drawPaperBackground:context inRect:rect];
	else
		[self drawColorBackground:context inRect:rect];

    float w = [GUILayout GetMainUIWidth];
    float h = [GUILayout GetMainUIHeight] - [GUILayout GetContentViewHeight];
    if(0 < h)
    {
        CGRect rt = CGRectMake(0, [GUILayout GetContentViewHeight], w, h);
        [self drawGround:context inRect:rt];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(void)InitSubViews
{
	CGRect rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);
	
    
	m_ConfigureView = [[ConfigurationView alloc] initWithFrame:rect];
	[self addSubview:m_ConfigureView];
	[m_ConfigureView release];
	m_ConfigureView.hidden = YES;
	
	m_ScoreView = [[ScoreView alloc] initWithFrame:rect];
	[self addSubview:m_ScoreView];
	[m_ScoreView release];
	m_ScoreView.hidden = YES;
	
	m_ShareView = [[SNSShareView alloc] initWithFrame:rect];
	[self addSubview:m_ShareView];
	[m_ShareView release];
	m_ShareView.hidden = YES;

    m_FriendView = [[FriendView alloc] initWithFrame:rect];
	[self addSubview:m_FriendView];
	[m_FriendView release];
	m_FriendView.hidden = YES;
    
    m_HelpView = [[HelpView alloc] initWithFrame:rect];
    [self addSubview:m_HelpView];
    [m_HelpView release];
    m_HelpView.hidden = YES;
    
    m_OnlinePlayerStatusView = [[PlayerOnlineStatusView alloc] initWithFrame:rect];
    [self addSubview:m_OnlinePlayerStatusView];
    [m_OnlinePlayerStatusView release];
    m_OnlinePlayerStatusView.hidden = YES;
    
    
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        /*float h = [GUILayout GetMainUIHeight];
        float ah = [GUILayout GetAdBannerHeight];
        CGRect rt = CGRectMake(0, h-ah, [GUILayout GetMainUIWidth], ah);
        BOOL bMobFox = NO;
        if([StringFactory IsOSLangGR] || [StringFactory IsOSLangIT] || [StringFactory IsOSLangFR])
            bMobFox = YES;
        m_AdViewBottom = [[Ad320x50View alloc] initAdViewWithFrame:rt enableMobFox:bMobFox];
        [self addSubview:m_AdViewBottom];
        [m_AdViewBottom release];
        
        m_AdFlashView = [[AdBannerView alloc] initWithFrame:CGRectMake(0, 0, [GUILayout GetAdBigBannerWidth], [GUILayout GetAdBigBannerHeight])];
        float cx = [GUILayout GetMainUIWidth]*0.5;
        float cy = [GUILayout GetMainUIHeight]*0.5;
        [m_AdFlashView setCenter:CGPointMake(cx, cy)];
        m_AdFlashView.hidden = YES;
        [self addSubview:m_AdFlashView];
        [self sendSubviewToBack:m_AdFlashView];
        [m_AdFlashView release];*/
        [self DelayLoadAds];
	}

	m_LeaderBoardView = [[LeaderBoardSelectView alloc] initWithFrame:rect];
	[self addSubview:m_LeaderBoardView];
	[m_LeaderBoardView release];
	m_LeaderBoardView.hidden = YES;
	
    m_GameCenterPostView = [[GameCenterPostView alloc] initWithFrame:rect];
	[self addSubview:m_GameCenterPostView];
	[m_GameCenterPostView release];
	m_GameCenterPostView.hidden = YES;
    
    m_AchievementView = [[AchievementSelectView alloc] initWithFrame:rect];
	[self addSubview:m_AchievementView];
	[m_AchievementView release];
	m_AchievementView.hidden = YES;
    
    m_AchievementPostView = [[AchievementPostView alloc] initWithFrame:rect];
	[self addSubview:m_AchievementPostView];
	[m_AchievementPostView release];
	m_AchievementPostView.hidden = YES;
    
    m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:m_Spinner];
    
    float sbw, sbh;
    if([ApplicationConfigure iPADDevice])
    {
        sbw = STATUSBAR_WIDTH_IPAD;
        sbh = STATUSBAR_HEIGHT_IPAD;
    }
    else 
    {
        sbw = STATUSBAR_WIDTH_IPHONE;
        sbh = STATUSBAR_HEIGHT_IPHONE;
    }
    m_StatusBar = [[CustomDummyAlertView alloc] initWithFrame:CGRectMake(([GUILayout GetMainUIWidth]-sbw)/2.0, 0, sbw, sbh)];
    [self addSubview:m_StatusBar];
    [m_StatusBar release];
    [m_StatusBar Hide];
    [m_StatusBar SetMultiLineText:NO];
    m_StatusBarStartTime = [[NSProcessInfo processInfo] systemUptime];
    
	m_GameView = [[GameView alloc] initWithFrame:rect];
	[self addSubview:m_GameView];
	[m_GameView release];
	[m_GameView updateGameLayout];
    [m_GameView resetGame];
    setGamePlayState(GAME_PLAY_READY);
	
	
    
	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENCONFIGUREVIEW eventHandler:@selector(OnOpenConfigureView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENSCOREVIEW eventHandler:@selector(OnOpenScoreView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENSHAREVIEW eventHandler:@selector(OnOpenShareView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_PURCHASE eventHandler:@selector(OnPurchase:) eventReceiver:self eventSender:m_GameView];
    [GUIEventLoop RegisterEvent:GUIID_OPENFRIENDVIEW eventHandler:@selector(OnOpenFriendView:) eventReceiver:self eventSender:m_GameView];
    
	[GUIEventLoop RegisterEvent:GUIID_EVENT_POSTWINMESSAGE eventHandler:@selector(OnPostGameWinMessage) eventReceiver:self eventSender:nil];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_POSTLOSTMESSAGE eventHandler:@selector(OnPostGameLostMessage) eventReceiver:self eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OPENHELPVIEW eventHandler:@selector(OnOpenHelpView) eventReceiver:self eventSender:nil];

    [GUIEventLoop RegisterEvent:GUIID_EVENT_OPENONLINEGAMERSTATUSVIEW eventHandler:@selector(OnOpenOnlineGamerStatusView) eventReceiver:self eventSender:nil];
    
    
    [GUIEventLoop RegisterEvent:GUIID_AWSSERVICE_FAILED_EVENT eventHandler:@selector(OnAWSServiceFailed) eventReceiver:self eventSender:nil];
}	

-(void)UpdateSubViewsOrientation
{
	CGRect rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);

    [m_GameView setFrame:rect];
	[m_GameView updateGameLayout];

	[m_ConfigureView setFrame:rect];
	[m_ConfigureView UpdateViewLayout];
	[m_ScoreView setFrame:rect];
	[m_ScoreView UpdateViewLayout];
	[m_ShareView setFrame:rect];
	[m_ShareView UpdateViewLayout];
    [m_LeaderBoardView setFrame:rect];
    [m_LeaderBoardView UpdateViewLayout];
    [m_GameCenterPostView setFrame:rect];
    [m_GameCenterPostView UpdateViewLayout];
    [m_AchievementView setFrame:rect];
    [m_AchievementView UpdateViewLayout];
    [m_AchievementPostView setFrame:rect];
    [m_AchievementPostView UpdateViewLayout];
    [m_FriendView setFrame:rect];
    [m_FriendView UpdateViewLayout];
    [m_HelpView setFrame:rect];
    [m_HelpView UpdateViewLayout];
    [m_OnlinePlayerStatusView setFrame:rect];
    [m_OnlinePlayerStatusView UpdateViewLayout];
    
    if([ApplicationConfigure GetAdViewsState] == YES && m_bAdsLoad == YES)
    {   
        float w = [GUILayout GetMainUIWidth];
        float h = [GUILayout GetMainUIHeight];
        float ah = [GUILayout GetAdBannerHeight];
        float aw = [GUILayout GetAdBannerWidth];
        CGRect rt = CGRectMake((w-aw)/2.0, h-ah, aw, ah);
        [m_AdViewBottom setFrame:rt];
        //[m_AdViewBottom ];
	
        float cx = [GUILayout GetMainUIWidth]*0.5;
        float cy = [GUILayout GetMainUIHeight]*0.5;
        [m_AdFlashView setCenter:CGPointMake(cx, cy)];
        
        w = [GUILayout GetExtendAdViewCornerWidth];
        h = [GUILayout GetExtendAdViewCornerWidth];
        float sx = ([GUILayout GetMainUIWidth] -w)/2.0;
        float sy = [GUILayout GetContentViewHeight];
        rt = CGRectMake(sx, sy, w, h);
        [m_ExtendAdView setFrame:rt];
        [m_ExtendAdView UpdateViewLayout];
        float fSize = [GUILayout GetHouseAdViewSize];
        rt = CGRectMake(([GUILayout GetContentViewWidth]-fSize)/2.0, [GUILayout GetContentViewHeight], fSize, fSize);
        [m_HouseAdView setFrame:rt];
        [m_HouseAdView setNeedsDisplay];
        [self setNeedsDisplay];
        
    }

    float sbw, sbh;
    CGRect sbrt;
    if([ApplicationConfigure iPADDevice])
    {
        sbw = STATUSBAR_WIDTH_IPAD;
        sbh = STATUSBAR_HEIGHT_IPAD;
        sbrt = CGRectMake(([GUILayout GetMainUIWidth]-sbw)/2.0, 0, sbw, sbh);
    }
    else 
    {
        sbw = STATUSBAR_WIDTH_IPHONE;
        sbh = STATUSBAR_HEIGHT_IPHONE;
        //if([GUILayout IsProtrait])
        //{
        //    sbrt = CGRectMake(([GUILayout GetMainUIWidth]-sbw)/2.0, ([GUILayout GetContentViewHeight]-sbh)/2.0, sbw, sbh);
        //}
        //else
        //{
            sbrt = CGRectMake(([GUILayout GetMainUIWidth]-sbw)/2.0, 0, sbw, sbh);
        //}
    }
    [m_StatusBar setFrame:sbrt];
    [m_StatusBar UpdateSubViewsOrientation];
    
    m_Spinner.center = CGPointMake([GUILayout GetContentViewWidth]/2, [GUILayout GetContentViewHeight]/2);
    int nCount = [self.subviews count];
    for(int i = 0; i < nCount; ++i)
    {
        id pSubView = [self.subviews objectAtIndex:i];
        if(pSubView && [pSubView isKindOfClass:[CustomModalAlertBackgroundView class]] && [pSubView respondsToSelector:@selector(UpdateSubViewsOrientation)])
        {
            [pSubView performSelector:@selector(UpdateSubViewsOrientation)];
            //break;
        }
    }
}	
 
-(void)UpdateAdViewsState
{
}	

-(void)OnTimerEvent
{
    if(m_StatusBar.hidden == NO)
    {
        float currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(15 <= currentTime - m_StatusBarStartTime)
        {
            [self HideStatusBar];
        }
    }
    if(m_ConfigureView.hidden == NO)
    {
        [m_ConfigureView OnTimerEvent];
    }
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if([ApplicationConfigure GetAdViewsState])
        {
            [m_HouseAdView OnTimerEvent];
            if([m_ExtendAdView IsDisplay] == YES)
            {
                [m_ExtendAdView OnTimerEvent];
            }
        }    
        [m_GameView onTimerEvent:self];
    }
    else
    {    
        if([ApplicationConfigure GetAdViewsState])
        {
            [m_AdViewBottom OnTimerEvent];
            [m_HouseAdView OnTimerEvent];
            if([m_ExtendAdView IsDisplay] == YES)
            {
                [m_ExtendAdView OnTimerEvent];
            }
            if(isDisplayAD() == 1)
            {    
                if(m_bFlashAdShowing == NO)
                {
                    //if([m_GameView GameOverPresentationDone])
                    //{
                        [self ShowFlashAdView];
                    //}
                }
                else
                {
                    ++m_nFlashAdDisplayCount; 
                    if(MAX_FALSHADDISPLAY < m_nFlashAdDisplayCount)
                    {
                        [self HideFlashAdView];
                        setGamePlayState(GAME_PLAY_READY);
                        [GUIEventLoop SendEvent:GUIID_EVENT_RESETGAME eventSender:nil];
                    }
                }
            }   
        }
        [m_GameView onTimerEvent:self];
    }    
}	

- (void)dealloc 
{
    [m_GameView stopGame];
//    [m_GameView release];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	CGImageRelease(m_ProtraitCheckerImage);
	CGImageRelease(m_LandscapeCheckerImage);
    [m_Spinner release];
    [super dealloc];
}

-(void)OnOpenConfigureView:(id)sender
{
	[m_ConfigureView OpenView:YES];
}

-(void)OnOpenScoreView:(id)sender
{
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        NSString *snString = [StringFactory GetString_Me]; 
        NSString *gkstring = @"Game Center";
        int nRet = [CustomModalAlertView Ask:nil withButton1:snString withButton2:gkstring]; 
        if(nRet == 0)
        {
            [m_ScoreView OpenView:YES];
        }
        else
        {
            NSString *achieveString = @"Achievement"; 
            NSString *LeaderString = @"LeaderBoard";
            int nSel = [CustomModalAlertView Ask:nil withButton1:LeaderString withButton2:achieveString]; 
            if(nSel == 0)
                [m_LeaderBoardView OpenView:YES];
            else
                [m_AchievementView OpenView:YES];
        }
    }
    else
    {    
        [m_ScoreView OpenView:YES];
    }    
}


-(void)OnOpenScorePostView
{
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        NSString *snString = [StringFactory GetString_SocialNetwork]; 
        NSString *gkstring = @"Game Center";
        //NSArray *buttons = [NSArray arrayWithObjects:snString, gkstring, nil];
        //int nRet = [ModalAlert ask:nil withCancel:nil withButtons:buttons];
        int nRet = [CustomModalAlertView Ask:nil withButton1:snString withButton2:gkstring]; 
        if(nRet == 0)
        {
            [m_ShareView OpenView:YES];
        }
        else
        {
            //NSString *achieveString = @"吹牛成就";//@"Achievement"; 
            //NSString *LeaderString = @"吹牛排行榜";//@"LeaderBoard";
            //NSArray *selButtons = [NSArray arrayWithObjects:LeaderString, achieveString, nil];
            //int nSel = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:selButtons];
            //if(nSel == 1)
                [m_GameCenterPostView OpenView:YES];
            //else if(nSel == 2)
            //    [m_AchievementPostView OpenView:YES];
            
        }
    } 
    else
    {    
        [m_ShareView OpenView:YES];
    }    
}	

-(void)OnPostTellFriendByEmail
{
    ApplicationController* pAppController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pAppController && [ApplicationConfigure CanSendEmail])
    {
        [pAppController SendTellFriendsEmail];
    }
    else 
    {
        NSString* str = @"Cannot send E-mail from your device，please try later！";
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
}

-(void)OnPostTellFriendBySMS
{
    ApplicationController* pAppController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pAppController && [ApplicationConfigure CanSendTextMessage])
    {
        [pAppController SendTellFriendsMessage];
    }
    else 
    {
        NSString* str = @"Cannot send text message from your device，please try later！";
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
}

-(void)OnPostTellFriendOnFacebook
{
    ApplicationController* pAppController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pAppController)
    {
        [pAppController SendTellFriendsFacebook];
    }
}

-(void)OnPostTellFriendOnTwitter
{
    ApplicationController* pAppController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pAppController )//&& [ApplicationConfigure CanSendTweet])
    {
        [pAppController SendTellFriendsTwitter];
    }
    else 
    {
        NSString* str = @"Cannot send Twitter message from your device，please try later！";
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
}


-(void)OnOpenTellFriendsView
{
    NSString* strFacebook = @"Facebook";//[StringFactory GetString_Email];
    NSString* strTwitter = @"Twitter";//[StringFactory GetString_SMS];
    NSString* strEmail = [StringFactory GetString_Email];
    NSString* strIM = [StringFactory GetString_SMS];
    
    
    NSMutableArray *buttons = [[[NSMutableArray alloc] init] autorelease];
    [buttons addObject:strFacebook];
    [buttons addObject:strTwitter];
    [buttons addObject:strEmail]; 
    [buttons addObject:strIM];
    
    int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:nil withChoice:buttons];
    
    if(nAnswer == 1)
    {
        [self OnPostTellFriendOnFacebook];
    }
    else if(nAnswer == 2)
    {
        [self OnPostTellFriendOnTwitter];
    }
    else if(nAnswer == 3)
    {
        [self OnPostTellFriendByEmail];
    }
    else if(nAnswer == 4)
    {
        [self OnPostTellFriendBySMS];
    }
}

-(void)OnOpenShareView:(id)sender
{
    NSString* strTellFriend = [StringFactory GetString_TellFriends];
    NSString* strPostScore = [StringFactory GetString_PostScore];
    
    NSMutableArray *buttons = [[[NSMutableArray alloc] init] autorelease];
    [buttons addObject:strTellFriend]; 
    [buttons addObject:strPostScore];
    
    int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
    
    if(nAnswer == 1)
    {
        [self OnOpenTellFriendsView];
    }
    else if(nAnswer == 2)
    {
        [self OnOpenScorePostView];
    }
}	

-(void)ResumeAds
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        if(m_AdFlashView.hidden == NO)
            [m_AdFlashView ResumeAd];
        
        [m_AdViewBottom ResumeAd];
    }    
}

-(void)PauseAds
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        [m_AdFlashView PauseAd];
        [m_AdViewBottom PauseAd];
    }    
}

-(void)DelayLoadAds
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        m_bAdsLoad = YES;
        float w = [GUILayout GetMainUIWidth];
        float h = [GUILayout GetMainUIHeight];
        float ah = [GUILayout GetAdBannerHeight];
        float aw = [GUILayout GetAdBannerWidth];
        CGRect rt = CGRectMake((w-aw)/2.0, h-ah, aw, ah);
        m_AdViewBottom = [[AdBannerHostView alloc] initWithFrame:rt];
        [m_AdViewBottom RegisterDelegate:(id<AdRequestHandlerDelegate>)[GUILayout GetMainViewController]];
        [m_AdViewBottom SetAlertMessage:[StringFactory GetString_NetworkWarn]];
        [self addSubview:m_AdViewBottom];
        [m_AdViewBottom release];
        [m_AdViewBottom Start];
        
        
        
        m_AdFlashView = [[RedeemClickAdHostView alloc] initWithFrame:CGRectMake(0, 0, [GUILayout GetRedeemAdViewWidth], [GUILayout GetRedeemAdViewHeight])];
        float cx = [GUILayout GetMainUIWidth]*0.5;
        float cy = [GUILayout GetMainUIHeight]*0.5;
        [m_AdFlashView setCenter:CGPointMake(cx, cy)];
        [m_AdFlashView RegisterDelegate:(id<AdRequestHandlerDelegate>)[GUILayout GetMainViewController]];
        [m_AdFlashView StartShowAd];
        m_AdFlashView.hidden = YES;
        [self addSubview:m_AdFlashView];
        [self sendSubviewToBack:m_AdFlashView];
        [m_AdFlashView release];
        float evw = [GUILayout GetDefaultExtendAdViewWidth];
        float evh = [GUILayout GetDefaultExtendAdViewHeight];
        rt = CGRectMake(([GUILayout GetContentViewWidth]-evw)/2.0, ([GUILayout GetContentViewHeight]-evh)/2.0, evw, evh);
        m_ExtendAdView = [[ExtendAdView alloc] initWithFrame:rt];
        [self addSubview:m_ExtendAdView];
        [m_ExtendAdView release];
        m_ExtendAdView.hidden = YES;
        float fSize = [GUILayout GetHouseAdViewSize];
        rt = CGRectMake(([GUILayout GetContentViewWidth]-fSize)/2.0, [GUILayout GetContentViewHeight], fSize, fSize);
        m_HouseAdView = [[HouseAdHostView alloc] initWithFrame:rt];
        [self addSubview:m_HouseAdView];
        [m_HouseAdView release];
    }
}    

-(void)ShowSpinner
{
    [self bringSubviewToFront:m_Spinner];
    m_Spinner.hidden = NO;
    [m_Spinner sizeToFit];
    [m_Spinner startAnimating];
    m_Spinner.center = CGPointMake([GUILayout GetContentViewWidth]/2, [GUILayout GetContentViewHeight]/2);
}

-(void)HideSpinner
{
    [m_Spinner stopAnimating];
    m_Spinner.hidden = YES;
}

-(void)ShowFlashAdView
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        return;
    }
    
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        //[self ShowSpinner];
        m_bFlashAdShowing = YES;
        m_AdFlashView.hidden = NO;
        [m_AdFlashView StartShowAd];
        [self bringSubviewToFront:m_AdFlashView];
        m_nFlashAdDisplayCount = 0;    
    }
}

-(void)HideFlashAdView
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        [self HideSpinner];
        m_bFlashAdShowing = NO;
        [m_AdFlashView StopShowAd];
        m_AdFlashView.hidden = YES;
        [self sendSubviewToBack:m_AdFlashView];
        m_nFlashAdDisplayCount = 0;
        setDisplayAD(0);
        //[m_GameView startGame];
        setGamePlayState(GAME_PLAY_READY);
        [GUIEventLoop SendEvent:GUIID_EVENT_RESETGAME eventSender:nil];
    }
}

-(void)OneFuldlScreenAdDone:(id)sender
{
    if([ApplicationConfigure GetAdViewsState] == YES && (m_bFlashAdShowing == YES || isDisplayAD() == 1))
    {
        [self HideSpinner];
        m_bFlashAdShowing = NO;
        m_AdFlashView.hidden = YES;
        [m_AdFlashView StopShowAd];
        [self sendSubviewToBack:m_AdFlashView];
        m_nFlashAdDisplayCount = 0;  
        setDisplayAD(0);
        //[m_GameView startGame];
        setGamePlayState(GAME_PLAY_READY);
        [GUIEventLoop SendEvent:GUIID_EVENT_RESETGAME eventSender:nil];
    }
}

//#define TEST_BUYIT

-(void)OnPurchase:(id)sender
{
    //#ifdef TEST_BUYIT
    //    [self SwitchToPaidVersion];
    //#endif
    [self BuyAction];
}

- (void) doLog: (NSString *) formatstring, ...
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	NSString *outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
	[self.log appendString:outstring];
	[self.log appendString:@"\n"];
	NSLog(@"%@", self.log);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	[self doLog:@"Error: Could not contact App Store properly, %@", [error localizedDescription]];
	NSString* str = [NSString stringWithFormat:@"Error(Could not contact App Store properly): %@", [error localizedDescription]];
	//[ModalAlert say:str];
    [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
	//m_Scores.m_bPaid = 0;
	//g_bContiuneBuy = NO;
}

- (void)requestDidFinish:(SKRequest *)request
{
	// Release the request
	[request release];
	[self doLog:@"Request finished."];
	//if(g_bContiuneBuy == YES)
	//{	
	//	if(m_Scores.m_bPaid == 1)
	//		[self SwitchToPaidVersion];
	//	[self doLog:@"SwitchToPaidVersion."];
	//}
	//g_bContiuneBuy = NO;
}

- (void) repurchase
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	SKProduct *product = [[response products] lastObject];
	if (!product)
	{
		[self doLog:@"Error retrieving product information from App Store. Sorry! Please try again later."];
		return;
	}
	
	// Retrieve the localized price
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:product.priceLocale];
	NSString *formattedString = [numberFormatter stringFromNumber:product.price];
	[numberFormatter release];
	
	// Create a description that gives a heads up about 
	// a non-consumable purchase
	NSString *buyString = formattedString; 
	NSString *describeString = [NSString stringWithFormat:@"%@\n\n%@.", product.localizedDescription, [StringFactory GetString_BuyConfirm]];
	NSArray *buttons = [NSArray arrayWithObject: buyString];
	
	// Offer the user a choice to buy or not buy
//	if ([ModalAlert ask:describeString withCancel:[StringFactory GetString_NoThanks] withButtons:buttons])
    if ([CustomModalAlertView Ask:describeString withButton1:[StringFactory GetString_NoThanks] withButton2:buyString] == ALERT_OK)
	{
		// Purchase the item
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:PRODUCT_ID]; 
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
}

#pragma mark payments
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
}

- (void) completedPurchaseTransaction: (SKPaymentTransaction *) transaction
{
	// PERFORM THE SUCCESS ACTION THAT UNLOCKS THE FEATURE HERE
	
	// Check the receipt
	NSString *json = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}", [transaction.transactionReceipt base64Encoding]];
	NSString *urlsting = SANDBOX ? @"https://sandbox.itunes.apple.com/verifyReceipt" : @"https://buy.itunes.apple.com/verifyReceipt";
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlsting]];
	if (!urlRequest)
	{	
		// Finish transaction
		[[SKPaymentQueue defaultQueue] finishTransaction: transaction]; // do not call until you are actually finished
		NOTIFY_AND_LEAVE(@"Error creating the URL Request");
	}
	
	[urlRequest setHTTPMethod: @"POST"];
	[urlRequest setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSError *error;
	NSURLResponse *response;
	NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
	if(!result)
	{
		// Finish transaction
		[[SKPaymentQueue defaultQueue] finishTransaction: transaction]; // do not call until you are actually finished
		NOTIFY_AND_LEAVE(@"Error querying the recipt from Appstore server");
	}
    
	//if(SANDBOX == YES)
	//{	
	//	NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
	//	CFShow(resultString);
	//	[resultString release];
	//}
	
	NSDictionary* reciptData = [[CJSONDeserializer deserializer] deserialize:result error:&error];
	if(!reciptData)
	{
		// Finish transaction
		[[SKPaymentQueue defaultQueue] finishTransaction: transaction]; // do not call until you are actually finished
		NOTIFY_AND_LEAVE(@"Recipt data is invalid");
	}	
	else
	{
		NSNumber* rid = [reciptData valueForKey:@"status"];
		if(rid && [rid intValue] == 0)
		{
			[self doLog:@"Recipte is valid."];
			[self SwitchToPaidVersion];
			
		}
		else
		{
			// Finish transaction
			[[SKPaymentQueue defaultQueue] finishTransaction: transaction]; // do not call until you are actually finished
			NOTIFY_AND_LEAVE(@"Recipte data block is invalid");
		}	
	}
	
	// Finish transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction]; // do not call until you are actually finished
	[self doLog:@"Recipte is checked."];
}

- (void) handleFailedTransaction: (SKPaymentTransaction *) transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self doLog:[StringFactory GetString_BuyFailure]];
}

/*- (void)CheckPaymentForPurchase:(SKPaymentTransaction *) transaction
 {
 if(transaction != nil && transaction.payment != nil && transaction.payment.productIdentifier != nil)
 {
 NSComparisonResult result;
 
 result = [transaction.payment.productIdentifier compare:PRODUCT_ID];		
 if(result == NSOrderedSame)
 {
 [self SwitchToPaidVersion];
 m_Scores.m_bPaid = 1;
 }	
 }	
 }*/	

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions 
{
	for (SKPaymentTransaction *transaction in transactions) 
	{
		switch (transaction.transactionState) 
		{
			case SKPaymentTransactionStatePurchased: 
				[self doLog:@"SKPaymentTransactionStatePurchased"];
				//[self CheckPaymentForPurchase:transaction];
				//if(SANDBOX == YES)
				[self completedPurchaseTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self doLog:@"SKPaymentTransactionStateRestored"];
				//[self CheckPaymentForPurchase:transaction];
				//if(SANDBOX == YES)
				[self completedPurchaseTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed: 
				[self doLog:@"SKPaymentTransactionStateFailed"];
				[self handleFailedTransaction:transaction]; 
				break;
			case SKPaymentTransactionStatePurchasing:
				//[self repurchase];
				[self doLog:@"SKPaymentTransactionStatePurchasing"];
				break;
			default: 
			    NSLog(@"Other transaction");
				break;
		}
	}
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    if([ApplicationConfigure GetAdViewsState])
    {
        [self SwitchToPaidVersion];
    }
}

- (void)BuyAction
{
    if([ApplicationConfigure IsOnSimulator])
    {
        if ([CustomModalAlertView Ask:[StringFactory GetString_AskString] withButton1:[StringFactory GetString_NoThanks] withButton2:[StringFactory GetString_Purchase]] == ALERT_OK)
        {
            [self SwitchToPaidVersion];
        }
    }
    else
    {    
        if([SKPaymentQueue canMakePayments])
        {	
            // Create the product request and start it
            //NSArray *buttons = [NSArray arrayWithObject: [StringFactory GetString_Purchase]];
            
            NSString *buyString = [StringFactory GetString_Purchase];
            NSString *restoreString = [StringFactory GetString_RestorePurchase];
            NSArray *buttons = [NSArray arrayWithObjects:buyString, restoreString, nil];
            int nAnswer = [CustomModalAlertView MultChoice:[StringFactory GetString_AskString] withCancel:[StringFactory GetString_NoThanks] withChoice:buttons];
            
            if(nAnswer == 1)
            {
                self.log = [NSMutableString string];
                [self doLog:@"Submitting Request... Please wait."];
                SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCT_ID]];
                preq.delegate = self;
                [preq start];
            }
            else if(nAnswer == 2)
            {
                [self repurchase];
            }
            
            
            //if ([ModalAlert ask:[StringFactory GetString_AskString] withCancel:[StringFactory GetString_NoThanks] withButtons:buttons])
            /*if ([CustomModalAlertView Ask:[StringFactory GetString_AskString] withButton1:[StringFactory GetString_NoThanks] withButton2:[StringFactory GetString_Purchase]] == ALERT_OK)
             {
             self.log = [NSMutableString string];
             [self doLog:@"Submitting Request... Please wait."];
             SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCT_ID]];
             preq.delegate = self;
             [preq start];
             }*/
        }
        else
        {
//            [ModalAlert say:[StringFactory GetString_CannotPayment]];
            [CustomModalAlertView SimpleSay:[StringFactory GetString_CannotPayment] closeButton:[StringFactory GetString_Close]];
        }
    } 
}

- (void)RemoveBuyitButton
{
    [m_GameView RemovePurchaseButton];
}

- (void)ShutDownAdViews
{
    [m_AdFlashView StopShowAd];
    //[m_AdFlashView removeFromSuperview];
    //m_AdFlashView = nil;
    [self sendSubviewToBack: m_AdFlashView];
    m_AdFlashView.hidden = YES;
    
    [m_AdViewBottom PauseAd];    
    //[m_AdViewBottom removeFromSuperview];    
    //m_AdViewBottom = nil; 
    [self sendSubviewToBack:m_AdViewBottom];    
    m_AdViewBottom.hidden = YES; 
    
    if(m_ExtendAdView != nil)
    {
        [m_ExtendAdView removeFromSuperview];
        m_ExtendAdView = nil;
    }
    if(m_HouseAdView != nil)
    {
        [m_HouseAdView removeFromSuperview];
        m_HouseAdView = nil;
    }
}	

- (void)SwitchToPaidVersion
{
    [ApplicationConfigure SetAdViewsState:NO];
    [ScoreRecord SavePaidState];
	[self RemoveBuyitButton];
	[self ShutDownAdViews];
    [self UpdateSubViewsOrientation];
}

-(void)OnLobbyStartedEvent
{
    if(m_GameView != nil)
    {
        [m_GameView OnLobbyStartedEvent];
    }
    if([ApplicationConfigure GetAdViewsState] && isDisplayAD() == 1)
    {
        [self HideFlashAdView];
    }
    
    [self setNeedsDisplay];
}

-(void)ResetCurrentPlayingGame
{
    if(m_GameView != nil)
    {
        [m_GameView ResetCurrentPlayingGame];
    }
    [self setNeedsDisplay];
}

-(void)StartLobbyGame
{
    if(m_GameView != nil)
    {
        [m_GameView startGame];
    }
    [self setNeedsDisplay];    
}

- (void)EnableLobbyUI:(BOOL)bEnable
{
    if(m_GameView != nil)
    {
        [m_GameView EnableLobbyUI:bEnable];
    }
    [self setNeedsDisplay];
}

- (void)ShowLobbyControls:(BOOL)bShow
{
    if(m_GameView != nil)
    {
        [m_GameView ShowLobbyControls:bShow];
    }
    [self setNeedsDisplay];
}

- (void)HandleDebugMsg:(NSString*)msg
{
    if(m_GameView != nil)
    {
        [m_GameView HandleDebugMsg:msg];
    }
}

- (void)AddPlayerAvatarInLobby:(NSString*)playerID withName:(NSString*)szName
{
    if(m_GameView != nil)
    {
        [m_GameView AddPlayerAvatarInLobby:playerID withName:szName];
    }
}

- (void)RemovePlayerAvatarFromLobby:(NSString*)playerID
{
    if(m_GameView != nil)
    {
        [m_GameView RemovePlayerAvatarFromLobby:playerID];
    }
    [self setNeedsDisplay];
}

- (void)ShowTextMessage:(NSString*)szText from:(NSString*)playerID
{
    if(m_GameView != nil)
    {
        [m_GameView ShowTextMessage:szText from:playerID];
    }
    [self setNeedsDisplay];
}

- (void)PlayerStartWriteTextMessage:(NSString*)playerID
{
    if(m_GameView != nil)
    {
        [m_GameView PlayerStartWriteTextMessage:playerID];
    }
    [self setNeedsDisplay];
}

- (void)PlayerStartTalking:(NSString*)playerID
{
    if(m_GameView != nil)
    {
        [m_GameView PlayerStartTalking:playerID];
    }
    [self setNeedsDisplay];
}

- (void)PlayerStopTalking:(NSString*)playerID
{
    if(m_GameView != nil)
    {
        [m_GameView PlayerStopTalking:playerID];
    }
    [self setNeedsDisplay];
}

- (BOOL)SetPlayerAvatarAsMaster:(NSString*)playerID
{
    BOOL bRet = NO;
    if(m_GameView != nil)
    {
        bRet = [m_GameView SetPlayerAvatarAsMaster:playerID];
        [self setNeedsDisplay];
    }
    return bRet;
}

- (BOOL)SetPlayerAvatarHighLight:(NSString*)playerID
{
    BOOL bRet = NO;
    if(m_GameView != nil)
    {
        bRet = [m_GameView SetPlayerAvatarHighLight:playerID];
        [self setNeedsDisplay];
    }    
    return bRet;
}

- (BOOL)IsPlayerAvatarHighLight:(NSString*)playerID
{
    if(m_GameView != nil)
    {
        return [m_GameView IsPlayerAvatarHighLight:playerID];
    }    
    return NO;
}

- (BOOL)HasAvatar
{
    if(m_GameView != nil)
    {
        return [m_GameView HasAvatar];
    }    
    return NO;
}

- (void)UpdateActivePlayerScore
{
    if(m_GameView != nil)
    {
        [m_GameView UpdateActivePlayerScore];
    }
}

- (void)SetPlayerBestScore:(NSString*)playerID withScore:(int)nBest
{
    if(m_GameView != nil)
    {
        [m_GameView SetPlayerBestScore:playerID withScore:nBest];
    }
}

- (void)SetGamePlayerResult:(NSString*)playerID withResult:(int)nResult
{
    if(m_GameView != nil)
    {
        [m_GameView SetGamePlayerResult:playerID withResult:nResult];
    }
}

- (void)GameConfigureChange
{
    if(m_GameView != nil)
    {
        [m_GameView resetGame];
        [m_GameView setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

- (void)HandleAdRequest:(NSURL*)url
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        /*if([ApplicationConfigure CanLaunchHouseAd] == YES && IsGameRunning() != 1)
        {
            [m_ExtendAdView DisableCornerShow];
            float evw = [GUILayout GetDefaultExtendAdViewWidth];
            float evh = [GUILayout GetDefaultExtendAdViewHeight];
            CGRect rt = CGRectMake(([GUILayout GetContentViewWidth]-evw)/2.0, ([GUILayout GetContentViewHeight]-evh)/2.0, evw, evh);
            [m_ExtendAdView setFrame:rt];
            [m_ExtendAdView UpdateViewLayout];
        }
        else*/
        //{
            [m_ExtendAdView SetCornerShow];
            float w = [GUILayout GetExtendAdViewCornerWidth];
            float h = [GUILayout GetExtendAdViewCornerWidth];
            float sx = ([GUILayout GetMainUIWidth] -w)/2.0;
            float sy = [GUILayout GetContentViewHeight];
            CGRect rt = CGRectMake(sx, sy, w, h);
            [m_ExtendAdView setFrame:rt];
            [m_ExtendAdView UpdateViewLayout];
        //}
        [m_ExtendAdView OpenWebPage:url withAnimation:YES];
    }
}

- (void)AdViewClicked
{
    
}

- (void)DismissExtendAdView
{
    
}

- (void)InterstitialAdViewClicked
{
    [self HideFlashAdView];
}

- (void)CloseRedeemAdView
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        if(m_AdFlashView.hidden == NO)
        {
            m_AdFlashView.hidden = YES;
            [self sendSubviewToBack:m_AdFlashView];
        }
    }
}

- (BOOL)IsMySelfActive
{
    return [m_GameView IsMySelfActive];
}

- (BOOL)IsPlayer1Active
{
    return [m_GameView IsPlayer1Active];
}

- (BOOL)IsPlayer2Active
{
    return [m_GameView IsPlayer2Active];
}

- (BOOL)IsPlayer3Active
{
    return [m_GameView IsPlayer3Active];
}

- (NSString*)GetMyPlayerID
{
    return [m_GameView GetMyPlayerID];
}

- (NSString*)GetPlayer1PlayerID
{
    return [m_GameView GetPlayer1PlayerID];
}

- (NSString*)GetPlayer2PlayerID
{
    return [m_GameView GetPlayer2PlayerID];
}

- (NSString*)GetPlayer3PlayerID
{
    return [m_GameView GetPlayer3PlayerID];
}

- (int)NomiateGKCenterMasterInPeerToPeer
{
    int nRet = -1;
    if(m_GameView != nil)
    {
        nRet = [m_GameView NomiateGKCenterMasterInPeerToPeer];
    }
    return nRet;
}

- (void)StartNewLobbyGame
{
    if(m_GameView != nil)
    {
        [m_GameView StartNewLobbyGame];
    }
}

-(void)ShowStatusBar:(NSString*)text
{
    if(m_StatusBar == nil)
        return;
    
    [m_StatusBar SetMessage:text];
    [m_StatusBar Show];
    m_StatusBarStartTime = [[NSProcessInfo processInfo] systemUptime];
}

-(void)HideStatusBar
{
    [m_StatusBar Hide];
}

-(void)OnPostGameWinMessage
{
    int nLevel = [Configuration getGameLevel];
    int nSkill = [Configuration getGameSkill];
    int nTotalScore = [ScoreRecord getTotalWinScore];
    NSString* szGreeting = [StringFactory GetString_Congratulation];
    
    NSString* szText = [NSString stringWithFormat:@"%@ %@：%i",szGreeting, [StringFactory GetString_GameTotalScoreTitle], nTotalScore];
    [self ShowStatusBar:szText];
    if(m_GameView != nil)
        [m_GameView ShowNonPlayingButtons];

    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsAWSMessagerEnabled])
    {
        [pGKDelegate PostAWSWonMessage:nSkill withLevel:nLevel withScore:nTotalScore];
    }
}

-(void)OnPostGameLostMessage
{
    int nLevel = [Configuration getGameLevel];
    int nSkill = [Configuration getGameSkill];
    int nTotalScore = [ScoreRecord getTotalWinScore];
    NSString* szGreeting = @"Oops！";
    
    NSString* szText = [NSString stringWithFormat:@"%@ %@：%i",szGreeting, [StringFactory GetString_GameTotalScoreTitle], nTotalScore];
    [self ShowStatusBar:szText];
    if(m_GameView != nil)
        [m_GameView ShowNonPlayingButtons];
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsAWSMessagerEnabled])
    {
        [pGKDelegate PostAWSLostMessage:nSkill withLevel:nLevel withScore:nTotalScore];
    }
}

-(void)ShowLobbyButton
{
    if(m_GameView != nil)
        [m_GameView ShowLobbyButton];
}

-(void)HideLobbyButton
{
    if(m_GameView != nil)
        [m_GameView HideLobbyButton];
}


-(void)OnOpenFriendView:(id)sender
{
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        [m_FriendView OpenView:YES];
    }
    else
    {
        NSString* str = @"Cannot connect with Game Center，please try later！";
        [self ShowStatusBar:str];
    }
}

-(void)OnOpenHelpView
{
	[m_HelpView OpenView:YES];
}

-(void)OnOpenOnlineGamerStatusView
{
    [m_OnlinePlayerStatusView OpenView:YES];
}

-(void)OnAWSServiceFailed
{
    if([UIDevice networkAvailable] && [ScoreRecord isAWSServiceEnabled] == YES)
    {
        NSString* szText = [StringFactory GetString_AWSServiceFailureMessage];
        [self ShowStatusBar:szText];
    }
}
@end
