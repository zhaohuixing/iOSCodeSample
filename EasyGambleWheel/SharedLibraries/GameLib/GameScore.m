//
//  GameScore.m
//  LuckyCompass
//
//  Created by ZXing on 2010-05-03.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import "GameScore.h"
#import <Foundation/NSDate.h>
#import "GameConstants.h"
//#include "GameUtil.h"


@implementation GameScore

-(id)init
{
    self = [super init];
    if(self)
    {
        m_nMyMostWinYear = 0;
        m_nMyMostWinMonth = 0;
        m_nMyMostWinDay = 0;
        m_nMyMostWinChips = 0;
        m_nMyChipBalance = 0;
        m_nMyLastPlayResult = 0;
        
        m_nPlayer1MostWinYear = 0;
        m_nPlayer1MostWinMonth = 0;
        m_nPlayer1MostWinDay = 0;
        m_nPlayer1MostWinChips = 0;
        m_nPlayer1ChipBalance = 0;
        m_nPlayer1LastPlayResult = 0;
        
        m_nPlayer2MostWinYear = 0;
        m_nPlayer2MostWinMonth = 0;
        m_nPlayer2MostWinDay = 0;
        m_nPlayer2MostWinChips = 0;
        m_nPlayer2ChipBalance = 0;
        m_nPlayer2LastPlayResult = 0;
        
        m_nPlayer3MostWinYear = 0;
        m_nPlayer3MostWinMonth = 0;
        m_nPlayer3MostWinDay = 0;
        m_nPlayer3MostWinChips = 0;
        m_nPlayer3ChipBalance = 0;
        m_nPlayer3LastPlayResult = 0;
        
        m_nGameType = GAME_TYPE_8LUCK;
        m_nGameTheme = GAME_THEME_ANIMAL;
        m_nOfflineBetWay = 0;
        m_nSaveRecord = 0;
        m_bSound = YES;
        m_nPlayTurnType = GAME_PLAYTURN_TYPE_SEQUENCE;
    }
    return self;
}

- (void)SetGameType:(int)nType
{
    m_nGameType = nType;
}


- (int)GetGameType
{
    return m_nGameType;
}

- (void)SetGameTheme:(int)nTheme
{
    m_nGameTheme = nTheme;
}

- (int)GetGameTheme
{
    return m_nGameTheme;
}

- (int)GetSavedRecord
{
    return m_nSaveRecord;
}

- (void)SetOfflineBetMethod:(int)nWay
{
    m_nOfflineBetWay = nWay;
}

- (int)GetOfflineBetMethod
{
    return m_nOfflineBetWay;
}

- (void)SetSoundEnable:(BOOL)bEnable
{
    m_bSound = bEnable;
}

- (BOOL)GetSoundEnable
{
    return m_bSound;
}

- (void)SetPlayTurnType:(int)nPlayTurnType
{
    m_nPlayTurnType = nPlayTurnType;
}

- (int)GetPlayTurnType
{
    return m_nPlayTurnType;
}

- (void)SetMyChipBalance:(int)nChips
{
    m_nMyChipBalance = nChips;
}

- (void)SetMyLastPlayResult:(int)nChips
{
    m_nMyLastPlayResult = nChips;
    if(m_nMyMostWinChips <= m_nMyLastPlayResult)
    {
        m_nMyMostWinChips = m_nMyLastPlayResult;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM"];
        m_nMyMostWinMonth = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        
        [dateFormatter setDateFormat:@"dd"];
        m_nMyMostWinDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        
        [dateFormatter setDateFormat:@"yyyy"];
        m_nMyMostWinYear = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    }
}

- (void)SetPlayer1ChipBalance:(int)nChips
{
    m_nPlayer1ChipBalance = nChips;
}

- (void)SetPlayer1LastPlayResult:(int)nChips
{
    m_nPlayer1LastPlayResult = nChips;
    if(m_nPlayer1MostWinChips <= m_nPlayer1LastPlayResult)
    {
        m_nPlayer1MostWinChips = m_nPlayer1LastPlayResult;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM"];
        m_nPlayer1MostWinMonth = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        
        [dateFormatter setDateFormat:@"dd"];
        m_nPlayer1MostWinDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        
        [dateFormatter setDateFormat:@"yyyy"];
        m_nPlayer1MostWinYear = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    }
}

- (void)SetPlayer2ChipBalance:(int)nChips
{
    m_nPlayer2ChipBalance = nChips;
}

- (void)SetPlayer2LastPlayResult:(int)nChips
{
    m_nPlayer2LastPlayResult = nChips;
    if(m_nPlayer2MostWinChips <= m_nPlayer2LastPlayResult)
    {
        m_nPlayer2MostWinChips = m_nPlayer2LastPlayResult;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM"];
        m_nPlayer2MostWinMonth = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        
        [dateFormatter setDateFormat:@"dd"];
        m_nPlayer2MostWinDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        
        [dateFormatter setDateFormat:@"yyyy"];
        m_nPlayer2MostWinYear = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    }
}

- (void)SetPlayer3ChipBalance:(int)nChips
{
    m_nPlayer3ChipBalance = nChips;
}

- (void)SetPlayer3LastPlayResult:(int)nChips
{
    m_nPlayer3LastPlayResult = nChips;
    if(m_nPlayer3MostWinChips <= m_nPlayer3LastPlayResult)
    {
        m_nPlayer3MostWinChips = m_nPlayer3LastPlayResult;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM"];
        m_nPlayer3MostWinMonth = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        
        [dateFormatter setDateFormat:@"dd"];
        m_nPlayer3MostWinDay = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        
        [dateFormatter setDateFormat:@"yyyy"];
        m_nPlayer3MostWinYear = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    }
}

- (int)GetMyMostWinYear
{
    return m_nMyMostWinYear;
}

- (int)GetMyMostWinMonth
{
    return m_nMyMostWinMonth;
}

- (int)GetMyMostWinDay
{
    return m_nMyMostWinDay;
}

- (int)GetMyMostWinChips
{
    return m_nMyMostWinChips;
}

- (int)GetMyChipBalance
{
    return m_nMyChipBalance;
}

- (int)GetMyLastPlayResult
{
    return m_nMyLastPlayResult;
}

- (int)GetPlayer1MostWinYear
{
    return m_nPlayer1MostWinYear;
}

- (int)GetPlayer1MostWinMonth
{
    return m_nPlayer1MostWinMonth;
}

- (int)GetPlayer1MostWinDay
{
    return m_nPlayer1MostWinDay;
}

- (int)GetPlayer1MostWinChips
{
    return m_nPlayer1MostWinChips;
}

- (int)GetPlayer1ChipBalance
{
    return m_nPlayer1ChipBalance;
}

- (int)GetPlayer1LastPlayResult
{
    return m_nPlayer1LastPlayResult;
}

- (int)GetPlayer2MostWinYear
{
    return m_nPlayer2MostWinYear;
}

- (int)GetPlayer2MostWinMonth
{
    return m_nPlayer2MostWinMonth;
}

- (int)GetPlayer2MostWinDay
{
    return m_nPlayer2MostWinDay;
}

- (int)GetPlayer2MostWinChips
{
    return m_nPlayer2MostWinChips;
}

- (int)GetPlayer2ChipBalance
{
    return m_nPlayer2ChipBalance;
}

- (int)GetPlayer2LastPlayResult
{
    return m_nPlayer2LastPlayResult;
}

- (int)GetPlayer3MostWinYear
{
    return m_nPlayer3MostWinYear;
}

- (int)GetPlayer3MostWinMonth
{
    return m_nPlayer3MostWinMonth;
}

- (int)GetPlayer3MostWinDay
{
    return m_nPlayer3MostWinDay;
}

- (int)GetPlayer3MostWinChips
{
    return m_nPlayer3MostWinChips;
}

- (int)GetPlayer3ChipBalance
{
    return m_nPlayer3ChipBalance;
}

- (int)GetPlayer3LastPlayResult
{
    return m_nPlayer3LastPlayResult;
}

- (void)SaveMeDate:(NSUserDefaults*)prefs
{
	[prefs setInteger:m_nMyMostWinYear forKey:[GameScore GetMyMostWinYearKey]];
	[prefs setInteger:m_nMyMostWinMonth forKey:[GameScore GetMyMostWinMonthKey]];
	[prefs setInteger:m_nMyMostWinDay forKey:[GameScore GetMyMostWinDayKey]];
	[prefs setInteger:m_nMyMostWinChips forKey:[GameScore GetMyMostWinChipsKey]];

	[prefs setInteger:m_nMyChipBalance forKey:[GameScore GetMyChipBalanceKey]];
	[prefs setInteger:m_nMyLastPlayResult forKey:[GameScore GetMyLastPlayResultKey]];
}

- (void)SavePlayer1Date:(NSUserDefaults*)prefs
{
	[prefs setInteger:m_nPlayer1MostWinYear forKey:[GameScore GetPlayer1MostWinYearKey]];
	[prefs setInteger:m_nPlayer1MostWinMonth forKey:[GameScore GetPlayer1MostWinMonthKey]];
	[prefs setInteger:m_nPlayer1MostWinDay forKey:[GameScore GetPlayer1MostWinDayKey]];
	[prefs setInteger:m_nPlayer1MostWinChips forKey:[GameScore GetPlayer1MostWinChipsKey]];
    
	[prefs setInteger:m_nPlayer1ChipBalance forKey:[GameScore GetPlayer1ChipBalanceKey]];
	[prefs setInteger:m_nPlayer1LastPlayResult forKey:[GameScore GetPlayer1LastPlayResultKey]];
}

- (void)SavePlayer2Date:(NSUserDefaults*)prefs
{
	[prefs setInteger:m_nPlayer2MostWinYear forKey:[GameScore GetPlayer2MostWinYearKey]];
	[prefs setInteger:m_nPlayer2MostWinMonth forKey:[GameScore GetPlayer2MostWinMonthKey]];
	[prefs setInteger:m_nPlayer2MostWinDay forKey:[GameScore GetPlayer2MostWinDayKey]];
	[prefs setInteger:m_nPlayer2MostWinChips forKey:[GameScore GetPlayer2MostWinChipsKey]];
    
	[prefs setInteger:m_nPlayer2ChipBalance forKey:[GameScore GetPlayer2ChipBalanceKey]];
	[prefs setInteger:m_nPlayer2LastPlayResult forKey:[GameScore GetPlayer2LastPlayResultKey]];
}

- (void)SavePlayer3Date:(NSUserDefaults*)prefs
{
	[prefs setInteger:m_nPlayer3MostWinYear forKey:[GameScore GetPlayer3MostWinYearKey]];
	[prefs setInteger:m_nPlayer3MostWinMonth forKey:[GameScore GetPlayer3MostWinMonthKey]];
	[prefs setInteger:m_nPlayer3MostWinDay forKey:[GameScore GetPlayer3MostWinDayKey]];
	[prefs setInteger:m_nPlayer3MostWinChips forKey:[GameScore GetPlayer3MostWinChipsKey]];
    
	[prefs setInteger:m_nPlayer3ChipBalance forKey:[GameScore GetPlayer3ChipBalanceKey]];
	[prefs setInteger:m_nPlayer3LastPlayResult forKey:[GameScore GetPlayer3LastPlayResultKey]];
}

- (void)SaveGameType:(NSUserDefaults*)prefs
{
	[prefs setInteger:m_nGameType forKey:[GameScore GetGameTypeKey]];
	[prefs setInteger:m_nGameTheme forKey:[GameScore GetGameThemeKey]];
	[prefs setInteger:m_nOfflineBetWay forKey:[GameScore GetOfflineBetKey]];
    
    [prefs setBool:m_bSound forKey:[GameScore GetSoundKey]];
    
    [prefs setInteger:m_nPlayTurnType forKey:[GameScore GetPlayTurnTypeKey]];
    m_nSaveRecord += 1;
    [prefs setInteger:m_nSaveRecord forKey:[GameScore GetSaveRecordKey]];
}

- (void)Save
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self SaveMeDate:prefs];
	[self SavePlayer1Date:prefs];
	[self SavePlayer2Date:prefs];
	[self SavePlayer3Date:prefs];
    [self SaveGameType:prefs];
    [prefs synchronize];
}

- (void)LoadMeDate:(NSUserDefaults*)prefs
{
	m_nMyMostWinYear = (int)[prefs integerForKey:[GameScore GetMyMostWinYearKey]];
	m_nMyMostWinMonth = (int)[prefs integerForKey:[GameScore GetMyMostWinMonthKey]];
	m_nMyMostWinDay = (int)[prefs integerForKey:[GameScore GetMyMostWinDayKey]];
	m_nMyMostWinChips = (int)[prefs integerForKey:[GameScore GetMyMostWinChipsKey]];
    
	m_nMyChipBalance = (int)[prefs integerForKey:[GameScore GetMyChipBalanceKey]];
	m_nMyLastPlayResult = (int)[prefs integerForKey:[GameScore GetMyLastPlayResultKey]];
}

- (void)LoadPlayer1Date:(NSUserDefaults*)prefs
{
	m_nPlayer1MostWinYear = (int)[prefs integerForKey:[GameScore GetPlayer1MostWinYearKey]];
	m_nPlayer1MostWinMonth = (int)[prefs integerForKey:[GameScore GetPlayer1MostWinMonthKey]];
	m_nPlayer1MostWinDay = (int)[prefs integerForKey:[GameScore GetPlayer1MostWinDayKey]];
	m_nPlayer1MostWinChips = (int)[prefs integerForKey:[GameScore GetPlayer1MostWinChipsKey]];
    
	m_nPlayer1ChipBalance = (int)[prefs integerForKey:[GameScore GetPlayer1ChipBalanceKey]];
	m_nPlayer1LastPlayResult = (int)[prefs integerForKey:[GameScore GetPlayer1LastPlayResultKey]];
}

- (void)LoadPlayer2Date:(NSUserDefaults*)prefs
{
	m_nPlayer2MostWinYear = (int)[prefs integerForKey:[GameScore GetPlayer2MostWinYearKey]];
	m_nPlayer2MostWinMonth = (int)[prefs integerForKey:[GameScore GetPlayer2MostWinMonthKey]];
	m_nPlayer2MostWinDay = (int)[prefs integerForKey:[GameScore GetPlayer2MostWinDayKey]];
	m_nPlayer2MostWinChips = (int)[prefs integerForKey:[GameScore GetPlayer2MostWinChipsKey]];
    
	m_nPlayer2ChipBalance = (int)[prefs integerForKey:[GameScore GetPlayer2ChipBalanceKey]];
	m_nPlayer2LastPlayResult = (int)[prefs integerForKey:[GameScore GetPlayer2LastPlayResultKey]];
}

- (void)LoadPlayer3Date:(NSUserDefaults*)prefs
{
	m_nPlayer3MostWinYear = (int)[prefs integerForKey:[GameScore GetPlayer3MostWinYearKey]];
	m_nPlayer3MostWinMonth = (int)[prefs integerForKey:[GameScore GetPlayer3MostWinMonthKey]];
	m_nPlayer3MostWinDay = (int)[prefs integerForKey:[GameScore GetPlayer3MostWinDayKey]];
	m_nPlayer3MostWinChips = (int)[prefs integerForKey:[GameScore GetPlayer3MostWinChipsKey]];
    
	m_nPlayer3ChipBalance = (int)[prefs integerForKey:[GameScore GetPlayer3ChipBalanceKey]];
	m_nPlayer3LastPlayResult = (int)[prefs integerForKey:[GameScore GetPlayer3LastPlayResultKey]];
}

- (void)LoadGameType:(NSUserDefaults*)prefs
{
    m_nGameType = (int)[prefs integerForKey:[GameScore GetGameTypeKey]];
    m_nGameTheme = (int)[prefs integerForKey:[GameScore GetGameThemeKey]];
	m_nOfflineBetWay = (int)[prefs integerForKey:[GameScore GetOfflineBetKey]];
    
    if([[[prefs dictionaryRepresentation] allKeys] containsObject:[GameScore GetSoundKey]] == NO)
    {
        m_bSound = YES; //(int)PUZZLE_BUBBLE_COLOR;
    }
    else
    {
        m_bSound = [prefs boolForKey:[GameScore GetSoundKey]];
    }
    m_nSaveRecord = (int)[prefs integerForKey:[GameScore GetSaveRecordKey]];

    if([[[prefs dictionaryRepresentation] allKeys] containsObject:[GameScore GetPlayTurnTypeKey]] == NO)
    {
        m_nPlayTurnType = GAME_PLAYTURN_TYPE_SEQUENCE;
    }
    else
    {
        m_nPlayTurnType = (int)[prefs integerForKey:[GameScore GetPlayTurnTypeKey]];

    }
}

- (void)Load
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[self LoadMeDate:prefs];
	[self LoadPlayer1Date:prefs];
	[self LoadPlayer2Date:prefs];
	[self LoadPlayer3Date:prefs];
    [self LoadGameType:prefs];
}	

+(NSString*)GetMyMostWinYearKey
{
    return @"sgw_key_mymostwin_year";
}

+(NSString*)GetMyMostWinMonthKey
{
    return @"sgw_key_mymostwin_month";
}

+(NSString*)GetMyMostWinDayKey
{
    return @"sgw_key_mymostwin_day";
}

+(NSString*)GetMyMostWinChipsKey
{
    return @"sgw_key_mymostwin_chips";
}

+(NSString*)GetMyChipBalanceKey
{
    return @"sgw_key_mychipbalance";
}

+(NSString*)GetMyLastPlayResultKey
{
    return @"sgw_key_mylastresult";
}

+(NSString*)GetPlayer1MostWinYearKey
{
    return @"sgw_key_player1mostwin_year";
}

+(NSString*)GetPlayer1MostWinMonthKey
{
    return @"sgw_key_player1mostwin_month";
}

+(NSString*)GetPlayer1MostWinDayKey
{
    return @"sgw_key_player1mostwin_day";
}

+(NSString*)GetPlayer1MostWinChipsKey
{
    return @"sgw_key_player1mostwin_chips";
}

+(NSString*)GetPlayer1ChipBalanceKey
{
    return @"sgw_key_player1chipbalance";
}

+(NSString*)GetPlayer1LastPlayResultKey
{
    return @"sgw_key_player1lastresult";
}


+(NSString*)GetPlayer2MostWinYearKey
{
    return @"sgw_key_player2mostwin_year";
}

+(NSString*)GetPlayer2MostWinMonthKey
{
    return @"sgw_key_player2mostwin_month";
}

+(NSString*)GetPlayer2MostWinDayKey
{
    return @"sgw_key_player2mostwin_day";
}

+(NSString*)GetPlayer2MostWinChipsKey
{
    return @"sgw_key_player2mostwin_chips";
}

+(NSString*)GetPlayer2ChipBalanceKey
{
    return @"sgw_key_player2chipbalance";
}

+(NSString*)GetPlayer2LastPlayResultKey
{
    return @"sgw_key_player2lastresult";
}

+(NSString*)GetPlayer3MostWinYearKey
{
    return @"sgw_key_player3mostwin_year";
}

+(NSString*)GetPlayer3MostWinMonthKey
{
    return @"sgw_key_player3mostwin_month";
}

+(NSString*)GetPlayer3MostWinDayKey
{
    return @"sgw_key_player3mostwin_day";
}

+(NSString*)GetPlayer3MostWinChipsKey
{
    return @"sgw_key_player3mostwin_chips";
}

+(NSString*)GetPlayer3ChipBalanceKey
{
    return @"sgw_key_player3chipbalance";
}

+(NSString*)GetPlayer3LastPlayResultKey
{
    return @"sgw_key_player3lastresult";
}

+(NSString*)GetGameTypeKey
{
    return @"sgw_key_gametype";
}

+(NSString*)GetGameThemeKey
{
    return @"sgw_key_gametheme";
}


+(NSString*)GetOfflineBetKey
{
    return @"sgw_key_offlinebetway";
}

+(NSString*)GetSaveRecordKey
{
    return @"sgw_key_savedrecord";
}

+(NSString*)GetSoundKey
{
    return @"sgw_key_soundenable";
}

+(NSString*)GetPlayTurnTypeKey
{
    return @"sgw_key_playturntype";
}

#define XGADGET_ONLINE_USER_NICKNAME_KEY        @"GAME_ONLINE_USER_NICKNAME_KEY_20120806121618_0001"
#define XGADGET_ONLINE_USER_PLAYERID_KEY        @"GAME_ONLINE_USER_PLAYERID_KEY_20120806121730_0002"

+(void)SetOnlineNickName:(NSString*)szName
{
    [[NSUserDefaults standardUserDefaults] setObject:szName forKey:XGADGET_ONLINE_USER_NICKNAME_KEY];
}

+(NSString*)GetOnlineNickName
{
    NSString* nsName = [[NSUserDefaults standardUserDefaults] stringForKey:XGADGET_ONLINE_USER_NICKNAME_KEY];
    return nsName;
}

+(BOOL)HasOnlineNickName
{
    NSString* nsName = [[NSUserDefaults standardUserDefaults] stringForKey:XGADGET_ONLINE_USER_NICKNAME_KEY];
    if(nsName != nil)
        return YES;
    
    return NO;
}

+(void)SetOnlinePlayerID:(NSString*)szID
{
    [[NSUserDefaults standardUserDefaults] setObject:szID forKey:XGADGET_ONLINE_USER_PLAYERID_KEY];
}

+(NSString*)GetOnlinePlayerID
{
    NSString* nsID = [[NSUserDefaults standardUserDefaults] stringForKey:XGADGET_ONLINE_USER_PLAYERID_KEY];
    return nsID;
}

+(BOOL)HasOnlinePlayerID
{
    NSString* nsID = [[NSUserDefaults standardUserDefaults] stringForKey:XGADGET_ONLINE_USER_PLAYERID_KEY];
    if(nsID != nil)
        return YES;
    
    return NO;
}

#define XGADGET_GAMBLEWHEEL_AWSSERVICE_KEY        @"GAME_GAMBLEWHEEL_ONLINE_ENABLE_KEY_20120806171440_0001"

+(void)SetAWSServiceEnable:(BOOL)bEnable
{
    [[NSUserDefaults standardUserDefaults] setBool:!bEnable forKey:XGADGET_GAMBLEWHEEL_AWSSERVICE_KEY];
}

+(BOOL)IsAWSServiceEnable
{
    BOOL bRet = YES;
    bRet =  ![[NSUserDefaults standardUserDefaults] boolForKey:XGADGET_GAMBLEWHEEL_AWSSERVICE_KEY];
    return bRet;
}

@end
