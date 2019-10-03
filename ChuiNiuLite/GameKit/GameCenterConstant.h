//
//  GameCenterConstanr.h
//  XXXXXXX
//
//  Created by Zhaohui Xing on 2011-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//Compass of Luck leaderboard IDs
#import <GameKit/GameKit.h>

@class GameMessage;


#define _SKILL_ONE_LEVEL_ONE_            @"com.zhaohuixing.ChuiNiuLite.l.1"
#define _SKILL_ONE_LEVEL_TWO_            @"com.zhaohuixing.ChuiNiuLite.l.2"
#define _SKILL_ONE_LEVEL_THREE_          @"com.zhaohuixing.ChuiNiuLite.l.3"
#define _SKILL_ONE_LEVEL_FOUR_           @"com.zhaohuixing.ChuiNiuLite.l.4"

#define _SKILL_TWO_LEVEL_ONE_            @"com.zhaohuixing.ChuiNiuLite.l.5"
#define _SKILL_TWO_LEVEL_TWO_            @"com.zhaohuixing.ChuiNiuLite.l.6"
#define _SKILL_TWO_LEVEL_THREE_          @"com.zhaohuixing.ChuiNiuLite.l.7"
#define _SKILL_TWO_LEVEL_FOUR_           @"com.zhaohuixing.ChuiNiuLite.l.8"

#define _SKILL_THREE_LEVEL_ONE_          @"com.zhaohuixing.ChuiNiuLite.l.9"
#define _SKILL_THREE_LEVEL_TWO_          @"com.zhaohuixing.ChuiNiuLite.l.10"
#define _SKILL_THREE_LEVEL_THREE_        @"com.zhaohuixing.ChuiNiuLite.l.11"
#define _SKILL_THREE_LEVEL_FOUR_         @"com.zhaohuixing.ChuiNiuLite.l.12"

#define _LEVEL_ONE_                      @"com.zhaohuixing.ChuiNiuLite.l.13"
#define _LEVEL_TWO_                      @"com.zhaohuixing.ChuiNiuLite.l.14"
#define _LEVEL_THREE_                    @"com.zhaohuixing.ChuiNiuLite.l.15"
#define _LEVEL_FOUR_                     @"com.zhaohuixing.ChuiNiuLite.l.16"

#define _LEVEL_ONE_ACHIEVEMENT_          @"com.zhaohuixing.ChuiNiuLite.a.1"
#define _LEVEL_TWO_ACHIEVEMENT_          @"com.zhaohuixing.ChuiNiuLite.a.2"
#define _LEVEL_THREE_ACHIEVEMENT_        @"com.zhaohuixing.ChuiNiuLite.a.3"
#define _LEVEL_FOUR_ACHIEVEMENT_         @"com.zhaohuixing.ChuiNiuLite.a.4"

#define _GK_TOTALSCORE_                  @"com.zhaohuixing.ChuiNiuLite.l.17" //???????com.zhaohuixing.ChuiNiuLite.l.17

#define _LEVEL_ONE_ACHIEVEMENT_POINT_       10.0
#define _LEVEL_TWO_ACHIEVEMENT_POINT_       20.0
#define _LEVEL_THREE_ACHIEVEMENT_POINT_     30.0
#define _LEVEL_FOUR_ACHIEVEMENT_POINT_      40.0


#define _SKILL_ONE_LEVEL_ONE_WINCOUNT_      200.0
#define _SKILL_TWO_LEVEL_ONE_WINCOUNT_      180.0
#define _SKILL_THREE_LEVEL_ONE_WINCOUNT_    160.0

#define _SKILL_ONE_LEVEL_TWO_WINCOUNT_      100.0
#define _SKILL_TWO_LEVEL_TWO_WINCOUNT_      90.0
#define _SKILL_THREE_LEVEL_TWO_WINCOUNT_    80.0

#define _SKILL_ONE_LEVEL_THREE_WINCOUNT_    80.0
#define _SKILL_TWO_LEVEL_THREE_WINCOUNT_    70.0
#define _SKILL_THREE_LEVEL_THREE_WINCOUNT_   60.0

#define _SKILL_ONE_LEVEL_FOUR_WINCOUNT_     50.0
#define _SKILL_TWO_LEVEL_FOUR_WINCOUNT_     40.0
#define _SKILL_THREE_LEVEL_FOUR_WINCOUNT_   30.0

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
- (BOOL) isAchievementAccomplished:(int)boradIndex;
@end

@protocol GameCenterPostDelegate <NSObject>
- (void) OpenLeaderBoardView:(int)boardIndex;
- (void) OpenAchievementViewBoardView:(int)boardIndex;
- (void) PostGameCenterScore:(int)nScore withBoard:(int)boardIndex;
- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex;
- (void) PostAllAchievements;
- (void) PostAllGameScores;
- (BOOL) IsGameCenterReporting;
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
- (void)PostAWSWonMessage:(int)nSkill withLevel:(int)nLevel withScore:(int)nScore;
- (void)PostAWSLostMessage:(int)nSkill withLevel:(int)nLevel withScore:(int)nScore;
- (id)GetAWSMessager;
- (BOOL)IsAWSMessagerEnabled;
- (NSString*)GetDefaultAWSNickName;
- (NSMutableArray *)GetAWSMessagesQueue;
- (void)InitAWSMessager;
@end
