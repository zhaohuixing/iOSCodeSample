//
//  StringFactory.m
//  XXXX
//
//  Created by Zhaohui Xing on 10-05-12.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#include "libinc.h"
#import "StringFactory.h"
#import "ApplicationConfigure.h"

#define LANGID_EN	0
#define LANGID_FR	1
#define LANGID_GR	2
#define LANGID_JP	3
#define LANGID_IT	4
#define LANGID_ES	5


@implementation StringFactory

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
		nRet = LANGID_IT;
	else if([str isEqualToString:@"5"] == YES)
		nRet = LANGID_ES;
	
	return nRet;
}	

+(NSString*)GetString_Start
{
	NSString* str = @"Start";
	
	//Localization string query here
	str = NSLocalizedString(@"Start", @"Start label string");
	
	return str;
}

+(NSString*)GetString_Reset
{
	NSString* str = @"Reset";
	
	//Localization string query here
	str = NSLocalizedString(@"Reset", @"Reset label string");
	
	return str;
}

+(NSString*)GetString_Stop
{
	NSString* str = @"Stop";
	
	//Localization string query here
	str = NSLocalizedString(@"Stop", @"Stop label string");
	
	return str;
}

+(NSString*)GetString_Pause
{
	NSString* str = @"Pause";
	
	//Localization string query here
	str = NSLocalizedString(@"Pause", @"Pause label string");
	
	return str;
}

+(NSString*)GetString_Resume
{
	NSString* str = @"Resume";
	
	//Localization string query here
	str = NSLocalizedString(@"Resume", @"Resume label string");
	
	return str;
}

+(NSString*)GetString_Setting
{
	NSString* str = @"Setting";
	
	//Localization string query here
	str = NSLocalizedString(@"Setting", @"Setting label string");
	
	return str;
}

+(NSString*)GetString_Time
{
	NSString* str = @"Time";
	
	//Localization string query here
	str = NSLocalizedString(@"Time", @"Time label string");
	
	return str;
}

+(NSString*)GetString_Sound
{
	NSString* str = @"Sound";
	
	//Localization string query here
	str = NSLocalizedString(@"Sound", @"Sound label string");
	
	return str;
}

+(NSString*)GetString_Level
{
	NSString* str = @"Level";
	
	//Localization string query here
	str = NSLocalizedString(@"Level", @"Level label string");
	
	return str;
}

+(NSString*)GetString_Skill
{
	NSString* str = @"Skill";
	
	//Localization string query here
	str = NSLocalizedString(@"Skill", @"Skill label string");
	
	return str;
}

+(NSString*)GetString_Score
{
	NSString* str = @"Score";
	
	//Localization string query here
	str = NSLocalizedString(@"Score", @"Score label string");
	
	return str;
}	

+(NSString*)GetString_Game
{
	NSString* str = @"Game";
	
	//Localization string query here
	str = NSLocalizedString(@"Game", @"Game label string");
	
	return str;
}

+(NSString*)GetString_Configuration
{
	NSString* str = @"Configuration";
	
	//Localization string query here
	str = NSLocalizedString(@"Configuration", @"Configuration label string");
	
	return str;
}	

+(NSString*)GetString_Background
{
	NSString* str = @"Background";
	
	//Localization string query here
	str = NSLocalizedString(@"Background", @"Background label string");
	
	return str;
}

+(NSString*)GetString_PaperBackground;
{
	NSString* str = @"Paper Background";
	
	//Localization string query here
	str = NSLocalizedString(@"Paper Background", @"Paper Background label string");
	
	return str;
}

+(NSString*)GetString_LevelOne:(BOOL)bDefault
{
	NSString* str = @"Level One";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Level One", @"Level One label string");
	else 
		str = @"Level One";
    
	return str;
}

+(NSString*)GetString_LevelTwo:(BOOL)bDefault
{
	NSString* str = @"Level Two";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Level Two", @"Level two label string");
	else 
		str = @"Level Two";
	
	return str;
}

+(NSString*)GetString_LevelThree:(BOOL)bDefault
{
	NSString* str = @"Level Three";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Level Three", @"Level three label string");
	else 
		str = @"Level Three";
	
	return str;
}

+(NSString*)GetString_LevelFour:(BOOL)bDefault
{
	NSString* str = @"Level Four";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Level Four", @"Level Four label string");
	else 
		str = @"Level Four";
	
	return str;
}	

+(NSString*)GetString_LevelString:(int)nLevel withDefault:(BOOL)bDefault
{
	NSString* str = @"";
    
	switch(nLevel)
	{
		case GAME_PLAY_LEVEL_ONE:
			str = [StringFactory GetString_LevelOne:bDefault];
			break;
		case GAME_PLAY_LEVEL_TWO:
			str = [StringFactory GetString_LevelTwo:bDefault];
			break;
		case GAME_PLAY_LEVEL_THREE:
			str = [StringFactory GetString_LevelThree:bDefault];
			break;
		case GAME_PLAY_LEVEL_FOUR:
			str = [StringFactory GetString_LevelFour:bDefault];
			break;
	}			
	
	return str;
}	


+(NSString*)GetString_LevelOneAbv
{
	NSString* str = @"L1";
	
	//Localization string query here
	str = NSLocalizedString(@"L1", @"L1 label string");
	
	return str;
}

+(NSString*)GetString_LevelTwoAbv
{
	NSString* str = @"L2";
	
	//Localization string query here
	str = NSLocalizedString(@"L2", @"L2 label string");
	
	return str;
}

+(NSString*)GetString_LevelThreeAbv
{
	NSString* str = @"L3";
	
	//Localization string query here
	str = NSLocalizedString(@"L3", @"L3 label string");
	
	return str;
}

+(NSString*)GetString_LevelFourAbv
{
	NSString* str = @"L4";
	
	//Localization string query here
	str = NSLocalizedString(@"L4", @"L4 label string");
	
	return str;
}

+(NSString*)GetString_LevelStringAbv:(int)nLevel
{
	NSString* str = @"";
	
	switch(nLevel)
	{
		case GAME_PLAY_LEVEL_ONE:
			str = [StringFactory GetString_LevelOneAbv];
			break;
		case GAME_PLAY_LEVEL_TWO:
			str = [StringFactory GetString_LevelTwoAbv];
			break;
		case GAME_PLAY_LEVEL_THREE:
			str = [StringFactory GetString_LevelThreeAbv];
			break;
		case GAME_PLAY_LEVEL_FOUR:
			str = [StringFactory GetString_LevelFourAbv];
			break;
	}			
	
	return str;
}	


+(NSString*)GetString_SkillOne:(BOOL)bDefault
{
	NSString* str = @"Easy";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Easy", @"Skill One label string");
	
	return str;
}

+(NSString*)GetString_SkillTwo:(BOOL)bDefault
{
	NSString* str = @"Medium";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Medium", @"Skill Two label string");
	
	return str;
}

+(NSString*)GetString_SkillThree:(BOOL)bDefault
{
	NSString* str = @"Hard";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Hard", @"Skill Three label string");
	
	return str;
}	


+(NSString*)GetString_SkillString:(int)nSkill withDefault:(BOOL)bDefault
{
	NSString* str = @"";
	
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			str = [StringFactory GetString_SkillOne:bDefault];
			break;
		case GAME_SKILL_LEVEL_TWO:
			str = [StringFactory GetString_SkillTwo:bDefault];
			break;
		case GAME_SKILL_LEVEL_THREE:
			str = [StringFactory GetString_SkillThree:bDefault];
			break;
	}			
	
	return str;
}	

+(NSString*)GetString_SkillOneAbv
{
	NSString* str = @"S1";
	
	//Localization string query here
	str = NSLocalizedString(@"S1", @"S1 label string");
	
	return str;
}

+(NSString*)GetString_SkillTwoAbv
{
	NSString* str = @"S2";
	
	//Localization string query here
	str = NSLocalizedString(@"S2", @"S2 label string");
	
	return str;
}

+(NSString*)GetString_SkillThreeAbv
{
	NSString* str = @"S3";
	
	//Localization string query here
	str = NSLocalizedString(@"S3", @"S3 label string");
	
	return str;
}

+(NSString*)GetString_SkillStringAbv:(int)nSkill
{
	NSString* str = @"";
	
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			str = [StringFactory GetString_SkillOneAbv];
			break;
		case GAME_SKILL_LEVEL_TWO:
			str = [StringFactory GetString_SkillTwoAbv];
			break;
		case GAME_SKILL_LEVEL_THREE:
			str = [StringFactory GetString_SkillThreeAbv];
			break;
	}			
	
	return str;
}

+(NSString*)GetString_PreferenceKeyPrefix:(int)nIndex
{
	NSString* str = [NSString stringWithFormat:@"CHUINIU_KEY_INDEX_%i_", nIndex]; 
	
	return str;
}

+(NSString*)GetString_PreferenceScoreKey:(int)nIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_PreferenceKeyPrefix:nIndex], @"SCORE"]; 
	
	return str;
}

+(NSString*)GetString_PreferencePointKey:(int)nIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_PreferenceKeyPrefix:nIndex], @"POINT"]; 
	
	return str;
}	

+(NSString*)GetString_PreferenceLastWinSkillKey
{
	NSString* str = @"CHUINIU_KEY_LASTWIN_SKILL"; 
	
	return str;
}

+(NSString*)GetString_PreferenceLastWinLevelKey
{
	NSString* str = @"CHUINIU_KEY_LASTWIN_LEVEL"; 
	
	return str;
}

+(NSString*)GetString_PreferenceSkillKey
{
	NSString* str = @"CHUINIU_KEY_SKILL"; 
	
	return str;
}

+(NSString*)GetString_PreferenceLevelKey
{
	NSString* str = @"CHUINIU_KEY_LEVEL"; 
	
	return str;
}

+(NSString*)GetString_PreferenceSoundKey
{
	NSString* str = @"CHUINIU_KEY_SOUND"; 
	
	return str;
}	

+(NSString*)GetString_PreferenceBackgroundKey
{
	NSString* str = @"CHUINIU_KEY_BACKGROUND_SETTING"; 
	
	return str;
}	

+(NSString*)GetString_PreferenceThunderThemeKey
{
	NSString* str = @"CHUINIU_KEY_THUNDERTHEME_SETTING"; 
	
	return str;
}

+(NSString*)GetString_PreferenceClockKey
{
	NSString* str = @"CHUINIU_KEY_CLOCK_SETTING"; 
	
	return str;
}

+(NSString*)GetString_PreferenceTotalScoreKey
{
	NSString* str = @"CHUINIU_KEY_TOTAL_SCORE"; 
	
	return str;
}

+(NSString*)GetString_PurchaseStateKey
{
	NSString* str = @"CHUINIULITE_KEY_PAYMENT_STATE"; 
	
	return str;
}

+(NSString*)GetString_UptoWord
{
	NSString* str = @"Upto";
	
	//Localization string query here
	str = NSLocalizedString(@"Upto", @"Upto label string");
	
	return str;
}	

+(NSString*)GetString_UptoLimit:(int)nLimit
{
	NSString* str = [NSString stringWithFormat:@"%@ %i", [StringFactory GetString_UptoWord], nLimit]; 
	
	return str;
}	

+(NSString*)GetString_NetworkWarn
{
	NSString* str = @"NetworkWarn";
	
	//Localization string query here
	str = NSLocalizedString(@"NetworkWarn", @"NetworkWarn label string");
	
	return str;
}	

+(NSString*)GetString_Share
{
	NSString* str = @"Share";
	
	//Localization string query here
	str = NSLocalizedString(@"Share", @"Share label string");
	
	return str;
}

+(NSString*)GetString_SharingLang
{
	NSString* str = @"Language for posting, default by English";
	
	//Localization string query here
	str = NSLocalizedString(@"Language for posting (The default is English)", @"SharingLang label string");
	
	if([StringFactory IsOSLangEN] == YES)
    {
        str = @"Language for posting";
    }    
	return str;
}

+(NSString*)GetString_SharingOption
{
	NSString* str = @"Game playing information for posting";
	
	//Localization string query here
	str = NSLocalizedString(@"Game playing information for posting", @"SharingOption label string");
	
	return str;
}

+(NSString*)GetString_SharingLangName
{
	NSString* str = @"language name for posting";
	
	//Localization string query here
	str = NSLocalizedString(@"language name", @"Sharinglangname label string");
	
	return str;
}	

+(NSString*)GetString_PostTitle:(BOOL)bDefault
{
	NSString* str = @"Playing game [Flying Cow]";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Playing game <Flying Cow/ChuiNiu>", @"PostTitle label string");
    
	if([ApplicationConfigure iPADDevice])
		str = [str stringByAppendingString:@" iPad"];
	else	
		str = [str stringByAppendingString:@" iPhone"];
    
    
	return str;
}	

+(NSString*)GetString_MyLastWin:(BOOL)bDefault
{
	NSString* str = @"My Last Win";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"My last winning score", @"MyLastWin label string");
	else 
		str = @"My last winning score";
    
	return str;
}	

+(NSString*)GetString_MyTodayWin:(BOOL)bDefault
{
	NSString* str = @"My Today Win";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"My today's winning score", @"TodayLastWin label string");
	else
		str = @"My today's winning score";
	
	return str;
}	

+(NSString*)GetString_MyTotalWin:(BOOL)bDefault
{
	NSString* str = @"My Total Win";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"My total winning score", @"My Total Win label string");
	else
		str = @"My total winning score";
	
	return str;
}	

+(NSString*)GetString_NoRecordPostWarn:(BOOL)bDefault
{
	NSString* str = @"No record to share";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"No record to share", @"No record sharing label string");
	else
		str = @"No record to share";
	
	return str;
}	

+(NSString*)GetString_GameTitle:(BOOL)bDefault
{
	NSString* str = @"Flying Cow (lite)";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Flying Cow <lite>", @"Flying Cow <lite> label string");
	
	if([ApplicationConfigure iPADDevice])
		str = [str stringByAppendingString:@" iPad"];
	else	
		str = [str stringByAppendingString:@" iPhone"];
    
	return str;
}	

+(NSString*)GetString_GameURL
{
	NSString* str = @"http://itunes.apple.com/us/app/flying-cow-chuiniu-lite-version/id396255432";
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

+(NSString*)GetString_SocialNetwork
{
	NSString* str = @"Social network";
	str = NSLocalizedString(@"Social network", @"Social network label string");
    return str;
}

+(NSString*)GetString_TotalPlay
{
	NSString* str = @"Total's play";
	
	//Localization string query here
	str = NSLocalizedString(@"Total's play", @"Total play label string");
	return str;
}

+(NSString*)GetString_AchievementOneTitle
{
	NSString* str = @"Achievement One Title";
	
	//Localization string query here
	str = NSLocalizedString(@"Achievement One Title", @"Achievement One Title's string");
	
    return str;
}

+(NSString*)GetString_AchievementTwoTitle
{
	NSString* str = @"Achievement Two Title";
	
	//Localization string query here
	str = NSLocalizedString(@"Achievement Two Title", @"Achievement Two Title's string");
	
    return str;
}

+(NSString*)GetString_AchievementThreeTitle
{
	NSString* str = @"Achievement Three Title";
	
	//Localization string query here
	str = NSLocalizedString(@"Achievement Three Title", @"Achievement Three Title's string");
	
    return str;
}

+(NSString*)GetString_AchievementFourTitle
{
	NSString* str = @"Achievement Four Title";
	
	//Localization string query here
	str = NSLocalizedString(@"Achievement Four Title", @"Achievement Four Title's string");
	
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

+(NSString*)GetString_ClickToClose
{
	NSString* str = @"ClickToClose";
	
	str = NSLocalizedString(@"ClickToClose", @"ClickToClose string");
    
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

@end
