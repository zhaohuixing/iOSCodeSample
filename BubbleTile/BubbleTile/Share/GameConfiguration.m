//
//  GameConfiguration.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-08.
//  Copyright 2011 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "ApplicationConfigure.h"
#import "GameConfiguration.h"
#import "GameScore.h"
#import "StringFactory.h"
#import "UIDevice-Reachability.h"


//Current configured bubble unit number
static int m_nBubbleUnit = MIN_BUBBLE_UNIT;
static enGridType       m_GridType = PUZZLE_GRID_TRIANDLE;
static enGridLayout     m_GridLayout = PUZZLE_LALOUT_MATRIX;
static BOOL             m_bDirty = NO;
static int              m_nPlayStepCount = 0;
static int              m_nYear = 0;
static int              m_nMonth = 0;
static int              m_nDay = 0;

static enBubbleType      m_BubbleType = PUZZLE_BUBBLE_COLOR;
static BOOL             m_bDifficulty = NO;
static BOOL             m_bValentineDay = NO;
static BOOL             m_bOdd = NO;

static int              m_nBackgroundType = 0;

static enGameType       m_GameType = GAME_BUBBLE_TILE;

@implementation GameConfiguration

+(void)SetGameType:(enGameType)bType
{
    m_bDirty = YES;
    m_GameType = bType;
}

+(enGameType)GetGameType
{
    return m_GameType;
}

+(void)SetBubbleType:(enBubbleType)bType
{
    //if(m_BubbleType != bType)
        m_bDirty = YES;
    
    m_BubbleType = bType;
}

+(enBubbleType)GetBubbleType
{
    return m_BubbleType;
}

+(void)SetGameDifficulty:(BOOL)bDifficulty
{
    //if(m_bDifficulty != bDifficulty)
        m_bDirty = YES;
    
    m_bDifficulty = bDifficulty;
}

+(BOOL)IsGameDifficulty
{
    return m_bDifficulty;
}

+(int)GetDefaultBubbleUnit
{
    return MIN_BUBBLE_UNIT;
}

+(int)GetBubbleUnit
{
    return m_nBubbleUnit;
}

+(void)SetBubbleUnit:(int)nEdge
{
    m_bDirty = YES;
    m_nBubbleUnit = nEdge;
    int nMinUnit = [GameConfiguration GetMinBubbleUnit:m_GridType];
    if(m_nBubbleUnit < nMinUnit)
        m_nBubbleUnit = nMinUnit;
    
    int nMaxUnit = [GameConfiguration GetMaxBubbleUnit:m_GridType];
    if(nMaxUnit < m_nBubbleUnit)
        m_nBubbleUnit = nMaxUnit;
}

+(void)SetGridType:(enGridType)enType
{
    //if(m_GridType != enType)
        m_bDirty = YES;
    
    m_GridType = enType;
    int nMinUnit = [GameConfiguration GetMinBubbleUnit:m_GridType];
    if(m_nBubbleUnit < nMinUnit)
        m_nBubbleUnit = nMinUnit;

    int nMaxUnit = [GameConfiguration GetMaxBubbleUnit:m_GridType];
    if(nMaxUnit < m_nBubbleUnit)
        m_nBubbleUnit = nMaxUnit;
}

+(enGridType)GetGridType
{
    return m_GridType;
}

+(void)SetGridLayout:(enGridLayout)enLayout
{
    //if(m_GridLayout != enLayout)
        m_bDirty = YES;
    
    m_GridLayout = enLayout;
}

+(enGridLayout)GetGridLayout
{
    return m_GridLayout;
}

+(int)GetMinBubbleUnit:(enGridType)enType
{
    int nRet = MIN_BUBBLE_UNIT;
    
    switch(enType)
    {
        case PUZZLE_GRID_TRIANDLE: 
            nRet = MIN_BUBBLE_UNIT;
            break;
        case PUZZLE_GRID_SQUARE:
            nRet = MIN_BUBBLE_UNIT;
            break;
        case PUZZLE_GRID_DIAMOND:
            nRet = MIN_BUBBLE_UNIT;
            break;
        case PUZZLE_GRID_HEXAGON:
            nRet = MIN_BUBBLE_UNIT-1;
            break;
    }
    
    return nRet;
}

+(int)GetUnpaidGameMaxBubbleUnit:(enGridType)enType gameType:(enGameType)gameType
{
    int nRet = MIN_BUBBLE_UNIT;
    
    if(enType == PUZZLE_GRID_TRIANDLE)
    {
        nRet = [GameConfiguration GetMaxBubbleUnit:PUZZLE_GRID_TRIANDLE];
        return nRet;
    }
    else
    {    
        nRet = [GameConfiguration GetMinBubbleUnit:enType];
        if(gameType == GAME_TRADITION_SLIDE)
        {
            nRet = nRet+1;
        }
    }
    
    return nRet;
}

+(BOOL)CanPlayFullTraditional:(enGridType)enType
{
    if([GameScore CheckPaymentState] || [ApplicationConfigure CanTemporaryAccessPaidFeature])
    {
        return YES;
    }
    else if(enType == PUZZLE_GRID_SQUARE && [GameScore CheckSquarePaymentState] == YES)
    {    
        return YES;
    }    
    else if(enType == PUZZLE_GRID_DIAMOND && [GameScore CheckDiamondPaymentState] == YES)
    {    
        return YES;
    }    
    else if(enType == PUZZLE_GRID_HEXAGON && [GameScore CheckHexagonPaymentState] == YES)
    {    
        return YES;
    }   

    return NO;
}


+(BOOL)CanPlayUnpaidTraditional:(enGridType)enType
{
    BOOL bRet =[GameConfiguration CanPlayFullTraditional:enType];
    if(bRet)
        return bRet;
    
    if ([UIDevice networkAvailable] == NO && ([StringFactory IsOSLangZH] || [StringFactory IsOSLangRU] || [StringFactory IsOSLangPT] || [StringFactory IsOSLangKO])) 
    {
        return NO;
    }
    
    return YES;
}

+(void)RecheckConfigureValidation
{
    BOOL bNeedReconfigure = ([GameConfiguration GetGameType] == GAME_TRADITION_SLIDE);
    if(!bNeedReconfigure)
        return;
    enGridType enType= [GameConfiguration GetGridType];
    bNeedReconfigure = (![GameConfiguration CanPlayFullTraditional:enType]);
    if(!bNeedReconfigure)
        return;

    if([GameConfiguration CanPlayUnpaidTraditional:enType])
    {
        int nEdge = [GameConfiguration GetBubbleUnit];
        int nLimit = [GameConfiguration GetUnpaidGameMaxBubbleUnit:enType gameType:GAME_TRADITION_SLIDE];
        if(nLimit < nEdge)
        {
            [GameConfiguration SetBubbleUnit:nLimit];
        }
        return;
    }
    else
    {
        [GameConfiguration SetGameType:GAME_BUBBLE_TILE];
        int nEdge = [GameConfiguration GetBubbleUnit];
        int nLimit = [GameConfiguration GetUnpaidGameMaxBubbleUnit:enType gameType:GAME_BUBBLE_TILE];
        if(nLimit < nEdge)
        {
            [GameConfiguration SetBubbleUnit:nLimit];
        }
        return;
    }
}

+(int)GetLegacyMaxBubbleUnit:(enGridType)enType
{
    int nRet = 8;
    
    if([ApplicationConfigure iPhoneDevice])
    {
        switch(enType)
        {
            case PUZZLE_GRID_TRIANDLE: 
                nRet = 10;
                break;
            case PUZZLE_GRID_SQUARE:
                nRet = 10;
                break;
            case PUZZLE_GRID_DIAMOND:
                nRet = 7;
                break;
            case PUZZLE_GRID_HEXAGON:
                nRet = 7;
                break;
        }
    }
    else
    {
        switch(enType)
        {
            case PUZZLE_GRID_TRIANDLE: 
                nRet = 16;
                break;
            case PUZZLE_GRID_SQUARE:
                nRet = 16;
                break;
            case PUZZLE_GRID_DIAMOND:
                nRet = 12;
                break;
            case PUZZLE_GRID_HEXAGON:
                nRet = 12;
                break;
        }
    }
    
    return nRet;
}

+(int)GetMaxBubbleUnit:(enGridType)enType
{
    int nRet = 8;
    switch(enType)
    {
        case PUZZLE_GRID_TRIANDLE: 
            nRet = 12;
            break;
        case PUZZLE_GRID_SQUARE:
            nRet = 12;
            break;
        case PUZZLE_GRID_DIAMOND:
            nRet = 10;
            break;
        case PUZZLE_GRID_HEXAGON:
            nRet = 10;
            break;
    }
    return nRet;
}

+(int)GetEnabledBubbleUnitCount:(enGridType)enType
{
    //??????????????????????????????????
    //TODO: Add real time checking game achievement from saved record
    //??????????????????????????????????
    int nMin = [GameConfiguration GetMinBubbleUnit:enType];
    int nMax = [GameConfiguration GetMaxBubbleUnit:enType];
    int nCount = nMax-nMin+1;
    return nCount;
}

+(void)SetGridBubbleUnit:(enGridType)enType withUnit:(int)nEdge
{
    //??????????????????????????????????
    //TODO: Add real time checking game achievement from saved record
    //??????????????????????????????????
   // if([GameConfiguration GetGridBubbleUnit:enType] != nEdge)
        m_bDirty = YES;
    
    [GameConfiguration SetBubbleUnit:nEdge];    
}

+(int)GetGridBubbleUnit:(enGridType)enType
{
    //??????????????????????????????????
    //TODO: Add real time checking game achievement from saved record
    //??????????????????????????????????
    return [GameConfiguration GetBubbleUnit];    
}

+(void)CleanDirty
{
    m_bDirty = NO;
}

+(BOOL)IsDirty
{
    return m_bDirty;
}

+(void)IncrementPlayStep
{
    ++m_nPlayStepCount;
}

+(void)DecrementPlayStep
{
    --m_nPlayStepCount;
    if(m_nPlayStepCount < 0)
        m_nPlayStepCount = 0; 
}

+(int)GetPlaySteps
{
    return m_nPlayStepCount;
}

+(void)SetPlaySteps:(int)nStep
{
    m_nPlayStepCount = nStep;
}

+(void)CleanPlaySteps
{
    m_nPlayStepCount = 0;
}

+(void)PrepareCurrentDate
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setDateFormat:@"MM"];
	m_nMonth = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter setDateFormat:@"dd"];
	m_nDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	
	[dateFormatter setDateFormat:@"yyyy"];
	m_nYear = [[dateFormatter stringFromDate:[NSDate date]] intValue];
}

+(int)GetYearOfCurrentDate
{
    return m_nYear;
}

+(int)GetMonthOfCurrentDate
{
    return m_nMonth;
}

+(int)GetDayOfCurrentDate
{
    return m_nDay;
}

+(BOOL)IsValentineDay
{
    return m_bValentineDay;
}

+(void)SetValentineDay:(BOOL)bYes
{
    m_bValentineDay = bYes;
}

+(BOOL)IsOddState
{
    return m_bOdd;
}

+(void)SetOddState:(BOOL)bOdd
{
    m_bOdd = bOdd;
}

+(void)SetMainBackgroundType:(int)nBKType
{
    m_nBackgroundType = nBKType;
}

+(int)GetMainBackgroundType
{
    return m_nBackgroundType;
}

+(int)getEasyGameWinScore:(enGridType)enType withEdge:(int)nEdge
{
    int nRet = 0;
    
    switch(enType)
    {
        case PUZZLE_GRID_TRIANDLE: 
            {
                int nMinEdge = [GameConfiguration GetMinBubbleUnit:enType];
                nRet = 1 + (nEdge-nMinEdge);
            }    
            break;
        case PUZZLE_GRID_SQUARE:
            {
                nRet = nEdge;
            }    
            break;
        case PUZZLE_GRID_DIAMOND:
            {
                int nMinEdge = [GameConfiguration GetMinBubbleUnit:enType];
                nRet = 2 + (nEdge-nMinEdge);
            }    
            break;
        case PUZZLE_GRID_HEXAGON:
            {
                int nMinEdge = [GameConfiguration GetMinBubbleUnit:enType];
                nRet = 3 + (nEdge-nMinEdge);
            }    
            break;
    }
    
    return nRet;
}

+(int)getDifficultGameWinScore:(enGridType)enType withEdge:(int)nEdge
{
    int nRet = 0;
    
    switch(enType)
    {
        case PUZZLE_GRID_TRIANDLE: 
            {
                int nMinEdge = [GameConfiguration GetMinBubbleUnit:enType];
                nRet = (1 + (nEdge-nMinEdge))*2;
            }    
            break;
        case PUZZLE_GRID_SQUARE:
            {
                nRet = nEdge*nEdge;
            }    
            break;
        case PUZZLE_GRID_DIAMOND:
            {
                int nMinEdge = [GameConfiguration GetMinBubbleUnit:enType];
                nRet = (2 + (nEdge-nMinEdge))*3;
            }    
            break;
        case PUZZLE_GRID_HEXAGON:
            {
                int nMinEdge = [GameConfiguration GetMinBubbleUnit:enType];
                nRet = (3 + (nEdge-nMinEdge))*4;
            }    
            break;
    }
    
    return nRet;
}

@end
