//
//  ApplicationMainView.m
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 2010-09-05.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "ApplicationMainView.h"
#import "ApplicationController.h"
#import "ImageLoader.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
#import "NSData-Base64.h"
#import "UIDevice-Reachability.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "StringFactory.h"
#import "GameScore.h"
#import "GameCenterConstant.h"
#import "GameCenterManager.h"
#import "GameCenterPostDelegate.h"
#import "GameLayout.h"
#import "RenderHelper.h"
#import "CustomModalAlertView.h"
#import "GameConfiguration.h"
#import "CPuzzleGrid.h"

//#ifndef _USE_SECUREVERIFICATION_
//#define _USE_SECUREVERIFICATION_
//#endif

#define NOTIFY_AND_LEAVE(X) {NSLog(X); return;}

#define PRODUCT_ID	@"com.xgadget.BubbleTile.PaidVersion"

#define PRODUCT_SQUARE_ID	@"com.xgadget.BubbleTile.PaidSquareVersion"
#define PRODUCT_DIAMOND_ID	@"com.xgadget.BubbleTile.PaidDiamondVersion"
#define PRODUCT_HEXAGON_ID	@"com.xgadget.BubbleTile.PaidHexagonVersion"

#define SANDBOX			NO

#define MAX_FALSHADDIS  PLAY       15   
#define STATUSBAR_WIDTH             300
#define STATUSBAR_HEIGHT            50

#define CURRENT_PRODUCT_RECIPT_CHECK_NONE       0
#define CURRENT_PRODUCT_RECIPT_CHECK_ALL        1
#define CURRENT_PRODUCT_RECIPT_CHECK_SQUARE     2
#define CURRENT_PRODUCT_RECIPT_CHECK_DIAMOND    3
#define CURRENT_PRODUCT_RECIPT_CHECK_HEXAGON    4


@implementation ApplicationMainView

@synthesize log;

-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate

{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
    NSInteger startDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate:startDate];
    NSInteger endDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate:endDate];
    
    return endDay-startDay;
    
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

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        m_RedeemAdView = nil;
        self.backgroundColor = [UIColor whiteColor];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        float w, h;
        if([ApplicationConfigure iPADDevice])
        {
            w = 768;
            h = 1024;
        }
        else
        {
            w = 320;
            h = 480;
        }
        m_bFlashAdShowing = FALSE;
        m_nPurchaseReciptCheckState = CURRENT_PRODUCT_RECIPT_CHECK_NONE;
	}
	
	return self;
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawDefaultBackground:(CGContextRef)context inRect:(CGRect)rect
{
    float fAlpha = 1.0;
    if([GameConfiguration GetMainBackgroundType] == 0)
        [RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
    else
        [RenderHelper DrawGreenPatternFill:context withAlpha:fAlpha atRect:rect];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
    
    [self drawDefaultBackground:context inRect:rect];
	
	CGContextRestoreGState(context);
}

-(void)InitSubViews
{
	CGRect rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight]);//CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);
	
	m_ScoreView = [[ScoreView alloc] initWithFrame:rect];
	[self addSubview:m_ScoreView];
	[m_ScoreView release];
	m_ScoreView.hidden = YES;

	
	m_ShareView = [[SNSShareView alloc] initWithFrame:rect];
	[self addSubview:m_ShareView];
	[m_ShareView release];
	m_ShareView.hidden = YES;

	m_LeaderBoardView = [[LeaderBoardSelectView alloc] initWithFrame:rect];
	[self addSubview:m_LeaderBoardView];
	[m_LeaderBoardView release];
	m_LeaderBoardView.hidden = YES;
	
    m_GameCenterPostView = [[GameCenterPostView alloc] initWithFrame:rect];
	[self addSubview:m_GameCenterPostView];
	[m_GameCenterPostView release];
	m_GameCenterPostView.hidden = YES;
 
    m_FriendView = [[FriendView alloc] initWithFrame:rect];
	[self addSubview:m_FriendView];
	[m_FriendView release];
	m_FriendView.hidden = YES;
    
    m_ScoreCalculationHelpView = [[HelpView alloc] initWithFrame:rect];
	[self addSubview:m_ScoreCalculationHelpView];
	[m_ScoreCalculationHelpView release];
	m_ScoreCalculationHelpView.hidden = YES;
    
    m_OnlinePlayerStatusView = [[PlayerOnlineStatusView alloc] initWithFrame:rect];
    [self addSubview:m_OnlinePlayerStatusView];
    [m_OnlinePlayerStatusView release];
    m_OnlinePlayerStatusView.hidden = YES;
    
    
    m_StatusBar = [[CustomDummyAlertView alloc] initWithFrame:CGRectMake(([GUILayout GetMainUIWidth]-STATUSBAR_WIDTH)/2.0, [GUILayout GetContentViewHeight]-STATUSBAR_HEIGHT, STATUSBAR_WIDTH, STATUSBAR_HEIGHT)];
    [self addSubview:m_StatusBar];
    [m_StatusBar release];
    [m_StatusBar Hide];
    [m_StatusBar SetMultiLineText:NO];
    m_StatusBarStartTime = [[NSProcessInfo processInfo] systemUptime];
    
    
/*    m_AchievementPostView = [[AchievementPostView alloc] initWithFrame:rect];
	[self addSubview:m_AchievementPostView];
	[m_AchievementPostView release];
	m_AchievementPostView.hidden = YES;
    
    m_GameView = [[GameView alloc] initWithFrame:rect];
	[self addSubview:m_GameView];
	[m_GameView release];
	[m_GameView UpdateGameViewLayout];
	[m_GameView StartNewGame];
*/
    float h = [GUILayout GetMainUIHeight];
    float w = [GUILayout GetMainUIWidth];
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
      
        float evw = [GUILayout GetDefaultExtendAdViewWidth];
        float evh = [GUILayout GetDefaultExtendAdViewHeight];
        rt = CGRectMake(([GUILayout GetContentViewWidth]-evw)/2.0, ([GUILayout GetContentViewHeight]-evh)/2.0, evw, evh);
        m_ExtendAdView = [[ExtendAdView alloc] initWithFrame:rt];
        [self addSubview:m_ExtendAdView];
        [m_ExtendAdView release];
        m_ExtendAdView.hidden = YES;
        float fSize = [GUILayout GetHouseAdViewSize];
        float sy = [GUILayout GetMainUIHeight] - fSize;
        rt = CGRectMake(([GUILayout GetMainUIWidth]-fSize)/2.0, sy, fSize, fSize);
        m_HouseAdView = [[HouseAdHostView alloc] initWithFrame:rt];
        [self addSubview:m_HouseAdView];
        [m_HouseAdView release];
        
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
    m_Wizard = [[WizardView alloc] initWithFrame:rect];
	m_Wizard.hidden = YES;
    [self addSubview:m_Wizard];
	[m_Wizard release];
	[m_Wizard UpdateViewLayout];
    
    m_FileSaveView = [[GameFileSaveView alloc] initWithFrame:rect];
	m_FileSaveView.hidden = YES;
    [self addSubview:m_FileSaveView];
	[m_FileSaveView release];
	[m_FileSaveView UpdateViewLayout];

    m_FileListView = [[GameFileListView alloc] initWithFrame:rect];
	m_FileListView.hidden = YES;
    [self addSubview:m_FileListView];
	[m_FileListView release];
	[m_FileListView UpdateViewLayout];
    
    
    m_PreviewView = [[PreviewView alloc] initWithFrame:rect];
	m_PreviewView.hidden = YES;
    [self addSubview:m_PreviewView];
	[m_PreviewView release];
    
    float fBtnSize = [GUILayout GetTitleBarHeight];
    float vw = (fBtnSize+2)*8.0+fBtnSize;
    float vh = (fBtnSize+2)*7.0;
	rect = CGRectMake(0, fBtnSize, vw, vh);
    m_PlayHelpSelectionView = [[PlayHelpView alloc] initWithFrame:rect];
	m_PlayHelpSelectionView.hidden = YES;
    [self addSubview:m_PlayHelpSelectionView];
	[m_PlayHelpSelectionView release];
    
    float daw = [GUILayout GetDefaultDummyAlertWidth];
    float dah = [GUILayout GetDefaultDummyAlertHeight];
	rect = CGRectMake(([GUILayout GetMainUIWidth]-daw)*0.5, ([GUILayout GetContentViewHeight] - dah)*0.5, daw, dah);
    m_DummyAlert = [[CustomDummyAlertButtonView alloc] initWithFrame:rect];
    m_DummyAlert.hidden = YES;
    [self addSubview:m_DummyAlert];
    [m_DummyAlert release];
    
    float paw = [GameLayout GetPurchaseSuggestViewWidth];
    float pah = [GameLayout GetPurchaseSuggestViewHeight];
	rect = CGRectMake(([GUILayout GetMainUIWidth]-paw)*0.5, ([GUILayout GetMainUIHeight] - pah), paw, pah);
    m_PurchaseAskView = [[PurchaseSuggestView alloc] initWithFrame:rect];
    [self addSubview:m_PurchaseAskView];
    [m_PurchaseAskView release];
    [m_PurchaseAskView CloseView:NO];
    
	rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);
    m_GameView = [[GameView alloc] initWithFrame:rect];
	[self addSubview:m_GameView];
	[m_GameView release];
	[m_GameView UpdateGameViewLayout];
    
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        [self bringSubviewToFront:m_HouseAdView];
    }    
    m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:m_Spinner];

	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENCONFIGUREVIEW eventHandler:@selector(OnOpenWizardView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENSCOREVIEW eventHandler:@selector(OnOpenScoreView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_OPENSHAREVIEW eventHandler:@selector(OnOpenShareView:) eventReceiver:self eventSender:m_GameView];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_PURCHASE eventHandler:@selector(OnPurchase:) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_DISABLEICONVIEWCLICK eventHandler:@selector(OnPaidFeaturePopup:) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_OPENFRIENDVIEW eventHandler:@selector(OnOpenFriendView:) eventReceiver:self eventSender:m_GameView];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OPENFILESAVEUI eventHandler:@selector(OnFileSave:) eventReceiver:self eventSender:m_GameView];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OPENPLAYHELPVIEW eventHandler:@selector(OnPlayHelpViewOpen:) eventReceiver:self eventSender:m_GameView];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_GAMEWINNOTIFICATION eventHandler:@selector(OnGameWinEvent) eventReceiver:self eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OPENSCOREHELPVIEW  eventHandler:@selector(OnOpenScorHelpView) eventReceiver:self eventSender:nil];
    
#ifdef DEBUG
//	UIButton*				m_TestSaveCacheButton;
//	UIButton*				m_TestLoadCacheButton;
//	UILabel*                m_DebugMsgDisplay;
	rect = CGRectMake(0, [GUILayout GetContentViewHeight]-50, [GUILayout GetMainUIWidth], 50);
/*    m_DebugMsgDisplay = [[UILabel alloc] initWithFrame:rect];
    m_DebugMsgDisplay.backgroundColor = [UIColor clearColor];
    [m_DebugMsgDisplay setTextColor:[UIColor whiteColor]];
    m_DebugMsgDisplay.font = [UIFont fontWithName:@"Georgia" size:24];
    [m_DebugMsgDisplay setTextAlignment:UITextAlignmentLeft];
    m_DebugMsgDisplay.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_DebugMsgDisplay.adjustsFontSizeToFitWidth = YES;
    [m_DebugMsgDisplay setText:@""];
    [self addSubview:m_DebugMsgDisplay];
    [m_DebugMsgDisplay release];*/
#endif    
}	

-(void)UpdateSubViewsOrientation
{
	CGRect rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);
	[m_GameView setFrame:rect];
	[m_GameView UpdateGameViewLayout];
    rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight]);
    [m_Wizard setFrame:rect];
    [m_Wizard UpdateViewLayout];
	[m_ScoreView setFrame:rect];
	[m_ScoreView UpdateViewLayout];
	[m_ShareView setFrame:rect];
	[m_ShareView UpdateViewLayout];
    
//	[m_PointsView setFrame:rect];
//	[m_PointsView UpdateViewLayout];
    [m_LeaderBoardView setFrame:rect];
    [m_LeaderBoardView UpdateViewLayout];
    [m_GameCenterPostView setFrame:rect];
    [m_GameCenterPostView UpdateViewLayout];
//    [m_AchievementPostView setFrame:rect];
//    [m_AchievementPostView UpdateViewLayout];
    [m_FriendView setFrame:rect];
    [m_FriendView UpdateViewLayout];
    [m_FileSaveView setFrame:rect];
    [m_FileSaveView UpdateViewLayout];
    
    [m_FileListView setFrame:rect];
    [m_FileListView UpdateViewLayout];
    
    [m_PreviewView setFrame:rect];
	[m_PreviewView UpdateSubViewsOrientation];
    
    [m_ScoreCalculationHelpView setFrame:rect];
    [m_ScoreCalculationHelpView UpdateViewLayout];
    [m_OnlinePlayerStatusView setFrame:rect];
    [m_OnlinePlayerStatusView UpdateViewLayout];
    
    [m_PlayHelpSelectionView UpdateViewLayout];

    [m_StatusBar setFrame:CGRectMake(([GUILayout GetMainUIWidth]-STATUSBAR_WIDTH)/2.0, [GUILayout GetContentViewHeight]-STATUSBAR_HEIGHT, STATUSBAR_WIDTH, STATUSBAR_HEIGHT)];
    [m_StatusBar UpdateSubViewsOrientation];
    
    float daw = [GUILayout GetDefaultDummyAlertWidth];
    float dah = [GUILayout GetDefaultDummyAlertHeight];
	rect = CGRectMake(([GUILayout GetMainUIWidth]-daw)*0.5, ([GUILayout GetContentViewHeight] - dah)*0.5, daw, dah);
    [m_DummyAlert setFrame:rect];

    float paw = [GameLayout GetPurchaseSuggestViewWidth];
    float pah = [GameLayout GetPurchaseSuggestViewHeight];
	rect = CGRectMake(([GUILayout GetMainUIWidth]-paw)*0.5, ([GUILayout GetMainUIHeight] - pah), paw, pah);
    [m_PurchaseAskView setFrame:rect];
    
    m_Spinner.center = CGPointMake([GUILayout GetContentViewWidth]/2, [GUILayout GetContentViewHeight]/2);
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        float h = [GUILayout GetMainUIHeight];
        float w = [GUILayout GetMainUIWidth];
        float ah = [GUILayout GetAdBannerHeight];
        float aw = [GUILayout GetAdBannerWidth];
        CGRect rt = CGRectMake(([GUILayout GetMainUIWidth]-aw)/2.0, h-ah, aw, ah);
        [m_AdViewBottom setFrame:rt];
     
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
        //if([ApplicationConfigure GetAdViewsState] == YES)
        //{
        //    [self bringSubviewToFront:m_HouseAdView];
        //}    
        [self setNeedsDisplay];
    }
#ifdef DEBUG
    //	UIButton*				m_TestSaveCacheButton;
    //	UIButton*				m_TestLoadCacheButton;
    //	UILabel*                m_DebugMsgDisplay;
	rect = CGRectMake(0, [GUILayout GetContentViewHeight]-50, [GUILayout GetMainUIWidth], 50);
//    [m_DebugMsgDisplay setFrame:rect];
#endif    
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

/*
-(void)AskBuyQestion
{
    int nRet = [CustomModalAlertView Ask:[StringFactory GetString_PaidFeatureInGameAsk] withButton1:[StringFactory GetString_No] withButton2:[StringFactory GetString_Yes]];
    
    if(nRet == ALERT_NO)
    {
        [self StartNewGame:NO];
    }
    else
    {
        [self OnPurchase:nil];
        return;
    }
}

-(void)HandleLatePurchaseAsk
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{[self AskBuyQestion];});    
    if(m_bDelayAskPurchase)
    {
        m_bDelayAskPurchase = NO;
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{[self AskBuyQestion];}); 
        dispatch_async(dispatch_get_main_queue(), ^{[self AskBuyQestion];}); 
        //[self AskBuyQestion];
    }
}*/

-(void)OnTimerEvent
{
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
    if(m_PurchaseAskView.hidden == NO)
    {
        NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(5 <= (currentTime - m_TimeStartShowm_PurchaseAskView))
            [m_PurchaseAskView CloseView:YES];
        
    }
    if(m_StatusBar.hidden == NO)
    {
        float currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(15 <= currentTime - m_StatusBarStartTime)
        {
            [self HideStatusBar];
        }
    }
	[m_GameView OnTimerEvent];
    [super OnTimerEvent];
}	

- (void)dealloc 
{
    [m_Spinner release];
    [super dealloc];
}

-(void)OpenFileListView
{
    if(m_FileListView)
    {
        [m_FileListView SetGameShareMode:NO];
        [m_FileListView OpenView:YES];
    }    
}

-(void)OnOpenWizardView:(id)sender
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || ![pController GetFileManager] || ![BTFileManager LocalFileExist] || [m_GameView IsUIEventLocked])
    {
        [m_Wizard OpenView:YES];
        return;
    }    
    
    int nRet = [CustomModalAlertView Ask:nil withButton1:[StringFactory GetString_Open] withButton2:[StringFactory GetString_New]];
    
    if(nRet == 1)
    {
        [m_Wizard OpenView:YES];
    }
    else 
    {
        [self OpenFileListView];
    }
}

-(void)OnOpenScoreView:(id)sender
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    BOOL bAWS = NO;
    if(pController && [pController IsAWSMessagerEnabled])
        bAWS = YES;
    
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        if(bAWS)
        {
            NSString *snString = [StringFactory GetString_Me]; 
            NSString *gkstring = @"Game Center";
            NSString* awsString = [StringFactory GetString_ReviewGamerOnlineStatus];            
            NSMutableArray *buttons = [[[NSMutableArray alloc] init] autorelease];
            [buttons addObject:snString]; 
            [buttons addObject:gkstring]; 
            [buttons addObject:awsString]; 
            
            int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
            if(nAnswer == 1)
            {
                [m_ScoreView OpenView:YES];
            }
            if(nAnswer == 2)
            {
                [m_LeaderBoardView OpenView:YES];
            }
            else if(nAnswer == 3)
            {
                //Online
                [m_OnlinePlayerStatusView OpenView:YES];
            }
        }
        else
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
                [m_LeaderBoardView OpenView:YES];
            }
            
            
        }    
    }
    else
    {    
        if(bAWS)
        {
            NSString *snString = [StringFactory GetString_Me]; 
            NSString* awsString = [StringFactory GetString_ReviewGamerOnlineStatus]; 
            int nRet = [CustomModalAlertView Ask:nil withButton1:snString withButton2:awsString]; 
            if(nRet == 0)
            {
                [m_ScoreView OpenView:YES];
            }
            else
            {
                //Online
                [m_OnlinePlayerStatusView OpenView:YES];
            }
            
        }
        else
        {
            [m_ScoreView OpenView:YES];
        } 
    }    
}

-(void)OnOpenScorePostView
{
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        NSString *snString = [StringFactory GetString_SocialNetwork]; 
        NSString *gkstring = @"Game Center";
        NSString *emailstring = [StringFactory GetString_Email];
        NSArray *buttons = [NSArray arrayWithObjects:snString, gkstring, emailstring, nil];
        int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_No] withChoice:buttons];
        
        if(nAnswer == 1)
        {
            [m_ShareView OpenView:YES];
        }
        else if(nAnswer == 2)
        {
            [m_GameCenterPostView OpenView:YES];
        }
        else if(nAnswer == 3)
        {
            [m_FileListView SetGameShareMode:YES];
            [m_FileListView OpenView:YES];
        }
    } 
    else
    {    
        NSString *snString = [StringFactory GetString_SocialNetwork]; 
        NSString *emailstring = @"E-mail";
        int nRet = [CustomModalAlertView Ask:nil withButton1:snString withButton2:emailstring];
        if(nRet == 0)
        {
            [m_ShareView OpenView:YES];
        }
        else
        {
            [m_FileListView SetGameShareMode:YES];
            [m_FileListView OpenView:YES];
        }
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

-(void)OnOpenTellFriendsView
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


-(void)SetFullFeaturePayment
{
    [GameScore SavePaidState];
    [self SwitchToPaidVersion];
}

-(void)SetSquarePuzzlePayment
{
    [GameScore SaveSquarePaidState];
    if([GameScore CheckSquarePaymentState] && [GameScore CheckDiamondPaymentState] && [GameScore CheckHexagonPaymentState])
    {
        [GameScore SavePaidState];
    }
    [self SwitchToPaidVersion];
}

-(void)SetDiamondPuzzlePayment
{
    [GameScore SaveDiamondPaidState];
    if([GameScore CheckSquarePaymentState] && [GameScore CheckDiamondPaymentState] && [GameScore CheckHexagonPaymentState])
    {
        [GameScore SavePaidState];
    }
    [self SwitchToPaidVersion];
}

-(void)SetHexagonPuzzlePayment
{
    [GameScore SaveHexagonPaidState];
    if([GameScore CheckSquarePaymentState] && [GameScore CheckDiamondPaymentState] && [GameScore CheckHexagonPaymentState])
    {
        [GameScore SavePaidState];
    }
    [self SwitchToPaidVersion];
}


-(void)BuyFullFeature
{
    if([ApplicationConfigure IsOnSimulator])
    {
        [self SetFullFeaturePayment];
    }
    else
    {
        if([SKPaymentQueue canMakePayments])
        {	
			self.log = [NSMutableString string];
			[self doLog:@"Submitting Request... Please wait."];
            SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCT_ID]];
            preq.delegate = self;
            [preq start];
        }
        else
        {
            [CustomModalAlertView SimpleSay:[StringFactory GetString_CannotPayment] closeButton:[StringFactory GetString_Close]];
        }	
    }
}

-(void)BuySquarePuzzle
{
    if([ApplicationConfigure IsOnSimulator])
    {
        [self SetSquarePuzzlePayment];
    }
    else
    {
        if([SKPaymentQueue canMakePayments])
        {	
			self.log = [NSMutableString string];
			[self doLog:@"Submitting Request... Please wait."];
            SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCT_SQUARE_ID]];
            preq.delegate = self;
            [preq start];
        }
        else
        {
            [CustomModalAlertView SimpleSay:[StringFactory GetString_CannotPayment] closeButton:[StringFactory GetString_Close]];
        }	
    }
}

-(void)BuyDiamondPuzzle
{
    if([ApplicationConfigure IsOnSimulator])
    {
        [self SetDiamondPuzzlePayment];
    }
    else
    {
        if([SKPaymentQueue canMakePayments])
        {	
			self.log = [NSMutableString string];
			[self doLog:@"Submitting Request... Please wait."];
            SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCT_DIAMOND_ID]];
            preq.delegate = self;
            [preq start];
        }
        else
        {
            [CustomModalAlertView SimpleSay:[StringFactory GetString_CannotPayment] closeButton:[StringFactory GetString_Close]];
        }	
    }
}

-(void)BuyHexagonPuzzle
{
    if([ApplicationConfigure IsOnSimulator])
    {
        [self SetHexagonPuzzlePayment];
    }
    else
    {
        if([SKPaymentQueue canMakePayments])
        {	
			self.log = [NSMutableString string];
			[self doLog:@"Submitting Request... Please wait."];
            SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCT_HEXAGON_ID]];
            preq.delegate = self;
            [preq start];
        }
        else
        {
            [CustomModalAlertView SimpleSay:[StringFactory GetString_CannotPayment] closeButton:[StringFactory GetString_Close]];
        }	
    }
}

-(void)OnPurchase:(id)sender
{
    NSString *szRestoreString = [StringFactory GetString_RestorePurchase];
    
    NSString* szFullFeature = [NSString stringWithFormat:@"%@ (%@)", [StringFactory GetString_PurchaseFullFeature], [StringFactory GetString_FullPrice]];
    NSString* szSquarePuzzle = [NSString stringWithFormat:@"%@ (1/2 %@)", [StringFactory GetString_SquarePuzzle], [StringFactory GetString_Price]];
    NSString* szDiamondPuzzle = [NSString stringWithFormat:@"%@ (1/2 %@)", [StringFactory GetString_DiamondPuzzle], [StringFactory GetString_Price]];
    NSString* szHexagonPuzzle = [NSString stringWithFormat:@"%@ (1/2 %@)", [StringFactory GetString_HexagonPuzzle], [StringFactory GetString_Price]];
    
    NSMutableArray *buttons = [[[NSMutableArray alloc] init] autorelease];
    [buttons addObject:szRestoreString]; 
    [buttons addObject:szFullFeature]; 
    if([GameScore CheckSquarePaymentState] == NO)
    {
        [buttons addObject:szSquarePuzzle];
    }    
    if([GameScore CheckDiamondPaymentState] == NO)
    {
         [buttons addObject:szDiamondPuzzle];
    }
    if([GameScore CheckHexagonPaymentState] == NO)
    {
        [buttons addObject:szHexagonPuzzle];
    }
    
    
    //int nAnswer = [ModalAlert ask:[StringFactory GetString_PaidFeatureAsk] withCancel:[StringFactory GetString_NoThanks] withButtons:buttons];
    int nAnswer = [CustomModalAlertView MultChoice:[StringFactory GetString_PaidFeatureAsk] withCancel:[StringFactory GetString_NoThanks] withChoice:buttons];
    
	NSLog(@"Ask buit answer:%i", nAnswer);
    if(nAnswer == 1)
    {
        [self repurchase];
    }
    if(nAnswer == 2)
    {
        [self BuyFullFeature];
    }
    else if(nAnswer == 3)
    {
        NSString* szLabel = (NSString*)[buttons objectAtIndex:2];
        if([szLabel isEqualToString:szSquarePuzzle])
            [self BuySquarePuzzle];
        else if([szLabel isEqualToString:szDiamondPuzzle])
            [self BuyDiamondPuzzle];
        else if([szLabel isEqualToString:szHexagonPuzzle])
            [self BuyHexagonPuzzle];
        
    }
    else if(nAnswer == 4)
    {
        NSString* szLabel = (NSString*)[buttons objectAtIndex:3];
        if([szLabel isEqualToString:szDiamondPuzzle])
            [self BuyDiamondPuzzle];
        else if([szLabel isEqualToString:szHexagonPuzzle])
            [self BuyHexagonPuzzle];
    }
    else if(nAnswer == 5)
    {
        [self BuyHexagonPuzzle];
    }
    else if(nAnswer == 0)
    {
        [self GotoRedeemProcess];
    }
}

-(void)ResumeAds
{
/*    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        if(m_AdFlashView.hidden == NO)
            [m_AdFlashView ResumeAd];
        
        [m_AdViewBottom ResumeAd];
    }*/    
    [self CheckTemporaryPaidFeatureAccess];
}

-(void)PauseAds
{
/*    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        [m_AdFlashView PauseAd];
        [m_AdViewBottom PauseAd];
    }*/    
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
/*    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        [self ShowSpinner];
        m_bFlashAdShowing = YES;
        m_AdFlashView.hidden = NO;
        [m_AdFlashView ShowAd];
        [self bringSubviewToFront:m_AdFlashView];
        m_nFlashAdDisplayCount = 0;    
    }*/
}

-(void)HideFlashAdView
{
/*    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        [self HideSpinner];
        m_bFlashAdShowing = NO;
        [m_AdFlashView HideAd];
        m_AdFlashView.hidden = YES;
        [self sendSubviewToBack:m_AdFlashView];
        m_nFlashAdDisplayCount = 0;
       // setDisplayAD(0);
        //[m_GameView StartNewGame];
    }*/
}

-(void)OnFullScreenAdDone:(id)sender
{
/*    if([ApplicationConfigure GetAdViewsState] == YES && (m_bFlashAdShowing == YES))
    {
        [self HideSpinner];
        m_bFlashAdShowing = NO;
        m_AdFlashView.hidden = YES;
        [self sendSubviewToBack:m_AdFlashView];
        m_nFlashAdDisplayCount = 0;  
        //setDisplayAD(0);
        //[m_GameView StartNewGame];
    }*/
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	[self doLog:@"Error: Could not contact App Store properly, %@", [error localizedDescription]];
	NSString* str = [NSString stringWithFormat:@"Error(Could not contact App Store properly): %@", [error localizedDescription]];
    [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
}

- (void)requestDidFinish:(SKRequest *)request
{
	// Release the request
	if(SANDBOX == YES)
    {  
        [self doLog:@"Request finished."];
    }    
	
    [request autorelease];
}

- (void) repurchase
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    NSLog(@"repuchase function is called");
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    int nCount = [response products].count; 
    if(0 < nCount)
    {   
        for(int i = 0; i < nCount; ++i)
        {    
            SKProduct *product = [[response products] lastObject];
            if (!product)
            {
                [self doLog:@"Error retrieving product information from App Store. Sorry! Please try again later."];
                continue;
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
                SKPayment *payment = [SKPayment paymentWithProduct:product]; 
                [[SKPaymentQueue defaultQueue] addPayment:payment];
            }
        }
    }    
}

#pragma mark payments
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
}

- (void) completedPurchaseTransaction: (SKPaymentTransaction *) transaction
{
#ifndef _USE_SECUREVERIFICATION_
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
		NSLog(@"Receipt information: %@", resultString);
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
            NSString* paymentProductID = transaction.payment.productIdentifier;
            if([paymentProductID isEqualToString:PRODUCT_ID] == YES)
            {
                [self SetFullFeaturePayment];
            }
            else if([paymentProductID isEqualToString:PRODUCT_SQUARE_ID] == YES)    
            {
                [self SetSquarePuzzlePayment];
            }
            else if([paymentProductID isEqualToString:PRODUCT_DIAMOND_ID] == YES)    
            {
                [self SetDiamondPuzzlePayment];
            }
            else if([paymentProductID isEqualToString:PRODUCT_HEXAGON_ID] == YES)    
            {
                [self SetHexagonPuzzlePayment];
            }
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
#else 
    m_nPurchaseReciptCheckState = CURRENT_PRODUCT_RECIPT_CHECK_NONE;
    VerificationController* pVerification = [VerificationController sharedInstance];
    if(pVerification)
    {
        [pVerification registerDelegate:self];
        [pVerification verifyPurchase:transaction];
    }
#endif    
}

- (void) restorePurchaseTransaction: (SKPaymentTransaction *) transaction
{
    [self completedPurchaseTransaction:transaction];
}

- (void) handleFailedTransaction: (SKPaymentTransaction *) transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self doLog:[StringFactory GetString_BuyFailure]];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions 
{
	for (SKPaymentTransaction *transaction in transactions) 
	{
		switch (transaction.transactionState) 
		{
			case SKPaymentTransactionStatePurchased: 
				if(SANDBOX == YES)
                    [self doLog:@"SKPaymentTransactionStatePurchased"];
				[self completedPurchaseTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				if(SANDBOX == YES)
                    [self doLog:@"SKPaymentTransactionStateRestored"];
				[self restorePurchaseTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed: 
				if(SANDBOX == YES)
                    [self doLog:@"SKPaymentTransactionStateFailed"];
				[self handleFailedTransaction:transaction]; 
				break;
			default: 
				if(SANDBOX == YES)
                    NSLog(@"Other transaction");
				break;
		}
	}
}

- (void)RemoveBuyitButton
{
    [m_GameView RemovePurchaseButton];
}

- (void)ShutDownAdViews
{
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
    if([ApplicationConfigure GetAdViewsState] == YES)
    {    
        [ApplicationConfigure SetAdViewsState:NO];
        [self ShutDownAdViews];
    }    
    
    if([GameScore CheckPaymentState] == YES)
        [self RemoveBuyitButton];

    [self UpdateSubViewsOrientation];
    if([m_Wizard IsOpened] == YES)
    {
        [m_Wizard CloseView:YES];
    }
    else
    {    
        [m_GameView ResetSate];
    }    
}

-(void)OnPaidFeaturePopup:(id)sender
{
    // Create the product request and start it
    [self OnPurchase:nil];
}

- (void)HandleAdRequest:(NSURL*)url
{
    if([ApplicationConfigure GetAdViewsState] == YES)
    {   
        [m_ExtendAdView SetCornerShow];
        float w = [GUILayout GetExtendAdViewCornerWidth];
        float h = [GUILayout GetExtendAdViewCornerWidth];
        float sx = ([GUILayout GetMainUIWidth] -w)/2.0;
        float sy = [GUILayout GetContentViewHeight];
        CGRect rt = CGRectMake(sx, sy, w, h);
        [m_ExtendAdView setFrame:rt];
        [m_ExtendAdView UpdateViewLayout];
        [m_ExtendAdView OpenWebPage:url withAnimation:YES];
    }
}

- (void)AdViewClicked
{
    
}

- (void)DismissExtendAdView
{
    
}

- (void)StartNewGame:(BOOL)bLoadCacheData
{
    [m_GameView StartNewGame:bLoadCacheData];
}

- (BOOL)IsGameComplete
{
    BOOL bRet = YES;
    if(m_GameView)
        bRet = [m_GameView IsGameComplete];
    return bRet;
}

- (void)LoadGameSet:(NSMutableDictionary**)dataDict
{
    if(m_GameView)
        [m_GameView LoadGameSet:dataDict];
}

//-(void)LoadUndoList:(NSMutableDictionary**)dataDict withKey:(NSString*)szKey
- (void)LoadUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index
{
    if(m_GameView)
        [m_GameView LoadUndoList:dataDict withPrefIndex:index];
}

-(void)OnFileSave:(id)sender
{
    if(m_FileSaveView)
        [m_FileSaveView OpenView:YES];
}

- (void)OpenPreviewView:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)enBubbleType withSetting:(NSArray*)setting
{
    CGImageRef preview = [CPuzzleGrid GetDefaultPreviewImage:enType withLayout:enLayout withSize:nEdge withLevel:bEasy withBubble:enBubbleType withSetting:setting];
    [m_PreviewView SetPreview:preview withLevel:bEasy];
    [m_PreviewView OpenView];
}

- (void)OnFileSaveViewClosed
{
    [m_GameView StartNewGame:NO];
}

- (void)OnFileOpenViewCancelled
{
    [m_GameView StartNewGame:NO];
}

- (void)OnFileOpenViewClosedForInAppPurchase
{
    [self OnPurchase:nil];
}

- (void)OnFileOpenViewClosedWithSelectedGameFile
{
    BOOL bSuccessed = NO;
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(m_FileListView && pController && [pController GetFileManager])
    {    
        NSURL* fileURL = [m_FileListView GetSelectedFile];
        if(fileURL)
        {
            bSuccessed = [[pController GetFileManager] NewGameFromPath:fileURL];
            if(bSuccessed)
            {
                BOOL bRestart = YES;
                if(0 < [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count])
                {
                    int nIndex = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count] - 1;
                    BTFilePlayRecord* pRecord = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:nIndex];
                    if(pRecord && !pRecord.m_bCompleted)
                    {
                        int nRet = [CustomModalAlertView Ask:[StringFactory GetString_GameNotCompletedWarn] withButton1:[StringFactory GetString_Continue] withButton2:[StringFactory GetString_Restart]];
                        
                        if(nRet == ALERT_NO)
                        {
                            bRestart = NO;
                        }    
                        else
                        {    
                            bRestart = YES;
                        }    
                    }
                }
                [m_GameView StartNewGameFromOpenFile:bRestart];
                return;
            }
        }
    }    
    if(bSuccessed == NO)
    {
        [m_GameView StartNewGame:NO];
    }
}

-(void)OnPlayHelpViewOpen:(id)sender;
{
    if(m_PlayHelpSelectionView)
    {
        if(m_PlayHelpSelectionView.hidden == YES)
            [m_PlayHelpSelectionView OpenView:YES];
    }
}

- (void)OnGamePlayHelpViewClosed
{
    if(m_PlayHelpSelectionView)
    {
        int nSelectedIndex = [m_PlayHelpSelectionView GetSelectedIndex];
        [self StartPlayHelpAnimation:nSelectedIndex];
    }
}

-(void)StartPlayHelpAnimation:(int)nSelectedType
{
    [m_GameView StartPlayHelpAnimation:nSelectedType];
}

-(void)OnCustomDummyAlertViewClosed
{
    int nRet = [m_DummyAlert GetClickedButton];
    if(nRet == ALERT_OK)
    {
        [self OnPurchase:nil];
    }
    else 
    {
        [self StartNewGame:NO];
    }
}

-(void)StartGameFromFile:(NSURL*)fileURL
{    
    BOOL bNeedToPurchase = YES;
    BTFile* TestFile = [[[BTFile alloc] init] autorelease];
    [TestFile SetFileURL:fileURL];
    [TestFile LoadDocument];
    
    enGridType enType = (enGridType)TestFile.m_FileHeader.m_GameData.m_GridType;
    int nEdge = TestFile.m_FileHeader.m_GameData.m_GridEdge;
    //????????????????
    //????????????????
    //????????????????
    //????????????????
    int nStart = [GameConfiguration GetMinBubbleUnit:enType];
    //????????????????
    //????????????????
    //????????????????
    //????????????????
    //????????????????
    //????????????????
    if(enType == PUZZLE_GRID_TRIANDLE || [GameScore CheckPaymentState] == YES)
    {    
        bNeedToPurchase = NO;
    }    
    else if(enType == PUZZLE_GRID_SQUARE && [GameScore CheckSquarePaymentState] == YES)
    {    
        bNeedToPurchase = NO;
    }    
    else if(enType == PUZZLE_GRID_DIAMOND && [GameScore CheckDiamondPaymentState] == YES)
    {    
        bNeedToPurchase = NO;
    }    
    else if(enType == PUZZLE_GRID_HEXAGON && [GameScore CheckHexagonPaymentState] == YES)
    {    
        bNeedToPurchase = NO;
    }   
    if(nEdge <= nStart)
    {
        bNeedToPurchase = NO;
    }
    
    if(bNeedToPurchase && ![ApplicationConfigure CanTemporaryAccessPaidFeature])
    {    
        [self StartNewGame: NO];
        [m_DummyAlert SetMessage:[StringFactory GetString_PaidFeatureInGameAsk]];
        [m_DummyAlert SetOKButtonString:[StringFactory GetString_Yes]];
        [m_DummyAlert SetCancelButtonString:[StringFactory GetString_No]];
        [m_DummyAlert OpenView:YES];
        return;
    }
    else
    {    
        ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
        if(fileURL && pController && [pController GetFileManager])
        {
            BOOL bSuccessed = [[pController GetFileManager] NewGameFromPath:fileURL];
            if(bSuccessed)
            {
                [m_GameView StartNewGameFromOpenFile:YES];
            }    
        }
    }    
}

- (void)HighScoreReport
{
//    [GUIEventLoop SendEvent:GUIID_EVENT_POSTONLINESCORE eventSender:nil];
}

- (void)OnGameWinEvent
{
    if([GameScore CheckPaymentState] == YES)
    {
        [self HighScoreReport];
        return;
    }
    if(m_PurchaseAskView.hidden == NO)
    {
        [self HighScoreReport];
        return;
    }
    [m_PurchaseAskView OpenView:YES];
    m_TimeStartShowm_PurchaseAskView = [[NSProcessInfo processInfo] systemUptime];
    [self HighScoreReport];
}

-(void)OnOpenScorHelpView
{
    if(m_ScoreCalculationHelpView)
    {
        [m_ScoreCalculationHelpView OpenView:YES];
    }
}

- (void)GotoRedeemProcess
{
    NSString* suggestString = [StringFactory GetString_SuggestTemporaryAccess];
    int nRet = [CustomModalAlertView Ask:suggestString withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_OK]]; 
    if(nRet != 0)
    {
        [self OnOpenTellFriendsView];
        return;
    }
    
    if([ApplicationConfigure CanClickToEarn] == YES && m_RedeemAdView != nil)
    {
        NSString *accessString = [StringFactory GetString_AccessPaidFeature]; 
        nRet = [CustomModalAlertView Ask:accessString withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_OK]]; 
        
        if(nRet == 0)
        {
            return;
        }
        
        if(m_RedeemAdView != nil)
        {    
            m_RedeemAdView.hidden = NO;
            [m_RedeemAdView StartShowAd];
            [self bringSubviewToFront:m_RedeemAdView];
        }
        
    }
}

-(void)CloseRedeemAdView
{
    if(m_RedeemAdView != nil)
    {    
        m_RedeemAdView.hidden = YES;
        [self sendSubviewToBack:m_RedeemAdView];
    }
}

- (void)RedeemAdpopupViewClose
{
    if(m_RedeemAdView != nil && m_RedeemAdView.hidden == NO)
    {    
        [m_RedeemAdView RedeemAdViewClosed];
    }
}


-(void)OnSNPostDone
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

-(void)CheckTemporaryPaidFeatureAccess
{
    if([GameScore CheckPaymentState] == YES)
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

-(void)ShowStatusBar
{
    [m_StatusBar Show];
    m_StatusBarStartTime = [[NSProcessInfo processInfo] systemUptime];
}

-(void)HideStatusBar
{
    [m_StatusBar Hide];
}

-(void)ShowTextOnStatusBar:(NSString*)text
{
    if(m_PurchaseAskView.hidden == NO)
        [m_PurchaseAskView CloseView:YES];
    [m_StatusBar SetMessage:text];
    [self ShowStatusBar];
}

-(void)setCurrentVerificationProductID:(NSString*)productID
{
    if([productID isEqualToString:PRODUCT_ID] == YES)
    {
        m_nPurchaseReciptCheckState = CURRENT_PRODUCT_RECIPT_CHECK_ALL;
        NSLog(@"Product ID is full features purchase in verification");
    }
    else if([productID isEqualToString:PRODUCT_SQUARE_ID] == YES)    
    {
        m_nPurchaseReciptCheckState = CURRENT_PRODUCT_RECIPT_CHECK_SQUARE;
        NSLog(@"Product ID is square features purchase in verification");
    }
    else if([productID isEqualToString:PRODUCT_DIAMOND_ID] == YES)    
    {
        m_nPurchaseReciptCheckState = CURRENT_PRODUCT_RECIPT_CHECK_DIAMOND;
        NSLog(@"Product ID is diamond features purchase in verification");
    }
    else if([productID isEqualToString:PRODUCT_HEXAGON_ID] == YES)    
    {
        m_nPurchaseReciptCheckState = CURRENT_PRODUCT_RECIPT_CHECK_HEXAGON;
        NSLog(@"Product ID is hexagon features purchase in verification");
    }
    else
    {
        m_nPurchaseReciptCheckState = CURRENT_PRODUCT_RECIPT_CHECK_NONE;
        NSLog(@"Product ID is not valid in verification");
    }
}

-(void)currentProductPurchaseVerificationDone
{
    if(m_nPurchaseReciptCheckState == CURRENT_PRODUCT_RECIPT_CHECK_ALL)
    {
        [self SetFullFeaturePayment];
    }
    else if( m_nPurchaseReciptCheckState == CURRENT_PRODUCT_RECIPT_CHECK_SQUARE)    
    {
        [self SetSquarePuzzlePayment];
    }
    else if(m_nPurchaseReciptCheckState == CURRENT_PRODUCT_RECIPT_CHECK_DIAMOND)    
    {
        [self SetDiamondPuzzlePayment];
    }
    else if(m_nPurchaseReciptCheckState == CURRENT_PRODUCT_RECIPT_CHECK_HEXAGON)    
    {
        [self SetHexagonPuzzlePayment];
    }
}

-(void)currentProductPurchaseVerificationFailed
{
    
}


#ifdef DEBUG
- (void)ShowDebugMessage:(NSString*)msg
{
//    [m_DebugMsgDisplay setText:msg];
}
#endif    

@end
