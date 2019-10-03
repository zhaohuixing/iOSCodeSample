//
//  Configuration.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-06.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "Configuration.h"
#import "ApplicationConfigure.h"

static int		m_GameLevel = GAME_PLAY_LEVEL_ONE;
static int		m_GameSkill = GAME_SKILL_LEVEL_ONE;
static BOOL		m_bGameSoundEffect = YES;
static BOOL     m_bDirty = NO;
static BOOL     m_bShownClock = NO;
static int		m_Gamebackground = GAME_BACKGROUND_DEFAULT;
static BOOL     m_bThunderTheme = NO;
static int      m_nFlashAdDelayCount = 0;

@implementation Configuration

+(void)setThunderTheme:(BOOL)bYes
{
    m_bThunderTheme = bYes;
}

+(BOOL)getThunderTheme
{
    return m_bThunderTheme;
}

+(int)getBackgroundSetting
{
	return m_Gamebackground; 
}	

+(void)setBackgroundSetting:(int)setting
{
	if(GAME_BACKGROUND_DEFAULT <= setting && setting <= GAME_BACKGROUND_NIGHT)
	{
		m_Gamebackground = setting;
	}	
}

+(BOOL)isDirty
{
	return m_bDirty;
}

+(void)setDirty
{
	m_bDirty = YES;
}

+(void)clearDirty
{
	m_bDirty = NO;
}	

+(BOOL)isClockShown
{
	return m_bShownClock;
}

+(void)setClockShown:(BOOL)bShown
{
	m_bShownClock = bShown;
}	

+(CGPoint)GetDefaultPlayerBulletSpeed
{
	return CGPointMake(GAME_DEFAULT_PLAYER_BULLET_SPEED_X, GAME_DEFAULT_PLAYER_BULLET_SPEED_Y);
}

+(BOOL)canTargetShoot
{
	BOOL bRet = NO;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_FOUR || m_GameLevel == GAME_PLAY_LEVEL_THREE)
		bRet = YES;
	
	return bRet;
}	

+(BOOL)canKnockDownTarget
{
	BOOL bRet = YES;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_ONE)
		bRet = NO;
	
	return bRet;
}

+(BOOL)canPlayerJump
{
	BOOL bRet = NO;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_FOUR)
		bRet = YES;
	
	return bRet;
}	

+(BOOL)canShootBlock
{
	return [Configuration canPlayerJump];
}

+(BOOL)canTargetBlast
{
	BOOL bRet = NO;
	
	if(m_GameLevel != GAME_PLAY_LEVEL_ONE)
		bRet = YES;
	
	return bRet;
}	

+(BOOL)canAlienShaking
{
	BOOL bRet = NO;
	
    //???????
    //???????
    //???????
	//if(m_GameLevel != GAME_PLAY_LEVEL_ONE)
	//	bRet = YES;
    //???????
    //???????
    //???????
	
	return bRet;
}	

+(BOOL)isPaperBackground
{
	return (m_Gamebackground == GAME_BACKGROUND_CHECKER);//m_bPaperbackground;
}	

+(void)setPaperBackground:(BOOL)bYesNo
{
	//m_bPaperbackground = bYesNo;
}	


+(void)enablePlaySound
{
	m_bGameSoundEffect = YES;
}	

+(void)disablePlaySound
{
	m_bGameSoundEffect = NO;
}	

+(void)setPlaySoundEffect:(BOOL)enable
{
	m_bGameSoundEffect = enable;
}	

+(BOOL)canPlaySound
{
	return m_bGameSoundEffect;
}	

+(void)setGameLevel:(int)nLevel
{
	if(GAME_PLAY_LEVEL_ONE <= nLevel && nLevel <= GAME_PLAY_LEVEL_FOUR)
	{
        if(m_GameLevel != nLevel)
            [Configuration setDirty];
        
		m_GameLevel = nLevel;
		//[Configuration setGameLevelFour];
	}	
}

+(void)setGameLevelOne
{
    if(m_GameLevel != GAME_PLAY_LEVEL_ONE)
        [Configuration setDirty];
    
	m_GameLevel = GAME_PLAY_LEVEL_ONE;
	//[Configuration setGameLevelFour];
}

+(void)setGameLevelTwo
{
    if(m_GameLevel != GAME_PLAY_LEVEL_TWO)
        [Configuration setDirty];
    
	m_GameLevel = GAME_PLAY_LEVEL_TWO;
	//[Configuration setGameLevelFour];
}

+(void)setGameLevelThree
{
    if(m_GameLevel != GAME_PLAY_LEVEL_THREE)
        [Configuration setDirty];
    
	m_GameLevel = GAME_PLAY_LEVEL_THREE;
	//[Configuration setGameLevelFour];
}

+(void)setGameLevelFour
{
    if(m_GameLevel != GAME_PLAY_LEVEL_FOUR)
        [Configuration setDirty];
	
    m_GameLevel = GAME_PLAY_LEVEL_FOUR;
}

+(int)getGameLevel
{
	return m_GameLevel;
}	

+(BOOL)isGameLevelOne
{
	BOOL bRet = NO;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_ONE)
		bRet = YES;
	
	return bRet;
}

+(BOOL)isGameLevelTwo
{
	BOOL bRet = NO;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_TWO)
		bRet = YES;
	
	return bRet;
}

+(BOOL)isGameLevelThree
{
	BOOL bRet = NO;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_THREE)
		bRet = YES;
	
	return bRet;
}

+(BOOL)isGameLevelFour
{
	BOOL bRet = NO;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_FOUR)
		bRet = YES;
	
	return bRet;
}

+(BOOL)canBirdFly
{
	BOOL bRet = YES;//NO;
	
	//if(m_GameLevel == GAME_PLAY_LEVEL_FOUR || m_GameLevel == GAME_PLAY_LEVEL_THREE 
    //   || m_GameLevel == GAME_PLAY_LEVEL_TWO)
	//	bRet = YES;
	
	return bRet;
}

+(BOOL)canBirdShoot
{
	BOOL bRet = NO;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_FOUR || (m_GameLevel == GAME_PLAY_LEVEL_THREE && m_GameSkill != GAME_SKILL_LEVEL_ONE))
		bRet = YES;
	
	return bRet;
}

+(void)setGameSkill:(int)nSkill
{
	if(GAME_SKILL_LEVEL_ONE <= nSkill && nSkill <= GAME_SKILL_LEVEL_THREE) 
	{	
        if(m_GameSkill != nSkill)
            [Configuration setDirty];
		m_GameSkill = nSkill;
		//[Configuration setGameSkillTwo];
	}	
}

+(void)setGameSkillOne
{
    if(m_GameSkill != GAME_SKILL_LEVEL_ONE)
        [Configuration setDirty];
	m_GameSkill = GAME_SKILL_LEVEL_ONE;
}

+(void)setGameSkillTwo
{
    if(m_GameSkill != GAME_SKILL_LEVEL_TWO)
        [Configuration setDirty];
	m_GameSkill = GAME_SKILL_LEVEL_TWO;
}	

+(void)setGameSkillThree
{
    if(m_GameSkill != GAME_SKILL_LEVEL_THREE)
        [Configuration setDirty];
    
	m_GameSkill = GAME_SKILL_LEVEL_THREE;
}

+(int)getGameSkill
{
	return m_GameSkill;
}

+(BOOL)isGameSkillOne
{
	BOOL bRet = NO;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_ONE)
		bRet = YES;
	
	return bRet;
}

+(BOOL)isGameSkillTwo
{
	BOOL bRet = NO;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		bRet = YES;
	
	return bRet;
}

+(BOOL)isGameSkillThree
{
	BOOL bRet = NO;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		bRet = YES;
	
	return bRet;
}	


//
//The target limit incremental
//
#define			GAME_HITLIMIT_INCREMENTAL_SKILLONE				0
#define			GAME_HITLIMIT_INCREMENTAL_SKILLTWO				-3
#define			GAME_HITLIMIT_INCREMENTAL_SKILLTHREE			-4
+(int)getTargetIncrementalBySkill
{
	int nRet = 0;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_ONE)
		nRet = GAME_HITLIMIT_INCREMENTAL_SKILLONE;
	else if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		nRet = GAME_HITLIMIT_INCREMENTAL_SKILLTWO;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		nRet = GAME_HITLIMIT_INCREMENTAL_SKILLTHREE;
	
	return nRet;
}

+(int)getTargetHitLimit
{
	int nRet = [Configuration getDefaultTargetHitLimit]+[Configuration getTargetIncrementalBySkill];
	return nRet;
}	

//
//The target hit deductable incremental
//
#define			GAME_HIT_DEDUCTABLE_SKILLONE				0
#define			GAME_HIT_DEDUCTABLE_SKILLTWO				0
#define			GAME_HIT_DEDUCTABLE_SKILLTHREE				2
+(int)getTargetHitDeductableBySkill
{
	int nRet = 0;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_ONE)
		nRet = GAME_HIT_DEDUCTABLE_SKILLONE;
	else if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		nRet = GAME_HIT_DEDUCTABLE_SKILLTWO;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		nRet = GAME_HIT_DEDUCTABLE_SKILLTHREE;
	
	return nRet;
}

+(int)getTargetHitDeductable
{
	int nRet = GAME_DEFAULT_TARGET_HIT_DEDUCABLE + [Configuration getTargetHitDeductableBySkill];
	return nRet;
}	

//
//Player timer parameters
//
#define			GAME_TIMER_INCREMENTAL_LEVELONE				0
#define			GAME_TIMER_INCREMENTAL_LEVELTWO				500
#define			GAME_TIMER_INCREMENTAL_LEVELTHREE			1000
#define			GAME_TIMER_INCREMENTAL_LEVELFOUR			1500
+(int)getGameTimeIncrementalByLevel
{
	int nRet = 0;
	
	if(m_GameLevel == GAME_PLAY_LEVEL_ONE)
		nRet = GAME_TIMER_INCREMENTAL_LEVELONE;
	else if(m_GameLevel == GAME_PLAY_LEVEL_TWO)
		nRet = GAME_TIMER_INCREMENTAL_LEVELTWO;
	else if(m_GameLevel == GAME_PLAY_LEVEL_THREE)
		nRet = GAME_TIMER_INCREMENTAL_LEVELTHREE;
	else if(m_GameLevel == GAME_PLAY_LEVEL_FOUR)
		nRet = GAME_TIMER_INCREMENTAL_LEVELFOUR;
	
	return nRet;
}

#define			GAME_TIMER_INCREMENTAL_SKILLONE				0
#define			GAME_TIMER_INCREMENTAL_SKILLTWO				1500
#define			GAME_TIMER_INCREMENTAL_SKILLTHREE			3000
+(int)getGameTimeIncrementalBySkill
{
	int nRet = 0;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_ONE)
		nRet = GAME_TIMER_INCREMENTAL_SKILLONE;
	else if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		nRet = GAME_TIMER_INCREMENTAL_SKILLTWO;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		nRet = GAME_TIMER_INCREMENTAL_SKILLTHREE;
	
	return nRet;
}

+(int)getGameTime
{
	int nRet = [Configuration getGameTimerClickThreshold] + [Configuration getGameTimeIncrementalByLevel] + [Configuration getGameTimeIncrementalBySkill]; 
    if([ApplicationConfigure iPADDevice])
        nRet = (int)(((float)nRet)/3.0);
	return nRet;
}


+(int)getBulletTimerElapse
{
	int nRet = GAME_TIMER_DEFAULT_BULLET_STEP;
	int nFactor = 1;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_ONE)
	{	
		if([ApplicationConfigure iPADDevice])
			nFactor = 2;
	}	
	else if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
	{	
		if([ApplicationConfigure iPADDevice])
			nFactor = 2;
		else
			nFactor = 4;
	}	
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
	{
		if([ApplicationConfigure iPADDevice])
			nFactor = 8;
		else
			nFactor = 4;
	}
	
	nRet = (int)(((float)nRet)/((float)nFactor));
	
	
	return nRet;
}	

+(int)getDefaultTargetHitLimit
{
	return GAME_DEFAULT_TARGET_HIT_THRESHED;
}	

+(int) getGameTimerClickThreshold
{
	return GAME_TIMER_GAME_TIME;
}


+(CGPoint)getTargetBulletSpeed
{
	CGPoint pt = CGPointMake(GAME_DEFAULT_TARGET_BULLET_SPEED_X, GAME_DEFAULT_TARGET_BULLET_SPEED_Y);
	
	float fFactor = 1.0;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_ONE)
	{
		if([ApplicationConfigure iPADDevice])
			fFactor = 1.2;
	}	
	else if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
	{	
		if([ApplicationConfigure iPhoneDevice])
			fFactor = 1.2;
		else
			fFactor = 1.6;
	}	
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
	{	
		if([ApplicationConfigure iPhoneDevice])
			fFactor = 1.4;
		else
			fFactor = 2.0;
	}
	
	
	float fSign = 1.0;
	int nr = getRandNumber();
	int n = nr%3;
	if(n == 0)
		fSign = 0.0;
	else if(n == 1)
		fSign = -1.0;
	
	float fRatio = ((float)(nr%4+1))/4.0;
	pt.x = pt.x*fSign*fRatio/fFactor;
	pt.y = pt.y/fFactor;
	
	return pt;
}	

+(int)getTargetTimerStep
{
	int nRet = GAME_TIMER_TARGET_STEP;
	float nFactor = 1;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_ONE)
	{
		if([ApplicationConfigure iPADDevice])
			nFactor = 1.2;
	}	
	else if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
	{
		if([ApplicationConfigure iPADDevice])
			nFactor = 1.5;
		else 
			nFactor = 1.2;
	}	
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
	{	
		if([ApplicationConfigure iPADDevice])
			nFactor = 2;
		else 
			nFactor = 1.5;
	}
	
	nRet = (int)(((float)nRet)/((float)nFactor));
	
	return nRet;
}	

+(int)getTargetAnimationDelayThreshold
{
	int nRet = 0;

	
	if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		nRet = 2;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		nRet = 4;

	if([ApplicationConfigure iPADDevice])
		nRet /= 2;
	
    
	return nRet;
}	

+(float)getTargetSpeedY
{
	float fRet = GAME_DEFAULT_TARGET_SPEED_Y;
	//fRet *= 2.0;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
	{
		fRet *= 1.5;
	}	
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
	{
		fRet *= 2.0;
	}
	if(m_GameLevel == GAME_PLAY_LEVEL_TWO)
	{
		fRet *= 1.5;
	}	
	else if(m_GameLevel == GAME_PLAY_LEVEL_THREE)
	{
		fRet *= 2.0;
	}	
	if(m_GameLevel == GAME_PLAY_LEVEL_FOUR)
	{
		fRet *= 3.0;
	}	
	return fRet;
}	

+(int)getAlienTimerElapse
{
	int nRet = GAME_TIMER_DEFAULT_ALIEN_STEP;
	int nFactor = 1;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		nFactor = 3;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		nFactor = 6;
	
	if([ApplicationConfigure iPADDevice])
		nFactor *= 2;
	
	nRet = (int)(((float)nRet)/((float)nFactor));
	
	return nRet;
}

+(int)getAlienShootThreshold
{
	int nRet = GAME_DEFAULT_ALIEN_SHOOT_THRESHED;
	if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		nRet = GAME_DEFAULT_ALIEN_SHOOT_THRESHED/2;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		nRet = GAME_DEFAULT_ALIEN_SHOOT_THRESHED/4;

	if(m_GameLevel == GAME_PLAY_LEVEL_TWO)
	{
		nRet -= 4;
	}	
	else if(m_GameLevel == GAME_PLAY_LEVEL_THREE)
	{
		nRet -= 8;
	}	
	if(m_GameLevel == GAME_PLAY_LEVEL_FOUR)
	{
		nRet -= 12;
	}	
    if(nRet <= 0)
        nRet = 0;
	
    if(1 < nRet)
    {    
        int n = getRandNumber();
        nRet = n%nRet + 2;
	}
    
	return nRet;
}	

+(int)getBlockageTimerElapse
{
	int nRet = GAME_TIMER_DEFAULT_BLOCK_STEP;
	if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		nRet = 6*nRet/8;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		nRet = nRet/2;
	
	if([ApplicationConfigure iPADDevice])
		nRet /= 2;
	
	return nRet;
}	

+(int)getBlockageShootThreshold
{
	int nRet = GAME_DEFAULT_BLOCK_SHOOT_THRESHED;
	float fTemp = GAME_DEFAULT_BLOCK_SHOOT_THRESHED;  
	if([ApplicationConfigure iPADDevice])
		fTemp *= 0.3;
	
	if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		fTemp = fTemp*0.6;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		fTemp *= 0.4;
	
	nRet = (int)fTemp;
	
	return nRet;
}	

+(CGPoint)getBlockageSpeed
{
	CGPoint pt = CGPointMake(GAME_DEFAULT_BLOCK_SPEED_X, GAME_DEFAULT_BLOCK_SPEED_Y);
	
	if(m_GameSkill == GAME_SKILL_LEVEL_TWO)
		pt.x += 4;
	else if(m_GameSkill == GAME_SKILL_LEVEL_THREE)
		pt.x += 6;
	
	if([ApplicationConfigure iPADDevice])
		pt.x *= 2.0;
	
	return pt;
}	

+(int) CalculateRainBowPlayTime
{
	int nRet = 0;
	float fRainbowWidth = [CGameLayout GetRainBowWidth];//getRainBowWidth();
	float fSceneWidth = [CGameLayout GetGameSceneWidth];//getGameSceneWidth();
	float fSpeed = [CGameLayout GetRainBowSpeed];
	float fMovement = (fRainbowWidth+fSceneWidth)*0.5;
	float fTiming = fMovement/fSpeed;
	int nStep = [CGameLayout GetRainBowTimerStep];
	
	nRet =(int)(((float)nStep)*fTiming);
	return nRet;
}	

+(int)getRainRowStartTime
{
	int nTime = [Configuration getGameTime];
	int nRBTime = [Configuration CalculateRainBowPlayTime];//getRainBowPlayTime();
	int nRet = nTime - nRBTime;
	return nRet;
}

+(float)getRandomCloudWidth:(int)nRand
{
	float fRet = GAME_DEFAULT_ALIEN_SIZE_WIDTH;
	static float fRatioiPad[6] = {1.5, 1.2, 1.1, 1.0, 0.9, 0.6};
	static float fRatioiPhone[6] = {1.4, 1.2, 1.0, 0.9, 0.8, 0.6};
	
	if(0 <= nRand && nRand < 6)
	{
		if([ApplicationConfigure iPADDevice])
			fRet *= fRatioiPad[nRand];
		else
			fRet *= fRatioiPhone[nRand];
	}
	
	return fRet;
}	

+(float)getRandomCloudHeight:(int)nRand
{
	float fRet = GAME_DEFAULT_ALIEN_SIZE_HEIGHT;
    
    if([Configuration getThunderTheme] == YES)
    {
        return [Configuration getRandomCloudWidth:nRand];
    }
    
	static float fRatioiPad[5] = {1.6, 1.4, 1.0, 0.8, 0.6};
	static float fRatioiPhone[5] = {1.3, 1.2, 1.0, 0.8, 0.6};
	
	if(0 <= nRand && nRand < 5)
	{	
		if([ApplicationConfigure iPADDevice])
			fRet *= fRatioiPad[nRand];
		else
			fRet *= fRatioiPhone[nRand];
	}	
	
	return fRet;
}

static float m_WinningScore[3][4] =
{
    {1, 2, 3, 6},
    {2, 3, 6, 10},
    {3, 4, 10, 20},
};


+(int)getGameWinScore:(int)nSkill inLevel:(int)nLevel
{
    int nRet = -1;
    
    if(0 <= nSkill && nSkill <= 2 && 0 <= nLevel && nLevel <= 3)
    {
        nRet = m_WinningScore[nSkill][nLevel];
    }
    
    return nRet;
}

static float m_PLayThesholdScore[3][4] =
{
    {0, 6, 23, 42},
    {1, 16, 26, 48},
    {3, 19, 32, 58},
};

+(int)getGamePLayThesholdScore:(int)nSkill inLevel:(int)nLevel
{
    int nRet = -1;

    if(0 <= nSkill && nSkill <= 2 && 0 <= nLevel && nLevel <= 3)
    {
        nRet = m_PLayThesholdScore[nSkill][nLevel];
    }
    
    return nRet;
}

static float m_LostPenalityScore[3][4] =
{
    {80, 9, 6, 3},
    {40, 8, 5, 2},
    {20, 7, 4, 1},
};

+(int)getGameLostPenalityScore:(int)nSkill inLevel:(int)nLevel
{
    int nRet = -1;

    if(0 <= nSkill && nSkill <= 2 && 0 <= nLevel && nLevel <= 3)
    {
        nRet = m_LostPenalityScore[nSkill][nLevel];
    }
    
    return nRet;
}

+(int)getCanGamePlaySkillAtScore:(int)nScore
{
    int nSkill = 0;
    int nValue = -1;
    BOOL bSmall = YES;
    
    for(int nLevelIndex = 0; nLevelIndex <= 3; ++nLevelIndex)
    {
        for(int nSkillIndex = 0; nSkillIndex <= 2; ++nSkillIndex)
        {
            nSkill = nSkillIndex;
            nValue = m_PLayThesholdScore[nSkillIndex][nLevelIndex];
            if(nValue < nScore)
            {
                bSmall = NO;
            }
            else if(nValue == nScore)
            {
                return nSkill;
            }
            else
            {
                if(bSmall == NO)
                {
                    nSkill = nSkillIndex-1;
                    if(nSkill < 0)
                        nSkill = 0;
                    return nSkill;
                }
            }
        }
    }
    if(GAME_SKILL_LEVEL_THREE < nSkill)
        nSkill = GAME_SKILL_LEVEL_THREE;
    
    
    return nSkill;
}

+(int)getCanGamePlayLevelAtScore:(int)nScore
{
    int nLevel = 0;
    int nValue = -1;
    BOOL bSmall = NO;
    
    for(int nLevelIndex = 0; nLevelIndex <= 3; ++nLevelIndex)
    {
        for(int nSkillIndex = 0; nSkillIndex <= 2; ++nSkillIndex)
        {
            nLevel = nLevelIndex;
            nValue = m_PLayThesholdScore[nSkillIndex][nLevelIndex];
            if(nValue < nScore)
            {
                bSmall = NO;
            }
            else if(nValue == nScore)
            {
                return nLevel;
            }
            else
            {
                if(bSmall == NO)
                {
                    return nLevel;
                }
            }
        }
    }
    if(GAME_PLAY_LEVEL_FOUR < nLevel)
        nLevel = GAME_PLAY_LEVEL_FOUR;
    
    
    return nLevel;
}

+(float)getBirdFlyingRatio
{
    float rval = (float)(([Configuration getGameSkill]+1)*([Configuration getGameLevel]+1));
    float rAll = (float)(GAME_PLAY_LEVELS*GAME_SKILL_LEVELS);
    float fRet = rval/rAll;
    return fRet;
}

+(int)getBirdFlyingThreshold
{
	if(m_GameLevel == GAME_PLAY_LEVEL_ONE)
        return 4;
    return 3;
}

+(int)getBirdFlyingAcceleration
{
    return (m_GameLevel + 2);
}

+(void)AddFlashAddDelayCount
{
    ++m_nFlashAdDelayCount;
}

#define FLASHAD_DELAY_LIMIT    6

+(BOOL)CanPlayFlashAddNow
{
    BOOL bRet = (FLASHAD_DELAY_LIMIT <= m_nFlashAdDelayCount);
    return bRet;
}

+(void)CleanFlashAddDelayCount
{
    m_nFlashAdDelayCount = 0;
}

+(int)GetGameSettingIndex:(int)nSkill witLevel:(int)nLevel
{
    int nIndex = nSkill*GAME_PLAY_LEVELS + nLevel;
    return nIndex;
}
+(int)GetGameSkillFromSettingIndex:(int)nIndex
{
    if(nIndex < 0 || 12 <= nIndex)
        return 0;
    
    int nLevel = nIndex%GAME_PLAY_LEVELS;
    int nSkill = (int)((nIndex - nLevel)/GAME_PLAY_LEVELS);
    return nSkill;
}

+(int)GetGameLevelFromSettingIndex:(int)nIndex
{
    if(nIndex < 0 || 12 <= nIndex)
        return 0;

    int nLevel = nIndex%GAME_PLAY_LEVELS;
    return nLevel;
}

static BOOL     m_bUseFacialGesture = YES;
+(void)setUseFacialGesture:(BOOL)bMouth
{
    m_bUseFacialGesture = bMouth;
}

+(BOOL)isUseFacialGesture
{
    return m_bUseFacialGesture;
}

@end
