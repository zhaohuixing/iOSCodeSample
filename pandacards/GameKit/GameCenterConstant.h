//
//  GameCenterConstanr.h
//  XXXXXXX
//
//  Created by Zhaohui Xing on 2011-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <GameKit/GameKit.h>

@class GameMessage;

//Compass of Luck leaderboard IDs

#define _24_POINT_GAME_SLOW_            @"com.xgadget.pandacards.l.0"
#define _24_POINT_GAME_FAST_            @"com.xgadget.pandacards.l.1"
#define _21_POINT_GAME_SLOW_            @"com.xgadget.pandacards.l.2"
#define _21_POINT_GAME_FAST_            @"com.xgadget.pandacards.l.3"
#define _18_POINT_GAME_SLOW_            @"com.xgadget.pandacards.l.4"
#define _18_POINT_GAME_FAST_            @"com.xgadget.pandacards.l.5"
#define _27_POINT_GAME_SLOW_            @"com.xgadget.pandacards.l.6"
#define _27_POINT_GAME_FAST_            @"com.xgadget.pandacards.l.7"
#define _ALL_GAME_RECORD_               @"com.xgadget.pandacards.l.8"



#define _27_POINT_ACHIEVEMENT_          @"com.xgadget.mindfire.a.4"
#define _24_POINT_ACHIEVEMENT_          @"com.xgadget.mindfire.a.7"
#define _21_POINT_ACHIEVEMENT_          @"com.xgadget.mindfire.a.10"
#define _18_POINT_ACHIEVEMENT_          @"com.xgadget.mindfire.a.13"
#define _N_POINT_ACHIEVEMENT_           @"com.xgadget.mindfire.a.22"

#define _REGULAR_ACHIEVEMENT_POINT_     20.0
#define _N_ACHIEVEMENT_POINT_           100.0

#define _27_POINT_WINCOUNT_             1000
#define _24_POINT_WINCOUNT_             800
#define _21_POINT_WINCOUNT_             900
#define _18_POINT_WINCOUNT_             1000
#define _N_POINT_WINCOUNT_              10000

typedef enum 
{
	GAME_LOBBY_NONE,
	GAME_LOBBY_CREATING,
	GAME_LOBBY_SEARCHING,
	GAME_LOBBY_RECIEVEINVITATION,
	GAME_LOBBY_PLAYING
} EN_LOBBY_STATE;

@protocol GameCenterManagerDelegate <NSObject>
@optional
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
- (void) achievementResetResult: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
@end

@protocol GameCenterPostDelegate <NSObject>
- (void) OpenLeaderBoardView:(int)boardIndex;
- (void) OpenAchievementViewBoardView:(int)boardIndex;

- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex;
- (void) PostGameCenterScoreByPoint:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed;
- (void) PostAchievementByPoint:(float)achievement withPoint:(int)nPoint;

//- (void) PostAllAchievements;
//- (void) PostAllGameScores;
//- (BOOL) IsGameCenterReporting;
- (void) InviteFriends: (NSArray*) identifiers;
- (BOOL) IsLobbyEnabled;
- (BOOL) IsInLobby;
- (BOOL) IsGameLobbyMaster;
- (void) HandleLobbyStartedEvent;
- (void) StartProcessDewDefaultLobby;
- (void) StartProcessSearchLobby;
- (void) ResetCurrentPlayingGame;
- (void) ShutdownLobby;
- (void) StartVoiceChat;
- (void) StopVoiceChat;
- (EN_LOBBY_STATE) GetLobbyState;
- (void)HandleDebugMsg:(NSString*)msg;
- (BOOL)SendMessageToAllplayers:(GameMessage*)msg;
- (BOOL)SendMessage:(GameMessage*)msg toPlayer:(NSString*)playerID;
- (BOOL)IsMyTurnToPlay;
- (void)MakeGameTurnToNext;
- (void)UpdateActivePlayerScore;
- (NSString*)GetPlayerIDInRing:(int)index;
- (void)SynchonzeGameSetting;
- (void) PostTwitterMessage:(NSString*)tweet;
- (void)FaceBookPostMessage:(NSString*)tweet;

- (BOOL)CanAcceptInvitation;
- (void)StartGKBTSession;
@end