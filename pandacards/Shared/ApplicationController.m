//
//  GameController.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "ApplicationMainView.h"
#import "ApplicationResource.h"
#import "ApplicationController.h"
#import "ImageLoader.h"
#import "GUILayout.h"
#import "GameState.h"
#import "GameUtility.h"
#import "GameScore.h"
#import "ApplicationMainView.h"
#import "ApplicationResource.h"
#import "ApplicationController.h"
#import "ImageLoader.h"
#import "GUILayout.h"
#import "ScoreRecord.h"
#import "GameCenterConstant.h"
#import "GameAchievementHelper.h"
#import "UIDevice-Reachability.h"
#import "GameMsgConstant.h"
#import "GameMsgFormatter.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "NSData-Base64.h"
#import "StringFactory.h"
#import "CustomModalAlertView.h"
#import <twitter/twitter.h>
#include "GameState.h"
#import "DrawHelper2.h"
#import "ApplicationController+Online.h"
#import "GUIEventLoop.h"

//#ifndef GAME_TIMER_INTERVAL
#define GAME_TIMER_INTERVAL   0.01
//#endif


@implementation ApplicationController

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	//NSString* strMsg = [NSString stringWithFormat:@"%@\n%@", title, message];
    //[CustomModalAlertView SimpleSay:strMsg closeButton:[StringFactory GetString_Close]];
    [(ApplicationMainView*)m_MainView showAlertWithTitle:title message: message];
}

//Code for handle game center match request
-(void)CreateLobbyObject
{
    m_GameLobby = [[GameLobby alloc] initWithDelegate:self withMVCDelegate:self withPostDelegate:self];
    [(ApplicationMainView*)m_MainView EnableLobbyUI:YES];
    [m_GameLobby HandleLobbyInvitation];
}

- (BOOL) IsLobbyEnabled
{
    BOOL bRet = (m_GameLobby != nil);
    return bRet;
}

- (BOOL) IsInLobby
{
    BOOL bRet = (m_GameLobby != nil && [m_GameLobby IsLive]);
    return bRet;
}

- (BOOL) IsGameLobbyMaster
{
    BOOL bRet = (m_GameLobby != nil && [m_GameLobby IsLive] && [m_GameLobby IsGameLobbyMaster]);
    return bRet;
}

- (id) init
{
    self = [super init];
	if (self) 
	{
		[ApplicationConfigure SetCurrentProduct: APPLICATION_PRODUCT_MINDFIRE];
        [DrawHelper2 InitializeResource];
        if([GameScore CheckPaymentState])
        {
            [ApplicationConfigure SetAdViewsState:NO];
        }    
        else
        {    
            [ApplicationConfigure SetAdViewsState:YES];
        }    
        if([StringFactory IsOSLangZH])
            [ApplicationConfigure SetChineseVersion];
        
        [ImageLoader Initialize];
		m_bInternet = YES;

        m_bGameMasterCheck = NO;
        m_TimeStartCenterMasterCheck = 0;
        m_bStartMasterCountingForNewGame = NO;
        m_TimeMasterCountingForNewGame = 0;
        
 //       m_FacebookPoster = [[FacebookPoster alloc] init];
	}	
	return self;
}

- (void)loadView 
{
	CGRect rect = [[UIScreen mainScreen] bounds];
	rect.size.height -= 20;
	rect.origin.y += 20;
	 
	m_MainView = (MainUIView*)[[ApplicationMainView alloc] initWithFrame:rect];
	m_MainView.backgroundColor = [UIColor blueColor];
	self.view = m_MainView;
	[m_MainView release];
	[self.view setUserInteractionEnabled:YES];
    [GUILayout SetMainUIDimension:rect.size.width withHeight:rect.size.height];
	[m_MainView InitSubViews];
}

- (void)handleTimer:(NSTimer*)timer 
{
    if(m_bGameMasterCheck == YES)
    {
        [self HandleGameMasterCheck];
    }
    if(m_bStartMasterCountingForNewGame == YES)
    {    
        [self HandleStartMasterCountingForNewGame];
    }
	[((ApplicationMainView*)m_MainView) OnTimerEvent];
}	

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.view.userInteractionEnabled = YES;
	self.view.multipleTouchEnabled = YES;
	if(m_Timer == nil)
	{	
		srandom(time(0));
		m_Timer = [[NSTimer scheduledTimerWithTimeInterval:GAME_TIMER_INTERVAL 
													target:self 
												  selector:@selector(handleTimer:)
												  userInfo:nil
												   repeats: YES 
					] retain]; 
	}
    [self CreateLobbyObject];
	if([GameCenterManager isGameCenterSupported] && [UIDevice networkAvailable])
	{
		m_GameCenterManager = [[[GameCenterManager alloc] init] autorelease];
		[m_GameCenterManager setDelegate: self];
        [m_MainView ShowSpinner];
		if([m_GameCenterManager authenticateLocalUser] == NO)
        {    
            setGameCenterLoggingin(1);
        }
        else
        {
            [m_MainView HideSpinner];
            [ApplicationConfigure SetGameCenterEnable:YES];
            //[(ApplicationMainView*)m_MainView DelayLoadAds];
        }
	}
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
    [m_MainView ResumeAds];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:YES];
    [m_MainView PauseAds];
}	

- (void)dealloc 
{
    [DrawHelper2 ReleaseResource];
	[ImageLoader Release];
    if(m_Timer != nil)
	{
		[m_Timer invalidate];
		[m_Timer release];
		m_Timer = nil;
	}
    if(m_GameLobby != nil)
    {
        [m_GameLobby Shutdown];
        [m_GameLobby release];
    }
    //[m_FacebookPoster release];
    [super dealloc];
}

#pragma mark GameCenterDelegateProtocol Methods
//Delegate method used by processGameCenterAuth to support looping waiting for game center authorization
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        setGameCenterLoggingin(0);
        [ApplicationConfigure SetGameCenterEnable:NO];
    }
    else
    {   
        [m_MainView ShowSpinner];
		if([m_GameCenterManager authenticateLocalUser] == NO)
        {    
            setGameCenterLoggingin(1);
            [ApplicationConfigure SetGameCenterEnable:YES];
        }    
    }    
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [m_MainView HideSpinner];
    setGameCenterLoggingin(0);
    [ApplicationConfigure SetGameCenterEnable:NO];
}

- (void) processGameCenterAuth: (NSError*) error
{
    [m_MainView HideSpinner];
	if(error == NULL)
	{
        [GameCenterManager setCurrentLocalPlayerAlias:[GKLocalPlayer localPlayer].alias];
        //NSString* leaderBoardID = [GameAchievementHelper GetAchievementIDByPoint:24]; //??????????????????????????????????????????????????
		//[m_GameCenterManager reloadHighScoresForCategory: leaderBoardID];
        setGameCenterLoggingin(0);
        [ApplicationConfigure SetGameCenterEnable:YES];
        //[self CreateLobbyObject];
        [m_MainView HideSpinner];
 	}
	else
	{
        //NSString* szTry = @"Try Again...";
		//UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: @"Game Center Account Required" 
         //                                               message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]
        //                                               delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: szTry, nil] autorelease];
		//[alert show];
        NSString* szText = [NSString stringWithFormat:@"Game Center Account Access failed. Reaseon:%@", [error localizedDescription]];
        if ([CustomModalAlertView Ask:szText withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_TryAgain]] == ALERT_OK)
        {
            [m_MainView ShowSpinner];
            if([m_GameCenterManager authenticateLocalUser] == NO)
            {    
                setGameCenterLoggingin(1);
                [ApplicationConfigure SetGameCenterEnable:YES];
            }    
            else
            {
                setGameCenterLoggingin(0);
                [ApplicationConfigure SetGameCenterEnable:YES];
                //[self CreateLobbyObject];
                [m_MainView HideSpinner];
            }
        }
        else 
        {
            [m_MainView HideSpinner];
            setGameCenterLoggingin(0);
            [ApplicationConfigure SetGameCenterEnable:NO];
            //if([m_GameCenterManager authenticateLocalUser] == YES)
            //{
            [ApplicationConfigure SetGameCenterEnable:NO];
                //[self CreateLobbyObject];
            //}
        }
	}
    //[(ApplicationMainView*)m_MainView DelayLoadAds];
}

- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
{
	if((error == NULL) && (player != NULL))
	{
		m_LeaderboardHighScoreDescription= [NSString stringWithFormat: @"%@ got:", player.alias];
        [GameCenterManager setCurrentLocalPlayerAlias:player.alias];
		
		if(m_CachedHighestScore != NULL)
		{
			m_LeaderboardHighScoreString= m_CachedHighestScore;
		}
		else
		{
			m_LeaderboardHighScoreString= @"-";
		}
        
	}
	else
	{
		m_LeaderboardHighScoreDescription= @"GameCenter Scores Unavailable";
		m_LeaderboardHighScoreDescription=  @"-";
	}
}

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
{
	if(error == NULL)
	{
		int64_t personalBest= leaderBoard.localPlayerScore.value;
		m_PersonalBestScoreDescription= @"Your Best:";
		m_PersonalBestScoreString= [NSString stringWithFormat: @"%ld", personalBest];
		if([leaderBoard.scores count] >0)
		{
			m_LeaderboardHighScoreDescription=  @"-";
			m_LeaderboardHighScoreString=  @"";
			GKScore* allTime= [leaderBoard.scores objectAtIndex: 0];
			m_CachedHighestScore= allTime.formattedValue;
			[m_GameCenterManager mapPlayerIDtoPlayer: allTime.playerID];
		}
	}
	else
	{
		m_PersonalBestScoreDescription= @"GameCenter Scores Unavailable";
		m_PersonalBestScoreString=  @"-";
		m_LeaderboardHighScoreDescription= @"GameCenter Scores Unavailable";
		m_LeaderboardHighScoreDescription=  @"-";
		[self showAlertWithTitle: @"Score Reload Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}

- (void) scoreReported: (NSError*) error;
{
	if(error == NULL)
	{
		[m_GameCenterManager reloadHighScoresForCategory: m_CurrentLeaderBoard];
		//[self showAlertWithTitle: @"High Score Reported!"
		//				 message: [NSString stringWithFormat: @"", [error localizedDescription]]];
        [(ApplicationMainView*)m_MainView CloseGameScorePostView:YES];
	}
	else
	{
		[self showAlertWithTitle: @"Score Report Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}



- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{
    if((error == NULL) && (ach != NULL))
    {
        if(ach.percentComplete == 100.0)
        {
            [self showAlertWithTitle: @"Achievement Earned!"
                             message: [NSString stringWithFormat: @"Great job!  You earned an achievement: \"%@\"", NSLocalizedString(ach.identifier, NULL)]];
        }
        else
        {
            if(ach.percentComplete > 0)
            {
                [self showAlertWithTitle: @"Achievement Progress!"
                                 message: [NSString stringWithFormat: @"Great job!  You're %.0f\%% of the way to: \"%@\"",ach.percentComplete, NSLocalizedString(ach.identifier, NULL)]];
            }
        }
    }
    else
    {
        [self showAlertWithTitle: @"Achievement Submission Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
    }
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
	[viewController release];
}

#pragma mark GKAchievementViewControllerDelegate Methods
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
	[self dismissModalViewControllerAnimated: YES];
	[viewController release];
}

//GameCenterPostDelegate methods
- (void) OpenLeaderBoardView:(int)boardIndex
{
	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByIndex:boardIndex];
	
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) 
	{
		leaderboardController.category = m_CurrentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[self presentModalViewController: leaderboardController animated: YES];
	}
}

- (void) OpenAchievementViewBoardView:(int)boardIndex
{
	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentAchievementBoard = [GameAchievementHelper GetAchievementIDByIndex:boardIndex];
    
	GKAchievementViewController *achievementsController = [[GKAchievementViewController alloc] init];
	if (achievementsController != NULL)
	{
		achievementsController.achievementDelegate = self;
		[self presentModalViewController: achievementsController animated: YES];
	}
    
}

- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex
{
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
    }
}

- (void) PostGameCenterScoreByPoint:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed
{
    if([GameScore CheckPaymentState] == NO && ![ApplicationConfigure CanTemporaryAccessPaidFeature])
    {
        NSString* szPaidFeature = [StringFactory GetString_PaidFeature];
        if ([CustomModalAlertView Ask:szPaidFeature withButton1:[StringFactory GetString_NoThanks] withButton2:[StringFactory GetString_Purchase]] == ALERT_OK)
        {
            [GUIEventLoop PostEvent:GUIID_EVENT_PURCHASE];
        }
        else
        {
            [((ApplicationMainView*)m_MainView) ShowRedeenAdViewForPostGameCenterScore:nScore withPoint:nPoint withSpeed:nSpeed];
        }
        return;
    }
    
	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByPoint:nPoint withSpeed:nSpeed];
    
	if(nScore > 0)
	{
		[m_GameCenterManager reportScore: nScore forCategory: m_CurrentLeaderBoard];
	}
    else
    {
		[self showAlertWithTitle: @"Score Report Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", @"0 score"]];
    }
}

- (void) PostAchievementByPoint:(float)achievement withPoint:(int)nPoint
{
	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentAchievementBoard = [GameAchievementHelper GetAchievementIDByPoint:nPoint];
    
	if(achievement > 0)
	{
		[m_GameCenterManager submitAchievement:m_CurrentAchievementBoard percentComplete:achievement];
	}
    else
    {
		[self showAlertWithTitle: @"Achievement Report Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", @"0 percent achievement"]];
    }
}

- (void) RecheckShutdownConfigure
{
    if([ApplicationConfigure GetAdViewsState] == YES && [UIDevice networkAvailable] == NO)
        [ApplicationConfigure SetShutdownGame:YES];
    else
        [ApplicationConfigure SetShutdownGame:NO];
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
    [friendRequestViewController release];
}

//GKFriendRequestComposeViewControllerDelegate method
- (void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];    
}

- (void) HandleLobbyStartedEvent
{
    [((ApplicationMainView*)m_MainView) OnLobbyStartedEvent];
    if([ApplicationConfigure IsDebugMode])
    {
        [self HandleDebugMsg:@"Matching done, lobby starting"];
        
        int nCount = [m_GameLobby GetPlayerCount];
        NSString* szCount = [NSString stringWithFormat:@"Players' number in Lobby:%i", nCount];
        [self HandleDebugMsg:szCount];
        
        if(0 < nCount)
        {
            for(int i = 0; i < nCount; ++i)
            {
                NSString* playerID = [m_GameLobby GetPlayerID:i];
                szCount = [NSString stringWithFormat:@"Player's ID:%@", playerID];
                [self HandleDebugMsg:szCount];
            }
        }
        nCount = [m_GameLobby GetUnjoinedPlayerCount];
        szCount = [NSString stringWithFormat:@"Unfilled number in Lobby:%i", nCount];
        [self HandleDebugMsg:szCount];
    }
}

- (void) StartProcessDewDefaultLobby
{
    if(m_GameLobby != nil && [m_GameLobby CanPlayLobby])
    {
        [m_GameLobby StartNewLobby:4];
    }
}

- (void) StartProcessSearchLobby
{
    if(m_GameLobby != nil && [m_GameLobby CanPlayLobby])
    {
        [m_GameLobby AutoSearchLobby];
    }
}

- (void) ResetCurrentPlayingGame
{
    [((ApplicationMainView*)m_MainView) ResetCurrentPlayingGame];
}

- (void) ShutdownLobby
{
    if(m_GameLobby != nil)
    {
        [m_GameLobby Shutdown];
    }
    //m_bLobbyMasterInit = NO;
    //m_bLobbyHighLitInit = NO;
    [(ApplicationMainView*)m_MainView ShowLobbyControls:NO];
}

- (void) StartVoiceChat
{
    if(m_GameLobby != nil)
    {
        [m_GameLobby StartVoiceChat];
    }
}

- (void) StopVoiceChat
{
    if(m_GameLobby != nil)
    {
        [m_GameLobby StopVoiceChat];
    }
}

- (EN_LOBBY_STATE) GetLobbyState
{
    EN_LOBBY_STATE enRet = GAME_LOBBY_NONE;
    if(m_GameLobby != nil)
    {
        enRet = [m_GameLobby GetLobbyState];
    }
    return enRet;
}

- (void)HandleDebugMsg:(NSString*)msg
{
    if([ApplicationConfigure IsDebugMode])
    {
        [(ApplicationMainView*)m_MainView HandleDebugMsg:msg];
    }
}

- (BOOL)SendMessageToAllplayers:(GameMessage*)msg
{
    BOOL bRet = NO;
    if(m_GameLobby != nil)
    {
        bRet = [m_GameLobby SendMessageToAllplayers:msg];
    }
    return bRet;
}

- (BOOL)SendMessage:(GameMessage*)msg toPlayer:(NSString*)playerID
{
    BOOL bRet = NO;
    if(m_GameLobby != nil)
    {
        bRet = [m_GameLobby SendMessage:msg toPlayer:playerID];
    }
    return bRet;
}

- (BOOL)IsMyTurnToPlay
{
    BOOL bRet = YES;
    /*if(m_GameLobby != nil)
     {
     bRet = [m_GameLobby IsMyTurnToPlay];
     }*/
    return bRet;
}

- (void)SendGameTurnMessage:(NSString*)playerID
{
    //    GameMessage* msg = [[GameMessage alloc] init];
    //    [GameMsgFormatter FormatNextTurnMsg:msg nextPlayer:playerID];
    //    [self SendMessageToAllplayers:msg];
    //    [msg release];
}

- (void)MakeGameTurnToNext
{
    /*    if([self IsMyTurnToPlay] == YES && isMsgBounceLock() == 0)
     {
     [m_GameLobby SetPlayerTurn:NO];
     NSString* playerID = [m_GameLobby GetMyNextPlayerInRing];
     [self SendGameTurnMessage:playerID];
     [(ApplicationMainView*)m_MainView SetPlayerAvatarHighLight:playerID];
     }*/
}

- (void)UpdateActivePlayerScore
{
    if([self IsInLobby])
    {
        [(ApplicationMainView*)m_MainView UpdateActivePlayerScore];
    }
}

-(NSString*)GetPlayerIDInRing:(int)index
{
    NSString* szRet = @"";
    if([self IsInLobby])
    {
        szRet = [m_GameLobby GetPlayerIDInRing:index];
    }
    return szRet;
}

-(void)handleNextTurnMessage:(NSString*)szPlayerID
{
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil)
        return;
    
    NSString* localID = pPlayer.playerID;
    if([localID isEqualToString:szPlayerID] == YES)
    {
        //setMsgBounceLock(1);
        [m_GameLobby SetPlayerTurn:YES];
        NSLog(@"handleNextTurnMessage to myself\n");
    }
    else
    {
        //setMsgBounceLock(0);
        [m_GameLobby SetPlayerTurn:NO];
        NSLog(@"handleNextTurnMessage to others\n");
    }
    [(ApplicationMainView*)m_MainView SetPlayerAvatarHighLight:szPlayerID];
}

-(void)startLobbyGame
{
    [(ApplicationMainView*)m_MainView StartLobbyGame];    
}

-(void)handleLobbyGamePlayerResult:(NSString*)playerID withResult:(int)nResult
{
    [(ApplicationMainView*)m_MainView SetGamePlayerResult:playerID withResult:nResult];    
}

-(void)handleLobbyGamePlayerWinResult:(NSString*)playerID withResult:(NSArray*)array
{
    [(ApplicationMainView*)m_MainView SetGamePlayerWinResult:playerID withResult:array];    
}

-(void)handleLobbyGamePlayerLoseResult:(NSString*)playerID
{
    [(ApplicationMainView*)m_MainView SetGamePlayerLoseResult:playerID];    
}

-(void)handleTextMessage:(NSString*)szText fromPlayer:(NSString*)playerID
{
    [(ApplicationMainView*)m_MainView ShowTextMessage:szText from:playerID];
    
    if([ApplicationConfigure IsDebugMode])
    {    
        NSString* szMsg = [NSString stringWithFormat:@"Player <%@> said: %@", playerID, szText];
        [self HandleDebugMsg:szMsg];
    }
}

-(void)parserMessageInformation:(NSDictionary*)msgData fromPlayer:(NSString*)playerID
{
    NSNumber* msgTypeID = [msgData valueForKey:GAME_MSG_KEY_TYPE];
    if(msgTypeID == nil)
    {
        if([ApplicationConfigure IsDebugMode])
        {    
            [self HandleDebugMsg:@"Can not parse out message type information"];
        }
        return;
    }
    int nTypeID = [msgTypeID intValue];
    switch (nTypeID)
    {
        case GAME_MSG_TYPE_TEXT:
        {
            NSString* msgText = [msgData valueForKey:GAME_MSG_KEY_TEXTMSG];
            if(msgText != nil)
            {
                [self handleTextMessage:msgText fromPlayer:playerID];
            }
            break;
        }
        case GAME_MSG_TYPE_MASTERCANDIATES:
        {
            m_bGameMasterCheck = NO;
            [m_GameLobby SetGameLobbyMaster:NO];
            NSString* msgMasterID = [msgData valueForKey:GAME_MSG_KEY_MASTER_ID];
            [m_GameLobby ClearPlayerRing];
            [m_GameLobby SetPlayerTurn:NO];
            if(msgMasterID != nil && 0 < [msgMasterID length])
            {    
                [m_GameLobby AddPlayerToRing:msgMasterID];
                [(ApplicationMainView*)m_MainView SetPlayerAvatarAsMaster:msgMasterID];
                NSString* msgPlayer1ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERONE_ID];
                if(msgPlayer1ID != nil && 0 < [msgPlayer1ID length])
                {
                    [m_GameLobby AddPlayerToRing:msgPlayer1ID];
                    NSString* msgPlayer2ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERTWO_ID];
                    if(msgPlayer2ID != nil && 0 < [msgPlayer2ID length])
                    {
                        [m_GameLobby AddPlayerToRing:msgPlayer2ID];
                        NSString* msgPlayer3ID = [msgData valueForKey:GAME_MSG_KEY_PLAYERTHREE_ID];
                        if(msgPlayer3ID != nil && 0 < [msgPlayer3ID length])
                        {
                            [m_GameLobby AddPlayerToRing:msgPlayer3ID];
                        }
                    }    
                }    
            }
            break;
        }
        case GAME_MSG_TYPE_GAMEPLAYENDWIN:
        {
            NSArray* msgResult = [msgData valueForKey:GAME_MSG_KEY_GAME_WINRESULT];
            if(msgResult != nil)
            {    
                [self handleLobbyGamePlayerWinResult:playerID withResult:msgResult];
            }    
            break;
        }
        case GAME_MSG_TYPE_GAMEPLAYENDLOSE:
        {
            [self handleLobbyGamePlayerLoseResult:playerID];
            break;
        }
            
        case GAME_MSG_TYPE_STARTWRITTING:
        {
            [(ApplicationMainView*)m_MainView PlayerStartWriteTextMessage:playerID];
            break;
        }
        case GAME_MSG_TYPE_STARTCHATTING:
        {
            [(ApplicationMainView*)m_MainView PlayerStartTalking:playerID];
            break;
        }
        case GAME_MSG_TYPE_STOPCHATTING:
        {
            [(ApplicationMainView*)m_MainView PlayerStopTalking:playerID];
            break;
        }
        case GAME_MSG_TYPE_GAMESETTINGSYNC:
        {
            [(ApplicationMainView*)m_MainView SetPlayerAvatarAsMaster:playerID];
            m_bGameMasterCheck = NO;
            NSNumber* msgPoint = [msgData valueForKey:GAME_MSG_KEY_GAME_POINTS];
            if(msgPoint != nil)
            {    
                int nPoint = [msgPoint intValue];
                SetGamePoint(nPoint);
            }    
            NSNumber* msgSpeed = [msgData valueForKey:GAME_MSG_KEY_GAME_SPEED];
            if(msgSpeed)
            {
                int nSpeed = [msgSpeed intValue];
                SetGameSpeed(nSpeed);
            }
            [(ApplicationMainView*)m_MainView GameConfigureChange];
            [(ApplicationMainView*)m_MainView SetGamePlayerState:playerID withState:ROBO_STATE_PLAY];
            break;
        }
        case GAME_MSG_TYPE_GAMECARDLIST:
        {
            m_bGameMasterCheck = NO;
            [(ApplicationMainView*)m_MainView SetPlayerAvatarAsMaster:playerID];
            NSArray* array = [msgData valueForKey:GAME_MSG_KEY_GAME_CARDLIST];
            if(array != nil)
            {
                [(ApplicationMainView*)m_MainView SetLobbyGameCardList:array];
                [(ApplicationMainView*)m_MainView SetGamePlayerState:playerID withState:ROBO_STATE_PLAY];
                [self startLobbyGame];
            }
            break;
        }
        case GAME_MSG_TYPE_NEXTGAMEDEAL:
        {
            [(ApplicationMainView*)m_MainView HandleLobbyGameNextDeal];
            break;
        }
        case GAME_MSG_TYPE_GAMEPLAYSTATECHANGE:
        {    
            NSNumber* msgState = [msgData valueForKey:GAME_MSG_KEY_GAMEPLAYERSTATE];
            if(msgState)
            {
                int nState = [msgState intValue];
                [(ApplicationMainView*)m_MainView SetGamePlayerState:playerID withState:nState];
            }
                
            break;
        }    
    }   
}

//
// GKMatchDelegate methods
//
// The match received data sent from the player.
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
	NSError *myerror = nil;
	NSDictionary* msgData = [[CJSONDeserializer deserializer] deserialize:data error:&myerror];
    if(myerror != nil && [myerror description] != nil)
    {
        if([ApplicationConfigure IsDebugMode])
        {    
            NSString* szMsg = [NSString stringWithFormat:@"Erro in decoding reveive data from Player %@ as %@", playerID, [myerror description]];
            [self HandleDebugMsg:szMsg];
        }
        return;
    }
    
    [self parserMessageInformation:msgData fromPlayer:playerID];
}

- (void)AddPlayerAvatar:(NSString*)playerID withName:(NSString*)szName
{
    [(ApplicationMainView*)m_MainView AddPlayerAvatarInLobby:playerID withName:szName];
}

- (void)AddPlayerAvatar2:(GKPlayer*)player
{
    [(ApplicationMainView*)m_MainView AddPlayerAvatarInLobby2:player];
}

- (NSString*)GetLobbyPlayerMsgKey:(int)nIndex
{
    NSString* sKey = @"";
    if(nIndex == 0)
        sKey = GAME_MSG_KEY_PLAYERONE_ID; 
    else if(nIndex == 1)
        sKey = GAME_MSG_KEY_PLAYERTWO_ID; 
    else if(nIndex == 2)
        sKey = GAME_MSG_KEY_PLAYERTHREE_ID; 
    
    return sKey;
}


- (void)SynchonzePlayersOrder:(GKMatch *)match
{
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil || pPlayer.authenticated == NO || match == nil || match.playerIDs == nil || [match.playerIDs count] == 0 || 4 < [match.playerIDs count])
        return;
    
    NSString* localID = pPlayer.playerID;
    int nCount = 0;
    [m_GameLobby ClearPlayerRing];
    [m_GameLobby AddPlayerToRing:localID];
    [m_GameLobby SetPlayerTurn:YES];
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_MASTERCANDIATES];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_MASTER_ID withText:localID];
    
    for(NSString* gplayerID in match.playerIDs)
    {
        if([localID isEqualToString:gplayerID] == NO)
        {
            [m_GameLobby AddPlayerToRing:gplayerID];
            NSString* sKey = [self GetLobbyPlayerMsgKey:nCount];
            [GameMsgFormatter AddMsgText:msg withKey:sKey withText:gplayerID];
            ++nCount;
        }
    }
    
    [GameMsgFormatter EndFormatMsg:msg];
    [self SendMessageToAllplayers:msg];
    [msg release];
    [self SendGameTurnMessage:localID];
    [(ApplicationMainView*)m_MainView SetPlayerAvatarHighLight:localID];
    [(ApplicationMainView*)m_MainView SetPlayerAvatarAsMaster:localID];
    //setMsgBounceLock(1);    
}

- (void)SynchonzeGameSetting
{
    GameMessage* msg = [[GameMessage alloc] init];
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMESETTINGSYNC];
    
    int nPoint = GetGamePoint();
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAME_POINTS withInteger:nPoint];
    
    int nSpeed = GetGameSpeed();
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAME_SPEED withInteger:nSpeed];
    
    [GameMsgFormatter EndFormatMsg:msg];
    [self SendMessageToAllplayers:msg];
    [msg release];
    
}

- (void)HandlePlayerJoin:(NSString *)playerID toMatch:(GKMatch *)match
{
    [self ResetCurrentPlayingGame];
    NSMutableArray* playerIDList = [[[NSMutableArray alloc] init] autorelease];
    [playerIDList addObject:playerID];
    [GKPlayer loadPlayersForIdentifiers: playerIDList withCompletionHandler:^(NSArray *playerArray, NSError *error)
     {
         if(playerArray != nil && 0 < playerArray.count)
         {
             for (GKPlayer* tempPlayer in playerArray)
             {
                 //NSString* szName = [NSString stringWithFormat:@"%@", tempPlayer.alias];
                 //[self AddPlayerAvatar:playerID withName:szName];
                 //[self AddPlayerAvatar:playerID withName:tempPlayer.alias];
                 [self AddPlayerAvatar2:tempPlayer];
                 break;
             }
         }    
     }];
    
    if(match != nil  && [self IsGameLobbyMaster] == YES)
    {
        m_bGameMasterCheck = NO;
        [self SynchonzeGameSetting];
        [self StartMasterCountingForNewGame];
    }
    
    
    if(match != nil && match.expectedPlayerCount == 0 && [self IsGameLobbyMaster] == YES)
    {
        [self SynchonzePlayersOrder:match];
    }
    else if([self IsGameLobbyMaster] == NO)
    {
        [self StartCenterMasterCheck];
    }
}

- (void)HandlePosetPlayerLeaveJobs
{
    [m_GameLobby AddReplacementPlyerToLobby];
}

- (void)HandlePlayerLeave:(NSString *)playerID fromMatch:(GKMatch *)match
{
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    NSString* localID = pPlayer.playerID;
    
    [self ResetCurrentPlayingGame];
    BOOL bTurnPlayer = [(ApplicationMainView*)m_MainView IsPlayerAvatarHighLight:playerID];
    NSString* szNextPlayer = [m_GameLobby GetNextPlayerInRingAfter:playerID];
    BOOL bMasterPlayer = [m_GameLobby IsMasterPlayerInRing:playerID];
    [(ApplicationMainView*)m_MainView RemovePlayerAvatarFromLobby:playerID];
    [m_GameLobby RemovePlayerFromRing:playerID];
    
    if(bTurnPlayer && [m_GameLobby IsGameLobbyMaster])
    {
        [self SendGameTurnMessage:szNextPlayer];
        if([localID isEqualToString:szNextPlayer] == YES)
        {
            [m_GameLobby SetPlayerTurn:YES];
        }
        else
        {
            [m_GameLobby SetPlayerTurn:NO];
        }
        [(ApplicationMainView*)m_MainView SetPlayerAvatarHighLight:szNextPlayer];
        [self HandlePosetPlayerLeaveJobs];
        return;
    }
    if(bMasterPlayer == YES)
    {
        int nIndex = [m_GameLobby GetMyIndexInRing];
        if(nIndex == 0)
        {
            [m_GameLobby SetGameLobbyMaster:YES];
            if(bTurnPlayer)
            {
                [self SendGameTurnMessage:szNextPlayer];
                if([localID isEqualToString:szNextPlayer] == YES)
                {
                    [m_GameLobby SetPlayerTurn:YES];
                }
                else
                {
                    [m_GameLobby SetPlayerTurn:NO];
                }
            }     
            [(ApplicationMainView*)m_MainView SetPlayerAvatarHighLight:szNextPlayer];
            [self HandlePosetPlayerLeaveJobs];
        }
        else
        {
            NSString* szMaster = [m_GameLobby GetPlayerIDInRing:0];
            [(ApplicationMainView*)m_MainView SetPlayerAvatarAsMaster:szMaster];
        }
    }
}


// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    NSString* szTemp = @"";
    switch(state)
    {
        case GKPlayerStateUnknown:
            szTemp = @"unknown";
            break;
        case GKPlayerStateConnected:
            szTemp = @"connected";
            [self HandlePlayerJoin:playerID toMatch:match];
            break;
        case GKPlayerStateDisconnected:
            szTemp = @"disconnected";
            [self HandlePlayerLeave:playerID fromMatch:match];
            break;
    }
    if([ApplicationConfigure IsDebugMode])
    {    
        NSString* szMsg = [NSString stringWithFormat:@"Player %@ state change to %@", playerID, szTemp];
        [self HandleDebugMsg:szMsg];
        int nCount = [m_GameLobby GetPlayerCount];
        NSString* szCount = [NSString stringWithFormat:@"Players' number in Lobby:%i", nCount];
        [self HandleDebugMsg:szCount];
        
        if(0 < nCount)
        {
            for(int i = 0; i < nCount; ++i)
            {
                NSString* playerID = [m_GameLobby GetPlayerID:i];
                szCount = [NSString stringWithFormat:@"Player's ID:%@", playerID];
                [self HandleDebugMsg:szCount];
            }
        }
        nCount = [m_GameLobby GetUnjoinedPlayerCount];
        szCount = [NSString stringWithFormat:@"Unfilled number in Lobby:%i", nCount];
        [self HandleDebugMsg:szCount];
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error
{
    if([ApplicationConfigure IsDebugMode])
    {    
        NSString* szMsg = [NSString stringWithFormat:@"Match failed to connect with %@ with error %@", playerID, [error description]];
        [self HandleDebugMsg:szMsg];
    }
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)match didFailWithError:(NSError *)error
{
    if([ApplicationConfigure IsDebugMode])
    {    
        NSString* szMsg = [NSString stringWithFormat:@"Match failed to created by error %@", [error description]];
        [self HandleDebugMsg:szMsg];
    }
}

//
// GKMatchmakerViewControllerDelegate methods
//
// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    NSLog(@"MVC was cancelled");
    [self dismissModalViewControllerAnimated:YES];    
    if(m_GameLobby != nil)
    {
        [m_GameLobby Shutdown];
        [m_GameLobby HandleLobbyInvitation];
    }
    [(ApplicationMainView*)m_MainView StopLobbyButtonSpin];
    if([ApplicationConfigure IsDebugMode])
    {    
        [self HandleDebugMsg:@"MVC was cancelled"];
    }
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    NSLog(@"MVC failed");
    [self dismissModalViewControllerAnimated:YES];    
    if(m_GameLobby != nil)
    {
        [m_GameLobby Shutdown];
        [m_GameLobby HandleLobbyInvitation];
    }
    [(ApplicationMainView*)m_MainView StopLobbyButtonSpin];
    if([ApplicationConfigure IsDebugMode])
    {    
        NSString* szMsg = [NSString stringWithFormat:@"Match creating failed with error %@", [error description]];
        [self HandleDebugMsg:szMsg];
    }
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    NSLog(@"MVC was done");
    [self dismissModalViewControllerAnimated:YES];
    if(m_GameLobby != nil)
    {
        [m_GameLobby AdviseLobbyObject:match];
    }
    if([ApplicationConfigure IsDebugMode])
    {    
        [self HandleDebugMsg:@"MVC was done"];
    }
}

// Players have been found for a server-hosted game, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs
{
    //Currently, we don't support this type game, then do nothing
    [self dismissModalViewControllerAnimated:YES];    
}

- (void)HandleAdRequest:(NSURL*)url
{
    [self dismissModalViewControllerAnimated:YES];
	[((ApplicationMainView*)m_MainView) HandleAdRequest:url];
    if([ApplicationConfigure IsRedeemModalPresent])
    {
        [((ApplicationMainView*)m_MainView) RedeemAdpopupViewClose];
    }
}


- (void)AdViewClicked
{
	[((ApplicationMainView*)m_MainView) AdViewClicked];
}

- (void)DismissExtendAdView
{
	[((ApplicationMainView*)m_MainView) DismissExtendAdView];
}

- (void) displayTweetResult:(NSString*)result
{
    [CustomModalAlertView SimpleSay:result closeButton:[StringFactory GetString_Close]];
}

- (void) PostTwitterMessage:(NSString*)tweet
{
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:tweet];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                output = @"Tweet done.";
                break;
            default:
                break;
        }
        
        [self performSelectorOnMainThread:@selector(displayTweetResult:) withObject:output waitUntilDone:NO];
        
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
}


- (void)FaceBookPostMessage:(NSString*)tweet
{
    StdAdPostAppDelegate* pDelegate = [GUILayout GetApplicationDelegate];
    if(pDelegate)
    {
        [pDelegate FacebookLogin];
        [pDelegate PostFacebookFeedToUser:tweet];
    }
}

//The MFMessageComposeViewControllerDelegate method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    BOOL bShowWarn = NO;
    NSString* text = @"";
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            [GUIEventLoop SendEvent:GUIID_POSTEDONSOICALNETWORK eventSender:nil];
            break;
        case MessageComposeResultFailed:
            text = [StringFactory GetString_MessageFailed];
            bShowWarn = YES;
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
    if(bShowWarn)
    {
        [CustomModalAlertView SimpleSay:text closeButton:[StringFactory GetString_Close]];
    }
}


//The MFMailComposeViewControllerDelegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 

{   
    // Notifies users about errors associated with the interface
    //????????????
    //????????????
    //????????????
    BOOL bShowWarn = NO;
    NSString* text = @"";
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [GUIEventLoop SendEvent:GUIID_POSTEDONSOICALNETWORK eventSender:nil];
            break;
        case MFMailComposeResultFailed:
            if(error)
            {
                text = [error localizedDescription];
            }
            else 
            {
                text = [StringFactory GetString_EmailFailed];
            }
            bShowWarn = YES;
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
    if(bShowWarn)
    {
        [CustomModalAlertView SimpleSay:text closeButton:[StringFactory GetString_Close]];
    }
}

-(void)SendTellFriendsEmail
{
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_ILikeGame], [StringFactory GetString_GameTitle:NO]];
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:subjectString];
    
    NSString* gameURL = [StringFactory GetString_GameURL];
    NSString* gameTitle = [StringFactory GetString_GameTitle:NO];
    
    NSString* imgSrc = [NSString stringWithFormat:@"<img width=%C80%C height=%C80%C alt=%CPanda Cards%C src=%Chttp://a536.phobos.apple.com/us/r30/Purple/v4/43/55/82/43558230-d2b7-57c6-c54f-7dcb174e0f4c/mza_8994574835340411801.170x170-75.png%C />", 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22];
    
    NSString *emailBody = [NSString stringWithFormat:@"<p>%@</p><p><a href=%@>%@%@</a></p>", subjectString, gameURL, imgSrc, gameTitle];
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];    
    
}

-(void)SendTellFriendsMessage
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_ILikeGame], [StringFactory GetString_GameTitle:NO]];
    NSString* gameURL = [StringFactory GetString_GameURL];
    NSString *msgBody = [NSString stringWithFormat:@"%@ :%@", subjectString, gameURL];
    picker.body = msgBody;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];    
}

-(void)SendTellFriendsTwitter
{
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_ILikeGame], [StringFactory GetString_GameTitle:NO]];
    TWTweetComposeViewController *tweetViewController = [[[TWTweetComposeViewController alloc] init] autorelease];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:subjectString];
    
    NSString* gameURL = [StringFactory GetString_GameURL]; 
    
    NSURL* gameLink = [NSURL URLWithString:gameURL];
    [tweetViewController addURL:gameLink];
    
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon3.png" ofType:nil];
	__block UIImage* uiImagge = [UIImage imageWithContentsOfFile:imagePath];
    
    [tweetViewController addImage:uiImagge];
    
    __block NSString *output = @"";
    __block BOOL bFailed = NO;
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) 
     {
         //NSString *output;
         
         switch (result) {
             case TWTweetComposeViewControllerResultCancelled:
                 // The cancel button was tapped.
                 output = @"Tweet cancelled.";
                 bFailed = YES;
                 break;
             case TWTweetComposeViewControllerResultDone:
                 // The tweet was sent.
                 //output = @"Tweet done.";
                 [GUIEventLoop SendEvent:GUIID_POSTEDONSOICALNETWORK eventSender:nil];
                 bFailed = NO;
                 break;
             default:
                 break;
         }
         
         // Dismiss the tweet composition view controller.
         [self dismissModalViewControllerAnimated:YES];
         //[uiImagge release];
         //if(bFailed)
         //    [self performSelectorOnMainThread:@selector(displayTweetResult:) withObject:output waitUntilDone:NO];
     }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
}

-(void)SendTellFriendsFacebook
{
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_ILikeGame], [StringFactory GetString_GameTitle:YES]];
    NSString* alertString = @"I invite you to play Panada Cards";
    
//    [m_FacebookPoster FaceBookPostMessage:subjectString]; 
    StdAdPostAppDelegate* pDelegate = [GUILayout GetApplicationDelegate];
    if(pDelegate)
    {
        [pDelegate FacebookLogin];
        [pDelegate SendRequestsSendToMany:subjectString withAlert:alertString];
    }
}

- (BOOL)CanAcceptInvitation
{
    if([GameScore CheckPaymentState] || [ApplicationConfigure CanTemporaryAccessPaidFeature])
    {
        return YES;
    }  
    NSString* szPaidFeature = [StringFactory GetString_PaidFeature];
    if ([CustomModalAlertView Ask:szPaidFeature withButton1:[StringFactory GetString_NoThanks] withButton2:[StringFactory GetString_Purchase]] == ALERT_OK)
    {
        [GUIEventLoop PostEvent:GUIID_EVENT_PURCHASE];
    }
    else
    {
        if([((ApplicationMainView*)m_MainView) ShowRedeenAdViewForAcceptInvitation] == NO)
            return NO;
        else
            return YES;
    }
    return NO;
}

- (void)CloseRedeemAdView
{
	[((ApplicationMainView*)m_MainView) CloseRedeemAdView];
}

- (void)HandleFreeVersionOnlineOption
{
	[((ApplicationMainView*)m_MainView) PopupFreeVersionLobbyOption];
}

- (void)HandleFreeVersionGameCenterScorePost:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed
{
	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByPoint:nPoint withSpeed:nSpeed];

	[((ApplicationMainView*)m_MainView).superview bringSubviewToFront:((ApplicationMainView*)m_MainView)];
    
	if(nScore > 0)
	{
		[m_GameCenterManager reportScore: nScore forCategory: m_CurrentLeaderBoard];
	}
    else
    {
		[self showAlertWithTitle: @"Score Report Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", @"0 score"]];
    }
}

- (void)HandleFreeVersionOnlineInvitation
{
    //Probably do nothing
}

- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion 
{
    [super dismissViewControllerAnimated:flag completion:completion];
	[((ApplicationMainView*)m_MainView) UpdateSubViewsOrientation];
    if([ApplicationConfigure IsRedeemModalPresent])
    {
        [((ApplicationMainView*)m_MainView) RedeemAdpopupViewClose];
    }
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [super dismissModalViewControllerAnimated:animated];
	[((ApplicationMainView*)m_MainView) UpdateSubViewsOrientation];
    if([ApplicationConfigure IsRedeemModalPresent])
    {
        [((ApplicationMainView*)m_MainView) RedeemAdpopupViewClose];
    }
}

-(void)CompleteFacebookFeedMySelf
{
    [GUIEventLoop SendEvent:GUIID_POSTEDONSOICALNETWORK eventSender:nil];
}

-(void)CompleteFacebookSuggestToFriends
{
    [GUIEventLoop SendEvent:GUIID_POSTEDONSOICALNETWORK eventSender:nil];
}

@end
