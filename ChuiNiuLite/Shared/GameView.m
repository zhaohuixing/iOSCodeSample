//
//  GameView.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-27.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "ApplicationConfigure.h"
#import "TextMsgPoster.h"
#import "GameRobo.h"
#import "PlayerBadget.h"
#import "SpinnerBtn.h"
#import "GameView.h"
#import "GameScene.h"
#import "SoundSource.h"
#import "Configuration.h"
#import "ImageLoader.h"
#import "GUILayout.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "MultiChoiceGlossyMenuItem.h"
#import "ScoreRecord.h"
#import "GameCenterConstant.h"
#import "GameMsgConstant.h"
#import "GameMessage.h"
#import "GameMsgFormatter.h"
#import "StringFactory.h"
#import "CustomModalAlertView.h"

#define POINT(X)	[[points objectAtIndex:X] locationInView:self]

@implementation GameView

@synthesize m_Game;
@synthesize m_nLoseSceneFlash;

- (BOOL)canBecomeFirstResponder 
{
	return YES;
}

- (BOOL)CanDoLobbyButtonClick
{
    BOOL bRet = NO;
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        if([pGKDelegate IsGameLobbyMaster] == NO)
            return NO;
        
        if([pGKDelegate IsGameLobbyMaster] && isGamePlayPlaying() == 1)
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

- (void)HideNonMenuButtons
{
    m_PlayButton.hidden = YES;
    m_LobbyButton.hidden = YES;
    m_HelpButton.hidden = YES;
    m_FingerButton.hidden = YES;
    m_MouthButton.hidden = YES;
    m_SystemButton.hidden = NO;
}

- (void)ShowNonMenuButtons
{
    m_HelpButton.hidden = NO;
    m_PlayButton.hidden = NO;
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == NO)
    {
        if([ApplicationConfigure IsGameCenterEnable] == YES)
            m_LobbyButton.hidden = NO;
    }    
    m_SystemButton.hidden = NO;
    if([Configuration isUseFacialGesture])
    {
        m_FingerButton.hidden = NO;
        m_MouthButton.hidden = YES;
    }
    else
    {
        m_FingerButton.hidden = YES;
        m_MouthButton.hidden = NO;
    }
}


- (void)SystemButtonClick
{
    if([ApplicationConfigure GetAdViewsState] && isDisplayAD() == 1)
        return;
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        if([self CanDoLobbyButtonClick] == NO)
            return;
        
        //if([pGKDelegate IsGameCenterReporting])
        //    return;
        
        if([pGKDelegate IsGameLobbyMaster] && isGamePlayPlaying() == 1)
            return; 
        
        if([pGKDelegate IsGameLobbyMaster] == NO && [pGKDelegate IsInLobby] == YES)
            return; 
    }
    
	if(m_Menu && m_bMenuAnimtation == NO)
	{	
		m_bMenuAnimtation = YES;
		if(m_bMenuShow == NO)
		{
			if(isGamePlayPlaying() == 1)
			{
				[self pauseGame];
			}
            m_bMenuShow = YES;
			[self HideNonMenuButtons];
            [m_Menu Show];
		}	
		else
		{
			[m_Menu Hide];
			[self ShowNonMenuButtons];
		}
		
		[self invalidate];
	}	
}	

-(void)PlayButtonClick
{
    if(m_bMenuShow == YES)
        return;
   
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {    
        if([self CanDoLobbyButtonClick] == NO)
            return;
        
        if([pGKDelegate IsGameLobbyMaster] == YES)
        {
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMEPLAYSTART];
            [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAMESTART withInteger:0];
            [GameMsgFormatter EndFormatMsg:msg];
            [pGKDelegate SendMessageToAllplayers:msg];
            [msg release];
            [self startGame];
        }
        return; 
    }
    
	if(isGameResult() == 1)
    {
        if([ApplicationConfigure GetAdViewsState] == YES && isDisplayAD() == 1)
        {
            return;
        }
        
        if((isGameResultWin() == 1 && [SoundSource IsPlayWin] == NO) ||
           (isGameResultLose() == 1 && [SoundSource IsPlayLose] == NO))
        {    
            [self startGame];
        }
        else
        {
            return;
        }
    }
    else
    {
        [self startGame];
    }
}

-(void)HelpButtonClick
{
    [GUIEventLoop SendEvent:GUIID_EVENT_OPENHELPVIEW eventSender:nil];
}

-(void)MouthButtonClick
{
    if(m_bMenuShow == YES)
        return;

    [Configuration setUseFacialGesture:YES];
    
    if([Configuration isUseFacialGesture])
    {
        m_FingerButton.hidden = NO;
        m_MouthButton.hidden = YES;
    }
    else
    {
        m_FingerButton.hidden = YES;
        m_MouthButton.hidden = NO;
    }
    
    [self setNeedsDisplay];
}

-(void)FingerButtonClick
{
    if(m_bMenuShow == YES)
        return;

    [Configuration setUseFacialGesture:NO];
    if([Configuration isUseFacialGesture])
    {
        m_FingerButton.hidden = NO;
        m_MouthButton.hidden = YES;
    }
    else
    {
        m_FingerButton.hidden = YES;
        m_MouthButton.hidden = NO;
    }
    [self setNeedsDisplay];
}

-(void)StartNewLobbyGame
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {    
        if([pGKDelegate IsGameLobbyMaster] == YES)
        {
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMEPLAYSTART];
            [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAMESTART withInteger:0];
            [GameMsgFormatter EndFormatMsg:msg];
            [pGKDelegate SendMessageToAllplayers:msg];
            [msg release];
            [self startGame];
        }
        return; 
    }
}

-(void)ShowLobbyStateButtons
{
	m_MicButton.hidden = NO;
	m_MicMuteButton.hidden = YES;
	m_TextMsgButton.hidden = NO;
    m_Badget.hidden = NO;
    [m_Badget AssignID:[GKLocalPlayer localPlayer].playerID withName:[GKLocalPlayer localPlayer].alias];
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
	m_MicButton.hidden = YES;
	m_MicMuteButton.hidden = YES;
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

-(void)HideNonPlayingButtons
{
    m_HelpButton.hidden = YES;
    m_SystemButton.hidden = YES;
    m_FingerButton.hidden = YES;
    m_MouthButton.hidden = YES;
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == NO)
    {
        m_LobbyButton.hidden = YES;
    }    
}

-(void)ShowNonPlayingButtons
{
    m_HelpButton.hidden = NO;
    m_SystemButton.hidden = NO;
    if([Configuration isUseFacialGesture])
    {
        m_FingerButton.hidden = NO;
        m_MouthButton.hidden = YES;
    }
    else
    {
        m_FingerButton.hidden = YES;
        m_MouthButton.hidden = NO;
    }
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == NO)
    {
        if([ApplicationConfigure IsGameCenterEnable] == YES || [pGKDelegate IsAWSMessagerEnabled])
            m_LobbyButton.hidden = NO;
    }    
}

-(void)ShowLobbyButton
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == NO)
    if((isGamePlayPlaying() == 1 || isGamePlayPaused() == 1) && ((pGKDelegate && [pGKDelegate IsInLobby] == NO) || [pGKDelegate IsAWSMessagerEnabled]))
    {
        m_LobbyButton.hidden = YES;
        return;
    }
    m_LobbyButton.hidden = NO;
}

-(void)HideLobbyButton
{
    m_LobbyButton.hidden = YES;
}

-(void)LobbyButtonClickForGameCenter
{
    NSString* szNewLobby = [StringFactory GetString_CreateNewLobby];
    NSString* szSearch = [StringFactory GetString_SearchLobby];
    NSMutableArray *buttons = [[[NSMutableArray alloc] init] autorelease];
    [buttons addObject:szNewLobby]; 
    [buttons addObject:szSearch];
    
    //int nAnswer = [ModalAlert ask:[StringFactory GetString_GameLobby] withCancel:@"Cancel" withButtons:buttons];
    int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
    
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

-(void)LobbyButtonClick
{
    if(m_bMenuShow == YES)
        return;
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsAWSMessagerEnabled] == NO)
    {
        [self LobbyButtonClickForGameCenter];
        return;
    }
    else if(pGKDelegate && [pGKDelegate IsAWSMessagerEnabled] == YES && [ApplicationConfigure IsGameCenterEnable] == NO)
    {
        [GUIEventLoop SendEvent:GUIID_EVENT_OPENONLINEGAMERSTATUSVIEW eventSender:nil];
    }
    else
    {
        NSString* szRewiew = [StringFactory GetString_ReviewGamerOnlineStatus];
        NSString* szStartOlineGame = [StringFactory GetString_StartOnlineGame];
        NSMutableArray *buttons = [[[NSMutableArray alloc] init] autorelease];
        [buttons addObject:szRewiew]; 
        [buttons addObject:szStartOlineGame];
        
        //int nAnswer = [ModalAlert ask:[StringFactory GetString_GameLobby] withCancel:@"Cancel" withButtons:buttons];
        int nAnswer = [CustomModalAlertView MultChoice:nil withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
        
        if(nAnswer == 1)
        {
            [GUIEventLoop SendEvent:GUIID_EVENT_OPENONLINEGAMERSTATUSVIEW eventSender:nil];
        }
        else if(nAnswer == 2)
        {
            [self LobbyButtonClickForGameCenter];
            return;
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
	m_MicButton.hidden = YES;
	m_MicMuteButton.hidden = NO;
    
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
	m_MicButton.hidden = NO;
	m_MicMuteButton.hidden = YES;
    
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
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatStartWriteMsg:msg];
    if(pGKDelegate)
    {
        [pGKDelegate SendMessageToAllplayers:msg];
    }
    [msg release];
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

- (void)OnMenuFriend:(id)sender
{
    [GUIEventLoop SendEvent:GUIID_OPENFRIENDVIEW eventSender:self];
}


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
		[SoundSource InitializeSoundSource:self];
		m_nLoseSceneFlash = 0;
		self.backgroundColor = [UIColor clearColor];
		m_Game = [[GameScene alloc]init];
        m_Game.m_GameView = self;
   
        float fSize = [GUILayout GetTitleBarHeight];
		CGRect rect = CGRectMake(0, 0, fSize, fSize);
		m_SystemButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_SystemButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_SystemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_SystemButton setBackgroundImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateNormal];
		[m_SystemButton setBackgroundImage:[UIImage imageNamed:@"menuiconhi.png"] forState:UIControlStateHighlighted];
		[m_SystemButton addTarget:self action:@selector(SystemButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_SystemButton];
	
		rect = CGRectMake([GUILayout GetMainUIWidth]-(fSize+1), [GUILayout GetContentViewHeight]-fSize*1.5, fSize, fSize);
		
        m_PlayButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_PlayButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_PlayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_PlayButton setBackgroundImage:[UIImage imageNamed:@"playbtn.png"] forState:UIControlStateNormal];
		[m_PlayButton setBackgroundImage:[UIImage imageNamed:@"playbtnhi.png"] forState:UIControlStateHighlighted];
		[m_PlayButton addTarget:self action:@selector(PlayButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_PlayButton];
    
        
//        UIButton*				m_HelpButton;
		rect = CGRectMake((fSize+1), 0, fSize, fSize);
        m_HelpButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_HelpButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_HelpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_HelpButton setBackgroundImage:[UIImage imageNamed:@"qbutton.png"] forState:UIControlStateNormal];
		[m_HelpButton setBackgroundImage:[UIImage imageNamed:@"qbuttonhi.png"] forState:UIControlStateHighlighted];
		[m_HelpButton addTarget:self action:@selector(HelpButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_HelpButton];
        
		rect = CGRectMake(2.0*(fSize+1), 0, fSize, fSize);

        m_MouthButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_MouthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_MouthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_MouthButton setBackgroundImage:[UIImage imageNamed:@"mbutton.png"] forState:UIControlStateNormal];
		[m_MouthButton setBackgroundImage:[UIImage imageNamed:@"mbutton.png"] forState:UIControlStateHighlighted];
		[m_MouthButton addTarget:self action:@selector(MouthButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_MouthButton];

        m_FingerButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_FingerButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_FingerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_FingerButton setBackgroundImage:[UIImage imageNamed:@"fbutton.png"] forState:UIControlStateNormal];
		[m_FingerButton setBackgroundImage:[UIImage imageNamed:@"fbutton.png"] forState:UIControlStateHighlighted];
		[m_FingerButton addTarget:self action:@selector(FingerButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_FingerButton];
        
        if([Configuration isUseFacialGesture])
        {
            m_FingerButton.hidden = NO;
            m_MouthButton.hidden = YES;
        }
        else
        {
            m_FingerButton.hidden = YES;
            m_MouthButton.hidden = NO;
        }
        
		rect = CGRectMake(3.0*(fSize+1), 0, fSize, fSize);
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
		m_MicButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_MicButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_MicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_MicButton setBackgroundImage:[UIImage imageNamed:@"micicon.png"] forState:UIControlStateNormal];
		[m_MicButton addTarget:self action:@selector(MicphoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_MicButton];
		m_MicButton.hidden = YES;
        
		m_MicMuteButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_MicMuteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_MicMuteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_MicMuteButton setBackgroundImage:[UIImage imageNamed:@"micmuteicon.png"] forState:UIControlStateNormal];
		[m_MicMuteButton addTarget:self action:@selector(MicphoneMuteButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_MicMuteButton];
		m_MicMuteButton.hidden = YES;
        
		rect = CGRectMake(5*(fSize+1), 0, fSize, fSize);
		m_TextMsgButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_TextMsgButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_TextMsgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_TextMsgButton setBackgroundImage:[UIImage imageNamed:@"txtmsgicon.png"] forState:UIControlStateNormal];
		[m_TextMsgButton addTarget:self action:@selector(TextMsgButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_TextMsgButton];
		m_TextMsgButton.hidden = YES;
        
        float tsx = 70.0;
        if([ApplicationConfigure iPADDevice])
        {
            tsx = 180.0;
        }
        //tsx = tsx-fSize;
        rect = CGRectMake(tsx, fSize, [GUILayout GetTextMsgViewWidth], [GUILayout GetTextMsgViewHeight]);
        m_TextMsgEditor = [[TextMsgPoster alloc] initWithFrame:rect];
        [m_TextMsgEditor SetAchorAtTop:0.5];//0.32];
		[self addSubview:m_TextMsgEditor];
		[m_TextMsgEditor release];
        m_TextMsgEditor.hidden = YES;
		[GUIEventLoop RegisterEvent:GUIID_TEXTMESG_SENDBUTTON_CLICK eventHandler:@selector(OnTextMsgSend:) eventReceiver:self eventSender:m_TextMsgEditor];
    
        float dW = [GUILayout GetContentViewWidth];//[GUILayout GetContentViewWidth]/3.0;
        float dY = [GUILayout GetContentViewHeight]/4.0;//[GUILayout GetContentViewHeight];
        //float txtWidth = [GUILayout GetMsgBoardViewWidth];
        float dSX = dW;//(dW-txtWidth)*0.5; 
        m_Avatar1 = [[GameRobo2 alloc] initWithAchorPoint:CGPointMake(dSX, dY)];
		[self addSubview:m_Avatar1];
		[m_Avatar1 release];
        m_Avatar1.hidden = YES;
        
        dY += dY; //dSX += dW; 
        m_Avatar2 = [[GameRobo2 alloc] initWithAchorPoint:CGPointMake(dSX, dY)];
		[self addSubview:m_Avatar2];
		[m_Avatar2 release];
        m_Avatar2.hidden = YES;
        
        dY += dY; //dSX += dW; 
        m_Avatar3 = [[GameRobo2 alloc] initWithAchorPoint:CGPointMake(dSX, dY)];
		[self addSubview:m_Avatar3];
		[m_Avatar3 release];
        m_Avatar3.hidden = YES;
        
        dSX = 0; //[GUILayout GetContentViewWidth]-[GUILayout GetMsgBoardViewWidth]*0.5; 
        dY = [GUILayout GetContentViewHeight]/2.0;
        m_Badget = [[PlayerBadget alloc] initWithAchorPoint:CGPointMake(dSX, dY)];
		[self addSubview:m_Badget];
		[m_Badget release];
        m_Badget.hidden = YES;
  
		[self CreateMenu];
		[self bringSubviewToFront:m_SystemButton];
		m_bMenuAnimtation = NO;
        
            
		[GUIEventLoop RegisterEvent:GUIID_EVENT_RESETGAME eventHandler:@selector(resetGame) eventReceiver:self eventSender:nil];
        
	}
    return self;
}

- (void)CreateMenu
{
	if(m_Menu)
	{
		CGRect rect = CGRectMake(0, 0, [GUILayout GetGlossyMenuSize], [GUILayout GetGlossyMenuSize]);
		GlossyMenuItem*  menuPlay = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_PLAYBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
		[menuPlay RegisterNormalImage:@"playback.png"];
		[menuPlay RegisterHighLightImage:@"playbackhi.png"];
		[menuPlay SetGroundZero:CGPointMake(15, 15)];
		[menuPlay Reset];
		[self AddMenuItem:menuPlay];
		[GUIEventLoop RegisterEvent:GUIID_PLAYBUTTON eventHandler:@selector(OnMenuPlay:) eventReceiver:self eventSender:self];
		
		GlossyMenuItem*  menuSound = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_SOUNDBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
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
		
		MultiChoiceGlossyMenuItem*  menuBkgnd = [[[MultiChoiceGlossyMenuItem alloc] initWithMeueID:GUIID_BKGNDBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
		[menuBkgnd RegisterMenuImages:@"dayicon.png" withHigLight:@"dayiconhi.png"];
		[menuBkgnd RegisterMenuImages:@"checkicon.png" withHigLight:@"checkiconhi.png"];
		[menuBkgnd RegisterMenuImages:@"nighticon.png" withHigLight:@"nighticonhi.png"];
		[menuBkgnd SetGroundZero:CGPointMake(15, 15)];
		[menuBkgnd Reset];
		[menuBkgnd SetActiveChoice:[Configuration getBackgroundSetting]];
		[self AddMenuItem:menuBkgnd];
		[GUIEventLoop RegisterEvent:GUIID_BKGNDBUTTON eventHandler:@selector(OnMenuBkGnd:) eventReceiver:self eventSender:self];
		
		GlossyMenuItem*  menuLevel = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_LEVELBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
		[menuLevel RegisterNormalImage:@"toolicon.png"];
		[menuLevel RegisterHighLightImage:@"tooliconhi.png"];
		[menuLevel SetGroundZero:CGPointMake(15, 15)];
		[menuLevel Reset];
		[self AddMenuItem:menuLevel];
		[GUIEventLoop RegisterEvent:GUIID_LEVELBUTTON eventHandler:@selector(OnMenuSetting:) eventReceiver:self eventSender:self];
		
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
		
		GlossyMenuItem*  menuClock = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_CLOCKBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
		[menuClock RegisterNormalImage:@"clockicon.png"];
		[menuClock RegisterHighLightImage:@"clockiconhi.png"];
		[menuClock SetGroundZero:CGPointMake(15, 15)];
		[menuClock Reset];
		[self AddMenuItem:menuClock];
		[GUIEventLoop RegisterEvent:GUIID_CLOCKBUTTON eventHandler:@selector(OnMenuClock:) eventReceiver:self eventSender:self];
		
   
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
        
		[self UpdateMenuLayout];
	}	
}	

-(void)OnMenuHide
{
	[super OnMenuHide];
	m_bMenuAnimtation = NO;
    
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES && [pGKDelegate IsGameLobbyMaster] == YES)
    {
        [pGKDelegate SynchonzeGameSetting];
        return; 
    }
    
	if(isGamePlayPaused() == 1)
	{
        if([Configuration isDirty] == YES)
            [self startGame];
        else    
            [self resumeGame];
	}	
    else if(isGamePlayReady() == 1) 
	{	
		[self startGame];
	}
    else if(isGameResult() == 1)
    {
		[self startGame];
    }
	
	[self invalidate];
}

-(void)OnMenuShow
{
	[super OnMenuShow];
	m_bMenuAnimtation = NO;
	[self invalidate];
}	

- (void)drwaGameLoseFlashOverlay:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.60);
    CGContextFillRect(context, rect);
}

- (void)drawMenuActiveOverlay:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 0.7);
    CGContextFillRect(context, rect);
}

- (void)drawColorBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSetRGBFillColor(context, 0.4, 0.4, 1.0, 1.00);
    CGContextFillRect(context, rect);
}

- (void)drawGameScene:(CGContextRef)context inRect:(CGRect)rect
{
	if(m_Game != nil)
	{
		[m_Game drawGame:context inRect:rect];
	}	
}

- (void)drawGameSceneWin:(CGContextRef)context inRect:(CGRect)rect
{
	if(m_Game != nil)
	{
		[m_Game drawGameSceneWin:context inRect:rect];
	}	
}

- (void)drawGame:(CGContextRef)context inRect:(CGRect)rect 
{
	CGContextRef layerDC;
	CGLayerRef   layerObj;
	
	layerObj = CGLayerCreateWithContext(context, rect.size, NULL);
	layerDC = CGLayerGetContext(layerObj);
	
	CGContextSaveGState(layerDC);
	
	//[self drawBackground: layerDC inRect: rect];
	if(isGameResultWin() == 1)
	{
		[self drawGameSceneWin: layerDC inRect: rect];
	}
	else 
	{
		[self drawGameScene: layerDC inRect: rect];
	}
	if(isGameResultLose() == 1 && m_nLoseSceneFlash == 1)
	{
		[self drwaGameLoseFlashOverlay:layerDC inRect: rect];
	}	
	CGContextRestoreGState(layerDC);
	CGContextSaveGState(context);
    //CGContextDrawLayerAtPoint(context, CGPointMake(0.0f, 0.0f), layerObj);
    CGContextDrawLayerInRect(context, rect, layerObj);
	CGContextRestoreGState(context);
	CGLayerRelease(layerObj);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawGame:context inRect: rect];
	if(m_bMenuShow || m_bMenuAnimtation)
	{
		[self drawMenuActiveOverlay:context inRect:rect];
	}	
}


- (void)dealloc 
{
	[SoundSource ReleaseSoundSource];
    [super dealloc];
}

-(void)onTimerEvent:(id)sender
{
	if(m_Game != nil)
		[m_Game onTimerEvent];
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
        
        if([pGKDelegate IsGameLobbyMaster] == NO && [m_Avatar1 IsMaster] == NO && [m_Avatar2 IsMaster] == NO && 
           [m_Avatar3 IsMaster] == NO)
        {    
            NSString* szID = [pGKDelegate GetPlayerIDInRing:0];
            [self SetPlayerAvatarAsMaster:szID];
        }
        
        
        if([pGKDelegate IsGameLobbyMaster] == YES)
        {
            if(m_SystemButton.enabled == NO)
                m_SystemButton.enabled = YES; 
            if(m_PlayButton.enabled == NO)
                m_PlayButton.enabled = YES; 
        }
        else
        {
            if(m_SystemButton.enabled == YES)
                m_SystemButton.enabled = NO; 
            if(m_PlayButton.enabled == YES)
                m_PlayButton.enabled = NO; 
        }
    }    
    
}	

- (void) touchesBegan : (NSSet*)touches withEvent: (UIEvent*)event
{
    if(isGameResult() == 1 || isGamePlayReady() == 1)
    {
        return;
    }
    
	NSArray *points = [touches allObjects];
	CGPoint pt;
	float x, y;
	
	for(int i = 0; i < points.count; ++i)
	{	
		pt = POINT(i);
		x = [CGameLayout DeviceToGameSceneX:pt.x];//getViewPointXinScene(pt.x);
		y = [CGameLayout DeviceToGameSceneY:pt.y];//getViewPointYinScene(pt.y);
		
		if(m_Game != nil)
			[m_Game touchBegan:CGPointMake(x, y)];
	}
}	

- (void) touchesMoved: (NSSet*)touches withEvent: (UIEvent*)event
{
    if(isGameResult() == 1 || isGamePlayReady() == 1)
    {
        return;
    }
    
	NSArray *points = [touches allObjects];
	CGPoint pt;
	float x, y;
	
	for(int i = 0; i < points.count; ++i)
	{	
		pt = POINT(i);
		x = [CGameLayout DeviceToGameSceneX:pt.x];//getViewPointXinScene(pt.x);
		y = [CGameLayout DeviceToGameSceneY:pt.y];//getViewPointYinScene(pt.y);
		if(m_Game != nil)
			[m_Game touchMoved:CGPointMake(x, y)];
	}
}	

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_bMenuShow == YES)
        return;
    
    if(isGameResult() == 1)
    {
        //[self PlayButtonClick];
        //?????????
        if(isGameResultWin() == 1)
        {
            if(![SoundSource IsPlayWin])
            {    
                setGamePlayState(GAME_PLAY_READY);
                [self resetGame];
            }    
            return;
        }
        if(isGameResultLose() == 1)
        {
            if(isDisplayAD() == 1 && [ApplicationConfigure GetAdViewsState] == YES)
                return;
            
            if(![SoundSource IsPlayLose])
            {     
                setGamePlayState(GAME_PLAY_READY);
                [self resetGame];
            }    

            return;
        }
        return;
    }
    if(isGamePlayReady() == 1)
    {
        [self startGame];
        return;
    }
    
	NSArray *points = [touches allObjects];
	CGPoint pt;
	float x, y;
	
	for(int i = 0; i < points.count; ++i)
	{	
		pt = POINT(i);
		x = [CGameLayout DeviceToGameSceneX:pt.x];//getViewPointXinScene(pt.x);
		y = [CGameLayout DeviceToGameSceneY:pt.y];//getViewPointYinScene(pt.y);
		if(m_Game != nil)
			[m_Game touchEnded:CGPointMake(x, y)];
	}
}	

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}	

-(BOOL)isPlayingSound
{
	BOOL bRet = YES;
	
	return bRet;
}

-(void)playSound:(int)sndID
{
	if([Configuration canPlaySound] == NO)
		return;
	
	switch (sndID) 
	{
		case GAME_SOUND_ID_PLAYERSHOOT:
			[SoundSource PlayDogBreath];
			break;
		case GAME_SOUND_ID_TARGETHORN:
			[SoundSource PlayCowMeeo];
			break;
		case GAME_SOUND_ID_TARGETSHOOT:
			[SoundSource PlayCowPupu];
			break;
		case GAME_SOUND_ID_TARGETKNOCKDOWN:
			[SoundSource PlayCowKnockdown];
			break;
		case GAME_SOUND_ID_BLAST:
			[SoundSource PlayBlast];
			break;
		case GAME_SOUND_ID_COLLISION:
			[SoundSource PlayCollision];
			break;
		case GAME_SOUND_ID_JUMP:
			[SoundSource PlayJump];
			break;
		case GAME_SOUND_ID_CRASH:
			[SoundSource PlayCrash];
			break;
		case GAME_SOUND_ID_THUNDER:
			[SoundSource PlayThunder];
			break;
	}
}	

-(void)stopSound:(int)sndID
{
	if([Configuration canPlaySound] == NO)
		return;
	
	switch (sndID) 
	{
		case GAME_SOUND_ID_PLAYERSHOOT:
			[SoundSource StopDogBreath];
			break;
		case GAME_SOUND_ID_TARGETHORN:
			[SoundSource StopCowMeeo];
			break;
		case GAME_SOUND_ID_TARGETSHOOT:
			[SoundSource StopCowPupu];
			break;
		case GAME_SOUND_ID_TARGETKNOCKDOWN:
			[SoundSource StopCowKnockdown];
			break;
		case GAME_SOUND_ID_BLAST:
			[SoundSource StopBlast];
			break;
		case GAME_SOUND_ID_COLLISION:
			[SoundSource StopCollision];
			break;
		case GAME_SOUND_ID_JUMP:
			[SoundSource StopJump];
			break;
		case GAME_SOUND_ID_CRASH:
			[SoundSource StopCrash];
			break;
		case GAME_SOUND_ID_THUNDER:
			[SoundSource StopThunder];
			break;
	}
}	

-(void)playBlockageSound
{
	if([Configuration canPlaySound] == NO)
		return;

	[SoundSource PlayBlockageSound];
}

-(void)switchToBackgroundSound
{
	if([Configuration canPlaySound] == NO)
		return;
	
	[SoundSource SwitchToBackgroundSound];
}	


-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	[self stopAllSoundPlay];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if(player && flag == YES)
		[SoundSource StopPlaySoundFile:player];
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	[self resumeSoundPlay];
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
}	

-(void)playBackgroundSound
{
	if([Configuration canPlaySound] == NO)
		return;
	
	[SoundSource PlayBackgroundSound];
}

-(void)stopAllSoundPlay
{
	if([Configuration canPlaySound] == NO)
		return;
	
	[SoundSource StopAllPlayingSound];
}

-(void)pauseSoundPlay
{
	if([Configuration canPlaySound] == NO)
		return;
	
	[SoundSource PauseAllPlayingSound];
}	

-(void)resumeSoundPlay
{
	if([Configuration canPlaySound] == NO)
		return;
	
	[SoundSource ResumeAllPlayingSound];
}	

-(void)updateGameEndState
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {    
        GameMessage* msg = [[GameMessage alloc] init];
        [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMEPLAYEND];
        if(isGameResultWin() == 1)
        {
            [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAMEEND withInteger:GAMEMSG_VALUE_GAMEWIN];
            [m_Badget SetStateWin];
        }
        else if(isGameResultLose() == 1)
        {
            [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAMEEND withInteger:GAMEMSG_VALUE_GAMELOSE];
            [m_Badget SetStateLose];
        }	
        [GameMsgFormatter EndFormatMsg:msg];
        [pGKDelegate SendMessageToAllplayers:msg];
        [msg release];
        
        return; 
    }
    
    if([ApplicationConfigure GetAdViewsState] && isGameResultLose() == 1)
    {
        [Configuration AddFlashAddDelayCount];
        if([Configuration CanPlayFlashAddNow] == YES)
        {    
            [Configuration CleanFlashAddDelayCount];
            setDisplayAD(1);
        }    
    }
}

-(void)updatePlayerLobbyWinScore
{
    [self UpdateActivePlayerScore];
}

-(void)invalidate
{
	[self.superview setNeedsDisplay];
	[self setNeedsDisplay];
}	

-(void)updateGameLayout
{
    float fSize = [GUILayout GetTitleBarHeight];
    CGRect rect = CGRectMake([GUILayout GetMainUIWidth]-(fSize+1), [GUILayout GetContentViewHeight]-fSize*1.5, fSize, fSize);
    [m_PlayButton setFrame:rect];
    
	[CGameLayout InitializeLayout];
	[self OnOrientationChange];
	[m_Game updateGameLayout];
    
    float dW = [GUILayout GetContentViewWidth];//[GUILayout GetContentViewWidth]/3.0;
    float dY = [GUILayout GetContentViewHeight]/4.0;//[GUILayout GetContentViewHeight];
    //float txtWidth = [GUILayout GetMsgBoardViewWidth];
    float dSX = dW;//(dW-txtWidth)*0.5; 
    [m_Avatar1 SetAchor:CGPointMake(dSX, dY)];
    
    dY += dY; //dSX += dW; 
    [m_Avatar2 SetAchor:CGPointMake(dSX, dY)];
    
    dY += dY; //dSX += dW; 
    [m_Avatar3 SetAchor:CGPointMake(dSX, dY)];
    
    dSX = 0; //[GUILayout GetContentViewWidth]-[GUILayout GetMsgBoardViewWidth]*0.5; 
    dY = [GUILayout GetContentViewHeight]/2.0;
    [m_Badget SetAchor:CGPointMake(dSX, dY)];
    
    [self setNeedsDisplay];
}	

-(void)HandleBoardcastWinningResult
{
    //??????????????
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if([ApplicationConfigure IsGameCenterEnable] == YES && pGKDelegate)
    {    
        if ([CustomModalAlertView Ask:nil withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory   GetString_PostGameScore]] == ALERT_OK)
        {
            int nScore = [ScoreRecord getTotalWinScore];
            [pGKDelegate PostGameCenterScore:nScore withBoard:16];
            //????????
            //????????
        }
    } 
}

-(void)HandleNewGameLevelSelection
{
    int nTotalScore = [ScoreRecord getTotalWinScore];
    int nCurrentSkill = [Configuration getGameSkill];
    int nCurrentLevel = [Configuration getGameLevel];
    int nScoreMaxSkill = [Configuration getCanGamePlaySkillAtScore:nTotalScore];
    int nScoreMaxLevel = [Configuration getCanGamePlayLevelAtScore:nTotalScore];

    int nCurrent = nCurrentSkill + nCurrentLevel*3;
    int nThreshold = nScoreMaxSkill + nScoreMaxLevel*3;

    if(nCurrent < nThreshold)
    {
 
        if ([CustomModalAlertView Ask:nil withButton1:[StringFactory GetString_CurrentGame] withButton2:[StringFactory GetString_NextLevelGame]] == ALERT_OK)
        {
            [Configuration setGameLevel:nScoreMaxLevel];
            [Configuration setGameSkill:nScoreMaxSkill];
        }
    }
}

-(void)HandleBoardcastLostResult
{
    
}

-(void)HandlePostLostAction
{
    int nTotalScore = [ScoreRecord getTotalWinScore];
    int nCurrentSkill = [Configuration getGameSkill];
    int nCurrentLevel = [Configuration getGameLevel];
    int nScoreMaxSkill = [Configuration getCanGamePlaySkillAtScore:nTotalScore];
    int nScoreMaxLevel = [Configuration getCanGamePlayLevelAtScore:nTotalScore];
    
    int nCurrent = nCurrentSkill + nCurrentLevel*3;
    int nThreshold = nScoreMaxSkill + nScoreMaxLevel*3;
    
    if(nThreshold < nCurrent)
    {
        [Configuration setGameLevel:nScoreMaxLevel];
        [Configuration setGameSkill:nScoreMaxSkill];
    }
}

-(void)HandlePostWinningOptions
{
    if(m_Game && [m_Game ShouldHandlePostWinningOptions] == YES)
    {
        [self HandleBoardcastWinningResult];
        [self HandleNewGameLevelSelection];
    }
    else if(m_Game && [m_Game ShouldHandlePostLostAction] == YES)
    {
        [self HandleBoardcastLostResult];
        [self HandlePostLostAction];
    }
}

//
//Game Delegate controller methods
//
-(void)startGame
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(!pGKDelegate || [pGKDelegate IsInLobby] == NO)
    {
        [self HandlePostWinningOptions];
    }
    
	[m_Game startNewGame];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        [m_Badget SetStatePlay];
        
        [m_Avatar1 SetStatePlay];
        
        [m_Avatar2 SetStatePlay];
        
        [m_Avatar3 SetStatePlay];
    }
    [self HideNonPlayingButtons];
}

-(void)resetGame
{
	[m_Game resetGameScene];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        [m_Badget SetStateIdle];
        
        [m_Avatar1 SetStateIdle];
        
        [m_Avatar2 SetStateIdle];
        
        [m_Avatar3 SetStateIdle];
    }
}

-(void)stopGame
{
	[m_Game endGame];
}

-(void)pauseGame
{
	[m_Game pauseGame];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        [m_Badget SetStateIdle];
        
        [m_Avatar1 SetStateIdle];
        
        [m_Avatar2 SetStateIdle];
        
        [m_Avatar3 SetStateIdle];
    }
}

-(void)resumeGame
{
	[m_Game resumeGame];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
    {
        [m_Badget SetStateIdle];
        
        [m_Avatar1 SetStateIdle];
        
        [m_Avatar2 SetStateIdle];
        
        [m_Avatar3 SetStateIdle];
    }
}

-(void)setButtonsLabel
{
}

-(void)initButtons
{
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
	//[ScoreRecord saveRecord];
	bEnable = ![Configuration canPlaySound];
	[[m_Menu GetMenuItem:GUIID_SOUNDBUTTON] SetChecked:bEnable];
}

-(void)OnMenuBkGnd:(id)sender
{
	//[ModalAlert say:@"Background"];
	int n = [Configuration getBackgroundSetting];
	n = (n+1)%GAME_BACKGROUND_COUNT;
	[Configuration setBackgroundSetting:n];
	[[m_Menu GetMenuItem:GUIID_BKGNDBUTTON] SetActiveChoice:[Configuration getBackgroundSetting]];
	[self.superview setNeedsDisplay];
}

-(void)OnMenuSetting:(id)sender
{
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENCONFIGUREVIEW eventSender:self];
}

-(void)OnMenuScore:(id)sender
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
        return;
    
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENSCOREVIEW eventSender:self];
}

-(void)OnMenuShare:(id)sender
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
        return;
	
    [GUIEventLoop SendEvent:GUIID_EVENT_OPENSHAREVIEW eventSender:self];
}

-(void)OnMenuClock:(id)sender
{
	BOOL bShown = [Configuration isClockShown];
	[Configuration setClockShown:!bShown];
    [ScoreRecord saveRecord];
	[self setNeedsDisplay];
}	

-(void)OnMenuBuyIt:(id)sender
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsInLobby] == YES)
        return;
	
    [GUIEventLoop SendEvent:GUIID_EVENT_PURCHASE eventSender:self];
}

-(BOOL)GameOverPresentationDone
{
    BOOL bRet = NO;
  
	if(isGameResult() == 1)
    {
        if((isGameResultLose() == 1 && [SoundSource IsPlayLose] == NO))
        {    
           bRet = YES;
        }
    }
    
    return bRet;
}

-(BOOL)IsUIEventLocked
{
    if([ApplicationConfigure GetAdViewsState] && isDisplayAD() == 1)
        return YES;
    
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return YES;
    
    return NO;
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
    [self stopGame];
    [m_LobbyButton HideButton];
    m_LobbyCloseButton.hidden = NO;
    [self ShowLobbyStateButtons];
	//if(isGamePlayPlaying() == 1 || isGameResult() == 1)
	//{
	[self resetGame];
	//}
    [self setNeedsDisplay];
}

- (void)ResetCurrentPlayingGame
{
	if(isGamePlayPlaying() == 1 || isGameResult() == 1)
	{
		[self resetGame];
	}
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
/*    if([m_Avatar1 IsActive] == NO && [m_Avatar2 IsActive] == NO && [m_Avatar3 IsActive] == NO && [m_Badget IsActive] == NO)
        return NO;
    
    if([m_Avatar1 IsActive] == YES)
    {
        if([playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
            [m_Avatar1 SetHighLight:YES];
        else
            [m_Avatar1 SetHighLight:NO];
    }
    if([m_Avatar2 IsActive] == YES)
    {
        if([playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
            [m_Avatar2 SetHighLight:YES];
        else
            [m_Avatar2 SetHighLight:NO];
    }
    if([m_Avatar3 IsActive] == YES)
    {
        if([playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
            [m_Avatar3 SetHighLight:YES];
        else
            [m_Avatar3 SetHighLight:NO];
    }
    if([m_Badget IsActive] == YES)
    {
        if([playerID isEqualToString:[m_Badget GetPlayerID]] == YES)
            [m_Badget SetHighLight:YES];
        else
            [m_Badget SetHighLight:NO];
    }*/
    
    return YES;
}

- (BOOL)IsPlayerAvatarHighLight:(NSString*)playerID
{
    /*if([m_Avatar1 IsActive] == YES && [playerID isEqualToString:[m_Avatar1 GetPlayerID]] == YES)
    {
        if([m_Avatar1 IsHighLight] == YES)
            return YES;
    }
    if([m_Avatar2 IsActive] == YES && [playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        if([m_Avatar2 IsHighLight] == YES)
            return YES;
    }
    if([m_Avatar3 IsActive] == YES && [playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        if([m_Avatar3 IsHighLight] == YES)
            return YES;
    }
    if([m_Badget IsActive] == YES && [playerID isEqualToString:[m_Badget GetPlayerID]] == YES)
    {
        if([m_Badget IsHighLight] == YES)
            return YES;
    }*/
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
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
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
    }   
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
        return;
    }
    if([playerID isEqualToString:[m_Avatar2 GetPlayerID]] == YES)
    {
        if(nResult == GAMEMSG_VALUE_GAMEWIN)
            [m_Avatar2 SetStateWin];
        else
            [m_Avatar2 SetStateLose];
        return;
    }
    if([playerID isEqualToString:[m_Avatar3 GetPlayerID]] == YES)
    {
        if(nResult == GAMEMSG_VALUE_GAMEWIN)
            [m_Avatar3 SetStateWin];
        else
            [m_Avatar3 SetStateLose];
        return;
    }
    if([playerID isEqualToString:[m_Badget GetPlayerID]] == YES)
    {
        if(nResult == GAMEMSG_VALUE_GAMEWIN)
            [m_Badget SetStateWin];
        else
            [m_Badget SetStateLose];
        return;
    }
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

@end
