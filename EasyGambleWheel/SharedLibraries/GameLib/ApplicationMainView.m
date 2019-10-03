//
//  ApplicationMainView.m
//  ChuiNiuZH
//
//  Created by Zhaohui Xing on 2010-09-05.
//  Copyright 2010 xgadget. All rights reserved.
//
#import "GameView.h"
#import "ApplicationMainView.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "RenderHelper.h"
#include "drawhelper.h"
#import "ImageLoader.h"
#import "GameViewController.h"

#import "ApplicationResource.h"
#import "GlossyMenuItem.h"
#import "MultiChoiceGlossyMenuItem.h"
#import "Configuration.h"
#import "RenderHelper.h"
#import "SoundSource.h"
#include "drawhelper.h"
#import "GameViewController.h"
#import "CustomModalAlertView.h"
#import "StringFactory.h"
#import "CGameSectionManager.h"
#import "GameScore.h"
#import "UIDevice-Reachability.h"
#import "ScoreRecord.h"
#import "MainAppViewController.h"
#import "GameCenterManager.h"


#define NOTIFY_AND_LEAVE(X) {NSLog(X); return;}


@interface ApplicationMainView () //GlossyMenuView<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    GameView*               m_GameView;
    
     WizardView*             m_WizardView;
     ScoreView*				m_ScoreView;
     PledgeView*             m_PlayerPledgeView;
     AnimalThemePledgeView*  m_PlayerPledgeViewAnimalTheme;
     TransactionView*        m_PlayerTransactionView;
     
     GameCenterPostView*     m_GameCenterPostView;
     FriendView*              m_FriendView;
     InAppPurchaseSelectionView*     m_InAppPurchaseSelectionView;
     
     CashMachine*            m_CashMachine;
    
    int                     m_nFlashAdDisplayCount;
    BOOL                    m_bFlashAdShowing;
    
    NSMutableString*		log;
    
    UIActivityIndicatorView*    m_Spinner;
    
    int                     m_nSpiralAnimation;
    int                     m_nSpiralStep;
    
    //Menu items
    UIButton*				m_SystemButton;
    SpinnerBtn*             m_OnlineButton;
    SpinnerBtn*             m_OnlineCloseButton;
    
    
    BOOL					m_bMenuAnimtation;
    OverLayView*            m_Overlay;
    
    //In-App purchasing process
    BOOL                    m_bInAppPurchasing;
    BOOL                    m_bPaymentSent;
    GameStatusBar*          m_StatusBar;
    NSTimeInterval          m_TimeStartShowCongratulation;
}

-(void)HandleFailedToPurchase;
-(void)OnPurchaseFailed;

@end

@implementation ApplicationMainView

@synthesize log;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor redColor];
    m_bFlashAdShowing = NO;
    m_bInAppPurchasing = NO;
    m_bPaymentSent = NO;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    m_nSpiralAnimation = 0;
    m_nSpiralStep = 0;
    
    NSLog(@"container view width:%f height:%f", self.frame.size.width, self.frame.size.height);
    
}

-(void)Terminate
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [m_GameView Terminate];
}

-(void)RegisterGKInvitationListener
{
    if(m_GameView != nil)
        [m_GameView RegisterGKInvitationListener];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [GUILayout SetMainUIDimension:self.frame.size.width withHeight:self.frame.size.height];
    [self UpdateSubViewsOrientation];
}

-(GameView*)GetGameView
{
    return m_GameView;
}

- (id<GameControllerDelegate>)GetGameController
{
    return (id<GameControllerDelegate>)[m_GameView GetGameController];
}

-(void)ShowCongratulationText
{
    [self bringSubviewToFront:m_StatusBar];
    [m_StatusBar SetText:[StringFactory GetString_Congratulation]];
    m_TimeStartShowCongratulation = [[NSProcessInfo processInfo] systemUptime];
}

-(void)CloseStatusBar
{
    [m_StatusBar CloseView:YES];
}

-(void)AddPurchase1000ChipToMyAccount
{
    [self AddMoneyToMyAccount:PURCHASED_CHIPS_1];
    [self ShowCongratulationText];
    if([Configuration canPlaySound])
    {
        [SoundSource PlayDropCoinSound];
    }
    [self setNeedsDisplay];
}

-(void)OpenOnlineGKPlayerListViewForGameCenterGame
{
    //??????????
    //??????????
    //How to open game center to invite player to join the game
    //
    //??????????
    //??????????
}

-(void)AskForOnlineGameWithGameCenter
{
    NSString* szGameCenter = @"Game Center";
    NSString* szBluetooth = [StringFactory GetString_BlueTooth];
    
    NSArray *buttons = [NSArray arrayWithObjects:szGameCenter,szBluetooth, nil];//[NSArray arrayWithObjects:szAWSOnline, szGameCenter,szBluetooth, nil];
    int nOnlineOption = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
    
    if(nOnlineOption == 1)
    {
/*        NSString* szCheckOnlinePlayer = [StringFactory GetString_CheckOnlinePlayers];
        
        int nRet = [CustomModalAlertView Ask:szCheckOnlinePlayer withButton1:[StringFactory GetString_No] withButton2:[StringFactory GetString_Yes]];
        if(nRet == 1)
        {
            [self OpenOnlineGKPlayerListViewForGameCenterGame];
            return;
        }
*/        
        NSString* szCreate = [StringFactory GetString_CreateNewLobby];
        NSString* szSearch = [StringFactory GetString_SearchLobby];
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        [buttons addObject:szCreate];
        [buttons addObject:szSearch];
        
        int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
        
        if(nAnswer == 0)
        {
            [m_OnlineButton StopSpin];
        }
        else if(nAnswer == 1)
        {
            [m_OnlineButton StartSpin];
            [self CreateNewOnlineGame];
        }
        else if(nAnswer == 2)
        {
            [m_OnlineButton StartSpin];
            [self CreateSearchOnlineGame];
        }
    }
    else if(nOnlineOption == 2)
    {
        [m_OnlineButton StartSpin];
        [self CreateNewGKBTSessionGame];
    }
}

-(void)AskForOnlineGameWithOutGameCenter
{
    NSString* szBluetooth = [StringFactory GetString_BlueTooth];
    
    NSArray *buttons = [NSArray arrayWithObjects:szBluetooth, nil];
    int nOnlineOption = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
    
    if(nOnlineOption == 1)
    {
        [m_OnlineButton StartSpin];
        [self CreateNewGKBTSessionGame];
    }
}



-(void)GotoOnlineGame
{
    [self OnlineButtonClick];
}

-(void)OnlineButtonClick
{
    CGameSectionManager* pGameController = [m_GameView GetGameController];
    if(pGameController && [pGameController IsOnline])
        return;
    
    if([ApplicationConfigure IsGameCenterEnable])
    {
        [self AskForOnlineGameWithGameCenter];
    }
    else
    {
        [self AskForOnlineGameWithOutGameCenter];
    }
}

-(void)OnlineCloseButtonClick
{
     CGameSectionManager* pGameController = [m_GameView GetGameController];
    if(pGameController && [pGameController IsOnline])
    {
        [pGameController ShutdownGameSection];
        if(![pGameController IsOnline])
        {
            [self GKOnlineRequestCancelled];
        }
    }
}

-(void)UpdateOnlineButtonsStatus
{
    //if([ApplicationConfigure IsGameCenterEnable])
    if([UIDevice networkAvailable])
    {
        m_OnlineButton.hidden = NO;
        m_OnlineCloseButton.hidden = YES;
    }
    else 
    {
        m_OnlineButton.hidden = YES;
        m_OnlineCloseButton.hidden = YES;
    }
}

- (void)StartOnlineButtonSpin
{
    if(m_OnlineButton.hidden == NO)
        [m_OnlineButton StartSpin];
}

- (void)StopOnlineButtonSpin
{
    [m_OnlineButton StopSpin];
}

- (void)CloseTransactionProcess
{
    m_bInAppPurchasing = NO;
    if(m_bPaymentSent)
    {
        m_bPaymentSent = NO;
    }
    [m_GameView RedeemAdViewClosed];
}

- (BOOL)IsRedeemAdViewOpened
{
    BOOL bRet = NO;
    //if(![ApplicationConfigure EarnChipFromInApp])
    //{
//        bRet = (m_RedeemAdView.hidden == NO) || m_bInAppPurchasing;
    //}
    //else
    //{
    //    bRet = m_bInAppPurchasing;
    //}
    return bRet;
}

- (void)SystemButtonClick
{
    if(([m_GameView GetGameState] != GAME_STATE_READY && [m_GameView GetGameState] != GAME_STATE_RESET))
    {
        return;
    }
    
     if(m_Menu && m_bMenuAnimtation == NO)
     {	
         m_bMenuAnimtation = YES;
         if(m_bMenuShow == NO)
         {
             m_Overlay.hidden = NO;
             [self bringSubviewToFront:m_Overlay];
             [self bringSubviewToFront:m_SystemButton];
             int nCount = [m_Menu GetMenuItemCount];
             if(0 < nCount)
             {
                 for(int i = 0; i < nCount; ++i)
                 {
                     [self bringSubviewToFront:((UIView*)[m_Menu GetMenuItemAt:i])];
                 }	
             }	
     
             m_bMenuShow = YES;
             if([m_GameView IsOnline] == NO)
             {    
                 [m_GameView CancelPendPlayerBet];
                 [m_GameView SetSystemOnHold:TRUE];
                 [m_GameView HoldMyTurnIfNeeded];
                 [Configuration setDirty];
             }    
             [m_Menu Show];
         }	
         else
         {
             [m_Menu Hide];
         }	
     
         [self setNeedsDisplay];
     }	
}

-(void)ResetSate
{
    if(m_Menu && m_bMenuAnimtation == NO)
    {	
        if(m_bMenuShow == YES)
        {
            m_bMenuAnimtation = YES;
            [m_Menu Hide];
        }
    }
}

-(void)OnWizardClosed
{
    [Configuration setDirty];
    [self ResetSate];
}



//////////////////////////////////////////////////////////////////////////
//Menu Item methods
//////////////////////////////////////////////////////////////////////////
-(void)OnMenuHide
{
	[super OnMenuHide];
	
    m_bMenuAnimtation = NO;
    
    [self sendSubviewToBack:m_Overlay];
    m_Overlay.hidden = YES;

    [self bringSubviewToFront:m_SystemButton];
    [self setNeedsDisplay];
    [m_GameView ResetGameStateAndType];
}

-(BOOL)IsUIEventLocked
{
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return YES;

    return NO;
}

-(void)OnMenuShow
{
	m_bMenuAnimtation = NO;
	[self setNeedsDisplay];
}	

-(void)OnMenuEvent:(int)menuID
{
	if(m_bMenuAnimtation == YES)
		return;
    
	[GUIEventLoop SendEvent:menuID eventSender:self];
}	

-(void)OnMenuPlay:(id)sender
{
	[self SystemButtonClick];
}

-(void)OnMenuSound:(id)sender
{
	BOOL bEnable = [Configuration canPlaySound];
	[Configuration setPlaySoundEffect:!bEnable];
    [ScoreRecord SetSoundEnable:[Configuration canPlaySound]];
    [ScoreRecord SaveScore];
    bEnable = ![Configuration canPlaySound];
    
	[[m_Menu GetMenuItem:GUIID_SOUNDBUTTON] SetChecked:bEnable];
}

-(void)OnMenuSetting:(id)sender
{
    [Configuration setCurrentGameType:[m_GameView GetGameType]];
    [Configuration setOnline:NO];
    [m_WizardView OpenView:YES];
}

-(void)OnMenuScore:(id)sender
{
    GameViewController* pAppController = (GameViewController*)[GUILayout GetGameViewController];
    
    if(pAppController && [pAppController IsConnectedGameCenter])
    {
        NSString *snString = @"Me!";
        NSString *gkstring = @"Game Center";
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        [buttons addObject:snString];
        [buttons addObject:gkstring];
        
        int nRet = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
        if(nRet == 1)
        {
            [m_ScoreView OpenView:YES];
        }

        else if(nRet == 2)
        {
            [pAppController OpenLeaderBoardView:0];
        }
    }
    else
    {
 
        NSString *snString = @"Me!";
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        [buttons addObject:snString];
        
        int nRet = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
        if(nRet == 1)
        {
            [m_ScoreView OpenView:YES];
        }

//        [CustomModalAlertView SimpleSay:@"Cannot access GameCenter!" closeButton:[StringFactory GetString_Close]];
    }
}

-(void)OnMenuFriend:(id)sender
{
/*????
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        [m_FriendView OpenView:YES];
    }
    else
    {
        NSString* str = @"Cannot connect with Game Center，please try later！";
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
??????*/
}

-(void)OnOpenGameCenterPostView
{
    if([GameCenterManager isGameCenterSupported] && [ApplicationConfigure IsGameCenterEnable])
    {
        [m_GameCenterPostView OpenView:YES];
    }
    else
    {
        NSString* str = @"Cannot connect with Game Center，please try later！";
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
}


-(void)OnMenuShare:(id)sender
{
    //NSString* strTellFriend = [StringFactory GetString_TellFriends];
//??    NSString* strPostScore = [StringFactory GetString_PostScore];
    
/*
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    //[buttons addObject:strTellFriend];
    [buttons addObject:strPostScore];
    
    int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
    if(nAnswer == 1)
    {
        int nScore = [ScoreRecord GetMyMostWinChips];
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetGameViewController];
        if(pGKDelegate)
        {
            [pGKDelegate PostGameCenterScore:nScore withBoard:0];
        }
    }
 */
    [self OnOpenGameCenterPostView];
}


- (void)SetCurrentConfiguration
{
}

- (void) doLog: (NSString *) formatstring, ...
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	NSString *outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	[self.log appendString:outstring];
	[self.log appendString:@"\n"];
	NSLog(@"%@", self.log);
}

- (void)drawSpiralAnimation:(CGContextRef)context inRect:(CGRect)rect
{
    float cx = rect.origin.x + rect.size.width/2;
    float cy = rect.origin.y + rect.size.height/2;
    float fSize = (rect.size.height < rect.size.width) ? rect.size.width : rect.size.height;
    fSize *= 1.2;
    CGRect drawRect = CGRectMake(cx-fSize/2, cy-fSize/2, fSize, fSize);

    float angle = m_nSpiralAnimation;
	
    CGContextSaveGState(context);
    
    CGFloat clrvals[] = {0.4, 0.1, 0.1, 1.0};
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
    
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    shadowSize = CGSizeMake(6, 6);
    
    CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, angle*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
    
    CGContextSetShadowWithColor(context, shadowSize, 10, shadowClrs);
    
    [RenderHelper DrawSpiral:context at:drawRect];
    
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    
    CGContextRestoreGState(context);
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawDefaultBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreatePattern(NULL);
	
	CGContextSetFillColorSpace(context, colorSpace);

	CGFloat fAlpha = 0.65;
	[RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(context);
    
//    [self drawSpiralAnimation:context inRect:rect];
}

-(void)drawCashMachine:(CGContextRef)context
{
    CGFloat fSize = [GUILayout GetCashMachineSize];
    CGFloat sx = [GUILayout GetMainUIWidth] - fSize;
    CGFloat sy = 0;
    CGRect rt = CGRectMake(sx, sy, fSize, fSize);
    [m_CashMachine Draw:context at:rt]; 
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
    
    [self drawDefaultBackground:context inRect:rect];
    [self drawCashMachine:context];
	CGContextRestoreGState(context);
}

-(CGPoint)GetViewCenter
{
	CGPoint pt = CGPointMake([GUILayout GetMainUIWidth]/2.0, [GUILayout GetContentViewHeight]/2.0);
	return pt;
}

- (void)CreateMenu
{
	if(m_Menu)
	{
        CGRect rect = CGRectMake(0, 0, [GUILayout GetGlossyMenuSize], [GUILayout GetGlossyMenuSize]);
        
		GlossyMenuItem*  menuPlay = [[GlossyMenuItem alloc] initWithMeueID:GUIID_PLAYBUTTON withFrame:rect withContainer:m_Menu];
		[menuPlay RegisterNormalImage:@"playback.png"];
		[menuPlay RegisterHighLightImage:@"playbackhi.png"];
		[menuPlay SetGroundZero:CGPointMake(15, 15)];
		[menuPlay Reset];
		[self AddMenuItem:menuPlay];
		[GUIEventLoop RegisterEvent:GUIID_PLAYBUTTON eventHandler:@selector(OnMenuPlay:) eventReceiver:self eventSender:self];
      
/*??????
        GlossyMenuItem*  menuAWSSetting = [[GlossyMenuItem alloc] initWithMeueID:GUIID_AWSCONFIGUREBUTTON withFrame:rect withContainer:m_Menu];
        [menuAWSSetting RegisterNormalImage:@"onlinestate.png"];
        [menuAWSSetting RegisterHighLightImage:@"onlinestatedisable.png"];
        [menuAWSSetting SetGroundZero:CGPointMake(15, 15)];
        [menuAWSSetting Reset];
        [self AddMenuItem:menuAWSSetting];
        [GUIEventLoop RegisterEvent:GUIID_AWSCONFIGUREBUTTON eventHandler:@selector(OnAWSConfigure) eventReceiver:self eventSender:nil];
?????????????*/
        
        GlossyMenuItem*  menuLevel = [[GlossyMenuItem alloc] initWithMeueID:GUIID_CONFIGUREBUTTON withFrame:rect withContainer:m_Menu];
        [menuLevel RegisterNormalImage:@"toolicon.png"];
        [menuLevel RegisterHighLightImage:@"tooliconhi.png"];
        [menuLevel SetGroundZero:CGPointMake(15, 15)];
        [menuLevel Reset];
        [self AddMenuItem:menuLevel];
        [GUIEventLoop RegisterEvent:GUIID_CONFIGUREBUTTON eventHandler:@selector(OnMenuSetting:) eventReceiver:self eventSender:self];
  
		GlossyMenuItem*  menuSound = [[GlossyMenuItem alloc] initWithMeueID:GUIID_SOUNDBUTTON withFrame:rect withContainer:m_Menu];
		[menuSound RegisterNormalImage:@"musicicon.png"];
		[menuSound RegisterHighLightImage:@"musiciconhi.png"];
		[menuSound RegisterCheckedImage:@"muteicon.png"];
		[menuSound RegisterCheckedHighLightImage:@"muteicon.png"];
		[menuSound SetGroundZero:CGPointMake(15, 15)];
		[menuSound Reset];
		BOOL bChecked = ![Configuration canPlaySound];
		[menuSound SetChecked:bChecked];
		[self AddMenuItem:menuSound];
		[GUIEventLoop RegisterEvent:GUIID_SOUNDBUTTON eventHandler:@selector(OnMenuSound:) eventReceiver:self eventSender:self];
        
        GlossyMenuItem*  menuScore = [[GlossyMenuItem alloc] initWithMeueID:GUIID_SCOREBUTTON withFrame:rect withContainer:m_Menu];
        [menuScore RegisterNormalImage:@"scoreicon.png"];
        [menuScore RegisterHighLightImage:@"scoreiconhi.png"];
        [menuScore SetGroundZero:CGPointMake(15, 15)];
        [menuScore Reset];
        [self AddMenuItem:menuScore];
        [GUIEventLoop RegisterEvent:GUIID_SCOREBUTTON eventHandler:@selector(OnMenuScore:) eventReceiver:self eventSender:self];
        
        GlossyMenuItem*  menuPost = [[GlossyMenuItem alloc] initWithMeueID:GUIID_POSTBUTTON withFrame:rect withContainer:m_Menu];
        [menuPost RegisterNormalImage:@"posticon.png"];
        [menuPost RegisterHighLightImage:@"posticonhi.png"];
        [menuPost SetGroundZero:CGPointMake(15, 15)];
        [menuPost Reset];
        [self AddMenuItem:menuPost];
        [GUIEventLoop RegisterEvent:GUIID_POSTBUTTON eventHandler:@selector(OnMenuShare:) eventReceiver:self eventSender:self];
   
 /*??
		GlossyMenuItem*  menuFriend = [[GlossyMenuItem alloc] initWithMeueID:GUIID_FRIENDBUTTON withFrame:rect withContainer:m_Menu];
		[menuFriend RegisterNormalImage:@"friendicon.png"];
		[menuFriend RegisterHighLightImage:@"friendiconhi.png"];
		[menuFriend SetGroundZero:CGPointMake(15, 15)];
		[menuFriend Reset];
		[self AddMenuItem:menuFriend];
		[GUIEventLoop RegisterEvent:GUIID_FRIENDBUTTON eventHandler:@selector(OnMenuFriend:) eventReceiver:self eventSender:self];
   ??*/
        [self UpdateMenuLayout];
    }  
}

-(void)InitMenuItems
{
    [self CreateMenu];
    CGRect frame = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight]);
    [self SetCurrentConfiguration];
    
    m_Overlay = [[OverLayView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:m_Overlay];
    m_Overlay.hidden = YES;
    
    
    float fBtnSize = [GUILayout GetTitleBarHeight];
    CGRect rect = CGRectMake(0, 0, fBtnSize, fBtnSize);
    m_SystemButton = [[UIButton alloc] initWithFrame:rect];
    
    // Set up the button aligment properties
    m_SystemButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_SystemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_SystemButton setBackgroundImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateNormal];
    [m_SystemButton setBackgroundImage:[UIImage imageNamed:@"menuiconhi.png"] forState:UIControlStateHighlighted];
    [m_SystemButton addTarget:self action:@selector(SystemButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_SystemButton];
    
    GameViewController* AppController = (GameViewController*)[GUILayout GetGameViewController];
    if(AppController && [AppController IsSupportMultPlayerGame])
    {    
        rect = CGRectMake((fBtnSize+1), 0, fBtnSize, fBtnSize);
        m_OnlineButton = [[SpinnerBtn alloc] initWithFrame:rect];
    
        // Set up the button aligment properties
        m_OnlineButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_OnlineButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
        [m_OnlineButton setBackgroundImage:[UIImage imageNamed:@"lobbyicon.png"] forState:UIControlStateNormal];
        [m_OnlineButton addTarget:self action:@selector(OnlineButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_OnlineButton];
    
    
        //rect = CGRectMake(0, 0, fBtnSize, fBtnSize);
        m_OnlineCloseButton = [[SpinnerBtn alloc] initWithFrame:rect];
    
        // Set up the button aligment properties
        m_OnlineCloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_OnlineCloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
        [m_OnlineCloseButton setBackgroundImage:[UIImage imageNamed:@"lobbystopicon.png"] forState:UIControlStateNormal];
        [m_OnlineCloseButton addTarget:self action:@selector(OnlineCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_OnlineCloseButton];
        m_OnlineCloseButton.hidden = YES;
    }
    
    [self bringSubviewToFront:m_SystemButton];
    [self bringSubviewToFront:m_OnlineButton];
    m_bMenuAnimtation = NO;
}

-(void)InitGameView
{
    CGRect rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);
    m_GameView = [[GameView alloc] initWithFrame:rect];
    [self addSubview:m_GameView];
    [m_GameView DelayRegisterGameController];
}

-(void)InitSubViews
{
    float h = [GUILayout GetMainUIHeight];
    float w = [GUILayout GetMainUIWidth];
    m_CashMachine = [[CashMachine alloc] init];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_GAMESTATECHANGE eventHandler:@selector(OnGameStateChange) eventReceiver:self eventSender:nil];

    [GUIEventLoop RegisterEvent:GUIID_EVENT_PURCHASEFAILED eventHandler:@selector(OnPurchaseFailed) eventReceiver:self eventSender:nil];
    
    CGRect rect;
    
    rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight]);
    m_WizardView = [[WizardView alloc] initWithFrame:rect];
    [self addSubview:m_WizardView];
    m_WizardView.hidden = YES;
   
	m_ScoreView = [[ScoreView alloc] initWithFrame:rect];
	[self addSubview:m_ScoreView];
	m_ScoreView.hidden = YES;
    
    m_GameCenterPostView = [[GameCenterPostView alloc] initWithFrame:rect];
	[self addSubview:m_GameCenterPostView];
	m_GameCenterPostView.hidden = YES;
    
    m_InAppPurchaseSelectionView = [[InAppPurchaseSelectionView alloc] initWithFrame:rect];
    [self addSubview:m_InAppPurchaseSelectionView];
    [m_InAppPurchaseSelectionView SetParent:self];
    m_InAppPurchaseSelectionView.hidden = YES;
    
    h = [GUILayout GetContentViewHeight];
    float ph = [GUILayout GetLuckyNumberPickViewHeight];
    float pw = [GUILayout GetLuckyNumberPickViewWidth];
    rect = CGRectMake((w-pw)/2.0, (h-ph)/2.0, pw, ph);
    m_PlayerPledgeView = [[PledgeView alloc] initWithFrame:rect];
    [self addSubview:m_PlayerPledgeView];
    m_PlayerPledgeView.hidden = YES;
    [self sendSubviewToBack:m_PlayerPledgeView];
    
    m_PlayerPledgeViewAnimalTheme = [[AnimalThemePledgeView alloc] initWithFrame:rect];
    [self addSubview:m_PlayerPledgeViewAnimalTheme];
    m_PlayerPledgeViewAnimalTheme.hidden = YES;
    [self sendSubviewToBack:m_PlayerPledgeViewAnimalTheme];
    
    m_PlayerTransactionView = [[TransactionView alloc] initWithFrame:rect];
    [self addSubview:m_PlayerTransactionView];
    m_PlayerTransactionView.hidden = YES;
    [self sendSubviewToBack:m_PlayerTransactionView];
 
    
    float greeth = [GUILayout GetStatusBarHeight];
    float greetw = [GUILayout GetStatusBarWidth];
    //float greety = [GUILayout GetContentViewHeight]-greeth;
    rect = CGRectMake(([GUILayout GetMainUIWidth]-greetw)/2.0, 0, greetw, greeth);
    m_StatusBar = [[GameStatusBar alloc] initWithFrame:rect];
    [m_StatusBar CloseView:NO];
    [self addSubview:m_StatusBar];
    
    
    m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:m_Spinner];
    
//????    [GUIEventLoop RegisterEvent:GUIID_EVENT_OPENREDEEMVIEW eventHandler:@selector(OnRedeemViewOpen) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_PURCHASECHIPS eventHandler:@selector(OnPurchaseChips) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_ONLINE_GAMEEQUEST_DONE eventHandler:@selector(GKOnlineRequestDone) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_WIZARDFINISHED eventHandler:@selector(OnWizardClosed) eventReceiver:self eventSender:nil];
    [self InitMenuItems];
    [self InitGameView];
    [self bringSubviewToFront:m_OnlineButton];
    [self bringSubviewToFront:m_SystemButton];
}
 
-(void)UpdateSubViewsOrientation
{
    CGRect rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetContentViewHeight]);
    rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight]);
    [m_GameView setFrame:rect];
    [m_GameView UpdateGameLayout];
    
    float h = [GUILayout GetMainUIHeight];
    float w = [GUILayout GetMainUIWidth];
    
	[m_GameView setFrame:rect];
    [m_GameView UpdateGameLayout];
    [m_Overlay setFrame:rect];
    [self UpdateMenuLayout];
    
    rect = CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight]);
    [m_WizardView setFrame:rect];
    [m_WizardView UpdateViewLayout];
	[m_ScoreView setFrame:rect];
	[m_ScoreView UpdateViewLayout];
    [m_GameCenterPostView setFrame:rect];
    [m_GameCenterPostView UpdateViewLayout];
    [m_FriendView setFrame:rect];
    [m_FriendView UpdateViewLayout];
    
    [m_InAppPurchaseSelectionView setFrame:rect];
    [m_InAppPurchaseSelectionView UpdateViewLayout];

    
    h = [GUILayout GetContentViewHeight];
    float ph = [GUILayout GetLuckyNumberPickViewHeight];
    float pw = [GUILayout GetLuckyNumberPickViewWidth];
    rect = CGRectMake((w-pw)/2.0, (h-ph)/2.0, pw, ph);
    //rect = CGRectMake((w-pw)/2.0, 0, pw, ph);
    [m_PlayerPledgeView setFrame:rect];
    [m_PlayerPledgeViewAnimalTheme setFrame:rect];
    [m_PlayerTransactionView setFrame:rect];
   
    float greeth = [GUILayout GetStatusBarHeight];
    float greetw = [GUILayout GetStatusBarWidth];
//    float greety = [GUILayout GetContentViewHeight]-greeth;
 //   if([GUILayout IsLandscape])
 //       greety = [GUILayout GetContentViewHeight]-[GUILayout GetAvatarDislayVerticalMargin];
    
    rect = CGRectMake(([GUILayout GetMainUIWidth]-greetw)/2.0, 0, greetw, greeth);
    [m_StatusBar setFrame:rect];
   
    m_Spinner.center = CGPointMake([GUILayout GetContentViewWidth]/2, m_Spinner.frame.size.height/2.0);//[GUILayout GetContentViewHeight]/2);

    int nCount = (int)[self.subviews count];
    for(int i = 0; i < nCount; ++i)
    {
        id pSubView = [self.subviews objectAtIndex:i];
        if(pSubView && [pSubView isKindOfClass:[CustomModalAlertBackgroundView class]] && [pSubView respondsToSelector:@selector(UpdateSubViewsOrientation)])
        {
            [pSubView performSelector:@selector(UpdateSubViewsOrientation)];
        }
    }
    [self setNeedsDisplay];
}


-(void)OnTimerEvent
{
	[m_GameView OnTimerEvent];
    
    if(m_PlayerPledgeView.hidden == NO)
        [m_PlayerPledgeView OnTimerEvent];
    
    if(m_PlayerPledgeViewAnimalTheme.hidden == NO)
        [m_PlayerPledgeViewAnimalTheme OnTimerEvent];
    
    if(m_WizardView.hidden == NO)
        [m_WizardView OnTimerEvent];
    
    if(m_PlayerTransactionView.hidden == NO)
        [m_PlayerTransactionView OnTimerEvent];

    if([self IsRedeemAdViewOpened] || ([m_GameView GetGameState] != GAME_STATE_READY && [m_GameView GetGameState] != GAME_STATE_RESET))
    {
        if(m_SystemButton.hidden == NO)
            m_SystemButton.hidden = YES;
    }
    else
    {
        if(m_SystemButton.hidden == YES)
            m_SystemButton.hidden = NO;
    }

    
    if(m_StatusBar.hidden == NO)
    {
        NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(GREETING_SHOW_TIME <= (currentTime - m_TimeStartShowCongratulation))
             [self CloseStatusBar];
    }
    else
    {
        id<GameControllerDelegate> pGameController = [self GetGameController];
        if(pGameController && [pGameController GetGameOnlineState] == GAME_ONLINE_STATE_ONLINE && [pGameController GetGameState] == GAME_STATE_RESET)
        {
            GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
            [pController ShowStatusBar:[StringFactory GetString_Pledge]];
        }
    }
}

- (void)dealloc 
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)InitializeDefaultPlayersConfiguration
{
    [m_GameView InitializeDefaultPlayersConfiguration];
}

- (int)GetPlayerCurrentMoney:(int)nSeat
{
    return [m_GameView GetPlayerCurrentMoney:nSeat];
}

- (void)AddMoneyToPlayerAccount:(int)nChips SeatID:(int)nSeat
{
    [m_GameView AddMoneyToPlayerAccount:nChips SeatID:nSeat];
/*????
    if([m_Click2EarnDisplay IsOpen])
    {
        int nMoney = [self GetPlayerCurrentMoney:nSeat];
        [m_Click2EarnDisplay SetCurrentMoney:nMoney];
        int nType = [m_GameView GetGameType];
        BOOL bEnable = [m_GameView CanPlayerPlayGame:nType inSeat:nSeat];
        [m_Click2EarnDisplay SetEnable:bEnable];
    }
????*/
    [self OnGameStateChange];
}

- (int)GetMyCurrentMoney
{
    return [m_GameView GetMyCurrentMoney];
}

- (void)AddMoneyToMyAccount:(int)nChips
{
    [m_GameView AddMoneyToMyAccount:nChips];
    int nMoney = [self GetMyCurrentMoney];
    [m_CashMachine SetMyCurrentMoney:nMoney];
    [self setNeedsDisplay];
}

-(void)OnGameStateChange
{
    int nMoney = [m_GameView GetMyCurrentMoney];
    [m_CashMachine SetMyCurrentMoney:nMoney];
    [self setNeedsDisplay];
    [m_GameView setNeedsDisplay];
}

-(void)OnPurchaseChips
{
//??  [(MainAppViewController*)[GUILayout GetRootViewController] setAdBannerEnable:NO];
    
    
    [self ShowSpinner];
  
    
    
    // Make a payment for consumable purchase item
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self OnInAppPurchase];
}

-(NSString*)GetPlayerName:(int)nSeatID
{
    return [m_GameView GetPlayerName:nSeatID];
}

-(BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID
{
    return [m_GameView CanPlayerPlayGame:nType inSeat:nSeatID];
}

- (void)OpenPlayerPledgeView:(int)nSeat
{
    int nType = [m_GameView GetGameType];
 
    [Configuration setCurrentGameType:nType];
    if(m_bMenuShow == NO)
    {
        m_Overlay.hidden = NO;
        [self bringSubviewToFront:m_Overlay];
    }
    if([Configuration getCurrentGameTheme] == GAME_THEME_NUMBER)
        [m_PlayerPledgeView OpenView:nSeat];
    else
        [m_PlayerPledgeViewAnimalTheme OpenView:nSeat];
}

- (void)OnClosePlayerPledgeView
{
    if(m_bMenuShow == NO)
    {
        m_Overlay.hidden = YES;
        [self sendSubviewToBack:m_Overlay];
    }
    if([Configuration getCurrentGameTheme] == GAME_THEME_NUMBER)
    {
        [m_PlayerPledgeView CloseView];
        int nSeat = [m_PlayerPledgeView GetSeatID];
        int nLuckNumber = [m_PlayerPledgeView GetSelectedLuckNumber];
        int nBetMoney = [m_PlayerPledgeView GetPledgedBet];
        [m_GameView PlayerFinishPledge:nSeat withNumber:nLuckNumber withBet:nBetMoney];
    }
    else
    {
        [m_PlayerPledgeViewAnimalTheme CloseView];
        int nSeat = [m_PlayerPledgeViewAnimalTheme GetSeatID];
        int nLuckNumber = [m_PlayerPledgeViewAnimalTheme GetSelectedLuckNumber];
        int nBetMoney = [m_PlayerPledgeViewAnimalTheme GetPledgedBet];
        [m_GameView PlayerFinishPledge:nSeat withNumber:nLuckNumber withBet:nBetMoney];
    }
}

- (void)OpenPlayerTransactionView:(int)nSeat
{
    if(m_bMenuShow == NO)
    {
        m_Overlay.hidden = NO;
        [self bringSubviewToFront:m_Overlay];
    }
    [m_PlayerTransactionView OpenView:nSeat];
}

- (void)OnClosePlayerTransactionView
{
    if(m_bMenuShow == NO)
    {
        m_Overlay.hidden = YES;
        [self sendSubviewToBack:m_Overlay];
    }    
    [m_PlayerTransactionView CloseView];
    int nSeat = [m_PlayerTransactionView GetSeatID];
    int nReceiverID = [m_PlayerTransactionView GetReceiverID];
    int nTransChips = [m_PlayerTransactionView GetTransactionChips];
    [m_GameView PlayerTranfereChipsFrom:nSeat To:nReceiverID withChips:nTransChips];   
    int nMoney = [m_GameView GetMyCurrentMoney];
    [m_CashMachine SetMyCurrentMoney:nMoney];
    [self setNeedsDisplay];
}

- (void)PauseGame
{
}

- (void)ResumeGame
{
    [m_GameView ResumeGame];
}

-(void)ShowSpinner
{
/*????
    [self bringSubviewToFront:m_Spinner];
    m_Spinner.hidden = NO;
    [m_Spinner sizeToFit];
    [m_Spinner startAnimating];
    m_Spinner.center = CGPointMake([GUILayout GetContentViewWidth]/2, m_Spinner.frame.size.height/2.0);//[GUILayout GetContentViewHeight]/2);
???*/
}

-(void)HideSpinner
{
/*????
    [m_Spinner stopAnimating];
    m_Spinner.hidden = YES;
????*/
}


- (void)OnInAppPurchase
{
	if([SKPaymentQueue canMakePayments])
	{
		// Create the product request and start it
		/*
        
        NSArray *buttons = [NSArray arrayWithObject: [StringFactory GetString_Purchase]];
	
        int nAnswer = [CustomModalAlertView MultChoice:[StringFactory GetString_AskString] withCancel:[StringFactory GetString_NoThanks] withChoice:buttons];
        
		if (nAnswer == 1)
		{
            [m_InAppPurchaseSelectionView SetParent:self];
            [m_InAppPurchaseSelectionView OpenView:YES];
            
		}
        else
        {
            [self HideSpinner];
        }
        */
        
        NSMutableArray* buttons = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < 10; ++i)
        {
            NSString* szLable = [StringFactory GetString_InAppPurchaseItemName:i];
            [buttons addObject:szLable];
        }
        int nAnswer = [CustomModalAlertView MultChoice:nil/*??[StringFactory GetString_AskString]??*/ withCancel:[StringFactory GetString_NoThanks] withChoice:buttons];
        if (1 <= nAnswer)
        {
            [self PurchaseInAppItem:(nAnswer-1)];
        }
        else
        {
            [self HideSpinner];
            [self HandleFailedToPurchase];
        }
    }
	else
	{
        m_bInAppPurchasing = NO;
		[CustomModalAlertView SimpleSay:[StringFactory GetString_CannotPayment] closeButton:[StringFactory GetString_Close]];
        [self HideSpinner];
        [self HandleFailedToPurchase];
	}
}

-(void)PurchaseInAppItem:(int)nItemIndex
{
    if([ApplicationConfigure IsOnSimulator])
    {
        int nChip = [GameUitltyHelper GetInAppPurchaseChips:nItemIndex];
        [self AddMoneyToMyAccount:nChip];
        [self HideSpinner];
        [self ShowCongratulationText];
        [m_GameView RedeemAdViewClosed];
        if([Configuration canPlaySound])
        {
            [SoundSource PlayDropCoinSound];
        }
        [self setNeedsDisplay];
        return;
    }
    [self ShowSpinner];
    // Make a payment for consumable purchase item
    
    self.log = [NSMutableString string];
    [self doLog:@"Submitting Request... Please wait."];
    m_bInAppPurchasing = YES;
    
    NSString* szProductID = [GameUitltyHelper GetInAppPurchaseID:nItemIndex];
    NSLog(@"In-App Item ID:%@\n", szProductID);
    NSSet* itemList = [NSSet setWithObject:szProductID];
    
    SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:itemList];
    preq.delegate = self;
    [preq start];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	[self doLog:@"Error: Could not contact App Store properly, %@", [error localizedDescription]];
	NSString* str = [NSString stringWithFormat:@"Error(Could not contact App Store properly): %@", [error localizedDescription]];
    [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    [self CloseTransactionProcess];
    [self HideSpinner];
    [self HandleFailedToPurchase];
}

- (void)requestDidFinish:(SKRequest *)request
{
	// Release the request
	if(SANDBOX == YES)
    {  
        [self doLog:@"Request finished."];
    }    
	
    NSLog(@"requestDidFinish: %@\n", [request description]);
    
    [self HideSpinner];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    int nCount = (int)[response products].count;
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
            
            // Make a payment for consumable purchase item
            SKPayment *payment = [SKPayment paymentWithProduct:product]; 
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            m_bPaymentSent = YES;
            return;
        }
    }
    else
    {
        [self CloseTransactionProcess];
    }
}

#pragma mark payments
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
}

- (void)completedPurchaseTransactionAndRestoreGame: (SKPaymentTransaction *) transaction
{
    if(transaction && transaction.payment && transaction.payment.productIdentifier)
    {   
        NSString* paymentProductID = transaction.payment.productIdentifier;
        
        for(int i = 0; i < 10; ++i)
        {
            if([paymentProductID isEqualToString:[GameUitltyHelper GetInAppPurchaseID:i]] == YES)
            {
                int nChip = [GameUitltyHelper GetInAppPurchaseChips:i];
                [self AddMoneyToMyAccount:nChip];
                [self ShowCongratulationText];
                if([Configuration canPlaySound])
                {
                    [SoundSource PlayDropCoinSound];
                }
                [m_GameView RedeemAdViewClosed];
                [self setNeedsDisplay];
                
                break;
            }
        }
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self CloseTransactionProcess];
}

- (void) completedPurchaseTransaction: (SKPaymentTransaction *) transaction
{
    BOOL bOK = NO;
    NSString* paymentProductID = transaction.payment.productIdentifier;
    for(int i = 0; i < 10; ++i)
    {
        if([paymentProductID isEqualToString:[GameUitltyHelper GetInAppPurchaseID:i]] == YES)
        {
            int nChip = [GameUitltyHelper GetInAppPurchaseChips:i];
            [self AddMoneyToMyAccount:nChip];
            [self ShowCongratulationText];
            if([Configuration canPlaySound])
            {
                [SoundSource PlayDropCoinSound];
            }
            [m_GameView RedeemAdViewClosed];
            [self setNeedsDisplay];
            bOK = YES;
            break;
        }
    }

	// Finish transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction]; // do not call until you are actually finished
	[self doLog:@"Recipte is checked."];
    [self HideSpinner];
    if(bOK == NO)
    {
        [self HandleFailedToPurchase];
    }
}


- (void) restorePurchaseTransaction: (SKPaymentTransaction *) transaction
{
    //Since the purchase is consumable, no restoration needed 
    //[self completedPurchaseTransaction:transaction];
    [self CloseTransactionProcess];
}


- (void) handleFailedTransaction: (SKPaymentTransaction *) transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self doLog:[StringFactory GetString_BuyFailure]];
    [self CloseTransactionProcess];
    [self HandleFailedToPurchase];
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
				//[self completedPurchaseTransaction:transaction];
				[self completedPurchaseTransactionAndRestoreGame:transaction];
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
			case SKPaymentTransactionStatePurchasing: 
				if(SANDBOX == YES)
                    [self doLog:@"SKPaymentTransactionStatePurchasing"];
				break;
			default: 
				if(SANDBOX == YES)
                    NSLog(@"Other transaction");
                [self CloseTransactionProcess];
				break;
		}
	}
}

- (void)GKOnlineRequestCancelled
{
    [self CloseStatusBar];
    [m_OnlineButton StopSpin];
    m_OnlineButton.hidden = NO;
    m_OnlineCloseButton.hidden = YES;
    m_SystemButton.hidden = NO;
    [self bringSubviewToFront:m_OnlineButton];
    [m_GameView GotoOfflineGame];
}

- (void)GKOnlineRequestDone
{
    [m_OnlineButton StopSpin];
    m_OnlineButton.hidden = YES;
    m_OnlineCloseButton.hidden = NO;
    m_SystemButton.hidden = YES;
    [self bringSubviewToFront:m_OnlineCloseButton];
}

- (void)CreateNewOnlineGame
{
    GameViewController* pAppController = (GameViewController*)[GUILayout GetGameViewController];
    if(pAppController)
    {
        id<GameControllerDelegate> pGameController = [pAppController GetGameController];
        if(pGameController)
            [pGameController PopupGKMatchWindow];
    }    
}

- (void)CreateSearchOnlineGame
{
    GameViewController* pAppController = (GameViewController*)[GUILayout GetGameViewController];
    if(pAppController)
    {
        id<GameControllerDelegate> pGameController = [pAppController GetGameController];
        if(pGameController)
            [pGameController StartGKMatchAutoSearch];
    }    
}

- (void)CreateNewGKBTSessionGame
{
    GameViewController* pAppController = (GameViewController*)[GUILayout GetGameViewController];
    if(pAppController)
    {
        id<GameControllerDelegate> pGameController = [pAppController GetGameController];
        if(pGameController)
            [pGameController PopupGKBTSessionWindow];
    }    
}

- (void)ShowStatusBar:(NSString*)text
{
    [self bringSubviewToFront:m_StatusBar];
    [m_StatusBar SetText:text];
    m_TimeStartShowCongratulation = [[NSProcessInfo processInfo] systemUptime];
    
}

- (void)HandleFailedToPurchase
{
    [GUIEventLoop SendEvent:GUIID_EVENT_PURCHASEFAILED eventSender:self];
}

-(int)GetDefaultRedeemChips
{
    return 2;
}

-(void)OnPurchaseFailed
{
    GamePlayer* pMyself = [m_GameView GetMyself];
    if(pMyself != nil && [pMyself GetPacketBalance] == 0)
    {
        [(MainAppViewController*)[GUILayout GetRootViewController] setAdBannerEnable:YES];
        NSString* str = @"Welcome to play the game!";
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
        int nChips = [self GetDefaultRedeemChips];
        [self AddMoneyToMyAccount:nChips];
        [pMyself UpdateCurrentGamePlayablity];
        
    }
}


@end
