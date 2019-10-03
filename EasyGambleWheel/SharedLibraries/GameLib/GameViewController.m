    //
//  GameController.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#import "ApplicationMainView.h"
#import "GameCenterManager.h"
#import "GameViewController.h"
#import "ApplicationConfigure.h"
#import "RenderHelper.h"
#import "GUILayout.h"
#import "DrawHelper2.h"
#import "Configuration.h"
#import "GameMsgConstant.h"
#import "GameMessage.h"
#import "GameAchievementHelper.h"
#import "CustomModalAlertView.h"
#import "StringFactory.h"
#import "GameScore.h"
#import "ScoreRecord.h"
#import "UIDevice-Reachability.h"

@import MultipeerConnectivity;

#define GAME_TIMER_INTERVAL   0.0001
#ifndef ADREPOST_INVALID    
#define ADREPOST_INVALID        1
#endif    

@interface GameViewController () <GKAchievementViewControllerDelegate,
                                    GameCenterManagerDelegate,
                                    GameCenterPostDelegate,
                                    GKFriendRequestComposeViewControllerDelegate,
                                    GKMatchmakerViewControllerDelegate,
                                    GKPeerPickerControllerDelegate>
{
    NSTimer*                m_Timer;
    BOOL                    m_bGamePaused;
    GameCenterManager*      m_GameCenterManager;
    
    //Leader board record
    int m_nHighestScore;
    int m_LeaderboardPostSemphore;
    NSString* m_CurrentLeaderBoard;
    
    BOOL                    m_bStartGKGameAsMaster;
}


@property (nonatomic, weak) IBOutlet ApplicationMainView*	m_MainView;

@end


@implementation GameViewController

-(void)Terminate
{
    [self.m_MainView Terminate];
}

- (void) displayTweetResult:(NSString*)result
{
//    [CustomModalAlertView SimpleSay:result closeButton:[StringFactory GetString_Close]];
}


- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	NSString* strMsg = [NSString stringWithFormat:@"%@\n%@", title, message];
    [CustomModalAlertView SimpleSay:strMsg closeButton:[StringFactory GetString_Close]];
}

- (void)InitializeGameConfiguration
{
    [DrawHelper2 InitializeResource];
    [RenderHelper InitializeResource];
    [GUILayout SetGameViewController:self];
    [ScoreRecord IntiScore];

    [ApplicationConfigure SetCurrentProduct: APPLICATION_PRODUCT_SIMPLEGAMBLEWHEEL];
    
    //???????
    //???????
    //[ApplicationConfigure SetAdViewsState:YES]; //????????
    //???????
    //???????
    
    [RenderHelper InitializeResource];
     int nType = [ScoreRecord GetGameType];
     int nTheme = [ScoreRecord GetGameTheme];
     BOOL bAuto = ([ScoreRecord GetOfflineBetMethod] == 0);
     BOOL bSound = [ScoreRecord GetSoundEnable];
     
     [Configuration setCurrentGameType:nType];
     [Configuration setCurrentGameTheme:nTheme];
     [Configuration setRoPaAutoBet:bAuto];
     [Configuration setPlaySoundEffect:bSound];
     [Configuration setPlayTurn:[ScoreRecord GetPlayTurnType]];
     
     m_GameCenterManager = [[GameCenterManager alloc] init];
     [m_GameCenterManager setDelegate: self];
     
     m_nHighestScore = 0;
     m_LeaderboardPostSemphore = 0;
     m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByIndex:0];
     m_bGamePaused = NO;
     m_bStartGKGameAsMaster = NO;
}

- (id) init
{
    self = [super init];
	if (self)
	{
        [self InitializeGameConfiguration];
	}
	return self;
}

- (id<GameUIDelegate>)GetCurrentGameUIDelegate
{
    return (id<GameUIDelegate>)[self.m_MainView GetGameView];
}

- (id<GameControllerDelegate>)GetGameController
{
    return [self.m_MainView GetGameController];
}

- (void)handleTimer:(NSTimer*)timer 
{
	[self.m_MainView OnTimerEvent];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.view.userInteractionEnabled = YES;
	self.view.multipleTouchEnabled = YES;
    
    [Configuration ClearGKGameCenterAccessTry];
    BOOL bNeedCheckOnlineSetting = YES;
    if([GameCenterManager isGameCenterSupported] && [UIDevice networkAvailable])
    {
        [self.m_MainView ShowSpinner];
        bNeedCheckOnlineSetting = NO;
        if([m_GameCenterManager authenticateLocalUser] == NO)
        {
            [ApplicationConfigure SetGameCenterLoggingin:YES];
        }
        else
        {
            bNeedCheckOnlineSetting = YES;
            [self.m_MainView HideSpinner];
            [ApplicationConfigure SetGameCenterEnable:YES];
        }
    }
 
    CGRect frame = self.m_MainView.frame;
    frame.origin.x = 0;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height;
    [GUILayout SetMainUIDimension:frame.size.width withHeight:frame.size.height];
    [self.m_MainView setFrame:frame];
    
    
    [self.m_MainView InitSubViews];
    [self.m_MainView InitializeDefaultPlayersConfiguration];
    [self.m_MainView UpdateSubViewsOrientation];
    [self.m_MainView UpdateOnlineButtonsStatus];
    
	dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        assert([NSThread isMainThread]);
    
        if(m_Timer == nil)
        {
            srandom((int)time(0));
            m_Timer = [NSTimer scheduledTimerWithTimeInterval:GAME_TIMER_INTERVAL
													target:self 
												  selector:@selector(handleTimer:)
												  userInfo:nil
												   repeats: YES 
					];
        }
    });
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.m_MainView.frame;
    frame.origin.x = 0;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height;
    [GUILayout SetMainUIDimension:frame.size.width withHeight:frame.size.height];
    [self.m_MainView setFrame:frame];
    [self.m_MainView UpdateSubViewsOrientation];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:YES];
}

- (void)dealloc 
{
    if(m_Timer != nil)
	{
		[m_Timer invalidate];
	}
    [RenderHelper ReleaseResource];
    [DrawHelper2 ReleaseResource];  
    [ScoreRecord ReleaseScore];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self InitializeGameConfiguration];
}

- (int)GetMyCurrentMoney
{
    return [self.m_MainView GetMyCurrentMoney];
}

- (int)GetPlayerCurrentMoney:(int)nSeat
{
    return [self.m_MainView GetPlayerCurrentMoney:nSeat];
}

- (NSString*)GetPlayerName:(int)nSeatID
{
    return [self.m_MainView GetPlayerName:nSeatID];
}

- (BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID
{
    return [self.m_MainView CanPlayerPlayGame:nType inSeat:nSeatID];
}


- (BOOL)IsConnectedGameCenter
{
    return [ApplicationConfigure IsGameCenterEnable];
}

- (BOOL)IsSupportMultPlayerGame
{
    return YES;
}

- (void)PauseGame
{
    m_bGamePaused = YES;
    [self.m_MainView PauseGame];
}

- (void)ResumeGame
{
    m_bGamePaused = NO;
    [self.m_MainView ResumeGame];
}

- (BOOL)IsGamePaused
{
    return m_bGamePaused; 
}

-(void)postAchievementByIndex:(int)nIndex;
{
    [self.m_MainView setNeedsDisplay];
}

#pragma mark GameCenterDelegateProtocol Methods
//Delegate method used by processGameCenterAuth to support looping waiting for game center authorization

/////////////////////////////////////////////
// Game Center Mathc related functions, begin
/////////////////////////////////////////////
- (void) showGKSessionPickerView
{
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self; 
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show]; 
}

- (void) showMatchmakerMasterView:(GKMatchmakerViewController*)pMmvc
{
    m_bStartGKGameAsMaster = YES;
    pMmvc.matchmakerDelegate = self;
//    [self presentModalViewController:pMmvc animated:YES];
    [self presentViewController:pMmvc animated:YES completion:^{}];
}

- (void) showMatchmakerParticipantView:(GKMatchmakerViewController*)pMmvc
{
    m_bStartGKGameAsMaster = NO;
    pMmvc.matchmakerDelegate = self;
//    [self presentModalViewController:pMmvc animated:YES];
    [self presentViewController:pMmvc animated:YES completion:^{}];
}

- (void) handleAutoSearchMatchCancelledEvent
{
    [self.m_MainView GKOnlineRequestCancelled];
}

- (void) handleMatchErrorEvent:(NSError*)error
{
    [self.m_MainView GKOnlineRequestCancelled];
}

- (void) handleHandleBluetoothSessionClosed
{
    [self.m_MainView GKOnlineRequestCancelled];
}

- (void) handleNewPlayerAddedIntoMatchEvent
{
    
}

- (NSNumber*)askForJoinMatch:(GKMatch*)gameMatch
{
    int nRet = 0;
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"askForJoinMatch is called."];
#endif     
    if([[self GetGameController] IsOnline] == NO && [CustomModalAlertView IsAlertPopup] == NO && gameMatch)
    {
        NSString* szPlayers = @"Unknown";
        if(gameMatch.playerIDs && 0 < [gameMatch.playerIDs count])
        {    
            szPlayers = [NSString stringWithFormat:@"%@", [gameMatch.playerIDs objectAtIndex:0]];
            for(int i = 1; i < [gameMatch.playerIDs count]; ++i)
            {
                szPlayers = [NSString stringWithFormat:@"%@,%@", szPlayers, [gameMatch.playerIDs objectAtIndex:i]];
            }
        }    
        
        NSString* szAsk = [NSString stringWithFormat:[StringFactory GetString_OnlineGameInvitationAskFormt], szPlayers];
        nRet = [CustomModalAlertView Ask:szAsk withButton1:[StringFactory GetString_No] withButton2:[StringFactory GetString_Yes]];
    }
    
    NSNumber* nsRet = [[NSNumber alloc] initWithInt:nRet];
    return nsRet;
}


- (NSNumber*)askForJoinMatchByInvitation:(GKInvite*)acceptedInvite
{
    int nRet = 0;
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"askForJoinMatchByInvitation is called."];
#endif     
    
    if([[self GetGameController] IsOnline] == NO && [CustomModalAlertView IsAlertPopup] == NO && acceptedInvite && acceptedInvite.sender)
    {
        NSString* szAsk = [NSString stringWithFormat:[StringFactory GetString_OnlineGameInvitationAskFormt], acceptedInvite.sender.alias];
        nRet = [CustomModalAlertView Ask:szAsk withButton1:[StringFactory GetString_No] withButton2:[StringFactory GetString_Yes]];
    }
 
    NSNumber* nsRet = [[NSNumber alloc] initWithInt:nRet];
    return nsRet;
}

- (NSNumber*)askForJoinGameByPlayersInvitation
{
    int nRet = 0;
    
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"askForJoinGameByPlayersInvitation."];
#endif     
    if([[self GetGameController] IsOnline] == NO && [CustomModalAlertView IsAlertPopup] == NO)
    {
        NSString* szAsk = [NSString stringWithFormat:[StringFactory GetString_OnlineGameInvitationAskFormt], [StringFactory GetString_OtherPlayes]];
        nRet = [CustomModalAlertView Ask:szAsk withButton1:[StringFactory GetString_No] withButton2:[StringFactory GetString_Yes]];
    }
    NSNumber* nsRet = [[NSNumber alloc] initWithInt:nRet];
    return nsRet;
}

- (void) handleMatchRejectedEvent:(GKInvite*)acceptedInvite
{
    
}

/////////////////////////////////////////////
// Game Center Mathc related functions, end
/////////////////////////////////////////////
- (void) processGameCenterAuth: (NSError*) error
{
    [self.m_MainView HideSpinner];
    
	if(error == NULL)
	{
        [GameCenterManager setCurrentLocalPlayerAlias:[GKLocalPlayer localPlayer].alias];
        [GameCenterManager setCurrentLocalPlayerID:[GKLocalPlayer localPlayer].playerID];
        [ApplicationConfigure SetGameCenterLoggingin:NO];
        [ApplicationConfigure SetGameCenterEnable:YES];
        m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByIndex:0];
        [m_GameCenterManager reloadHighScoresForCategory: m_CurrentLeaderBoard];
        [Configuration ClearGKGameCenterAccessTry];
        [self.m_MainView RegisterGKInvitationListener];
 	}
	else
	{
        [ApplicationConfigure SetGameCenterLoggingin:NO];
        [ApplicationConfigure SetGameCenterEnable:NO];
        [Configuration ClearGKGameCenterAccessTry];
	}
    [self.m_MainView UpdateOnlineButtonsStatus];
    [self.m_MainView setNeedsDisplay];
}

- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if([GKLocalPlayer localPlayer].authenticated == YES)
    {
        [GameCenterManager setCurrentLocalPlayerAlias:[GKLocalPlayer localPlayer].alias];
        [GameCenterManager setCurrentLocalPlayerID:[GKLocalPlayer localPlayer].playerID];
        [ApplicationConfigure SetGameCenterLoggingin:NO];
        [ApplicationConfigure SetGameCenterEnable:YES];
        m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByIndex:0];
        [m_GameCenterManager reloadHighScoresForCategory: m_CurrentLeaderBoard];
        [Configuration ClearGKGameCenterAccessTry];
    }
    else
    {
        [ApplicationConfigure SetGameCenterLoggingin:NO];
        [ApplicationConfigure SetGameCenterEnable:NO];
        [Configuration ClearGKGameCenterAccessTry];
    }
    [self.m_MainView UpdateOnlineButtonsStatus];
    [self.m_MainView setNeedsDisplay];
}


- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
{
	if((error == nil) && (player != nil))
	{
        [GameCenterManager setCurrentLocalPlayerAlias:player.alias];
        [GameCenterManager setCurrentLocalPlayerID:player.playerID];
		
	}
	else
	{
		//m_LeaderboardHighScoreDescription= @"GameCenter Scores Unavailable";
		//m_LeaderboardHighScoreDescription=  @"-";
	}
    [self.m_MainView setNeedsDisplay];
}

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
{
	if(error == NULL)
	{
		m_nHighestScore = (int)leaderBoard.localPlayerScore.value;
		if([leaderBoard.scores count] >0)
		{
			GKScore* allTime= [leaderBoard.scores objectAtIndex: 0];
			[m_GameCenterManager mapPlayerIDtoPlayer: allTime.player.alias];
		}
	}
	else
	{
		[self showAlertWithTitle: @"Score Reload Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}

- (void) scoreReported: (NSError*) error;
{
	if(error == NULL)
	{
         [self.m_MainView HideSpinner];
         [m_GameCenterManager reloadHighScoresForCategory: m_CurrentLeaderBoard];
         [self showAlertWithTitle: @"High Score Reported!"
                             message: [NSString stringWithFormat: @"%@", [error localizedDescription]]];
        m_LeaderboardPostSemphore = 0; 
	}
	else
	{
        m_LeaderboardPostSemphore = 0;
        [self.m_MainView HideSpinner];
		[self showAlertWithTitle: @"Score Report Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}



- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{
/*    if((error == NULL) && (ach != NULL))
    {
        if(0 < m_AchievementPostSemphore)
        {
            --m_AchievementPostSemphore;
            [self postAchievementByIndex:(m_AchievementPostSemphore-1)];
            return;
        }
        if(m_AchievementPostSemphore == 0)
        {    
            [self.m_MainView HideSpinner];
        }    
    }
    else
    {
        m_AchievementPostSemphore = 0;
        [self.m_MainView HideSpinner];
        [self showAlertWithTitle: @"Achievement Submission Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
    }*/
}

- (void) achievementResetResult: (NSError*) error;
{
    if(error != NULL)
    {
        [self showAlertWithTitle: @"Achievement Reset Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
    }
}

#pragma mark GKLeaderboardViewControllerDelegate Methods
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissModalViewControllerAnimated: YES];
}

#pragma mark GKAchievementViewControllerDelegate Methods
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
	[self dismissModalViewControllerAnimated: YES];
}

//GameCenterPostDelegate methods
- (void) PostGameCenterScore:(int)nScore withBoard:(int)boardIndex
{
    if(![GameCenterManager isGameCenterSupported] || ![self IsConnectedGameCenter])
    {
        [CustomModalAlertView SimpleSay:@"Cannot access GameCenter!" closeButton:[StringFactory GetString_Close]];
        return;
    }
/*
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    [buttons addObject:@"Universal ScoreBoard"];
    [buttons addObject:@"Game Center"];
    
    int nAnswer = [CustomModalAlertView MultChoice:@"Post score to:" withCancel:[StringFactory GetString_Cancel] withChoice:buttons];
    
    if(nAnswer == 1)
    {
        return;
    }
    else if(nAnswer == 0)
    {
        return;
    }
*/
    m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByIndex:boardIndex];
    
	if(nScore > m_nHighestScore)
	{
        m_LeaderboardPostSemphore = 1;
        [self.m_MainView ShowSpinner];
		[m_GameCenterManager reportScore: nScore forCategory: m_CurrentLeaderBoard];
	}
    //else
    //{
	//	[self showAlertWithTitle: @"Score Report Failed!"
	//					 message: [NSString stringWithFormat: @"Reason: %@", @"Score is not highest one"]];
    //}
    [CustomModalAlertView SimpleSay:@"Highest Score posted!" closeButton:[StringFactory GetString_Close]];
}

- (void) OpenLeaderBoardView:(int)boardIndex
{
	if(![GameCenterManager isGameCenterSupported] || ![self IsConnectedGameCenter])
    {
        [CustomModalAlertView SimpleSay:@"Cannot access GameCenter!" closeButton:[StringFactory GetString_Close]];
        return;
    }
    m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByIndex:boardIndex];
	
/*
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) 
	{
		leaderboardController.category = m_CurrentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[ApplicationConfigure SetModalPresentAccountable];
        [self presentModalViewController: leaderboardController animated: YES];
	}
*/
    [m_GameCenterManager showLeaderboardOnViewController:self forBoardIdentifier:m_CurrentLeaderBoard];
    
}

- (void) OpenAchievementViewBoardView:(int)boardIndex
{
}

- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex
{
/*
	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentAchievementBoard = [GameAchievementHelper GetAchievementIDByIndex:boardIndex];
    
	if(achievement > 0)
	{
		[m_GameCenterManager submitAchievement:m_CurrentAchievementBoard percentComplete:achievement];
	}
    else
    {
		[self showAlertWithTitle: @"Achievement Report Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", @"0 percent achievement"]];
    }*/
}

- (void) PostAllGameScores
{
/*
    if(![GameCenterManager isGameCenterSupported])
        return;
    [self.m_MainView ShowSpinner];
    m_LeaderboardPostSemphore = 6;
    [self postLeadBoardScoreByIndex:(m_LeaderboardPostSemphore-1)];
*/
}

- (void) PostAllAchievements
{
/*
    [self.m_MainView ShowSpinner];
    
    m_AchievementPostSemphore = 6;
    [self postAchievementByIndex:(m_AchievementPostSemphore-1)];*/
}

- (BOOL) IsGameCenterReporting
{
/*    if(m_LeaderboardPostSemphore != 0 || m_AchievementPostSemphore != 0)
        return YES;
*/    
    return NO;
}

- (void) InviteFriends: (NSArray*) identifiers
{
    GKFriendRequestComposeViewController *friendRequestViewController = [[GKFriendRequestComposeViewController alloc] init];
    friendRequestViewController.composeViewDelegate = self; 
    if (identifiers) 
    {
        [friendRequestViewController addRecipientsWithPlayerIDs: identifiers];
    }
    [self presentModalViewController: friendRequestViewController animated: YES];
}

- (void) shutdownCurrentGame
{
    id<GameControllerDelegate> pGameController = [self GetGameController];
    if(pGameController)
    {
        [pGameController shutdownCurrentGame];
    }
}

- (void) AbsoultShutDownOnlineGame
{
    id<GameControllerDelegate> pGameController = [self GetGameController];
    if(pGameController)
    {
        [pGameController AbsoultShutDownOnlineGame];
    }
}


- (BOOL) isCurrentGameOnline
{
    BOOL bRet = NO;
    
    id<GameControllerDelegate> pGameController = [self GetGameController];
    if(pGameController)
    {
        bRet = ([pGameController GetGameOnlineState] == GAME_ONLINE_STATE_ONLINE);
    }
    return bRet;
}

//GKFriendRequestComposeViewControllerDelegate method
- (void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];    
}

//
// GKMatchmakerViewControllerDelegate methods
//
// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    NSLog(@"MVC was cancelled");
    [self dismissModalViewControllerAnimated:YES];   
    m_bStartGKGameAsMaster = NO;
    [self.m_MainView GKOnlineRequestCancelled];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    NSLog(@"MVC failed");
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    m_bStartGKGameAsMaster = NO;
    [self.m_MainView GKOnlineRequestCancelled];
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    NSLog(@"MVC was done");
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(m_bStartGKGameAsMaster)
    {
        m_bStartGKGameAsMaster = NO;
        [[self GetGameController] StartGKGameAsMaster:match];
    }
    else
    {
        [[self GetGameController] StartGKGameAsParticipant:match];
    }
    [self.m_MainView GKOnlineRequestDone];
}

// Players have been found for a server-hosted game, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs
{
    //Currently, we don't support this type game, then do nothing
    [self dismissModalViewControllerAnimated:YES];    
}

// voice chat client's participant ID
- (NSString *)participantID
{
    NSString* szID = @"";
	if([GameCenterManager isGameCenterSupported])
    {
        szID = [GameCenterManager getCurrentLocalPlayerID]; 
    }
    return szID;
}

- (void)StartOnlineButtonSpin
{
    [self.m_MainView StartOnlineButtonSpin];
}

- (void)StopOnlineButtonSpin
{
    [self.m_MainView StopOnlineButtonSpin];
}

- (void)ShowStatusBar:(NSString*)text
{
    [self.m_MainView ShowStatusBar:text];
}

//??- (void) peerPickerControllerDidCancel: (GKPeerPickerController *)picker
- (void) peerPickerControllerDidCancel: (GKPeerPickerController *)picker
{
	[picker dismiss];
	//[picker;
    m_bStartGKGameAsMaster = NO;
    [self.m_MainView GKOnlineRequestCancelled];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession: (GKSession *) session
{ 
	[picker dismiss];
    id<GameControllerDelegate>pGameController = [self GetGameController];
    if(pGameController)
    {
        [pGameController AdviseGKBTSession:session];
        [pGameController SetGKBTPeerID:peerID];
        [pGameController SetGKBTMyID:session.peerID];
        [pGameController StartGKBTSessionGamePreset];        
    }
    [self.m_MainView GKOnlineRequestDone];
	//[picker;
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type 
{ 
	// The session ID is basically the name of the service, and is used to create the bonjour connection.
    GKSession* pRet = nil;

    id<GameControllerDelegate>pGameController = [self GetGameController];
    if(pGameController)
    {
        if([pGameController GetGKBTSession] == nil)
        {
            [pGameController CreateGKBTSession]; 
        }
        pRet = [pGameController GetGKBTSession]; 
    }
    
    return pRet;
}

-(void)GotoOnlineGame
{
    [self.m_MainView GotoOnlineGame];
}

#define RECOMMENDATION_REWARD_EARN_DEFAULT      100
-(void)AddRecommendationReward
{
    [self.m_MainView AddMoneyToMyAccount:RECOMMENDATION_REWARD_EARN_DEFAULT];
}

@end
