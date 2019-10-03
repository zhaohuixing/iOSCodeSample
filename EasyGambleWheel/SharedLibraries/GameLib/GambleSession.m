//
//  GambleSession.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "GambleSession.h"
#import "GambleLobby.h"
#import "SoundSource.h"
#import "Configuration.h"

@implementation GambleSession

-(void)PlayCurrentGameStateSound
{
    switch(m_nGamePlayState)
    {
        case GAME_STATE_READY:
        case GAME_STATE_RESET:
        {    
            if([SoundSource IsPlayGameResultSound])
                [SoundSource StopGameResultSound];
            if([SoundSource IsPlayPointerSpinSound])
                [SoundSource StopPointerSpinSound];
            if(![SoundSource IsPlayWheelStaticSound])
                [SoundSource PlayWheelStaticSound];
            
            break;
        }
        case GAME_STATE_RUN:
        {
            if([SoundSource IsPlayWheelStaticSound])
                [SoundSource StopWheelStaticSound];
            if([SoundSource IsPlayGameResultSound])
                [SoundSource StopGameResultSound];
            if(![SoundSource IsPlayPointerSpinSound])
                [SoundSource PlayPointerSpinSound];
            break;
        }
        case GAME_STATE_RESULT:
        {
            if([SoundSource IsPlayWheelStaticSound])
                [SoundSource StopWheelStaticSound];
            if([SoundSource IsPlayPointerSpinSound])
                [SoundSource StopPointerSpinSound];
            if(![SoundSource IsPlayGameResultSound])
                [SoundSource PlayGameResultSound];
            break;
        }
    }
}

-(void)initLuck2Scopes
{
    for(int i = 0; i < 2; ++i)
    {
        int nStartAngle = i*180;
        int nEndAngle = nStartAngle + 180;
        m_Luck2Scopes[i] = [[CLuckScope alloc] initScope:nStartAngle withEnd:nEndAngle];
    }
}

-(void)initLuck4Scopes
{
    for(int i = 0; i < 4; ++i)
    {
        int nStartAngle = i*90;
        int nEndAngle = nStartAngle + 90;
        m_Luck4Scopes[i] = [[CLuckScope alloc] initScope:nStartAngle withEnd:nEndAngle];
    }
}

-(void)initLuck6Scopes
{
    for(int i = 0; i < 6; ++i)
    {
        int nStartAngle = i*60;
        int nEndAngle = nStartAngle + 60;
        m_Luck6Scopes[i] = [[CLuckScope alloc] initScope:nStartAngle withEnd:nEndAngle];
    }
}

-(void)initLuck8Scopes
{
    for(int i = 0; i < 8; ++i)
    {
        int nStartAngle = i*45;
        int nEndAngle = nStartAngle + 45;
        m_Luck8Scopes[i] = [[CLuckScope alloc] initScope:nStartAngle withEnd:nEndAngle];
    }
}

-(void)initScopes
{
    [self initLuck2Scopes];
    [self initLuck4Scopes];
    [self initLuck6Scopes];
    [self initLuck8Scopes];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self initScopes];
        m_nPosition = -1;
        m_nWinScopeIndex = -1;
        
        m_nGamePlayType = GAME_TYPE_8LUCK;
        m_nGamePlayState = GAME_STATE_READY;
        
        //This is temperoray variable for test
        m_nChips = 0;
    }
    return self;
}

-(void)dealloc
{
}

-(void)RegisterParent:(GambleLobby*)parent
{
    m_Parent = parent;
}

-(void)SetGameType:(int)nType
{
    m_nGamePlayType = nType;
}

-(int)GetGameType
{
    return m_nGamePlayType;
}

-(void)SetGameState:(int)nState
{
    BOOL bChange = (m_nGamePlayState != nState);
    m_nGamePlayState = nState;
    if(bChange && [Configuration canPlaySound])
    {
        [self PlayCurrentGameStateSound];
    }
}

-(int)GetGameState
{
    return m_nGamePlayState;
}

-(void)CalculateLuck2WinScope
{
    for(int i = 0; i < 2; ++i)
    {
        if([m_Luck2Scopes[i] InScope:m_nPosition])
        {
            m_nWinScopeIndex = i;
            return;
        }
    }
}

-(void)CalculateLuck4WinScope
{
    for(int i = 0; i < 4; ++i)
    {
        if([m_Luck4Scopes[i] InScope:m_nPosition])
        {
            m_nWinScopeIndex = i;
            return;
        }
    }
}

-(void)CalculateLuck6WinScope
{
    for(int i = 0; i < 6; ++i)
    {
        if([m_Luck6Scopes[i] InScope:m_nPosition])
        {
            m_nWinScopeIndex = i;
            return;
        }
    }
}

-(void)CalculateLuck8WinScope
{
    for(int i = 0; i < 8; ++i)
    {
        if([m_Luck8Scopes[i] InScope:m_nPosition])
        {
            m_nWinScopeIndex = i;
            return;
        }
    }
}


-(void)CalculateWinScope
{
    switch(m_nGamePlayType)
    {
        case GAME_TYPE_2LUCK:
            [self CalculateLuck2WinScope];
            break;
        case GAME_TYPE_4LUCK:
            [self CalculateLuck4WinScope];
            break;
        case GAME_TYPE_6LUCK:
            [self CalculateLuck6WinScope];
            break;
        case GAME_TYPE_8LUCK:
            [self CalculateLuck8WinScope];
            break;
    }
}

-(void)PointerStopAt:(int)nAngle
{
    m_nPosition = nAngle;
    [self CalculateWinScope];
}

-(int)GetPointerPosition
{
    return m_nPosition;
}

-(int)GetWinScopeIndex
{
    return m_nWinScopeIndex;
}

-(void)Reset
{
    m_nPosition = -1;
    m_nWinScopeIndex = -1;
}

- (int)GetMyCurrentMoney
{
    return m_nChips;
}

- (void)AddMoneyToMyAccount:(int)nChips
{
    m_nChips += nChips;
}


@end
