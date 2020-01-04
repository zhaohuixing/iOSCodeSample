//
//  ScoreRecord.m
//  MindFire
//
//  Created by Zhaohui Xing on 10-05-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScoreRecord.h"
#import "StringFactory.h"
#include "GameState.h"

@implementation ScoreRecord

@synthesize	m_nPoint; 
@synthesize m_nSpeed;
@synthesize	m_nLastScore;
@synthesize m_nAveHighestScore;
@synthesize m_nAveAveScore;
@synthesize m_nAvePlayCount;
@synthesize m_nYear4Highest;
@synthesize m_nMonth4Highest;
@synthesize m_nDay4Highest;
@synthesize m_nTotalWinScore; 


-(id)initRecord:(int)nPoint withSpeed:(int)nSpeed
{
    if ((self = [super init])) 
	{
		m_nPoint = nPoint;
		//m_nPlaySpeed = nSpeed;
		
        m_nTotalWinScore = 0; 
		m_nAveHighestScore = 0;
		m_nAveAveScore = 0;
		m_nAvePlayCount = 0;
		m_nYear4Highest = 0;
		m_nMonth4Highest = 0;
		m_nDay4Highest = 0;
		m_nLastScore = 0;
        m_nSpeed = nSpeed;
	}	
	
	return self;
}

-(int)GetPoint 
{
	return m_nPoint;
}	

-(int)GetSpeed
{
    return m_nSpeed;
}

-(void)AddScore:(double)dScore;
{
	++m_nAvePlayCount;
	
	m_nLastScore = dScore;
    m_nTotalWinScore += (int)dScore; 
	double dTotal = m_nAveAveScore*((double)(m_nAvePlayCount-1));
	m_nAveAveScore = (dTotal+dScore)/((double)m_nAvePlayCount);
	
	if(m_nAveHighestScore < dScore)
	{
		m_nAveHighestScore = dScore;
		m_nYear4Highest = GetTodayYear();
		m_nMonth4Highest = GetTodayMonth();
		m_nDay4Highest = GetTodayDay();
	}	
}	

//
//Save to storage 
//
-(void)SavePoint:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScorePointKey:index];	
	[prefs setInteger:m_nPoint forKey:sKey];
}

-(void)SaveSpeed:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreSpeedKey:index];	
	[prefs setInteger:m_nSpeed forKey:sKey];
}

-(void)SaveLast:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreLastKey:index];	
	[prefs setDouble:m_nLastScore forKey:sKey];
}

-(void)SaveHigh:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreHighestKey:index];	
	[prefs setDouble:m_nAveHighestScore forKey:sKey];
}

-(void)SaveAverage:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreAverageKey:index];	
	[prefs setDouble:m_nAveAveScore forKey:sKey];
}

-(void)SaveTotalWinScore:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreTotalWinCountKey:index];	
	[prefs setInteger: m_nTotalWinScore forKey:sKey];
}

-(void)SavePlay:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScorePlayKey:index];	
	[prefs setInteger:m_nAvePlayCount forKey:sKey];
}

-(void)SaveHighTime:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreYearHighKey:index];	
	[prefs setInteger:m_nYear4Highest forKey:sKey];

	sKey = [StringFactory GetString_ScoreMonthHighKey:index];	
	[prefs setInteger:m_nMonth4Highest forKey:sKey];

	sKey = [StringFactory GetString_ScoreDayHighKey:index];	
	[prefs setInteger:m_nDay4Highest forKey:sKey];
	
}

-(void)SaveScore:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	[self SavePoint:prefs scoreIndex: index];
    [self SaveSpeed:prefs scoreIndex:index];
	[self SaveLast:prefs scoreIndex: index];
	[self SaveHigh:prefs scoreIndex: index];
	[self SaveAverage:prefs scoreIndex: index];
    [self SaveTotalWinScore:prefs scoreIndex: index];
	[self SavePlay:prefs scoreIndex: index];
	[self SaveHighTime:prefs scoreIndex: index];
}

//
//Load from storage
//
-(void)LoadPoint:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScorePointKey:index];	
	m_nPoint = [prefs integerForKey:sKey];
	if(m_nPoint <= 0)
	{
		m_nPoint = GetGameDefaultPoint();
	}	
}

-(void)LoadSpeed:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreSpeedKey:index];	
	m_nSpeed = [prefs integerForKey:sKey];
	if(m_nSpeed <= 0)
	{
		m_nSpeed = 0;
	}	
}



-(void)LoadLast:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreLastKey:index];	
	m_nLastScore = [prefs doubleForKey:sKey];
	if(m_nLastScore <= 0.0)
		m_nLastScore = 0.0;
}

-(void)LoadHigh:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreHighestKey:index];	
	m_nAveHighestScore = [prefs doubleForKey:sKey];
	if(m_nAveHighestScore <= 0.0)
		m_nAveHighestScore = 0.0;
}

-(void)LoadAverage:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreAverageKey:index];	
	m_nAveAveScore = [prefs doubleForKey:sKey];
	if(m_nAveAveScore <= 0.0)
		m_nAveAveScore = 0.0;
}

-(void)LoadTotalWinScore:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreTotalWinCountKey:index];	
	m_nTotalWinScore = [prefs integerForKey:sKey];
	if(m_nTotalWinScore == 0)
		m_nTotalWinScore = (int)(m_nAveAveScore*m_nAvePlayCount);
}



-(void)LoadPlay:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScorePlayKey:index];	
	m_nAvePlayCount = [prefs integerForKey:sKey];
	if(m_nAvePlayCount <= 0)
		m_nAvePlayCount = 0;
}

-(void)LoadHighTime:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	NSString* sKey = [StringFactory GetString_ScoreYearHighKey:index];	
	m_nYear4Highest = [prefs integerForKey:sKey];
	if(m_nYear4Highest <= 0)
	{
		m_nYear4Highest = 0;
		m_nMonth4Highest = 0;
		m_nDay4Highest = 0;
		return;
	}	
	
	sKey = [StringFactory GetString_ScoreMonthHighKey:index];	
	m_nMonth4Highest = [prefs integerForKey:sKey];
	if(m_nMonth4Highest <= 0)
	{
		m_nYear4Highest = 0;
		m_nMonth4Highest = 0;
		m_nDay4Highest = 0;
		return;
	}	
	
	sKey = [StringFactory GetString_ScoreDayHighKey:index];	
	m_nDay4Highest = [prefs integerForKey:sKey];
	if(m_nDay4Highest <= 0)
	{	
		m_nYear4Highest = 0;
		m_nMonth4Highest = 0;
		m_nDay4Highest = 0;
		return;
	}
}

-(void)LoadScore:(NSUserDefaults*)prefs scoreIndex:(int)index
{
	[self LoadPoint:prefs scoreIndex: index];
	[self LoadSpeed:prefs scoreIndex: index];
	[self LoadLast:prefs scoreIndex: index];
	[self LoadHigh:prefs scoreIndex: index];
	[self LoadAverage:prefs scoreIndex: index];
	[self LoadPlay:prefs scoreIndex: index];
    [self LoadTotalWinScore:prefs scoreIndex:index];
	[self LoadHighTime:prefs scoreIndex: index];
}	


@end
