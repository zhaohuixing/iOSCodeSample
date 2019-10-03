//
//  ApplicationController.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 10-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MainUIController.h"
#import "GameCenterConstant.h"
#import "GameCenterManager.h"
#import "GameLobby.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AWSMessageService.h"

@interface ApplicationController : MainUIController<
    GKLeaderboardViewControllerDelegate, 
    GKAchievementViewControllerDelegate, 
    GameCenterManagerDelegate, 
    GameCenterPostDelegate, 
    GKFriendRequestComposeViewControllerDelegate,
    GKMatchDelegate,
    GKMatchmakerViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    MFMailComposeViewControllerDelegate>
{
	GameCenterManager*      m_GameCenterManager;
    GameLobby*              m_GameLobby;

    NSTimer*		m_Timer;
	BOOL			m_bInternet;

    //TODO: following parameters should move to a player class
	NSString* m_PersonalBestScoreDescription;
	NSString* m_PersonalBestScoreString;
	
	NSString* m_LeaderboardHighScoreDescription;
	NSString* m_LeaderboardHighScoreString;
	NSString* m_CurrentLeaderBoard;
	NSString* m_CurrentAchievementBoard;
	
	NSString* m_CachedHighestScore;
    
    BOOL    m_bLobbyMasterInit;
    BOOL    m_bLobbyHighLitInit;
    
    BOOL                    m_bGameMasterCheck;
    NSTimeInterval          m_TimeStartCenterMasterCheck;
    
    BOOL                    m_bStartMasterCountingForNewGame;
    NSTimeInterval          m_TimeMasterCountingForNewGame;
    
    AWSMessageService*      m_AWSMessager;
}

//GameCenterManagerDelegate methods
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
- (void) achievementResetResult: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;

//GameCenterPostDelegate methods
- (void) PostGameCenterScore:(int)nScore withBoard:(int)boardIndex;
- (void) OpenLeaderBoardView:(int)boardIndex;
- (void) OpenAchievementViewBoardView:(int)boardIndex;
- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex;
- (BOOL) isAchievementAccomplished:(int)boradIndex;

- (void) RecheckShutdownConfigure;

- (void) InviteFriends: (NSArray*) identifiers;
//GKFriendRequestComposeViewControllerDelegate method
- (void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController *)viewController;

- (BOOL) IsLobbyEnabled;
- (BOOL) IsInLobby;
- (BOOL) IsGameLobbyMaster;
- (NSString*)GetLobbyPlayerMsgKey:(int)nIndex;

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

//
// GKMatchDelegate methods
//
// The match received data sent from the player.
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state;
// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error;
// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)match didFailWithError:(NSError *)error;


//
// GKMatchmakerViewControllerDelegate methods
//
// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController;
// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error;
// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match;
// Players have been found for a server-hosted game, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs;

- (void)HandleAdRequest:(NSURL*)url;
- (void)AdViewClicked;
- (void)DismissExtendAdView;
- (void)InterstitialAdViewClicked;
- (void)CloseRedeemAdView;

-(void)SendTellFriendsEmail;
-(void)SendTellFriendsMessage;

- (void) PostTwitterMessage:(NSString*)tweet;
- (void) FaceBookPostMessage:(NSString*)tweet;

- (void) SendTellFriendsTwitter;
- (void) SendTellFriendsFacebook;

- (void)PostAWSWonMessage:(int)nSkill withLevel:(int)nLevel withScore:(int)nScore;
- (void)PostAWSLostMessage:(int)nSkill withLevel:(int)nLevel withScore:(int)nScore;
- (id)GetAWSMessager;
- (void)InitAWSMessager;
- (BOOL)IsAWSMessagerEnabled;
- (NSString*)GetDefaultAWSNickName;
- (NSMutableArray *)GetAWSMessagesQueue;
@end
