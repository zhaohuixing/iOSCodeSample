//
//  CGameSectionBase.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CGameSectionBase.h"
#import "GUILayout.h"
#import "GamePlayer+Online.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
#import "CustomModalAlertView.h"
#import "StringFactory.h"

@implementation CGameSectionBase

-(id)init
{
    self = [super init];
    if(self)
    {
        for(int i = 0; i < 4; ++i)
        {
            m_Players[i] = [[GamePlayer alloc] init];
            [m_Players[i] Activate:NO];
            if([self GetGameOnlineState] == GAME_ONLINE_STATE_OFFLINE)
            {
                [m_Players[i] SetPlayerOnlineStatus:NO];
            }
            else
            {
                [m_Players[i] SetPlayerOnlineStatus:YES];
            }
        }
        float fSize = [GUILayout GetAvatarDislaySize];
        m_PlayingSpinner = [[ActivePlayerAnimator alloc] initWithFrame:CGRectMake(0, 0, fSize/2.0, fSize/2.0)];
        m_nPlayerTurnIndex = -1;

        CGRect frame = [m_Players[0] GetSeatBound];
        CGFloat sx = frame.origin.x + (frame.size.width - fSize)/2.0;
        CGFloat sy = frame.origin.y + frame.size.height*1.5;
        [m_PlayingSpinner setFrame:CGRectMake(sx, sy, fSize, fSize)];
    }
    return self;
}

-(void)dealloc
{
  //  [GUIEventLoop RemoveEvent:GUIID_EVENT_PURCHASEFAILED eventReceiver:self eventSender:nil];
}

- (void)Draw:(CGContextRef)context inRect:(CGRect)rect
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            [m_Players[i] Draw:context];
        }
    }
}

-(void)AssignController:(id<GameControllerDelegate>)controller
{
    m_GameController = controller;
    [m_GameController RegisterSubUIObject:m_PlayingSpinner];
}

-(void)OnTimerEvent
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            [m_Players[i] OnTimerEvent];
        }
    }
}

-(void)UpdateGameLayout
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i])
        {
            [m_Players[i] UpdateLayout];
        }
    }
    [self LocatePlayingSpinner];
}

-(GamePlayer*)GetPlayer:(int)nSeatID
{
    GamePlayer* pPlayer = nil;
    for(int i = 0; i < 4; ++i)
    {
        if([m_Players[i] GetSeatID] == nSeatID)
        {
            return m_Players[i];
        }
    }
    return pPlayer;
}

-(GamePlayer*)GetMyself
{
    GamePlayer* pPlayer = nil;
    for(int i = 0; i < 4; ++i)
    {
        if([m_Players[i] IsMyself])
        {
            return m_Players[i];
        }
    }
    return pPlayer;
}

-(id)GetPlayerAtSeat:(int)nSeatID
{
    return [self GetPlayer:nSeatID];
}


-(void)LocatePlayingSpinner
{
    int nSeat = [self GetCurrentActivePlayingSeat];
    if(nSeat < 0 || 4 <= nSeat)
        nSeat = 0;
    //    return;
    /*if(!m_Players[nSeat] || ![m_Players[nSeat] IsActivated])  
        return;
    */
    GamePlayer* pPlayer = [self GetPlayer:nSeat];
    if(!pPlayer || ![pPlayer IsActivated])
        return;
        
    
    float fSize = [GUILayout GetAvatarDislaySize]/2.0;
    float sx = 0; 
    float sy = 0;
    CGRect frame = [pPlayer GetSeatBound];
    
    if(nSeat == 1)
    {
        sx = frame.origin.x + (frame.size.width - fSize)/2.0;
        sy = frame.origin.y + frame.size.height*1.5;
    }
    else if(nSeat == 2)
    {
        sx = frame.origin.x + (frame.size.width - fSize)/2.0;
        sy = frame.origin.y - fSize;
    }
    else if(nSeat == 3)
    {
        sx = frame.origin.x + (frame.size.width - fSize)/2.0;
        sy = frame.origin.y - fSize;
    }
    else
    {
        sx = frame.origin.x + (frame.size.width - fSize)/2.0;
        sy = frame.origin.y + frame.size.height*1.5;
    }
    [m_PlayingSpinner setFrame:CGRectMake(sx, sy, fSize, fSize)]; 
}

-(int)GetCurrentActivePlayingSeat
{
    return m_nPlayerTurnIndex;
}

-(void)ForceClosePlayerMenus
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            [m_Players[i] ForceClosePopupMenu];
        }
    }
}

-(void)ShowPlayersPledgeInformation
{
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated] && [m_Players[i] IsEnabled])
        {
            [m_Players[i] ShowPlayBet];
        }
    }
}

-(void)RestoreOffLineReadyState
{
    
}

-(int)GetAcitvitedPlayersNumber
{
    int nRet = 0;
    for(int i = 0; i < 4; ++i)
    {
        if(m_Players[i] && [m_Players[i] IsActivated])
        {
            ++nRet; 
        }
    }
    return nRet;
}

-(void)ShutdownSection
{
    for(int i = 0; i < 4; ++i)
    {
        [m_Players[i] ClearPlayBet];
        [m_Players[i] Activate:NO];
    }
    [m_PlayingSpinner StopAnimation];
}

-(void) AbsoultShutDownOnlineGame
{
    
}

-(void)StartGameSection
{
//    m_PlayingSpinner.hidden = NO;
}

-(void)OpenOnlinePlayerPopupMenu:(int)nSeatID
{
    
}

@end
