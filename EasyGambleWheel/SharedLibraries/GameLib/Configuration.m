//
//  Configuration.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-06.
//  Copyright 2010 xgadget. All rights reserved.
//
#import "Configuration.h"
#import "ApplicationConfigure.h"
#import "GameConstants.h"

static BOOL		m_bGameSoundEffect = NO;
static BOOL		m_bDirty = NO;
static int      m_nGameType = GAME_TYPE_8LUCK;
static BOOL		m_bRoPaAutoBet = YES;

static BOOL		m_bCacheOnlineMode = NO;
static BOOL		m_bGameOnline = NO;
static int      m_nPlayTurnType = GAME_PLAYTURN_TYPE_SEQUENCE;
static int      m_nCurrentTheme = GAME_THEME_KULO;

@implementation Configuration

+(BOOL)isDirty
{
    return m_bDirty;
}

+(void)resetDirty
{
    m_bDirty = NO;
}

+(void)setDirty
{
    m_bDirty = YES;
}

+(void)enablePlaySound
{
    if(m_bGameSoundEffect == NO)
        m_bDirty = YES;
    
	m_bGameSoundEffect = YES;
}	

+(void)disablePlaySound
{
    if(m_bGameSoundEffect == YES)
        m_bDirty = YES;
	m_bGameSoundEffect = NO;
}	

+(void)setPlaySoundEffect:(BOOL)enable
{
    if(m_bGameSoundEffect != enable)
        m_bDirty = YES;
    
	m_bGameSoundEffect = enable;
}	

+(BOOL)canPlaySound
{
	return m_bGameSoundEffect;
}	

+(BOOL)isOnline
{
    return m_bGameOnline;
}

+(void)setOnline:(BOOL)bOnline
{
    if(m_bGameOnline != bOnline)
        m_bDirty = YES;
    
    m_bGameOnline = bOnline;
}

+(int)getCurrentGameType
{
    return m_nGameType;
}

+(void)setCurrentGameType:(int)nType
{
    if(m_nGameType != nType)
        m_bDirty = YES;
        
    m_nGameType = nType;
}

+(BOOL)isRoPaAutoBet
{
    return m_bRoPaAutoBet;
}

+(void)setRoPaAutoBet:(BOOL)bAuto
{
    if(m_bRoPaAutoBet != bAuto)
        m_bDirty = YES;
    m_bRoPaAutoBet = bAuto;
}

+(void)cacheOnlineSetting
{
    m_bCacheOnlineMode = m_bGameOnline;
}

+(BOOL)isOnlineSettingChange
{
    BOOL bRet = (m_bCacheOnlineMode != m_bGameOnline);
    return bRet;
}

+(void)setPlayTurn:(int)nPlayTurnType
{
    if(m_nPlayTurnType != nPlayTurnType)
        m_bDirty = YES;
    m_nPlayTurnType = nPlayTurnType;
}

+(int)getPlayTurnType
{
    return m_nPlayTurnType;
}

+(BOOL)isPlayTurnBySequence
{
    return (m_nPlayTurnType == GAME_PLAYTURN_TYPE_SEQUENCE);
}

static int      m_GKGameCenterTry = 0;

+(void)AddGKGameCenterAccessTry
{
    ++m_GKGameCenterTry;
}

+(int)GetGKGameCenterAccessTry
{
    return m_GKGameCenterTry;
}

+(void)ClearGKGameCenterAccessTry
{
    m_GKGameCenterTry = 0;
}

+(int)getCurrentGameTheme
{
    return m_nCurrentTheme;
}

+(void)setCurrentGameTheme:(int)themeType
{
    m_bDirty = YES;
    m_nCurrentTheme = themeType;
}


@end
