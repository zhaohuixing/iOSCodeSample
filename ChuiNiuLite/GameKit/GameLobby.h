//
//  GameLobby.h
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-07-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameCenterConstant.h"
#import "GameMessage.h"

@interface GameLobby : NSObject 
{
@private
    GKMatch*                                m_RealGameLobby;
    GKVoiceChat*                            m_GameChat;
    BOOL                                    m_bGameMaster;    //The master to create the game lobby, otherwise is a game participant
    EN_LOBBY_STATE                          m_LobbyState;
    id<GKMatchDelegate>                     m_MatchDelegate;    
    id<GKMatchmakerViewControllerDelegate>  m_MatchMVCDelegate;
    //id<GKVoiceChatClient>                   m_VoiceChatDelegate;
    id<GameCenterPostDelegate>              m_GamePostDelegate;    
    NSMutableArray*                         m_PlayerRing;
    BOOL                                    m_bMyTurn;
}

@property (nonatomic, retain) GKMatch*     m_RealGameLobby;

-(id)init;
//-(id)initWithDelegate:(id<GKMatchDelegate>)matchDelegate withMVCDelegate:(id<GKMatchmakerViewControllerDelegate>)mvcDelegate withChatClient:(id<GKVoiceChatClient>)chatDelegate withPostDelegate:(id<GameCenterPostDelegate>)postDelegate;
//-(void)RegisterDelegate:(id<GKMatchDelegate>)matchDelegate withMVCDelegate:(id<GKMatchmakerViewControllerDelegate>)mvcDelegate withChatClient:(id<GKVoiceChatClient>)chatDelegate withPostDelegate:(id<GameCenterPostDelegate>)postDelegate;
-(id)initWithDelegate:(id<GKMatchDelegate>)matchDelegate withMVCDelegate:(id<GKMatchmakerViewControllerDelegate>)mvcDelegate withPostDelegate:(id<GameCenterPostDelegate>)postDelegate;
-(void)RegisterDelegate:(id<GKMatchDelegate>)matchDelegate withMVCDelegate:(id<GKMatchmakerViewControllerDelegate>)mvcDelegate  withPostDelegate:(id<GameCenterPostDelegate>)postDelegate;

-(void)SetGameLobbyMaster:(BOOL)bMaster;
-(BOOL)IsGameLobbyMaster;
-(BOOL)IsLive;
-(EN_LOBBY_STATE)GetLobbyState;
-(void)SetLobbyInPlaying;
-(void)Shutdown;
-(BOOL)CanPlayLobby;
-(void)InitVoiceChatChannel;
-(void)StartNewLobby:(int)nMaxPlayer;
-(void)AutoSearchLobby;
-(void)AddReplacementPlyerToLobby;
-(void)AdviseLobbyObject:(GKMatch*)match;
-(void)HandleLobbyInvitation;
-(void)StartVoiceChat;
-(void)StopVoiceChat;
-(int)GetPlayerCount;
-(NSString*)GetPlayerID:(int)index;
-(BOOL)HasPlayer:(NSString*)playerID;
-(int)GetUnjoinedPlayerCount;
-(BOOL)SendMessageToAllplayers:(GameMessage*)msg;
-(BOOL)SendMessage:(GameMessage*)msg toPlayer:(NSString*)playerID;
-(BOOL)IsMyTurnToPlay;
-(void)ClearPlayerRing;
-(void)AddPlayerToRing:(NSString*)playerID;
-(void)RemovePlayerFromRing:(NSString*)playerID;
-(int)GetMyIndexInRing;
-(NSString*)GetPlayerIDInRing:(int)index;
-(void)SetPlayerTurn:(BOOL)bMyTurn;
-(NSString*)GetMyNextPlayerInRing;
-(NSString*)GetNextPlayerInRingAfter:(NSString*)playerID;
-(BOOL)IsMasterPlayerInRing:(NSString*)playerID;
-(int)GetPlayerCountInRing;
@end
