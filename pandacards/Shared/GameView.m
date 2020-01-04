//
//  DealView.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-16.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "ApplicationConfigure.h"
#import "TextMsgPoster.h"
#import "GameRobo.h"
#import "DealResult.h"
#import "PlayerBadget.h"
#import "SpinnerBtn.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "GameBaseView.h"
#import "GameCard.h"
#import "CSignsBtn.h"
#import "DealController.h"
#import "GameView.h"
#import "GUILayout.h"
#import "CGameLayout.h"
#import "GlossyMenuItem.h"
#import "MultiChoiceGlossyMenuItem.h"
#import "RenderHelper.h"
#import "ImageLoader.h"
#import "StringFactory.h"
#import "CustomModalAlertView.h"
#import "NSData-Base64.h"
#import "UIDevice-Reachability.h"
#import "GameCenterConstant.h"
#import "GameMsgConstant.h"
#import "GameMsgFormatter.h"
#import "CardEquation.h"
#include "GameUtility.h"
#include "GameState.h"
#import "GameScore.h"
#import "StringFactory.h"

@implementation GameView

@synthesize m_nAnimationLock;

- (BOOL)CanDoLobbyButtonClick
{
    BOOL bRet = NO;
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        if([pGKDelegate IsGameLobbyMaster] == NO)
        {    
            return NO;
        }
        
        if([pGKDelegate IsGameLobbyMaster] && [m_DealController IsGameComplete] == NO && [m_Badget GetState] == ROBO_STATE_PLAY)
            return NO;
        
        if([m_Avatar1 IsActive] == YES && [m_Avatar1 GetState] == ROBO_STATE_PLAY)
            return NO;
        
        if([m_Avatar2 IsActive] == YES && [m_Avatar2 GetState] == ROBO_STATE_PLAY)
            return NO;
        
        if([m_Avatar3 IsActive] == YES && [m_Avatar3 GetState] == ROBO_STATE_PLAY)
            return NO;
        
         
        return YES;
    }
    
    return bRet;
}

- (void)EnterNewDeal
{
	[m_DealController EnterNewDeal];
}	

- (void)GoToNextDeal
{
	[m_DealController GoToNextDeal];
}

- (void)MoveOutOldDeal
{
	[m_DealController MoveOutOldDeal];
}	

- (void)testAction
{
	[self EnterNewDeal];
}	

- (void)testAction2
{
	[self MoveOutOldDeal];
}	

- (void)UndoButtonClick
{
    if([self IsUIEventLocked])
        return;
    
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return;
    
    [self UndoDeal];
}

- (void)GoToNextLobbyDeal
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if([pGKDelegate IsGameLobbyMaster] && [m_DealController IsGameComplete] == YES)
        {    
            [self StartNewGame];
            return;
        }
        
        GameMessage* msg = [[GameMessage alloc] init];
        [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_NEXTGAMEDEAL];
        [GameMsgFormatter EndFormatMsg:msg];
        [pGKDelegate SendMessageToAllplayers:msg];
        [msg release];
        if([m_DealController IsGameDealComplete] == YES)
            [m_DealController GoToNextDeal];
        else
            [m_DealController MoveOutOldDeal];
        
        [self SetMyselfPlayState];
    }    
}

- (BOOL)CanLobbyNextButtonClick
{
    BOOL bRet = NO;
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        if([pGKDelegate IsGameLobbyMaster] == NO)
        {    
            if([m_DealController IsGameComplete] == YES)
                return NO;
        }
        
        if([m_Badget IsActive] == YES && [m_Badget GetState] != ROBO_STATE_PLAY && [m_Avatar1 IsActive] == YES && [m_Avatar1 GetState] == ROBO_STATE_PLAY)
            return NO;
        
        if([m_Badget IsActive] == YES && [m_Badget GetState] != ROBO_STATE_PLAY && [m_Avatar2 IsActive] == YES && [m_Avatar2 GetState] == ROBO_STATE_PLAY)
            return NO;
        
        if([m_Badget IsActive] == YES && [m_Badget GetState] != ROBO_STATE_PLAY && [m_Avatar3 IsActive] == YES && [m_Avatar3 GetState] == ROBO_STATE_PLAY)
            return NO;
        
        return YES;
    }
    
    return bRet;
}

- (void)NextButtonClick
{
    if([self IsUIEventLocked])
        return;
    
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return;

    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if([m_Badget GetState] == ROBO_STATE_PLAY)
        {
            [m_DealController ForceToNextDeal];
            [m_DealController ResetLobbyGameDeal];
            return;
        }
        
        if([self CanLobbyNextButtonClick] == NO)
            return;
        else
            [self GoToNextLobbyDeal];
        
        return;
    }
    
    [self NextDeal];
}

- (void)SystemButtonClick
{
    if(m_bMenuAnimtation == YES || 0 < m_nAnimationLock || [m_DealController InAnimation] == YES)
        return;

    if([ApplicationConfigure GetAdViewsState])
    {    
        if (![UIDevice networkAvailable])
        {	
            //[ModalAlert say:[StringFactory GetString_NetworkWarn]];
            [CustomModalAlertView SimpleSay:[StringFactory GetString_NetworkWarn] closeButton:[StringFactory GetString_Close]];
            //return;
        }
    }
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if([self CanDoLobbyButtonClick] == NO)
            return;
    }
    
	if(m_Menu && m_bMenuAnimtation == NO)
	{	
		m_bMenuAnimtation = YES;
		if(m_bMenuShow == NO)
		{
            m_Overlay.hidden = NO;
            [self bringSubviewToFront:m_Overlay];
            [self bringSubviewToFront:m_NextButton];
            [self bringSubviewToFront:m_SystemButton];
            [self bringSubviewToFront:m_UndoButton];
            int nCount = [m_Menu GetMenuItemCount];
            if(0 < nCount)
            {
                for(int i = 0; i < nCount; ++i)
                {
                    [self bringSubviewToFront:((UIView*)[m_Menu GetMenuItemAt:i])];
                }	
            }	
            
            m_bMenuShow = YES;
            m_nCachedPoint = GetGamePoint();
            m_nCachedSpeed = GetGameSpeed();
			[m_Menu Show];
		}	
		else
		{
            int nPoint = GetGamePoint();
            int nSpeed = GetGameSpeed();
            if(m_nCachedPoint != nPoint || m_nCachedSpeed != nSpeed)
            {  
                m_bFlagForHideAndPlay = YES;
                m_nCachedPoint = nPoint;
                m_nCachedSpeed = nSpeed;
            }
            else
            {
                m_bFlagForHideAndPlay = NO;
            }
            
			[m_Menu Hide];
		}	
		
		[self setNeedsDisplay];
	}	
    
}

-(void)ShowLobbyStateButtons
{
	m_TextMsgButton.hidden = NO;
    m_Badget.hidden = NO;
    [m_Badget AssignID:[GKLocalPlayer localPlayer].playerID withName:[GKLocalPlayer localPlayer].alias];
    [m_Badget  LoadAppleGameCenterPlayerImage:[GKLocalPlayer localPlayer]];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsGameLobbyMaster] == NO)
    {
        m_SystemButton.enabled = NO;
    }
    else if(pGKDelegate && [pGKDelegate IsGameLobbyMaster] == YES)
    {
        [m_Badget SetMaster:YES];
    }
}

-(void)HideLobbyStateButtons
{
	m_TextMsgButton.hidden = YES;
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsGameLobbyMaster] == NO)
    {
        m_SystemButton.enabled = YES;
    }    
    [m_LobbyButton StopSpin];
    m_LobbyButton.hidden = NO;
    [m_LobbyCloseButton HideButton];
    m_Badget.hidden = YES;
}

-(void)StartGameCenterLobby
{
    NSString* szNewLobby = [StringFactory GetString_CreateNewLobby];
    NSString* szSearch = [StringFactory GetString_SearchLobby];
    NSMutableArray *buttons = [[[NSMutableArray alloc] init] autorelease];
    [buttons addObject:szNewLobby]; 
    [buttons addObject:szSearch];
    
    int nAnswer = [CustomModalAlertView MultChoice:[StringFactory GetString_GameLobby] withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
    
    if(nAnswer == 1)
    {
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate)
        {
            [pGKDelegate StartProcessDewDefaultLobby];
        }
    }
    else if(nAnswer == 2)
    {
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate)
        {
            [pGKDelegate StartProcessSearchLobby];
            [m_LobbyButton StartSpin];
        }
    }
}

-(void)StartGKBTSession
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate StartGKBTSession];
        [m_LobbyButton StartSpin];
    }
}

-(void)LobbyButtonClick
{
    if(m_bMenuShow == YES)
        return;
    
	if([GameScore CheckPaymentState] == NO && ![ApplicationConfigure CanTemporaryAccessPaidFeature])
    {
        NSString* szPaidFeature = [StringFactory GetString_PaidFeature];
        if ([CustomModalAlertView Ask:szPaidFeature withButton1:[StringFactory GetString_NoThanks] withButton2:[StringFactory GetString_Purchase]] == ALERT_OK)
        {
            [GUIEventLoop PostEvent:GUIID_EVENT_PURCHASE];
        }
        else
        {
            [GUIEventLoop PostEvent:GUIID_EVENT_OPENREDEEMVIEWFORONLINEGAME];
        }
        return;
    }
    
    if([ApplicationConfigure IsGameCenterEnable] == YES)
    {    
        NSString* szGameCenter = @"Game Center";
        NSString* szBluetooth = [StringFactory GetString_BlueTooth];
  
        NSArray *buttons = [NSArray arrayWithObjects:szGameCenter,szBluetooth, nil];
        int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
    
        if(nAnswer == 1)
        {
            [self StartGameCenterLobby];
        }
        else if(nAnswer == 2) 
        {
            [self StartGKBTSession];
        }
    }
    else
    {
        NSString* szBluetooth = [StringFactory GetString_BlueTooth];
        
        NSArray *buttons = [NSArray arrayWithObjects:szBluetooth, nil];
        int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
        
        if(nAnswer == 1)
        {
            [self StartGKBTSession];
        }
    }
}

- (void)PopupFreeVersionLobbyOption
{
    if(m_bMenuShow == YES)
        return;
    
    if([ApplicationConfigure IsGameCenterEnable] == YES)
    {    
        NSString* szGameCenter = @"Game Center";
        NSString* szBluetooth = [StringFactory GetString_BlueTooth];
        
        NSArray *buttons = [NSArray arrayWithObjects:szGameCenter,szBluetooth, nil];
        int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
        
        if(nAnswer == 1)
        {
            [self StartGameCenterLobby];
        }
        else if(nAnswer == 2) 
        {
            [self StartGKBTSession];
        }
    }
    else
    {
        NSString* szBluetooth = [StringFactory GetString_BlueTooth];
        
        NSArray *buttons = [NSArray arrayWithObjects:szBluetooth, nil];
        int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
        
        if(nAnswer == 1)
        {
            [self StartGKBTSession];
        }
    }
}

-(void)LobbyCloseButtonClick
{
    if(m_bMenuShow == YES)
        return;
    
    [m_LobbyCloseButton StopSpin];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate ShutdownLobby];
    }
}

-(void)MicphoneButtonClick
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate StartVoiceChat];
    }
//	m_MicButton.hidden = YES;
//	m_MicMuteButton.hidden = NO;
    
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatStartChatMsg:msg];
    if(pGKDelegate)
    {
        [pGKDelegate SendMessageToAllplayers:msg];
    }
    [msg release];
}

-(void)MicphoneMuteButtonClick
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate StopVoiceChat];
    }
//	m_MicButton.hidden = NO;
//	m_MicMuteButton.hidden = YES;
    
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatStopChatMsg:msg];
    if(pGKDelegate)
    {
        [pGKDelegate SendMessageToAllplayers:msg];
    }
    [msg release];
}

-(void)TextMsgButtonClick
{
    if(m_bMenuShow == YES)
        return;
    
    [m_TextMsgEditor CleanTextMessage];
    m_TextMsgEditor.hidden = NO;
    
/*    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatStartWriteMsg:msg];
    if(pGKDelegate)
    {
        [pGKDelegate SendMessageToAllplayers:msg];
    }
    [msg release];*/
}

-(void)OnTextMsgSend:(id)sender
{
    NSString* text = [m_TextMsgEditor GetTextMessage];
    if(text == nil || [text length] == 0)
        return;
    
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatTextMsg:msg withText:text];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate SendMessageToAllplayers:msg];
    }
    [msg release];
    
    m_TextMsgEditor.hidden = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
        [RenderHelper Intialize];
        [CGameLayout Intialize];
        self.backgroundColor = [UIColor clearColor];
        
		m_DealController = [[DealController alloc] initController:self];
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		m_nAnimationLock = 0;
        
        m_Overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight])];
        m_Overlay.backgroundColor = [UIColor lightGrayColor];
        [m_Overlay setAlpha:0.6];
        [self addSubview:m_Overlay];
        m_Overlay.hidden = YES;
        
        float fSize = [GUILayout GetTitleBarHeight];
        
		CGRect rect = CGRectMake((fSize+1), 0, fSize, fSize);
		m_SystemButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_SystemButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_SystemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_SystemButton setBackgroundImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateNormal];
		[m_SystemButton setBackgroundImage:[UIImage imageNamed:@"menuiconhi.png"] forState:UIControlStateHighlighted];
		[m_SystemButton addTarget:self action:@selector(SystemButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_SystemButton];

		rect = CGRectMake(2*(fSize+1), 0, fSize, fSize);
        m_UndoButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_UndoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_UndoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_UndoButton setBackgroundImage:[UIImage imageNamed:@"undoicon.png"] forState:UIControlStateNormal];
		[m_UndoButton setBackgroundImage:[UIImage imageNamed:@"undoiconhi.png"] forState:UIControlStateHighlighted];
		[m_UndoButton addTarget:self action:@selector(UndoButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_UndoButton];
		[self bringSubviewToFront:m_UndoButton];

		
        
		rect = CGRectMake(3*(fSize+1), 0, fSize, fSize);
        m_NextButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_NextButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_NextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticon.png"] forState:UIControlStateNormal];
		[m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticonhi.png"] forState:UIControlStateHighlighted];
		[m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticondisable.png"] forState:UIControlStateDisabled];
		[m_NextButton addTarget:self action:@selector(NextButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_NextButton];
		[self bringSubviewToFront:m_NextButton];

		rect = CGRectMake(0, 0, fSize, fSize);
        
        m_LobbyButton = [[SpinnerBtn alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_LobbyButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_LobbyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_LobbyButton setBackgroundImage:[UIImage imageNamed:@"lobbyicon.png"] forState:UIControlStateNormal];
		[m_LobbyButton addTarget:self action:@selector(LobbyButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_LobbyButton];
        
        
		m_LobbyCloseButton = [[SpinnerBtn alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_LobbyCloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_LobbyCloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_LobbyCloseButton setBackgroundImage:[UIImage imageNamed:@"lobbystopicon.png"] forState:UIControlStateNormal];
		[m_LobbyCloseButton addTarget:self action:@selector(LobbyCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_LobbyCloseButton];
        m_LobbyCloseButton.hidden = YES;
   
		rect = CGRectMake(4*(fSize+1), 0, fSize, fSize);
		m_TextMsgButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_TextMsgButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_TextMsgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_TextMsgButton setBackgroundImage:[UIImage imageNamed:@"txtmsgicon.png"] forState:UIControlStateNormal];
		[m_TextMsgButton addTarget:self action:@selector(TextMsgButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_TextMsgButton];
		m_TextMsgButton.hidden = YES;
        
        float tsx = 4*(fSize+1)+0.5*fSize-[GUILayout GetTextMsgViewWidth]*0.5;
        rect = CGRectMake(tsx, fSize, [GUILayout GetTextMsgViewWidth], [GUILayout GetTextMsgViewHeight]);
        m_TextMsgEditor = [[TextMsgPoster alloc] initWithFrame:rect];
        [m_TextMsgEditor SetAchorAtTop:0.5];
		[self addSubview:m_TextMsgEditor];
		[m_TextMsgEditor release];
        m_TextMsgEditor.hidden = YES;
		[GUIEventLoop RegisterEvent:GUIID_TEXTMESG_SENDBUTTON_CLICK eventHandler:@selector(OnTextMsgSend:) eventReceiver:self eventSender:m_TextMsgEditor];
        
        float dW = [GUILayout GetContentViewWidth]/3.0;
        float dY = [GUILayout GetContentViewHeight];
        float txtWidth = [GUILayout GetMsgBoardViewWidth];
        float dSX = (dW-txtWidth)*0.5; 
        m_Avatar1 = [[GameRobo2 alloc] initWithAchorPoint:CGPointMake(dSX, dY)];
		[self addSubview:m_Avatar1];
		[m_Avatar1 release];
        m_Avatar1.hidden = YES;
        
        dSX += dW; 
        m_Avatar2 = [[GameRobo2 alloc] initWithAchorPoint:CGPointMake(dSX, dY)];
		[self addSubview:m_Avatar2];
		[m_Avatar2 release];
        m_Avatar2.hidden = YES;
        
        dSX += dW; 
        m_Avatar3 = [[GameRobo2 alloc] initWithAchorPoint:CGPointMake(dSX, dY)];
		[self addSubview:m_Avatar3];
		[m_Avatar3 release];
        m_Avatar3.hidden = YES;
     
        
        
        dSX = [GUILayout GetContentViewWidth]-2.5*[CGameLayout GetBulletinUnitSize]; 
        dY = 0;//[GUILayout GetContentViewHeight]/2.0;
        m_Badget = [[PlayerBadget alloc] initWithAchorPoint:CGPointMake(dSX, dY)];
		[self addSubview:m_Badget];
		[m_Badget release];
        m_Badget.hidden = YES;
        
		[self CreateMenu];
		[self bringSubviewToFront:m_SystemButton];
        m_bMenuAnimtation = NO;
        m_bFlagForHideAndPlay = NO;    
		m_nCachedPoint = 24;
        m_nCachedSpeed = GetGameSpeed();
        [self OnPointsChange];
        
        m_nGhostIndex = 0;
        m_fGhostTimerCount = [[NSProcessInfo processInfo] systemUptime];
	}
    return self;
}

- (void)CreateMenu
{
    CGRect rect = CGRectMake(0, 0, [GUILayout GetGlossyMenuSize], [GUILayout GetGlossyMenuSize]);
    GlossyMenuItem*  menuPlay = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_PLAYBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
    [menuPlay RegisterNormalImage:@"playback.png"];
    [menuPlay RegisterHighLightImage:@"playbackhi.png"];
    [menuPlay SetGroundZero:CGPointMake(15, 15)];
    [menuPlay Reset];
    [self AddMenuItem:menuPlay];
    [GUIEventLoop RegisterEvent:GUIID_PLAYBUTTON eventHandler:@selector(OnMenuPlay:) eventReceiver:self eventSender:self];
   
    GlossyMenuItem*  menuTheme = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_THEMEBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
    [menuTheme RegisterNormalImage:@"themeicon.png"];
    [menuTheme RegisterHighLightImage:@"themeiconhi.png"];
    [menuTheme RegisterCheckedImage:@"themeicon2.png"];
    [menuTheme RegisterCheckedHighLightImage:@"themeicon2hi.png"];
    [menuTheme SetGroundZero:CGPointMake(15, 15)];
    [menuTheme Reset];
    BOOL bChecked = !(IsClassicTheme() == 1);
    [menuTheme SetChecked:bChecked];
    [self AddMenuItem:menuTheme];
    [GUIEventLoop RegisterEvent:GUIID_THEMEBUTTON eventHandler:@selector(OnMenuTheme:) eventReceiver:self eventSender:self];
  
    MultiChoiceGlossyMenuItem*  menuBkgnd = [[[MultiChoiceGlossyMenuItem alloc] initWithMeueID:GUIID_BKGNDBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
    [menuBkgnd RegisterMenuImages:@"yellowicon.png" withHigLight:@"yellowiconhi.png"];
    [menuBkgnd RegisterMenuImages:@"greenicon.png" withHigLight:@"greeniconhi.png"];
    [menuBkgnd RegisterMenuImages:@"blueicon.png" withHigLight:@"blueiconhi.png"];
    [menuBkgnd RegisterMenuImages:@"redicon.png" withHigLight:@"rediconhi.png"];
    [menuBkgnd RegisterMenuImages:@"checkicon.png" withHigLight:@"checkiconhi.png"];
    [menuBkgnd RegisterMenuImages:@"woodicon.png" withHigLight:@"woodiconhi.png"];
    [menuBkgnd SetGroundZero:CGPointMake(15, 15)];
    [menuBkgnd Reset];
    [menuBkgnd SetActiveChoice:GetGameBackground()%6];
    [self AddMenuItem:menuBkgnd];
    [GUIEventLoop RegisterEvent:GUIID_BKGNDBUTTON eventHandler:@selector(OnMenuBkGnd:) eventReceiver:self eventSender:self];

    
    
    GlossyMenuItem*  menuPoints = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_POINTSBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
    [menuPoints RegisterNormalImage:@"toolicon.png"];
    [menuPoints RegisterHighLightImage:@"tooliconhi.png"];
    [menuPoints SetGroundZero:CGPointMake(15, 15)];
    [menuPoints Reset];
    [self AddMenuItem:menuPoints];
    [GUIEventLoop RegisterEvent:GUIID_POINTSBUTTON eventHandler:@selector(OnMenuPoints:) eventReceiver:self eventSender:self];
    
    GlossyMenuItem*  menuScore = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_SCOREBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
    [menuScore RegisterNormalImage:@"scoreicon.png"];
    [menuScore RegisterHighLightImage:@"scoreiconhi.png"];
    [menuScore SetGroundZero:CGPointMake(15, 15)];
    [menuScore Reset];
    [self AddMenuItem:menuScore];
    [GUIEventLoop RegisterEvent:GUIID_SCOREBUTTON eventHandler:@selector(OnMenuScore:) eventReceiver:self eventSender:self];
    
    GlossyMenuItem*  menuPost = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_POSTBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
    [menuPost RegisterNormalImage:@"posticon.png"];
    [menuPost RegisterHighLightImage:@"posticonhi.png"];
    [menuPost SetGroundZero:CGPointMake(15, 15)];
    [menuPost Reset];
    [self AddMenuItem:menuPost];
    [GUIEventLoop RegisterEvent:GUIID_POSTBUTTON eventHandler:@selector(OnMenuShare:) eventReceiver:self eventSender:self];
   
    GlossyMenuItem*  menuFriend = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_FRIENDBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
    [menuFriend RegisterNormalImage:@"friendicon.png"];
    [menuFriend RegisterHighLightImage:@"friendiconhi.png"];
    [menuFriend SetGroundZero:CGPointMake(15, 15)];
    [menuFriend Reset];
    [self AddMenuItem:menuFriend];
    [GUIEventLoop RegisterEvent:GUIID_FRIENDBUTTON eventHandler:@selector(OnMenuFriend:) eventReceiver:self eventSender:self];
    
    if([ApplicationConfigure GetAdViewsState] == YES)
    {
        GlossyMenuItem*  menuBuyIt = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_PURCHASEBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
        [menuBuyIt RegisterNormalImage:@"payicon.png"];
        [menuBuyIt RegisterHighLightImage:@"payiconhi.png"];
        [menuBuyIt SetGroundZero:CGPointMake(15, 15)];
        [menuBuyIt Reset];
        [self AddMenuItem:menuBuyIt];
        [GUIEventLoop RegisterEvent:GUIID_PURCHASEBUTTON eventHandler:@selector(OnMenuBuyIt:) eventReceiver:self eventSender:self];
    }
    
    [GUIEventLoop RegisterEvent:GUIID_EVENT_POINTSCHANGED eventHandler:@selector(OnPointsChange) eventReceiver:self eventSender:nil];
    
    [self UpdateMenuLayout];
}

-(void)OnMenuHide
{
	[super OnMenuHide];
	m_bMenuAnimtation = NO;
    [self sendSubviewToBack:m_Overlay];
    m_Overlay.hidden = YES;
    [self bringSubviewToFront:m_NextButton];
    [self bringSubviewToFront:m_SystemButton];
    [self setNeedsDisplay];

    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES && [pGKDelegate IsGameLobbyMaster] == YES)
    {
        [pGKDelegate SynchonzeGameSetting];
        return; 
    }
    
    
    if(m_bFlagForHideAndPlay == YES)
    {
        m_bFlagForHideAndPlay = NO;
        [self StartNewGame];
    }
}

-(void)OnMenuShow
{
	[super OnMenuShow];
	m_bMenuAnimtation = NO;
    [self setNeedsDisplay];
}	

-(void)OnMenuEvent:(int)menuID
{
	[GUIEventLoop SendEvent:menuID eventSender:self];
}	

- (void)OnMenuFriend:(id)sender
{
    [GUIEventLoop SendEvent:GUIID_OPENFRIENDVIEW eventSender:self];
}

-(void)OnMenuPlay:(id)sender
{
    m_bFlagForHideAndPlay = YES;    
	[m_Menu Hide];
}

-(void)OnMenuTheme:(id)sender
{
    if(IsClassicTheme() == 1)
    {
        SetThemeToAnimal();
    }
    else
    {
        SetThemeToClassic();
    }
    BOOL bChecked = !(IsClassicTheme() == 1);
	[[m_Menu GetMenuItem:GUIID_THEMEBUTTON] SetChecked:bChecked];
    [m_DealController SwitchTheme];
}

-(void)OnMenuPoints:(id)sender
{
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENCONFIGUREVIEW eventSender:self];
}

-(void)OnMenuScore:(id)sender
{
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENSCOREVIEW eventSender:self];
}

-(void)OnMenuShare:(id)sender
{
    if([StringFactory IsOSLangZH])
    {    
        [CustomModalAlertView SimpleSay:@"注意：Facebook在某些地区可能被屏蔽，这些地区的玩家可能不能使用Facebook的服务来与其他朋友共享游戏信息" closeButton:[StringFactory GetString_Close]];
    }    
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENSHAREVIEW eventSender:self];
}

-(void)OnMenuBuyIt:(id)sender
{
	[GUIEventLoop PostEvent:GUIID_EVENT_PURCHASE];
}


-(void)OnMenuBkGnd:(id)sender
{
	//[ModalAlert say:@"Background"];
	int n = GetGameBackground();
	n = (n+1)%6;
	SetGameBackground(n);
    [m_DealController SaveBackground];
	[(MultiChoiceGlossyMenuItem*)[m_Menu GetMenuItem:GUIID_BKGNDBUTTON] SetActiveChoice:n];
	[self.superview setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);

    CGRect oprt = [CGameLayout GetOperand1Rect];
	[RenderHelper DrawGhost:context inRect:oprt withIndex:m_nGhostIndex];
    
	oprt = [CGameLayout GetOperand2Rect];
	[RenderHelper DrawGhost:context inRect:oprt withIndex:m_nGhostIndex];
	
	CGContextRestoreGState(context);
}


- (void)dealloc 
{
	[m_DealController release];
	
    [super dealloc];
}

- (int)GetViewType
{
	return GAME_VIEW_DEAL;
}	

- (void)OnTimerEvent
{
	[m_DealController OnTimerEvent];
    if([m_DealController IsGameDealComplete])
    {
        m_nGhostIndex = 0;
    }
    else
    {
        float currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(0.2 <= (currentTime - m_fGhostTimerCount))
        {    
            m_nGhostIndex = (m_nGhostIndex + 1)%4;
            m_fGhostTimerCount = currentTime;
        }    
    }
    
    if([m_Avatar1 IsActive] == YES)
    {
        [m_Avatar1 OnTimeEvent];
    }
    if([m_Avatar2 IsActive] == YES)
    {
        [m_Avatar2 OnTimeEvent];
    }
    if([m_Avatar3 IsActive] == YES)
    {
        [m_Avatar3 OnTimeEvent];
    }
    if([m_Badget IsActive] == YES)
    {
        [m_Badget OnTimeEvent];
    }
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        
        if([pGKDelegate IsGameLobbyMaster] == YES && [m_Badget IsMaster] == NO)
            [m_Badget SetMaster:YES];
        if([pGKDelegate IsGameLobbyMaster] == NO && [m_Badget IsMaster] == YES)
            [m_Badget SetMaster:NO];
        
        /*if([pGKDelegate IsGameLobbyMaster] == NO && [m_Avatar1 IsMaster] == NO && [m_Avatar2 IsMaster] == NO && 
           [m_Avatar3 IsMaster] == NO)
        {    
            NSString* szID = [pGKDelegate GetPlayerIDInRing:0];
            [self SetPlayerAvatarAsMaster:szID];
        }*/
        
        
        if([pGKDelegate IsGameLobbyMaster] == YES)
        {
            if(m_SystemButton.enabled == NO)
                m_SystemButton.enabled = YES; 
        }
        else
        {
            if(m_SystemButton.enabled == YES)
                m_SystemButton.enabled = NO; 
        }
        
        BOOL bCeckNextBtn = [self CanLobbyNextButtonClick];
        if(bCeckNextBtn)
        {
            if(m_NextButton.enabled == NO)
                m_NextButton.enabled = YES; 
        }
        else
        {
            if(m_NextButton.enabled == YES)
                m_NextButton.enabled = NO; 
        }
    }
    else
    {
        if(m_NextButton.enabled == NO)
            m_NextButton.enabled = YES; 
    }
	[self setNeedsDisplay];
}	

- (void)UpdateGameViewLayout
{
	//[super UpdateGameViewLayout];
	[self OnOrientationChange];	
    [self CancelTouchState];

    [m_Overlay setFrame:CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight])];
    
    [m_DealController UpdateGameViewLayout];
    
    
    [m_TextMsgEditor UpdateViewLayout];
    
    
    float dW = [GUILayout GetContentViewWidth]/3.0;
    float dY = [GUILayout GetContentViewHeight];
    float dSX = dW*0.5;//-txtWidth)*0.5; 
    [m_Avatar1 SetAchor:CGPointMake(dSX, dY)];
    
    dSX += dW; 
    [m_Avatar2 SetAchor:CGPointMake(dSX, dY)];
    
    dSX += dW; 
    [m_Avatar3 SetAchor:CGPointMake(dSX, dY)];
    
    
    dSX = [GUILayout GetContentViewWidth]-2.5*[CGameLayout GetBulletinUnitSize]; 
    dY = 0;//[GUILayout GetContentViewHeight]/2.0;
    [m_Badget SetAchor:CGPointMake(dSX, dY)];
    
    [self setNeedsDisplay];
}	

- (void)CancelTouchState
{
    [m_DealController RestoreNonTouchState];   
}

- (void) touchesBegan : (NSSet*)touches withEvent: (UIEvent*)event
{
    if([self IsUIEventLocked])
        return;
	
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if([self CanLobbyNextButtonClick] == NO)
            return;
    }
    
    [m_DealController touchesBegan:touches withEvent:event];
}	

- (void) touchesMoved: (NSSet*)touches withEvent: (UIEvent*)event
{
    if([self IsUIEventLocked])
        return;

    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if([self CanLobbyNextButtonClick] == NO)
            return;
    }
	
    [m_DealController touchesMoved:touches withEvent:event];
}	

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self IsUIEventLocked])
        return;

    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if([self CanLobbyNextButtonClick] == NO)
            return;
    }
	
    [m_DealController touchesEnded:touches withEvent:event];
}	

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[m_DealController touchesCancelled:touches withEvent:event];
}	

- (void)UndoDeal
{
	[m_DealController UndoDeal];
}	

- (void)NextDeal
{
	[m_DealController ForceToNextDeal];
}

- (void)StartNewGame
{
	[m_DealController StartNewGame];
    [self SetMyselfPlayState];
}

- (void)LobbyGameStartNewGame
{
	[m_DealController StartNewLobbyGameWithoutShuffle];
    [self SetMyselfPlayState];
    
}

- (void)SwitchTheme
{
	[m_DealController SwitchTheme];
}

- (BOOL)canBecomeFirstResponder 
{
	return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if([self IsUIEventLocked])
        return;
    
	if(event.subtype == UIEventSubtypeMotionShake)
		[self UndoDeal];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	
}

- (BOOL)GameOverPresentationDone
{
    return YES;
}

-(BOOL)IsUIEventLocked
{
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES || 0 < m_nAnimationLock || [m_DealController InAnimation] == YES)
        return YES;
    
    return NO;
}

-(void)OnPointsChange
{
    int nPoint = GetGamePoint();
    int nSpeed = GetGameSpeed();
    if(m_nCachedPoint != nPoint || m_nCachedSpeed != nSpeed)
    {  
        m_bFlagForHideAndPlay = YES;    
    }    
    [m_DealController SavePoints];
    [m_DealController SaveSpeed];
    [RenderHelper ReloadGhostImage];
    [self setNeedsDisplay];
}

-(void)RemovePurchaseButton
{
    [GUIEventLoop RemoveEvent:GUIID_PURCHASEBUTTON eventReceiver:self eventSender:self];
    [m_Menu RemoveMenuItem:GUIID_PURCHASEBUTTON];
    [self UpdateMenuLayout];
}

- (void)EnableLobbyUI:(BOOL)bEnable
{
	if(m_LobbyButton != nil)
    {
        m_LobbyButton.enabled = bEnable;
    }
	if(m_LobbyCloseButton != nil)
    {
        m_LobbyCloseButton.enabled = bEnable;
    }
}

- (void)OnLobbyStartedEvent
{
    [m_LobbyButton HideButton];
    m_LobbyCloseButton.hidden = NO;
    [self ShowLobbyStateButtons];
	[m_DealController ResetGame];
}

- (void)ResetCurrentPlayingGame
{
	[m_DealController ResetGame];
    [self setNeedsDisplay];
}

- (void)ShowLobbyControls:(BOOL)bShow
{
    if(bShow == NO)
    {
        [self HideLobbyStateButtons];
        if([m_Avatar1 IsActive] == YES)
        {
            [m_Avatar1 Resign];
        }
        if([m_Avatar2 IsActive] == YES)
        {
            [m_Avatar2 Resign];
        }
        if([m_Avatar3 IsActive] == YES)
        {
            [m_Avatar3 Resign];
        }
    }
    else
    {
        [m_Avatar1 SetStateIdle];
        [m_Avatar2 SetStateIdle];
        [m_Avatar3 SetStateIdle];
        [m_Badget SetStateIdle];
    }
}

- (void)HandleDebugMsg:(NSString*)msg
{
    if([ApplicationConfigure IsDebugMode])
    {
        //NSString* szText = m_DebugMsgText.text;
        //szText = [NSString stringWithFormat:@"%@\n%@", szText, msg];
        //[m_DebugMsgText setText: szText];
    }
}

- (void)AddPlayerAvatarInLobby:(NSString*)playerID withName:(NSString*)szName
{
    if([m_Avatar1 IsActive] == NO)
    {
        [m_Avatar1 AssignID:playerID withName:szName];
        return;
    }
    if([m_Avatar2 IsActive] == NO)
    {
        [m_Avatar2 AssignID:playerID withName:szName];
        return;
    }
    if([m_Avatar3 IsActive] == NO)
    {
        [m_Avatar3 AssignID:playerID withName:szName];
        return;
    }
}

- (void)AddMyselfAvatarInLobby:(NSString*)playerID withName:(NSString*)szName
{
    [m_Badget AssignID:playerID withName:szName];
}

- (void)AddPlayerAvatarInLobby2:(GKPlayer*)player
{
    if([m_Avatar1 IsActive] == NO)
    {
        [m_Avatar1 AssignID:player.playerID withName:player.alias];
        [m_Avatar1 LoadAppleGameCenterPlayerImage:player];
        return;
    }
    if([m_Avatar2 IsActive] == NO)
    {
        [m_Avatar2 AssignID:player.playerID withName:player.alias];
        [m_Avatar2 LoadAppleGameCenterPlayerImage:player];
        return;
    }
    if([m_Avatar3 IsActive] == NO)
    {
        [m_Avatar3 AssignID:player.playerID withName:player.alias];
        [m_Avatar3 LoadAppleGameCenterPlayerImage:player];
        return;
    }
}

- (void)RemovePlayerAvatarFromLobby:(NSString*)playerID
{
    if([m_Avatar1 IsActive] == YES && [playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 Resign];
        return;
    }
    if([m_Avatar2 IsActive] == YES && [playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 Resign];
        return;
    }
    if([m_Avatar3 IsActive] == YES && [playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 Resign];
        return;
    }
}

- (void)ShowTextMessage:(NSString*)szText from:(NSString*)playerID
{
    if([m_Avatar1 IsActive] == YES && [playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 SetMessage:szText];
        [m_Avatar1 SetWritting:NO];
        return;
    }
    if([m_Avatar2 IsActive] == YES && [playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 SetMessage:szText];
        [m_Avatar2 SetWritting:NO];
        return;
    }
    if([m_Avatar3 IsActive] == YES && [playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 SetMessage:szText];
        [m_Avatar3 SetWritting:NO];
        return;
    }
}

- (void)PlayerStartWriteTextMessage:(NSString*)playerID
{
    if([m_Avatar1 IsActive] == YES && [playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 SetWritting:YES];
        return;
    }
    if([m_Avatar2 IsActive] == YES && [playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 SetWritting:YES];
        return;
    }
    if([m_Avatar3 IsActive] == YES && [playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 SetWritting:YES];
        return;
    }
}

- (void)PlayerStartTalking:(NSString*)playerID
{
    if([m_Avatar1 IsActive] == YES && [playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 SetSpeaking:YES];
        return;
    }
    if([m_Avatar2 IsActive] == YES && [playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 SetSpeaking:YES];
        return;
    }
    if([m_Avatar3 IsActive] == YES && [playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 SetSpeaking:YES];
        return;
    }
}

- (void)PlayerStopTalking:(NSString*)playerID
{
    if([m_Avatar1 IsActive] == YES && [playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 SetSpeaking:NO];
        return;
    }
    if([m_Avatar2 IsActive] == YES && [playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 SetSpeaking:NO];
        return;
    }
    if([m_Avatar3 IsActive] == YES && [playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 SetSpeaking:NO];
        return;
    }
}

- (BOOL)SetPlayerAvatarAsMaster:(NSString*)playerID
{
    if([m_Avatar1 IsActive] == NO && [m_Avatar2 IsActive] == NO && [m_Avatar3 IsActive] == NO && [m_Badget IsActive] == NO)
        return NO;
    
    if([m_Avatar1 IsActive] == YES && [playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 SetMaster:YES];
    }
    else
    {
        [m_Avatar1 SetMaster:NO];
    }
    
    if([m_Avatar2 IsActive] == YES && [playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 SetMaster:YES];
    }
    else
    {
        [m_Avatar2 SetMaster:NO];
    }
    
    if([m_Avatar3 IsActive] == YES && [playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 SetMaster:YES];
    }
    else
    {
        [m_Avatar3 SetMaster:NO];
    }
    if([m_Badget IsActive] == YES && [playerID isEqualToString:[m_Badget GetPlayerID]] == YES)
    {
        [m_Badget SetMaster:YES];
    }
    else
    {
        [m_Badget SetMaster:NO];
    }
    return YES;
}

- (BOOL)SetPlayerAvatarHighLight:(NSString*)playerID
{
   
    return YES;
}

- (BOOL)IsPlayerAvatarHighLight:(NSString*)playerID
{
    return NO;
}

- (BOOL)HasAvatar
{
    if([m_Avatar1 IsActive] == YES || [m_Avatar2 IsActive] == YES || [m_Avatar3 IsActive] == YES)
        return YES;
    return NO;
}

- (void)UpdateActivePlayerScore
{
/*    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if(m_Badget && [m_Badget IsActive] == YES)
        {    
            [m_Badget UpdateScore];
            int nBest = [m_Badget GetScore];
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_SCOREUPDATE];
            [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAMESCORE_BEST withInteger:nBest];
            
            [GameMsgFormatter EndFormatMsg:msg];
            [pGKDelegate SendMessageToAllplayers:msg];
            [msg release];
        }
    }*/   
}

- (void)SetPlayerBestScore:(NSString*)playerID withScore:(int)nBest
{
    if([m_Avatar1 IsActive] == YES && [playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 SetScore:nBest];
        return;
    }
    if([m_Avatar2 IsActive] == YES && [playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 SetScore:nBest];
        return;
    }
    if([m_Avatar3 IsActive] == YES && [playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 SetScore:nBest];
        return;
    }
    if([m_Badget IsActive] == YES && [playerID isEqualToString:[m_Badget GetPlayerID]] == YES)
    {
        [m_Badget SetScore:nBest];
        return;
    }
}

- (void)SetGamePlayerResult:(NSString*)playerID withResult:(int)nResult
{
    if([playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        if(nResult == GAMEMSG_VALUE_GAMEWIN)
            [m_Avatar1 SetStateWin];
        else
            [m_Avatar1 SetStateLose];
        
        [self HandleLobbyGameComplete];
        return;
    }
    if([playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        if(nResult == GAMEMSG_VALUE_GAMEWIN)
            [m_Avatar2 SetStateWin];
        else
            [m_Avatar2 SetStateLose];
        [self HandleLobbyGameComplete];
        return;
    }
    if([playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        if(nResult == GAMEMSG_VALUE_GAMEWIN)
            [m_Avatar3 SetStateWin];
        else
            [m_Avatar3 SetStateLose];
        [self HandleLobbyGameComplete];
        return;
    }
    if([playerID isEqualToString:[m_Badget GetPlayerID]] == YES)
    {
        if(nResult == GAMEMSG_VALUE_GAMEWIN)
            [m_Badget SetStateWin];
        else
            [m_Badget SetStateLose];
        [self HandleLobbyGameComplete];
        return;
    }
}

- (void)SetLobbyGameCardList:(NSArray*)array
{
    if(m_DealController != nil /*&& [m_DealController IsGameComplete] == YES*/)
    {
        [m_DealController SetNewGameFromFormatArray:array];
        
        if([m_Avatar1 IsActive] == YES)
        {
            [m_Avatar1 SetStatePlay];
        }
        if([m_Avatar2 IsActive] == YES)
        {
            [m_Avatar2 SetStatePlay];
        }
        if([m_Avatar2 IsActive] == YES)
        {
            [m_Avatar2 SetStatePlay];
        }
    }
}

- (void)SetGamePlayerWinResult:(NSString*)playerID withResult:(NSArray*)array
{
    DealResult* pResult = [[[DealResult alloc] init] autorelease];
    [pResult FromFormatArray:array];
    float width = 5*[CGameLayout GetCardWidth]; 
    float height = [CGameLayout GetCardHeight];

    CGImageRef image1 = NULL;
    CGImageRef image2 = NULL;
    CGImageRef image3 = NULL;
    CardEquation* pEq = [pResult GetEquation:0];
    if(pEq != nil)
    {
        image1 = [pEq GetSnapshot:width withHeight:height];
    }
    pEq = [pResult GetEquation:1];
    if(pEq != nil)
    {
        image2 = [pEq GetSnapshot:width withHeight:height];
    }
    pEq = [pResult GetEquation:2];
    if(pEq != nil)
    {
        image3 = [pEq GetSnapshot:width withHeight:height];
    }
    /*pEq = [pResult GetEquation:3];
    if(pEq != nil)
    {
        image4 = [pEq GetSnapshot:width withHeight:height];
    }*/
    
    if([playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 ResetScoreBoardImages];
        if(image1 != NULL)
        {
            [m_Avatar1 SetImage1:image1];
        }
        if(image2 != NULL)
        {
            [m_Avatar1 SetImage2:image2];
        }
        if(image3 != NULL)
        {
            [m_Avatar1 SetImage3:image3];
        }
        [m_Avatar1 SetStateWin];
        [m_Avatar1 UpdateScore];
        [m_Avatar1 OpenScoreBoard];
    }
    if([playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 ResetScoreBoardImages];
        if(image1 != NULL)
        {
            [m_Avatar2 SetImage1:image1];
        }
        if(image2 != NULL)
        {
            [m_Avatar2 SetImage2:image2];
        }
        if(image3 != NULL)
        {
            [m_Avatar2 SetImage3:image3];
        }
        [m_Avatar2 SetStateWin];
        [m_Avatar2 UpdateScore];
        [m_Avatar2 OpenScoreBoard];
    }
    if([playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 ResetScoreBoardImages];
        if(image1 != NULL)
        {
            [m_Avatar3 SetImage1:image1];
        }
        if(image2 != NULL)
        {
            [m_Avatar3 SetImage2:image2];
        }
        if(image3 != NULL)
        {
            [m_Avatar3 SetImage3:image3];
        }
        [m_Avatar3 SetStateWin];
        [m_Avatar3 UpdateScore];
        [m_Avatar3 OpenScoreBoard];
    }
    if([m_Badget GetState] == ROBO_STATE_PLAY)
    {
        [m_DealController ForceToNextDeal];
        [m_DealController ResetLobbyGameDeal];
    }
    [self HandleLobbyGameDealEndProcess];
}

- (void)SetGamePlayerLoseResult:(NSString*)playerID
{
    if([playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 SetStateLose];
        [m_Avatar1 ResetScoreBoardImages];
        if([m_DealController IsGameComplete])
        {
            [m_Avatar1 OpenScoreBoard];
        }
    }
    if([playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 SetStateLose];
        [m_Avatar2 ResetScoreBoardImages];
        if([m_DealController IsGameComplete])
        {
            [m_Avatar2 OpenScoreBoard];
        }
    }
    if([playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 SetStateLose];
        [m_Avatar3 ResetScoreBoardImages];
        if([m_DealController IsGameComplete])
        {
            [m_Avatar3 OpenScoreBoard];
        }
    }
    [self HandleLobbyGameDealEndProcess];
}

- (void)SetGamePlayerState:(NSString *)playerID withState:(int)nState
{
    if([playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        [m_Avatar1 SetState:nState];
    }
    if([playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        [m_Avatar2 SetState:nState];
    }
    if([playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        [m_Avatar3 SetState:nState];
    }
    [self HandleLobbyGameDealEndProcess];
}

- (void)HandleLobbyGameNextDeal
{
    if(m_DealController != nil && [m_DealController IsGameComplete] == NO)
    {
        if([m_DealController IsGameDealComplete] == YES)
            [m_DealController GoToNextDeal];
        else
            [m_DealController MoveOutOldDeal];
        
        [self SetMyselfPlayState];
    }
}

- (void)SetMyselfResultStateAs:(BOOL)bWin withResult:(DealResult*)pResult
{
    if(bWin)
    {    
        [m_Badget ResetScoreBoardImages];
        float width = 5*[CGameLayout GetCardWidth]; 
        float height = [CGameLayout GetCardHeight];
        
        CardEquation* pEq = [pResult GetEquation:0];
        CGImageRef image1 = NULL;
        CGImageRef image2 = NULL;
        CGImageRef image3 = NULL;
        if(pEq != nil)
        {
            image1 = [pEq GetSnapshot:width withHeight:height];
            [m_Badget SetImage1:image1];
        }
        pEq = [pResult GetEquation:1];
        if(pEq != nil)
        {
            image2 = [pEq GetSnapshot:width withHeight:height];
            [m_Badget SetImage2:image2];
        }
        pEq = [pResult GetEquation:2];
        if(pEq != nil)
        {
            image3 = [pEq GetSnapshot:width withHeight:height];
            [m_Badget SetImage3:image3];
        }
        
        [m_Badget SetStateWin];
        [m_Badget UpdateScore];
        [m_Badget OpenScoreBoard];
    }    
    else
    {    
        [m_Badget ResetScoreBoardImages];
        [m_Badget SetStateLose];
        if([m_DealController IsGameComplete])
        {
            [m_Badget OpenScoreBoard];
        }
    }    
    [m_DealController ResetLobbyGameDeal];
}

- (int)NomiateGKCenterMasterInPeerToPeer
{
    int nRet = -1;
    
    if(![self HasAvatar])
        return nRet;
    
 
    NSString* strFirstPlayerID = @"";
    if(m_Badget && [m_Badget IsActive])
    {
        nRet = 0;
        strFirstPlayerID = [m_Badget GetPlayerID];
    }
    if(m_Avatar1 && [m_Avatar1 IsActive] == YES)
    {
        if([strFirstPlayerID compare:[m_Avatar1 GetPlayerID] options:NSNumericSearch] == NSOrderedAscending)
        {
            nRet = 1;
            strFirstPlayerID = [m_Avatar1 GetPlayerID];
        }
    }
    if(m_Avatar2 && [m_Avatar2 IsActive] == YES)
    {
        if([strFirstPlayerID compare:[m_Avatar2 GetPlayerID] options:NSNumericSearch] == NSOrderedAscending)
        {
            nRet = 2;
            strFirstPlayerID = [m_Avatar2 GetPlayerID];
        }
    }
    if(m_Avatar3 && [m_Avatar3 IsActive] == YES)
    {
        if([strFirstPlayerID compare:[m_Avatar3 GetPlayerID] options:NSNumericSearch] == NSOrderedAscending)
        {
            nRet = 3;
            strFirstPlayerID = [m_Avatar3 GetPlayerID];
        }
    }
    return nRet;
}

- (BOOL)IsMySelfActive
{
    return [m_Badget IsActive];
}

- (BOOL)IsPlayer1Active
{
    return [m_Avatar1 IsActive];
}

- (BOOL)IsPlayer2Active
{
    return [m_Avatar2 IsActive];
}

- (BOOL)IsPlayer3Active
{
    return [m_Avatar3 IsActive];
}

- (NSString*)GetMyPlayerID
{
    return [m_Badget GetPlayerID];
}

- (NSString*)GetPlayer1PlayerID
{
    return [m_Avatar1 GetPlayerID];
}

- (NSString*)GetPlayer2PlayerID
{
    return [m_Avatar2 GetPlayerID];
}

- (NSString*)GetPlayer3PlayerID
{
    return [m_Avatar3 GetPlayerID];
}

- (void)SetMyselfPlayState
{
    if([m_Badget IsActive] == YES)
    {
        [m_Badget SetStatePlay];
    }
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        GameMessage* msg = [[GameMessage alloc] init];
        [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMEPLAYSTATECHANGE];
        int nState = [m_Badget GetState];
        [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAMEPLAYERSTATE withInteger:nState];
        [GameMsgFormatter EndFormatMsg:msg];
        [pGKDelegate SendMessageToAllplayers:msg];
        [msg release];
    }     
}

- (void)HandleLobbyGameComplete
{
    if([m_Avatar1 IsActive] == YES)
    {
        [m_Avatar1 OpenScoreBoard];
    }
    if([m_Avatar2 IsActive] == YES)
    {
        [m_Avatar2 OpenScoreBoard];
    }
    if([m_Avatar2 IsActive] == YES)
    {
        [m_Avatar2 OpenScoreBoard];
    }
    if([m_Badget IsActive] == YES)
    {
        [m_Badget OpenScoreBoard];
    }
    
}

- (void)HandleLobbyGameDealEndProcess
{
    int nSpeed = GetGameSpeed();
    if(nSpeed == GAME_SPEED_NONE)
        return;
 
    if([m_DealController IsGameComplete])
    {
        [self HandleLobbyGameComplete];
    }
    
    if([m_Avatar1 IsActive] == YES && ([m_Avatar1 GetState] != ROBO_STATE_LOSE | [m_Avatar1 GetState] != ROBO_STATE_WIN))
    {
         return;
    }
    if([m_Avatar2 IsActive] == YES && ([m_Avatar2 GetState] != ROBO_STATE_LOSE | [m_Avatar2 GetState] != ROBO_STATE_WIN))
    {
        return;
    }
    if([m_Avatar3 IsActive] == YES && ([m_Avatar3 GetState] != ROBO_STATE_LOSE | [m_Avatar3 GetState] != ROBO_STATE_WIN))
    {
        return;
    }
    if([m_Badget IsActive] == YES && ([m_Badget GetState] != ROBO_STATE_LOSE | [m_Badget GetState] != ROBO_STATE_WIN))
    {
        return;
    }
    
    if([m_DealController IsGameComplete])
    {
        [self HandleLobbyGameComplete];
        return;
    }
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        if([pGKDelegate IsGameLobbyMaster] == YES)
        {    
            [self GoToNextLobbyDeal];
        }
    }    
}

-(void)StopLobbyButtonSpin
{
    if(m_LobbyButton.hidden == NO && [m_LobbyButton IsSpinning] == YES)
        [m_LobbyButton StopSpin];
}
@end
