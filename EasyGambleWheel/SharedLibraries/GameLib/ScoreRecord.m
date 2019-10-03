//
//  ScoreRecord.m
//  ChuiNiu
//
//  Created by ZXing on 2010-08-10.
//  Copyright 2010 xgadget. All rights reserved.
//
#import "ScoreRecord.h"
#import "StringFactory.h"
#import "GameScore.h"
#import "GameCenterConstant.h"
#import "GUILayout.h"

static GameScore* g_Score = nil;

@implementation ScoreRecord

+ (void)IntiScore
{
	g_Score = [[GameScore alloc] init];
	[g_Score Load];
}	

+ (void)SaveScore
{
	[g_Score Save];
}

+ (void)ReleaseScore
{
	[g_Score Save];
    g_Score = nil;
}	

+ (void)Reload
{
    if(g_Score != nil)
    {
        [g_Score Load];
    }
    else
    {
        [ScoreRecord IntiScore];
    }
}

+ (void)SetPlayerLastPlayResult:(int)nChips inSeat:(int)index
{
    if(index == 0)
    {
        [ScoreRecord SetMyLastPlayResult:nChips];
    }
    else if(index == 1)
    {
        [ScoreRecord SetPlayer1LastPlayResult:nChips];
    }
    else if(index == 2)
    {
        [ScoreRecord SetPlayer2LastPlayResult:nChips];
    }
    else if(index == 3)
    {
        [ScoreRecord SetPlayer3LastPlayResult:nChips];
    }
}

+ (void)SetPlayerChipBalance:(int)nChips inSeat:(int)index
{
    if(index == 0)
    {
        [ScoreRecord SetMyChipBalance:nChips];
    }
    else if(index == 1)
    {
        [ScoreRecord SetPlayer1ChipBalance:nChips];
    }
    else if(index == 2)
    {
        [ScoreRecord SetPlayer2ChipBalance:nChips];
    }
    else if(index == 3)
    {
        [ScoreRecord SetPlayer3ChipBalance:nChips];
    }
}

+ (void)SetMyChipBalance:(int)nChips
{
    [g_Score SetMyChipBalance:nChips];
}

+ (void)SetMyLastPlayResult:(int)nChips
{
    [g_Score SetMyLastPlayResult:nChips];
}


+ (void)SetPlayer1ChipBalance:(int)nChips
{
    [g_Score SetPlayer1ChipBalance:nChips];
}

+ (void)SetPlayer1LastPlayResult:(int)nChips
{
    [g_Score SetPlayer1LastPlayResult:nChips];
}


+ (void)SetPlayer2ChipBalance:(int)nChips
{
    [g_Score SetPlayer2ChipBalance:nChips];
}

+ (void)SetPlayer2LastPlayResult:(int)nChips
{
    [g_Score SetPlayer2LastPlayResult:nChips];
}

+ (void)SetPlayer3ChipBalance:(int)nChips
{
    [g_Score SetPlayer3ChipBalance:nChips];
}

+ (void)SetPlayer3LastPlayResult:(int)nChips
{
    [g_Score SetPlayer3LastPlayResult:nChips];
}

+ (void)SetGameType:(int)nType
{
    [g_Score SetGameType:nType];
}

+ (int)GetGameType
{
    return [g_Score GetGameType];
}

+ (void)SetGameTheme:(int)nTheme
{
    [g_Score SetGameTheme:nTheme];
}

+ (int)GetGameTheme
{
    return [g_Score GetGameTheme];
}

+ (void)SetOfflineBetMethod:(int)nWay
{
    [g_Score SetOfflineBetMethod:nWay];
}

+ (int)GetOfflineBetMethod
{
    return [g_Score GetOfflineBetMethod];
}

+ (void)SetSoundEnable:(BOOL)bEnable
{
    [g_Score SetSoundEnable:bEnable];
}

+ (BOOL)GetSoundEnable
{
    return [g_Score GetSoundEnable];
}

+ (void)SetPlayTurnType:(int)nPlayTurnType
{
    [g_Score SetPlayTurnType:nPlayTurnType];
}
+ (int)GetPlayTurnType
{
    return [g_Score GetPlayTurnType];
}

+ (int)GetSavedRecord
{
    return [g_Score GetSavedRecord];
}

+ (int)GetMyMostWinYear
{
    return [g_Score GetMyMostWinYear];
}

+ (int)GetMyMostWinMonth
{
    return [g_Score GetMyMostWinMonth];
}

+ (int)GetMyMostWinDay
{
    return [g_Score GetMyMostWinDay];
}

+ (int)GetMyMostWinChips
{
    return [g_Score GetMyMostWinChips];
}

+ (int)GetMyChipBalance
{
    return [g_Score GetMyChipBalance];
}

+ (int)GetMyLastPlayResult
{
    return [g_Score GetMyLastPlayResult];
}

+ (int)GetPlayer1MostWinYear
{
    return [g_Score GetPlayer1MostWinYear];
}

+ (int)GetPlayer1MostWinMonth
{
    return [g_Score GetPlayer1MostWinMonth];
}

+ (int)GetPlayer1MostWinDay
{
    return [g_Score GetPlayer1MostWinDay];
}

+ (int)GetPlayer1MostWinChips
{
    return [g_Score GetPlayer1MostWinChips];
}

+ (int)GetPlayer1ChipBalance
{
    return [g_Score GetPlayer1ChipBalance];
}

+ (int)GetPlayer1LastPlayResult
{
    return [g_Score GetPlayer1LastPlayResult];
}

+ (int)GetPlayer2MostWinYear
{
    return [g_Score GetPlayer2MostWinYear];
}

+ (int)GetPlayer2MostWinMonth
{
    return [g_Score GetPlayer2MostWinMonth];
}

+ (int)GetPlayer2MostWinDay
{
    return [g_Score GetPlayer2MostWinDay];
}

+ (int)GetPlayer2MostWinChips
{
    return [g_Score GetPlayer2MostWinChips];
}

+ (int)GetPlayer2ChipBalance
{
    return [g_Score GetPlayer2ChipBalance];
}

+ (int)GetPlayer2LastPlayResult
{
    return [g_Score GetPlayer2LastPlayResult];
}

+ (int)GetPlayer3MostWinYear
{
    return [g_Score GetPlayer3MostWinYear];
}

+ (int)GetPlayer3MostWinMonth
{
    return [g_Score GetPlayer3MostWinMonth];
}

+ (int)GetPlayer3MostWinDay
{
    return [g_Score GetPlayer3MostWinDay];
}

+ (int)GetPlayer3MostWinChips
{
    return [g_Score GetPlayer3MostWinChips];
}

+ (int)GetPlayer3ChipBalance
{
    return [g_Score GetPlayer3ChipBalance];
}

+ (int)GetPlayer3LastPlayResult
{
    return [g_Score GetPlayer3LastPlayResult];
}

static NSString* const g_AdBannerSettingKey = @"AdBannerViewEnableKey";

+ (void)SetEnableAdBanner:(BOOL)bEnable
{
    [NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:bEnable forKey:g_AdBannerSettingKey];
    [prefs synchronize];
}

+ (BOOL)GetEnableAdBanner
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL bEnable = YES;
    
    if([[[prefs dictionaryRepresentation] allKeys] containsObject:g_AdBannerSettingKey] == NO)
    {
        bEnable = YES;
    }
    else
    {
        bEnable = (BOOL)[prefs boolForKey:g_AdBannerSettingKey];
    }
    
    return bEnable;
}


@end
