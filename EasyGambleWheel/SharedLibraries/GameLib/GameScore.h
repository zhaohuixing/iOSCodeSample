//
//  GameScore.h
//  LuckyCompass
//
//  Created by ZXing on 2010-05-03.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameScore : NSObject 
{
    int			m_nMyMostWinYear;
    int			m_nMyMostWinMonth;
    int			m_nMyMostWinDay;
    int			m_nMyMostWinChips;
    int			m_nMyChipBalance;
    int         m_nMyLastPlayResult;

    int			m_nPlayer1MostWinYear;
    int			m_nPlayer1MostWinMonth;
    int			m_nPlayer1MostWinDay;
    int			m_nPlayer1MostWinChips;
    int			m_nPlayer1ChipBalance;
    int         m_nPlayer1LastPlayResult;
    
    int			m_nPlayer2MostWinYear;
    int			m_nPlayer2MostWinMonth;
    int			m_nPlayer2MostWinDay;
    int			m_nPlayer2MostWinChips;
    int			m_nPlayer2ChipBalance;
    int         m_nPlayer2LastPlayResult;
    
    int			m_nPlayer3MostWinYear;
    int			m_nPlayer3MostWinMonth;
    int			m_nPlayer3MostWinDay;
    int			m_nPlayer3MostWinChips;
    int			m_nPlayer3ChipBalance;
    int         m_nPlayer3LastPlayResult;
    
    int         m_nGameType;
    int         m_nGameTheme;
    int         m_nOfflineBetWay;
    int         m_nSaveRecord;
    BOOL        m_bSound;
    int         m_nPlayTurnType;
}

- (void)Save;
- (void)Load;

- (void)SetMyChipBalance:(int)nChips;
- (void)SetMyLastPlayResult:(int)nChips;

- (void)SetPlayer1ChipBalance:(int)nChips;
- (void)SetPlayer1LastPlayResult:(int)nChips;

- (void)SetPlayer2ChipBalance:(int)nChips;
- (void)SetPlayer2LastPlayResult:(int)nChips;

- (void)SetPlayer3ChipBalance:(int)nChips;
- (void)SetPlayer3LastPlayResult:(int)nChips;

- (void)SetGameType:(int)nType;
- (int)GetGameType;
- (void)SetGameTheme:(int)nTheme;
- (int)GetGameTheme;
- (void)SetOfflineBetMethod:(int)nWay;
- (int)GetOfflineBetMethod;
- (void)SetSoundEnable:(BOOL)bEnable;
- (BOOL)GetSoundEnable;
- (void)SetPlayTurnType:(int)nPlayTurnType;
- (int)GetPlayTurnType;
- (int)GetSavedRecord;


- (int)GetMyMostWinYear;
- (int)GetMyMostWinMonth;
- (int)GetMyMostWinDay;
- (int)GetMyMostWinChips;
- (int)GetMyChipBalance;
- (int)GetMyLastPlayResult;

- (int)GetPlayer1MostWinYear;
- (int)GetPlayer1MostWinMonth;
- (int)GetPlayer1MostWinDay;
- (int)GetPlayer1MostWinChips;
- (int)GetPlayer1ChipBalance;
- (int)GetPlayer1LastPlayResult;

- (int)GetPlayer2MostWinYear;
- (int)GetPlayer2MostWinMonth;
- (int)GetPlayer2MostWinDay;
- (int)GetPlayer2MostWinChips;
- (int)GetPlayer2ChipBalance;
- (int)GetPlayer2LastPlayResult;

- (int)GetPlayer3MostWinYear;
- (int)GetPlayer3MostWinMonth;
- (int)GetPlayer3MostWinDay;
- (int)GetPlayer3MostWinChips;
- (int)GetPlayer3ChipBalance;
- (int)GetPlayer3LastPlayResult;

+(NSString*)GetMyMostWinYearKey;
+(NSString*)GetMyMostWinMonthKey;
+(NSString*)GetMyMostWinDayKey;
+(NSString*)GetMyMostWinChipsKey;
+(NSString*)GetMyChipBalanceKey;
+(NSString*)GetMyLastPlayResultKey;

+(NSString*)GetPlayer1MostWinYearKey;
+(NSString*)GetPlayer1MostWinMonthKey;
+(NSString*)GetPlayer1MostWinDayKey;
+(NSString*)GetPlayer1MostWinChipsKey;
+(NSString*)GetPlayer1ChipBalanceKey;
+(NSString*)GetPlayer1LastPlayResultKey;

+(NSString*)GetPlayer2MostWinYearKey;
+(NSString*)GetPlayer2MostWinMonthKey;
+(NSString*)GetPlayer2MostWinDayKey;
+(NSString*)GetPlayer2MostWinChipsKey;
+(NSString*)GetPlayer2ChipBalanceKey;
+(NSString*)GetPlayer2LastPlayResultKey;

+(NSString*)GetPlayer3MostWinYearKey;
+(NSString*)GetPlayer3MostWinMonthKey;
+(NSString*)GetPlayer3MostWinDayKey;
+(NSString*)GetPlayer3MostWinChipsKey;
+(NSString*)GetPlayer3ChipBalanceKey;
+(NSString*)GetPlayer3LastPlayResultKey;

+(NSString*)GetGameTypeKey;
+(NSString*)GetOfflineBetKey;
+(NSString*)GetSaveRecordKey;
+(NSString*)GetSoundKey;
+(NSString*)GetPlayTurnTypeKey;

+(void)SetOnlineNickName:(NSString*)szName;
+(NSString*)GetOnlineNickName;
+(BOOL)HasOnlineNickName;

+(void)SetOnlinePlayerID:(NSString*)szID;
+(NSString*)GetOnlinePlayerID;
+(BOOL)HasOnlinePlayerID;

+(void)SetAWSServiceEnable:(BOOL)bEnable;
+(BOOL)IsAWSServiceEnable;
@end
