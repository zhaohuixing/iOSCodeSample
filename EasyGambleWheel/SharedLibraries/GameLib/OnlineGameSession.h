//
//  OnlineGameSession.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-01-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCenterConstant.h"
#import "GameMessage.h"
#import "GambleLobby.h"

@class GameViewController;


@interface OnlineGameSession : NSObject<GKMatchDelegate>
{
@private
    GameViewController*                  m_AppController;
    GambleLobby*                            m_Parent;
    
    GKMatch*                                m_RealGameCenterLobby;
    BOOL                                    m_bGameMaster;    //The master to create the game lobby, otherwise is a game participant
    EN_LOBBY_STATE                          m_LobbyState;
    NSMutableArray*                         m_PlayerRing;
    BOOL                                    m_bMyTurn;
}

@property (nonatomic, retain) GKMatch*     m_RealGameCenterLobby;

- (id)initWithGambleLobby:(GambleLobby*)parent;
- (void)RegisterGambleLobby:(GambleLobby*)parent;
- (void)InitGameCenterVoiceChatChannel;

- (void)Shutdown;
- (void)SetGameCenterLobbyMaster:(BOOL)bMaster;
- (BOOL)IsGameCenterLobbyMaster;
- (BOOL)IsGameCenterLive;
- (EN_LOBBY_STATE)GetGameCenterLobbyState;
- (void)SetGameCenterLobbyInPlaying;
- (BOOL)CanPlayGameCenterLobby;

- (void)StartNewGameCenterLobby:(int)nMaxPlayer;
- (void)AutoSearchGameCenterLobby;
- (void)AddReplacementPlyerToGameCenterLobby;
- (void)AdviseGameCenterLobbyObject:(GKMatch*)match;
- (void)HandleGameCenterLobbyInvitation;
- (void)StartGameCenterVoiceChat;
- (void)StopGameCenterVoiceChat;

- (void)HandleGameCenterLobbyStartedEvent;
- (void)ResetCurrentPlayingGame;

- (void)SynchonzeGameCenterLobbyGameSetting;
- (BOOL)SendGameCenterMessageToAllplayers:(GameMessage*)msg;
- (BOOL)SendGameCenterMessage:(GameMessage*)msg toPlayer:(NSString*)playerID;
- (int)GetGameCenterPlayerCount;
- (NSString*)GetGameCenterPlayerID:(int)index;
- (BOOL)HasGameCenterPlayer:(NSString*)playerID;

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
