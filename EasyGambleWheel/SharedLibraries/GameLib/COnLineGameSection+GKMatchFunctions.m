//
//  COnLineGameSection+GKMatchFunctions.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "COnLineGameSection+GKMatchFunctions.h"
#import "COnLineGameSection+GameMessageHandler.h"
//??#import "CJSONDeserializer.h"
//??#import "NSDictionary_JSONExtensions.h"
//??#import "NSData-Base64.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "GameCenterManager.h"
#import "ScoreRecord.h"
#import "GameMsgFormatter.h"
#import "GameMsgConstant.h"
#import "Configuration.h"
#import "GameConstants.h"
#import "ApplicationConfigure.h"
#import "GamePlayer+Online.h"
//??#import "XAWSMessageFormatter.h"
//???#import "SBJSON.h"

@implementation COnLineGameSection (GKMatchFunctions)

-(void)ClearAWSInitializeFlags
{
    m_bGKCenterMasterCheck = YES;
    m_bAWSGamePeerBalanceReceived = NO;
    m_bAWSGameMasterSettingReceived = NO;
}
- (void)sendOnlineMessageToAllPlayers:(GameMessage*)msg
{
    if(m_AppleGameCenter != nil && msg != nil)
    {
        NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            NSError* myerror = nil;
            [m_AppleGameCenter sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&myerror];
        }    
    }
    else if(m_GKBTGameSession != nil && msg != nil)
    {
        NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            NSError* myerror = nil;
            [m_GKBTGameSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&myerror];
        }    
    }
}

- (void)sendOnlineMessage:(GameMessage*)msg toPlayer:(NSString*)playerID
{
    if(m_AppleGameCenter != nil && msg != nil && playerID != nil)
    {
        NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            NSError* myerror = nil;
            GKPlayer* pPlayer = [self GetOnlinePlayer:playerID];
            if(pPlayer != nil)
            {
                NSArray* array = [NSArray arrayWithObject:pPlayer];
                [m_AppleGameCenter sendData:data toPlayers:array dataMode:GKMatchSendDataReliable error:&myerror];
            }
        }
    }
    else if(m_GKBTGameSession != nil && msg != nil)
    {
        NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            NSError* myerror = nil;
            NSArray* array = [NSArray arrayWithObject:playerID];
            [m_GKBTGameSession sendData:data toPeers:array withDataMode:GKSendDataReliable error:&myerror];
        }
    }
}

-(void)SendMessageToAllPlayers:(GameMessage*)msg
{
    if(m_AppleGameCenter != nil || m_GKBTGameSession != nil)
    {
        [self sendOnlineMessageToAllPlayers:msg];
    }
}

-(void)SendMessage:(GameMessage*)msg toPlayer:(NSString*)playerID
{
    if(m_AppleGameCenter != nil || m_GKBTGameSession != nil )
    {
        [self sendOnlineMessage:msg toPlayer:playerID];
    }
}

-(void)translateGKMessageInformation:(NSData *)data fromPlayer:(NSString *)playerID
{
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"translateGKMessageInformation is called from : %@", playerID];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
	NSError *myerror = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&myerror];
	
    
    NSDictionary* msgData = (NSDictionary*)jsonObject;//[[CJSONDeserializer deserializer] deserialize:data error:&myerror];
    if(myerror != nil && [myerror description] != nil)
    {
#ifdef DEBUG
        NSString* szText = [NSString stringWithFormat:@"error in translateGKMessageInformation to decode msg: %@", [myerror description]];
        [ApplicationConfigure LogDebugInformation:szText];
#endif     
    }
    else
    {    
        [self parserMessageInformation:msgData fromPlayer:playerID];
    }
}

-(void)ConnectAppleGameCenter:(GKMatch*)match
{
    m_nPlayerTurnIndex = -1;
    BOOL bNeedLoadPlayers = NO;
    
    if(m_AppleGameCenter  == nil)
    {
        bNeedLoadPlayers = YES;
    }
    else if(m_AppleGameCenter && m_AppleGameCenter != match)
    {
        [m_AppleGameCenter disconnect];
        m_AppleGameCenter = nil;
        bNeedLoadPlayers = YES;
    }
    
    m_AppleGameCenter = match;
    m_AppleGameCenter.delegate = self;
    if(bNeedLoadPlayers)
        [self LoadGameCenterPlayers];
    
    if([m_PlayingSpinner IsActive] == NO)
        [m_PlayingSpinner StartAnimation];
}

-(void)LoadGameCenterPlayersAsGameHost
{
    int nCount = 0;
    if(!m_bHost)
        return;
    
    if(m_AppleGameCenter.players && 0 < [m_AppleGameCenter.players count])
        nCount = (int)[m_AppleGameCenter.players count];
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"LoadGameCenterPlayersAsGameHost is called with player# %i", nCount];
    [ApplicationConfigure LogDebugInformation:szText];
    if(m_AppleGameCenter)
        [ApplicationConfigure LogDebugInformation:@"Match existed"];
    else        
        [ApplicationConfigure LogDebugInformation:@"Match not existed"];
    
    if(!m_AppleGameCenter.delegate)
    {    
        [ApplicationConfigure LogDebugInformation:@"Match's delegate is not existed"];
    }    
    else 
    {
        if(m_AppleGameCenter.delegate == self)
            [ApplicationConfigure LogDebugInformation:@"Match's delegate is existed and correct"];
        else    
            [ApplicationConfigure LogDebugInformation:@"Match's delegate is existed but incorrect"];
    }
#endif     
    
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil || pPlayer.authenticated == NO)
        return;
    
    NSString* localID = pPlayer.playerID;
    NSString* myName = pPlayer.alias;
    
    if(nCount == 0)
    {
#ifdef DEBUG
        NSString* szText2 = [NSString stringWithFormat:@"Add myself to list with ID %@ and name %@", localID, myName];
        [ApplicationConfigure LogDebugInformation:szText2];
#endif     
        [m_Players[0] IntializePlayerInfo:myName withID:localID inSeat:0 isMyself:YES inLobby:m_GameController];
        [m_Players[0] Activate:YES];
        int nChips = [ScoreRecord GetMyChipBalance];
        [m_Players[0] SetupPacket:nChips];
        [m_Players[0] LoadAppleGameCenterPlayerImage:pPlayer];
        [m_Players[0] UpdateCurrentGamePlayablity];
        [m_Players[0] SetGKCenterMaster:YES];
    }
    else 
    {    
        [m_Players[0] IntializePlayerInfo:myName withID:localID inSeat:0 isMyself:YES inLobby:m_GameController];
        [m_Players[0] Activate:YES];
        int nChips = [ScoreRecord GetMyChipBalance];
        [m_Players[0] SetupPacket:nChips];
        [m_Players[0] LoadAppleGameCenterPlayerImage:pPlayer];
        [m_Players[0] UpdateCurrentGamePlayablity];
        [m_Players[0] SetGKCenterMaster:YES];
        int nPlayerSeatIndex = 1;
        for(int i = 0; i < nCount; ++i)
        {
            NSString* playerID = [m_AppleGameCenter.players objectAtIndex:i].playerID;
            [m_Players[nPlayerSeatIndex] IntializePlayerInfo:playerID withID:playerID inSeat:nPlayerSeatIndex isMyself:NO inLobby:m_GameController];
            [m_Players[nPlayerSeatIndex] Activate:YES];
            [m_Players[nPlayerSeatIndex] SetupPacket:0];
            [m_Players[nPlayerSeatIndex] SetGKCenterMaster:NO];
            ++nPlayerSeatIndex;
        }
        [self PostOnlineGamePlayersOrder];
        [self PostOnlineGameSettting];
        [self PostMyOnlineGameBalance];
        [self LoadOnlineGamePlayersInfo];
    }    
}

-(void)LoadGameCenterPlayersAsParticipant
{
    int nCount = 0;
    
    if(m_AppleGameCenter.players && 0 < [m_AppleGameCenter.players count])
        nCount = (int)[m_AppleGameCenter.players count];
  
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"LoadGameCenterPlayersAsParticipant is called with player# %i", nCount];
    [ApplicationConfigure LogDebugInformation:szText];
    if(m_AppleGameCenter)
        [ApplicationConfigure LogDebugInformation:@"Match existed"];
    else        
        [ApplicationConfigure LogDebugInformation:@"Match not existed"];
    
    if(!m_AppleGameCenter.delegate)
    {    
        [ApplicationConfigure LogDebugInformation:@"Match's delegate is not existed"];
    }    
    else 
    {
        if(m_AppleGameCenter.delegate == self)
            [ApplicationConfigure LogDebugInformation:@"Match's delegate is existed and correct"];
        else    
            [ApplicationConfigure LogDebugInformation:@"Match's delegate is existed but incorrect"];
    }
#endif     
    
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil || pPlayer.authenticated == NO)
        return;
    
    NSString* localID = pPlayer.playerID;
    NSString* myName = pPlayer.alias;
 
    if(nCount == 0)
    {
#ifdef DEBUG
        NSString* szText2 = [NSString stringWithFormat:@"Add myself to list with ID %@ and name %@", localID, myName];
        [ApplicationConfigure LogDebugInformation:szText2];
#endif     
        [m_Players[0] IntializePlayerInfo:myName withID:localID inSeat:0 isMyself:YES inLobby:m_GameController];
        [m_Players[0] Activate:YES];
        int nChips = [ScoreRecord GetMyChipBalance];
        [m_Players[0] SetupPacket:nChips];
        [m_Players[0] LoadAppleGameCenterPlayerImage:pPlayer];
        [m_Players[0] SetGKCenterMaster:NO];
    }
    else 
    {
        [m_Players[0] IntializePlayerInfo:myName withID:localID inSeat:0 isMyself:YES inLobby:m_GameController];
        [m_Players[0] Activate:YES];
        int nChips = [ScoreRecord GetMyChipBalance];
        [m_Players[0] SetupPacket:nChips];
        [m_Players[0] LoadAppleGameCenterPlayerImage:pPlayer];
        [m_Players[0] SetGKCenterMaster:NO];
        
        int nPlayerSeatIndex = 1;
        for(int i = 0; i < nCount; ++i)
        {
            //if([localID isEqualToString:[m_AppleGameCenter.playerIDs objectAtIndex:i]] == YES)
            //{
            //    [m_Players[i] IntializePlayerInfo:myName withID:localID inSeat:i isMyself:YES inLobby:m_GameController];
            //    [m_Players[i] Activate:YES];
            //    int nChips = [ScoreRecord GetMyChipBalance];
            //    [m_Players[i] SetupPacket:nChips];
            //    [m_Players[i] LoadAppleGameCenterPlayerImage:pPlayer];
            //    [m_Players[i] SetGKCenterMaster:NO];
            //}
            //else
            //{    
                NSString* playerID = [m_AppleGameCenter.players objectAtIndex:i].playerID;
                [m_Players[nPlayerSeatIndex] IntializePlayerInfo:playerID withID:playerID inSeat:nPlayerSeatIndex isMyself:NO inLobby:m_GameController];
                [m_Players[nPlayerSeatIndex] Activate:YES];
                [m_Players[nPlayerSeatIndex] SetupPacket:0];
                [m_Players[nPlayerSeatIndex] SetGKCenterMaster:NO];
                ++nPlayerSeatIndex;
            //}
        }
        [self PostMyOnlineGameBalance];
        [self LoadOnlineGamePlayersInfo];
    }    
}

-(void)LoadGameCenterPlayers
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"LoadGameCenterPlayers is called."];
    if(m_AppleGameCenter.players == nil)
        [ApplicationConfigure LogDebugInformation:@"m_AppleGameCenter.playerIDs is null."];
    
    if (m_AppleGameCenter.players)
    {
        NSString* szText = [NSString stringWithFormat:@"m_AppleGameCenter.playerIDs count is %i.", [m_AppleGameCenter.players count]];
        [ApplicationConfigure LogDebugInformation:szText];
    }
#endif     
    if(m_AppleGameCenter)// && m_AppleGameCenter.playerIDs && 0 < [m_AppleGameCenter.playerIDs count])
    {
        //int nCount = [m_AppleGameCenter.playerIDs count];
        if(m_bHost)
        {
            [self LoadGameCenterPlayersAsGameHost];
        }
        else
        {
            [self LoadGameCenterPlayersAsParticipant];
        }
        [m_GameController SetGameState:GAME_STATE_RESET];
    }
}

-(void)SynchonzePlayersOrder
{
    
}

-(void)PostOnlineGamePlayersOrder
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"PostOnlineGamePlayersOrder is called"];
#endif     
    if((m_AppleGameCenter && m_AppleGameCenter.players && 0 < [m_AppleGameCenter.players count]) || m_GKBTGameSession)
    {
        int nCount = [self GetAcitvitedPlayersNumber];
        GameMessage* msg = [[GameMessage alloc] init];
        [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_MASTERCANDIATES];
        for(int i = 0; i < nCount; ++i)
        {
            NSString* sKey = [self GetPlayerMsgKey:i];
            for(int j = 0; j < 4; ++j)
            {
                if([m_Players[j] IsActivated] && [m_Players[j] GetSeatID] == i)
                {
                    [GameMsgFormatter AddMsgText:msg withKey:sKey withText:[m_Players[j] GetPlayerID]];
                    break;
                }
            }
        }
        [GameMsgFormatter EndFormatMsg:msg];
        [self SendMessageToAllPlayers:msg];
        m_bGKCenterMasterCheck = NO;
        m_bHost = YES;
#ifdef DEBUG
        NSString* szText = [NSString stringWithFormat:@"PostOnlineGamePlayersOrder is sent with %i players", nCount];
        [ApplicationConfigure LogDebugInformation:szText];
#endif     
    }  
}

-(void)PostOnlineGameSettting
{
    GameMessage* msg = [[GameMessage alloc] init];
    int nGameType = [m_GameController GetGameType];
    int nPlayTurnType = [Configuration getPlayTurnType];
    int nThemeType = [Configuration getCurrentGameTheme];
    [GameMsgFormatter FormatGameSettingMsg:msg gameType:nGameType playTurn:nPlayTurnType themeType:nThemeType];
    [self SendMessageToAllPlayers:msg];
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"PostOnlineGameSettting is sent with GameType:%i Game Turn Type:%i", nGameType, nPlayTurnType];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
}

-(void)PostMyOnlineGameBalance
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"PostMyOnlineGameBalance is called"];
#endif     
    int nBalance = 0;
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [m_Players[i] IsMyself])
        {
            nBalance = [m_Players[i] GetPacketBalance];
            NSString* szPlayerID = [m_Players[i] GetPlayerID];
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter FormatPlayerBalanceMsg:msg playerID:szPlayerID chipBalance:nBalance];
            [self SendMessageToAllPlayers:msg];
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"PostMyOnlineGameBalance is sent with balance:%i playerID:%@", nBalance, szPlayerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif     
            return;
        }
    }
}

-(BOOL)IsMakeOnlineGameBet
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [m_Players[i] IsMyself] && [m_Players[i] AlreadyMadePledge])
        {
            return YES;
        }
    }
    return NO;
}

-(void)PostMyOnlineGameBet
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"PostMyOnlineGameBet is called"];
#endif     
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [m_Players[i] IsMyself] && [m_Players[i] AlreadyMadePledge])
        {
            int chipBalace = [m_Players[i] GetPacketBalance];
            int nBet = [m_Players[i] GetPlayBet];
            int nLuckNumber = [m_Players[i] GetPlayBetLuckNumber];
            NSString* szPlayerID = [m_Players[i] GetPlayerID];
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter FormatPlayerBetMsg:msg playerID:szPlayerID luckNumber:nLuckNumber betAmount:nBet chipBalance:chipBalace];
            [self SendMessageToAllPlayers:msg];
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"PostMyOnlineGameBet is sent with balance:%i playerID:%@, bet:%i, lucky#:%i", chipBalace, szPlayerID, nBet, nLuckNumber];
            [ApplicationConfigure LogDebugInformation:szText];
#endif     
            return;
        }
    }
}

-(void)PostMyOnlineGameState
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"PostMyOnlineGameState is called"];
#endif     
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [m_Players[i] IsMyself])
        {
            int nState = [m_Players[i] GetOnlinePlayingState];
            NSString* szPlayerID = [m_Players[i] GetPlayerID];
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter FormatPlayerStateMsg:msg playerID:szPlayerID playerState:nState];
            [self SendMessageToAllPlayers:msg];
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"PostMyOnlineGameState is sent with player State:%i playerID:%@", nState, szPlayerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif     
            return;
        }
    }
}

-(void)PostMyOnlinePlayablity
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [m_Players[i] IsMyself])
        {
            BOOL bEnable = [m_Players[i] IsEnabled];
            NSString* szPlayerID = [m_Players[i] GetPlayerID];
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter FormatPlayerPlayabilityMsg:msg playerID:szPlayerID Playability:bEnable];
            [self SendMessageToAllPlayers:msg];
            return;
        }
    }
}


-(void)PostCancelCurrentBetMessage
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"PostCancelCurrentBetMessage is called"];
#endif     
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatCancelPendingBetMsg:msg];
    [self SendMessageToAllPlayers:msg];
}


-(void)PostChipTransferMessage:(int)nTransferChips receiverID:(NSString*)szPlayerID
{
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatChipTransferMsg:msg recieverID:szPlayerID chipAmount:nTransferChips];
    [self SendMessageToAllPlayers:msg];
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"PostChipTransferMessage is sent with transfered chips:%i to receiverID:%@", nTransferChips, szPlayerID];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
}

-(void)PostChipTransferReceiptMessage:(NSString*)szMoneySenderID
{
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatChipTransferReceiptMsg:msg senderID:szMoneySenderID];
    [self SendMessage:msg toPlayer:szMoneySenderID];
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"PostChipTransferReceiptMessage is sent to receiverID:%@", szMoneySenderID];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
}

-(void)PostSpinGambleWheelMessage:(CPinActionLevel*)action
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"PostSpinGambleWheelMessage is called"];
#endif     
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatActionMsg:msg withAction:action];
    [self SendMessageToAllPlayers:msg];
}

-(void)LoadOnlineGamePlayersInfo
{
    if(!m_AppleGameCenter || !m_AppleGameCenter.playerIDs || [m_AppleGameCenter.playerIDs count] <= 0)
        return;
    
    [GKPlayer loadPlayersForIdentifiers:m_AppleGameCenter.playerIDs withCompletionHandler:^(NSArray *playerArray, NSError *error)
     {
         if(error)
         {
             NSLog(@"Loard players' name failed by %@", [error localizedDescription]);
         }
         else if(playerArray && playerArray.count)
         {
             for (GKPlayer* tempPlayer in playerArray)
             {
                 if(tempPlayer)
                 {
                     for(int i = 0; i < 4; ++i)
                     {
                         if(m_Players[i] && [m_Players[i] IsActivated] && [tempPlayer.playerID isEqualToString:[m_Players[i] GetPlayerID]])
                         {
                             [m_Players[i] SetPlayerName:tempPlayer.alias];
                             [m_Players[i] LoadAppleGameCenterPlayerImage:tempPlayer];
                         }
                     }
                 }
                 
             }
         }
     }];
}

-(void)SendNextPlayTurnMessage
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"SendNextPlayTurnMessage is called."];
#endif     
    if(0 <= m_nPlayerTurnIndex)
    {
        GamePlayer* pPlayer = [self GetPlayer:m_nPlayerTurnIndex];
        if(pPlayer && [pPlayer IsEnabled])
        {
            NSString* szPlayerID = [pPlayer GetPlayerID];
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter FormatNextTurnMsg:msg nextPlayer:szPlayerID];
            [self SendMessageToAllPlayers:msg];
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"SendNextPlayTurnMessage called with seat ID:%i, playerID:%@", m_nPlayerTurnIndex, szPlayerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif     
            return;
        }
    }
}

- (void)HandlePlayerJoin:(NSString *)playerID toMatch:(GKMatch *)match
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"HandlePlayerJoin is called."];
#endif     
    if(match != m_AppleGameCenter)
    {    
        [self ConnectAppleGameCenter:match];
    }
    BOOL bPlayerExisted = (0 <= [self GetPlayerSeatID:playerID]); 
    
    if(!bPlayerExisted)
    {    
        int nPlayerCount = [self GetAcitvitedPlayersNumber];
        if(4 < nPlayerCount)
            return;
        int nSeatID = nPlayerCount;
        for(int i = 0; i < 4; ++i)
        {
            if(m_Players[i] && [m_Players[i] IsActivated] == NO)
            {
                [m_Players[i] IntializePlayerInfo:playerID withID:playerID inSeat:nSeatID isMyself:NO inLobby:m_GameController];
                [m_Players[i] Activate:YES];
                [m_Players[i] SetupPacket:0];
                [m_Players[i] SetGKCenterMaster:NO];
                break;
            }
        }
    }    
    if(m_bHost)
    {    
#ifdef DEBUG
        [ApplicationConfigure LogDebugInformation:@"Host HandlePlayerJoin call PostOnlineGamePlayersOrder."];
#endif     
        [self PostOnlineGamePlayersOrder];
#ifdef DEBUG
        [ApplicationConfigure LogDebugInformation:@"Host HandlePlayerJoin call PostOnlineGameSettting."];
#endif     
        [self PostOnlineGameSettting];
        m_bGKCenterMasterCheck = NO;
    } 
    else 
    {
        if(![self HasGKCenterMaster])
        {
            [self StartGKCenterMasterCheck];
        }
    }
    
    [self PostMyOnlineGameBalance];
    if([m_GameController GetGameState] == GAME_STATE_RUN || [m_GameController GetGameState] == GAME_STATE_READY)
        [self PostMyOnlineGameBet];
    
    NSMutableArray* playerIDList = [[NSMutableArray alloc] init];
    [playerIDList addObject:playerID];
    [GKPlayer loadPlayersForIdentifiers: playerIDList withCompletionHandler:^(NSArray *playerArray, NSError *error)
     {
         if(error)
         {
             NSLog(@"Loard players' name failed by %@", [error localizedDescription]);
         }
         else if(playerArray && playerArray.count)
         {
             for (GKPlayer* tempPlayer in playerArray)
             {
                 if(tempPlayer)
                 {
                     for(int i = 0; i < 4; ++i)
                     {
                         if(m_Players[i] && [m_Players[i] IsActivated] && [tempPlayer.playerID isEqualToString:[m_Players[i] GetPlayerID]])
                         {
                             [m_Players[i] SetPlayerName:tempPlayer.alias];
                             [m_Players[i] LoadAppleGameCenterPlayerImage:tempPlayer];
                         }
                     }
                 }
                 
             }
         }
     }];
}

- (void)HandlePlayerLeave:(NSString *)playerID fromMatch:(GKMatch *)match
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"HandlePlayerLeave is called."];
#endif 
    
    if(match != m_AppleGameCenter)
        return;
    
    int nDepartureSeatID = [self GetPlayerSeatID:playerID];
    if(nDepartureSeatID < 0)
        return;
    
    int nMySeatID = [self GetMySeatID];
    if(nMySeatID < 0)
        return;
    
    BOOL bMasteLeave = (nDepartureSeatID == 0);
    BOOL bIAmMasterCandiate = (nMySeatID == 1);
    
    for (int i = 0; i < 4; ++i) 
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            int nSeatID = [m_Players[i] GetSeatID];
            if(nSeatID == nDepartureSeatID)
            {
                [m_Players[i] Activate:NO];
            }
            else if(nDepartureSeatID < nSeatID)
            {
                [m_Players[i] SetSeatID:nSeatID-1];
            }
        }
    }
    if([self GetAcitvitedPlayersNumber] <= 1)
    {
        [m_GameController shutdownCurrentGame];
        return;
    }
    [self CancelPendPlayerBet];
    m_nPlayerTurnIndex = 0;
    [self LocatePlayingSpinner];
    
    if(bMasteLeave && bIAmMasterCandiate)
    {
        //[self PostCancelCurrentBetMessage];
        [self PostOnlineGamePlayersOrder];
    }
}

-(void)OnSendMyTextMessage
{
    GamePlayer* mySelf = [self GetMyself];
    if(mySelf)
    {
        NSString* text = [mySelf GetMyOnlineTextMessage];
        if(text && 0 < [text length])
        {
            GameMessage* msg = [[GameMessage alloc] init];
            [GameMsgFormatter FormatTextMsg:msg withText:text];
            [self SendMessageToAllPlayers:msg];
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"OnSendMyTextMessage called with text mesg:%@", text];
            [ApplicationConfigure LogDebugInformation:szText];
#endif     
        }
    }
}


////////////////////////////////////////////////////////////
//
// GKMatchDelegate functions
//
////////////////////////////////////////////////////////////
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"didReceiveData from %@", playerID];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
    if(m_AppleGameCenter != nil)
    {
        //[self callDualParamentersFunctionOnMainThread:@selector(translateGKMessageInformation:) withParam1:[data withParam2:[playerID];
        [self translateGKMessageInformation:data fromPlayer:playerID];
    }
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    switch(state)
    {
        case GKPlayerStateUnknown:
        {    
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"%@ didChangeState to unknown", playerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif     
            break;
        }    
        case GKPlayerStateConnected:
        {    
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"%@ didChangeState to connected", playerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif     
            [self HandlePlayerJoin:playerID toMatch:match];
            break;
        }    
        case GKPlayerStateDisconnected:
        {    
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"%@ didChangeState to disconnected", playerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif     
            [self HandlePlayerLeave:playerID fromMatch:match];
            break;
        }    
    }
}

- (void)match:(GKMatch *)match player:(GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state
{
    NSString* playerID = player.playerID;
    switch(state)
    {
        case GKPlayerStateUnknown:
        {
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"%@ didChangeState to unknown", playerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif
            break;
        }
        case GKPlayerStateConnected:
        {
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"%@ didChangeState to connected", playerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif
            [self HandlePlayerJoin:playerID toMatch:match];
            break;
        }
        case GKPlayerStateDisconnected:
        {
#ifdef DEBUG
            NSString* szText = [NSString stringWithFormat:@"%@ didChangeState to disconnected", playerID];
            [ApplicationConfigure LogDebugInformation:szText];
#endif
            [self HandlePlayerLeave:playerID fromMatch:match];
            break;
        }
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error
{
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"%@ connection With %@ Failed for the reason:%@", playerID, [error description]];
    [ApplicationConfigure LogDebugInformation:szText];
#endif
    [self HandlePlayerLeave:playerID fromMatch:match];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)match didFailWithError:(NSError *)error
{
#ifdef DEBUG
    NSString* szText = [NSString stringWithFormat:@"%@ GKMatch connection Failed for the reason:%@", [error description]];
    [ApplicationConfigure LogDebugInformation:szText];
#endif     
    [GUIEventLoop SendEvent:GUIID_EVENT_ONLINE_SHUTDOWN_GAMESECTION eventSender:self];
}


//GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    if (state == GKPeerStateDisconnected)
    {
        [GUIEventLoop SendEvent:GUIID_EVENT_ONLINE_SHUTDOWN_GAMESECTION eventSender:self];
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    NSLog(@"Connection called from:%@", peerID);
    NSError *error = nil;
    if([session acceptConnectionFromPeer:peerID error:(NSError **)&error] == YES)
    {
        [self AdviseGKBTSession:session];
        [self SetGKBTPeerID:peerID];
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    [GUIEventLoop SendEvent:GUIID_EVENT_ONLINE_SHUTDOWN_GAMESECTION eventSender:self];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    [GUIEventLoop SendEvent:GUIID_EVENT_ONLINE_SHUTDOWN_GAMESECTION eventSender:self];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    if(m_GKBTGameSession != nil)
    {
        [self translateGKMessageInformation:data fromPlayer:peer];
    }

}

-(void)ResetGKBluetoothSession
{
    if(m_GKBTGameSession)
    {
        [m_GKBTGameSession disconnectFromAllPeers]; 
        
        m_GKBTGameSession.available = NO; 
        
        [m_GKBTGameSession setDataReceiveHandler: nil withContext: NULL]; 
        
        m_GKBTGameSession.delegate = nil; 
        m_GKBTGameSession = nil;
    }
    if(m_GKBTPeerID)
    {
        m_GKBTPeerID = nil;
    }
}

-(void)CreateGKBTSession
{
    if(m_GKBTGameSession)
    {
        [self ResetGKBluetoothSession];
    }
    if (!m_GKBTGameSession) 
    { 
        GKLocalPlayer* player = [GKLocalPlayer localPlayer];
        if(player)
        {
            m_MyGKBTName = player.alias;
        }
        else
        {
            m_MyGKBTName = [[UIDevice currentDevice] name];
        }
        m_GKBTGameSession = [[GKSession alloc] initWithSessionID:@"Easy Gamble Wheel GK Bluetooth session" displayName:m_MyGKBTName sessionMode:GKSessionModePeer]; 
        m_GKBTGameSession.delegate = self; 
    } 
}

-(GKSession*)GetGKBTSession
{
    return m_GKBTGameSession;
}

-(void)SetGKBTPeerID:(NSString*)peerID
{
    if(m_GKBTPeerID)
    {
        m_GKBTPeerID = nil;
    }
    m_GKBTPeerID = [peerID copy];
}

-(void)SetGKBTMyID:(NSString*)myID
{
    m_MyGKBTID = myID;
}

-(void)AdviseGKBTSession:(GKSession*)session
{
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
	if(m_GKBTGameSession != session)
    {
        [self ResetGKBluetoothSession];
        m_GKBTGameSession = session;
    }
}

-(void)LoadGKBTSessionPlayerInformation
{
    NSString* peerID = @"Guest";
    NSString* peerName = @"Guest";
    
    if(m_GKBTPeerID)  
    {
        peerID = m_GKBTPeerID;
        if(m_GKBTGameSession)
        {
            peerName = [m_GKBTGameSession displayNameForPeer:peerID];
        }
    }
    [m_Players[0] IntializePlayerInfo:m_MyGKBTName withID:m_MyGKBTID inSeat:0 isMyself:YES inLobby:m_GameController];
    [m_Players[0] Activate:YES];
    int nChips = [ScoreRecord GetMyChipBalance];
    [m_Players[0] SetupPacket:nChips];
    [m_Players[0] SetGKCenterMaster:NO];
    
    [m_Players[1] IntializePlayerInfo:peerName withID:peerID inSeat:1 isMyself:NO inLobby:m_GameController];
    [m_Players[1] Activate:YES];
    [m_Players[1] SetupPacket:0];
    [m_Players[1] SetGKCenterMaster:NO];
    [self PostMyOnlineGameBalance];
    
    if([m_PlayingSpinner IsActive] == NO)
        [m_PlayingSpinner StartAnimation];
    
    if(![self HasGKCenterMaster])
    {
        [self StartGKCenterMasterCheck];
    }
}

@end
