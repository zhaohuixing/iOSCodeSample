//
//  StringFactory.m
//  MindFire
//
//  Created by Zhaohui Xing on 10-05-12.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "StringFactory.h"
#import "ApplicationConfigure.h"
//#import "GameConstants.h"

#define LANGID_EN	0
#define LANGID_FR	1
#define LANGID_GR	2
#define LANGID_JP	3
#define LANGID_ES	4
#define LANGID_IT	5
#define LANGID_PT	6
#define LANGID_KO	7
#define LANGID_ZH	8
#define LANGID_RU	9


@implementation StringFactory

+(BOOL)IsNeedToCareLang
{
    BOOL bRet = NO;
    
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_ZH || nID == LANGID_RU || nID == LANGID_ES || nID == LANGID_PT || nID == LANGID_KO)
		bRet = YES;
    
    return bRet;
}

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

+(BOOL)IsOSLangRU
{
	BOOL bRet = NO;
	
	int nID = [StringFactory GetString_OSLangID];
	if(nID == LANGID_RU)
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
	else if([str isEqualToString:@"9"] == YES)
		nRet = LANGID_RU;
	
	return nRet;
}	

+(NSString*)GetString_ClickToEarn
{
	NSString* str = @"Click to Earn!";
	
	//Localization string query here
	str = NSLocalizedString(@"Click to Earn!", @"Click to Earn! string");
	
	return str;
}

+(NSString*)GetString_Congratulation
{
	NSString* str = @"Congratulation!";
	
	//Localization string query here
	str = NSLocalizedString(@"Congratulation!", @"Congratulation! string");
	
	return str;
}

+(NSString*)GetString_OfflineMySelfID
{
	NSString* str = @"Me";
	
	//Localization string query here
	str = NSLocalizedString(@"Me", @"Me string");
	
	return str;
}

+(NSString*)GetString_OfflinePlayer1ID
{
	NSString* str = @"RoPa1";
	
	//Localization string query here
	str = NSLocalizedString(@"RoPa1", @"RoPa1 string");
	
	return str;
}

+(NSString*)GetString_OfflinePlayer2ID
{
	NSString* str = @"RoPa2";
	
	//Localization string query here
	str = NSLocalizedString(@"RoPa2", @"RoPa2 string");
	
	return str;
}

+(NSString*)GetString_OfflinePlayer3ID
{
	NSString* str = @"RoPa3";
	
	//Localization string query here
	str = NSLocalizedString(@"RoPa3", @"RoPa2 string");
	
	return str;
}

+(NSString*)GetString_RoPaPledgeMethodLabel
{
	NSString* str = @"RoPa Bet Method";
	
	//Localization string query here
	str = NSLocalizedString(@"RoPa Bet Method", @"RoPa Bet Method string");
	
	return str;
}

+(NSString*)GetString_Automatically
{
	NSString* str = @"Automatically";
	
	//Localization string query here
	str = NSLocalizedString(@"Automatically", @"Automatically string");
	
	return str;
}

+(NSString*)GetString_Manually
{
	NSString* str = @"Manually";
	
	//Localization string query here
	str = NSLocalizedString(@"Manually", @"Manually string");
	
	return str;
}

+(NSString*)GetString_Chips
{
	NSString* str = @"Chips";
	
	//Localization string query here
	str = NSLocalizedString(@"Chips", @"Chips string");
	
	return str;
}

+(NSString*)GetString_Earn
{
	NSString* str = @"Earn";
	
	//Localization string query here
	str = NSLocalizedString(@"Earn", @"Earn string");
	
	return str;
}

+(NSString*)GetString_SendMoney
{
	NSString* str = @"Transfer";
	
	//Localization string query here
	str = NSLocalizedString(@"Transfer", @"Transfer string");
	
	return str;
}

+(NSString*)GetString_BiggestWin
{
	NSString* str = @"Biggest Win";
	
	//Localization string query here
	str = NSLocalizedString(@"Biggest Win", @"Biggest Win string");
	
	return str;
}

+(NSString*)GetString_LatestPlay
{
	NSString* str = @"Latest Play";
	
	//Localization string query here
	str = NSLocalizedString(@"Latest Play", @"Latest Play string");
	
	return str;
}


+(NSString*)GetString_OnlineGamePlayLabel
{
	NSString* str = @"Game Play";
	
	//Localization string query here
	str = NSLocalizedString(@"Game Play", @"Game Play string");
	
	return str;
}

+(NSString*)GetString_OnlineGamePlayByMaxBet
{
	NSString* str = @"By Biggest Pledge";
	
	//Localization string query here
	str = NSLocalizedString(@"By Biggest Pledge", @"By Biggest Pledge string");
	
	return str;
}

+(NSString*)GetString_OnlineGamePlayBySequence
{
	NSString* str = @"By Sequence";
	
	//Localization string query here
	str = NSLocalizedString(@"By Sequence", @"By Sequence string");
	
	return str;
}

+(NSString*)GetString_FriendLabel
{
	NSString* str = @"Friends";
	str = NSLocalizedString(@"Friends", @"Friends label string");
    return str;
}

+(NSString*)GetString_PlayerListLabel
{
	NSString* str = @"Other players";
	
	str = NSLocalizedString(@"Other players", @"Other players label string");
    return str;
}

+(NSString*)GetString_OverallLabel
{
	NSString* str = @"Overall";
	
	str = NSLocalizedString(@"Overall", @"Overall players label string");
    return str;
}

//
//In App Purchase related localization strings
//
+(NSString*)GetString_AskString
{
	NSString* str = @"AskString";
	
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
	NSString* str = @"Nothanks";
	
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

+(NSString*)GetString_OnlineGameInvitationAskFormt
{
    NSString* str = @"OnlineGameInvitationAskFormt";
    str = NSLocalizedString(@"OnlineGameInvitationAskFormt", @"OnlineGameInvitationAskFormt label string");
    return str;
}

+(NSString*)GetString_CreateNewLobby
{
	NSString* str = @"Create New Online Game";
	
	str = NSLocalizedString(@"Create New Online Game", @"Create New Online Game label string");
    
    return str;
}

+(NSString*)GetString_SearchLobby
{
	NSString* str = @"Search Online Game";
	
	str = NSLocalizedString(@"Search Online Game", @"Search Online Game label string");
    
    return str;
}

+(NSString*)GetString_GameLobby
{
	NSString* str = @"Online Game";
	
	str = NSLocalizedString(@"Online Game", @"Online Game label string");
    
    return str;
}

+(NSString*)GetString_TryAgain
{
	NSString* str = @"Try Agin";
	
	str = NSLocalizedString(@"Try Agin", @"Try Agin label string");
    
    return str;
}

+(NSString*)GetString_GameCenterAccessFailedFormat
{
	NSString* str = @"Game Center acccess is failed for";
	
	str = NSLocalizedString(@"Game Center acccess is failed for", @"Game Center acccess is failed forn label string");
    
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

+(NSString*)GetString_PlayerSendMoneyToOtherFmt
{
    NSString* str = @"%@ sent %i chips to %@.";
    
	str = NSLocalizedString(@"%@ sent %i chips to %@.", @"PlayerSendMoneyToOtherFmt string");
    
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

+(NSString*)GetString_GameURL
{
    return @"http://itunes.apple.com/us/app/easy-gamble-wheel/id492115652?ls=1&mt=8";
}

+(NSString*)GetString_GameTitle
{
	NSString* str = @"Easy Gamble Wheel";
	
	//Localization string query here
	str = NSLocalizedString(@"Easy Gamble Wheel", @"Easy Gamble Wheel  string");
	
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

+(NSString*)GetString_Spinning
{
	NSString* str = @"Spinning...";
	
	//Localization string query here
	str = NSLocalizedString(@"Spinning...", @"Spinning... string");
	
	return str;
}

+(NSString*)GetString_PlayTurnIsSequence
{
	NSString* str = @"Game turn is made by sequence.";
	
	//Localization string query here
	str = NSLocalizedString(@"Game turn is made by sequence.", @"Game turn is made by sequence. string");
	
	return str;
}

+(NSString*)GetString_PlayTurnIsMaxBet
{
	NSString* str = @"Game turn is made by maxmum bet.";
	
	//Localization string query here
	str = NSLocalizedString(@"Game turn is made by maxmum bet.", @"Game turn is made by maxmum bet. string");
	
	return str;
}

+(NSString*)GetString_ItIsPlayTurnFmt
{
	NSString* str = @"It is %@'s turn.";
	
	//Localization string query here
	str = NSLocalizedString(@"It is %@'s turn.", @"It is %@'s turn string");
	
	return str;
}

+(NSString*)GetString_YouWin
{
	NSString* str = @"I win!";
	
	//Localization string query here
	str = NSLocalizedString(@"I win!", @"I win! string");
	
	return str;
}

+(NSString*)GetString_YouLose
{
	NSString* str = @"Too bad!";
	
	//Localization string query here
	str = NSLocalizedString(@"Too bad!", @"Too bad! string");
	
	return str;
}

+(NSString*)GetString_OtherStillPlaying
{
	NSString* str = @"Others are still playing.";
	
	//Localization string query here
	str = NSLocalizedString(@"Others are still playing.", @"Others are still playing. string");
	
	return str;
}

+(NSString*)GetString_PlayingDone
{
	NSString* str = @"Done.";
	
	//Localization string query here
	str = NSLocalizedString(@"Done.", @"Done. string");
	
	return str;
}

+(NSString*)GetString_SortPlayers
{
	NSString* str = @"Sorting players...";
	
	//Localization string query here
	str = NSLocalizedString(@"Sorting players...", @"Sorting players... string");
	
	return str;
}

+(NSString*)GetString_Pledge
{
	NSString* str = @"Pledging...";
	
	//Localization string query here
	str = NSLocalizedString(@"Pledging...", @"Pledging... string");
	
	return str;
}

+(NSString*)GetString_OtherPlayes
{
	NSString* str = @"other players";
	
	//Localization string query here
	str = NSLocalizedString(@"other players", @"other players string");
	
	return str;
}

+(NSString*)GetString_BlueTooth
{
	NSString* str = @"Bluetooth";
	
	str = NSLocalizedString(@"Bluetooth", @"Bluetooth string");
    
    return str;
}

+(NSString*)GetString_AskClickToEarnChip
{
	NSString* str = @"AskClickToEarnChip";
	
	str = NSLocalizedString(@"AskClickToEarnChip", @"AskClickToEarnChip string");
    
    return str;
}

+(NSString*)GetString_FcebookSuggestionToEarnChip
{
	NSString* str = @"FcebookSuggestionToEarnChip";
	
	str = NSLocalizedString(@"FcebookSuggestionToEarnChip", @"FcebookSuggestionToEarnChip string");
    
    return str;
}

+(NSString*)GetString_NickName
{
	NSString* str = @"Nick Name";
	
	str = NSLocalizedString(@"Nick Name", @"Nick Name string");
    
    return str;
}

+(NSString*)GetString_SendInvitation
{
	NSString* str = @"Send Invitation";
	
	str = NSLocalizedString(@"Send Invitation", @"Send Invitation string");
    
    return str;
}

+(NSString*)GetString_Accept
{
	NSString* str = @"Accept";
	
	str = NSLocalizedString(@"Accept", @"Accept string");
    
    return str;
}

+(NSString*)GetString_Reject
{
	NSString* str = @"Reject";
	
	str = NSLocalizedString(@"Reject", @"Reject string");
    
    return str;
}

+(NSString*)GetString_ReceiveInvitationFormatString
{
	NSString* str = @"ReceiveInvitationFormatString";
	
	str = NSLocalizedString(@"ReceiveInvitationFormatString", @"ReceiveInvitationFormatString string");
    
    return str;
}

+(NSString*)GetString_FreeOnlineGame
{
	NSString* str = @"Free Online Game";
	
	str = NSLocalizedString(@"Free Online Game", @"Free Online Game string");
    
    return str;
}

+(NSString*)GetString_Me
{
	NSString* str = @"Me";
	
	str = NSLocalizedString(@"Me", @"Me string");
    
    return str;
}

+(NSString*)GetString_SendInvitationStringFMT
{
	NSString* str = @"SendInvitationStringFMT";
	
	str = NSLocalizedString(@"SendInvitationStringFMT", @"SendInvitationStringFMT string");
    
    return str;
}

+(NSString*)GetString_SentInvitationRejected
{
	NSString* str = @"SentInvitationRejected";
	
	str = NSLocalizedString(@"Sent invitation is rejected.", @"Sent invitation is rejected! string");
    
    return str;
}

+(NSString*)GetString_SentInvitationAccepted
{
	NSString* str = @"SentInvitationAccepted";
	
	str = NSLocalizedString(@"Sent invitation is accepted.", @"Sent invitation is accepted. string");
    
    return str;
}

+(NSString*)GetString_InvitationCancelledStringFMT
{
	NSString* str = @"InvitationCancelledStringFMT";
	
	str = NSLocalizedString(@"InvitationCancelledStringFMT", @"InvitationCancelledStringFMT string");
    
    return str;
}

+(NSString*)GetString_AskEnableFreeOnlineGameOption
{
	NSString* str = @"AskEnableFreeOnlineGameOption";
	
	str = NSLocalizedString(@"AskEnableFreeOnlineGameOption", @"AskEnableFreeOnlineGameOption string");
    
    return str;
}

+(NSString*)GetString_CheckOnlinePlayers
{
	NSString* str = @"CheckOnlinePlayers";
	
	str = NSLocalizedString(@"CheckOnlinePlayers", @"CheckOnlinePlayers string");
    
    return str;
}

+(NSString*)GetString_InAppPurchaseItemName:(int)nIndex
{
	NSString* str = @"1000 game chips package";
	
    switch(nIndex)
    {
        case 0:
            str = NSLocalizedString(@"1000 game chips package", @"1000 game chips package string");
            break;
        case 1:
            str = NSLocalizedString(@"2100 game chips package", @"2100 game chips package string");
            break;
        case 2:
            str = NSLocalizedString(@"3200 game chips package", @"3200 game chips package string");
            break;
        case 3:
            str = NSLocalizedString(@"4400 game chips package", @"4400 game chips package string");
            break;
        case 4:
            str = NSLocalizedString(@"5800 game chips package", @"5800 game chips package string");
            break;
        case 5:
            str = NSLocalizedString(@"7600 game chips package", @"7600 game chips package string");
            break;
        case 6:
            str = NSLocalizedString(@"9200 game chips package", @"9200 game chips package string");
            break;
        case 7:
            str = NSLocalizedString(@"10400 game chips package", @"10400 game chips package string");
            break;
        case 8:
            str = NSLocalizedString(@"11800 game chips package", @"11800 game chips package string");
            break;
        case 9:
            str = NSLocalizedString(@"13600 game chips package", @"13600 game chips package string");
            break;
    
    }
    return str;
}

+(NSString*)GetString_WeShareOnMap
{
	NSString* str = @"WeShareOnMap";
	
	str = NSLocalizedString(@"WeShareOnMap", @"WeShareOnMap string");
    
    return str;
}

+(NSString*)GetString_WeConnectOnMap
{
	NSString* str = @"WeConnectOnMap";
	
	str = NSLocalizedString(@"WeConnectOnMap", @"WeConnectOnMap string");
    
    return str;
}

//
//////////////////////////////////////////////////////////
//

@end
