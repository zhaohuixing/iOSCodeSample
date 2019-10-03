//
//  GameViewController.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 10-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <MessageUI/MessageUI.h>
//#import "GameCenterConstant.h"
//#import "GameCenterManager.h"
#import "GameConstants.h"

@interface GameViewController : UIViewController /*MainUIController<GKLeaderboardViewControllerDelegate,
                                                    GKAchievementViewControllerDelegate, 
                                                    GameCenterManagerDelegate, 
                                                    GameCenterPostDelegate, 
                                                    GKFriendRequestComposeViewControllerDelegate,
                                                    GKMatchmakerViewControllerDelegate,
                                                    GKPeerPickerControllerDelegate,
                                                    MFMailComposeViewControllerDelegate,
                                                    MFMessageComposeViewControllerDelegate,
                                                    XAWSGameServiceManagerDelegate,
                                                    XAWSUserDelegate>*/


- (int)GetMyCurrentMoney;
- (int)GetPlayerCurrentMoney:(int)nSeat;
- (NSString*)GetPlayerName:(int)nSeatID;
- (BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID;
- (BOOL)IsConnectedGameCenter;
- (BOOL)IsSupportMultPlayerGame;
- (void)PauseGame;
- (void)ResumeGame;
- (BOOL)IsGamePaused;
- (id<GameUIDelegate>)GetCurrentGameUIDelegate;

- (id<GameControllerDelegate>)GetGameController;

- (void)StartOnlineButtonSpin;
- (void)StopOnlineButtonSpin;

//GameCenterManagerDelegate methods
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
- (void) achievementResetResult: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
- (void) showMatchmakerMasterView:(GKMatchmakerViewController*)pMmvc;
- (void) showMatchmakerParticipantView:(GKMatchmakerViewController*)pMmvc;
- (void) showGKSessionPickerView;
- (void) handleAutoSearchMatchCancelledEvent;
- (void) handleMatchErrorEvent:(NSError*)error;
- (void) handleNewPlayerAddedIntoMatchEvent;
- (void) handleHandleBluetoothSessionClosed;
- (NSNumber*)askForJoinMatch:(GKMatch*)gameMatch;
- (NSNumber*)askForJoinMatchByInvitation:(GKInvite*)acceptedInvite;
- (NSNumber*)askForJoinGameByPlayersInvitation;
- (void) handleMatchRejectedEvent:(GKInvite*)acceptedInvite;
- (void) shutdownCurrentGame;
- (BOOL) isCurrentGameOnline;

//GameCenterPostDelegate methods
- (void) PostGameCenterScore:(int)nScore withBoard:(int)boardIndex;
- (void) OpenLeaderBoardView:(int)boardIndex;
- (void) OpenAchievementViewBoardView:(int)boardIndex;
- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex;

- (void) PostAllAchievements;
- (void) PostAllGameScores;
- (BOOL) IsGameCenterReporting;

- (void) InviteFriends: (NSArray*) identifiers;

//GKFriendRequestComposeViewControllerDelegate method
- (void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController *)viewController;

- (void)ShowStatusBar:(NSString*)text;
-(void)GotoOnlineGame;
- (void) AbsoultShutDownOnlineGame;

-(void)AddRecommendationReward;

-(void)Terminate;

@end
