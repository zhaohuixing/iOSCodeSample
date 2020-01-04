//
//  GameScore.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-05-11.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "GameScore.h"
#import "StringFactory.h"
#import "ApplicationConfigure.h"
#include "GameState.h"

#define PRODUCT_FREE			0
#define	PRODUCT_PAID			1

@implementation GameScore
@synthesize			m_bPaid;

-(id)init
{
	if((self = [super init]))
	{
		m_Scores = [[NSMutableArray array] retain];
		if([ApplicationConfigure GetAdViewsState] == NO)
            m_bPaid = PRODUCT_PAID;
        else
            m_bPaid = PRODUCT_FREE;
            
	}	
	
	return self;
}	

- (void)dealloc 
{
	[m_Scores release];
    [super dealloc];
}

- (void)CreateScoreRecord:(int)nPoint withSpeed:(int)nSpeed
{
	ScoreRecord* score = [[ScoreRecord alloc] initRecord:nPoint withSpeed:nSpeed];
	[m_Scores addObject:score];
}	

- (int)GetScoreCount
{
	int nRet = [m_Scores count];
	return nRet;
}	

- (int)CheckScoreRecord:(int)nPoint
{
	int nRet = -1;
	
	for (int i = 0; i < [m_Scores count]; ++i)
	{
		if([(ScoreRecord*)[m_Scores objectAtIndex:i] GetPoint] == nPoint)
		{
			nRet = i;
		}	
	}	
	
	return nRet;
}

- (int)GetActivePointScoreIndex
{
	int nPoint = GetGamePoint();
	int nRet = [self CheckScoreRecord:nPoint];
	return nRet;
}	

- (void)AddScore:(int)nPoint withSpeed:(int)nSpeed withScore:(double)dScore
{
	int nRet = -1;
	
	for (int i = 0; i < [m_Scores count]; ++i)
	{
		if([(ScoreRecord*)[m_Scores objectAtIndex:i] GetPoint] == nPoint && [(ScoreRecord*)[m_Scores objectAtIndex:i] GetSpeed] == nSpeed)
		{
			[(ScoreRecord*)[m_Scores objectAtIndex:i] AddScore:dScore];
			nRet = nPoint;
			return;
		}	
	}	
	
	if(nRet == -1)
	{
		ScoreRecord* score = [[ScoreRecord alloc] initRecord:nPoint withSpeed:nSpeed];
		[score AddScore:dScore];
		[m_Scores addObject:score];
	}	
}

- (void)Reset
{
	[m_Scores removeAllObjects];
}

-(void)LoadGamePoint:(NSUserDefaults*)prefs writePoint:(BOOL)bSetGamePoint
{
	NSString* sKey = [StringFactory GetString_GamePointKey];	
	int nPoint = [prefs integerForKey:sKey];
	if(0 < nPoint && bSetGamePoint == YES)
	{	
		SetGamePoint(nPoint);
	}	
}

-(void)LoadGameSpeed:(NSUserDefaults*)prefs writePoint:(BOOL)bSetGamePoint
{
	NSString* sKey = [StringFactory GetString_GameSpeedKey];	
	int nSpeed = [prefs integerForKey:sKey];
	if(0 <= nSpeed && bSetGamePoint == YES)
	{	
		SetGameSpeed(nSpeed);
	}	
}


-(void)LoadGameBackground:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_GameBackgroundKey];	
	int nBkgnd = [prefs integerForKey:sKey];
    SetGameBackground(nBkgnd);
}


-(void)LoadScore:(NSUserDefaults*)prefs withIndex:(int)index
{
	ScoreRecord* score = [[ScoreRecord alloc] initRecord:0 withSpeed:0];
	[score LoadScore:prefs scoreIndex:index];
	[m_Scores addObject:score];
}	

-(void)LoadGameScores:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_ScoreNumberKey];	
	int nCount = [prefs integerForKey:sKey];
	if(0 < nCount)
	{	
		for(int i = 0; i < nCount; ++i)
		{
			[self LoadScore:prefs withIndex:i];
		}	
	}	
}

- (void)LoadPaymentState
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	m_bPaid = 0;
	m_bPaid = [prefs integerForKey:[StringFactory GetString_PurchaseStateKey]];
}

- (void)LoadScoresFromPreference:(BOOL)bSetGamePoint
{
	[m_Scores removeAllObjects];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	m_bPaid = 0;
	m_bPaid = [prefs integerForKey:[StringFactory GetString_PurchaseStateKey]];
	[self LoadGamePoint:prefs writePoint:bSetGamePoint];
	[self LoadGameSpeed:prefs writePoint:YES];
	[self LoadGameBackground: prefs];
    [self LoadGameScores:prefs];
}

-(void)SaveGamePoint:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_GamePointKey];	
	int nPoint = GetGamePoint();
	if(nPoint < 0)
		nPoint = GetGameDefaultPoint();
	
	[prefs setInteger:nPoint forKey:sKey];
}

-(void)SaveGameScores:(NSUserDefaults*)prefs
{
	int nCount = [m_Scores count];
	
	if(0 < nCount)
	{	
		NSString* sKey = [StringFactory GetString_ScoreNumberKey];	
		[prefs setInteger:nCount forKey:sKey];
		for(int i = 0; i < nCount; ++i)
		{
			[(ScoreRecord*)[m_Scores objectAtIndex:i] SaveScore:prefs scoreIndex:i];
		}	
	}
}	

-(void)SaveGameBackground:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_GameBackgroundKey];	
	int nBkgnd = GetGameBackground();
	if(nBkgnd < 0)
		nBkgnd = 0;
	
	[prefs setInteger:nBkgnd forKey:sKey];
}

-(void)SaveGamePoints
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self SaveGamePoint:prefs];
}

-(void)SaveGameSpeed
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKey = [StringFactory GetString_GameSpeedKey];	
	int nSpeed = GetGameSpeed();
	if(nSpeed < 0)
		nSpeed = 0;
	
	[prefs setInteger:nSpeed forKey:sKey];
}

-(void)SaveBackground
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self SaveGameBackground:prefs];
}

-(void)SavePaymentState
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:m_bPaid forKey:[StringFactory GetString_PurchaseStateKey]];
}

- (void)SaveScoresToPreference
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[prefs setInteger:m_bPaid forKey:[StringFactory GetString_PurchaseStateKey]];
	
	[self SaveGamePoint:prefs];
	[self SaveGameBackground:prefs];
    [self SaveGameScores:prefs];
}	

- (ScoreRecord*)GetScoreRecord:(int)index
{
	ScoreRecord* score = nil;

	if(0 <= index && index < [m_Scores count])
	{
		score = (ScoreRecord*)[m_Scores objectAtIndex:index];
	}	
	
	return score;
}

- (ScoreRecord*)GetScoreRecordByPoint:(int)nPoint
{
	ScoreRecord* score = nil;
    
	for (int i = 0; i < [m_Scores count]; ++i)
	{
		if([(ScoreRecord*)[m_Scores objectAtIndex:i] GetPoint] == nPoint)
		{
            score = (ScoreRecord*)[m_Scores objectAtIndex:i]; 
			return score;
		}	
	}	
	
	return score;
    
}

- (ScoreRecord*)GetNonActivePointScoreRecord:(int)index
{
	ScoreRecord* score = nil;

	int nActiveIndex = [self GetActivePointScoreIndex];

	
	if(0 <= index && index < [m_Scores count] && index != nActiveIndex)
	{
		score = (ScoreRecord*)[m_Scores objectAtIndex:index];
	}	
	
	return score;
}	

+(BOOL)CheckPaymentState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    [scores LoadScoresFromPreference:NO];
    if(scores.m_bPaid == PRODUCT_PAID)
    {    
        return YES;
    }    
    else
    {    
        return NO;
    }
}

+(void)SavePaidState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    scores.m_bPaid = PRODUCT_PAID;
    [scores SavePaymentState];
}

+(int)GetSNPostYear
{
    int nRet = -1;
	NSString* sKey = @"PANDACARD_SN_POST_REWARD_YEAR";	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	nRet = [prefs integerForKey:sKey];
	if(nRet <= 0)
	{
		nRet = -1;
	}	
    
    return nRet;
}

+(int)GetSNPostMonth
{
    int nRet = -1;
	NSString* sKey = @"PANDACARD_SN_POST_REWARD_MONTH";	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	nRet = [prefs integerForKey:sKey];
	if(nRet <= 0)
	{
		nRet = -1;
	}	
    
    return nRet;
}

+(int)GetSNPostDay
{
    int nRet = -1;
	NSString* sKey = @"PANDACARD_SN_POST_REWARD_DAY";	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	nRet = [prefs integerForKey:sKey];
	if(nRet <= 0)
	{
		nRet = -1;
	}	
    
    return nRet;
}

+(void)SetSNPostTime:(int)nDay withMonth:(int)nMonth withYear:(int)nYear
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKeyYear = @"PANDACARD_SN_POST_REWARD_YEAR";	
	NSString* sKeyMonth = @"PANDACARD_SN_POST_REWARD_MONTH";	
	NSString* sKeyDay = @"PANDACARD_SN_POST_REWARD_DAY";	
	[prefs setInteger:nDay forKey:sKeyDay];
	[prefs setInteger:nMonth forKey:sKeyMonth];
	[prefs setInteger:nYear forKey:sKeyYear];
}

@end
