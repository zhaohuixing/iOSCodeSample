//
//  CGameSectionManager.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CGameSectionManager.h"
#import "COnLineGameSection.h"
#import "COffLineGameSection.h"
#import "GameViewController.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#import "Configuration.h"
#import "SoundSource.h"
#import "StringFactory.h"
#import "CustomModalAlertView.h"
#import "GameMsgFormatter.h"
#import "GameMsgConstant.h"
#import "NSJSONSerialization+GameHelper.h"

@implementation CGameSectionManager

-(id)init
{
    self = [super init];
    if(self)
    {
        m_GameLobby = [[GambleLobby alloc] init];
        [m_GameLobby SetGameType:[Configuration getCurrentGameType] theme:[Configuration getCurrentGameTheme]];
        
        
        m_OfflineGameSection = [CGameSectionManager CreateOffLineSectionInstance];
        m_OnlineGameSection = [CGameSectionManager CreateOnLineSectionInstance:NO];
        
        m_AppleGameCenterAgent = [[AppleGameCenterEngine alloc] init];
        GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
        [m_AppleGameCenterAgent AttachDelegates:pController with:self]; 
        [m_AppleGameCenterAgent AutoHandleGameSessionInvitation];
        [GUIEventLoop RegisterEvent:GUIID_EVENT_ONLINE_SHUTDOWN_GAMESECTION eventHandler:@selector(ShutdownGameSection) eventReceiver:self eventSender:nil];
        
        if([GKLocalPlayer localPlayer].authenticated == YES)
        {
            [[GKLocalPlayer localPlayer] registerListener:(id<GKLocalPlayerListener>)m_AppleGameCenterAgent];
        }
    }
    return self;
}

-(void)Terminate
{
    [m_OnlineGameSection ShutdownSection];
    [[GKLocalPlayer localPlayer] unregisterAllListeners];
}

-(void)RegisterGKInvitationListener
{
    if(m_AppleGameCenterAgent != nil)
        [[GKLocalPlayer localPlayer] registerListener:(id<GKLocalPlayerListener>)m_AppleGameCenterAgent];
}


-(void)DelayRegisterGameController
{
    [m_OfflineGameSection AssignController:self];
    [m_OnlineGameSection AssignController:self];
    [m_OnlineGameSection ShutdownSection];
    
    m_ActiveGameSection = m_OfflineGameSection;
    [m_ActiveGameSection StartGameSection];
}


-(void)dealloc
{
    if(m_ActiveGameSection)
        m_ActiveGameSection = nil;
}

-(GamePlayer*)GetMyself
{
    if(m_ActiveGameSection)
        return [((CGameSectionBase *)m_ActiveGameSection) GetMyself];
    
    return nil;
}

- (void)SetGameType:(int)nType theme:(int)themeType
{
    [m_GameLobby SetGameType:nType theme:themeType];
    [[CGameSectionManager GetGlobalGameUIDelegate] UpdateGameUI];
}

-(void)SetGameState:(int)nState
{
    [m_GameLobby SetGameState:nState];
    [[CGameSectionManager GetGlobalGameUIDelegate] UpdateGameUI];
}

-(int)GetGameType
{
    return [m_GameLobby GetGameType];
}

-(int)GetGameState
{
    return [m_GameLobby GetGameState];
}

-(int)GetGameOnlineState
{
    return [m_ActiveGameSection GetGameOnlineState];
}

-(BOOL)IsOnline
{
    BOOL bRet = ([self GetGameOnlineState] == GAME_ONLINE_STATE_ONLINE);
    return bRet;
}

-(void)OpenOnlinePlayerPopupMenu:(int)nSeatID
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection OpenOnlinePlayerPopupMenu:nSeatID];
}

- (void)RegisterSubUIObject:(id)subUI
{
    [[CGameSectionManager GetGlobalGameUIDelegate] RegisterSubUIObject:subUI];
}

-(void)MakePlayerTransaction:(int)nSeatID
{
    if([self GetGameOnlineState] == GAME_ONLINE_STATE_OFFLINE)
    {    
        [self CancelPendPlayerBet];
        [self SetSystemOnHold:YES];
    }    
    [[CGameSectionManager GetGlobalGameUIDelegate] MakePlayerTransaction:nSeatID];
}


-(void)OpenRedeemViewForPlayer:(int)nSeatID
{
    [self CancelPendPlayerBet];
    [self SetSystemOnHold:YES];
    [ApplicationConfigure SetRedeemPlayerSeat:nSeatID];
    [GUIEventLoop SendEvent:GUIID_EVENT_PURCHASECHIPS eventSender:self];
}

-(BOOL)IsSystemOnHold
{
    if(m_ActiveGameSection)
        return [m_ActiveGameSection IsSystemOnHold];
    
    return NO;
}

-(void)SpinGambleWheel:(CPinActionLevel*)action
{
    [m_GameLobby SpinGambleWheel:action];
    if(m_ActiveGameSection)
        [m_ActiveGameSection ForceClosePlayerMenus];
    if([m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_ONLINE)
    {
        GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
        [pController ShowStatusBar:[StringFactory GetString_Spinning]];
    }
}

-(int)GetWinScopeIndex
{
    return [m_GameLobby GetWinScopeIndex];
}

-(void)HandleNonSpinTouchEvent
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection HandleNonSpinTouchEvent];
}

-(void)ShutdownGameSection
{
    if(m_ActiveGameSection && [m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_ONLINE)
    {
        
        [m_ActiveGameSection ShutdownSection];
        m_ActiveGameSection = m_OfflineGameSection;
        [m_ActiveGameSection StartGameSection];
        GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
        [pController handleHandleBluetoothSessionClosed];
    }
    else if(m_ActiveGameSection && [m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_OFFLINE)
    {
        [self PauseGame];
        [m_ActiveGameSection ShutdownSection];
        m_ActiveGameSection = m_OnlineGameSection;
        [m_ActiveGameSection StartGameSection];
    }
}

-(void)GotoOfflineGame
{
    if(m_ActiveGameSection && [m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_ONLINE)
    {
        [m_ActiveGameSection ShutdownSection];
        m_ActiveGameSection = m_OfflineGameSection;
        [m_ActiveGameSection StartGameSection];
    }    
}

-(int)GetActivatedPlayerCount
{
    int nRet = 0;
    
    if(m_ActiveGameSection)
        nRet = [m_ActiveGameSection GetActivatedPlayerCount];
    
    return nRet;
}

-(void)shutdownCurrentGame
{
    //????[self GotoOfflineGame];
    [self ShutdownGameSection];
}

- (void) AbsoultShutDownOnlineGame
{
    if(m_ActiveGameSection && [m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_ONLINE)
    {
        [m_ActiveGameSection AbsoultShutDownOnlineGame];
        m_ActiveGameSection = m_OfflineGameSection;
        [m_ActiveGameSection StartGameSection];
    }
}

//////////////////////////////////////
//Member functions
//////////////////////////////////////
- (void)Draw:(CGContextRef)context inRect:(CGRect)rect
{
    [m_GameLobby Draw:context inRect:rect];
    if(m_ActiveGameSection)
        [m_ActiveGameSection Draw:context inRect:rect];
}

-(void)OnTimerEvent
{
    [m_GameLobby OnTimerEvent];
    if(m_ActiveGameSection)
        [m_ActiveGameSection OnTimerEvent];
}

-(void)UpdateGameLayout
{
    //[m_GameLobby UpdateGameLayout];
    if(m_ActiveGameSection)
    {
        [m_ActiveGameSection UpdateGameLayout];
    }
}

-(void)InitializeDefaultPlayersConfiguration
{
    if(m_ActiveGameSection)
    {    
        [m_ActiveGameSection InitializeDefaultPlayersConfiguration];
        [[CGameSectionManager GetGlobalGameUIDelegate] UpdateGameUI];
    }    
}

-(int)GetMyCurrentMoney
{
    int nRet = -1;
    
    if(m_ActiveGameSection)
        nRet = [m_ActiveGameSection GetMyCurrentMoney];
    
    return nRet;
}

-(void)AddMoneyToMyAccount:(int)nChips
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection AddMoneyToMyAccount:nChips];
}

-(int)GetPlayerCurrentMoney:(int)nSeat
{
    int nRet = -1;
    
    if(m_ActiveGameSection)
        nRet = [m_ActiveGameSection GetPlayerCurrentMoney:nSeat];
    
    return nRet;
}

-(void)AddMoneyToPlayerAccount:(int)nChips inSeat:(int)nSeat
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection AddMoneyToPlayerAccount:nChips inSeat:nSeat];
}

-(void)RedeemAdViewClosed
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection RedeemAdViewClosed];
}

-(NSString*)GetPlayerName:(int)nSeatID
{
    NSString* strRet = @"";
    if(m_ActiveGameSection)
        strRet = [m_ActiveGameSection GetPlayerName:nSeatID];
    return strRet;
}

-(void)CancelPendPlayerBet
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection CancelPendPlayerBet];
}

-(void)SetSystemOnHold:(BOOL)bOnHold
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection SetSystemOnHold:bOnHold];
}

-(void)GotoOnLineGame
{
    if(m_ActiveGameSection && [m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_OFFLINE)
    {
        [m_ActiveGameSection RestoreOffLineReadyState];
    }
    
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    [pController GotoOnlineGame];
    return;
}

-(void)RestoreOffLineReadyState
{
    if(m_ActiveGameSection && [m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_OFFLINE)
    {
        [m_ActiveGameSection RestoreOffLineReadyState];
    }
}

-(void)ResetGameStateAndType
{
    if([Configuration isDirty])
    {
        if(![Configuration canPlaySound])
        {
            [SoundSource StopAllPlayingSound];
        }
        else
        {
            [SoundSource PlayWheelStaticSound];
        }
        
        if([Configuration isOnline])
        {
            [self GotoOnLineGame];
        }
        else
        {    
            [self RestoreOffLineReadyState];
        }    
        [Configuration resetDirty];
    }    
    
}

-(BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID
{
    BOOL bRet = NO;
    
    if(m_ActiveGameSection)
        bRet = [m_ActiveGameSection CanPlayerPlayGame:nType inSeat:nSeatID];
    
    return bRet;
}

-(void)PlayerFinishPledge:(int)nSeat withNumber:(int)nLuckNumber withBet:(int)nBetMoney
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection PlayerFinishPledge:nSeat withNumber:nLuckNumber withBet:nBetMoney];
}

-(void)PlayerTranfereChipsFrom:(int)nSeat To:(int)nReceiverID withChips:(int)nChips
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection PlayerTranfereChipsFrom:nSeat To:nReceiverID withChips:nChips];
}

-(void)StartNewGame
{
    
}

-(void)PauseGame
{
    [m_GameLobby PauseGame];
    if(m_ActiveGameSection)
        [m_ActiveGameSection PauseGame];
    if([Configuration canPlaySound])
    {
        [SoundSource StopAllPlayingSound];
    }
}

-(void)ResumeGame
{
    [m_GameLobby ResumeGame];
}

-(void)HoldMyTurnIfNeeded
{
    if(m_ActiveGameSection)
        [m_ActiveGameSection HoldMyTurnIfNeeded];
}

-(void)UpdateForGameStateChange
{
    if(m_ActiveGameSection)
    {
        [m_ActiveGameSection UpdateForGameStateChange];
    }
}

-(void)UpdateForGameTypeChange
{
    if(m_ActiveGameSection)
    {
        [m_ActiveGameSection UpdateForGameTypeChange];
    }
}

-(void)OnTouchBegin:(CGPoint)pt
{
    if(m_ActiveGameSection != nil)
        [m_ActiveGameSection OnTouchBegin:pt];
}

-(void)OnTouchMove:(CGPoint)pt
{
    if(m_ActiveGameSection != nil)
        [m_ActiveGameSection OnTouchMove:pt];
}

-(void)OnTouchEnd:(CGPoint)pt
{
    if(m_ActiveGameSection != nil)
        [m_ActiveGameSection OnTouchEnd:pt];
}

-(void)OnTouchCancel:(CGPoint)pt
{
    if(m_ActiveGameSection != nil)
        [m_ActiveGameSection OnTouchEnd:pt];
}

-(id)GetPlayerAtSeat:(int)nSeatID
{
    id ret = nil;
    
    if(m_ActiveGameSection)
        ret = [m_ActiveGameSection GetPlayerAtSeat:nSeatID];
    
    return ret;
}



/////////////////////////////////////////////
//Class methods
/////////////////////////////////////////////
+(id<IGameSection>)CreateOffLineSectionInstance
{
    COffLineGameSection* pOffSection = [[COffLineGameSection alloc] init];
    return pOffSection;
}

+(id<IGameSection>)CreateOnLineSectionInstance:(BOOL)bHost
{
    COnLineGameSection* pOnSection = [[COnLineGameSection alloc] init];
    [pOnSection SetOnlineGameHost:bHost];
    return pOnSection;
}

+(id<GameUIDelegate>)GetGlobalGameUIDelegate
{
    id<GameUIDelegate> pRet = nil;
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(pController)
    {
        pRet = [pController GetCurrentGameUIDelegate];
    }
    return pRet;
}

-(NSString*)GetInvitationSenderInitialDataString
{
    int nGameType = [self GetGameType];
    int nPlayTurnType = [Configuration getPlayTurnType];
    int nThemeType = [Configuration getCurrentGameTheme];
    int nBalance = [self GetMyCurrentMoney];
  
    NSMutableDictionary* pMessageStream = [[NSMutableDictionary alloc] init];
    
    NSNumber*   numberGameType = [[NSNumber alloc] initWithInt:nGameType];
    [pMessageStream setObject:numberGameType forKey:GAME_MSG_KEY_GAMETYPEMSG];

    NSNumber*   numberThemeType = [[NSNumber alloc] initWithInt:nThemeType];
    [pMessageStream setObject:numberThemeType forKey:GAME_MSG_KEY_THEMETYPEMSG];
    
    NSNumber*   numberPlayTurnType = [[NSNumber alloc] initWithInt:nPlayTurnType];
    [pMessageStream setObject:numberPlayTurnType forKey:GAME_MSG_KEY_ONLINEPLAYSEQUENCE];

    NSNumber*   numberBalance = [[NSNumber alloc] initWithInt:nBalance];
    [pMessageStream setObject:numberBalance forKey:GAME_MSG_KEY_PLAYER_CHIPS_BALANCE];
   
    
	NSString* pGameMessage = [NSJSONSerialization FormatJSONString:pMessageStream];

    return pGameMessage;
}

-(NSString*)GetInvitationRecieverInitialDataString
{
    int nBalance = [self GetMyCurrentMoney];
    
    NSMutableDictionary* pMessageStream = [[NSMutableDictionary alloc] init];
    
    NSNumber*   numberBalance = [[NSNumber alloc] initWithInt:nBalance];
    [pMessageStream setObject:numberBalance forKey:GAME_MSG_KEY_PLAYER_CHIPS_BALANCE];
    
    NSString* pGameMessage = [NSJSONSerialization FormatJSONString:pMessageStream];
    
    return pGameMessage;
}


@end
