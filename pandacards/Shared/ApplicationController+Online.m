//
//  ApplicationController+Online.m
//  MindFire
//
//  Created by Zhaohui Xing on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ApplicationController+Online.h"
#import "ApplicationMainView.h"
#import "GameMsgConstant.h"
#import "GameMsgFormatter.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "ApplicationConfigure.h"
#import "CustomModalAlertView.h"


#define GAME_ONLINE_MASTERCHECK_INTERVAL        10

@implementation ApplicationController (Online)

-(BOOL)HasGameMaster
{
    if([self IsGameLobbyMaster])
        return YES;
    
 //   if(m_GameLobby && 0 < [m_GameLobby GetPlayerCount])
 //       return YES;
        
    return NO;
}

-(void)StartCenterMasterCheck
{
    m_bGameMasterCheck = YES;
    m_TimeStartCenterMasterCheck = [[NSProcessInfo  processInfo] systemUptime];
}

-(void)StopCenterMasterCheck
{
    m_bGameMasterCheck = NO;
}

- (void)StartMasterCountingForNewGame
{
    m_bStartMasterCountingForNewGame = YES;
    m_TimeMasterCountingForNewGame = [[NSProcessInfo  processInfo] systemUptime];
}

-(void)HandleNomiatedAsGameMaster
{
    int nCount = 0;
    
    [m_GameLobby ClearPlayerRing];
    [m_GameLobby AddPlayerToRing:[self GetMyPlayerID]];
    [(ApplicationMainView*)m_MainView SetPlayerAvatarAsMaster:[self GetMyPlayerID]];
    [m_GameLobby SetGameLobbyMaster:YES];
    [m_GameLobby SetPlayerTurn:YES];
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_MASTERCANDIATES];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_MASTER_ID withText:[self GetMyPlayerID]];
    
    if([self IsPlayer1Active])
    {
        [m_GameLobby AddPlayerToRing:[self GetPlayer1PlayerID]];
        NSString* sKey = [self GetLobbyPlayerMsgKey:nCount];
        [GameMsgFormatter AddMsgText:msg withKey:sKey withText:[self GetPlayer1PlayerID]];
        ++nCount;
    }
    if([self IsPlayer2Active])
    {
        [m_GameLobby AddPlayerToRing:[self GetPlayer2PlayerID]];
        NSString* sKey = [self GetLobbyPlayerMsgKey:nCount];
        [GameMsgFormatter AddMsgText:msg withKey:sKey withText:[self GetPlayer2PlayerID]];
        ++nCount;
    }
    if([self IsPlayer3Active])
    {
        [m_GameLobby AddPlayerToRing:[self GetPlayer3PlayerID]];
        NSString* sKey = [self GetLobbyPlayerMsgKey:nCount];
        [GameMsgFormatter AddMsgText:msg withKey:sKey withText:[self GetPlayer3PlayerID]];
        ++nCount;
    }
    
    [GameMsgFormatter EndFormatMsg:msg];
    [self SendMessageToAllplayers:msg];
    [msg release];

    [self SynchonzeGameSetting];
}

-(void)NomiateGKCenterMasterInPeerToPeer
{
    int nMasterID = [(ApplicationMainView*)m_MainView NomiateGKCenterMasterInPeerToPeer];
    if(nMasterID == 0)
    {
        m_bGameMasterCheck = NO;
        [self HandleNomiatedAsGameMaster]; 
        [(ApplicationMainView*)m_MainView StartNewGame];
    }
}

-(void)HandleGKBTSessionConnected
{
    NSString* myID = [m_GameLobby GetGKBTMyID];
    NSString* peerID = [m_GameLobby GetGKBTPeerID];
    if([myID compare:peerID] == NSOrderedDescending)
    {
        m_bGameMasterCheck = NO;
        [self HandleNomiatedAsGameMaster];
        [(ApplicationMainView*)m_MainView StartNewGame];
    }
    else 
    {
        [m_GameLobby SetGameLobbyMaster:NO];
    }
}
-(void)HandleGameMasterCheck
{
    if(m_bGameMasterCheck)
    {
        if(![self HasGameMaster])
        {
            NSTimeInterval currentTime = [[NSProcessInfo  processInfo] systemUptime];
            float timeStep = currentTime - m_TimeStartCenterMasterCheck;
            if(GAME_ONLINE_MASTERCHECK_INTERVAL <= timeStep)
            {
                if([m_GameLobby IsGameCenterOnlineGame])
                    [self NomiateGKCenterMasterInPeerToPeer];
                else if([m_GameLobby IsGKBluetoothOnlineGame])
                    [self HandleGKBTSessionConnected];
            }
        }
        else 
        {
            m_bGameMasterCheck = NO;
        }
    }
}

- (void)HandleStartMasterCountingForNewGame
{
    NSTimeInterval currentTime = [[NSProcessInfo  processInfo] systemUptime];
    float timeStep = currentTime - m_TimeMasterCountingForNewGame;
    if(1 <= timeStep)
    {
        m_bStartMasterCountingForNewGame = NO;
        [(ApplicationMainView*)m_MainView StartNewGame];
    }
}

- (BOOL)IsMySelfActive
{
    return [(ApplicationMainView*)m_MainView IsMySelfActive];
}

- (BOOL)IsPlayer1Active
{
    return [(ApplicationMainView*)m_MainView IsPlayer1Active];
}

- (BOOL)IsPlayer2Active
{
    return [(ApplicationMainView*)m_MainView IsPlayer2Active];
}

- (BOOL)IsPlayer3Active
{
    return [(ApplicationMainView*)m_MainView IsPlayer3Active];
}

- (NSString*)GetMyPlayerID
{
    return [(ApplicationMainView*)m_MainView GetMyPlayerID];
}

- (NSString*)GetPlayer1PlayerID
{
    return [(ApplicationMainView*)m_MainView GetPlayer1PlayerID];
}

- (NSString*)GetPlayer2PlayerID
{
    return [(ApplicationMainView*)m_MainView GetPlayer2PlayerID];
}

- (NSString*)GetPlayer3PlayerID
{
    return [(ApplicationMainView*)m_MainView GetPlayer3PlayerID];
}


- (void) peerPickerControllerDidCancel: (GKPeerPickerController *)picker
{
	[picker dismiss];
	[picker release];
    [self ShutdownLobby];
    [(ApplicationMainView*)m_MainView StopLobbyButtonSpin];
    [(ApplicationMainView*)m_MainView StartNewGame];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession: (GKSession *) session
{ 
	[picker dismiss];
    if(m_GameLobby == nil)
        return;
    [self HandleLobbyStartedEvent];
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
	if([m_GameLobby GetGKBTSession] != session)
    {
        [m_GameLobby ResetGKBluetoothSession];
        [m_GameLobby SetGKBluetoothSession:session];
    }
    [m_GameLobby SetGKBTPeerID:peerID];
    [m_GameLobby SetGKBTMyID:session.peerID];
    
    NSString* myID = [m_GameLobby GetGKBTMyID];
    NSString* myName = [m_GameLobby GetGKBTMyName];
    NSString* peerID2 = [m_GameLobby GetGKBTPeerID];
    NSString* peerName = [m_GameLobby GetGKBTPeerName];
    [(ApplicationMainView*)m_MainView AddPlayerAvatarInLobby:peerID2 withName:peerName];
    [(ApplicationMainView*)m_MainView AddMyselfAvatarInLobby:myID withName:myName];
    
    
    [self StartCenterMasterCheck];
	[picker release];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type 
{ 
	// The session ID is basically the name of the service, and is used to create the bonjour connection.
    GKSession* pRet = nil;
    if(m_GameLobby)
    {
        if([m_GameLobby GetGKBTSession] == nil)
        {
            [m_GameLobby CreateGKBTSession:self];
        }
        pRet = [m_GameLobby GetGKBTSession]; //need retain??????????
    }

    return pRet;
}

//GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    if (state == GKPeerStateDisconnected)
    {
        [self ShutdownLobby];
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    [m_GameLobby ResetGKBluetoothSession];
    [(ApplicationMainView*)m_MainView StartNewGame];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    [m_GameLobby ResetGKBluetoothSession];
    [(ApplicationMainView*)m_MainView StartNewGame];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
	NSError *myerror = nil;
	NSDictionary* msgData = [[CJSONDeserializer deserializer] deserialize:data error:&myerror];
    if(myerror != nil && [myerror description] != nil)
    {
        if([ApplicationConfigure IsDebugMode])
        {    
            NSString* szMsg = [NSString stringWithFormat:@"Erro in decoding reveive data from Player %@ as %@", peer, [myerror description]];
            [self HandleDebugMsg:szMsg];
        }
        return;
    }
    
    [self parserMessageInformation:msgData fromPlayer:peer];
}

- (void)StartGKBTSession
{
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self; 
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show]; 
}
@end
