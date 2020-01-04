//
//  StringFactory.m
//  MindFire
//
//  Created by Zhaohui Xing on 10-05-12.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "StringFactory.h"
#import "ApplicationConfigure.h"
#include "GameState.h"

#define LANGID_EN	0
#define LANGID_FR	1
#define LANGID_GR	2
#define LANGID_JP	3
#define LANGID_ES	4
#define LANGID_IT	5
#define LANGID_PT	6
#define LANGID_KO	7
#define LANGID_ZH	8


@implementation StringFactory



+(BOOL)IsOSLangZH
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_ZH)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangES
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_ES)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangIT
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_IT)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangPT
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_PT)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangKO
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_KO)
		bRet = YES;
	
	return bRet;
}


+(BOOL)IsOSLangEN
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_EN)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangFR
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_FR)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangGR
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_GR)
		bRet = YES;
	
	return bRet;
}

+(BOOL)IsOSLangJP
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_JP)
		bRet = YES;
	
	return bRet;
}


+(int)GetString_OSLangID
{
	int nRet = LANGID_EN;
	NSString* str = @"OS_LANGSETTING";
	
	//Localization string query here
	str = NSLocalizedString(@"OS_LANGSETTING", @"Start label string");
	
	if([str isEqualToString:@"0"] == YES)
		nRet = LANGID_EN;
	else if([str isEqualToString:@"1"] == YES)
		nRet = LANGID_FR;
	else if([str isEqualToString:@"2"] == YES)
		nRet = LANGID_GR;
	else if([str isEqualToString:@"3"] == YES)
		nRet = LANGID_JP;
	else if([str isEqualToString:@"4"] == YES)
		nRet = LANGID_ES;
	else if([str isEqualToString:@"5"] == YES)
		nRet = LANGID_IT;
	else if([str isEqualToString:@"6"] == YES)
		nRet = LANGID_PT;
	else if([str isEqualToString:@"7"] == YES)
		nRet = LANGID_KO;
	else if([str isEqualToString:@"8"] == YES)
		nRet = LANGID_ZH;
    
	
	return nRet;
}	


+(NSString*)GetString_YouWin
{
	NSString* str = @"YOU WIN!";
	
	//Localization string query here
	str = NSLocalizedString(@"YOU WIN!", @"You win label string");
	
	return str;
}

+(NSString*)GetString_YouLose
{
	NSString* str = @"YOU LOSE!";
	
	//Localization string query here
	str = NSLocalizedString(@"YOU LOSE!", @"You lose label string");
	
	return str;
}	


//Score UI localization string
+(NSString*)GetString_NoScore
{
	NSString* str = @"No Score Record";
	
	//Localization string query here
	str = NSLocalizedString(@"No Score Record", @"No-record label string");
	
	return str;
}

+(NSString*)GetString_PointTitle:(int)nPoint
{
	NSString* strPoint = [StringFactory GetString_PointsLabel];//[StringFactory GetString_Point];
	NSString* str = [NSString stringWithFormat:@"%i %@", nPoint, strPoint];
        
	return str;
}	

+(NSString*)GetString_ScoreTitleString:(int)nPoint withSpeed:(int)nSpeed
{
    NSString* szBase = [StringFactory GetString_PointTitle:nPoint];
    if(nSpeed == GAME_SPEED_SLOW)
    {
        szBase = [NSString stringWithFormat:@"%@/%@", szBase, [StringFactory GetString_Slow]];
    }
    else if(nSpeed == GAME_SPEED_FAST)
    {
        szBase = [NSString stringWithFormat:@"%@/%@", szBase, [StringFactory GetString_Fast]];
    }
    return szBase;
}


+(NSString*)GetString_N_PointTitle
{
	NSString* strPoint = [StringFactory GetString_PointsLabel];//[StringFactory GetString_Point];
	NSString* str = [NSString stringWithFormat:@"N-%@", strPoint];
    
	return str;
}

+(NSString*)GetString_LastScoreLabel
{
	NSString* str = @"Last Score";

	//Localization string query here
	str = NSLocalizedString(@"Last score", @"Last Score label string");
	
	return str;
}

+(NSString*)GetString_HighScoreLabel
{
	NSString* str = @"Highest Score";
	
	//Localization string query here
	str = NSLocalizedString(@"Highest Score", @"Highest Score label string");
	
	return str;
}

+(NSString*)GetString_HighScoreTime
{
	NSString* str = @"Highest Score Time";
	
	//Localization string query here
	str = NSLocalizedString(@"Highest Score Time", @"Highest Score Time label string");
	
	return str;
}

+(NSString*)GetString_AveScoreLabel
{
	NSString* str = @"Average Score";

	//Localization string query here
	str = NSLocalizedString(@"Average Score", @"Average Score Time label string");
	
	return str;
}

+(NSString*)GetString_PlaysLabel
{
	NSString* str = @"Play Number";
	
	//Localization string query here
	str = NSLocalizedString(@"Play Number", @"Play Number label string");
	
	return str;
}	

+(NSString*)GetString_CustomizedPoints
{
	NSString* str = @"Customized";
	
	//Localization string query here
	str = NSLocalizedString(@"Customized", @"Customized label string");
	
	return str;
}

+(NSString*)GetString_PointsLabel
{
	NSString* str = @"Points";
	
	//Localization string query here
	str = NSLocalizedString(@"Points", @"Points label string");
	
	return str;
}

+(NSString*)GetString_PointString:(int)nPoint
{
	NSString* str = [NSString stringWithFormat:@"%i", nPoint];
	return str;
}	


//The game key prefix for preference storage
+(NSString*)GetString_PerfKeyPrefix
{
	NSString* str = @"PANDACARDS_KEY_";
	
	return str;
}	

//The game current active point key for preference storage
+(NSString*)GetString_GamePointKey
{
	NSString* str = @"PANDACARDS_KEY_CURRENTPOINT";
	
	return str;
}	

+(NSString*)GetString_GameSpeedKey
{
	NSString* str = @"PANDACARDS_KEY_CURRENTSPEED";
	
	return str;
}

//The game score record number key for preference storage
+(NSString*)GetString_ScoreNumberKey
{
	NSString* str = @"PANDACARDS_KEY_SCORENUMBER";
	
	return str;
}	

+(NSString*)GetString_PurchaseStateKey
{
	NSString* str = @"PANDACARDS_KEY_PURCHASESTATE";
	
	return str;
}	

+(NSString*)GetString_GameBackgroundKey
{
	NSString* str = @"PANDACARDS_KEY_GAMEBACKGROUND";
	
	return str;
}

+(NSString*)GetString_ScoreIndexKeyPrefix:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"PANDACARDS_KEY_SCOREINDEX_%i_", scoreIndex]; 
	
	return str;
}	

+(NSString*)GetString_ScorePointKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"POINT"]; 
	
	return str;
}

+(NSString*)GetString_ScoreSpeedKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"SPEED"]; 
	
	return str;
}

+(NSString*)GetString_ScoreLastKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"LASTSCORE"]; 
	
	return str;
}

+(NSString*)GetString_ScoreHighestKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"HIGHSCORE"]; 
	
	return str;
}

+(NSString*)GetString_ScoreAverageKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"AVERAGESCORE"]; 
	
	return str;
}

+(NSString*)GetString_ScorePlayKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"PLAYNUMBER"]; 
	
	return str;
}

+(NSString*)GetString_ScoreYearHighKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"HIGHSCORE_YEAR"]; 
	
	return str;
}

+(NSString*)GetString_ScoreMonthHighKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"HIGHSCORE_MONTH"]; 
	
	return str;
}	
 
+(NSString*)GetString_ScoreDayHighKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"HIGHSCORE_DAY"]; 
	
	return str;
}	

+(NSString*)GetString_ScoreTotalWinCountKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"TOTALWINSCORE"]; 
	
	return str;
}


+(NSString*)GetString_AskString
{
	NSString* str = @"AskPurchase";
	
	//Localization string query here
	str = NSLocalizedString(@"AskString", @"AskString string");
	
	return str;
}

+(NSString*)GetString_Purchase
{
	NSString* str = @"Purchase";
	
	//Localization string query here
	str = NSLocalizedString(@"Purchase", @"Purchase string");
	
	return str;
}

+(NSString*)GetString_NoThanks
{
	NSString* str = @"No thanks!";
	
	//Localization string query here
	str = NSLocalizedString(@"NoThanks", @"No thanks string");
	
	return str;
}	

+(NSString*)GetString_CannotPayment
{
	NSString* str = @"CannotPayment";
	
	//Localization string query here
	str = NSLocalizedString(@"CannotPayment", @"CannotPayment string");
	
	return str;
}	

+(NSString*)GetString_BuyConfirm
{
	NSString* str = @"BuyConfirm";
	
	//Localization string query here
	str = NSLocalizedString(@"BuyConfirm", @"BuyConfirm string");
	
	return str;
}

+(NSString*)GetString_BuyFailure
{
	NSString* str = @"TransactionFailure";
	
	//Localization string query here
	str = NSLocalizedString(@"TransactionFailure", @"TransactionFailure string");
	
	return str;
}	

+(NSString*)GetString_BuyIt
{
	NSString* str = @"Buy it!";
	
	//Localization string query here
	str = NSLocalizedString(@"BuyIt", @"Buy it string");
	
	return str;
}	

+(NSString*)GetString_GameTitle:(BOOL)bDefault
{
	NSString* str = @"Panda Cards";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Mind Fire", @"Flying Cow <lite> label string");
	
	if([ApplicationConfigure iPADDevice])
		str = [str stringByAppendingString:@" iPad"];
	else	
		str = [str stringByAppendingString:@" iPhone"];
    
	return str;
}	

+(NSString*)GetString_GameURL
{
	NSString* str = @"http://itunes.apple.com/us/app/panda-cards/id517550842";
	return str;
}	

+(NSString*)GetString_FBUserMsgPrompt:(BOOL)bDefault
{
	NSString* str = @"Share On Facebook";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Share On Facebook", @"Share On Facebook label string");
	
	return str;
}	

+(NSString*)GetString_PostTitle:(BOOL)bDefault
{
	NSString* str = @"Playing game <Mind Fire>";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Playing game <Mind Fire>", @"PostTitle label string");
    
	if([ApplicationConfigure iPADDevice])
		str = [str stringByAppendingString:@" iPad"];
	else	
		str = [str stringByAppendingString:@" iPhone"];
    
    
	return str;
}	

+(NSString*)GetString_NetworkWarn
{
	NSString* str = @"NetworkWarn";
	
	//Localization string query here
	str = NSLocalizedString(@"NetworkWarn", @"NetworkWarn label string");
	if(str == @"")
    {
        str = @"This free version game requires internet connection。";
    }
        
	return str;
}

+(NSString*)GetString_SocialNetwork
{
    NSString* str = @"Social network";
    str = NSLocalizedString(@"Social network", @"Social network label string");
    return str;
}

+(NSString*)GetString_CreateNewLobby
{
	NSString* str = @"Create New Game Lobby";
	
	str = NSLocalizedString(@"Create New Game Lobby", @"Create New Game Lobby label string");
    
    return str;
}

+(NSString*)GetString_SearchLobby
{
	NSString* str = @"Search Game Lobby";
	
	str = NSLocalizedString(@"Search Game Lobby", @"Search Game Lobby label string");
    
    return str;
}

+(NSString*)GetString_GameLobby
{
	NSString* str = @"Game Lobby";
	
	str = NSLocalizedString(@"Game Lobby", @"Game Lobby label string");
    
    return str;
}


+(NSString*)GetString_TellFriends
{
	NSString* str = @"Tell Friend";
	
	str = NSLocalizedString(@"Tell Friend", @"Tell Friend string");
    
    return str;
}

+(NSString*)GetString_PostScore
{
	NSString* str = @"Post Score";
	
	str = NSLocalizedString(@"Post Score", @"Post Score string");
    
    return str;
}

+(NSString*)GetString_Location
{
	NSString* str = @"Location";
	
	str = NSLocalizedString(@"Location", @"Location string");
    
    return str;
}

+(NSString*)GetString_Message
{
	NSString* str = @"Message";
	
	str = NSLocalizedString(@"Message", @"Message string");
    
    return str;
}

+(NSString*)GetString_Send
{
	NSString* str = @"Send";
	
	str = NSLocalizedString(@"Send", @"Send string");
    
    return str;
}

+(NSString*)GetString_EmailFailed
{
	NSString* str = @"EmailFailed";
	
	//Localization string query here
	str = NSLocalizedString(@"EmailFailed", @"EmailFailed string");
	
	return str;
}

+(NSString*)GetString_MessageFailed
{
	NSString* str = @"MessageFailed";
	
	//Localization string query here
	str = NSLocalizedString(@"MessageFailed", @"EmailFailed string");
	
	return str;
}

+(NSString*)GetString_ILikeGame
{
	NSString* str = @"I like game";
	
	//Localization string query here
	str = NSLocalizedString(@"I like game", @"I like game  string");
	
	return str;
}

+(NSString*)GetString_Email
{
	NSString* str = @"E-mail";
	
	//Localization string query here
	str = NSLocalizedString(@"E-mail", @"E-mail  string");
	
	return str;
}

+(NSString*)GetString_SMS
{
	NSString* str = @"SMS";
	
	//Localization string query here
	str = NSLocalizedString(@"SMS", @"SMS string");
	
	return str;
}


+(NSString*)GetString_OK
{
	NSString* str = @"OK";
	
	str = NSLocalizedString(@"OK", @"OK string");
    
    return str;
}

+(NSString*)GetString_Cancel
{
	NSString* str = @"Cancel";
	
	str = NSLocalizedString(@"Cancel", @"Cancel string");
    
    return str;
}

+(NSString*)GetString_Yes
{
	NSString* str = @"Yes";
	
	str = NSLocalizedString(@"Yes", @"Yes string");
    
    return str;
}

+(NSString*)GetString_No
{
	NSString* str = @"No";
	
	str = NSLocalizedString(@"No", @"No string");
    
    return str;
}

+(NSString*)GetString_Close
{
	NSString* str = @"Close";
	
	str = NSLocalizedString(@"Close", @"Close string");
    
    return str;
}

+(NSString*)GetString_TryAgain
{
	NSString* str = @"Try Agin";
	
	str = NSLocalizedString(@"Try Agin", @"Try Agin label string");
    
    return str;
}


+(NSString*)GetString_None
{
	NSString* str = @"None";
	
	str = NSLocalizedString(@"None", @"None label string");
    
    return str;
}

+(NSString*)GetString_Slow
{
	NSString* str = @"Slow";
	
	str = NSLocalizedString(@"Slow", @"Slow label string");
    
    return str;
}

+(NSString*)GetString_Fast
{
	NSString* str = @"Fast";
	
	str = NSLocalizedString(@"Fast", @"Fast label string");
    
    return str;
}

+(NSString*)GetString_PaidFeature
{
	NSString* str = @"Paid Feature";
	
	str = NSLocalizedString(@"Paid Feature", @"Paid Feature label string");
    
    return str;
}

+(NSString*)GetString_BuyItSuggestion
{
	NSString* str = @"BuyItSuggestion";
	
	str = NSLocalizedString(@"BuyItSuggestion", @"BuyItSuggestion string");
    
    return str;
}

+(NSString*)GetString_PurchaseDone
{
	NSString* str = @"PurchaseDone";
	
	str = NSLocalizedString(@"PurchaseDone", @"PurchaseDone string");
    
    return str;
}

+(NSString*)GetString_PlayerListLabel
{
	NSString* str = @"Player";
	
	str = NSLocalizedString(@"Player", @"Player string");
    
    return str;
}

+(NSString*)GetString_FriendLabel
{
	NSString* str = @"Friend";
	
	str = NSLocalizedString(@"Friend", @"Friend string");
    
    return str;
}

+(NSString*)GetString_BlueTooth
{
	NSString* str = @"Bluetooth";
	
	str = NSLocalizedString(@"Bluetooth", @"Bluetooth string");
    
    return str;
}

+(NSString*)GetString_ClickToClose
{
	NSString* str = @"ClickToClose";
	
	str = NSLocalizedString(@"ClickToClose", @"ClickToClose string");
    
    return str;
}

+(NSString*)GetString_AccessPaidFeature
{
	NSString* str = @"AccessPaidFeature";
	
	str = NSLocalizedString(@"AccessPaidFeature", @"AccessPaidFeature string");
    
    return str;
}

+(NSString*)GetString_YouCanAccessNextDaysFormat
{
	NSString* str = @"YouCanAccessNextDaysFormat";
	
	str = NSLocalizedString(@"YouCanAccessNextDaysFormat", @"YouCanAccessNextDaysFormat string");
    
    return str;
}

+(NSString*)GetString_YouCanAccessOneTime
{
	NSString* str = @"YouCanAccessOneTime";
	
	str = NSLocalizedString(@"YouCanAccessOneTime", @"YouCanAccessOneTime string");
    
    return str;
}

+(NSString*)GetString_SuggestTemporaryAccess
{
	NSString* str = @"SuggestTemporaryAccess";
	
	str = NSLocalizedString(@"SuggestTemporaryAccess", @"SuggestTemporaryAccess string");
    
    return str;
}

+(BOOL)IsSupportClickRedeem
{
    BOOL bRet = NO;
    
    if([StringFactory IsOSLangZH] || [StringFactory IsOSLangKO] || [StringFactory IsOSLangPT] || [StringFactory IsOSLangES] || [StringFactory IsOSLangFR] || [StringFactory IsOSLangIT])
        return YES;
    
    return bRet;
}

@end
