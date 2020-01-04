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
+(BOOL)IsOSLangRU;
+(BOOL)IsOSLangKO;
+(int)GetString_OSLangID;
+(BOOL)IsNeedToCareLang;

//Localization string

+(NSString*)GetString_LeastStepLabel;
+(NSString*)GetString_WinCountLabel;


//Score preference storage keys' string
+(NSString*)GetString_PerfKeyPrefix;
+(NSString*)GetString_ScoreNumberKey;
+(NSString*)GetString_PurchaseStateKey;

+(NSString*)GetString_PurchaseSquareStateKey;
+(NSString*)GetString_PurchaseDiamondStateKey;
+(NSString*)GetString_PurchaseHexagonStateKey;


+(NSString*)GetString_DefaultGameKey;
+(NSString*)GetString_DefaultTypeKey;
+(NSString*)GetString_DefaultLayoutKey;
+(NSString*)GetString_DefaultEdgeKey;
+(NSString*)GetString_DefaultLevelKey;


+(NSString*)GetString_ScoreIndexKeyPrefix:(int)scoreIndex;
+(NSString*)GetString_GridTypeKey:(int)scoreIndex;
+(NSString*)GetString_GridLayoutKey:(int)scoreIndex;
+(NSString*)GetString_GridEdgeKey:(int)scoreIndex;
+(NSString*)GetString_GameLeastKey:(int)scoreIndex;
+(NSString*)GetString_GameYearLeastKey:(int)scoreIndex;
+(NSString*)GetString_GameMonthLeastKey:(int)scoreIndex;
+(NSString*)GetString_GameDayLeastKey:(int)scoreIndex;
+(NSString*)GetString_ScoreTotalWinCountKey:(int)scoreIndex;
+(NSString*)GetString_ScoreLevelKey:(int)scoreIndex;
+(NSString*)GetString_GameTypeKey:(int)scoreIndex;

+(NSString*)GetString_BubbleTypeKey;

//In App Purchase related localization strings
+(NSString*)GetString_BuyIt;
+(NSString*)GetString_AskString;
+(NSString*)GetString_Purchase;
+(NSString*)GetString_NoThanks;
+(NSString*)GetString_CannotPayment;
+(NSString*)GetString_BuyConfirm;
+(NSString*)GetString_BuyFailure;
+(NSString*)GetString_PaidFeatureAsk;
+(NSString*)GetString_PaidFeatureInGameAsk;

+(NSString*)GetString_GameTitle:(BOOL)bDefault;
+(NSString*)GetString_GameURL;
+(NSString*)GetString_FBUserMsgPrompt:(BOOL)bDefault;
+(NSString*)GetString_PostTitle:(BOOL)bDefault;


+(NSString*)GetString_NetworkWarn;
+(NSString*)GetString_SocialNetwork;


+(NSString*)GetString_GridTypeString:(int)nType;
+(NSString*)GetString_Triangle;
+(NSString*)GetString_Square;
+(NSString*)GetString_Diamond;
+(NSString*)GetString_Hexagon;
+(NSString*)GetString_Parallel;
+(NSString*)GetString_Zigzag;
+(NSString*)GetString_Spiral;

+(NSString*)GetString_PuzzleString:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge;

+(NSString*)GetString_PurchaseFullFeature;
+(NSString*)GetString_SquarePuzzle;
+(NSString*)GetString_DiamondPuzzle;
+(NSString*)GetString_HexagonPuzzle;
+(NSString*)GetString_FullPrice;
+(NSString*)GetString_Price;

+(NSString*)GetString_Easy;
+(NSString*)GetString_Difficult;

+(NSString*)GetString_FriendLabel;
+(NSString*)GetString_PlayerListLabel;
+(NSString*)GetString_OverallLabel;

+(NSString*)GetString_OK;
+(NSString*)GetString_Cancel;
+(NSString*)GetString_Yes;
+(NSString*)GetString_No;
+(NSString*)GetString_Close;

+(NSString*)GetString_SaveFileComfirmation;
+(NSString*)GetString_Game;
+(NSString*)GetString_Creator;
+(NSString*)GetString_CreatorEmail;
+(NSString*)GetString_CreatTime;
+(NSString*)GetString_LastUpdateTime;
+(NSString*)GetString_GameFileName;

+(NSString*)GetString_GameCreator;
+(NSString*)GetString_Player;
+(NSString*)GetString_GamePlayer;

+(NSString*)GetString_GPSSharingWarning;

+(NSString*)GetString_ShowMe;
+(NSString*)GetString_ShowAll;
+(NSString*)GetString_MapStandard;
+(NSString*)GetString_MapSatellite;
+(NSString*)GetString_MapHybird;

+(NSString*)GetString_Device;
+(NSString*)GetString_AppVersion;
+(NSString*)GetString_DeviceString:(int)nDeviceID;
+(NSString*)GetString_Record;
+(NSString*)GetString_PlayingStep;
+(NSString*)GetString_Completion;
+(NSString*)GetString_Me;

+(NSString*)GetString_Local;
+(NSString*)GetString_SaveGameFileIn;

+(NSString*)GetString_FileExistWarn;
+(NSString*)GetString_Overwrite;
+(NSString*)GetString_KeepBoth;

+(NSString*)GetString_Open;
+(NSString*)GetString_New;
+(NSString*)GetString_GameNotCompletedWarn;
+(NSString*)GetString_Continue;
+(NSString*)GetString_Restart;
+(NSString*)GetString_Share;

+(NSString*)GetString_EmailFailed;

+(NSString*)GetString_ILikeGame;

+(NSString*)GetString_Email;
+(NSString*)GetString_SMS;
+(NSString*)GetString_MessageFailed;
+(NSString*)GetString_TellFriends;
+(NSString*)GetString_PostScore;

+(NSString*)GetString_PurchaseSuggestion;

+(NSString*)GetString_TryAgain;

+(NSString*)GetString_SuggestTemporaryAccess;
+(NSString*)GetString_AccessPaidFeature;
+(NSString*)GetString_YouCanAccessNextDaysFormat;
+(NSString*)GetString_ClickToClose;

+(NSString*)GetString_RestorePurchase;

+(NSString*)GetString_EdgeUnit;

+(NSString*)GetString_WinningScore;

+(NSString*)GetString_PostGameScore;

+(NSString*)GetString_Score;

+(NSString*)GetString_ReviewGamerOnlineStatus;

@end
