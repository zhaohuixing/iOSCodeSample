//
//  StringFactory.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-05-12.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

@import UIKit;

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

+(NSString*)GetString_ClickToEarn;
+(NSString*)GetString_Congratulation;
+(NSString*)GetString_OfflineMySelfID;
+(NSString*)GetString_OfflinePlayer1ID;
+(NSString*)GetString_OfflinePlayer2ID;
+(NSString*)GetString_OfflinePlayer3ID;
+(NSString*)GetString_RoPaPledgeMethodLabel;
+(NSString*)GetString_Automatically;
+(NSString*)GetString_Manually;
+(NSString*)GetString_Chips;
+(NSString*)GetString_Earn;
+(NSString*)GetString_SendMoney;
+(NSString*)GetString_BiggestWin;
+(NSString*)GetString_LatestPlay;
+(NSString*)GetString_OnlineGamePlayLabel;
+(NSString*)GetString_OnlineGamePlayByMaxBet;
+(NSString*)GetString_OnlineGamePlayBySequence;

//In App Purchase related localization strings
+(NSString*)GetString_BuyIt;
+(NSString*)GetString_AskString;
+(NSString*)GetString_Purchase;
+(NSString*)GetString_NoThanks;
+(NSString*)GetString_CannotPayment;
+(NSString*)GetString_BuyConfirm;
+(NSString*)GetString_BuyFailure;

+(NSString*)GetString_FriendLabel;
+(NSString*)GetString_PlayerListLabel;
+(NSString*)GetString_OverallLabel;

+(NSString*)GetString_OK;
+(NSString*)GetString_Cancel;
+(NSString*)GetString_Yes;
+(NSString*)GetString_No;
+(NSString*)GetString_Close;

+(NSString*)GetString_NetworkWarn;
+(NSString*)GetString_SocialNetwork;

+(NSString*)GetString_OnlineGameInvitationAskFormt;

+(NSString*)GetString_CreateNewLobby;
+(NSString*)GetString_SearchLobby;
+(NSString*)GetString_GameLobby;

+(NSString*)GetString_TryAgain;
+(NSString*)GetString_GameCenterAccessFailedFormat;

+(NSString*)GetString_TellFriends;
+(NSString*)GetString_PostScore;
+(NSString*)GetString_Location;
+(NSString*)GetString_Message;
+(NSString*)GetString_Send;

+(NSString*)GetString_PlayerSendMoneyToOtherFmt;

+(NSString*)GetString_EmailFailed;
+(NSString*)GetString_MessageFailed;

+(NSString*)GetString_Email;
+(NSString*)GetString_SMS;

+(NSString*)GetString_ILikeGame;
+(NSString*)GetString_GameURL;
+(NSString*)GetString_GameTitle;

+(NSString*)GetString_Spinning;

+(NSString*)GetString_PlayTurnIsSequence;
+(NSString*)GetString_PlayTurnIsMaxBet;
+(NSString*)GetString_ItIsPlayTurnFmt;
+(NSString*)GetString_YouWin;
+(NSString*)GetString_YouLose;
+(NSString*)GetString_OtherStillPlaying;
+(NSString*)GetString_PlayingDone;
+(NSString*)GetString_SortPlayers;
+(NSString*)GetString_Pledge;
+(NSString*)GetString_OtherPlayes;

+(NSString*)GetString_BlueTooth;

+(NSString*)GetString_AskClickToEarnChip;
+(NSString*)GetString_FcebookSuggestionToEarnChip;

+(NSString*)GetString_NickName;

+(NSString*)GetString_SendInvitation;
+(NSString*)GetString_Accept;
+(NSString*)GetString_Reject;
+(NSString*)GetString_ReceiveInvitationFormatString;
+(NSString*)GetString_FreeOnlineGame;
+(NSString*)GetString_Me;
+(NSString*)GetString_SendInvitationStringFMT;
+(NSString*)GetString_SentInvitationRejected;
+(NSString*)GetString_SentInvitationAccepted;
+(NSString*)GetString_InvitationCancelledStringFMT;
+(NSString*)GetString_AskEnableFreeOnlineGameOption;

+(NSString*)GetString_CheckOnlinePlayers;

+(NSString*)GetString_InAppPurchaseItemName:(int)nIndex;

+(NSString*)GetString_WeShareOnMap;
+(NSString*)GetString_WeConnectOnMap;

@end
