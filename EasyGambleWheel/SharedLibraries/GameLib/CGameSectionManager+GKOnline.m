//
//  CGameSectionManager+GKOnline.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CGameSectionManager+GKOnline.h"
#import "COnLineGameSection+GKMatchFunctions.h"
#import "COnLineGameSection+GameMessageHandler.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"

@implementation CGameSectionManager (GKOnline)

/////////////////////////////////////////////
//GameCenterOnlinePlayDelegate functions
/////////////////////////////////////////////
- (void)joinExistedMatch:(GKMatch*)gameMatch
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::joinExistedMatch is called."];
#endif     
    [GUIEventLoop SendEvent:GUIID_EVENT_ONLINE_GAMEEQUEST_DONE eventSender:self];
    [self StartGKGameAsParticipant:gameMatch];
}

-(void)StartGKGameAsMaster:(GKMatch*)match
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::StartGKGameAsMaster."];
#endif     
    if([m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_OFFLINE)
        [self ShutdownGameSection];
    
    m_ActiveGameSection = m_OnlineGameSection;
    [((COnLineGameSection*)m_ActiveGameSection) SetOnlineGameHost:YES];
    [((COnLineGameSection*)m_ActiveGameSection) ConnectAppleGameCenter:match];
}


-(void)StartGKGameAsParticipant:(GKMatch*)match
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::StartGKGameAsParticipant."];
#endif     
    if([m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_OFFLINE)
        [self ShutdownGameSection];
    m_ActiveGameSection = m_OnlineGameSection;
    [((COnLineGameSection*)m_ActiveGameSection) SetOnlineGameHost:NO];
    [((COnLineGameSection*)m_ActiveGameSection) ConnectAppleGameCenter:match];
}

-(void)AddGKPlayerToOnlineGame:(NSString*)playerID
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::AddGKPlayerToOnlineGame."];
#endif     
    
}

-(void)PopupGKMatchWindow
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::PopupGKMatchWindow."];
#endif     
    if(m_AppleGameCenterAgent)
        [m_AppleGameCenterAgent StartNewGameCenterSession:4];
}

-(void)PopupGKMatchWindowForPlayWith:(NSString*)szPlayerID
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::PopupGKMatchWindowForPlayWith."];
#endif
    if(m_AppleGameCenterAgent)
        [m_AppleGameCenterAgent StartNewGameCenterSessionWithPlayer:szPlayerID];
}

-(void)StartGKMatchAutoSearch
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::StartGKMatchAutoSearch."];
#endif     
    if(m_AppleGameCenterAgent)
        [m_AppleGameCenterAgent AutoSearchGameCenterSession];
}

-(void)PopupGKBTSessionWindow
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::PopupGKBTSessionWindow."];
#endif     
    if(m_AppleGameCenterAgent)
        [m_AppleGameCenterAgent StartGKBTSession];
}

-(void)CreateGKBTSession
{
    [(COnLineGameSection*)m_OnlineGameSection CreateGKBTSession];
}

-(GKSession*)GetGKBTSession
{
    return [(COnLineGameSection*)m_OnlineGameSection GetGKBTSession];
}

-(void)SetGKBTPeerID:(NSString*)peerID
{
    [(COnLineGameSection*)m_OnlineGameSection SetGKBTPeerID:peerID];
}

-(void)SetGKBTMyID:(NSString*)myID
{
    [(COnLineGameSection*)m_OnlineGameSection SetGKBTMyID:myID];
}

-(void)AdviseGKBTSession:(GKSession*)session
{
    [(COnLineGameSection*)m_OnlineGameSection AdviseGKBTSession:session];
}

-(void)StartGKBTSessionGamePreset
{
#ifdef DEBUG
    [ApplicationConfigure LogDebugInformation:@"GameCenterOnlinePlayDelegate::StartGKBTSessionGamePreset."];
#endif     
    [GUIEventLoop SendEvent:GUIID_EVENT_ONLINE_GAMEEQUEST_DONE eventSender:self];
    if([m_ActiveGameSection GetGameOnlineState] == GAME_ONLINE_STATE_OFFLINE)
        [self ShutdownGameSection];
    m_ActiveGameSection = m_OnlineGameSection;
    [((COnLineGameSection*)m_ActiveGameSection) SetOnlineGameHost:NO];
    [(COnLineGameSection*)m_OnlineGameSection LoadGKBTSessionPlayerInformation];
    
}

@end
