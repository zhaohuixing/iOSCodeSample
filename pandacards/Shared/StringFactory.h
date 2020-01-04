//
//  StringFactory.h
//  MindFire
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

+(BOOL)IsOSLangZH;
+(BOOL)IsOSLangEN;
+(BOOL)IsOSLangFR;
+(BOOL)IsOSLangGR;
+(BOOL)IsOSLangJP;
+(BOOL)IsOSLangES;
+(BOOL)IsOSLangIT;
+(BOOL)IsOSLangPT;
+(BOOL)IsOSLangKO;
+(int)GetString_OSLangID;

//Localization string

//Score UI localization string
+(NSString*)GetString_NoScore;
+(NSString*)GetString_PointTitle:(int)nPoint;
+(NSString*)GetString_LastScoreLabel;
+(NSString*)GetString_HighScoreLabel;
+(NSString*)GetString_HighScoreTime;
+(NSString*)GetString_AveScoreLabel;
+(NSString*)GetString_PlaysLabel;
+(NSString*)GetString_YouWin;
+(NSString*)GetString_YouLose;

//Point setup UI localization string
+(NSString*)GetString_CustomizedPoints;
+(NSString*)GetString_PointsLabel;
+(NSString*)GetString_PointString:(int)nPoint;
+(NSString*)GetString_ScoreTitleString:(int)nPoint withSpeed:(int)nSpeed;
+(NSString*)GetString_N_PointTitle;


//Score preference storage keys' string
+(NSString*)GetString_PerfKeyPrefix;
+(NSString*)GetString_GamePointKey;
+(NSString*)GetString_GameSpeedKey;
+(NSString*)GetString_ScoreNumberKey;
+(NSString*)GetString_PurchaseStateKey;
+(NSString*)GetString_GameBackgroundKey;


+(NSString*)GetString_ScoreIndexKeyPrefix:(int)scoreIndex;
+(NSString*)GetString_ScorePointKey:(int)scoreIndex;
+(NSString*)GetString_ScoreSpeedKey:(int)scoreIndex;
+(NSString*)GetString_ScoreLastKey:(int)scoreIndex;
+(NSString*)GetString_ScoreHighestKey:(int)scoreIndex;
+(NSString*)GetString_ScoreAverageKey:(int)scoreIndex;
+(NSString*)GetString_ScorePlayKey:(int)scoreIndex;
+(NSString*)GetString_ScoreYearHighKey:(int)scoreIndex;
+(NSString*)GetString_ScoreMonthHighKey:(int)scoreIndex;
+(NSString*)GetString_ScoreDayHighKey:(int)scoreIndex;
+(NSString*)GetString_ScoreTotalWinCountKey:(int)scoreIndex;

//In App Purchase related localization strings
+(NSString*)GetString_BuyIt;
+(NSString*)GetString_AskString;
+(NSString*)GetString_Purchase;
+(NSString*)GetString_NoThanks;
+(NSString*)GetString_CannotPayment;
+(NSString*)GetString_BuyConfirm;
+(NSString*)GetString_BuyFailure;


+(NSString*)GetString_GameTitle:(BOOL)bDefault;
+(NSString*)GetString_GameURL;
+(NSString*)GetString_FBUserMsgPrompt:(BOOL)bDefault;
+(NSString*)GetString_PostTitle:(BOOL)bDefault;


+(NSString*)GetString_NetworkWarn;
+(NSString*)GetString_SocialNetwork;

+(NSString*)GetString_CreateNewLobby;
+(NSString*)GetString_SearchLobby;
+(NSString*)GetString_GameLobby;

+(NSString*)GetString_TellFriends;
+(NSString*)GetString_PostScore;
+(NSString*)GetString_Location;
+(NSString*)GetString_Message;
+(NSString*)GetString_Send;
+(NSString*)GetString_EmailFailed;
+(NSString*)GetString_MessageFailed;
+(NSString*)GetString_Email;
+(NSString*)GetString_SMS;
+(NSString*)GetString_ILikeGame;

+(NSString*)GetString_OK;
+(NSString*)GetString_Cancel;
+(NSString*)GetString_Yes;
+(NSString*)GetString_No;
+(NSString*)GetString_Close;
+(NSString*)GetString_TryAgain;

+(NSString*)GetString_None;
+(NSString*)GetString_Slow;
+(NSString*)GetString_Fast;

+(NSString*)GetString_PaidFeature;
+(NSString*)GetString_BuyItSuggestion;
+(NSString*)GetString_PurchaseDone;

+(NSString*)GetString_PlayerListLabel;
+(NSString*)GetString_FriendLabel;
+(NSString*)GetString_BlueTooth;

+(NSString*)GetString_ClickToClose;

+(NSString*)GetString_AccessPaidFeature;

+(NSString*)GetString_YouCanAccessNextDaysFormat;
+(NSString*)GetString_YouCanAccessOneTime;
+(NSString*)GetString_SuggestTemporaryAccess;


+(BOOL)IsSupportClickRedeem;
@end
