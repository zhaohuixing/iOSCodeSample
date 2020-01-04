//
//  GameConfiguration.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface GameConfiguration : NSObject
{
}

+(void)SetGameType:(enGameType)bType;
+(enGameType)GetGameType;


+(void)SetBubbleType:(enBubbleType)bType;
+(enBubbleType)GetBubbleType;

+(void)SetGameDifficulty:(BOOL)bDifficulty;
+(BOOL)IsGameDifficulty;

+(int)GetDefaultBubbleUnit;
+(int)GetBubbleUnit;
+(void)SetBubbleUnit:(int)nEdge;

+(void)SetGridType:(enGridType)enType;
+(enGridType)GetGridType;
+(void)SetGridLayout:(enGridLayout)enLayout;
+(enGridLayout)GetGridLayout;
+(int)GetMinBubbleUnit:(enGridType)enType;
+(int)GetLegacyMaxBubbleUnit:(enGridType)enType;
+(int)GetMaxBubbleUnit:(enGridType)enType;
+(int)GetEnabledBubbleUnitCount:(enGridType)enType;
+(void)SetGridBubbleUnit:(enGridType)enType withUnit:(int)nEdge;
+(int)GetGridBubbleUnit:(enGridType)enType;

+(int)GetUnpaidGameMaxBubbleUnit:(enGridType)enType gameType:(enGameType)gameType;
+(BOOL)CanPlayFullTraditional:(enGridType)enType;
+(BOOL)CanPlayUnpaidTraditional:(enGridType)enType;

+(void)RecheckConfigureValidation;

+(void)CleanDirty;
+(BOOL)IsDirty;

+(void)IncrementPlayStep;
+(void)DecrementPlayStep;
+(int)GetPlaySteps;
+(void)SetPlaySteps:(int)nStep;
+(void)CleanPlaySteps;

+(void)PrepareCurrentDate;
+(int)GetYearOfCurrentDate;
+(int)GetMonthOfCurrentDate;
+(int)GetDayOfCurrentDate;

+(BOOL)IsValentineDay;
+(void)SetValentineDay:(BOOL)bYes;
+(BOOL)IsOddState;
+(void)SetOddState:(BOOL)bOdd;

+(void)SetMainBackgroundType:(int)nBKType;
+(int)GetMainBackgroundType;

+(int)getEasyGameWinScore:(enGridType)enType withEdge:(int)nEdge;
+(int)getDifficultGameWinScore:(enGridType)enType withEdge:(int)nEdge;

@end
