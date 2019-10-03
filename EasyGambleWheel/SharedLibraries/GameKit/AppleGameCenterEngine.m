//
//  AppleGameCenterEngine.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "AppleGameCenterEngine.h"

#ifndef USGKINVITEEVENTLISTENER
#define USGKINVITEEVENTLISTENER
#endif

#ifdef USGKINVITEEVENTLISTENER
@interface AppleGameCenterEngine () <GKLocalPlayerListener>

@end
#endif


@implementation AppleGameCenterEngine

- (int) callMainDelegateForReturnValue: (SEL) selector withArg: (id) arg
{
    int nRet = -1;
    id  objRet;
	assert([NSThread isMainThread]);
	if(m_GameCenterManager && [m_GameCenterManager respondsToSelector: selector])
	{
		if(arg != NULL)
		{
			objRet = [m_GameCenterManager performSelector:selector withObject: arg];
		}
		else
		{
			objRet = [m_GameCenterManager performSelector:selector];
		}
        if(objRet && [objRet isKindOfClass:[NSNumber class]])
        {
            nRet = [objRet intValue];
        }
	}
	else
	{
		NSLog(@"callMainDelegateForReturnValue Missed Method");
	}
    
    return nRet;
}


- (int) callMainDelegateOnMainThreadForReturnValue: (SEL) selector withArg: (id) arg
{
    __block int nRet = -1;
	dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        nRet = [self callMainDelegateForReturnValue: selector withArg: arg];
    });
    return nRet;
}

- (void) callMainDelegate: (SEL) selector withArg: (id) arg
{
	assert([NSThread isMainThread]);
	if(m_GameCenterManager && [m_GameCenterManager respondsToSelector: selector])
	{
		if(arg != NULL)
		{
			[m_GameCenterManager performSelector:selector withObject: arg];
		}
		else
		{
			[m_GameCenterManager performSelector:selector];
		}
	}
	else
	{
		NSLog(@"callMainDelegate Missed Method");
	}
}

- (void) callMainDelegateOnMainThread: (SEL) selector withArg: (id) arg
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [self callMainDelegate: selector withArg: arg];
    });
}


- (int) callGameControllerDelegateForReturnValue: (SEL) selector withArg: (id) arg
{
    int nRet = -1;
    id  objRet;
	assert([NSThread isMainThread]);
	if(m_OnlineGameController && [m_OnlineGameController respondsToSelector: selector])
	{
		if(arg != NULL)
		{
			objRet = [m_OnlineGameController performSelector:selector withObject: arg];
		}
		else
		{
			objRet = [m_OnlineGameController performSelector:selector];
		}
        if(objRet && [objRet isKindOfClass:[NSNumber class]])
        {
            nRet = [objRet intValue];
        }
	}
	else
	{
		NSLog(@"callMainDelegateForReturnValue Missed Method");
	}
    
    return nRet;
}


- (int) callGameControllerDelegateOnMainThreadForReturnValue: (SEL) selector withArg: (id) arg
{
    __block int nRet = -1;
	dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        nRet = [self callGameControllerDelegateForReturnValue: selector withArg: arg];
    });
    return nRet;
}


- (void) callGameControllerDelegate: (SEL) selector withArg: (id) arg
{
	assert([NSThread isMainThread]);
	if(m_OnlineGameController && [m_OnlineGameController respondsToSelector: selector])
	{
		if(arg != NULL)
		{
			[m_OnlineGameController performSelector:selector withObject: arg];
		}
		else
		{
			[m_OnlineGameController performSelector:selector];
		}
	}
	else
	{
		NSLog(@"callGameControllerDelegate Missed Method");
	}
}

- (void) callGameControllerDelegateOnMainThread: (SEL) selector withArg: (id) arg
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [self callGameControllerDelegate: selector withArg: arg];
    });
}

-(id)init
{
    self = [super init];
    if(self)
    {
        m_GameCenterManager = nil;
        m_OnlineGameController = nil;
    }
    return self;
}

-(void)dealloc
{
    m_GameCenterManager = nil;
    m_OnlineGameController = nil;
    
}

-(void)AttachDelegates:(id<GameCenterManagerDelegate, GKMatchmakerViewControllerDelegate, NSObject>)pMainDelegate with:(id <GameCenterOnlinePlayDelegate>)pControllerDelegate
{
    m_GameCenterManager = pMainDelegate;
    m_OnlineGameController = pControllerDelegate;
}

-(void)StartGKBTSession
{
    [m_GameCenterManager shutdownCurrentGame];
    [self callMainDelegateOnMainThread:@selector(showGKSessionPickerView) withArg:nil];
}

-(void)StartNewGameCenterSession:(int)nMaxPlayer
{
    [m_GameCenterManager shutdownCurrentGame];
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2; 
    request.maxPlayers = nMaxPlayer;
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = m_GameCenterManager;
    [self callMainDelegateOnMainThread:@selector(showMatchmakerMasterView:) withArg:mmvc];
}

-(void)StartNewGameCenterSessionWithPlayer:(NSString*)playerID
{
    [m_GameCenterManager shutdownCurrentGame];
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    request.recipients = [NSArray arrayWithObjects:playerID, nil];
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = m_GameCenterManager;
    [self callMainDelegateOnMainThread:@selector(showMatchmakerMasterView:) withArg:mmvc];
}

-(void)AutoSearchGameCenterSession
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2; 
    request.maxPlayers = 4;
    
    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) 
     {
         if (error) 
         {
             [self callMainDelegateOnMainThread:@selector(handleMatchErrorEvent:) withArg:error];
         } 
         else if (match != nil) 
         {
             //int nRet = [self callMainDelegateOnMainThreadForReturnValue:@selector(askForJoinMatch:) withArg:match];
             //if(0 < nRet)
             //{
                 //[self callGameControllerDelegateOnMainThread:@selector(joinExistedMatch:) withArg:match];
             [m_OnlineGameController joinExistedMatch:match];
             //}
             //else
             //{
             //    if(match)
             //        [match disconnect];
             //    [self callMainDelegateOnMainThread:@selector(handleAutoSearchMatchCancelledEvent) withArg:nil];
             //}
         }    
     }];
}


-(void)AddReplacementPlyerToGameSession:(GKMatch*)match
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2; 
    request.maxPlayers = 4;
    
    [[GKMatchmaker sharedMatchmaker] addPlayersToMatch:match matchRequest:request completionHandler:^(NSError *error) 
     {
         if (error) 
         {
             // Process the error.
             [self callMainDelegateOnMainThread:@selector(handleMatchErrorEvent:) withArg:error];
             return;
         } 
         else 
         {
             [self callMainDelegateOnMainThread:@selector(handleNewPlayerAddedIntoMatchEvent) withArg:nil];
         }    
     }];
}

-(void)AutoHandleGameSessionInvitation
{
#ifdef USGKINVITEEVENTLISTENER
    return;
#endif
    
    [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) 
    {
         // Insert application-specific code here to clean up any games in progress. 
        BOOL bOnlineNow = [m_GameCenterManager isCurrentGameOnline];
        if (acceptedInvite)
        {
            if(bOnlineNow)
            {    
                //int nRet = [self callMainDelegateOnMainThreadForReturnValue:@selector(askForJoinMatchByInvitation:) withArg:acceptedInvite];
                NSNumber* pRet = [m_GameCenterManager askForJoinMatchByInvitation:acceptedInvite];
                int nRet = 0;
                if(pRet)
                    nRet = [pRet intValue];
                if(0 < nRet)
                {
                    [m_GameCenterManager shutdownCurrentGame];
                    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite];
                    mmvc.matchmakerDelegate = m_GameCenterManager;
                    [self callMainDelegateOnMainThread:@selector(showMatchmakerParticipantView:) withArg:mmvc];
                }
            }
            else
            {
                GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite];
                mmvc.matchmakerDelegate = m_GameCenterManager;
                [self callMainDelegateOnMainThread:@selector(showMatchmakerParticipantView:) withArg:mmvc];
            }
            //else
            //{
            //    [self callMainDelegateOnMainThread:@selector(handleMatchRejectedEvent:) withArg:acceptedInvite];
            //}
        } 
        else if (playersToInvite) 
        {
            if(bOnlineNow)
            {    
                NSNumber* pRet = [m_GameCenterManager askForJoinGameByPlayersInvitation];
                int nRet = 0;
                if(pRet)
                    nRet = [pRet intValue];
                if(0 < nRet)
                {
                    GKMatchRequest *request = [[GKMatchRequest alloc] init];
                    request.minPlayers = 2; 
                    request.maxPlayers = 4; 
                    request.playersToInvite = playersToInvite;
                    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
                    mmvc.matchmakerDelegate = m_GameCenterManager;
                    [self callMainDelegateOnMainThread:@selector(showMatchmakerUI:) withArg:mmvc];
                }
            }
            else
            {
                GKMatchRequest *request = [[GKMatchRequest alloc] init];
                request.minPlayers = 2; 
                request.maxPlayers = 4; 
                request.playersToInvite = playersToInvite;
                GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
                mmvc.matchmakerDelegate = m_GameCenterManager;
                [self callMainDelegateOnMainThread:@selector(showMatchmakerUI:) withArg:mmvc];
            }
        }
    };
    
}

#ifdef USGKINVITEEVENTLISTENER
-(void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite
{
    BOOL bOnlineNow = [m_GameCenterManager isCurrentGameOnline];
    if (invite)
    {
        if(bOnlineNow)
        {
            //int nRet = [self callMainDelegateOnMainThreadForReturnValue:@selector(askForJoinMatchByInvitation:) withArg:acceptedInvite];
            NSNumber* pRet = [m_GameCenterManager askForJoinMatchByInvitation:invite];
            int nRet = 0;
            if(pRet)
                nRet = [pRet intValue];
            if(0 < nRet)
            {
                [m_GameCenterManager shutdownCurrentGame];
                GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:invite];
                mmvc.matchmakerDelegate = m_GameCenterManager;
                [self callMainDelegateOnMainThread:@selector(showMatchmakerParticipantView:) withArg:mmvc];
            }
        }
        else
        {
            GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:invite];
            mmvc.matchmakerDelegate = m_GameCenterManager;
            [self callMainDelegateOnMainThread:@selector(showMatchmakerParticipantView:) withArg:mmvc];
        }
    }
}


-(void)player:(GKPlayer *)player didRequestMatchWithPlayers:(NSArray *)playersToInvite
{
    BOOL bOnlineNow = [m_GameCenterManager isCurrentGameOnline];
    if (playersToInvite)
    {
        if(bOnlineNow)
        {
            NSNumber* pRet = [m_GameCenterManager askForJoinGameByPlayersInvitation];
            int nRet = 0;
            if(pRet)
                nRet = [pRet intValue];
            if(0 < nRet)
            {
                GKMatchRequest *request = [[GKMatchRequest alloc] init];
                request.minPlayers = 2;
                request.maxPlayers = 4;
                request.playersToInvite = playersToInvite;
                GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
                mmvc.matchmakerDelegate = m_GameCenterManager;
                [self callMainDelegateOnMainThread:@selector(showMatchmakerUI:) withArg:mmvc];
            }
        }
        else
        {
            GKMatchRequest *request = [[GKMatchRequest alloc] init];
            request.minPlayers = 2;
            request.maxPlayers = 4;
            request.playersToInvite = playersToInvite;
            GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
            mmvc.matchmakerDelegate = m_GameCenterManager;
            [self callMainDelegateOnMainThread:@selector(showMatchmakerUI:) withArg:mmvc];
        }
    }
}
#endif


@end
