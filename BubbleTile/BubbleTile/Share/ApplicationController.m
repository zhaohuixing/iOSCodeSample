    //
//  GameController.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "ApplicationMainView.h"
#import "ApplicationResource.h"
#import "ApplicationController.h"
#import "ImageLoader.h"
#import "GUILayout.h"
//#import "GameState.h"
//#import "GameUtility.h"
//#import "GameScore.h"
#import "ApplicationMainView.h"
#import "ApplicationResource.h"
#import "ApplicationController.h"
#import "ImageLoader.h"
#import "GUILayout.h"
#import "GameCenterConstant.h"
#import "GameAchievementHelper.h"
#import "UIDevice-Reachability.h"
#import "GameScore.h"
#import "StringFactory.h"
#import <Twitter/Twitter.h>
#import "RenderHelper.h"
#import "DrawHelper2.h"
#import "GameConfiguration.h"
#import "CustomModalAlertView.h"
#import "GUIEventLoop.h"
#import "AWSConstants.h"
#import "GameMsgFormatter.h"

//#ifndef GAME_TIMER_INTERVAL
#define GAME_TIMER_INTERVAL   0.01
//#endif


@implementation ApplicationController

//??????????
//??????????
//??????????
//??????????
-(void)launchMailAppOnDevice

{
    /*
    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    NSString *body = @"&body=It is raining in sunny California!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    */ 
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	NSString* strMsg = [NSString stringWithFormat:@"%@\n%@", title, message];
    [CustomModalAlertView SimpleSay:strMsg closeButton:[StringFactory GetString_Close]];
}

- (id) init
{
    self = [super init];
	if (self) 
	{
        [self CheckValentineDay];
        int nType = [GameScore GetBackgoundType];
        [GameConfiguration SetMainBackgroundType:nType];
        [DrawHelper2 InitializeResource];
        [RenderHelper InitializeResource];
		[ApplicationConfigure SetCurrentProduct: APPLICATION_PRODUCT_MINDFIRE];
        [GameScore InitializeGameScore];
        if([GameScore HasPurchasedProduct])
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
        //m_FacebookPoster = [[FacebookPoster alloc] init];
        m_bNeedPostGKTotalScore = NO;
        [GUIEventLoop RegisterEvent:GUIID_EVENT_POSTONLINESCORE  eventHandler:@selector(OnPostOnlineScoreEvent) eventReceiver:self eventSender:nil];
        m_AWSMessager = NULL;
        [self InitAWSMessager];
        
	}	
	return self;
}

-(void)CheckValentineDay
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setDateFormat:@"MM"];
	int month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter setDateFormat:@"dd"];
	int day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    if(month == 2 && (day == 12 || day == 13 || day == 14 || day == 15))
    {
        [GameConfiguration SetValentineDay:YES];
    }
    else
    {
        [GameConfiguration SetValentineDay:NO];
    }
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
	if([GameCenterManager isGameCenterSupported] && [UIDevice networkAvailable])
	{
		m_GameCenterManager = [[[GameCenterManager alloc] init] autorelease];
		[m_GameCenterManager setDelegate: self];
        [m_MainView ShowSpinner];
		if([m_GameCenterManager authenticateLocalUser] == YES)
        {
            [m_MainView HideSpinner];
            [ApplicationConfigure SetGameCenterEnable:YES];
        }
	}
    if(m_FileManager)
    {
        [m_FileManager LoadCacheFileData];
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
    [RenderHelper ReleaseResource];
	[ImageLoader Release];
    [GameScore CleanGameScore];
    if(m_Timer != nil)
	{
		[m_Timer invalidate];
		[m_Timer release];
		m_Timer = nil;
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
        [ApplicationConfigure SetGameCenterEnable:NO];
    }
    else
    {   
        [m_MainView ShowSpinner];
		if([m_GameCenterManager authenticateLocalUser] == NO)
        {    
            [ApplicationConfigure SetGameCenterEnable:YES];
        }    
    }    
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [m_MainView HideSpinner];
    [ApplicationConfigure SetGameCenterEnable:NO];
}

- (void) processGameCenterAuth: (NSError*) error
{
    [m_MainView HideSpinner];
	if(error == NULL)
	{
        [GameCenterManager setCurrentLocalPlayerAlias:[GKLocalPlayer localPlayer].alias];
        NSString* leaderBoardID = [GameAchievementHelper GetLeaderBoardIDByIndex:0]; 
		[m_GameCenterManager reloadHighScoresForCategory: leaderBoardID];
        [ApplicationConfigure SetGameCenterEnable:YES];
 	}
	else
	{
        NSString* szText = [NSString stringWithFormat:@"Game Center Account Access failed. Reaseon:%@", [error localizedDescription]];
        if ([CustomModalAlertView Ask:szText withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory GetString_TryAgain]] == ALERT_OK)
        {
            [m_MainView ShowSpinner];
            if([m_GameCenterManager authenticateLocalUser] == NO)
            {    
                [ApplicationConfigure SetGameCenterEnable:YES];
            }    
            else
            {
                [ApplicationConfigure SetGameCenterEnable:YES];
                [m_MainView HideSpinner];
            }
        }
        else 
        {
            [m_MainView HideSpinner];
            [ApplicationConfigure SetGameCenterEnable:NO];
        }
	}
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
		m_PersonalBestScoreString= [NSString stringWithFormat: @"%Ld", personalBest];
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
/*		m_PersonalBestScoreDescription= @"GameCenter Scores Unavailable";
		m_PersonalBestScoreString=  @"-";
		m_LeaderboardHighScoreDescription= @"GameCenter Scores Unavailable";
		m_LeaderboardHighScoreDescription=  @"-";
		[self showAlertWithTitle: @"Score Reload Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
*/ 
        [(ApplicationMainView*)m_MainView ShowTextOnStatusBar:@"Score Reload Failed!"];
	}
}

- (void) scoreReported: (NSError*) error;
{
	if(error == NULL)
	{
		//[m_GameCenterManager reloadHighScoresForCategory: m_CurrentLeaderBoard];
		//[self showAlertWithTitle: @"High Score Reported!"
		//				 message: [NSString stringWithFormat: @"%@", [error localizedDescription]]];
        if(m_bNeedPostGKTotalScore == YES)
        {
            m_bNeedPostGKTotalScore = NO;
            [self PostGKTotalGameScore];
        }
        else
        {
            [(ApplicationMainView*)m_MainView ShowTextOnStatusBar:@"High Score Repoted!"];
        }
	}
	else
	{
//		[self showAlertWithTitle: @"Score Report Failed!"
//						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
        [(ApplicationMainView*)m_MainView ShowTextOnStatusBar:@"Score Report Failed!"];
	}
    m_bNeedPostGKTotalScore = NO;
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
- (void) PostGameCenterScore:(int)nScore withBoard:(int)boardIndex
{
	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByIndex:boardIndex];
    
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

- (void) OpenLeaderBoardViewByPoint:(int)nPoint
{
/*	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByPoint:nPoint];
	
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) 
	{
		leaderboardController.category = m_CurrentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[self presentModalViewController: leaderboardController animated: YES];
	}*/
}

- (void) OpenAchievementViewBoardView:(int)boardIndex
{
/*	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentAchievementBoard = [GameAchievementHelper GetAchievementIDByIndex:boardIndex];
    
	GKAchievementViewController *achievementsController = [[GKAchievementViewController alloc] init];
	if (achievementsController != NULL)
	{
		achievementsController.achievementDelegate = self;
		[self presentModalViewController: achievementsController animated: YES];
	}
*/    
}

- (void) PostAchievement:(float)achievement withBoard:(int)boardIndex
{
/*	if(![GameCenterManager isGameCenterSupported])
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

- (void) PostGameCenterScoreByPoint:(int)nScore withPoint:(int)nPoint
{
/*	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentLeaderBoard = [GameAchievementHelper GetLeaderBoardIDByPoint:nPoint];
    
	if(nScore > 0)
	{
		[m_GameCenterManager reportScore: nScore forCategory: m_CurrentLeaderBoard];
	}
    else
    {
		[self showAlertWithTitle: @"Score Report Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", @"0 score"]];
    }*/
}

- (void) PostAchievementByPoint:(float)achievement withPoint:(int)nPoint
{
/*	if(![GameCenterManager isGameCenterSupported])
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
    }*/
}

- (void) RecheckShutdownConfigure
{
    if([GameScore HasPurchasedProduct] == NO && [UIDevice networkAvailable] == NO)
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
    TWTweetComposeViewController *tweetViewController = [[[TWTweetComposeViewController alloc] init] autorelease];
    
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

//BTFileManageDelegate protocol
-(void)PostFileSavingHandle
{
    [super PostFileSavingHandle];
    
    //?????????????????
#ifdef DEBUG
    if([BTFileManager CacheFileExist])
        NSLog(@"After cachefile saving, checked cache file exiting");
    else
        NSLog(@"After cachefile saving, checked cache file not exiting");
#endif    
}

-(void)StartGameWithoutCacheData
{
	[((ApplicationMainView*)m_MainView) StartNewGame:NO];
}

-(void)StartGameWithCacheData
{
	[((ApplicationMainView*)m_MainView) StartNewGame:YES];
}

- (void)SaveUnfinishedGameToCacheFile
{
    if(m_MainView && ![((ApplicationMainView*)m_MainView) IsGameComplete])
    {  
        if(!m_FileManager.m_PlayingFile || ![m_FileManager.m_PlayingFile IsValid])
        {    
            NSMutableDictionary* dataDict = [[[NSMutableDictionary alloc] init] autorelease];
            [BTFileHeader AssemnleDefaultPlayerCacheDataMessage:&dataDict];
            [((ApplicationMainView*)m_MainView) LoadGameSet:&dataDict];
            NSNumber* msgCount = [[[NSNumber alloc] initWithInt:1] autorelease];
            [dataDict setObject:msgCount forKey:BTF_RECORD_PLAY_COUNT_KEY];
            [BTFilePlayRecord AssemnleDefaultPlayRecordDataMessage:&dataDict completionState:NO withPrefIndex:0];
            [((ApplicationMainView*)m_MainView) LoadUndoList:&dataDict  withPrefIndex:0];
            [m_FileManager LoadGameFromGameMessage:(NSDictionary*)dataDict];
            [m_FileManager SaveAndCloseGameToCacheFile];
        }
        else
        {
            [self LoadLastGamePlayToFile];
            [m_FileManager SaveAndCloseGameToCacheFile];
        }
    }
    else
    {
        if([BTFileManager CacheFileExist])
            [BTFileManager DeleteCacheFile];
#ifdef DEBUG
        if([BTFileManager CacheFileExist])
            NSLog(@"Something wrong to delete cache file");
        else
            NSLog(@"Cache file deleted");
#endif        
    }
}

- (void)LoadNewGameToFile
{
    if(m_MainView)
    {    
        enGridType      enType = [GameConfiguration GetGridType];
        enGridLayout    enLayout = [GameConfiguration GetGridLayout];
        int             nEdge = [GameConfiguration GetBubbleUnit];
        NSString* szGameDescription = [StringFactory GetString_PuzzleString:(int)enType withLayout:(int)enLayout withEdge:nEdge];
        
        NSMutableDictionary* dataDict = [[[NSMutableDictionary alloc] init] autorelease];
        [BTFileHeader AssemnlePlayerNewGameDataMessage:&dataDict withGameInfo:szGameDescription];
        [((ApplicationMainView*)m_MainView) LoadGameSet:&dataDict];
        NSNumber* msgCount = [[[NSNumber alloc] initWithInt:1] autorelease];
        [dataDict setObject:msgCount forKey:BTF_RECORD_PLAY_COUNT_KEY];
        BOOL bCompletion = [((ApplicationMainView*)m_MainView) IsGameComplete];
        [BTFilePlayRecord AssemnleDefaultPlayRecordDataMessage:&dataDict completionState:bCompletion withPrefIndex:0];
        [((ApplicationMainView*)m_MainView) LoadUndoList:&dataDict withPrefIndex:0];
        [m_FileManager LoadGameFromGameMessage:(NSDictionary*)dataDict];
    }
}

- (void)LoadLastGamePlayToFile
{
    if(m_MainView)
    {    
        NSMutableDictionary* dataDict = [[[NSMutableDictionary alloc] init] autorelease];
        int nLastIndex = 0;
        if(m_FileManager.m_PlayingFile.m_PlayRecordList)
            nLastIndex = [m_FileManager.m_PlayingFile.m_PlayRecordList count];
        BOOL bCompletion = [((ApplicationMainView*)m_MainView) IsGameComplete];
        [BTFilePlayRecord AssemnleDefaultPlayRecordDataMessage:&dataDict completionState:bCompletion withPrefIndex:nLastIndex];
        [((ApplicationMainView*)m_MainView) LoadUndoList:&dataDict withPrefIndex:nLastIndex];
        [m_FileManager AddGamePlayRecordFromGameMessage:(NSDictionary*)dataDict];
    }
}


- (void)OpenPreviewView:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)enBubbleType withSetting:(NSArray*)setting
{
    if(m_MainView)
    {    
        [((ApplicationMainView*)m_MainView) OpenPreviewView:enType withLayout:enLayout withSize:nEdge withLevel:bEasy withBubble:enBubbleType withSetting:setting];
    }    
}

- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion 
{
    [super dismissViewControllerAnimated:flag completion:completion];
    NSLog(@"presentViewController is called");
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
            [self InterstitialAdViewClicked];
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
            [self InterstitialAdViewClicked];
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

-(void)StartGameFromFile:(NSURL*)fileUrl
{
    if(m_MainView)
    {
        [((ApplicationMainView*)m_MainView) StartGameFromFile:fileUrl];
    }
}

- (void)ShareGameByEmail:(NSURL*)fileURL
{
    NSString* fileName = [BTFileManager GetFileNameFromURL:fileURL];
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_Share], [StringFactory GetString_GameTitle:NO]];
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:subjectString];
    
    NSData *myData = [NSData dataWithContentsOfURL:fileURL];
    [picker addAttachmentData:myData mimeType:@"text/x-btf" fileName:fileName];
    NSString* gameURL = [StringFactory GetString_GameURL];
    NSString* gameTitle = [StringFactory GetString_GameTitle:NO];
    
    NSString* imgSrc = [NSString stringWithFormat:@"<img width=%C80%C height=%C80%C alt=%CBubble Tile%C src=%Chttp://a4.mzstatic.com/us/r1000/064/Purple/ab/40/ec/mzl.uboakcrx.175x175-75.jpg%C />", 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22];
    
    NSString *emailBody = [NSString stringWithFormat:@"<p>%@</p><p><a href=%@>%@%@</a></p>", subjectString, gameURL, imgSrc, gameTitle];
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];    
}

-(void)SendTellFriendsEmail
{
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_ILikeGame], [StringFactory  GetString_GameTitle:NO]];
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:subjectString];
    
    NSString* gameURL = [StringFactory GetString_GameURL];
    NSString* gameTitle = [StringFactory  GetString_GameTitle:NO];
    
    NSString* imgSrc = [NSString stringWithFormat:@"<img width=%C80%C height=%C80%C alt=%CBubble Tile%C src=%Chttp://a4.mzstatic.com/us/r1000/064/Purple/ab/40/ec/mzl.uboakcrx.175x175-75.jpg%C />", 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22];
    
    NSString *emailBody = [NSString stringWithFormat:@"<p>%@</p><p><a href=%@>%@%@</a></p>", subjectString, gameURL, imgSrc, gameTitle];
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];    
    
}

-(void)SendTellFriendsMessage
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_ILikeGame], [StringFactory  GetString_GameTitle:NO]];
    NSString* gameURL = [StringFactory GetString_GameURL];
    NSString *msgBody = [NSString stringWithFormat:@"%@ :%@", subjectString, gameURL];
    picker.body = msgBody;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];    
}

-(void)SendTellFriendsTwitter
{
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_ILikeGame], [StringFactory  GetString_GameTitle:NO]];
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
                 [self InterstitialAdViewClicked];
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
    NSString* subjectString = [NSString stringWithFormat:@"%@ %@", [StringFactory GetString_ILikeGame], [StringFactory  GetString_GameTitle:NO]];
    //[m_FacebookPoster FaceBookPostMessage:subjectString]; 
    NSString* alertString = @"I invite you to play Bubble Tile";
    
    //    [m_FacebookPoster FaceBookPostMessage:subjectString]; 
    StdAdPostAppDelegate* pDelegate = [GUILayout GetApplicationDelegate];
    if(pDelegate)
    {
        [pDelegate FacebookLogin];
        [pDelegate SendRequestsSendToMany:subjectString withAlert:alertString];
    }
}

- (void)FaceBookPostScore:(NSString*)sScore
{
    //[m_FacebookPoster FaceBookPostScore:sScore];
    StdAdPostAppDelegate* pDelegate = [GUILayout GetApplicationDelegate];
    if(pDelegate)
    {
        [pDelegate FacebookLogin];
        [pDelegate PostFacebookFeedToUser:sScore];
    }
}

//Show debug message
- (void)ShowDebugMessage:(NSString*)msg
{
#ifdef DEBUG
    if(m_MainView)
    {
        [((ApplicationMainView*)m_MainView) ShowDebugMessage:msg];
    }
#endif    
}

-(void)CompleteFacebookFeedMySelf
{
    [self InterstitialAdViewClicked];
}

-(void)CompleteFacebookSuggestToFriends
{
    [self InterstitialAdViewClicked];
}

- (void)InterstitialAdViewClicked
{
    if(m_MainView)
    {
        [((ApplicationMainView*)m_MainView) OnSNPostDone];
    }
}

- (void)CloseRedeemAdView
{
	[((ApplicationMainView*)m_MainView) CloseRedeemAdView];
}

- (void)PostAWSWonMessage:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withScore:(int)nScore
{
}

- (id)GetAWSMessager
{
    return m_AWSMessager;
}

- (BOOL)IsAWSMessagerEnabled
{
    BOOL bRet = (m_AWSMessager != nil && [UIDevice networkAvailable] && [GameScore isAWSServiceEnabled] == YES);
    return bRet;
}

- (NSString*)GetDefaultAWSNickName
{
    NSString* szName = [StringFactory GetString_GameTitle:NO];
    if([ApplicationConfigure IsGameCenterEnable])
    {
        szName = [GKLocalPlayer localPlayer].alias;//[GameCenterManager getCurrentLocalPlayerAlias];
    }
    else
    {
        szName = [NSString stringWithFormat:@"%@:%@",[StringFactory GetString_GameTitle:NO], [[UIDevice currentDevice] name]];
    }
    
    return szName;
}

- (NSMutableArray *)GetAWSMessagesQueue
{
    NSMutableArray* pArray =nil;
    
    if(m_AWSMessager != nil)
    {
        pArray = [m_AWSMessager getMessagesFromQueue];
    }
    
    return pArray;
}

- (void)InitAWSMessager
{
    if(m_AWSMessager == nil && [UIDevice networkAvailable])
    {
        m_AWSMessager = [[AWSMessageService alloc] init:XGADGET_ACCESS_KEY_ID withSecret:XGADGET_SECRET_KEY withTopic:FLYINGCOW_GAMERESULT_TOPIC withQueue:FLYINGCOW_GAMERESULT_QUEUE];
        if(m_AWSMessager)
        {
            [m_AWSMessager setQueueMessageRetentionTime:[ApplicationConfigure GetDefaultAWSMessageRetentionTime]];
        }
    }
}

- (void)PostAWSGameWinMessage
{
    if(m_AWSMessager)
    {
        enGameType enType = [GameConfiguration GetGridType];
        enGridLayout enLayout = [GameConfiguration GetGridLayout];
        int nEdge = [GameConfiguration GetBubbleUnit];
        int nScore = [GameScore GetTotalGameScore];
        GameMessage* msg = [[[GameMessage alloc] init] autorelease];
        NSString* szName = [self GetDefaultAWSNickName];
        [GameMsgFormatter AddMsgText:msg withKey:AWS_MESSAGE_GAMER_NICKNAME_KEY withText:szName];
       
        [GameMsgFormatter AddMsgInt:msg withKey:AWS_MESSAGE_GAME_GRID_KEY withInteger:(int)enType];
        [GameMsgFormatter AddMsgInt:msg withKey:AWS_MESSAGE_GAME_LAYOUT_KEY withInteger:(int)enLayout];
        [GameMsgFormatter AddMsgInt:msg withKey:AWS_MESSAGE_GAME_UNIT_KEY withInteger:nEdge];
        
        
        [GameMsgFormatter AddMsgInt:msg withKey:AWS_MESSAGE_GAME_TOTALSCORE_KEY withInteger:nScore];
        [GameMsgFormatter AddMsgInt:msg withKey:AWS_MESSAGE_GAME_DEVICETYPE_KEY withInteger:0];
        [GameMsgFormatter EndFormatMsg:msg];
        [m_AWSMessager post:msg.m_GameMessage];
        
    }
}

- (void)PostCurrentGameScoreToGameCenter
{
	if(![GameCenterManager isGameCenterSupported])
        return;

    m_bNeedPostGKTotalScore = YES;
    
    int nScore = 0;
    if([GameConfiguration IsGameDifficulty])
    {
        nScore = [GameScore GetDifficultGameScore];
        m_CurrentLeaderBoard = _TOTAL_DIFFICULT_GAMESCORE_;
    }
    else
    {
        nScore = [GameScore GetEasyGameScore];
        m_CurrentLeaderBoard = _TOTAL_EASY_GAMESCORE_;
    }

    if(nScore > 0)
    {
        [m_GameCenterManager reportScore: nScore forCategory: m_CurrentLeaderBoard];
    }
}

- (void)PostCurrentGameScoreOnline
{
    if([self IsAWSMessagerEnabled])
        [self PostAWSGameWinMessage];
    
    [self PostCurrentGameScoreToGameCenter];    
}

- (void)PostGKTotalGameScore
{
    m_bNeedPostGKTotalScore = NO;
    int nTotalScore = [GameScore GetTotalGameScore];
	if(![GameCenterManager isGameCenterSupported])
        return;
    
    m_CurrentLeaderBoard = _TOTAL_GAMESCORE_;
    
	if(nTotalScore > 0)
	{
		[m_GameCenterManager reportScore: nTotalScore forCategory: m_CurrentLeaderBoard];
	}
}

-(void)OnPostOnlineScoreEvent
{
     if([UIDevice networkAvailable] == YES)
     {
         if ([CustomModalAlertView Ask:nil withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory   GetString_PostGameScore]] == ALERT_OK)
         {
             [self PostCurrentGameScoreOnline];
         }
     }
}
@end
