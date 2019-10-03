//
//  ScoreRecord.m
//  ChuiNiu
//
//  Created by ZXing on 2010-08-10.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "ScoreRecord.h"
#import "Configuration.h"
#import "StringFactory.h"

static int		g_score[12];     
static int		g_point[12];     
static int		g_lastWinLevel = -1;
static int		g_lastWinSkill = -1;
static int		g_TotalScore = 0;
static BOOL     g_bShouldAchievement1Report = NO;
static BOOL     g_bShouldAchievement2Report = NO;
static BOOL     g_bShouldAchievement3Report = NO;
static BOOL     g_bShouldAchievement4Report = NO;
static BOOL     g_bDisableAWSService = NO;

@implementation ScoreRecord

+(int)getLastWinSkill
{
	return g_lastWinSkill;
}	

+(int)getLastWinLevel;
{
	return g_lastWinLevel;
}	

+(void)SaveLastWinSkill:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceLastWinSkillKey];	
	[prefs setInteger:g_lastWinSkill forKey:sKey];
}

+(void)SaveLastWinLevel:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceLastWinLevelKey];	
	[prefs setInteger:g_lastWinLevel forKey:sKey];
}


+(void)SaveSkill:(NSUserDefaults*)prefs
{
	int nSkill = [Configuration getGameSkill];
	
	NSString* sKey = [StringFactory GetString_PreferenceSkillKey];	
	[prefs setInteger:nSkill forKey:sKey];
}

+(void)SaveLevel:(NSUserDefaults*)prefs
{
	int nLevel = [Configuration getGameLevel];
	
	NSString* sKey = [StringFactory GetString_PreferenceLevelKey];	
	[prefs setInteger:nLevel forKey:sKey];
}

+(void)SaveSound:(NSUserDefaults*)prefs
{
	BOOL bEnable = [Configuration canPlaySound];
	
	NSString* sKey = [StringFactory GetString_PreferenceSoundKey];	
	[prefs setBool:bEnable forKey:sKey];
}

+(void)SaveBackground:(NSUserDefaults*)prefs
{
	//BOOL bEnable = [Configuration isPaperBackground];
	int nSetting = [Configuration getBackgroundSetting];
	NSString* sKey = [StringFactory GetString_PreferenceBackgroundKey];	
	[prefs setInteger:nSetting forKey:sKey];
}


+(void)SavePoint:(NSUserDefaults*)prefs atSkill:(int)nSkill atLevel:(int)nLevel
{
	int nPoint = [ScoreRecord getPoint:nSkill atLevel:nLevel];
	int k = nSkill*GAME_PLAY_LEVELS + nLevel;
	if(12 <= k)
		return;
	
	NSString* sKey = [StringFactory GetString_PreferencePointKey:k];	
	[prefs setInteger:nPoint forKey:sKey];
}

+(void)SaveScore:(NSUserDefaults*)prefs atSkill:(int)nSkill atLevel:(int)nLevel
{
	int nScore = [ScoreRecord getScore:nSkill atLevel:nLevel];
	int k = nSkill*GAME_PLAY_LEVELS + nLevel;
	if(12 <= k)
		return;
	
	NSString* sKey = [StringFactory GetString_PreferenceScoreKey:k];	
	[prefs setInteger:nScore forKey:sKey];
}


+(void)SaveThunderTheme:(NSUserDefaults*)prefs
{
	BOOL bEnable = [Configuration getThunderTheme];
	NSString* sKey = [StringFactory GetString_PreferenceThunderThemeKey];	
	[prefs setBool:bEnable forKey:sKey];
}

+(void)SaveClock:(NSUserDefaults*)prefs
{
	BOOL bEnable = ![Configuration isClockShown];
	NSString* sKey = [StringFactory GetString_PreferenceClockKey];	
	[prefs setBool:bEnable forKey:sKey];
}

+(void)SaveTotalScore:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceTotalScoreKey];	
	[prefs setInteger:g_TotalScore forKey:sKey];
}

+(void)SaveActievementReportState:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_Achievement1Key];
	[prefs setBool:g_bShouldAchievement1Report forKey:sKey];
	sKey = [StringFactory GetString_Achievement2Key];
	[prefs setBool:g_bShouldAchievement2Report forKey:sKey];
	sKey = [StringFactory GetString_Achievement3Key];
	[prefs setBool:g_bShouldAchievement3Report forKey:sKey];
	sKey = [StringFactory GetString_Achievement4Key];
	[prefs setBool:g_bShouldAchievement4Report forKey:sKey];
}



+(void)LoadLastWinSkill:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceLastWinSkillKey];	
	g_lastWinSkill = [prefs integerForKey:sKey];
}

+(void)LoadLastWinLevel:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceLastWinLevelKey];	
	g_lastWinLevel = [prefs integerForKey:sKey];
}

+(void)LoadSkill:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceSkillKey];	
	int nSkill = [prefs integerForKey:sKey];
	[Configuration setGameSkill:nSkill];
}

+(void)LoadLevel:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceLevelKey];	
	int nLevel = [prefs integerForKey:sKey];
	[Configuration setGameLevel:nLevel];
}

+(void)LoadSound:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceSoundKey];	
	BOOL bEnable = [prefs boolForKey:sKey];
	[Configuration setPlaySoundEffect:bEnable];
}

+(void)LoadBackground:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceBackgroundKey];	
	//BOOL bEnable = [prefs boolForKey:sKey];
	//[Configuration setPaperBackground:bEnable];
	int nSetting = [prefs integerForKey:sKey];
	[Configuration setBackgroundSetting:nSetting];
}

+(void)LoadThunderTheme:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceThunderThemeKey];	
	BOOL bEnable = [prefs boolForKey:sKey];
	[Configuration setThunderTheme:bEnable];
}

+(void)LoadClock:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceClockKey];	
	BOOL bEnable = [prefs boolForKey:sKey];
	[Configuration setClockShown:!bEnable];
}

+(void)LoadTotalScore:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_PreferenceTotalScoreKey];	
	g_TotalScore = [prefs integerForKey:sKey];
    if(g_TotalScore < 0)
        g_TotalScore = 0;
}


+(void)LoadPoint:(NSUserDefaults*)prefs atSkill:(int)nSkill atLevel:(int)nLevel
{
	int k = nSkill*GAME_PLAY_LEVELS + nLevel;
	if(12 <= k)
		return;
	
	NSString* sKey = [StringFactory GetString_PreferencePointKey:k];	
	
	int nPoint = [prefs integerForKey:sKey];
	if(nPoint <= 0)
	{
		nPoint = 0;
	}	
	g_point[k] = nPoint; 
}

+(void)LoadScore:(NSUserDefaults*)prefs atSkill:(int)nSkill atLevel:(int)nLevel
{
	int k = nSkill*GAME_PLAY_LEVELS + nLevel;
	if(12 <= k)
		return;
	
	NSString* sKey = [StringFactory GetString_PreferenceScoreKey:k];	
	int nScore = [prefs integerForKey:sKey];
	if(nScore <= 0)
	{
		nScore = 0;
	}	
	g_score[k] = nScore; 
}

+(void)LoadActievementReportState:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_Achievement1Key];
	g_bShouldAchievement1Report = [prefs boolForKey:sKey];
	sKey = [StringFactory GetString_Achievement2Key];
	g_bShouldAchievement2Report = [prefs boolForKey:sKey];
	sKey = [StringFactory GetString_Achievement3Key];
	g_bShouldAchievement3Report = [prefs boolForKey:sKey];
	sKey = [StringFactory GetString_Achievement4Key];
	g_bShouldAchievement4Report = [prefs boolForKey:sKey];
}


+(int)getScore:(int)nSkill atLevel:(int)nLevel
{
	int nRet = 0;
    
	for(int i = 0; i < GAME_SKILL_LEVELS; ++i)
	{
		for(int j = 0; j < GAME_PLAY_LEVELS; ++j)
		{
			if(i == nSkill && j == nLevel)
			{
				int k = nSkill*GAME_PLAY_LEVELS + nLevel;
				if(12 <= k)
					return nRet;
				nRet = g_score[k];
				break;
			}	
		}	
	}	
					
	return nRet;
}

+(int)getPoint:(int)nSkill atLevel:(int)nLevel
{
	int nRet = 0;
	
	for(int i = 0; i < GAME_SKILL_LEVELS; ++i)
	{
		for(int j = 0; j < GAME_PLAY_LEVELS; ++j)
		{
			if(i == nSkill && j == nLevel)
			{
				int k = nSkill*GAME_PLAY_LEVELS + nLevel;
				if(12 <= k)
					return nRet;
				nRet = g_point[k];
				break;
			}	
		}	
	}	
	
	return nRet;
}

+(void)handleAchivementReportStatus:(int)nSkill atLevel:(int)nLevel
{
    if(nSkill == GAME_SKILL_LEVEL_THREE && nLevel == GAME_PLAY_LEVEL_THREE)
    {
        g_bShouldAchievement1Report = YES;
    }
    else if(nSkill == GAME_SKILL_LEVEL_ONE && nLevel == GAME_PLAY_LEVEL_FOUR)
    {
        g_bShouldAchievement2Report = YES;
    }
    else if(nSkill == GAME_SKILL_LEVEL_TWO && nLevel == GAME_PLAY_LEVEL_FOUR)
    {
        g_bShouldAchievement3Report = YES;
    }
    else if(nSkill == GAME_SKILL_LEVEL_THREE && nLevel == GAME_PLAY_LEVEL_FOUR)
    {
        g_bShouldAchievement4Report = YES;
    }
}

+(void)addScore:(int)nSkill atLevel:(int)nLevel
{
	g_lastWinLevel = nLevel;
	g_lastWinSkill = nSkill;
	
	for(int i = 0; i < GAME_SKILL_LEVELS; ++i)
	{
		for(int j = 0; j < GAME_PLAY_LEVELS; ++j)
		{
			if(i == nSkill && j == nLevel)
			{
				int k = nSkill*GAME_PLAY_LEVELS + nLevel;
				if(12 <= k)
					return;
				g_score[k] = g_score[k]+1;
				if(GAME_MAXMUM_SCORE_NUMBER < g_score[k])
				{
					g_score[k] = 0;
					g_point[k] = g_point[k]+1;
				}	
                [ScoreRecord handleAchivementReportStatus:nSkill atLevel:nLevel];
				break;
			}	
		}	
	}	
}

+(void)setScore:(int)nScore atSkill:(int)nSkill atLevel:(int)nLevel
{
	for(int i = 0; i < GAME_SKILL_LEVELS; ++i)
	{
		for(int j = 0; j < GAME_PLAY_LEVELS; ++j)
		{
			if(i == nSkill && j == nLevel)
			{
				int k = nSkill*GAME_PLAY_LEVELS + nLevel;
				
				if(12 <= k)
					return;
				
				g_score[k] = nScore;
				if(GAME_MAXMUM_SCORE_NUMBER < g_score[k])
				{
					g_score[k] = 0;
					g_point[k] = g_point[k]+1;
				}	
				break;
			}	
		}	
	}	
}

+(void)setPoint:(int)nPoint atSkill:(int)nSkill atLevel:(int)nLevel
{
	for(int i = 0; i < GAME_SKILL_LEVELS; ++i)
	{
		for(int j = 0; j < GAME_PLAY_LEVELS; ++j)
		{
			if(i == nSkill && j == nLevel)
			{
				int k = nSkill*GAME_PLAY_LEVELS + nLevel;
				if(12 <= k)
					return;
				g_point[k] = nPoint;
			}	
		}	
	}	
}	


+(void)saveRecord
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	[ScoreRecord SaveLastWinSkill:prefs];
	[ScoreRecord SaveLastWinLevel:prefs];
	[ScoreRecord SaveSkill:prefs];
	[ScoreRecord SaveLevel:prefs];
	[ScoreRecord SaveSound:prefs];
	[ScoreRecord SaveBackground:prefs];
    [ScoreRecord SaveThunderTheme:prefs];
    [ScoreRecord SaveClock:prefs];
    [ScoreRecord SaveTotalScore:prefs];
    [ScoreRecord SaveActievementReportState:prefs];
    
	for(int i = 0; i < GAME_SKILL_LEVELS; ++i)
	{
		for(int j = 0; j < GAME_PLAY_LEVELS; ++j)
		{
			[ScoreRecord SavePoint:prefs atSkill:i atLevel:j];
			[ScoreRecord SaveScore:prefs atSkill:i atLevel:j];
		}	
	}	
    [prefs synchronize];
}

+(void)loadRecord
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[ScoreRecord LoadLastWinSkill:prefs];
	[ScoreRecord LoadLastWinLevel:prefs];
	[ScoreRecord LoadSkill:prefs];
	[ScoreRecord LoadLevel:prefs];
	[ScoreRecord LoadSound:prefs];
	[ScoreRecord LoadBackground:prefs];
	[ScoreRecord LoadThunderTheme:prefs];
	[ScoreRecord LoadClock:prefs];
    [ScoreRecord LoadTotalScore:prefs];
    [ScoreRecord LoadActievementReportState:prefs];
	for(int i = 0; i < GAME_SKILL_LEVELS; ++i)
	{
		for(int j = 0; j < GAME_PLAY_LEVELS; ++j)
		{
			[ScoreRecord LoadPoint:prefs atSkill:i atLevel:j];
			[ScoreRecord LoadScore:prefs atSkill:i atLevel:j];
		}	
	}	
}	

+(BOOL)CheckPaymentState
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	BOOL bPaid = [prefs boolForKey:[StringFactory GetString_PurchaseStateKey]];
    return bPaid;
}

+(void)SavePaidState
{
    BOOL bRet = YES;
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:bRet forKey:[StringFactory GetString_PurchaseStateKey]];
    [prefs synchronize];
}

+(void)addTotalWinScore:(int)nWinScore
{
    g_TotalScore += nWinScore;
}

+(void)reduceTotalWinScore:(int)nLostScore
{
    g_TotalScore -= nLostScore;
    if(g_TotalScore < 0)
        g_TotalScore = 0;
}

+(int)getTotalWinScore
{
    return g_TotalScore;
}

+(BOOL)shouldAchievement1Reported
{
    return g_bShouldAchievement1Report;
}

+(BOOL)shouldAchievement2Reported;
{
    return g_bShouldAchievement2Report;
}

+(BOOL)shouldAchievement3Reported
{
    return g_bShouldAchievement3Report;
}

+(BOOL)shouldAchievement4Reported
{
    return g_bShouldAchievement4Report;
}

+(void)resetAchievement1Reported
{
    g_bShouldAchievement1Report = NO;
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKey = [StringFactory GetString_Achievement1Key];
	[prefs setBool:g_bShouldAchievement1Report forKey:sKey];
}

+(void)resetAchievement2Reported
{
    g_bShouldAchievement2Report = NO;
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKey = [StringFactory GetString_Achievement2Key];
	[prefs setBool:g_bShouldAchievement2Report forKey:sKey];
}

+(void)resetAchievement3Reported
{
    g_bShouldAchievement3Report = NO;
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKey = [StringFactory GetString_Achievement3Key];
	[prefs setBool:g_bShouldAchievement3Report forKey:sKey];
}


+(void)resetAchievement4Reported;
{
    g_bShouldAchievement4Report = NO;
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKey = [StringFactory GetString_Achievement4Key];
	[prefs setBool:g_bShouldAchievement4Report forKey:sKey];
}

+(void)checkAWSServiceEnable
{
    g_bDisableAWSService = NO;
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	g_bDisableAWSService = [prefs boolForKey:[StringFactory GetString_AskAWSServiceEnableKey]];
}

+(void)setAWSServiceEnable:(BOOL)bEnable
{
    if(bEnable)
        g_bDisableAWSService = NO;
    else
        g_bDisableAWSService = YES;
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKey = [StringFactory GetString_AskAWSServiceEnableKey];
	[prefs setBool:g_bDisableAWSService forKey:sKey];
}

+(BOOL)isAWSServiceEnabled
{
    if(g_bDisableAWSService == NO)
        return YES;
    else
        return NO;
}

@end
