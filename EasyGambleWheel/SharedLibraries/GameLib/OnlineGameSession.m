//
//  OnlineGameSession.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-01-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "GameUtiltyObjects.h"
#import "OnlineGameSession.h"
#import "GameViewController.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "GameMsgConstant.h"
#import "GameMsgFormatter.h"
#import "Configuration.h"
//#import "CJSONDeserializer.h"

@implementation OnlineGameSession

@synthesize m_RealGameCenterLobby;

- (id)initWithGambleLobby:(GambleLobby*)parent
{
    self = [super init];
    if(self)
    {
        m_AppController = (GameViewController*)[GUILayout GetGameViewController];
        m_Parent = parent;
    }
    return self;
}

- (void)RegisterGambleLobby:(GambleLobby*)parent
{
    if(m_Parent != parent && parent != nil)
        m_Parent = parent;
    
    if(m_AppController == nil)
        m_AppController = (GameViewController*)[GUILayout GetGameViewController];
}

- (void)dealloc
{
    m_Parent = nil;
    m_AppController = nil;
    
}

-(void)Shutdown
{
    if(self.m_RealGameCenterLobby != nil)
    {
        [m_RealGameCenterLobby disconnect];
        m_RealGameCenterLobby = nil;
    }
    m_LobbyState = GAME_LOBBY_NONE;
    m_bGameMaster = NO;
    m_bMyTurn = NO;
    [m_PlayerRing removeAllObjects];
}

//???????
//???????
- (void)HandleGameCenterLobbyStartedEvent
{
    
}

//???????
//???????
- (void)ResetCurrentPlayingGame
{
    
}

//???????
//???????
- (void)SetGameStateToOffline
{
    [self Shutdown];
    
}

//???????
//???????
- (void)HandleFailGameCenterPlayerConnection:(NSString*)playerID
{
    
}


-(void)SetGameCenterLobbyMaster:(BOOL)bMaster
{
    m_bGameMaster = bMaster;
}

-(BOOL)IsGameCenterLobbyMaster
{
    return m_bGameMaster;
}

-(BOOL)IsGameCenterLive
{
    BOOL bRet = (self.m_RealGameCenterLobby != nil);
    return bRet;
}

-(EN_LOBBY_STATE)GetGameCenterLobbyState
{
    return m_LobbyState;
}

-(void)SetGameCenterLobbyInPlaying
{
    m_LobbyState = GAME_LOBBY_PLAYING;
}

-(BOOL)CanPlayGameCenterLobby
{
    BOOL bRet = (m_Parent && m_AppController && [m_AppController IsConnectedGameCenter]);
    return bRet;
}


-(BOOL)SendGameCenterMessageToAllplayers:(GameMessage*)msg
{
    BOOL bRet = NO;
    
    if(self.m_RealGameCenterLobby != nil && msg != nil)
    {
        NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            NSError* myerror = nil;
            [m_RealGameCenterLobby sendDataToAllPlayers:data withDataMode:GKSendDataUnreliable error:&myerror];
            if(myerror == nil)
            {
                bRet = YES;
            }
        }    
    }
    
    return bRet;
}

-(BOOL)SendGameCenterMessage:(GameMessage*)msg toPlayer:(NSString*)playerID
{
    BOOL bRet = NO;
    
    if(self.m_RealGameCenterLobby != nil && msg != nil && [self HasGameCenterPlayer:playerID])
    {
        NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            NSError* myerror = nil;
            NSArray* array = [NSArray arrayWithObject: playerID];
            [m_RealGameCenterLobby sendData:data toPlayers:array withDataMode:GKSendDataUnreliable error:&myerror];
            if(myerror == nil)
            {
                bRet = YES;
            }
        }    
    }
    
    return bRet;
}


-(int)GetGameCenterPlayerCount
{
    int nRet = 0;
    if(self.m_RealGameCenterLobby != nil && self.m_RealGameCenterLobby.playerIDs != nil)
    {
        nRet = [self.m_RealGameCenterLobby.playerIDs count];
    }
    
    return nRet;
}

-(NSString*)GetGameCenterPlayerID:(int)index
{
    NSString* szRet = @"";
    if(self.m_RealGameCenterLobby != nil && self.m_RealGameCenterLobby.playerIDs != nil && 0 <= index && index < [self.m_RealGameCenterLobby.playerIDs count])
    {
        szRet = [self.m_RealGameCenterLobby.playerIDs objectAtIndex:index];
    }
    
    return szRet;
}

-(BOOL)HasGameCenterPlayer:(NSString*)playerID
{
    BOOL bRet = NO;
    
    if(self.m_RealGameCenterLobby != nil && self.m_RealGameCenterLobby.playerIDs != nil)
    {
        int count = (int)[self.m_RealGameCenterLobby.playerIDs count];
        if(0 < count)
        {  
            for(int i = 0; i < count; ++i)
            {    
                if([playerID isEqualToString:[self.m_RealGameCenterLobby.playerIDs objectAtIndex:i]])
                {
                    bRet = YES;
                    return bRet;
                }
            }    
        }    
    }
    
    return bRet;
}

-(void)StartNewGameCenterLobby:(int)nMaxPlayer
{
    if([self CanPlayGameCenterLobby])
    {    
        [self Shutdown];
        int nMaxCount = nMaxPlayer;
        if(4 < nMaxCount)
            nMaxCount = 4;
        if(nMaxCount < 2)
            nMaxCount = 2;
        
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = 2; 
        request.maxPlayers = nMaxCount;
        GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
        mmvc.matchmakerDelegate = (id<GKMatchmakerViewControllerDelegate>)m_AppController; 
        m_LobbyState = GAME_LOBBY_CREATING;
        m_bGameMaster = YES;
        m_bMyTurn = NO;
        
        //??????
        [self ClearPlayerRing];
        [ApplicationConfigure SetModalPresentAccountable];
        [m_AppController presentModalViewController:mmvc animated:YES];        
    }
}

-(void)AutoSearchGameCenterLobby
{
    if([self CanPlayGameCenterLobby])
    {    
        [self Shutdown];
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = 2; 
        request.maxPlayers = 4;
        m_LobbyState = GAME_LOBBY_SEARCHING;
        
        [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) 
         {
             if (error) 
             {
                 // Process the error.
#ifdef DEBUG_LOG
                 NSString* szMsg = [NSString stringWithFormat:@"Failed to search match by %@", [error description]];
                 //[m_GamePostDelegate HandleDebugMsg:szMsg];
                 NSLog(@"%@", szMsg);
#endif                 
                 [self Shutdown];
             } 
             else if (match != nil) 
             {
                 [self ClearPlayerRing];
                 self.m_RealGameCenterLobby = match; // Use a retaining property to retain the
                 self.m_RealGameCenterLobby.delegate = self; 
                 if (m_LobbyState != GAME_LOBBY_PLAYING /*&& match.expectedPlayerCount == 0*/) 
                 {
                     m_LobbyState = GAME_LOBBY_PLAYING; // Insert application-specific code to begin the match.
                     [self HandleGameCenterLobbyStartedEvent];
#ifdef DEBUG_LOG
                     NSString* szMsg = [NSString stringWithFormat:@"ExpectedPalyerCount %i", match.expectedPlayerCount];
                     NSLog(@"%@", szMsg);
#endif                 
                 }
                 m_bMyTurn = NO;
                 [self InitGameCenterVoiceChatChannel];
             }    
         }];
    } 
}

-(void)AddReplacementPlyerToGameCenterLobby
{
    if(m_RealGameCenterLobby != nil)
    {
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = 2; 
        request.maxPlayers = 4;
        m_LobbyState = GAME_LOBBY_SEARCHING;
        
        [[GKMatchmaker sharedMatchmaker] addPlayersToMatch:m_RealGameCenterLobby matchRequest:request completionHandler:^(NSError *error) 
         {
             if (error) 
             {
                 // Process the error.
#ifdef DEBUG_LOG
                 NSString* szMsg = [NSString stringWithFormat:@"Failed to add replacement player by %@", [error description]];
                 //[m_GamePostDelegate HandleDebugMsg:szMsg];
                 NSLog(@"%@", szMsg);
#endif                 
                 return;
             } 
             else 
             {
                 //m_RealGameLobby = match; // Use a retaining property to retain the
                 //m_RealGameLobby.delegate = m_MatchDelegate; 
                 //if (m_LobbyState != GAME_LOBBY_PLAYING && match.expectedPlayerCount == 0) 
                 //{
                 //    m_LobbyState = GAME_LOBBY_PLAYING; // Insert application-specific code to begin the match.
                 //    [m_GamePostDelegate HandleLobbyStartedEvent];
                 //}
                 // Process the error.
#ifdef DEBUG_LOG
                 NSString* szMsg = [NSString stringWithFormat:@"Successful to add replacement player"];
                 //[m_GamePostDelegate HandleDebugMsg:szMsg];
                 NSLog(@"%@", szMsg);
#endif                 
                 return;
             }    
         }];
    }
}

-(void)AdviseGameCenterLobbyObject:(GKMatch*)match
{
    self.m_RealGameCenterLobby = match; // Use a retaining property to retain the
    self.m_RealGameCenterLobby.delegate = self; 
    m_bMyTurn = NO;
    [self InitGameCenterVoiceChatChannel];
    if (m_LobbyState != GAME_LOBBY_PLAYING /*&& match.expectedPlayerCount == 0*/) 
    {
        m_LobbyState = GAME_LOBBY_PLAYING; // Insert application-specific code to begin the match.
        //[m_GamePostDelegate HandleLobbyStartedEvent];
        [self HandleGameCenterLobbyStartedEvent];
#ifdef DEBUG_LOG
        NSString* szMsg = [NSString stringWithFormat:@"ExpectedPalyerCount %i", match.expectedPlayerCount];
        //[m_GamePostDelegate HandleDebugMsg:szMsg];
        NSLog(@"%@", szMsg);
#endif                 
    }
}


-(void)HandleGameCenterLobbyInvitation
{
    if([self CanPlayGameCenterLobby])
    {    
        m_LobbyState = GAME_LOBBY_RECIEVEINVITATION;
        [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) 
        {
            //Interrupted by other commands
            if(m_LobbyState != GAME_LOBBY_RECIEVEINVITATION)
            {    
#ifdef DEBUG_LOG
                NSString* szMsg = [NSString stringWithFormat:@"Listening to invitation is stopped"];
                //[m_GamePostDelegate HandleDebugMsg:szMsg];
                NSLog(@"%@", szMsg);
#endif                 
                return;
            }
            
            [self ResetCurrentPlayingGame];
            
            // Insert application-specific code here to clean up any games in progress. 
            if (acceptedInvite)
            {
#ifdef DEBUG_LOG
                NSString* szMsg = [NSString stringWithFormat:@"Accept invitation"];
                //[m_GamePostDelegate HandleDebugMsg:szMsg];
                NSLog(@"%@", szMsg);
#endif                 
                GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite];
                mmvc.matchmakerDelegate = (id<GKMatchmakerViewControllerDelegate>)m_AppController; 
                [ApplicationConfigure SetModalPresentAccountable];
                [m_AppController presentModalViewController:mmvc animated:YES];        
            } 
            else if (playersToInvite) 
            {
#ifdef DEBUG_LOG
                NSString* szMsg = [NSString stringWithFormat:@"Accept multiplayers invitation"];
                //[m_GamePostDelegate HandleDebugMsg:szMsg];
                NSLog(@"%@", szMsg);
#endif                 
                GKMatchRequest *request = [[GKMatchRequest alloc] init];
                request.minPlayers = 2; 
                request.maxPlayers = 4; 
                request.playersToInvite = playersToInvite;
                GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
                mmvc.matchmakerDelegate = (id<GKMatchmakerViewControllerDelegate>)m_AppController; 
                m_bGameMaster = YES;
                [ApplicationConfigure SetModalPresentAccountable];
                [m_AppController presentModalViewController:mmvc animated:YES];        
            }
        };
    }        
}

-(void)StartGameCenterVoiceChat
{
/*    if(m_GameChat)
    {
        m_GameChat.active = YES;
        [m_GameChat start];
    }*/    
}

-(void)StopGameCenterVoiceChat
{
/*    if(m_GameChat)
        [m_GameChat stop];*/
}

-(void)InitGameCenterVoiceChatChannel
{
    
}

-(void)ClearPlayerRing
{
    [m_PlayerRing removeAllObjects];
}

-(BOOL)IsMyTurnToPlay
{
    //Change late
    return m_bMyTurn;
}

-(void)AddPlayerToRing:(NSString*)playerID
{
    //NSString* szPlayer = [NSString stringWithFormat:@"%@", playerID];
    [m_PlayerRing addObject:playerID];
}

-(void)RemovePlayerFromRing:(NSString*)playerID
{
    int nCount = (int)[m_PlayerRing count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSString* szTemp = [m_PlayerRing objectAtIndex:i];
            if([playerID isEqualToString:szTemp] == YES)
            {
                [m_PlayerRing removeObjectAtIndex:i];
                break;
            }
        }
    }
}

-(int)GetMyIndexInRing
{
    int nRet = -1;
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil)
        return nRet;
    
    NSString* localID = pPlayer.playerID;
    int nCount = (int)[m_PlayerRing count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSString* szTemp = [m_PlayerRing objectAtIndex:i];
            if([localID isEqualToString:szTemp] == YES)
            {
                nRet = i;
                break;
            }
        }
    }
    return nRet;    
}

-(NSString*)GetPlayerIDInRing:(int)index
{
    NSString* szRet = @"";
    int nCount = (int)[m_PlayerRing count];
    if(0 < nCount && 0 <= index && index < nCount)
    {
        szRet = [m_PlayerRing objectAtIndex:index];
    }
    
    return szRet;
}

-(void)SetPlayerTurn:(BOOL)bMyTurn
{
    m_bMyTurn = bMyTurn;
}

-(NSString*)GetMyNextPlayerInRing
{
    NSString* szRet = @"";
    int nCount = (int)[m_PlayerRing count];
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil)
        return szRet;
    
    NSString* localID = pPlayer.playerID;
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSString* szTemp = [m_PlayerRing objectAtIndex:i];
            if([localID isEqualToString:szTemp] == YES)
            {
                if(i == nCount-1)
                    szRet = [m_PlayerRing objectAtIndex:0];
                else
                    szRet = [m_PlayerRing objectAtIndex:(i+1)];
                
                return szRet;
            }
        }
    }
    return szRet;
}

-(NSString*)GetNextPlayerInRingAfter:(NSString*)playerID
{
    NSString* szRet = @"";
    int nCount = (int)[m_PlayerRing count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSString* szTemp = [m_PlayerRing objectAtIndex:i];
            if([playerID isEqualToString:szTemp] == YES)
            {
                if(i == nCount-1)
                    szRet = [m_PlayerRing objectAtIndex:0];
                else
                    szRet = [m_PlayerRing objectAtIndex:(i+1)];
                
                return szRet;
            }
        }
    }
    
    return szRet;
}

-(BOOL)IsMasterPlayerInRing:(NSString*)playerID
{
    int nCount = (int)[m_PlayerRing count];
    if(0 < nCount)
    {
        NSString* szTemp = [m_PlayerRing objectAtIndex:0];
        if([playerID isEqualToString:szTemp] == YES)
            return YES;
    }
    
    return NO;
}

-(int)GetPlayerCountInRing
{
    int nCount = (int)[m_PlayerRing count];
    return nCount;
}


//
//Game message handling code
//
-(void)HandleTextMessage:(NSString*)szText fromPlayer:(NSString*)playerID
{
/*??    if(m_Parent != nil)
    {
        [m_Parent PostOnlinePlayerTextMessage:szText from:playerID];
    } ??*/
}

-(void)HandleNextTurnMessage:(NSString*)szPlayerID
{
/*??    [m_Parent SetOnlineGamePlayTurn:szPlayerID]; ??*/
}

-(void)HandleGameCenterPlayerListInformation:(NSDictionary*)msgData
{
    int nMyPlayerIndex = 0;
    BOOL bFind = NO;
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    NSString* localID = pPlayer.playerID;
    NSMutableArray* playerList = [[NSMutableArray alloc] init];
    
    NSString* msgMasterID = [msgData valueForKey:GAME_MSG_KEY_MASTER_ID];
    if(msgMasterID == nil || [msgMasterID length] <= 0)
        return;
    
    if([localID isEqualToString:msgMasterID] == NO)
    {
        nMyPlayerIndex = 0;
        bFind = YES;
    }
    [playerList addObject:msgMasterID];
    
    NSString* msgPlayer1ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERONE_ID];
    if(msgPlayer1ID != nil && 0 < [msgPlayer1ID length])
    {
        if(bFind == NO)
        {
            if([localID isEqualToString:msgPlayer1ID] == NO)
            {
                nMyPlayerIndex = 1;
                bFind = YES;
            }
        }
        [playerList addObject:msgPlayer1ID];
        
        NSString* msgPlayer2ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERTWO_ID];
        if(msgPlayer2ID != nil && 0 < [msgPlayer2ID length])
        {
            if(bFind == NO)
            {
                if([localID isEqualToString:msgPlayer2ID] == NO)
                {
                    nMyPlayerIndex = 2;
                    bFind = YES;
                }
            }
            [playerList addObject:msgPlayer2ID];
            NSString* msgPlayer3ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERTHREE_ID];
            if(msgPlayer3ID != nil && 0 < [msgPlayer3ID length])
            {
                if(bFind == NO)
                {
                    if([localID isEqualToString:msgPlayer3ID] == NO)
                    {
                        nMyPlayerIndex = 3;
                        bFind = YES;
                    }
                }
                [playerList addObject:msgPlayer3ID];
            }
        }
    }  
    int nCount = [playerList count];
    for(int i = 0; i < nCount; ++i)
    {
        int index = (nMyPlayerIndex + i)%nCount;
        BOOL bMaster = (index == 0);
        NSString* playerID = (NSString*)[playerList objectAtIndex:index];
        [m_Parent AddOnlinePlayer:playerID atSeat:i isMaster:bMaster];
    }
    
}

-(void)HandleOnlinePlayCompassAction:(NSDictionary*)msgData
{
    CPinActionLevel* action = [[CPinActionLevel alloc] init];
    NSNumber* msgFast = [msgData valueForKey:GAME_MSG_KEY_ACTION_FASTCYCLE];
    if(msgFast != nil)
    {
        action.m_nFastCycle = [msgFast intValue];
    }
     
    NSNumber* msgMedium = [msgData valueForKey:GAME_MSG_KEY_ACTION_MEDIUMCYCLE];
    if(msgMedium != nil)
    {
        action.m_nMediumCycle = [msgMedium intValue];
    }
     
    NSNumber* msgSlow = [msgData valueForKey:GAME_MSG_KEY_ACTION_SLOWCYCLE];
    if(msgSlow != nil)
    {
        action.m_nSlowCycle = [msgSlow intValue];
    }
     
    NSNumber* msgAngle = [msgData valueForKey:GAME_MSG_KEY_ACTION_SLOWANGLE];
    if(msgAngle != nil)
    {
        action.m_nSlowAngle = [msgAngle intValue];
    }
     
    NSNumber* msgVib = [msgData valueForKey:GAME_MSG_KEY_ACTION_VIBCYCLE];
    if(msgVib != nil)
    {
        action.m_nVibCycle = [msgVib intValue];
    }
     
    NSNumber* msgClockwise = [msgData valueForKey:GAME_MSG_KEY_ACTION_CLOCKWISE];
    if(msgClockwise != nil)
    {
        action.m_bClockwise = [msgClockwise intValue] == 0 ? NO : YES;
    }
    [m_Parent StartOnlineGameSpinAction:action];
}

-(void)HandleOnlineGameSettingUpdate:(NSDictionary*)msgData
{
    int nType = 0;
    BOOL bSequence = NO;
    
    NSNumber* msgType = [msgData valueForKey:GAME_MSG_KEY_GAMETYPEMSG];
    if(msgType != nil)
    {
        nType = [msgType intValue];
    }
    else
    {
        return;
    }

    NSNumber* msgTurn = [msgData valueForKey:GAME_MSG_KEY_ONLINEPLAYSEQUENCE];
    if(msgTurn != nil)
    {
        if([msgTurn intValue] == 0)
            bSequence = NO;
        else
            bSequence = YES;
    }
    [m_Parent SetOnlineGameSetting:nType playTurn:bSequence];
}

-(void)HandleOnlineGamePlayerPledge:(NSDictionary*)msgData
{
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_PLAIN_PLAYER_ID];
    if(msgPlayerID == nil || [msgPlayerID length] <= 0)
        return;

    int nLuckNumber = 0;
    NSNumber* msgLuckNumber = [msgData valueForKey:GAME_MSG_KEY_PLEDGET_LUCKYNUMBER];
    if(msgLuckNumber != nil)
    {
        nLuckNumber = [msgLuckNumber intValue];
    }
    
    int nBet = 0;
    NSNumber* msgBet = [msgData valueForKey:GAME_MSG_KEY_PLEDGET_BET];
    if(msgBet != nil)
    {
        nBet = [msgBet intValue];
    }

    int chipBalace = -1;
    NSNumber* msgBalance = [msgData valueForKey:GAME_MSG_KEY_PLAYER_CHIPS_BALANCE];
    if(msgBalance != nil)
    {
        chipBalace = [msgBalance intValue];
    }

    [m_Parent SetOnlineGamePlayerPledget:msgPlayerID withNumber:nLuckNumber withBet:nBet withBalance:chipBalace];
}

-(void)HandleOnlineGamePlayerBalance:(NSDictionary*)msgData
{
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_PLAIN_PLAYER_ID];
    if(msgPlayerID == nil || [msgPlayerID length] <= 0)
        return;
    
    int chipBalace = -1;
    NSNumber* msgBalance = [msgData valueForKey:GAME_MSG_KEY_PLAYER_CHIPS_BALANCE];
    if(msgBalance != nil)
    {
        chipBalace = [msgBalance intValue];
    }
    
    [m_Parent SetOnlineGamePlayerBalance:msgPlayerID withBalance:chipBalace];
}

-(void)HandleOnlineGamePlayerState:(NSDictionary*)msgData
{
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_PLAIN_PLAYER_ID];
    if(msgPlayerID == nil || [msgPlayerID length] <= 0)
        return;
    
    int nState = 0;
    NSNumber* msgState = [msgData valueForKey:GAME_MSG_KEY_PLAYERSTATE];
    if(msgState != nil)
    {
        nState = [msgState intValue];
    }
    
    [m_Parent SetOnlineGamePlayerState:msgPlayerID withState:nState];
}

-(void)HandleOnlineGamePlayerTransfer:(NSDictionary*)msgData
{
    NSString* szSenderID = [msgData valueForKey:GAME_MSG_KEY_MONEYSENDER];
    if(szSenderID == nil || [szSenderID length] <= 0)
        return;

    NSString* szRecieverID = [msgData valueForKey:GAME_MSG_KEY_MONEYRECIEVER];
    if(szRecieverID == nil || [szRecieverID length] <= 0)
        return;

    int nChips = -1;
    NSNumber* msgChips = [msgData valueForKey:GAME_MSG_KEY_TRANSMONEYMOUNT];
    if(msgChips != nil)
    {
        nChips = [msgChips intValue];
    }
    
    [m_Parent HandleOnlineGamePlayerMoneyTransfer:szSenderID toPlayer:szRecieverID withMoney:nChips];
}

-(void)HandleOnlineGamePlayerPlayability:(NSDictionary*)msgData
{
    NSString* msgPlayerID = [msgData valueForKey:GAME_MSG_KEY_PLAIN_PLAYER_ID];
    if(msgPlayerID == nil || [msgPlayerID length] <= 0)
        return;

    BOOL bEnable = YES;
    
    NSNumber* msgEnable = [msgData valueForKey:GAME_MSG_KEY_PLAYERPLAYABLITY];
    if(msgEnable != nil)
    {
        if([msgEnable intValue] == 0)
            bEnable = NO;
        else
            bEnable = YES;
    }
    [m_Parent SetOnlineGamePlayerPlayability:msgPlayerID isEnable:bEnable];
}

-(void)parserMessageInformation:(NSDictionary*)msgData fromPlayer:(NSString*)playerID
{
    if(m_Parent == nil)
        return;
    
    NSNumber* msgTypeID = [msgData valueForKey:GAME_MSG_KEY_TYPE];
    if(msgTypeID == nil)
    {
#ifdef DEBUG_LOG
        NSLog(@"Can not parse out message type information msgID %i",[msgTypeID intValue]);
#endif        
        return;
    }
    int nTypeID = [msgTypeID intValue];
    switch (nTypeID)
    {
        case GAME_MSG_TYPE_TEXT:
        {
            NSString* msgText = [msgData valueForKey:GAME_MSG_KEY_TEXTMSG];
            if(msgText != nil)
            {
                [self HandleTextMessage:msgText fromPlayer:playerID];
            }
            break;
        }
        case GAME_MSG_TYPE_MASTERCANDIATES:
        {
            [self HandleGameCenterPlayerListInformation:msgData];
            break;
        }
        case GAME_MSG_TYPE_GAMEPLAYNEXTTURN:
        {
            NSString* szPlayerID = [msgData valueForKey:GAME_MSG_KEY_GAMENEXTTURN_ID];
            if(szPlayerID != nil && 0 < [szPlayerID length])
            {
                [self HandleNextTurnMessage:szPlayerID];
            }
            break;
        }
        case GAME_MSG_TYPE_ACTIONLEVEL:
        {
            [self HandleOnlinePlayCompassAction:msgData];
            break;
        }
        /*case GAME_MSG_TYPE_STARTWRITTING:
        {
            [(ApplicationMainView*)m_MainView PlayerStartWriteTextMessage:playerID];
            break;
        }*/
        case GAME_MSG_TYPE_STARTCHATTING:
        {
            //[(ApplicationMainView*)m_MainView PlayerStartTalking:playerID];
            break;
        }
        case GAME_MSG_TYPE_STOPCHATTING:
        {
            //[(ApplicationMainView*)m_MainView PlayerStopTalking:playerID];
            break;
        }
        case GAME_MSG_TYPE_GAMESETTINGSYNC:
        {
            [self HandleOnlineGameSettingUpdate:msgData];
            break;
        }
        case GAME_MSG_TYPE_PLAYERBET:
        {
            [self HandleOnlineGamePlayerPledge:msgData];
            break;
        }
        case GAME_MSG_TYPE_PLAYERBALANCE:
        {
            [self HandleOnlineGamePlayerBalance:msgData];
            break;
        }
        case GAME_MSG_TYPE_PLAYERSTATE:
        {
            [self HandleOnlineGamePlayerState:msgData];
            break;
        }
        case GAME_MSG_TYPE_MONEYTRANSFER:
        {
            [self HandleOnlineGamePlayerTransfer:msgData];
            break;
        }
        case GAME_MSG_TYPE_PLAYERPLAYABLITY:
        {
            [self HandleOnlineGamePlayerPlayability:msgData];
            break;
        }
            
    }   
}


//
// GKMatchDelegate methods
//
// The match received data sent from the player.
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
	NSError *myerror = nil;
	NSDictionary* msgData = [[CJSONDeserializer deserializer] deserialize:data error:&myerror];
    if(myerror != nil && [myerror description] != nil)
    {
        //if([ApplicationConfigure IsDebugMode])
        //{    
        //    NSString* szMsg = [NSString stringWithFormat:@"Erro in decoding reveive data from Player %@ as %@", playerID, [myerror description]];
        //    [self HandleDebugMsg:szMsg];
        //}
        return;
    }
    
    [self parserMessageInformation:msgData fromPlayer:playerID];
}

- (void)AddPlayerAvatar:(NSString*)playerID withName:(NSString*)szName
{
//    [(ApplicationMainView*)m_MainView AddPlayerAvatarInLobby:playerID withName:szName];
}

- (NSString*)GetLobbyPlayerMsgKey:(int)nIndex
{
    NSString* sKey = @"";
/*    if(nIndex == 0)
        sKey = GAME_MSG_KEY_PLAYERONE_ID; 
    else if(nIndex == 1)
        sKey = GAME_MSG_KEY_PLAYERTWO_ID; 
    else if(nIndex == 2)
        sKey = GAME_MSG_KEY_PLAYERTHREE_ID; 
*/    
    return sKey;
}


- (void)SynchonzeGameCenterLobbyPlayersOrder:(GKMatch *)match
{
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil || pPlayer.authenticated == NO || match == nil || match.playerIDs == nil || [match.playerIDs count] == 0 || 4 < [match.playerIDs count])
        return;
    
 /*   NSString* localID = pPlayer.playerID;
    int nCount = 0;
    [m_GameLobby ClearPlayerRing];
    [m_GameLobby AddPlayerToRing:localID];
    [m_GameLobby SetPlayerTurn:YES];
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_MASTERCANDIATES];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_MASTER_ID withText:localID];
    
    for(NSString* gplayerID in match.playerIDs)
    {
        if([localID isEqualToString:gplayerID] == NO)
        {
            [m_GameLobby AddPlayerToRing:gplayerID];
            NSString* sKey = [self GetLobbyPlayerMsgKey:nCount];
            [GameMsgFormatter AddMsgText:msg withKey:sKey withText:gplayerID];
            ++nCount;
        }
    }
    
    [GameMsgFormatter EndFormatMsg:msg];
    [self SendMessageToAllplayers:msg];
    [msg;
    [self SendGameTurnMessage:localID];
    [(ApplicationMainView*)m_MainView SetPlayerAvatarHighLight:localID];
    setMsgBounceLock(1);    */
}

- (void)SynchonzeGameCenterLobbyGameSetting
{
    if(m_Parent == nil)
    {    
        return;
    }
    
    int nType = [m_Parent GetGameType];
    BOOL bSequence = [Configuration isOnlinePlayTurnBySequence];
    
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter FormatGameSettingMsg:msg gameType:nType playTurn:bSequence];
    [self SendGameCenterMessageToAllplayers:msg];
    [msg;
    
}

- (void)HandleGameCenterPlayerJoin:(NSString *)playerID toMatch:(GKMatch *)match
{
    [self ResetCurrentPlayingGame];
    NSMutableArray* playerIDList = [[[NSMutableArray alloc] init];
    [playerIDList addObject:playerID];
    [GKPlayer loadPlayersForIdentifiers: playerIDList withCompletionHandler:^(NSArray *playerArray, NSError *error)
     {
         if(playerArray != nil && 0 < playerArray.count)
         {
             for (GKPlayer* tempPlayer in playerArray)
             {
                 NSString* szName = [NSString stringWithFormat:@"%@", tempPlayer.alias];
                 [self AddPlayerAvatar:playerID withName:szName];
                 break;
             }
         }    
     }];
    
    if(match != nil  && [self IsGameCenterLobbyMaster] == YES)
    {
        [self SynchonzeGameCenterLobbyGameSetting];
    }
    
    
    if(match != nil && match.expectedPlayerCount == 0 && [self IsGameCenterLobbyMaster] == YES)
    {
        [self SynchonzeGameCenterLobbyPlayersOrder:match];
    }
}

- (void)HandlePostPlayerLeaveJobs
{
    [self AddReplacementPlyerToGameCenterLobby];
}

- (void)HandleGameCenterPlayerLeave:(NSString *)playerID fromMatch:(GKMatch *)match
{
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    NSString* localID = pPlayer.playerID;
    
/*    [self ResetCurrentPlayingGame];
    BOOL bTurnPlayer = [(ApplicationMainView*)m_MainView IsPlayerAvatarHighLight:playerID];
    NSString* szNextPlayer = [m_GameLobby GetNextPlayerInRingAfter:playerID];
    BOOL bMasterPlayer = [m_GameLobby IsMasterPlayerInRing:playerID];
    [(ApplicationMainView*)m_MainView RemovePlayerAvatarFromLobby:playerID];
    [m_GameLobby RemovePlayerFromRing:playerID];
    
    if(bTurnPlayer && [m_GameLobby IsGameLobbyMaster])
    {
        [self SendGameTurnMessage:szNextPlayer];
        if([localID isEqualToString:szNextPlayer] == YES)
        {
            [m_GameLobby SetPlayerTurn:YES];
        }
        else
        {
            [m_GameLobby SetPlayerTurn:NO];
        }
        [(ApplicationMainView*)m_MainView SetPlayerAvatarHighLight:szNextPlayer];
        [self HandlePosetPlayerLeaveJobs];
        return;
    }
    if(bMasterPlayer == YES)
    {
        int nIndex = [m_GameLobby GetMyIndexInRing];
        if(nIndex == 0)
        {
            [m_GameLobby SetGameLobbyMaster:YES];
            if(bTurnPlayer)
            {
                [self SendGameTurnMessage:szNextPlayer];
                if([localID isEqualToString:szNextPlayer] == YES)
                {
                    [m_GameLobby SetPlayerTurn:YES];
                }
                else
                {
                    [m_GameLobby SetPlayerTurn:NO];
                }
            }     
            [(ApplicationMainView*)m_MainView SetPlayerAvatarHighLight:szNextPlayer];
            [self HandlePosetPlayerLeaveJobs];
        }
        else
        {
            NSString* szMaster = [m_GameLobby GetPlayerIDInRing:0];
            [(ApplicationMainView*)m_MainView SetPlayerAvatarAsMaster:szMaster];
        }
    }*/
}


// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    NSString* szTemp = @"";
    switch(state)
    {
        case GKPlayerStateUnknown:
            szTemp = @"unknown";
            break;
        case GKPlayerStateConnected:
            szTemp = @"connected";
            [self HandleGameCenterPlayerJoin:playerID toMatch:match];
            break;
        case GKPlayerStateDisconnected:
            szTemp = @"disconnected";
            [self HandleGameCenterPlayerLeave:playerID fromMatch:match];
            break;
    }
    if([ApplicationConfigure IsDebugMode])
    {    
#ifdef DEBUG_LOG
        NSString* szMsg = [NSString stringWithFormat:@"Player %@ state change to %@", playerID, szTemp];
        NSLog(@"%@",szMsg);
/*        int nCount = [m_GameLobby GetPlayerCount];
        NSString* szCount = [NSString stringWithFormat:@"Players' number in Lobby:%i", nCount];
        [self HandleDebugMsg:szCount];
        
        if(0 < nCount)
        {
            for(int i = 0; i < nCount; ++i)
            {
                NSString* playerID = [m_GameLobby GetPlayerID:i];
                szCount = [NSString stringWithFormat:@"Player's ID:%@", playerID];
                [self HandleDebugMsg:szCount];
            }
        }
        nCount = [m_GameLobby GetUnjoinedPlayerCount];
        szCount = [NSString stringWithFormat:@"Unfilled number in Lobby:%i", nCount];
        [self HandleDebugMsg:szCount];*/
#endif        
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error
{
#ifdef DEBUG_LOG
    if([ApplicationConfigure IsDebugMode])
    {    
        NSString* szMsg = [NSString stringWithFormat:@"Match failed to connect with %@ with error %@", playerID, [error description]];
        NSLog(@"%@",szMsg);
    }
#endif        
    [self HandleFailGameCenterPlayerConnection:playerID];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)match didFailWithError:(NSError *)error
{
#ifdef DEBUG_LOG
    if([ApplicationConfigure IsDebugMode])
    {    
        NSString* szMsg = [NSString stringWithFormat:@"Match failed to created by error %@", [error description]];
        NSLog(@"%@",szMsg);
    }
#endif
    [self SetGameStateToOffline];
}


@end
