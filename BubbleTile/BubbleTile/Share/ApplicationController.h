//
//  ApplicationController.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 10-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "DebogConsole.h"
#import "MainUIController.h"
#import "GameCenterConstant.h"
#import "GameCenterManager.h"
#import "GameCenterPostDelegate.h"
#import "GameConstants.h"
#import "FacebookPoster.h"
#import "AWSMessageService.h"

@interface ApplicationController : MainUIController<GKLeaderboardViewControllerDelegate, 
                                                    GKAchievementViewControllerDelegate, 
                                                    GameCenterManagerDelegate, 
                                                    GameCenterPostDelegate, 
                                                    GKFriendRequestComposeViewControllerDelegate, 
                                                    MFMessageComposeViewControllerDelegate,
                                                    MFMailComposeViewControllerDelegate>
{
	GameCenterManager*      m_GameCenterManager;
	
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
    
    //FacebookPoster*         m_FacebookPoster;
    
    BOOL      m_bNeedPostGKTotalScore;
    
    AWSMessageService*      m_AWSMessager;
}

- (void) RecheckShutdownConfigure;

//GameCenterManagerDelegate methods
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
- (void) achievementResetResult: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;

//GameCenterPostDelegate methods
- (void) PostGameCenterScore:(int)nScore withBoard:(int)boardIndex;
- (void) PostGameCenterScoreByPoint:(int)nScore withPoint:(int)nPoint;
- (void) OpenLeaderBoardView:(int)boardIndex;
- (void) OpenLeaderBoardViewByPoint:(int)nPoint;
- (void) OpenAchievementViewBoardView:(int)boardIndex;
- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex;
- (void) PostAchievementByPoint:(float)achievement withPoint:(int)nPoint;

- (void) InviteFriends: (NSArray*) identifiers;
//GKFriendRequestComposeViewControllerDelegate method
- (void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController *)viewController;

- (void)HandleAdRequest:(NSURL*)url;
- (void)AdViewClicked;
- (void)DismissExtendAdView;
- (void)InterstitialAdViewClicked;
- (void)CloseRedeemAdView;

- (void) PostTwitterMessage:(NSString*)tweet;
- (void)StartGameWithoutCacheData;
- (void)StartGameWithCacheData;
- (void)SaveUnfinishedGameToCacheFile;

- (void)OpenPreviewView:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)enBubbleType withSetting:(NSArray*)setting;

- (void)ShareGameByEmail:(NSURL*)fileName;

//Show debug message
- (void)ShowDebugMessage:(NSString*)msg;


-(void)SendTellFriendsEmail;
-(void)SendTellFriendsMessage;
-(void)SendTellFriendsTwitter;
-(void)SendTellFriendsFacebook;
-(void)FaceBookPostScore:(NSString*)sScore;

-(void)CompleteFacebookFeedMySelf;
-(void)CompleteFacebookSuggestToFriends;

- (void)PostAWSWonMessage:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withScore:(int)nScore;
- (id)GetAWSMessager;
- (BOOL)IsAWSMessagerEnabled;
- (NSString*)GetDefaultAWSNickName;
- (NSMutableArray *)GetAWSMessagesQueue;
- (void)InitAWSMessager;

- (void)PostCurrentGameScoreOnline;
- (void)PostGKTotalGameScore;
- (void)OnPostOnlineScoreEvent;
@end
