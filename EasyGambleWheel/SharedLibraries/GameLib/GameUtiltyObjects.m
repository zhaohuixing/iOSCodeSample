//
//  GameUtiltyObjects.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "GameUtiltyObjects.h"
#import "GameConstants.h"
#import "GUILayout.h"
#include "drawhelper.h"

#define TOUCH_SPEED_FAST_THRESHOLD		20
#define TOUCH_SPEED_MEDIUM_THRESHOLD	30
#define TOUCH_SPEED_SLOW_THRESHOLD		50


@implementation CPinActionLevel

@synthesize     m_nFastCycle;
@synthesize     m_nMediumCycle;
@synthesize     m_nSlowCycle;
@synthesize     m_nSlowAngle;
@synthesize     m_nVibCycle;
@synthesize     m_bClockwise;


+(float)GetDistanceFactor:(float)x with:(float)y
{
    float dt = x*x + y*y;
    if(dt == 0.0)
        return -1.0;
    
    float sw = [GUILayout GetMainUIWidth];
    float sh = [GUILayout GetContentViewHeight];
    
    float ds = sw*sw + sh*sh;
        
    float fRet = ds/dt;
    
    return fRet;
}

-(void)GenerateDefaultSlowLevelPinAction:(BOOL)bClockWise
{
	int nRand = [GameUitltyHelper CreateRandomNumber];//GetRandNumber();
	if(nRand < 0)
		nRand *= -1;
	
	m_nFastCycle = 0;
	m_nMediumCycle = 0; 
	m_nSlowCycle = 1 + nRand%2;		
	m_nSlowAngle = nRand%360; 
	m_nVibCycle = 0 + nRand%4;
	m_bClockwise = bClockWise;
}

-(void)GenerateDefaultSlowLevelPinAction2:(BOOL)bClockWise
{
	int nRand = [GameUitltyHelper CreateRandomNumber];//GetRandNumber();
	if(nRand < 0)
		nRand *= -1;
	
	m_nFastCycle = 0;
	m_nMediumCycle = 0; 
	m_nSlowCycle = 1 + nRand%3;		
	m_nSlowAngle = nRand%360; 
	m_nVibCycle = nRand%4;
	m_bClockwise = bClockWise;
}


-(void)GenerateDefaultMeduimLevelPinAction:(BOOL)bClockWise
{
	int nRand = [GameUitltyHelper CreateRandomNumber];//GetRandNumber();
	if(nRand < 0)
		nRand *= -1;
    
	m_nFastCycle = 0;
	m_nMediumCycle = nRand%4 + 3; 
	m_nSlowCycle = 1 + nRand%2;		
	m_nSlowAngle = nRand%360; 
	m_nVibCycle = 0 + nRand%3;
	m_bClockwise = bClockWise;
}

-(void)GenerateSuperFastPinAction:(BOOL) bClockWise
{
	int nRand = [GameUitltyHelper CreateRandomNumber];//GetRandNumber();
	if(nRand < 0)
		nRand *= -1;
    
	m_nFastCycle = nRand%8 + 12;
	m_nMediumCycle = nRand%6 + 5; 
	m_nSlowCycle = 1 + nRand%3;		
	m_nSlowAngle = nRand%360; 
	m_nVibCycle = 0 + nRand%6;
	m_bClockwise = bClockWise;
}

-(void)GenerateFastPinAction:(BOOL)bClockWise
{
	int nRand = [GameUitltyHelper CreateRandomNumber];//GetRandNumber();
	if(nRand < 0)
		nRand *= -1;
    
	m_nFastCycle = nRand%6 + 6;
	m_nMediumCycle = nRand%5 + 5; 
	m_nSlowCycle = 1 + nRand%3;		
	m_nSlowAngle = nRand%360; 
	m_nVibCycle = 0 + nRand%4;
	m_bClockwise = bClockWise;
}

-(BOOL)GetTouchClockWise:(CGPoint)pt1 withPoint2:(CGPoint)pt2
{
    BOOL bRet = YES;
    
	float cx = [GUILayout GetMainUIWidth]/2;
	float cy = [GUILayout GetContentViewHeight]/2;
	if(CounterClockWise(pt1.x, pt1.y, pt2.x, pt2.y, cx, cy))
    {
        bRet = YES;
    }
    else
    {
        bRet = NO;
    }
    
    return bRet;
}

-(void)InternalCreateAction:(CGPoint)pt1 withPoint2:(CGPoint)pt2 withTime:(float)time
{
	float fx = pt2.x - pt1.x;
	float fy = pt2.y - pt1.y;
    float dFactor = [CPinActionLevel GetDistanceFactor:fx with:fy];
	if(dFactor < 0)
	{
		[self GenerateDefaultMeduimLevelPinAction:YES];
		return; 
	}
    
    BOOL bClockWise = [self GetTouchClockWise:pt1 withPoint2:pt2];

	float dThreshold = dFactor*time; 
	
	
	if(dThreshold <= TOUCH_SPEED_FAST_THRESHOLD)
	{
		[self GenerateSuperFastPinAction:bClockWise];
	}
	else if(TOUCH_SPEED_FAST_THRESHOLD < dThreshold && dThreshold <= TOUCH_SPEED_MEDIUM_THRESHOLD)
	{
		[self GenerateFastPinAction:bClockWise];
	}
	else if(TOUCH_SPEED_MEDIUM_THRESHOLD < dThreshold && dThreshold <= TOUCH_SPEED_SLOW_THRESHOLD)
	{
		[self GenerateDefaultMeduimLevelPinAction:bClockWise];
	}
	else
	{
		[self GenerateDefaultSlowLevelPinAction:bClockWise];
	}
}

-(id)initLevel:(CGPoint)pt1 withPoint2:(CGPoint)pt2 withTime:(float)time
{
    self = [super init];
    if(self)
    {
        [self InternalCreateAction:pt1 withPoint2:pt2 withTime:time];
    }
    return self;
}


-(void)InternalRandomCreateAction
{
    int nRand = [GameUitltyHelper CreateRandomNumber];//GetRandNumber();
    float sw = [GUILayout GetMainUIWidth];
    float sh = [GUILayout GetContentViewHeight];
    float ds = sw*sw + sh*sh;

    int ns = (int)ds;
    int dr = nRand%ns;
    
    float dFactor = ((float)dr)/ds;
    BOOL bClockWise = ((nRand%2) == 0 ? YES:NO);
    int nTime = nRand%TOUCH_SPEED_SLOW_THRESHOLD;
    float fTime = (float)nTime;
    
	float dThreshold = dFactor*fTime; 
	if(dThreshold <= TOUCH_SPEED_FAST_THRESHOLD)
	{
		[self GenerateSuperFastPinAction:bClockWise];
	}
	else if(TOUCH_SPEED_FAST_THRESHOLD < dThreshold && dThreshold <= TOUCH_SPEED_MEDIUM_THRESHOLD)
	{
		[self GenerateFastPinAction:bClockWise];
	}
	else if(TOUCH_SPEED_MEDIUM_THRESHOLD < dThreshold && dThreshold <= TOUCH_SPEED_SLOW_THRESHOLD)
	{
		[self GenerateDefaultMeduimLevelPinAction:bClockWise];
	}
	else
	{
		[self GenerateDefaultSlowLevelPinAction:bClockWise];
	}
}

-(id)initRandomLevel
{
    self = [super init];
    if(self)
    {
        [self InternalRandomCreateAction];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        m_nFastCycle = 0;
        m_nMediumCycle = 0;
        m_nSlowCycle = 0;
        m_nSlowAngle = 0;
        m_nVibCycle = 0;
        m_bClockwise = YES;
    }
    return self;
}

@end

//Class CLuckScope implememntations
@implementation CLuckScope

- (id)initScope:(int)startAngle withEnd:(int)endAngle
{
    self = [super init];
    
    if(self)
    {
        m_nStartAngle = startAngle;
        m_nEndAngle = endAngle;
    }
    
    return self;
}
 

- (BOOL)InScope:(int)angle
{
	BOOL bRet = NO;
	
	if(m_nEndAngle < m_nStartAngle) //Scope cross 360/0 degree limit
	{
		if((m_nStartAngle <= angle && angle <= 360) ||(0 <= angle && angle < m_nEndAngle))
			bRet = YES;
	}
	else
	{
		if(m_nStartAngle <= angle && angle < m_nEndAngle)
			bRet = YES;
	}
	
	return bRet;
    
}

- (int)GetSweepAngle
{
	int nRet = 0;
    if(m_nEndAngle < m_nStartAngle) //Scope cross 360/0 degree limit
    {
        nRet = (360-m_nStartAngle) + m_nEndAngle;
    }
    else
    {
        nRet = m_nEndAngle - m_nStartAngle;
    }
	
	return nRet;
}

@end


@implementation GameUitltyHelper

+(int)GetGameLuckNumberThreshold:(int)nType
{
    int nRet = -1;
 
    switch(nType)
    {
        case GAME_TYPE_8LUCK:
            nRet = 8;
            break;
        case GAME_TYPE_6LUCK:
            nRet = 6;
            break;
        case GAME_TYPE_4LUCK:
            nRet = 4;
            break;
        case GAME_TYPE_2LUCK:
            nRet = 2;
            break;
    }
    
    return nRet;
}

+(int)GetGameBetPledgeThreshold:(int)nType
{
    int nRet = -1;
    
    switch(nType)
    {
        case GAME_TYPE_8LUCK:
            nRet = GAME_BET_THRESHOLD_8LUCK;
            break;
        case GAME_TYPE_6LUCK:
            nRet = GAME_BET_THRESHOLD_6LUCK;
            break;
        case GAME_TYPE_4LUCK:
            nRet = GAME_BET_THRESHOLD_4LUCK;
            break;
        case GAME_TYPE_2LUCK:
            nRet = GAME_BET_THRESHOLD_2LUCK;
            break;
    }
    
    return nRet;
}

+(int)CreateRandomNumber
{
    NSTimeInterval t = [[NSProcessInfo processInfo] systemUptime];
    int nSeed = (int)(t*1000.0);
	srand((unsigned)time(NULL)%nSeed);
	int nRet = rand();
	return nRet;
}

+(int)CreateRandomNumberWithSeed:(int)nSeed
{
    NSTimeInterval t = [[NSProcessInfo processInfo] systemUptime];
    int nRandSeed = (int)(t*1000.0);
	if(0 < nSeed)
        nRandSeed = nRandSeed/nSeed;
    else
        nRandSeed = nRandSeed/2;
       
    srand((unsigned)time(NULL)%nRandSeed);
	int nRet = rand();
	return nRet;
    
}

+(int)GetInAppPurchaseChips:(int)index
{
    switch(index)
    {
        case 0:
            return PURCHASED_CHIPS_1;
        case 1:
            return PURCHASED_CHIPS_2;
        case 2:
            return PURCHASED_CHIPS_3;
        case 3:
            return PURCHASED_CHIPS_4;
        case 4:
            return PURCHASED_CHIPS_5;
        case 5:
            return PURCHASED_CHIPS_6;
        case 6:
            return PURCHASED_CHIPS_7;
        case 7:
            return PURCHASED_CHIPS_8;
        case 8:
            return PURCHASED_CHIPS_9;
        case 9:
            return PURCHASED_CHIPS_10;
    }
    
    return 0;
}

+(NSString*)GetInAppPurchaseID:(int)index
{
    NSString* strNull = nil;
    switch(index)
    {
        case 0:
            return PRODUCT_ID_1000CHIPS;
        case 1:
            return PRODUCT_ID_2100CHIPS;
        case 2:
            return PRODUCT_ID_3200CHIPS;
        case 3:
            return PRODUCT_ID_4400CHIPS;
        case 4:
            return PRODUCT_ID_5800CHIPS;
        case 5:
            return PRODUCT_ID_7600CHIPS;
        case 6:
            return PRODUCT_ID_9200CHIPS;
        case 7:
            return PRODUCT_ID_10400CHIPS;
        case 8:
            return PRODUCT_ID_11800CHIPS;
        case 9:
            return PRODUCT_ID_13600CHIPS;
    }
    
    return strNull;
}

@end

