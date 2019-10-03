//
//  COnLineGameSection+GameMessageHandler.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "COnLineGameSection+GameMessageHandler.h"
#import "COnLineGameSection+GKMatchFunctions.h"
#import "GameMsgConstant.h"
#import "Configuration.h"
#import "GamePlayer+Online.h"
#import "ApplicationConfigure.h"
#import "StringFactory.h"
#import "GameViewController.h"
#import "GUILayout.h"

@implementation COnLineGameSection (GameMessageHandler)

-(void)UpdateOnlineGamePlayerPlayabilty
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

- (NSString*)GetPlayerMsgKey:(int)nSeat
{
    NSString* sKey = @"";
    if(nSeat == 0)
        sKey = GAME_MSG_KEY_MASTER_ID; 
    else if(nSeat == 1)
        sKey = GAME_MSG_KEY_PLAYERONE_ID; 
    else if(nSeat == 2)
        sKey = GAME_MSG_KEY_PLAYERTWO_ID; 
    else if(nSeat == 3)
        sKey = GAME_MSG_KEY_PLAYERTHREE_ID; 
    
    return sKey;
}


-(void)handleTextMessage:(NSString*)szText fromPlayer:(NSString*)playerID
{
#ifdef DEBUG
    NSString* szMsg = [NSString stringWithFormat:@"handleTextMessage from %@ is: %@ ", playerID, szText];
    [ApplicationConfigure LogDebugInformation:szMsg];
#endif     
    
    GamePlayer* pPLayer = [self GetPlayerByPlayerID:playerID];
    if(pPLayer && [pPLayer IsActivated])
    {
        [pPLayer ShowOnlineMessage:szText];
    }
}


-(void)DisableNonAcitvatedSeat:(int)nLastSeatID
{
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"DisableNonAcitvatedSeat is called with last seatID:%i", nLastSeatID];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i])
        {
            int nSeatID = [m_Players[i] GetSeatID];
            if(nSeatID < 0 || nLastSeatID <= nSeatID)
            {
                [m_Players[i] Activate:NO];
#ifdef DEBUG
                NSString* szText2 = [NSString stringWithFormat:@"Player with index:%i seatID:%i is disabled", i, nSeatID];
                [ApplicationConfigure LogDebugInformation:szText2];
#endif     
            }
        }
    }
    GamePlayer* pPlayer = [self GetMyself];
    if(pPlayer && [pPlayer IsEnabled])
    {
        [pPlayer SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RESET];
        [self PostMyOnlineGameState];
    }
}

-(void)handlePlayersOrderMessage:(NSDictionary*)msgData
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"handlePlayersOrderMessage is called."];
#endif     
    if(msgData)
    {
        BOOL bNeedPostMyInfo = NO;
        if(m_bGKCenterMasterCheck == YES)
            bNeedPostMyInfo = YES;
            
        [self StopGKCenterMasterCheck];
        int nLastSeatID = 0;
        NSString* msgMasterID = [msgData valueForKey:GAME_MSG_KEY_MASTER_ID];
        if(msgMasterID && 0 < [msgMasterID length])
        {
            for(int i = 0; i < 4; ++i)
            {
                if(m_Players[i] && [m_Players[i] IsActivated] && [msgMasterID isEqualToString:[m_Players[i] GetPlayerID]])
                {   
#ifdef DEBUG
                    NSString* szMaster = [NSString stringWithFormat:@"Master PlayerID:%@ and index:%i", msgMasterID, i];
                    [ApplicationConfigure LogDebugInformation:szMaster];
#endif     
                    [m_Players[i] SetSeatID:0];
                    [m_Players[i] SetGKCenterMaster:YES];
                    break;
                }    
            }
        }
        else
        {
            [self DisableNonAcitvatedSeat:nLastSeatID];
            if(bNeedPostMyInfo == YES)
                [self DelayPostMyInfo];
            return;
        }
        nLastSeatID = 1;
        NSString* msgPlayer1ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERONE_ID];
        if(msgPlayer1ID && 0 < [msgPlayer1ID length])
        {
            for(int i = 0; i < 4; ++i)
            {
                if(m_Players[i] && [m_Players[i] IsActivated] && [msgPlayer1ID isEqualToString:[m_Players[i] GetPlayerID]])
                {   
#ifdef DEBUG
                    NSString* szPlayer1 = [NSString stringWithFormat:@"Player1 PlayerID:%@ and index:%i Myself:%i", msgPlayer1ID, i, [m_Players[i] IsMyself]? 1: 0];
                    [ApplicationConfigure LogDebugInformation:szPlayer1];
#endif     
                    [m_Players[i] SetSeatID:1];
                    [m_Players[i] SetGKCenterMaster:NO];
                    break;
                }    
            }
        }
        else
        {
            [self DisableNonAcitvatedSeat:nLastSeatID];
            if(bNeedPostMyInfo == YES)
                [self DelayPostMyInfo];
            return;
        }
        
        nLastSeatID = 2;
        NSString* msgPlayer2ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERTWO_ID];
        if(msgPlayer2ID && 0 < [msgPlayer2ID length])
        {
            for(int i = 0; i < 4; ++i)
            {
                if(m_Players[i] && [m_Players[i] IsActivated] && [msgPlayer2ID isEqualToString:[m_Players[i] GetPlayerID]])
                {   
#ifdef DEBUG
                    NSString* szPlayer2 = [NSString stringWithFormat:@"Player2 PlayerID:%@ and index:%i Myself:%i", msgPlayer2ID, i, [m_Players[i] IsMyself]? 1: 0];
                    [ApplicationConfigure LogDebugInformation:szPlayer2];
#endif     
                    [m_Players[i] SetSeatID:2];
                    [m_Players[i] SetGKCenterMaster:NO];
                    break;
                }    
            }
        }
        else
        {
            [self DisableNonAcitvatedSeat:nLastSeatID];
            if(bNeedPostMyInfo == YES)
                [self DelayPostMyInfo];
            return;
        }
        nLastSeatID = 3;
        NSString* msgPlayer3ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERTHREE_ID];
        if(msgPlayer3ID && 0 < [msgPlayer3ID length])
        {
            for(int i = 0; i < 4; ++i)
            {
                if(m_Players[i] && [m_Players[i] IsActivated] && [msgPlayer3ID isEqualToString:[m_Players[i] GetPlayerID]])
                {   
#ifdef DEBUG
                    NSString* szPlayer3 = [NSString stringWithFormat:@"Player2 PlayerID:%@ and index:%i  Myself:%i", msgPlayer3ID, i, [m_Players[i] IsMyself]? 1: 0];
                    [ApplicationConfigure LogDebugInformation:szPlayer3];
#endif     
                    [m_Players[i] SetSeatID:3];
                    [m_Players[i] SetGKCenterMaster:NO];
                    break;
                }    
            }
        }
        else
        {
            [self DisableNonAcitvatedSeat:nLastSeatID];
            if(bNeedPostMyInfo == YES)
                [self DelayPostMyInfo];
            return;
        }
        GamePlayer* pPlayer = [self GetMyself];
        if(pPlayer && [pPlayer IsEnabled])
        {
            [pPlayer SetOnlinePlayingState:GAME_ONLINE_PLAYER_STATE_RESET];
            [self PostMyOnlineGameState];
        }
        if(bNeedPostMyInfo == YES)
            [self DelayPostMyInfo];
    }
}

-(void)handleGameSetttingMessage:(NSDictionary*)msgData
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"handleGameSetttingMessage is called"];
#endif     
    NSNumber* msgGameType = [msgData valueForKey:GAME_MSG_KEY_GAMETYPEMSG];
    if(msgGameType != nil)
    {
        int nGameType = [msgGameType intValue];
        [Configuration setCurrentGameType:nGameType];
        [m_GameController SetGameType:nGameType theme:[Configuration getCurrentGameTheme]];
#ifdef DEBUG
        NSString* szMsg = [NSString stringWithFormat:@"handleGameSetttingMessage handle gametype %i", nGameType];
        [ApplicationConfigure LogDebugInformation:szMsg];
#endif     
    }
    NSNumber* msgThemeType = [msgData valueForKey:GAME_MSG_KEY_THEMETYPEMSG];
    if(msgThemeType != nil)
    {
        int nThemeType = [msgThemeType intValue];
        [Configuration setCurrentGameTheme:nThemeType];
        [m_GameController SetGameType:[Configuration getCurrentGameType] theme:nThemeType];
    }
    
    NSNumber* msgPlayTurnType = [msgData valueForKey:GAME_MSG_KEY_ONLINEPLAYSEQUENCE];
    if(msgPlayTurnType != nil)
    {    
        int nPlayTurnType = [msgPlayTurnType intValue];
        [Configuration setPlayTurn:nPlayTurnType];
    }
    [self UpdateOnlineGamePlayerPlayabilty];
}

-(void)handlePlayerBalanceMessage:(NSDictionary*)msgData
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"handlePlayerBalanceMessage is called"];
#endif     
//    if(m_AWSService && m_bGKCenterMasterCheck)
//    {
//        [self StopGKCenterMasterCheck];
//        [self DelayPostMyInfo];
//    }
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_PLAIN_PLAYER_ID];
    NSNumber* msgchipBalance = [msgData valueForKey:GAME_MSG_KEY_PLAYER_CHIPS_BALANCE];
    if(msgchipBalance != nil && msgPlayerID)
    {
        int nChip = [msgchipBalance intValue];
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsActivated] && [msgPlayerID isEqualToString:[m_Players[i] GetPlayerID]])
            {
                [m_Players[i] SetupPacket:nChip];
                if([m_GameController GetGameState] != GAME_STATE_RESULT && [m_GameController GetGameState] != GAME_STATE_RUN)
                {
                    [m_Players[i] UpdateCurrentGamePlayablity];
                }
#ifdef DEBUG
                NSString* szMsg = [NSString stringWithFormat:@"handlePlayerBalanceMessage handle balance %i from %@ at index %i with seat ID %i", nChip, msgPlayerID, i, [m_Players[i] GetSeatID]];
                [ApplicationConfigure LogDebugInformation:szMsg];
#endif     
                return;
            }    
        }
    }
}

-(void)handlePlayerPledgeBetMessage:(NSDictionary*)msgData
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"handlePlayerPledgeBetMessage is called"];
#endif     
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_PLAIN_PLAYER_ID];
    NSNumber* msgchipBalance = [msgData valueForKey:GAME_MSG_KEY_PLAYER_CHIPS_BALANCE];
    NSNumber* msgLuckyNumber = [msgData valueForKey:GAME_MSG_KEY_PLEDGET_LUCKYNUMBER];
    NSNumber* msgBet = [msgData valueForKey:GAME_MSG_KEY_PLEDGET_BET];
    if(msgPlayerID && msgchipBalance && msgLuckyNumber && msgBet)
    {
        int nChip = [msgchipBalance intValue];
        int nBet = [msgBet intValue];
        int nLuckyNumber = [msgLuckyNumber intValue];
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsActivated] && [msgPlayerID isEqualToString:[m_Players[i] GetPlayerID]])
            {
                int nSeat = [m_Players[i] GetSeatID];
                [self PlayerFinishPledge:nSeat withNumber:nLuckyNumber withBet:nBet];
                [m_Players[i] SetupPacket:nChip];
#ifdef DEBUG
                NSString* szMsg = [NSString stringWithFormat:@"handlePlayerPledgeBetMessage handle bet %i  with luck number %i from %@ at index %i with seat ID %i", nBet, nLuckyNumber,msgPlayerID, i, [m_Players[i] GetSeatID]];
                [ApplicationConfigure LogDebugInformation:szMsg];
#endif     
                //[self Update]
                return;
            }    
        }
    }
}

-(void)handleNextPlayTurnMessage:(NSDictionary*)msgData
{
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_GAMENEXTTURN_ID];
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"handleNextPlayTurnMessage is called and the turn player ID is %@", msgPlayerID];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
    m_nPlayerTurnIndex = -1;
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled] && [msgPlayerID isEqualToString:[m_Players[i] GetPlayerID]])
        {
            m_nPlayerTurnIndex = [m_Players[i] GetSeatID];
            [self SetOnLinePlayTurn];
            [self LocatePlayingSpinner];
            [m_GameController SetGameState:GAME_STATE_READY];
#ifdef DEBUG
            NSString* szMsg = [NSString stringWithFormat:@"handleNextPlayTurnMessage handle turn at %i by %@ at index %i with seat ID %i", m_nPlayerTurnIndex, msgPlayerID, i, [m_Players[i] GetSeatID]];
            [ApplicationConfigure LogDebugInformation:szMsg];
#endif     
            return;
        }    
    }
}

-(void)handlePlayerStateChangeMessage:(NSDictionary*)msgData
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"handlePlayerStateChangeMessage is called"];
#endif     
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_PLAIN_PLAYER_ID];
    NSNumber* msgState = [msgData valueForKey:GAME_MSG_KEY_PLAYERSTATE];
    if(msgState == nil || msgPlayerID == nil)
        return;
    
    int nState = [msgState intValue];
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled] && [msgPlayerID isEqualToString:[m_Players[i] GetPlayerID]])
        {
            [m_Players[i] SetOnlinePlayingState:nState];
#ifdef DEBUG
            NSString* szMsg = [NSString stringWithFormat:@"handlePlayerStateChangeMessage state chaneg for %@ at index %i with seat ID %i to state:%i", msgPlayerID, i, [m_Players[i] GetSeatID], nState];
            [ApplicationConfigure LogDebugInformation:szMsg];
#endif     
            return;
        }    
    }
    if([m_GameController GetGameState] == GAME_STATE_RESULT)
    {
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsEnabled] && [m_Players[i] GetOnlinePlayingState] == GAME_ONLINE_PLAYER_STATE_RUN)
            {
                return;
            }    
        }
        GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
        [pController ShowStatusBar:[StringFactory GetString_PlayingDone]];
    }
}

-(void)handlePlayerPlayablityChangeMessage:(NSDictionary*)msgData
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"handlePlayerPlayablityChangeMessage is called"];
#endif     
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_PLAIN_PLAYER_ID];
    NSNumber* msgEnable = [msgData valueForKey:GAME_MSG_KEY_PLAYERPLAYABLITY];
    if(msgEnable == nil || msgPlayerID == nil)
        return;
    
    int nValue = [msgEnable intValue];
    BOOL bEnable = YES;
    if(nValue == 0)
        bEnable = NO;
    
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsEnabled] && [msgPlayerID isEqualToString:[m_Players[i] GetPlayerID]])
        {
            return;
        }    
    }
}

-(void)handleChipTransferMessage:(NSDictionary*)msgData fromPlayer:(NSString*)senderID
{
#ifdef DEBUG
    NSString* szMsg = [NSString stringWithFormat:@"handleChipTransferMessage is called and sender is %@", senderID];
    [ApplicationConfigure LogDebugInformation:szMsg];
#endif     
    NSString* msgRecieverID = [msgData valueForKey:GAME_MSG_KEY_MONEYRECIEVER];
    NSNumber* msgTransferChips = [msgData valueForKey:GAME_MSG_KEY_TRANSMONEYMOUNT];
    if(msgRecieverID == nil|| msgTransferChips == nil || senderID == nil)
        return;
    int nChips = [msgTransferChips intValue];
    if(nChips <= 0)
        return;
    
    int nSenderIndex = -1;
    NSString* senderName = @"";
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [senderID isEqualToString:[m_Players[i] GetPlayerID]])
        {
            [m_Players[i] AddMoneyToPacket:-nChips];
            [m_Players[i] UpdateCurrentGamePlayablity];
            nSenderIndex = i;
            senderName = [m_Players[i] GetPlayerName];
            
#ifdef DEBUG
            NSString* szText1 = [NSString stringWithFormat:@"handleChipTransferMessage reduced %i chips from sender %@ at index %i with seat ID %i", nChips, senderID, i, [m_Players[i] GetSeatID]];
            [ApplicationConfigure LogDebugInformation:szText1];
#endif     
            break;
        }    
    }

    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [msgRecieverID isEqualToString:[m_Players[i] GetPlayerID]])
        {
            [m_Players[i] AddMoneyToPacket:nChips];
            [m_Players[i] UpdateCurrentGamePlayablity];
            [m_Players[i] ShowBalance];
            if(0 <= nSenderIndex && nSenderIndex <= 3)
            {    
                NSString* szTextMsg = [NSString stringWithFormat:[StringFactory GetString_PlayerSendMoneyToOtherFmt], senderName, nChips, [m_Players[i] GetPlayerName]];
                [m_Players[nSenderIndex] ShowOnlineMessage:szTextMsg];
            }    
#ifdef DEBUG
            NSString* szText2 = [NSString stringWithFormat:@"handleChipTransferMessage add %i chips from sender %@ at index %i with seat ID %i", nChips, msgRecieverID, i, [m_Players[i] GetSeatID]];
            [ApplicationConfigure LogDebugInformation:szText2];
#endif     
            if([m_Players[i] IsMyself])
            {    
                [self PostChipTransferReceiptMessage:senderID];
#ifdef DEBUG
                NSString* szText3 = [NSString stringWithFormat:@"Myself send chip transfer receipt message to sender %@", senderID];
                [ApplicationConfigure LogDebugInformation:szText3];
#endif     
            }    
            return;
        }    
    }
}

-(void)handleChipTransferReceiptMessage
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"handleChipTransferReceiptMessage is called"];
#endif     
    GamePlayer* myself = [self GetMyself];
    if(myself)
    {
        [myself SetCachedTransferedChipNumber:0];
    }
}

-(void)handleSpinGambleWheelMessage:(NSDictionary*)msgData
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"handleSpinGambleWheelMessage is called"];
#endif     
    CPinActionLevel* action = [[CPinActionLevel alloc] init];
    NSNumber* msgFast = [msgData valueForKey:GAME_MSG_KEY_ACTION_FASTCYCLE]; 
    action.m_nFastCycle = 0;
    if(msgFast != nil)
        action.m_nFastCycle = [msgFast intValue];
    
    NSNumber* msgMedium = [msgData valueForKey:GAME_MSG_KEY_ACTION_MEDIUMCYCLE]; 
    action.m_nMediumCycle = 0;
    if(msgMedium != nil)
        action.m_nMediumCycle = [msgMedium intValue];
    
    NSNumber* msgSlow = [msgData valueForKey:GAME_MSG_KEY_ACTION_SLOWCYCLE]; 
    action.m_nSlowCycle = 0;
    if(msgSlow != nil)
        action.m_nSlowCycle = [msgSlow intValue];
   
    NSNumber* msgAngle = [msgData valueForKey:GAME_MSG_KEY_ACTION_SLOWANGLE];
    action.m_nSlowAngle = 0;
    if(msgAngle != nil)
        action.m_nSlowAngle = [msgAngle intValue];
    
    NSNumber* msgVib = [msgData valueForKey:GAME_MSG_KEY_ACTION_VIBCYCLE];
    action.m_nVibCycle = 0;
    if(msgVib != nil)
        action.m_nVibCycle = [msgVib intValue];
    
    NSNumber* msgClockwise = [msgData valueForKey:GAME_MSG_KEY_ACTION_CLOCKWISE];
    if(msgClockwise != nil)
    {    
        int nClockwise = [msgClockwise intValue];
        if(nClockwise <= 0)
            action.m_bClockwise = NO;
        else 
            action.m_bClockwise = YES;
    }
    //?????????????????????????????????
    [m_GameController SetGameState:GAME_STATE_RUN];
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


@end
