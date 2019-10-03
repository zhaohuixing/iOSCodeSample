//
//  StringFactory.h
//  XXXX
//
//  Created by Zhaohui Xing on 2010-05-12.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

// The helper class to return localized string
// for the game. Current it is hardcode english string
//and update later
@interface StringFactory : NSObject 
{
}

//Localization string
+(BOOL)IsOSLangEN;
+(BOOL)IsOSLangFR;
+(BOOL)IsOSLangGR;
+(BOOL)IsOSLangJP;
+(BOOL)IsOSLangES;
+(BOOL)IsOSLangIT;
+(BOOL)IsOSLangTHAI;

+(int)GetString_OSLangID;
+(NSString*)GetString_Game;
+(NSString*)GetString_Start;
+(NSString*)GetString_Reset;
+(NSString*)GetString_Stop;
+(NSString*)GetString_Pause;
+(NSString*)GetString_Resume;
+(NSString*)GetString_Setting;
+(NSString*)GetString_Time;
+(NSString*)GetString_Sound;
+(NSString*)GetString_Level;
+(NSString*)GetString_Skill;
+(NSString*)GetString_Score;
+(NSString*)GetString_Configuration;
+(NSString*)GetString_Background;
+(NSString*)GetString_PaperBackground;

+(NSString*)GetString_LevelOne:(BOOL)bDefault;
+(NSString*)GetString_LevelTwo:(BOOL)bDefault;
+(NSString*)GetString_LevelThree:(BOOL)bDefault;
+(NSString*)GetString_LevelFour:(BOOL)bDefault;
+(NSString*)GetString_LevelString:(int)nLevel withDefault:(BOOL)bDefault;

+(NSString*)GetString_LevelOneAbv;
+(NSString*)GetString_LevelTwoAbv;
+(NSString*)GetString_LevelThreeAbv;
+(NSString*)GetString_LevelFourAbv;
+(NSString*)GetString_LevelStringAbv:(int)nLevel;


+(NSString*)GetString_SkillOne:(BOOL)bDefault;
+(NSString*)GetString_SkillTwo:(BOOL)bDefault;
+(NSString*)GetString_SkillThree:(BOOL)bDefault;
+(NSString*)GetString_SkillString:(int)nSkill withDefault:(BOOL)bDefault;

+(NSString*)GetString_SkillOneAbv;
+(NSString*)GetString_SkillTwoAbv;
+(NSString*)GetString_SkillThreeAbv;
+(NSString*)GetString_SkillStringAbv:(int)nSkill;

+(NSString*)GetString_PreferenceKeyPrefix:(int)nIndex;
+(NSString*)GetString_PreferenceScoreKey:(int)nIndex;
+(NSString*)GetString_PreferencePointKey:(int)nIndex;

+(NSString*)GetString_PreferenceLastWinSkillKey;
+(NSString*)GetString_PreferenceLastWinLevelKey;
+(NSString*)GetString_PreferenceSkillKey;
+(NSString*)GetString_PreferenceLevelKey;
+(NSString*)GetString_PreferenceSoundKey;
+(NSString*)GetString_PreferenceBackgroundKey;
+(NSString*)GetString_PreferenceThunderThemeKey;
+(NSString*)GetString_PreferenceClockKey;
+(NSString*)GetString_PurchaseStateKey;

+(NSString*)GetString_PreferenceTotalScoreKey;

+(NSString*)GetString_UptoLimit:(int)nLimit;
+(NSString*)GetString_NetworkWarn;

+(NSString*)GetString_Share;
+(NSString*)GetString_SharingLang;
+(NSString*)GetString_SharingOption;
+(NSString*)GetString_SharingLangName;

+(NSString*)GetString_PostTitle:(BOOL)bDefault;
+(NSString*)GetString_MyLastWin:(BOOL)bDefault;
+(NSString*)GetString_MyTodayWin:(BOOL)bDefault;
+(NSString*)GetString_MyTotalWin:(BOOL)bDefault;
+(NSString*)GetString_NoRecordPostWarn:(BOOL)bDefault;
+(NSString*)GetString_GameTitle:(BOOL)bDefault;
+(NSString*)GetString_GameURL;
+(NSString*)GetString_FBUserMsgPrompt:(BOOL)bDefault;

+(NSString*)GetString_SocialNetwork;

//In App Purchase related localization strings
+(NSString*)GetString_BuyIt;
+(NSString*)GetString_AskString;
+(NSString*)GetString_Purchase;
+(NSString*)GetString_NoThanks;
+(NSString*)GetString_CannotPayment;
+(NSString*)GetString_BuyConfirm;
+(NSString*)GetString_BuyFailure;

+(NSString*)GetString_TotalPlay;

+(NSString*)GetString_AchievementOneTitle;
+(NSString*)GetString_AchievementTwoTitle;
+(NSString*)GetString_AchievementThreeTitle;
+(NSString*)GetString_AchievementFourTitle;

+(NSString*)GetString_CreateNewLobby;
+(NSString*)GetString_SearchLobby;
+(NSString*)GetString_GameLobby;

+(NSString*)GetString_ClickToClose;

+(NSString*)GetString_OK;
+(NSString*)GetString_Cancel;
+(NSString*)GetString_Yes;
+(NSString*)GetString_No;
+(NSString*)GetString_Close;
+(NSString*)GetString_TryAgain;
+(NSString*)GetString_CurrentGame;
+(NSString*)GetString_NextLevelGame;
+(NSString*)GetString_PostGameScore;
+(NSString*)GetString_ShareGameResult;
+(NSString*)GetString_GameTotalScoreTitle;

+(NSString*)GetString_EmailFailed;

+(NSString*)GetString_ILikeGame;

+(NSString*)GetString_Email;
+(NSString*)GetString_SMS;
+(NSString*)GetString_MessageFailed;
+(NSString*)GetString_TellFriends;
+(NSString*)GetString_PostScore;
+(NSString*)GetString_CannotPlayerSelectedGame;

+(NSString*)GetString_FriendLabel;
+(NSString*)GetString_PlayerListLabel;

+(NSString*)GetString_WinningScore;
+(NSString*)GetString_LostScore;
+(NSString*)GetString_PlayingScore;
+(NSString*)GetString_Me;
+(NSString*)GetString_Congratulation;

+(NSString*)GetString_Achievement1Key;
+(NSString*)GetString_Achievement2Key;
+(NSString*)GetString_Achievement3Key;
+(NSString*)GetString_Achievement4Key;

+(NSString*)GetString_RestorePurchase;
+(NSString*)GetString_AskAWSService;

+(NSString*)GetString_ReviewGamerOnlineStatus;
+(NSString*)GetString_StartOnlineGame;

+(NSString*)GetString_AskAWSServiceEnableKey;
+(NSString*)GetString_AWSServiceFailureMessage;

+(NSString*)GetString_Won;
+(NSString*)GetString_Lost;

@end
