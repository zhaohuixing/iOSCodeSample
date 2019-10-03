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
#define _GAME_BIGGEST_WIN_            @"com.xgadget.SimpleGambleWheel.BiggestWin"

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
- (void) showMatchmakerMasterView:(GKMatchmakerViewController*)pMmvc;
- (void) showMatchmakerParticipantView:(GKMatchmakerViewController*)pMmvc;
- (void) showGKSessionPickerView;

- (NSNumber*)askForJoinMatch:(GKMatch*)gameMatch;
- (NSNumber*)askForJoinMatchByInvitation:(GKInvite*)acceptedInvite;
- (NSNumber*)askForJoinGameByPlayersInvitation;
- (void) handleAutoSearchMatchCancelledEvent;
- (void) handleMatchErrorEvent:(NSError*)error;
- (void) handleNewPlayerAddedIntoMatchEvent;
- (void) handleMatchRejectedEvent:(GKInvite*)acceptedInvite;
- (void) handleHandleBluetoothSessionClosed;
- (void) shutdownCurrentGame;
- (BOOL) isCurrentGameOnline;
@end

@protocol GameCenterPostDelegate <NSObject>
- (void) OpenLeaderBoardView:(int)boardIndex;
- (void) OpenAchievementViewBoardView:(int)boardIndex;
//- (void) OpenLeaderBoardViewByPoint:(int)nPoint;

- (void) PostGameCenterScore:(int)nScore withBoard:(int)boardIndex;
- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex;
//- (void) PostGameCenterScoreByPoint:(int)nScore withPoint:(int)nPoint;
//- (void) PostAchievementByPoint:(float)achievement withPoint:(int)nPoint;

//- (void) PostAllAchievements;
//- (void) PostAllGameScores;
//- (BOOL) IsGameCenterReporting;
- (void) InviteFriends: (NSArray*) identifiers;
@end

@protocol GameCenterOnlinePlayDelegate <NSObject>
- (void)joinExistedMatch:(GKMatch*)gameMatch;
@end
