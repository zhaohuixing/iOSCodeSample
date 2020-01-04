//
//  ApplicationMainView.m
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 2010-09-05.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "ApplicationMainView.h"
#import "ImageLoader.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
#import "NSData-Base64.h"
#import "UIDevice-Reachability.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "StringFactory.h"
#import "CustomModalAlertView.h"
#import "GameScore.h"
#include "GameUtility.h"
#include "GameState.h"
#import "GameCenterConstant.h"
#import "GameCenterManager.h"
#import "DrawHelper2.h"
#import "RenderHelper.h"
#import "ApplicationController.h"

#define NOTIFY_AND_LEAVE(X) {NSLog(X); return;}

#define PRODUCT_ID	@"com.xgadget.pandacards.paidversion"
#define SANDBOX			NO

#define MAX_FALSHADDISPLAY       15   
#define STATUSBAR_WIDTH             300
#define STATUSBAR_HEIGHT            50

@implementation ApplicationMainView

@synthesize log;

-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate

{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
    NSInteger startDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate:startDate];
    NSInteger endDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate:endDate];
    
    return endDay-startDay;
    
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	NSString* strMsg = [NSString stringWithFormat:@"%@\n%@", title, message];
    [CustomModalAlertView SimpleSay:strMsg closeButton:[StringFactory GetString_Close]];
}

- (void)SetCurrentTime
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:@"MM"];
	int month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter setDateFormat:@"dd"];
	int day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter setDateFormat:@"yyyy"];
	int year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter release];
	SetTodayDate(year, month, day);
}	


- (void)CheckPurchaseState
{
	//m_bFreeVersion = YES;
	//SetProductFree();
	
}	

- (BOOL)IsFreeOnlineADVersion
{
	//return m_bFreeVersion;
	BOOL bRet = YES;
	if([GameScore CheckPaymentState])
		bRet = NO;
	
	return bRet;
}	

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        m_RedeemAdView = nil;
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
		m_LandscapeCheckerImage = [ImageLoader CreateLandScapeBKImage];
		m_ProtraitCheckerImage = [ImageLoader CreateProtraitBKImage];
       m_bFlashAdShowing = FALSE;
	}
	
	return self;
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawBlueBackground:(CGContextRef)context inRect:(CGRect)rect
{
    [DrawHelper2 DrawBlueTextureRect:context at:rect];
}

- (void)drawYellowBackground:(CGContextRef)context inRect:(CGRect)rect
{
    float fAlpha = 1.0;
    [RenderHelper DrawNumericPatternFill:context withAlpha:fAlpha atRect:rect];
}

- (void)drawRedBackground:(CGContextRef)context inRect:(CGRect)rect
{
    [DrawHelper2 DrawRedTextureRect:context at:rect];
}

- (void)drawCheckerBackground:(CGContextRef)context inRect:(CGRect)rect
{
	if([GUILayout IsProtrait])
		CGContextDrawImage(context, rect, m_ProtraitCheckerImage);
	else
		CGContextDrawImage(context, rect, m_LandscapeCheckerImage);
}

- (void)drawGreenBackground:(CGContextRef)context inRect:(CGRect)rect
{
    float fAlpha = 1.0;
    [RenderHelper DrawGreenPatternFill:context withAlpha:fAlpha atRect:rect];
}

- (void)drawWoodTextureBackground:(CGContextRef)context inRect:(CGRect)rect
{
    float fAlpha = 1.0;
    [RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
    
    int n = GetGameBackground();
    if(n == GAME_BACKGROUND_GREEN)
        [self drawGreenBackground:context inRect:rect];
    else if(n == GAME_BACKGROUND_BLUE)
        [self drawBlueBackground:context inRect:rect];
    else if(n == GAME_BACKGROUND_YELLOW)
        [self drawYellowBackground:context inRect:rect];
    else if(n == GAME_BACKGROUND_RED)
        [self drawRedBackground:context inRect:rect];
    else if(n == GAME_BACKGROUND_CHECKER)
        [self drawCheckerBackground:context inRect:rect];
    else if(n == GAME_BACKGROUND_WOOD)
        [self drawWoodTextureBackground:context inRect:rect];
	
	CGContextRestoreGState(context);
}

-(void)InitSubViews
{
    float h = [GUILayout GetMainUIHeight];
    float w = [GUILayout GetMainUIWidth];
	CGRect rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);
	
	m_PointsView = [[PointsView alloc] initWithFrame:rect];
	[self addSubview:m_PointsView];
	[m_PointsView release];
	m_PointsView.hidden = YES;
	
	m_ScoreView = [[ScoreView alloc] initWithFrame:rect];
	[self addSubview:m_ScoreView];
	[m_ScoreView release];
	m_ScoreView.hidden = YES;

	
	m_ShareView = [[SNSShareView alloc] initWithFrame:rect];
	[self addSubview:m_ShareView];
	[m_ShareView release];
	m_ShareView.hidden = YES;
    
    m_StatusBar = [[CustomDummyAlertView alloc] initWithFrame:CGRectMake((w-STATUSBAR_WIDTH)/2.0, [GUILayout GetContentViewHeight]-STATUSBAR_HEIGHT, STATUSBAR_WIDTH, STATUSBAR_HEIGHT)];
    [self addSubview:m_StatusBar];
    [m_StatusBar release];
    [m_StatusBar Hide];
    [m_StatusBar SetMultiLineText:NO];
    m_StatusBarStartTime = [[NSProcessInfo processInfo] systemUptime];

    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        float ah = [GUILayout GetAdBannerHeight];
        float aw = [GUILayout GetAdBannerWidth];
        CGRect rt = CGRectMake((w-aw)/2.0, h-ah, aw, ah);
        m_AdViewBottom = [[AdBannerHostView alloc] initWithFrame:rt];
        [m_AdViewBottom RegisterDelegate:(id<AdRequestHandlerDelegate>)[GUILayout GetMainViewController]];
        [m_AdViewBottom SetAlertMessage:[StringFactory GetString_NetworkWarn]];
        [self addSubview:m_AdViewBottom];
        [m_AdViewBottom release];
        [m_AdViewBottom Start];
        
        m_BuyitAlertView = [[CustomDummyClickView alloc] initWithFrame:rt]; 
        [self addSubview:m_BuyitAlertView];
        [self sendSubviewToBack:m_BuyitAlertView];
        m_BuyitAlertView.hidden = YES;    
        [m_BuyitAlertView SetEventID:GUIID_EVENT_PURCHASE];
        [m_BuyitAlertView SetMessage:[StringFactory GetString_BuyItSuggestion]];
        [m_BuyitAlertView SetMultiLineText:YES];
        [m_BuyitAlertView SetButtonString:[StringFactory GetString_BuyIt]];
        [m_BuyitAlertView release];
        
        
        float evw = [GUILayout GetDefaultExtendAdViewWidth];
        float evh = [GUILayout GetDefaultExtendAdViewHeight];
        rt = CGRectMake(([GUILayout GetContentViewWidth]-evw)/2.0, [GUILayout GetContentViewHeight], evw, evh);
        m_ExtendAdView = [[ExtendAdView alloc] initWithFrame:rt];
        [self addSubview:m_ExtendAdView];
        [m_ExtendAdView release];
        m_ExtendAdView.hidden = YES;
        float fSize = [GUILayout GetHouseAdViewSize];
        rt = CGRectMake(([GUILayout GetContentViewWidth]-fSize)/2.0, [GUILayout GetContentViewHeight], fSize, fSize);
        m_HouseAdView = [[HouseAdHostView alloc] initWithFrame:rt];
        [self addSubview:m_HouseAdView];
        [m_HouseAdView release];
        [self bringSubviewToFront:m_HouseAdView];
        float rw = [GUILayout GetRedeemAdViewWidth];
        float rh = [GUILayout GetRedeemAdViewHeight];
        rt = CGRectMake((w-rw)/2.0, (h-rh)/2.0, rw, rh);
        m_RedeemAdView = [[RedeemClickAdHostView alloc] initWithFrame:rt];
        [m_RedeemAdView RegisterDelegate:(id<AdRequestHandlerDelegate>)[GUILayout GetMainViewController]];
        [m_RedeemAdView StartShowAd];
        [self addSubview:m_RedeemAdView];
        [m_RedeemAdView release];
        m_RedeemAdView.hidden = YES;
        [self sendSubviewToBack:m_RedeemAdView];
    }
    
	m_LeaderBoardView = [[LeaderBoardSelectView alloc] initWithFrame:rect];
	[self addSubview:m_LeaderBoardView];
	[m_LeaderBoardView release];
	m_LeaderBoardView.hidden = YES;
	
    m_GameCenterPostView = [[GameCenterPostView alloc] initWithFrame:rect];
	[self addSubview:m_GameCenterPostView];
	[m_GameCenterPostView release];
	m_GameCenterPostView.hidden = YES;
    
    //m_AchievementPostView = [[AchievementPostView alloc] initWithFrame:rect];
	//[self addSubview:m_AchievementPostView];
	//[m_AchievementPostView release];
	//m_AchievementPostView.hidden = YES;
    m_FriendView = [[FriendView alloc] initWithFrame:rect];
    [self addSubview:m_FriendView];
    [m_FriendView release];
    m_FriendView.hidden = YES;
    
    m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:m_Spinner];
	
    m_GameView = [[GameView alloc] initWithFrame:rect];
	[self addSubview:m_GameView];
	[m_GameView release];
	[m_GameView UpdateGameViewLayout];
	[m_GameView StartNewGame];
	
	
	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENCONFIGUREVIEW eventHandler:@selector(OnOpenConfigureView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENSCOREVIEW eventHandler:@selector(OnOpenScoreView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENSHAREVIEW eventHandler:@selector(OnOpenShareView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_PURCHASE eventHandler:@selector(OnPurchase:) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OPENREDEEMVIEWFORONLINEGAME eventHandler:@selector(OnOpenRedeemViewForOnlineGame) eventReceiver:self eventSender:nil];

	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENPURCHASEALERT eventHandler:@selector(OnOpenBuyitSuggest:) eventReceiver:self eventSender:nil];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_CLOSEPURCHASEALERT eventHandler:@selector(OnCloseBuyitSuggest:) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_OPENFRIENDVIEW eventHandler:@selector(OnOpenFriendView:) eventReceiver:self eventSender:m_GameView];
    [GUIEventLoop RegisterEvent:GUIID_POSTEDONSOICALNETWORK eventHandler:@selector(OnSNPostDone) eventReceiver:self eventSender:nil];
    
    [self UpdateSubViewsOrientation];
}	

-(void)UpdateSubViewsOrientation
{
	CGRect rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight]);
	[m_PointsView setFrame:rect];
	[m_PointsView UpdateViewLayout];
	[m_ScoreView setFrame:rect];
	[m_ScoreView UpdateViewLayout];
	[m_ShareView setFrame:rect];
	[m_ShareView UpdateViewLayout];
    [m_LeaderBoardView setFrame:rect];
    [m_LeaderBoardView UpdateViewLayout];
    [m_GameCenterPostView setFrame:rect];
    [m_GameCenterPostView UpdateViewLayout];
    //[m_AchievementPostView setFrame:rect];
    //[m_AchievementPostView UpdateViewLayout];
    [m_FriendView setFrame:rect];
    [m_FriendView UpdateViewLayout];
    
    [m_StatusBar setFrame:CGRectMake(([GUILayout GetMainUIWidth]-STATUSBAR_WIDTH)/2.0, [GUILayout GetContentViewHeight]-STATUSBAR_HEIGHT, STATUSBAR_WIDTH, STATUSBAR_HEIGHT)];
    [m_StatusBar UpdateSubViewsOrientation];
    
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        float h = [GUILayout GetMainUIHeight];
        float w = [GUILayout GetMainUIWidth];
        float ah = [GUILayout GetAdBannerHeight];
        float aw = [GUILayout GetAdBannerWidth];
        CGRect rt = CGRectMake(([GUILayout GetMainUIWidth]-aw)/2.0, h-ah, aw, ah);
        [m_AdViewBottom setFrame:rt];
   
        [m_BuyitAlertView setFrame:rt];
        [m_BuyitAlertView UpdateSubViewsOrientation];
        
        float rw = [GUILayout GetRedeemAdViewWidth];
        float rh = [GUILayout GetRedeemAdViewHeight];
        rt = CGRectMake((w-rw)/2.0, (h-rh)/2.0, rw, rh);
        [m_RedeemAdView setFrame:rt];
        /*float cx = [GUILayout GetMainUIWidth]*0.5;
         float cy = [GUILayout GetMainUIHeight]*0.5;
         [m_AdFlashView setCenter:CGPointMake(cx, cy)];*/
        w = [GUILayout GetExtendAdViewCornerWidth];
        h = [GUILayout GetExtendAdViewCornerWidth];
        float sx = ([GUILayout GetMainUIWidth] -w)/2.0;
        float sy = [GUILayout GetContentViewHeight];
        rt = CGRectMake(sx, sy, w, h);
        [m_ExtendAdView setFrame:rt];
        [m_ExtendAdView UpdateViewLayout];
        
        float fSize = [GUILayout GetHouseAdViewSize];
        sy = [GUILayout GetMainUIHeight] - fSize;
        rt = CGRectMake(([GUILayout GetMainUIWidth]-fSize)/2.0, sy, fSize, fSize);
        if([GUILayout IsLandscape])
        {
            rt = CGRectMake(([GUILayout GetMainUIWidth]+aw)/2.0, sy, fSize, fSize); 
        }
        [m_HouseAdView setFrame:rt];
        [m_HouseAdView setNeedsDisplay];
        [self bringSubviewToFront:m_HouseAdView];
        [self setNeedsDisplay];
        
    }
	rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);
	[m_GameView setFrame:rect];
	[m_GameView UpdateGameViewLayout];

    if(m_PointsView.hidden == NO)
        [self bringSubviewToFront:m_PointsView];
	
    if(m_ScoreView.hidden == NO)
        [self bringSubviewToFront:m_ScoreView];

    if(m_ShareView.hidden == NO)
        [self bringSubviewToFront:m_ShareView];

    if(m_LeaderBoardView.hidden == NO)
        [self bringSubviewToFront:m_LeaderBoardView];

    if(m_GameCenterPostView.hidden == NO)
        [self bringSubviewToFront:m_GameCenterPostView];

    if(m_FriendView.hidden == NO)
        [self bringSubviewToFront:m_FriendView];
	
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
        [m_GameView OnTimerEvent];
        [super OnTimerEvent];
        return;
    }
    
    if([ApplicationConfigure GetAdViewsState])
    {
        [m_AdViewBottom OnTimerEvent];
        [m_HouseAdView OnTimerEvent];
        if([m_ExtendAdView IsDisplay] == YES)
        {
            [m_ExtendAdView OnTimerEvent];
        }
        if(m_RedeemAdView != nil)
        {    
            if(m_RedeemAdView.hidden == NO)
                [m_RedeemAdView OnTimerEvent];
        }
    }
	[m_GameView OnTimerEvent];
    if(m_PointsView.hidden == NO)
        [m_PointsView OnTimerEvent];
    
    if(m_StatusBar.hidden == NO)
    {
        float currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(15 <= currentTime - m_StatusBarStartTime)
        {
            [self HideStatusBar];
        }
    }
    
    [super OnTimerEvent];
}	

- (void)dealloc 
{
	CGImageRelease(m_ProtraitCheckerImage);
	CGImageRelease(m_LandscapeCheckerImage);
    //CGImageRelease(m_TextureWood);
    [m_Spinner release];
    [super dealloc];
}

-(void)OnOpenConfigureView:(id)sender
{
	[m_PointsView OpenView:YES];
}

-(void)OnOpenScoreView:(id)sender
{
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        NSString *snString = @"Me!"; 
        NSString *gkstring = @"Game Center";
        int nRet = [CustomModalAlertView Ask:nil withButton1:snString withButton2:gkstring]; 
        if(nRet == 0)
        {
            [m_ScoreView OpenView:YES];
        }
        else
        {
            //NSString *achieveString = @"Achievement"; 
            //NSString *LeaderString = @"LeaderBoard";
            //int nSel = [CustomModalAlertView Ask:nil withButton1:LeaderString withButton2:achieveString];
            //if(nSel == 0)
                [m_LeaderBoardView OpenView:YES];
            //else
            //{
            //    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
            //    if(pGKDelegate)
            //    {
            //        [pGKDelegate OpenAchievementViewBoardView:-1];
            //    }
                
            //}
        }
    }
    else
    {    
        [m_ScoreView OpenView:YES];
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

-(void)OnPostTellFriend
{
    NSString* strFacebook = @"Facebook";
    NSString* strTwitter = @"Twitter";
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

-(void)OnOpenScoreShareView
{
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        NSString *snString = [StringFactory GetString_SocialNetwork]; 
        NSString *gkstring = @"Game Center";
        int nRet = [CustomModalAlertView Ask:nil withButton1:snString withButton2:gkstring]; 
        if(nRet == 0)
        {
            [m_ShareView OpenView:YES];
        }
        else
        {
            [m_GameCenterPostView OpenView:YES];
        }
    } 
    else
    {    
        [m_ShareView OpenView:YES];
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
        [self OnPostTellFriend];
    }
    else if(nAnswer == 2)
    {
        [self OnOpenScoreShareView];
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

-(void)ResumeAds
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
//        if(m_AdFlashView.hidden == NO)
//            [m_AdFlashView ResumeAd];
        
        [m_AdViewBottom ResumeAd];
        [self CheckTemporaryPaidFeatureAccess];
    }    
}

-(void)PauseAds
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
//        [m_AdFlashView PauseAd];
        [m_AdViewBottom PauseAd];
    }    
}

/*
-(void)DelayLoadAds
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        m_bAdsLoad = YES;
        float h = [GUILayout GetMainUIHeight];
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
        [m_AdFlashView release];
    }
}*/    

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
    [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    [self HideSpinner];
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
    [self HideSpinner];
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
	
	// Offer the user a choice to buy or not buy
    if ([CustomModalAlertView Ask:describeString withButton1:[StringFactory GetString_NoThanks] withButton2:buyString] == ALERT_OK)
	{
		// Purchase the item
//		SKPayment *payment = [SKPayment paymentWithProductIdentifier:PRODUCT_ID]; 
        SKPayment *payment = [SKPayment paymentWithProduct:product]; 
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
}

#pragma mark payments
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
}

- (void) completedPurchaseTransaction: (SKPaymentTransaction *) transaction
{
    [self HideSpinner];
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
    
	if(SANDBOX == YES)
	{	
		NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
		CFShow(resultString);
		[resultString release];
	}
	
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
    [self HideSpinner];
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
            if ([CustomModalAlertView Ask:[StringFactory GetString_AskString] withButton1:[StringFactory GetString_NoThanks] withButton2:[StringFactory GetString_Purchase]] == ALERT_OK)
            {
                self.log = [NSMutableString string];
                [self doLog:@"Submitting Request... Please wait."];
                SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCT_ID]];
                preq.delegate = self;
                [preq start];
            }
        }
        else
        {
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
//    [m_AdFlashView PauseAd];
//    [m_AdFlashView removeFromSuperview];
    
    [m_AdViewBottom PauseAd];    
    [m_AdViewBottom removeFromSuperview];    
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
    if(m_RedeemAdView != nil)
    {
        [m_RedeemAdView StopShowAd];
        [m_RedeemAdView removeFromSuperview];
        m_RedeemAdView = nil;
    }
}	

- (void)SwitchToPaidVersion
{
    [CustomModalAlertView SimpleSay:[StringFactory GetString_PurchaseDone] closeButton:[StringFactory GetString_Close]];
    
    [GameScore SavePaidState];
    [ApplicationConfigure SetAdViewsState:NO];
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
        [m_GameView LobbyGameStartNewGame];
    }
    [self setNeedsDisplay];    
}

-(void)StartNewGame
{
    if(m_GameView != nil)
    {
        [m_GameView StartNewGame];
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

- (void)AddMyselfAvatarInLobby:(NSString*)playerID withName:(NSString*)szName
{
    if(m_GameView != nil)
    {
        [m_GameView AddMyselfAvatarInLobby:playerID withName:szName];
    }
}

- (void)AddPlayerAvatarInLobby2:(GKPlayer*)player
{
    if(m_GameView != nil)
    {
        [m_GameView AddPlayerAvatarInLobby2:player];
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
        [m_GameView OnPointsChange];
        [m_GameView setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

- (void)SetLobbyGameCardList:(NSArray*)array
{
    if(m_GameView != nil)
    {
        [m_GameView SetLobbyGameCardList:array];
    }
}

- (void)SetGamePlayerWinResult:(NSString*)playerID withResult:(NSArray*)array
{
    if(m_GameView != nil)
    {
        [m_GameView SetGamePlayerWinResult:playerID withResult:array];
    }
}

- (void)SetGamePlayerLoseResult:(NSString*)playerID
{
    if(m_GameView != nil)
    {
        [m_GameView SetGamePlayerLoseResult:playerID];
    }
}

- (void)SetGamePlayerState:(NSString *)playerID withState:(int)nState
{
    if(m_GameView != nil)
    {
        [m_GameView SetGamePlayerState:playerID withState:nState];
    }
}

- (void)HandleLobbyGameNextDeal
{
    if(m_GameView != nil)
    {
        [m_GameView HandleLobbyGameNextDeal];
    }
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
        //[m_ExtendAdView SetCornerShow];
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

- (int)NomiateGKCenterMasterInPeerToPeer
{
    int nRet = -1;
    if(m_GameView != nil)
    {
        nRet = [m_GameView NomiateGKCenterMasterInPeerToPeer];
    }
    return nRet;
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


- (void)OnOpenBuyitSuggest:(id)sender
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        if(m_BuyitAlertView.hidden == YES)
            [m_BuyitAlertView Show];
    }    
}

- (void)OnCloseBuyitSuggest:(id)sender
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        if(m_BuyitAlertView.hidden == NO)
            [m_BuyitAlertView Hide];
    }    
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
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
}

-(void)StopLobbyButtonSpin
{
    if(m_GameView)
        [m_GameView StopLobbyButtonSpin];
}

-(void)OnOpenRedeemViewForOnlineGame
{
    [self HideSpinner];
    if([ApplicationConfigure GetAdViewsState] == YES)
    { 
        NSString* suggestString = [StringFactory GetString_SuggestTemporaryAccess];
        int nRet = [CustomModalAlertView Ask:suggestString withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_OK]]; 
        if(nRet != 0)
        {
            [self OnPostTellFriend];
            return;
        }
        
        if(![StringFactory IsSupportClickRedeem])
            return;
        
        NSString *accessString = [StringFactory GetString_AccessPaidFeature]; 
        nRet = [CustomModalAlertView Ask:accessString withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_OK]]; 
        
        if(nRet == 0)
        {
            return;
        }
        
        if(m_RedeemAdView != nil)
        {    
            m_RedeemAdView.hidden = NO;
            [m_RedeemAdView SetRedeemType:REDEEMTYPE_ONLINE];
            [m_RedeemAdView StartShowAd];
            [self bringSubviewToFront:m_RedeemAdView];
        }
    }
}

-(void)ShowRedeenAdViewForPostGameCenterScore:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed
{
    [self HideSpinner];
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        NSString* suggestString = [StringFactory GetString_SuggestTemporaryAccess];
        int nRet = [CustomModalAlertView Ask:suggestString withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_OK]]; 
        if(nRet != 0)
        {
            [self OnPostTellFriend];
            return;
        }
        
        if(![StringFactory IsSupportClickRedeem])
            return;
        
        
        NSString *accessString = [StringFactory GetString_AccessPaidFeature]; 
        nRet = [CustomModalAlertView Ask:accessString withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_OK]]; 
        
        if(nRet == 0)
        {
            return;
        }
        if(m_RedeemAdView != nil)
        {    
            m_RedeemAdView.hidden = NO;
            [m_RedeemAdView SetScorePost:nScore withPoint:nPoint withSpeed:nScore];
            [m_RedeemAdView StartShowAd];
            [self bringSubviewToFront:m_RedeemAdView];
            
        }
    }
}

-(BOOL)ShowRedeenAdViewForAcceptInvitation
{
    [self HideSpinner];
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        NSString* suggestString = [StringFactory GetString_SuggestTemporaryAccess];
        int nRet = [CustomModalAlertView Ask:suggestString withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_OK]]; 
        if(nRet != 0)
        {
            [self OnPostTellFriend];
            return NO;
        }
        
        if(![StringFactory IsSupportClickRedeem])
            return NO;
        
        NSString *accessString = [StringFactory GetString_AccessPaidFeature]; 
        nRet = [CustomModalAlertView Ask:accessString withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_OK]]; 
        
        if(nRet == 0)
        {
            return NO;
        }
        if(m_RedeemAdView != nil)
        {    
            m_RedeemAdView.hidden = NO;
            [m_RedeemAdView SetRedeemType:REDEEMTYPE_INVITATION];
            [m_RedeemAdView StartShowAd];
            [self bringSubviewToFront:m_RedeemAdView];
        }
    }
    return YES;
}

-(void)CloseRedeemAdView
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        if(m_RedeemAdView != nil)
        {    
            m_RedeemAdView.hidden = YES;
            [self sendSubviewToBack:m_RedeemAdView];
            [self PostOneTimeTemporaryAccessOnStatusBar];
        }
    }
}

- (void)PopupFreeVersionLobbyOption
{
    if(m_GameView)
        [m_GameView PopupFreeVersionLobbyOption];
}

- (void)RedeemAdpopupViewClose
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        if(m_RedeemAdView != nil && m_RedeemAdView.hidden == NO)
        {    
            [m_RedeemAdView RedeemAdViewClosed];
        }
    }
}

-(void)CloseGameScorePostView:(BOOL)bResult
{
    if(m_GameCenterPostView.hidden == NO)
    {
        [m_GameCenterPostView SetPostResult:bResult];
        [m_GameCenterPostView CloseView:YES];
    }    
}

-(void)OnGameCenterPostSucceed
{
    [CustomModalAlertView SimpleSay:@"High Score Reported!" closeButton:[StringFactory GetString_Close]];
}

-(void)CheckTemporaryPaidFeatureAccess
{
    if([ApplicationConfigure GetAdViewsState] == NO)
        return;
    
    int nSNYear = [GameScore GetSNPostYear];
    int nSNMonth = [GameScore GetSNPostMonth];
    int nSNDay = [GameScore GetSNPostDay];
    if(nSNDay <= 0 || nSNMonth <= 0 || nSNYear <= 0)
    {
        [ApplicationConfigure SetTemporaryAccessDayLeft:-1];
        return;
    }
    
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    [components setDay:nSNDay]; // day
    [components setMonth:nSNMonth]; // month
    [components setYear:nSNYear];
    NSCalendar *gregorian = [[[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDate *SNDate = [gregorian dateFromComponents:components];
    NSDate *today = [NSDate date];
    int nDaysPast = [self daysWithinEraFromDate:SNDate toDate:today];
    int nDefaultDays = [ApplicationConfigure GetDefaultTemporaryAccessDayLimit];
    int nDaysLeft = nDefaultDays-nDaysPast;
    [ApplicationConfigure SetTemporaryAccessDayLeft:nDaysLeft];
    if([ApplicationConfigure CanTemporaryAccessPaidFeature])
        [self PostTemporaryAccessDayLeftOnStatusBar];
}

-(void)OnSNPostDone
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        NSDateComponents *dayComponents = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today];
        NSInteger day = [dayComponents day];
        NSInteger month = [dayComponents month];    
        NSInteger year = [dayComponents year];
        [GameScore SetSNPostTime:day withMonth:month withYear:year];
        [self CheckTemporaryPaidFeatureAccess];
    }    
}

-(void)ShowStatusBar
{
    [m_StatusBar Show];
    m_StatusBarStartTime = [[NSProcessInfo processInfo] systemUptime];
}

-(void)HideStatusBar
{
    [m_StatusBar Hide];
}

-(void)PostTemporaryAccessDayLeftOnStatusBar
{
    int nDayLeft = [ApplicationConfigure GetTemporaryAccessDayLeft];
    if(0 <= nDayLeft)
    {
        NSString* szText = [NSString stringWithFormat:[StringFactory GetString_YouCanAccessNextDaysFormat], (nDayLeft+1)];
        [m_StatusBar SetMessage:szText];
        [self ShowStatusBar];
    }
}

-(void)PostOneTimeTemporaryAccessOnStatusBar
{
    NSString* szText = [StringFactory GetString_YouCanAccessOneTime];
    [m_StatusBar SetMessage:szText];
    [self ShowStatusBar];
}

@end
