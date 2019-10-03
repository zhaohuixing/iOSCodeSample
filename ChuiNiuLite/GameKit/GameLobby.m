//
//  GameLobby.m
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-07-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameLobby.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@implementation GameLobby

@synthesize m_RealGameLobby;

- (void)InitAudioSessionByObjC
{
	NSError *myerror = nil;//[[NSError alloc] init];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance]; 
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&myerror]; 
    if(myerror != nil)
    {
        if(m_GamePostDelegate != nil)
            [m_GamePostDelegate HandleDebugMsg:[myerror description]];
    }
    [audioSession setActive: YES error: &myerror];    
    if(myerror != nil)
    {
        if(m_GamePostDelegate != nil)
            [m_GamePostDelegate HandleDebugMsg:[myerror description]];
    }
    //[myerror release];
    
}

- (void)InitAudioSessionByC
{
    OSStatus osRes = 0;
    osRes = AudioSessionInitialize(NULL, NULL, NULL, NULL);
    if (osRes) 
    {
        NSString* szMsg = [NSString stringWithFormat:@"Initializing Audio Session Failed: %ld", (long)osRes];
        if(m_GamePostDelegate != nil)
            [m_GamePostDelegate HandleDebugMsg:szMsg];
    }
    
    osRes = AudioSessionSetActive(true);
    if (osRes) 
    {
        NSString* szMsg = [NSString stringWithFormat:@"AudioSessionSetActive Failed: %ld", (long)osRes];
        if(m_GamePostDelegate != nil)
            [m_GamePostDelegate HandleDebugMsg:szMsg];
    }
    
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    osRes = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    if (osRes) 
    {
        NSString* szMsg = [NSString stringWithFormat:@"AudioSessionSetProperty kAudioSessionCategory_PlayAndRecord Failed: %ld", (long)osRes];
        if(m_GamePostDelegate != nil)
            [m_GamePostDelegate HandleDebugMsg:szMsg];
    }
    UInt32 allowMixing = true;
    osRes = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing);
    if (osRes) 
    {
        NSString* szMsg = [NSString stringWithFormat:@"AudioSessionSetProperty kAudioSessionProperty_OverrideCategoryMixWithOthers Failed: %ld", (long)osRes];
        if(m_GamePostDelegate != nil)
            [m_GamePostDelegate HandleDebugMsg:szMsg];
    }
    UInt32 route = kAudioSessionOverrideAudioRoute_Speaker;
    osRes = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(route), &route);
    if (osRes) 
    {
        NSString* szMsg = [NSString stringWithFormat:@"AudioSessionSetProperty kAudioSessionOverrideAudioRoute_Speaker Failed: %ld", (long)osRes];
        if(m_GamePostDelegate != nil)
            [m_GamePostDelegate HandleDebugMsg:szMsg];
    }
}

- (void)InitAudioSession
{
    //[self InitAudioSessionByObjC];
    [self InitAudioSessionByC];
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.m_RealGameLobby = nil;
        m_bGameMaster = NO;
        m_MatchDelegate = nil;    
        m_MatchMVCDelegate = nil;
//        m_VoiceChatDelegate = nil;
        m_GamePostDelegate = nil;   
        m_LobbyState = GAME_LOBBY_NONE;
        m_GameChat = nil;
        m_PlayerRing = [[NSMutableArray alloc] init];
        m_bMyTurn = NO;

        [self InitAudioSession];
    }
    
    return self;
}

-(id)initWithDelegate:(id<GKMatchDelegate>)matchDelegate withMVCDelegate:(id<GKMatchmakerViewControllerDelegate>)mvcDelegate  withPostDelegate:(id<GameCenterPostDelegate>)postDelegate
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.m_RealGameLobby = nil;
        m_bGameMaster = NO;
        m_MatchDelegate = matchDelegate;    
        m_MatchMVCDelegate = mvcDelegate;
//        m_VoiceChatDelegate = chatDelegate;
        m_GamePostDelegate = postDelegate;    
        m_LobbyState = GAME_LOBBY_NONE;
        m_GameChat = nil;
        m_PlayerRing = [[NSMutableArray alloc] init];
        m_bMyTurn = NO;
        [self InitAudioSession];
    }
    
    return self;
}

-(void)RegisterDelegate:(id<GKMatchDelegate>)matchDelegate withMVCDelegate:(id<GKMatchmakerViewControllerDelegate>)mvcDelegate  withPostDelegate:(id<GameCenterPostDelegate>)postDelegate
{
    m_MatchDelegate = matchDelegate;    
    m_MatchMVCDelegate = mvcDelegate;
    //m_VoiceChatDelegate = chatDelegate;
    m_GamePostDelegate = postDelegate;    
}

- (void)dealloc
{
    [self Shutdown];
    m_MatchDelegate = nil;    
    m_MatchMVCDelegate = nil;
    //m_VoiceChatDelegate = nil;
    m_GamePostDelegate = nil;    
    [m_PlayerRing release];
    [super dealloc];
}

-(void)SetGameLobbyMaster:(BOOL)bMaster
{
    m_bGameMaster = bMaster;
}

-(BOOL)IsGameLobbyMaster
{
    return m_bGameMaster;
}

-(BOOL)IsLive
{
    BOOL bRet = (self.m_RealGameLobby != nil);
    return bRet;
}

-(EN_LOBBY_STATE)GetLobbyState
{
    return m_LobbyState;
}

-(void)SetLobbyInPlaying
{
    m_LobbyState = GAME_LOBBY_PLAYING;
}

-(void)InitVoiceChatChannel
{
    if(self.m_RealGameLobby != nil)
    {
        m_GameChat = [[self.m_RealGameLobby voiceChatWithName:@"GameChatRoom"] retain];
        m_GameChat.active = YES;
        m_GameChat.playerStateUpdateHandler = ^(NSString *playerID, GKVoiceChatPlayerState state) 
        {
            switch (state) 
            {
                case GKVoiceChatPlayerSpeaking: 
                {
                    NSString* szMsg = [NSString stringWithFormat:@"%@ is talking", playerID];
                    [m_GamePostDelegate HandleDebugMsg:szMsg];
                    break;
                }    
                case GKVoiceChatPlayerSilent:  
                {
                    NSString* szMsg = [NSString stringWithFormat:@"%@ is silent", playerID];
                    [m_GamePostDelegate HandleDebugMsg:szMsg];
                    break;
                }    
                case GKVoiceChatPlayerConnected:
                {
                    NSString* szMsg = [NSString stringWithFormat:@"%@ is connected into Voice Chat", playerID];
                    [m_GamePostDelegate HandleDebugMsg:szMsg];
                    break;
                }    
                case GKVoiceChatPlayerDisconnected:
                {
                    NSString* szMsg = [NSString stringWithFormat:@"%@ is disconnected into Voice Chat", playerID];
                    [m_GamePostDelegate HandleDebugMsg:szMsg];
                    break;
                }    
            }
        };    
        [m_GameChat setVolume:1.0];
        if([GKVoiceChat isVoIPAllowed])
        {
            [m_GamePostDelegate HandleDebugMsg:@"VoIP is allowed in this"];
        }
        else
        {
            [m_GamePostDelegate HandleDebugMsg:@"VoIP is not allowed in this"];
            
        }
        [m_GameChat stop];
        
    }    
}

-(void)Shutdown
{
    if(self.m_RealGameLobby != nil)
    {
        if(m_GameChat != nil)
        {
            [m_GameChat stop];
            m_GameChat.active = NO;
            [m_GameChat release];
            m_GameChat = nil;
        }
        [self.m_RealGameLobby disconnect];
        [self.m_RealGameLobby release];
        m_RealGameLobby = nil;
    }
    m_LobbyState = GAME_LOBBY_NONE;
    m_bGameMaster = NO;
    m_bMyTurn = NO;
    [m_PlayerRing removeAllObjects];
}

-(BOOL)CanPlayLobby
{
    BOOL bRet = (m_MatchDelegate != nil && m_MatchMVCDelegate != nil /*&& m_VoiceChatDelegate != nil*/ && m_GamePostDelegate != nil);
    return bRet;
}

-(void)StartNewLobby:(int)nMaxPlayer
{
    if([self CanPlayLobby])
    {    
        [self Shutdown];
        int nMaxCount = nMaxPlayer;
        if(4 < nMaxCount)
            nMaxCount = 4;
        if(nMaxCount < 2)
            nMaxCount = 2;
        
        GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
        request.minPlayers = 2; 
        request.maxPlayers = nMaxCount;
        GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
        mmvc.matchmakerDelegate = m_MatchMVCDelegate; 
        m_LobbyState = GAME_LOBBY_CREATING;
        m_bGameMaster = YES;
        m_bMyTurn = NO;
        [self ClearPlayerRing];
        [(UIViewController*)m_MatchMVCDelegate presentModalViewController:mmvc animated:YES];        
    }
}

-(void)AutoSearchLobby
{
    if([self CanPlayLobby])
    {    
        [self Shutdown];
        GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
        request.minPlayers = 2; 
        request.maxPlayers = 4;
        m_LobbyState = GAME_LOBBY_SEARCHING;
        
        [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) 
        {
            if (error) 
            {
                // Process the error.
                // Process the error.
                NSString* szMsg = [NSString stringWithFormat:@"Failed to search match by %@", [error description]];
                [m_GamePostDelegate HandleDebugMsg:szMsg];
                [self Shutdown];
            } 
            else if (match != nil) 
            {
                [self ClearPlayerRing];
                self.m_RealGameLobby = match; // Use a retaining property to retain the
                self.m_RealGameLobby.delegate = m_MatchDelegate; 
                if (m_LobbyState != GAME_LOBBY_PLAYING /*&& match.expectedPlayerCount == 0*/) 
                {
                    m_LobbyState = GAME_LOBBY_PLAYING; // Insert application-specific code to begin the match.
                    [m_GamePostDelegate HandleLobbyStartedEvent];
                    NSString* szMsg = [NSString stringWithFormat:@"ExpectedPalyerCount %i", match.expectedPlayerCount];
                    [m_GamePostDelegate HandleDebugMsg:szMsg];
                }
                m_bMyTurn = NO;
                [self InitVoiceChatChannel];
            }    
        }];
    } 
}

-(void)AddReplacementPlyerToLobby
{
    if(m_RealGameLobby != nil)
    {
        GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
        request.minPlayers = 2; 
        request.maxPlayers = 4;
        m_LobbyState = GAME_LOBBY_SEARCHING;
        
        [[GKMatchmaker sharedMatchmaker] addPlayersToMatch:m_RealGameLobby matchRequest:request completionHandler:^(NSError *error) 
         {
             if (error) 
             {
                 // Process the error.
                 NSString* szMsg = [NSString stringWithFormat:@"Failed to add replacement player by %@", [error description]];
                 [m_GamePostDelegate HandleDebugMsg:szMsg];
                 return;
             } 
             else 
             {
                 //m_RealGameLobby = match; // Use a retaining property to retain the
                 //m_RealGameLobby.delegate = m_MatchDelegate; 
                 //if (m_LobbyState != GAME_LOBBY_PLAYING && match.expectedPlayerCount == 0) 
                 //{
                 //    m_LobbyState = GAME_LOBBY_PLAYING; // Insert application-specific code to begin the match.
                 //    [m_GamePostDelegate HandleLobbyStartedEvent];
                 //}
                 // Process the error.
                 NSString* szMsg = [NSString stringWithFormat:@"Successful to add replacement player"];
                 [m_GamePostDelegate HandleDebugMsg:szMsg];
                 return;
             }    
         }];
    }
}

-(void)AdviseLobbyObject:(GKMatch*)match
{
    self.m_RealGameLobby = match; // Use a retaining property to retain the
    self.m_RealGameLobby.delegate = m_MatchDelegate; 
    m_bMyTurn = NO;
    [self InitVoiceChatChannel];
    if (m_LobbyState != GAME_LOBBY_PLAYING /*&& match.expectedPlayerCount == 0*/) 
    {
        m_LobbyState = GAME_LOBBY_PLAYING; // Insert application-specific code to begin the match.
        [m_GamePostDelegate HandleLobbyStartedEvent];
        NSString* szMsg = [NSString stringWithFormat:@"ExpectedPalyerCount %i", match.expectedPlayerCount];
        [m_GamePostDelegate HandleDebugMsg:szMsg];
    }
}


-(void)HandleLobbyInvitation
{
    if([self CanPlayLobby])
    {    
        m_LobbyState = GAME_LOBBY_RECIEVEINVITATION;
        [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) 
        {
            //Interrupted by other commands
            if(m_LobbyState != GAME_LOBBY_RECIEVEINVITATION)
            {    
                NSString* szMsg = [NSString stringWithFormat:@"Listening to invitation is stopped"];
                [m_GamePostDelegate HandleDebugMsg:szMsg];
                return;
            }
            
            [m_GamePostDelegate ResetCurrentPlayingGame];
            
            // Insert application-specific code here to clean up any games in progress. 
            if (acceptedInvite)
            {
                NSString* szMsg = [NSString stringWithFormat:@"Accept invitation"];
                [m_GamePostDelegate HandleDebugMsg:szMsg];
                GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite] autorelease];
                mmvc.matchmakerDelegate = m_MatchMVCDelegate; 
                [(UIViewController*)m_MatchMVCDelegate presentModalViewController:mmvc animated:YES];        
            } 
            else if (playersToInvite) 
            {
                NSString* szMsg = [NSString stringWithFormat:@"Accept multiplayers invitation"];
                [m_GamePostDelegate HandleDebugMsg:szMsg];
                GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
                request.minPlayers = 2; 
                request.maxPlayers = 4; 
                request.playersToInvite = playersToInvite;
                GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
                mmvc.matchmakerDelegate = m_MatchMVCDelegate; 
                m_bGameMaster = YES;
                [(UIViewController*)m_MatchMVCDelegate presentModalViewController:mmvc animated:YES];        
            }
        };
    }        
}

-(void)StartVoiceChat
{
    if(m_GameChat)
    {
        m_GameChat.active = YES;
        [m_GameChat start];
    }    
}

-(void)StopVoiceChat
{
    if(m_GameChat)
        [m_GameChat stop];
}

-(int)GetPlayerCount
{
    int nRet = 0;
    if(self.m_RealGameLobby != nil && self.m_RealGameLobby.playerIDs != nil)
    {
        nRet = [self.m_RealGameLobby.playerIDs count];
    }
    
    return nRet;
}

-(NSString*)GetPlayerID:(int)index
{
    NSString* szRet = @"";
    if(self.m_RealGameLobby != nil && self.m_RealGameLobby.playerIDs != nil && 0 <= index && index < [self.m_RealGameLobby.playerIDs count])
    {
        szRet = [self.m_RealGameLobby.playerIDs objectAtIndex:index];
    }
    
    return szRet;
}

-(BOOL)HasPlayer:(NSString*)playerID
{
    BOOL bRet = NO;
    
    if(self.m_RealGameLobby != nil && self.m_RealGameLobby.playerIDs != nil)
    {
        int count = [self.m_RealGameLobby.playerIDs count];
        if(0 < count)
        {  
            for(int i = 0; i < count; ++i)
            {    
                if([playerID isEqualToString:[self.m_RealGameLobby.playerIDs objectAtIndex:i]])
                {
                    bRet = YES;
                    return bRet;
                }
            }    
        }    
    }
    
    return bRet;
}


-(int)GetUnjoinedPlayerCount
{
    int nRet = -1;
    
    if(self.m_RealGameLobby != nil)
    {
        nRet = self.m_RealGameLobby.expectedPlayerCount;
    }
    
    return nRet;
}

-(BOOL)SendMessageToAllplayers:(GameMessage*)msg
{
    BOOL bRet = NO;
    
    if(self.m_RealGameLobby != nil && msg != nil)
    {
        NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            NSError* myerror = nil;
            [m_RealGameLobby sendDataToAllPlayers:data withDataMode:GKSendDataUnreliable error:&myerror];
            if(myerror == nil)
            {
                bRet = YES;
            }
        }    
    }
    
    return bRet;
}

-(BOOL)SendMessage:(GameMessage*)msg toPlayer:(NSString*)playerID
{
    BOOL bRet = NO;
    
    if(self.m_RealGameLobby != nil && msg != nil && [self HasPlayer:playerID])
    {
        NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            NSError* myerror = nil;
            NSArray* array = [NSArray arrayWithObject: playerID];
            [m_RealGameLobby sendData:data toPlayers:array withDataMode:GKSendDataUnreliable error:&myerror];
            if(myerror == nil)
            {
                bRet = YES;
            }
        }    
    }
    
    return bRet;
}

-(BOOL)IsMyTurnToPlay
{
    //Change late
    return m_bMyTurn;
}

-(void)ClearPlayerRing
{
    [m_PlayerRing removeAllObjects];
}

-(void)AddPlayerToRing:(NSString*)playerID
{
    //NSString* szPlayer = [NSString stringWithFormat:@"%@", playerID];
    [m_PlayerRing addObject:playerID];
}

-(void)RemovePlayerFromRing:(NSString*)playerID
{
    int nCount = [m_PlayerRing count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSString* szTemp = [m_PlayerRing objectAtIndex:i];
            if([playerID isEqualToString:szTemp] == YES)
            {
                [m_PlayerRing removeObjectAtIndex:i];
                break;
            }
        }
    }
}

-(int)GetMyIndexInRing
{
    int nRet = -1;
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil)
        return nRet;
    
    NSString* localID = pPlayer.playerID;
    int nCount = [m_PlayerRing count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSString* szTemp = [m_PlayerRing objectAtIndex:i];
            if([localID isEqualToString:szTemp] == YES)
            {
                nRet = i;
                break;
            }
        }
    }
    return nRet;    
}

-(NSString*)GetPlayerIDInRing:(int)index
{
    NSString* szRet = @"";
    int nCount = [m_PlayerRing count];
    if(0 < nCount && 0 <= index && index < nCount)
    {
         szRet = [m_PlayerRing objectAtIndex:index];
    }
    
    return szRet;
}

-(void)SetPlayerTurn:(BOOL)bMyTurn
{
    m_bMyTurn = bMyTurn;
}

-(NSString*)GetMyNextPlayerInRing
{
    NSString* szRet = @"";
    int nCount = [m_PlayerRing count];
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil)
        return szRet;
    
    NSString* localID = pPlayer.playerID;
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSString* szTemp = [m_PlayerRing objectAtIndex:i];
            if([localID isEqualToString:szTemp] == YES)
            {
                if(i == nCount-1)
                    szRet = [m_PlayerRing objectAtIndex:0];
                else
                    szRet = [m_PlayerRing objectAtIndex:(i+1)];
                    
                return szRet;
            }
        }
    }
    return szRet;
}

-(NSString*)GetNextPlayerInRingAfter:(NSString*)playerID
{
    NSString* szRet = @"";
    int nCount = [m_PlayerRing count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSString* szTemp = [m_PlayerRing objectAtIndex:i];
            if([playerID isEqualToString:szTemp] == YES)
            {
                if(i == nCount-1)
                    szRet = [m_PlayerRing objectAtIndex:0];
                else
                    szRet = [m_PlayerRing objectAtIndex:(i+1)];
                
                return szRet;
            }
        }
    }
    
    return szRet;
}

-(BOOL)IsMasterPlayerInRing:(NSString*)playerID
{
    int nCount = [m_PlayerRing count];
    if(0 < nCount)
    {
        NSString* szTemp = [m_PlayerRing objectAtIndex:0];
        if([playerID isEqualToString:szTemp] == YES)
            return YES;
    }
    
    return NO;
}

-(int)GetPlayerCountInRing
{
    int nCount = [m_PlayerRing count];
    return nCount;
}


@end
