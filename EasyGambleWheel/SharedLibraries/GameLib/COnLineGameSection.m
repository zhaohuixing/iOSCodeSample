//
//  COnLineGameSection.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "GameConstants.h"
#import "COnLineGameSection.h"
#import "COnLineGameSection+GKMatchFunctions.h"
#import "COnLineGameSection+GameMessageHandler.h"
#import "ScoreRecord.h"
#import "GameMsgConstant.h"
#import "Configuration.h"
#import "GameViewController.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"
#import "CGameSectionManager.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "GamePlayer+Online.h"
#import "StringFactory.h"

@implementation COnLineGameSection

//////////////////////////////////////////////////
//Asynchronized call functions
//////////////////////////////////////////////////
- (void)callSingleParamenterFunction: (SEL) selector withParam:(id)param
{
	assert([NSThread isMainThread]);
	if([self respondsToSelector: selector])
	{
		if(param != NULL)
		{
			[self performSelector: selector withObject:param];
		}
		else
		{
			[self performSelector: selector];
		}
	}
	else
	{
		NSLog(@"callSingleParamenterFunction Missed Method");
	}
}

- (void) callSingleParamenterFunctionOnMainThread: (SEL) selector withParam:(id)param
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [self callSingleParamenterFunction: selector withParam:param];
    });
}

- (void)callDualParamentersFunction: (SEL) selector withParam1:(id)param1 withParam2:(id)param2
{
	assert([NSThread isMainThread]);
	if([self respondsToSelector:selector])
	{
        [self performSelector:selector withObject:param1 withObject:param2];
	}
	else
	{
		NSLog(@"callDualParamentersFunction Missed Method");
	}
}

- (void)callDualParamentersFunctionOnMainThread: (SEL) selector withParam1:(id)param1 withParam2:(id)param2
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [self callDualParamentersFunction:selector withParam1:param1 withParam2:param2];
    });
}
//////////////////////////////////////////////////
//End 
//////////////////////////////////////////////////
-(id)init
{
    self = [super init];
    if(self)
    {
        m_bHost = NO;      
        m_AppleGameCenter = nil;
        m_GKBTGameSession = nil;
        m_MyGKBTID = [[UIDevice currentDevice] name];
        m_MyGKBTName = m_MyGKBTID;
        m_GKBTPeerID = nil;

        m_bGKCenterMasterCheck = NO;
        m_TimeStartGKCenterMasterCheck = 0;
        m_bAWSGameMasterSettingReceived = NO;
        m_bAWSGamePeerBalanceReceived = NO;
        
		[GUIEventLoop RegisterEvent:GUIID_TEXTMESG_SENDBUTTON_CLICK eventHandler:@selector(OnSendMyTextMessage) eventReceiver:self eventSender:nil];
    }
    
    return self;
}

-(void)dealloc
{
    
}

-(void)Release
{
    if(m_AppleGameCenter)
    {
        [m_AppleGameCenter disconnect];
        m_AppleGameCenter = nil;
    }
    [self ResetGKBluetoothSession];
}

-(GKPlayer*)GetOnlinePlayer:(NSString*)playerID
{
    GKPlayer* pPlayer = nil;
    
    if(m_AppleGameCenter != nil && m_AppleGameCenter.players != nil && 0 < m_AppleGameCenter.players.count)
    {
        for(GKPlayer* pPlayerElement in m_AppleGameCenter.players)
        {
            if(pPlayerElement != nil && pPlayerElement.playerID != nil && [pPlayerElement.playerID isEqualToString:playerID] == YES)
            {
                pPlayer = pPlayerElement;
                break;
            }
        }
    }
    
    return pPlayer;
}

-(int)GetGameOnlineState
{
    return GAME_ONLINE_STATE_ONLINE;
}

-(void)OnTouchBegin:(CGPoint)pt
{
    if([m_GameController IsSystemOnHold] || m_bGKCenterMasterCheck == YES)
        return;
    
    if([self IsOnlineGameStateReadyToPlay] == NO)
        return;
    
    if([self IsMyTurn])
    {
        m_ptTouchStart = pt;
        m_timeTouchStart = [[NSProcessInfo processInfo] systemUptime];
        return;
    }
}

-(void)OnTouchMove:(CGPoint)pt
{
    if([m_GameController IsSystemOnHold] || m_bGKCenterMasterCheck == YES)
        return;
    
    if([self IsOnlineGameStateReadyToPlay] == NO)
        return;
}

-(void)OnTouchEnd:(CGPoint)pt
{
    if([m_GameController IsSystemOnHold] || m_bGKCenterMasterCheck == YES)
        return;
    
    if([self IsOnlineGameStateReadyToPlay] == NO)
    {
        [self HandleNonSpinTouchEvent];
        return;
    } 
    
    if([self IsMyTurn])
    {
        m_ptTouchEnd = pt;
        NSTimeInterval endTime = [[NSProcessInfo processInfo] systemUptime];
        float time = endTime - m_timeTouchStart;
        CPinActionLevel* action = [[CPinActionLevel alloc] initLevel:m_ptTouchStart withPoint2:m_ptTouchEnd withTime:time];
        [self PostSpinGambleWheelMessage:action];
        [m_GameController SpinGambleWheel:action];
        for (int i = 0; i < 4; ++i) 
        {
            if(m_Players[i] && [m_Players[i] IsEnabled])
            {
                [m_Players[i] SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RUN];
                if([m_Players[i] IsMyself])
                    [self PostMyOnlineGameState];
            }
        }
    }    
}

-(void)OnTouchCancel:(CGPoint)pt
{
    [self OnTouchEnd:pt];
}

-(void)OnTimerEvent
{
    [super OnTimerEvent];
    if(m_bGKCenterMasterCheck && !m_bHost)
    {
        if(![self HasGKCenterMaster])
        {
            NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
            if(ONLINE_GAME_NONGKMASTER_CHECK_TIMELINE <= (currentTime - m_TimeStartGKCenterMasterCheck))
            {
                [self NomiateGKCenterMasterInPeerToPeer];
            }
        }
        else 
        {
            m_bGKCenterMasterCheck = NO;
        }
    }
}

-(void)InitializeDefaultPlayersConfiguration
{
    
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
        [self PostMyOnlineGameBalance];
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
        if([player IsEnabled] == NO)
            [player UpdateCurrentGamePlayablity];
        //??????????????????????????????
        //??????????????????????????????
        //??????????????????????????????
        //??????????????????????????????
        //??????????????????????????????
        //??????????????????????????????
        //??????????????????????????????
    }
}

-(void)UpdateForGameStateChange
{
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    int nGameState = [m_GameController GetGameState];
    int nMySeatID = [self GetMySeatID];
    if(nGameState == GAME_STATE_RUN)
    {
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsEnabled])
            {
                [m_Players[i] SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RUN];
                if([m_Players[i] GetSeatID] == nMySeatID)
                {
                    [self PostMyOnlineGameState];
                }
            }
        }
    }
    else if(nGameState == GAME_STATE_RESULT)
    {
        int nMySeatID = [self GetMySeatID];
        int nWinNumber = [m_GameController GetWinScopeIndex]+1;
        int nTotalPledge = 0;
        int nWinPlayers = 0;
        int nPledge = 0;
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsEnabled] && [m_Players[i] AlreadyMadePledge])
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
            if(m_Players[i] && [m_Players[i] IsEnabled] && [m_Players[i] AlreadyMadePledge])
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
        
        NSString* myStatus = [StringFactory GetString_PlayingDone];
        NSString* otherStatus = @"";
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsEnabled] && [m_Players[i] AlreadyMadePledge])
            {
                if(0 <= nWinChips && [m_Players[i] GetPlayBetLuckNumber] == nWinNumber)
                {    
                    [m_Players[i] AddMoneyToPacket: nWinChips];
                    [m_Players[i] SetPlayResult:YES];
                    if(nMySeatID == [m_Players[i] GetSeatID])
                    {    
                        [ScoreRecord SetMyLastPlayResult:nWinChips];
                        myStatus = [StringFactory GetString_YouWin];
                        //????????????????
                        //????????????????
                        //????????????????
                        //????????????????
                        //OnlineScore
                        //????????????????
                        //????????????????
                        //????????????????
                        //????????????????
                        //????????????????
                    }    
                }    
                else
                {
                    [m_Players[i] SetPlayResult:NO];
                    int nBet = [m_Players[i] GetPlayBet]*(-1);
                    if(nMySeatID == [m_Players[i] GetSeatID])
                    {    
                        [ScoreRecord SetMyLastPlayResult:nBet];
                        myStatus = [StringFactory GetString_YouLose];
                        //????????????????
                        //????????????????
                        //????????????????
                        //????????????????
                        //OnlineScore
                        //????????????????
                        //????????????????
                        //????????????????
                        //????????????????
                        //????????????????
                    }    
                }
                if(nMySeatID == [m_Players[i] GetSeatID])
                {    
                    int nChip = [m_Players[i] GetPacketBalance];
                    [ScoreRecord SetPlayerChipBalance:nChip inSeat:nMySeatID];
                    [self PostMyOnlineGameBalance];
                    [m_Players[i] SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RESULT];
                    [self PostMyOnlineGameState];
                }
                else 
                {
                    if([m_Players[i] GetOnlinePlayingState] == GAME_ONLINE_PLAYER_STATE_RUN)
                        otherStatus = [StringFactory GetString_OtherStillPlaying];
                }
                [m_Players[i] GameStateChange];
                
            }
        }    
        [ScoreRecord SaveScore];
        NSString* szText = [NSString stringWithFormat:@"%@ %@", myStatus, otherStatus];
        [pController ShowStatusBar:szText];
        return;
    }
    else if(nGameState == GAME_STATE_RESET)
    {
        /*GamePlayer* mySelf = [self GetMyself];
        if(mySelf && [mySelf IsEnabled])
        {
            [mySelf SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RESET];
            [self PostMyOnlineGameState];
            [mySelf GameStateChange];
        }*/
        for(int i = 0; i < 4; ++i)
        {    
            if(m_Players[i] && [m_Players[i] IsEnabled])
            {
                if([m_Players[i] GetOnlinePlayingState] == GAME_ONLINE_PLAYER_STATE_RESET)
                {
                    [m_Players[i] GameStateChange];
                    [m_Players[i] UpdateOnlinePlayingStateByMoneyBalance];
                }
            }
        }
        if([Configuration isPlayTurnBySequence])
        {
            [pController ShowStatusBar:[StringFactory GetString_PlayTurnIsSequence]];
        }
        else 
        {
            [pController ShowStatusBar:[StringFactory GetString_PlayTurnIsMaxBet]];
        }
    }    
}

-(void)UpdateForGameTypeChange
{
    
}

-(void)HandleNonSpinTouchEvent
{
    if([m_GameController GetGameState] == GAME_STATE_RESET)
    {
        GamePlayer* pMyself = [self GetMyself];
        if(pMyself && [pMyself IsEnabled])
        {
            BOOL bCanPledge = YES;
            
            for(int i = 0; i < 4; ++i)
            {
                if(m_Players[i] && [m_Players[i] IsEnabled] && ![m_Players[i] IsMyself] && ([m_Players[i] GetOnlinePlayingState] == GAME_ONLINE_PLAYER_STATE_RESULT || [m_Players[i] GetOnlinePlayingState] == GAME_ONLINE_PLAYER_STATE_RUN))
                {
                    bCanPledge = NO;
                    break;
                }
            }
            
            if([pMyself AlreadyMadePledge] == NO && bCanPledge)
            {
                [[CGameSectionManager GetGlobalGameUIDelegate] MakePlayerManualPledge:[pMyself GetSeatID]];
                return;
            }
        }    
    }
    else if([m_GameController GetGameState] == GAME_STATE_RESULT)
    {
        BOOL bCanClick = YES;
        
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsEnabled] && ![m_Players[i] IsMyself] && [m_Players[i] GetOnlinePlayingState] == GAME_ONLINE_PLAYER_STATE_RUN)
            {
                bCanClick = NO;
                break;
            }
        }
        
        GamePlayer* pPLayer = [self GetMyself];
        if(pPLayer && [pPLayer IsEnabled] && bCanClick)
        {
            [pPLayer SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RESET];
            [pPLayer UpdateOnlinePlayingStateByMoneyBalance];
            [self PostMyOnlineGameState];
            [m_GameController SetGameState:GAME_STATE_RESET];
            return;         
        }
    }

    GamePlayer* pMyself = [self GetMyself];
    if(pMyself && [pMyself IsActivated] && ![pMyself IsEnabled])
    {
        [m_GameController SetSystemOnHold:YES];
        [ApplicationConfigure SetRedeemPlayerSeat:[pMyself GetSeatID]];
        [GUIEventLoop SendEvent:GUIID_EVENT_PURCHASECHIPS eventSender:self];
        return;
    }    
}

-(void)HoldMyTurnIfNeeded
{
    
}

-(void)UpdateOnlinePlayersStateToReady
{
    BOOL bShowBet = YES;
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled])
        {
            if ([m_Players[i] AlreadyMadePledge] == NO || [m_Players[i] GetOnlinePlayingState] != GAME_ONLINE_PLAYER_STATE_READY) 
            {
                return;
            }
        }
    }
    if(bShowBet)
    {
        [self ShowPlayersPledgeInformation];
        [self MakeOnlinePlayTurn];
        [m_GameController SetGameState:GAME_STATE_READY];
    }
}

-(BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID
{
    return YES;
}

-(void)PlayerFinishPledge:(int)nSeat withNumber:(int)nLuckNumber withBet:(int)nBetMoney
{
    GamePlayer* pPlayer = [self GetPlayer:nSeat];
    if(pPlayer && [pPlayer IsActivated])
    {
        [pPlayer MakePlayBet:nLuckNumber withPledge:nBetMoney];
        [pPlayer SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_READY];
        int nMyseatiD = [self GetMySeatID];
        if(nMyseatiD == nSeat)
        {
            [self PostMyOnlineGameBet];
        }
        
        [self UpdateOnlinePlayersStateToReady];
    }
}

-(void)PauseGame
{
    [self CancelPendPlayerBet];
    [m_GameController SetGameState:GAME_STATE_RESET];
    int nType = [m_GameController GetGameType];
    [ScoreRecord SetGameType:nType];
    [ScoreRecord SetGameTheme:[Configuration getCurrentGameTheme]];
    [ScoreRecord SetSoundEnable:[Configuration canPlaySound]];
    [ScoreRecord SetPlayTurnType:[Configuration getPlayTurnType]];
    
    GamePlayer* pMyself = [self GetMyself];
    
    int nChips ;
    if(pMyself)
    {
        nChips = [pMyself GetPacketBalance];
        [ScoreRecord SetMyChipBalance:nChips];
    }
    [ScoreRecord SaveScore];
    
    if(m_GameController)
        [m_GameController GotoOfflineGame];
}

-(void)CancelPendPlayerBet
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled])
        {
            [m_Players[i] CancelPendingBet];
            [m_Players[i] SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RESET];
        }
    }
    [m_GameController SetGameState:GAME_STATE_RESET];
    [self PostMyOnlineGameBalance];
    [self PostMyOnlineGameState];
}

-(void)PlayerTranfereChipsFrom:(int)nSeat To:(int)nReceiverID withChips:(int)nChips
{
    if([m_GameController IsSystemOnHold])
    {
        [m_GameController SetSystemOnHold:NO];   
    }
    if(nSeat < 0 || 3 < nSeat || nReceiverID < 0 || 3 < nReceiverID || nChips == 0)
        return;

    GamePlayer* player = [self GetPlayer:nReceiverID];
    if(!player || ![player IsActivated])
    {
        return;
    }
    NSString* szPlayerID = [player GetPlayerID];
    if(!szPlayerID || [szPlayerID length] <= 0)
        return;
    
    [self AddMoneyToPlayerAccount:-nChips inSeat:nSeat];
    [self AddMoneyToPlayerAccount:nChips inSeat:nReceiverID];
    GamePlayer* myself = [self GetMyself];
    if(myself)
    {
        [myself SetCachedTransferedChipNumber:nChips];
    }
    [self PostChipTransferMessage:nChips receiverID:szPlayerID];
    [self PostMyOnlineGameBalance];
    
    [ApplicationConfigure SetRedeemPlayerSeat:0];
}

- (void)RedeemAdViewClosed
{
    
}

-(NSString*)GetPlayerName:(int)nSeatID
{
    NSString* strName = @"";
    
    GamePlayer* pPlayer = [self GetPlayer:nSeatID];
    if(pPlayer)
        strName = [pPlayer GetPlayerName];
    
    return strName;
}

-(BOOL)IsSystemOnHold
{
    return NO;
}

-(void)SetSystemOnHold:(BOOL)bOnHold
{
}

-(void)SetOnlineGameHost:(BOOL)bHost
{
    m_bHost = bHost;
}

-(BOOL)IsOnlineGameHost
{
    return m_bHost;
}

-(void)SetOnLinePlayTurn
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled])
        {
            if([m_Players[i] GetSeatID] == m_nPlayerTurnIndex)
            {
                [m_Players[i] SetMyTurn:YES];
            }
            else
            {
                [m_Players[i] SetMyTurn:NO];
            }
        }
    }
}

-(void)MakeNextOnlinePlayTurnBySequence
{
    int nCount = [self GetEnabledOnlinePlayesCount];
    if(nCount <= 0)
        return;
    
    if(m_nPlayerTurnIndex < 0)
    {
        m_nPlayerTurnIndex = 0;
    }
    else 
    {
        m_nPlayerTurnIndex = (m_nPlayerTurnIndex+1)%nCount;
    }
    GamePlayer* pPlayer = [self GetPlayer:m_nPlayerTurnIndex];
    if(pPlayer && [pPlayer IsEnabled])
    {    
        [self SetOnLinePlayTurn];
        [self LocatePlayingSpinner];
        if(m_bHost)
            [self SendNextPlayTurnMessage];
    }
    else
    {
        [self MakeNextOnlinePlayTurnBySequence];
    }
}

-(void)MakeNextOnlinePlayTurnByMaxBet
{
    int nBetMax = 0;
    m_nPlayerTurnIndex = 0;
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled] && [m_Players[i] AlreadyMadePledge])
        {
            int nBet = [m_Players[i] GetPlayBet];
            if(nBetMax < nBet)
            {
                m_nPlayerTurnIndex = [m_Players[i] GetSeatID];
                nBetMax = nBet;
            }
        }
    }
    GamePlayer* pPlayer = [self GetPlayer:m_nPlayerTurnIndex];
    if(pPlayer && [pPlayer IsEnabled])
    {    
        [self SetOnLinePlayTurn];
        [self LocatePlayingSpinner];
        if(m_bHost)
            [self SendNextPlayTurnMessage];
    }
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    NSString* playerName = [self GetPlayerName:m_nPlayerTurnIndex];
    NSString* szText = [NSString  stringWithFormat:[StringFactory GetString_ItIsPlayTurnFmt], playerName];
    [pController ShowStatusBar:szText];
}

-(void)MakeOnlinePlayTurn
{
    if([Configuration getPlayTurnType] == GAME_PLAYTURN_TYPE_SEQUENCE)
    {
        [self MakeNextOnlinePlayTurnBySequence];
    }
    else 
    {
        [self MakeNextOnlinePlayTurnByMaxBet];
    }
    
}

-(int)GetEnabledOnlinePlayesCount
{
    int nRet = 0;
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled])
        {
            ++nRet;
        }
    }
    
    return nRet;
}

-(GamePlayer*)GetPlayerByPlayerID:(NSString*)szPlayerID
{
    GamePlayer* pPlayer = nil;
    if(szPlayerID == nil)
        return pPlayer;
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] GetPlayerID] && [szPlayerID isEqualToString:[m_Players[i] GetPlayerID]])
        {
            return m_Players[i];
        }
    }
    
    return pPlayer;
}

-(int)GetPlayerSeatID:(NSString*)szPlayerID
{
    int nRet = -1;
    if(szPlayerID == nil)
        return nRet;
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] GetPlayerID] && [szPlayerID isEqualToString:[m_Players[i] GetPlayerID]])
        {
            nRet = [m_Players[i] GetSeatID];
            return nRet;
        }
    }
    
    return nRet;
}

-(int)GetMySeatID
{
    int nRet = -1;
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] GetPlayerID] && [m_Players[i] IsMyself])
        {
            nRet = [m_Players[i] GetSeatID];
            return nRet;
        }
    }
    
    return nRet;
}

-(BOOL)IsMyTurn
{
    BOOL bRet = NO;
    int nMySeatID = [self GetMySeatID];
    if(nMySeatID == m_nPlayerTurnIndex)
        bRet = YES;
    
    return bRet;
}

-(void)ShutdownSection
{
    [Configuration setOnline:NO];
    int nState = [m_GameController GetGameState];
    if(nState == GAME_STATE_READY || nState == GAME_STATE_RUN)
        [self CancelPendPlayerBet];
    
    GamePlayer* mySelf = [self GetMyself];
    if(mySelf)
    {
        int nBalance = [mySelf GetPacketBalance];
        [ScoreRecord SetMyChipBalance:nBalance];
        [ScoreRecord SaveScore];
    }
    
    if(m_AppleGameCenter)
    {
        [m_AppleGameCenter disconnect];
        m_AppleGameCenter = nil;
    }
    [self ResetGKBluetoothSession];
    m_bHost = NO;
    m_bGKCenterMasterCheck = NO;
    [super ShutdownSection];
}

- (void) AbsoultShutDownOnlineGame
{
    [Configuration setOnline:NO];
    int nState = [m_GameController GetGameState];
    if(nState == GAME_STATE_READY || nState == GAME_STATE_RUN)
        [self CancelPendPlayerBet];
    
    GamePlayer* mySelf = [self GetMyself];
    if(mySelf)
    {
        int nBalance = [mySelf GetPacketBalance];
        [ScoreRecord SetMyChipBalance:nBalance];
        [ScoreRecord SaveScore];
    }
    
    if(m_AppleGameCenter)
    {
        [m_AppleGameCenter disconnect];
        m_AppleGameCenter = nil;
    }
    [self ResetGKBluetoothSession];
    m_bHost = NO;
    m_bGKCenterMasterCheck = NO;
    [super ShutdownSection];
}

-(void)StartGameSection
{
    [super StartGameSection];
}

-(BOOL)IsOnlineGameStateReadyToPlay
{
    BOOL bRet = YES;
    
    if([m_GameController GetGameState] != GAME_STATE_READY)
        return NO;

    BOOL bHaveActiveOne = NO;
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled])
        {
            bHaveActiveOne = YES;
            if([m_Players[i] GetOnlinePlayingState] != GAME_ONLINE_PLAYER_STATE_READY)
                return NO;
        }
    }
    if(bHaveActiveOne == NO)
        return NO;
    
    return bRet;
}

-(int)GetActivatedPlayerCount
{
    int nRet = 0;
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            ++nRet;
        }
    }
    
    return nRet;
}


////////////////////////////////////////////////////////////
//
// Online Game message handling functions
//
////////////////////////////////////////////////////////////
-(void)parserMessageInformation:(NSDictionary*)msgData fromPlayer:(NSString*)playerID
{
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"parserMessageInformation is called from : %@", playerID];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
    NSNumber* msgTypeID = [msgData valueForKey:GAME_MSG_KEY_TYPE];
    if(msgTypeID == nil)
    {
#ifdef DEBUG
        [ApplicationConfigure LogDebugInformation:@"parserMessageInformation cannot find message type information"];
#endif     
        return;
    }
    int nTypeID = [msgTypeID intValue];
    switch (nTypeID)
    {
        case GAME_MSG_TYPE_TEXT:
        {
#ifdef DEBUG
            [ApplicationConfigure LogDebugInformation:@"parserMessageInformation message type is text message"];
#endif     
            NSString* msgText = [msgData valueForKey:GAME_MSG_KEY_TEXTMSG];
            if(msgText != nil)
            {
                [self handleTextMessage:msgText fromPlayer:playerID];
            }
            break;
        }
        case GAME_MSG_TYPE_MASTERCANDIATES:
        {
            [self handlePlayersOrderMessage:msgData];
            break;
        }
        case GAME_MSG_TYPE_GAMESETTINGSYNC:
        {
            [self handleGameSetttingMessage:msgData];
            break;
        }
        case GAME_MSG_TYPE_PLAYERBALANCE:
        {
            [self handlePlayerBalanceMessage:msgData];
            break;
        }
        case GAME_MSG_TYPE_PLAYERBET:
        {
            [self handlePlayerPledgeBetMessage:msgData];
            break;
        }
        case GAME_MSG_TYPE_GAMEPLAYNEXTTURN:
        {
            [self handleNextPlayTurnMessage:msgData];
            break;
        }
        case GAME_MSG_TYPE_PLAYERSTATE:
        {
            [self handlePlayerStateChangeMessage:msgData];
            break;
        }
        case GAME_MSG_TYPE_PLAYERPLAYABLITY:
        {
            [self handlePlayerPlayablityChangeMessage:msgData];
            break;
        }
        case GAME_MSG_TYPE_CANCELPENDINGBET:
        {
            [self CancelPendPlayerBet];
            break;
        }
        case GAME_MSG_TYPE_MONEYTRANSFER:
        {
            [self handleChipTransferMessage:msgData fromPlayer:playerID];
            break;
        }
        case GAME_MSG_TYPE_MONEYTRANSFERRECEIPT:
        {
            [self handleChipTransferReceiptMessage];
            break;
        }
        case GAME_MSG_TYPE_ACTIONLEVEL:
        {
            [self handleSpinGambleWheelMessage:msgData];
            break;
        }
        case GAME_MSG_TYPE_AWSGAMEMASTERSETTINGNOTRECEIVED:
        {
            break;
        }
        case GAME_MSG_TYPE_AWSGAMEPEERBALANCENOTRECEIVED:
        {
            break;
        }
    }

    GameViewController* pAppController = (GameViewController*)[GUILayout GetGameViewController];
    if(pAppController && [pAppController GetCurrentGameUIDelegate])
    {
        [[pAppController GetCurrentGameUIDelegate] UpdateGameUI];
    }
}

-(BOOL)HasGKCenterMaster
{
    BOOL bRet = NO;
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [m_Players[i] IsGKCenterMaster])
            return YES;
    }
    
    return bRet;
}

-(void)StartGKCenterMasterCheck
{
    m_bGKCenterMasterCheck = YES;
    m_TimeStartGKCenterMasterCheck = [[NSProcessInfo  processInfo] systemUptime];
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    [pController ShowStatusBar:[StringFactory GetString_SortPlayers]];
}

-(void)StopGKCenterMasterCheck
{
    m_bGKCenterMasterCheck = NO;
}

-(void)NomiateGKCenterMasterInPeerToPeer
{
    NSMutableArray* nSeatIDList = [[NSMutableArray alloc] init];
    NSMutableArray* nPlayerIDList = [[NSMutableArray alloc] init];

    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            NSNumber* number = [[NSNumber alloc] initWithInt:i];
            [nPlayerIDList addObject:number];
        }
    }
    
    int nPlayerLeftCount = (int)[nPlayerIDList count];
    
    while (0 < nPlayerLeftCount) 
    {
        int nMaxPlayerIndex = 0;
        int index = [[nPlayerIDList objectAtIndex:nMaxPlayerIndex] intValue];
        NSString* szMaxPlayerID = [m_Players[index] GetPlayerID];
        
        for(int i = nMaxPlayerIndex+1; i < nPlayerLeftCount; ++i)
        {
            int nTempIndex = [[nPlayerIDList objectAtIndex:i] intValue];
            NSString* szTempPlayerID = [m_Players[nTempIndex] GetPlayerID];
            if([szMaxPlayerID compare:szTempPlayerID options:NSNumericSearch] == NSOrderedAscending)
            {
                szMaxPlayerID = [NSString stringWithFormat:@"%@", szTempPlayerID];
                index = nTempIndex;
                nMaxPlayerIndex = i;
            }
        }
        NSNumber* number = [[NSNumber alloc] initWithInt:index];
        [nSeatIDList addObject:number];
        number = [nPlayerIDList objectAtIndex:nMaxPlayerIndex];
        [nPlayerIDList removeObjectAtIndex:nMaxPlayerIndex];
        nPlayerLeftCount = (int)[nPlayerIDList count];
    };
    
    nPlayerLeftCount = (int)[nSeatIDList count];
    if(0 < nPlayerLeftCount)
    {
        int nFirstIndex = [[nSeatIDList objectAtIndex:0] intValue];
        if(0 <= nFirstIndex && nFirstIndex < 4 && m_Players[nFirstIndex] && [m_Players[nFirstIndex] IsActivated] && [m_Players[nFirstIndex] IsMyself])
        {
            for(int i = 0; i < [nSeatIDList count]; ++i)
            {
                int nIndex = [[nSeatIDList objectAtIndex:i] intValue];
                if(0 <= nIndex && nIndex < 4 && m_Players[nIndex] && [m_Players[nIndex] IsActivated])
                {
                    [m_Players[nIndex] SetSeatID:i];
                }
            }
            m_bHost = YES;
            [self PostOnlineGamePlayersOrder];
            [self PostOnlineGameSettting];
            [m_Players[nFirstIndex] SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RESET];
            [self PostMyOnlineGameState];
            [m_Players[nFirstIndex] UpdateCurrentGamePlayablity];
            [self PostMyOnlineGameBalance];
            [self StopGKCenterMasterCheck];
        }
    }
    [nSeatIDList removeAllObjects];
}

-(void)DelayPostMyInfo
{
    GamePlayer* pPlayer = [self GetMyself];
    if(pPlayer)
        [pPlayer UpdateCurrentGamePlayablity];
    [self PostMyOnlineGameBalance];
}

-(void)OpenOnlinePlayerPopupMenu:(int)nSeatID
{
    GamePlayer* pPlayer = [self GetPlayer:nSeatID];
    if(pPlayer)
    {
        [pPlayer OpenOnlinePopupMenu];
    }
}


@end
