//
//  COffLineGameSection.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "COffLineGameSection.h"
#import "CGameSectionManager.h"
#import "ApplicationConfigure.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
#import "StringFactory.h"
#import "ScoreRecord.h"
#import "Configuration.h"
#import "GameConstants.h"

@implementation COffLineGameSection

-(id)init
{
    self = [super init];
    if(self)
    {
        m_OffLineResetToReadyDelay = OFFLINE_PLAYER_TURN_DELAY;
        m_bInOffLineReadyPlay = NO;
        m_bOnHold = NO;
    }
    
    return self;
}

-(void)dealloc
{
}

-(void)Release
{
}

-(int)GetGameOnlineState
{
    return GAME_ONLINE_STATE_OFFLINE;
}

-(void)CancelPendPlayerBet
{
    int nState = [m_GameController GetGameState];
    
    for(int i = 0; i < 4; ++i)
    {
        if(nState == GAME_STATE_RUN || nState == GAME_STATE_READY || nState == GAME_STATE_RESET)
        {    
            if(m_Players[i] && [m_Players[i] IsEnabled])
            {
                [m_Players[i] CancelPendingBet];
            }
        }
        else if(nState == GAME_STATE_RESULT) 
        {
            [m_Players[i] ClearPlayBet];
        }
    }
    [m_GameController SetGameState:GAME_STATE_RESET];
}

-(void)SavePlayersOfflineStateInformation
{
    int nType = [m_GameController GetGameType];
    [ScoreRecord SetGameType:nType];
    [ScoreRecord SetGameTheme:[Configuration getCurrentGameTheme]];
    [ScoreRecord SetSoundEnable:[Configuration canPlaySound]];
    [ScoreRecord SetPlayTurnType:[Configuration getPlayTurnType]];
    if([Configuration isRoPaAutoBet])
        [ScoreRecord SetOfflineBetMethod:0];
    else
        [ScoreRecord SetOfflineBetMethod:1];
    
    int nChips;
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i])
        {
            nChips = [m_Players[i] GetPacketBalance];
            [ScoreRecord SetPlayerChipBalance:nChips inSeat:i];
        }
    }
    [ScoreRecord SaveScore];
}

-(BOOL)AllOfflinePlayersMakePledge
{
    BOOL bRet = NO;
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled])
        {
            if(![m_Players[i] AlreadyMadePledge])
                return NO;
            else
                bRet = YES;
        }
    }
    
    return bRet;
}

-(void)StartOffLinePlayerAction
{
    if(0 < m_nPlayerTurnIndex)
    {
        m_bInOffLineReadyPlay = NO;
        CPinActionLevel* action = [[CPinActionLevel alloc] initRandomLevel];
        [m_GameController SpinGambleWheel:action];
    }
}


-(void)SetOffLinePlayTurn
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled])
        {
            if(i == m_nPlayerTurnIndex)
            {
                [m_Players[i] SetMyTurn:YES];
            }
            else
            {
                [m_Players[i] SetMyTurn:NO];
            }
        }
    }
    m_OffLineResetToReadyDelay = OFFLINE_PLAYER_TURN_DELAY;
    
    if([m_Players[1] IsEnabled] == NO || [m_Players[2] IsEnabled] == NO ||[m_Players[3] IsEnabled] == NO) 
        m_OffLineResetToReadyDelay = 2.0*OFFLINE_PLAYER_TURN_DELAY;
}

-(BOOL)PlayerCanPlay:(int)nIndex
{
    int nType = [m_GameController GetGameType];
    BOOL bRet = [self CanPlayerPlayGame:nType inSeat:nIndex];
    return bRet;
}

-(int)GetNextSequencePlayTurn:(int)nCurrentTurn
{
    if(nCurrentTurn < 0)
        return 0;
    
    int nIndex = nCurrentTurn;
    for(int i = 0; i < 4; ++i)
    {
        nIndex = (nIndex+1)%4;
        if([self PlayerCanPlay:nIndex])
        {
            return nIndex;
        }
    }
    return nIndex;
}

-(void)UpdateOffLineGamePlayTurn
{
    //if([Configuration getPlayTurnType] == GAME_PLAYTURN_TYPE_SEQUENCE)
    {    
        m_nPlayerTurnIndex = [self GetNextSequencePlayTurn:m_nPlayerTurnIndex];
        [self SetOffLinePlayTurn];
        [self LocatePlayingSpinner];
        if([Configuration isRoPaAutoBet])
        {    
            if(0 < m_nPlayerTurnIndex)
            {    
                m_OffLineReadyPlayTime = [[NSProcessInfo processInfo] systemUptime];
                m_bInOffLineReadyPlay = YES;
            }    
        }
    }
}

-(void)UpdateOfflineOtherPlayersAutoPledge:(BOOL)bChangeState
{
    int nBetMoney;
    int nChoiceNumber;
    int nType = [m_GameController GetGameType];
    
    for(int i = 1; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && ![m_Players[i] AlreadyMadePledge])
        {
            [m_Players[i] UpdateCurrentGamePlayablity];
            if([m_Players[i] IsEnabled])
            {    
                nBetMoney = [m_Players[i] GenerateAutoOffLineBetPledge:nType];
                nChoiceNumber = [m_Players[i] GenerateAutoOffLineBetLuckNumber:nType];
                [m_Players[i] MakePlayBet:nChoiceNumber withPledge:nBetMoney];
            }    
        }
    }
    if(bChangeState)
    {    
        [self ShowPlayersPledgeInformation];
        [m_GameController SetGameState:GAME_STATE_READY];
        [self UpdateOffLineGamePlayTurn];
    }    
}

-(BOOL)IsMyTurn
{
    BOOL bRet = (m_nPlayerTurnIndex == 0);
    return bRet;
}

-(void)OnTouchBegin:(CGPoint)pt
{
    if([m_GameController IsSystemOnHold])
        return;
    
    if([m_GameController GetGameState] != GAME_STATE_READY)
        return;
     
    if(m_nPlayerTurnIndex == -1)
    {
        [self UpdateOffLineGamePlayTurn];
    }
    
    if([self IsMyTurn] || ![Configuration isRoPaAutoBet])
    {
         m_ptTouchStart = pt;
         m_timeTouchStart = [[NSProcessInfo processInfo] systemUptime];
         return;
    }
}

-(void)OnTouchMove:(CGPoint)pt
{
    if([m_GameController IsSystemOnHold])
        return;
    
    if([m_GameController GetGameState] != GAME_STATE_READY)
        return;
}

-(void)OnTouchEnd:(CGPoint)pt
{
    if([m_GameController IsSystemOnHold])
        return;
    
    if([m_GameController GetGameState] != GAME_STATE_READY)
    {
        [self HandleNonSpinTouchEvent];
        return;
    } 
    
    if([self IsMyTurn] || ![Configuration isRoPaAutoBet])
    {
        m_ptTouchEnd = pt;
        NSTimeInterval endTime = [[NSProcessInfo processInfo] systemUptime];
        float time = endTime - m_timeTouchStart;
        CPinActionLevel* action = [[CPinActionLevel alloc] initLevel:m_ptTouchStart withPoint2:m_ptTouchEnd withTime:time];
        [m_GameController SpinGambleWheel:action];
    }    
}

-(void)OnTouchCancel:(CGPoint)pt
{
    [self OnTouchEnd:pt];
}

-(void)OnTimerEvent
{
    [super OnTimerEvent];
    if(m_bInOffLineReadyPlay && ![m_GameController IsSystemOnHold] && [Configuration isRoPaAutoBet])
    {
        NSTimeInterval curTime = [[NSProcessInfo processInfo] systemUptime];
        if(m_OffLineResetToReadyDelay < (curTime - m_OffLineReadyPlayTime))
        {
            if([self AllOfflinePlayersMakePledge])
            {    
                [self StartOffLinePlayerAction];
            }    
            else
            {
                m_nPlayerTurnIndex = m_nPlayerTurnIndex-1;
                if(m_nPlayerTurnIndex < 0)
                    m_nPlayerTurnIndex = 0;
                m_bInOffLineReadyPlay = NO;
                [[CGameSectionManager GetGlobalGameUIDelegate] MakePlayerManualPledge:0];
            }
        }
    }
}

-(void)UpdatePlayersCurrentGamePlayablity
{
    int nCount = 4;
    for(int i = 0; i < nCount; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            [m_Players[i] UpdateCurrentGamePlayablity];
        }
    }    
}

-(void)OfflinePlayersLoadMoney
{
     if([ScoreRecord GetSavedRecord] == 0)
     {
         for(int i = 0; i < 4; ++i)
         {    
             [m_Players[i] SetupPacket:GAME_DEFAULT_CHIPSINPACKET];
         }    
         [ScoreRecord SetMyChipBalance:GAME_DEFAULT_CHIPSINPACKET];
         [ScoreRecord SetPlayer1ChipBalance:GAME_DEFAULT_CHIPSINPACKET];
         [ScoreRecord SetPlayer2ChipBalance:GAME_DEFAULT_CHIPSINPACKET];
         [ScoreRecord SetPlayer3ChipBalance:GAME_DEFAULT_CHIPSINPACKET];
     }
     else
     {
         int nChips = [ScoreRecord GetMyChipBalance];
         [m_Players[0] SetupPacket:nChips];
         nChips = [ScoreRecord GetPlayer1ChipBalance];
         [m_Players[1] SetupPacket:nChips];
         nChips = [ScoreRecord GetPlayer2ChipBalance];
         [m_Players[2] SetupPacket:nChips];
         nChips = [ScoreRecord GetPlayer3ChipBalance];
         [m_Players[3] SetupPacket:nChips];
     }
     [m_Players[0] UpdateCurrentGamePlayablity];
     [m_Players[1] UpdateCurrentGamePlayablity];
     [m_Players[2] UpdateCurrentGamePlayablity];
     [m_Players[3] UpdateCurrentGamePlayablity];
}

-(void)InitializeDefaultPlayersConfiguration
{
    if(m_GameController)
    {
        NSString* sText = [StringFactory GetString_OfflineMySelfID];
        [m_Players[0] Activate:YES];
        [m_Players[0] IntializePlayerInfo:sText withID:sText inSeat:0 isMyself:YES inLobby:m_GameController];
        
        sText = [StringFactory GetString_OfflinePlayer1ID];
        [m_Players[1] Activate:YES];
        [m_Players[1] IntializePlayerInfo:sText withID:sText inSeat:1 isMyself:NO inLobby:m_GameController];
        
        sText = [StringFactory GetString_OfflinePlayer2ID];
        [m_Players[2] Activate:YES];
        [m_Players[2] IntializePlayerInfo:sText withID:sText inSeat:2 isMyself:NO inLobby:m_GameController];
        
        sText = [StringFactory GetString_OfflinePlayer3ID];
        [m_Players[3] Activate:YES];
        [m_Players[3] IntializePlayerInfo:sText withID:sText inSeat:3 isMyself:NO inLobby:m_GameController];
        
        [self OfflinePlayersLoadMoney];
        [m_GameController SetGameState:GAME_STATE_RESET];
        m_nPlayerTurnIndex = -1;
        [self LocatePlayingSpinner];
        if([m_PlayingSpinner IsActive] == NO)
            [m_PlayingSpinner StartAnimation];
    }
}

-(int)GetMyCurrentMoney
{
    int nRet = -1;
    GamePlayer* myself = [self GetMyself];
    if(myself && [myself IsActivated])
        nRet = [myself GetPacketBalance];
    return nRet;
}

-(void)AddMoneyToMyAccount:(int)nChips
{
    GamePlayer* myself = [self GetMyself];
    if(myself && [myself IsActivated])
    {    
        [myself AddMoneyToPacket:nChips];
        int nMoney = [myself GetPacketBalance];
        [ScoreRecord SetMyChipBalance:nMoney];
        [ScoreRecord SaveScore];
        if([myself IsEnabled] == NO)
            [myself UpdateCurrentGamePlayablity];
    }    
}

-(int)GetPlayerCurrentMoney:(int)nSeat
{
    int nRet = -1;
    
    GamePlayer* player = [self GetPlayer:nSeat];
    if(player && [player IsActivated])
        nRet = [player GetPacketBalance];
    
    return nRet;
}

-(void)AddMoneyToPlayerAccount:(int)nChips inSeat:(int)nSeat
{
    GamePlayer* player = [self GetPlayer:nSeat];
    if(player && [player IsActivated])
    {
        [player AddMoneyToPacket:nChips];
        int nMoney = [player GetPacketBalance];
        if(nSeat == 1)
            [ScoreRecord SetPlayer1ChipBalance:nMoney];
        if(nSeat == 2)
            [ScoreRecord SetPlayer2ChipBalance:nMoney];
        if(nSeat == 3)
            [ScoreRecord SetPlayer3ChipBalance:nMoney];
        
        if([player IsEnabled] == NO)
            [player UpdateCurrentGamePlayablity];
    }
}

-(void)UpdateForGameStateChange
{
    if(m_GameController && [m_GameController GetGameState] == GAME_STATE_RESULT)
    {
        //Calculate total pledge and winners' number
        int nWinNumber = [m_GameController GetWinScopeIndex]+1;
        int nTotalPledge = 0;
        int nWinPlayers = 0;
        int nPledge = 0;
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsEnabled])
            {
                nPledge = [m_Players[i] GetPlayBet];
                if(0 < nPledge)
                {    
                    nTotalPledge += [m_Players[i] GetPlayBet];
                    if([m_Players[i] GetPlayBetLuckNumber] == nWinNumber)
                    {    
                        ++nWinPlayers; 
                    }
                }    
            }
        }
        
        //Restore winners' pledge
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsEnabled])
            {
                if(0 <= nTotalPledge && [m_Players[i] GetPlayBetLuckNumber] == nWinNumber)
                {    
                    nPledge = [m_Players[i] GetPlayBet];
                    [m_Players[i] AddMoneyToPacket: nPledge];
                    nTotalPledge = nTotalPledge - nPledge;
                }    
            }    
        }    
        
        //Set winners' earning chips
        if(nTotalPledge < 0)
            nTotalPledge = 0; 
        
        int nWinChips = -1;
        if(0 < nWinPlayers)
        {
            nWinChips = (int)(((float)nTotalPledge)/((float)nWinPlayers));
        }

        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsEnabled])
            {
                if(0 <= nWinChips && [m_Players[i] GetPlayBetLuckNumber] == nWinNumber)
                {    
                    [m_Players[i] AddMoneyToPacket: nWinChips];
                    [m_Players[i] SetPlayResult:YES];
                    [ScoreRecord SetPlayerLastPlayResult:nWinChips inSeat:i];
                }    
                else
                {
                    [m_Players[i] SetPlayResult:NO];
                    int nBet = [m_Players[i] GetPlayBet]*(-1);
                    [ScoreRecord SetPlayerLastPlayResult:nBet inSeat:i];
                }
                int nChip = [m_Players[i] GetPacketBalance];
                [ScoreRecord SetPlayerChipBalance:nChip inSeat:i];
                [m_Players[i] GameStateChange];
            }
        }    
        [ScoreRecord SaveScore];
        return;
    }
    else if(m_GameController && [m_GameController GetGameState] == GAME_STATE_RESET)
    {
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsActivated])
            {
                [m_Players[i] ClearPlayBet];
                [m_Players[i] UpdateCurrentGamePlayablity];
            }
        }
    }
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            [m_Players[i] GameStateChange];
        }
    }
}

-(void)UpdateForGameTypeChange
{
    
}

-(BOOL)CanSetToOnHold
{
    BOOL bRet = NO;
    
    if(([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET))
    {
        bRet = YES;
    }
    
    return bRet;
}

- (void)RedeemAdViewClosed
{
    if([m_GameController IsSystemOnHold])
    {
        [m_GameController SetSystemOnHold:NO];
    }
    [ApplicationConfigure SetRedeemPlayerSeat:0];
    [self UpdatePlayersCurrentGamePlayablity];
}

-(void)HandleNonSpinTouchEvent
{
    if([m_GameController GetGameState] == GAME_STATE_RESET)
    {
        if([Configuration isRoPaAutoBet])
        {
            GamePlayer* pMyself = [self GetMyself];
            if(pMyself && [pMyself IsActivated])
            {
                [pMyself UpdateCurrentGamePlayablity];
                if([pMyself IsEnabled] == NO)
                {
                    if([self CanSetToOnHold])
                    {
                        [m_GameController SetSystemOnHold:YES];
                        [ApplicationConfigure SetRedeemPlayerSeat:0];
                        [GUIEventLoop SendEvent:GUIID_EVENT_PURCHASECHIPS eventSender:self];
                    }
                    return;
                }
                if([pMyself AlreadyMadePledge] == NO)
                {
                    [[CGameSectionManager GetGlobalGameUIDelegate] MakePlayerManualPledge:0];
                    return;
                }
            }
            [self UpdateOfflineOtherPlayersAutoPledge:YES];
        }
        else 
        {
            for(int i = 0; i < 4; ++i)
            {
                if(m_Players[i] && [m_Players[i] IsEnabled] && [m_Players[i] AlreadyMadePledge] == NO)
                {
                    [[CGameSectionManager GetGlobalGameUIDelegate] MakePlayerManualPledge:i];
                    return;
                }
            }
        }
    }
    else if([m_GameController GetGameState] == GAME_STATE_RESULT)
    {
        [m_GameController SetGameState:GAME_STATE_RESET];
        return;         
    }
}

-(void)HoldMyTurnIfNeeded
{
    if([self IsMyTurn])
    {
        m_nPlayerTurnIndex = -1;
    }
}

-(BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nIndex
{
    BOOL bRet = NO;
    if(0 <= nIndex && nIndex < 4)
    {
        if(m_Players[nIndex] && ([m_Players[nIndex] CanPlayGame:nType] || [m_Players[nIndex] IsEnabled]))
        {
            return YES;
        }
    }
    return bRet;
}

-(void)OfflinePlayersPledgeDone
{
    [self ShowPlayersPledgeInformation];
    [m_GameController SetGameState:GAME_STATE_READY];
    [self UpdateOffLineGamePlayTurn];
}


-(void)CheckOfflineNextPlayerManualPledge:(int)nSeat
{
    int nCount = 4;
    if(0 <= nSeat && nSeat < nCount-1)
    {
        if(m_Players[nSeat] && (([m_Players[nSeat] IsEnabled] && [m_Players[nSeat] AlreadyMadePledge]) || (![m_Players[nSeat] IsEnabled] && nSeat != 0)))
        {
            [self CheckOfflineNextPlayerManualPledge:(nSeat+1)%nSeat];
            return;
        }
    }
    else if(nSeat == nCount-1)
    {
        if(m_Players[nSeat] && (([m_Players[nSeat] IsEnabled] && [m_Players[nSeat] AlreadyMadePledge]) || (!m_Players[nSeat] || ![m_Players[nSeat] IsEnabled])))
        {
            [self OfflinePlayersPledgeDone];
            return;
        }
    }
}

-(void)PlayerFinishPledge:(int)nSeat withNumber:(int)nLuckNumber withBet:(int)nBetMoney
{
    int nCount = 4;
    if(nSeat == 0 && m_Players[nSeat] && [m_Players[nSeat] IsActivated])
    {
        [m_Players[nSeat] MakePlayBet:nLuckNumber withPledge:nBetMoney];
        //m_bMyselfMakeBet = NO;
        if([Configuration isRoPaAutoBet])
        {
            [self UpdateOfflineOtherPlayersAutoPledge:YES];
            return;
        }
        else
        {
            [self CheckOfflineNextPlayerManualPledge:(nSeat+1)%nCount];
            return;
        }
    }
    else if(nSeat < nCount-1 && m_Players[nSeat] && [m_Players[nSeat] IsActivated])
    {
        if([Configuration isRoPaAutoBet] == NO)
        {
            [m_Players[nSeat] MakePlayBet:nLuckNumber withPledge:nBetMoney];
            [self CheckOfflineNextPlayerManualPledge:(nSeat+1)%nCount];
            return;
        }
    }
    else if(nSeat == nCount-1 && m_Players[nSeat] && [m_Players[nSeat] IsActivated])
    {
        if([Configuration isRoPaAutoBet] == NO)
        {
            [m_Players[nSeat] MakePlayBet:nLuckNumber withPledge:nBetMoney];
            [self OfflinePlayersPledgeDone];
            return;
        }
    }
}

-(void)RestoreOffLineReadyState
{
    if([m_GameController IsSystemOnHold])
    {
        [m_GameController SetSystemOnHold:NO];   
    }
    
    if([Configuration isDirty])
    {
        int nType = [Configuration getCurrentGameType];
        [m_GameController SetGameType:nType theme:[Configuration getCurrentGameTheme]];
        [self UpdatePlayersCurrentGamePlayablity];
    }
    
    [ApplicationConfigure SetRedeemPlayerSeat:0];
    [m_GameController SetGameState:GAME_STATE_RESET];
    
}

-(void)PauseGame
{
    [self CancelPendPlayerBet];
    [m_GameController SetGameState:GAME_STATE_RESET];
    [self SavePlayersOfflineStateInformation];
    
}

-(void)PlayerTranfereChipsFrom:(int)nSeat To:(int)nReceiverID withChips:(int)nChips
{
    if([m_GameController IsSystemOnHold])
    {
        [m_GameController SetSystemOnHold:NO];   
    }
    if(nSeat < 0 || 3 < nSeat || nReceiverID < 0 || 3 < nReceiverID || nChips == 0)
        return;
    
    [self AddMoneyToPlayerAccount:-nChips inSeat:nSeat];
    [self AddMoneyToPlayerAccount:nChips inSeat:nReceiverID];
    [ApplicationConfigure SetRedeemPlayerSeat:0];
    [self UpdatePlayersCurrentGamePlayablity];
}

-(NSString*)GetPlayerName:(int)nSeatID
{
    NSString* str = @"";
    if (0 <= nSeatID && nSeatID < 4)
    {
        return [m_Players[nSeatID] GetPlayerName];
    }
    return str;
}

-(BOOL)IsSystemOnHold
{
    return m_bOnHold;
}

-(void)SetSystemOnHold:(BOOL)bOnHold
{
    m_bOnHold = bOnHold;
}

-(void)ShutdownSection
{
    [self PauseGame];
    [super ShutdownSection];
}

-(void)StartGameSection
{
    [super StartGameSection];
/*    NSString* sText = [StringFactory GetString_OfflineMySelfID];
    [m_Players[0] Activate:YES];
    [m_Players[0] SetPlayerID:sText];
    [m_Players[0] SetPlayerName:sText];
    [m_Players[0] SetMySelfFlag:YES];
    
    sText = [StringFactory GetString_OfflinePlayer1ID];
    [m_Players[1] Activate:YES];
    [m_Players[1] SetPlayerID:sText];
    [m_Players[1] SetPlayerName:sText];
    [m_Players[1] SetMySelfFlag:NO];
    
    sText = [StringFactory GetString_OfflinePlayer2ID];
    [m_Players[2] Activate:YES];
    [m_Players[2] SetPlayerID:sText];
    [m_Players[2] SetPlayerName:sText];
    [m_Players[2] SetMySelfFlag:NO];
    
    sText = [StringFactory GetString_OfflinePlayer3ID];
    [m_Players[3] Activate:YES];
    [m_Players[3] SetPlayerID:sText];
    [m_Players[3] SetPlayerName:sText];
    [m_Players[3] SetMySelfFlag:NO];
    
    [self OfflinePlayersLoadMoney];
    [m_GameController SetGameState:GAME_STATE_RESET];
    m_nPlayerTurnIndex = -1;
    [self LocatePlayingSpinner];*/
    [self InitializeDefaultPlayersConfiguration];    
    if([m_PlayingSpinner IsActive] == NO)
    {
        [m_PlayingSpinner StartAnimation];
    }
}

-(int)GetActivatedPlayerCount
{
    return 4;
}

@end
