//
//  ScoreRecord.h
//  XXXXX
//
//  Created by ZXing on 2010-08-10.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScoreRecord : NSObject 
{
}

+ (void)IntiScore;
+ (void)SaveScore;
+ (void)ReleaseScore;
+ (void)Reload;
+ (void)SetMyChipBalance:(int)nChips;
+ (void)SetMyLastPlayResult:(int)nChips;

+ (void)SetPlayerLastPlayResult:(int)nChips inSeat:(int)index;
+ (void)SetPlayerChipBalance:(int)nChips inSeat:(int)index;

+ (void)SetPlayer1ChipBalance:(int)nChips;
+ (void)SetPlayer1LastPlayResult:(int)nChips;

+ (void)SetPlayer2ChipBalance:(int)nChips;
+ (void)SetPlayer2LastPlayResult:(int)nChips;

+ (void)SetPlayer3ChipBalance:(int)nChips;
+ (void)SetPlayer3LastPlayResult:(int)nChips;

+ (void)SetGameType:(int)nType;
+ (int)GetGameType;
+ (void)SetGameTheme:(int)nTheme;
+ (int)GetGameTheme;
+ (void)SetOfflineBetMethod:(int)nWay;
+ (int)GetOfflineBetMethod;
+ (void)SetSoundEnable:(BOOL)bEnable;
+ (BOOL)GetSoundEnable;
+ (void)SetPlayTurnType:(int)nPlayTurnType;
+ (int)GetPlayTurnType;
+ (int)GetSavedRecord;

+ (int)GetMyMostWinYear;
+ (int)GetMyMostWinMonth;
+ (int)GetMyMostWinDay;
+ (int)GetMyMostWinChips;
+ (int)GetMyChipBalance;
+ (int)GetMyLastPlayResult;

+ (int)GetPlayer1MostWinYear;
+ (int)GetPlayer1MostWinMonth;
+ (int)GetPlayer1MostWinDay;
+ (int)GetPlayer1MostWinChips;
+ (int)GetPlayer1ChipBalance;
+ (int)GetPlayer1LastPlayResult;

+ (int)GetPlayer2MostWinYear;
+ (int)GetPlayer2MostWinMonth;
+ (int)GetPlayer2MostWinDay;
+ (int)GetPlayer2MostWinChips;
+ (int)GetPlayer2ChipBalance;
+ (int)GetPlayer2LastPlayResult;

+ (int)GetPlayer3MostWinYear;
+ (int)GetPlayer3MostWinMonth;
+ (int)GetPlayer3MostWinDay;
+ (int)GetPlayer3MostWinChips;
+ (int)GetPlayer3ChipBalance;
+ (int)GetPlayer3LastPlayResult;

+ (void)SetEnableAdBanner:(BOOL)bEnable;
+ (BOOL)GetEnableAdBanner;


@end
