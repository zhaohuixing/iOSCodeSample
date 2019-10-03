//
//  GambleLobby.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-09-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameUtiltyObjects.h"
#import "GambleLobby.h"
#import "GamePlayer.h"
#import "GambleSession.h"
#import "BetIndicator.h"
#import"ChoiceDisplay.h"
#import "GambleLobbySeat.h"
#import "ActivePlayerAnimator.h"
#import "WinnerAnimator.h"
#import "GameConstants.h"
#import "GUILayout.h"
#import "ApplicationResource.h"
#import "ApplicationConfigure.h"
#import "GUIEventLoop.h"
#import "StringFactory.h"
#import "Configuration.h"
#import "ScoreRecord.h"
#import "SoundSource.h"
#import "CGameSectionManager.h"

@implementation GambleLobby

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_GambleWheel = [[CGambleWheel alloc] init];
        [m_GambleWheel RegisterDelegate:self];
        
        m_GameSession = [[GambleSession alloc] init];
        [m_GameSession RegisterParent:self];
    }
    return self;
}

-(void)dealloc
{
}

- (void)OnTimerEvent
{
    [m_GambleWheel OnTimerEvent];
}

- (void)Draw:(CGContextRef)context inRect:(CGRect)rect
{
    [m_GambleWheel Draw:context inRect:rect];
}

- (void)SpinGambleWheel:(CPinActionLevel*)action
{
    [ApplicationConfigure SetRedeemPlayerSeat:0];
    [m_GambleWheel StartSpin:action];
}

- (void)SetGameType:(int)nType theme:(int)themeType
{
    BOOL bNeedUpdate = ([m_GameSession GetGameType] != nType);
    [m_GameSession SetGameType:nType];
    [m_GambleWheel SetGameType:nType theme:themeType];
    if(bNeedUpdate)
    {
        [[CGameSectionManager GetGlobalGameUIDelegate] UpdateForGameTypeChange];
    }
}

-(int)GetGameType
{
    return [m_GameSession GetGameType];
}

-(void)SetGameState:(int)nState
{
    BOOL bNeedUpdate = ([m_GameSession GetGameState] != nState);
    [m_GameSession SetGameState:nState];
    if(bNeedUpdate)
    {
        [[CGameSectionManager GetGlobalGameUIDelegate] UpdateForGameStateChange];
    }
}



-(int)GetGameState
{
    return [m_GameSession GetGameState];
}

-(void)PointerStopAt:(int)nAngle
{
    [m_GameSession PointerStopAt:nAngle];
    
    //Debugcode
    int nPosition = [self GetPointerPosition];
    int nWinNumber = [self GetWinScopeIndex]+1;
    NSLog(@"Pointer angle:%i, Wining #:%i", nPosition, nWinNumber);
}

-(int)GetPointerPosition
{
    return [m_GameSession GetPointerPosition];
}

-(int)GetWinScopeIndex
{
    return [m_GameSession GetWinScopeIndex];
}

- (void)PauseGame
{
    [m_GambleWheel Stop];
}

- (void)ResumeGame
{
    if([Configuration canPlaySound])
    {
        [m_GameSession PlayCurrentGameStateSound];
    }    
}


@end
