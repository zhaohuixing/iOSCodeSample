//
//  StringFactory.m
//  MindFire
//
//  Created by Zhaohui Xing on 10-05-12.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "StringFactory.h"
#import "ApplicationConfigure.h"
#import "GameConstants.h"
#import "BTFileConstant.h"

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


+(NSString*)GetString_LeastStepLabel
{
	NSString* str = @"Least Step";
	
	//Localization string query here
	str = NSLocalizedString(@"Least Step", @"Least Step string");
	
	return str;
}

+(NSString*)GetString_WinCountLabel
{
	NSString* str = @"Total Archivement";
	
	//Localization string query here
	str = NSLocalizedString(@"Total Archivement", @"Total Archivement string");
	
	return str;
}


//The game key prefix for preference storage
+(NSString*)GetString_PerfKeyPrefix
{
	NSString* str = @"BUBBLETILE_KEY_";
	
	return str;
}	

//The game score record number key for preference storage
+(NSString*)GetString_ScoreNumberKey
{
	NSString* str = @"BUBBLETILE_KEY_SCORENUMBER";
	
	return str;
}	

+(NSString*)GetString_PurchaseStateKey
{
	NSString* str = @"BUBBLETILE_KEY_PURCHASESTATE";
	
	return str;
}	

+(NSString*)GetString_PurchaseSquareStateKey
{
	NSString* str = @"BUBBLETILE_KEY_PURCHASESQUARESTATE";
	
	return str;
}

+(NSString*)GetString_PurchaseDiamondStateKey
{
	NSString* str = @"BUBBLETILE_KEY_PURCHASEDIAMONDSTATE";
	
	return str;
    
}

+(NSString*)GetString_PurchaseHexagonStateKey
{
	NSString* str = @"BUBBLETILE_KEY_PURCHASEHEXAGONSTATE";
	
	return str;
}

+(NSString*)GetString_DefaultGameKey
{
	NSString* str = @"BUBBLETILE_KEY_DEFAULT_GAME";
	
	return str;
}

+(NSString*)GetString_DefaultTypeKey
{
	NSString* str = @"BUBBLETILE_KEY_DEFAULT_TYPE";
	
	return str;
}

+(NSString*)GetString_DefaultLayoutKey
{
	NSString* str = @"BUBBLETILE_KEY_DEFAULT_LAYOUT";
	
	return str;
}

+(NSString*)GetString_DefaultEdgeKey
{
	NSString* str = @"BUBBLETILE_KEY_DEFAULT_EDGE";
	
	return str;
}

+(NSString*)GetString_DefaultLevelKey
{
	NSString* str = @"BUBBLETILE_KEY_DEFAULT_LEVEL";
	
	return str;
}


+(NSString*)GetString_ScoreIndexKeyPrefix:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"BUBBLETILE_KEY_SCOREINDEX_%i_", scoreIndex]; 
	
	return str;
}	

+(NSString*)GetString_GameTypeKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"GAME"]; 
	
	return str;
}

+(NSString*)GetString_GridTypeKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"TYPE"]; 
	
	return str;
}

+(NSString*)GetString_GridLayoutKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"LAYOUT"]; 
	
	return str;
}

+(NSString*)GetString_GridEdgeKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"EDGE"]; 
	
	return str;
}

+(NSString*)GetString_GameLeastKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"LEASTSTEP"]; 
	
	return str;
}

+(NSString*)GetString_GameYearLeastKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"LEASTSTEP_YEAR"]; 
	
	return str;
}

+(NSString*)GetString_GameMonthLeastKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"LEASTSTEP_MONTH"]; 
	
	return str;
}

+(NSString*)GetString_GameDayLeastKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"LEASTSTEP_DAY"]; 
	
	return str;
}

+(NSString*)GetString_ScoreTotalWinCountKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"WINCOUNT"]; 
	
	return str;
}

+(NSString*)GetString_ScoreLevelKey:(int)scoreIndex
{
	NSString* str = [NSString stringWithFormat:@"%@%@", [StringFactory GetString_ScoreIndexKeyPrefix:scoreIndex], @"LEVEL"]; 
	
	return str;
}

+(NSString*)GetString_BubbleTypeKey
{
	NSString* str = @"BUBBLETILE_KEY_BUBBLE_TYPE";
	
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


+(NSString*)GetString_PaidFeatureAsk
{
	NSString* str = @"This feature is available in paid version. Do you want to purchase paid version?";
	
	//Localization string query here
	str = NSLocalizedString(@"PaidFeatureAsk", @"PaidFeatureAsk string");
	
	return str;
}

+(NSString*)GetString_GameTitle:(BOOL)bDefault
{
	NSString* str = @"Bubble Tile";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Bubble Tile", @"Bubble Tile label string");
	
	if([ApplicationConfigure iPADDevice])
		str = [str stringByAppendingString:@" iPad"];
	else	
		str = [str stringByAppendingString:@" iPhone"];
    
	return str;
}	

+(NSString*)GetString_GameURL
{
	NSString* str = @"http://itunes.apple.com/us/app/bubble-tile/id445302495";
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
	NSString* str = @"Playing game <Bubble Tile>";
	
	//Localization string query here
	if(bDefault == NO)
		str = NSLocalizedString(@"Playing game <Bubble Tile>", @"PostTitle label string");
    
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

+(NSString*)GetString_Triangle
{
    NSString* str = @"Triangle";
    str = NSLocalizedString(@"Triangle", @"Triangle label string");
    return str;
}

+(NSString*)GetString_Square
{
    NSString* str = @"Square";
    str = NSLocalizedString(@"Square", @"Square label string");
    return str;
}

+(NSString*)GetString_Diamond
{
    NSString* str = @"Diamond";
    str = NSLocalizedString(@"Diamond", @"Diamond label string");
    return str;
}

+(NSString*)GetString_Hexagon
{
    NSString* str = @"Hexagon";
    str = NSLocalizedString(@"Hexagon", @"Hexagon label string");
    return str;
}

+(NSString*)GetString_Parallel
{
    NSString* str = @"Parallel";
    str = NSLocalizedString(@"Parallel", @"Parallel label string");
    return str;
}

+(NSString*)GetString_Zigzag
{
    NSString* str = @"Zigzag";
    str = NSLocalizedString(@"Zigzag", @"Zigzag label string");
    return str;
}

+(NSString*)GetString_Spiral
{
    NSString* str = @"Spiral";
    str = NSLocalizedString(@"Spiral", @"Spiral label string");
    return str;
}

+(NSString*)GetString_GridTypeString:(int)nType
{
    NSString* sType = @"Triangle";
    switch ((enGridType)nType)
    {
        case PUZZLE_GRID_TRIANDLE:
            sType = [StringFactory GetString_Triangle];
            break;
        case PUZZLE_GRID_SQUARE:
            sType = [StringFactory GetString_Square];
            break;
        case PUZZLE_GRID_DIAMOND:
            sType = [StringFactory GetString_Diamond];
            break;
        case PUZZLE_GRID_HEXAGON:
            sType = [StringFactory GetString_Hexagon];
            break;
    }
    return sType;
}

+(NSString*)GetString_PuzzleString:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge
{
    NSString* sType = @"Triangle";
    switch ((enGridType)nType)
    {
        case PUZZLE_GRID_TRIANDLE:
            sType = [StringFactory GetString_Triangle];
            break;
        case PUZZLE_GRID_SQUARE:
            sType = [StringFactory GetString_Square];
            break;
        case PUZZLE_GRID_DIAMOND:
            sType = [StringFactory GetString_Diamond];
            break;
        case PUZZLE_GRID_HEXAGON:
            sType = [StringFactory GetString_Hexagon];
            break;
    }
    NSString* sLayout = @"Parallel";
    switch((enGridLayout)nLayout)
    {
        case PUZZLE_LALOUT_MATRIX:
            sLayout = [StringFactory GetString_Parallel];
            break;
        case PUZZLE_LALOUT_SNAKE:
            sLayout = [StringFactory GetString_Zigzag];
            break;
        case PUZZLE_LALOUT_SPIRAL:
            sLayout = [StringFactory GetString_Spiral];
            break;
    }
    NSString* szRet = [NSString stringWithFormat:@"%@-%i-%@", sType, nEdge, sLayout];
    return szRet;
}

+(NSString*)GetString_PurchaseFullFeature
{
    NSString* str = @"Full Game Feature";
    str = NSLocalizedString(@"Full Game Feature", @"Full Game Feature label string");
    return str;
}

+(NSString*)GetString_SquarePuzzle
{
    NSString* str = @"Square Puzzle";
    str = NSLocalizedString(@"Square Puzzle", @"Square Puzzle label string");
    return str;
}

+(NSString*)GetString_DiamondPuzzle
{
    NSString* str = @"Diamond Puzzle";
    str = NSLocalizedString(@"Diamond Puzzle", @"Diamond Puzzle label string");
    return str;
}

+(NSString*)GetString_HexagonPuzzle
{
    NSString* str = @"Hexagon Puzzle";
    str = NSLocalizedString(@"Hexagon Puzzle", @"Hexagon Puzzle label string");
    return str;
}

+(NSString*)GetString_FullPrice
{
    NSString* str = @"Full Price";
    str = NSLocalizedString(@"Full Price", @"Full Price label string");
    return str;
    
}

+(NSString*)GetString_Price
{
    NSString* str = @"Price";
    str = NSLocalizedString(@"Price", @"Price label string");
    return str;
}

+(NSString*)GetString_Easy
{
    NSString* str = @"Easy";
    str = NSLocalizedString(@"Easy", @"Easy string");
    return str;
}

+(NSString*)GetString_Difficult
{
    NSString* str = @"Difficult";
    str = NSLocalizedString(@"Difficult", @"Difficult string");
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

+(NSString*)GetString_SaveFileComfirmation
{
	NSString* str = @"Do you want save game to file for replaying and shareing?";
	
	str = NSLocalizedString(@"Do you want save game to file for replaying and sharing?", @"Do you want save game to file for replaying and shareing? string");
    
    return str;
}

//????????????
+(NSString*)GetString_Game
{
	NSString* str = @"Game";
	
	str = NSLocalizedString(@"Game", @"Game string");
    
    return str;
}

+(NSString*)GetString_Creator
{
	NSString* str = @"Creator";
	
	str = NSLocalizedString(@"Creator", @"Creator string");
    
    return str;
}

+(NSString*)GetString_CreatorEmail
{
	NSString* str = @"E-mail";
	
	str = NSLocalizedString(@"E-mail", @"E-mail string");
    
    return str;
}

+(NSString*)GetString_CreatTime
{
	NSString* str = @"Created";
	
	str = NSLocalizedString(@"Created", @"Created string");
    
    return str;
}

+(NSString*)GetString_LastUpdateTime
{
	NSString* str = @"Last Modified";
	
	str = NSLocalizedString(@"Last Modified", @"Last Modified string");
    
    return str;
}

+(NSString*)GetString_GameFileName
{
	NSString* str = @"Original File";
	
	str = NSLocalizedString(@"Original File", @"Original File string");
    
    return str;
}

+(NSString*)GetString_GPSSharingWarning
{
	NSString* str = @"LocationSharingWarning";
	
	str = NSLocalizedString(@"LocationSharingWarning", @"LocationSharingWarning File string");
    
    return str;
}

+(NSString*)GetString_ShowMe
{
	NSString* str = @"Me";
	
	str = NSLocalizedString(@"Me", @"Me string");
    
    return str;
}

+(NSString*)GetString_ShowAll
{
	NSString* str = @"All";
	
	str = NSLocalizedString(@"All", @"All string");
    
    return str;
}

+(NSString*)GetString_MapStandard
{
	NSString* str = @"Map";
	
	str = NSLocalizedString(@"Map", @"Map string");
    
    return str;
}

+(NSString*)GetString_MapSatellite
{
	NSString* str = @"Satellite";
	
	str = NSLocalizedString(@"Satellite", @"Satellite string");
    
    return str;
}

+(NSString*)GetString_MapHybird
{
	NSString* str = @"Hybird";
	
	str = NSLocalizedString(@"Hybird", @"Hybird string");
    
    return str;
}

+(NSString*)GetString_GameCreator
{
	NSString* str = @"Game Creator";
	
	str = NSLocalizedString(@"Game Creator", @"Game Creator string");
    
    return str;
}

+(NSString*)GetString_Player
{
	NSString* str = @"Player";
	
	str = NSLocalizedString(@"Player", @"Player string");
    
    return str;
}

+(NSString*)GetString_GamePlayer
{
	NSString* str = @"Game Player";
	
	str = NSLocalizedString(@"Game Player", @"Game Player string");
    
    return str;
}

+(NSString*)GetString_Record
{
	NSString* str = @"Playing Record";
	
	str = NSLocalizedString(@"Playing Record", @"Playing Record string");
    
    return str;
}

+(NSString*)GetString_Device
{
	NSString* str = @"Device";
	
	str = NSLocalizedString(@"Device", @"Device string");
    
    return str;
}

+(NSString*)GetString_AppVersion
{
	NSString* str = @"App Version";
	
	str = NSLocalizedString(@"App Version", @"App Version string");
    
    return str;
}

+(NSString*)GetString_PlayingStep
{
	NSString* str = @"Steps";
	
	str = NSLocalizedString(@"Steps", @"Steps string");
    
    return str;
}

+(NSString*)GetString_Completion
{
	NSString* str = @"Completion";
	
	str = NSLocalizedString(@"Completion", @"Completion string");
    
    return str;
}


+(NSString*)GetString_Me
{
	NSString* str = @"Me";
	
	str = NSLocalizedString(@"Me", @"Me string");
    
    return str;
}

+(NSString*)GetString_Local
{
	NSString* str = @"Local";
	
	str = NSLocalizedString(@"Local", @"Local string");
    
    return str;
}

+(NSString*)GetString_SaveGameFileIn
{
	NSString* str = @"Save game file in";
	
	str = NSLocalizedString(@"Save game file in", @"Save game file in string");
    
    return str;
}

+(NSString*)GetString_FileExistWarn
{
	NSString* str = @"File already exists.";
	
	str = NSLocalizedString(@"File already exists.", @"File already exists. string");
    
    return str;
}

+(NSString*)GetString_Overwrite
{
	NSString* str = @"Overwrite";
	
	str = NSLocalizedString(@"Overwrite", @"Overwrite string");
    
    return str;
}

+(NSString*)GetString_KeepBoth
{
	NSString* str = @"Keep both";
	
	str = NSLocalizedString(@"Keep both", @"Keep both string");
    
    return str;
}

+(NSString*)GetString_Open
{
	NSString* str = @"Open";
	
	str = NSLocalizedString(@"Open", @"Open string");
    
    return str;
}

+(NSString*)GetString_New
{
	NSString* str = @"New";
	
	str = NSLocalizedString(@"New", @"New string");
    
    return str;
}

+(NSString*)GetString_PaidFeatureInGameAsk
{
	NSString* str = @"The feature in this game file is available in paid version. Do you want to purchase paid version?";
	
	//Localization string query here
	str = NSLocalizedString(@"PaidFeatureInGameAsk", @"PaidFeatureInGameAsk string");
	
	return str;
}

+(NSString*)GetString_GameNotCompletedWarn
{
	NSString* str = @"The last play of this game is not finished, do you want to:";
	
	//Localization string query here
	str = NSLocalizedString(@"GameNotCompletedWarn", @"GameNotCompletedWarn string");
	
	return str;
}

+(NSString*)GetString_Continue
{
	NSString* str = @"Continue";
	
	//Localization string query here
	str = NSLocalizedString(@"Continue", @"Continue string");
	
	return str;
}

+(NSString*)GetString_Restart
{
	NSString* str = @"Restart";
	
	//Localization string query here
	str = NSLocalizedString(@"Restart", @"Restart string");
	
	return str;
}

+(NSString*)GetString_Share
{
	NSString* str = @"Share";
	
	//Localization string query here
	str = NSLocalizedString(@"Share", @"Share string");
	
	return str;
}

+(NSString*)GetString_EmailFailed
{
	NSString* str = @"EmailFailed";
	
	//Localization string query here
	str = NSLocalizedString(@"EmailFailed", @"EmailFailed string");
	
	return str;
}

+(NSString*)GetString_DeviceString:(int)nDeviceID
{
	NSString* str = @"";
	
	switch (nDeviceID) 
    {
        case BT_DEVICEID_IPHONE:
            str = @"iPhone/iPod Touch";
            break;
        case BT_DEVICEID_IPAD:
            str = @"iPad";
            break;
        case BT_DEVICEID_ANDROID:
            str = @"Android";
            break;
        case BT_DEVICEID_WINDOWSPHONE:
            str = @"Windows Phone";
            break;
        case BT_DEVICEID_MAC:
            str = @"MAC computer";
            break;
        case BT_DEVICEID_WINDOWS:
            str = @"Windows computer";
            break;
        case BT_DEVICEID_WEB:
            str = @"Web";
            break;
        default:
            break;
    };
    return str;
}

+(NSString*)GetString_ILikeGame
{
	NSString* str = @"I like game";
	
	//Localization string query here
	str = NSLocalizedString(@"I like game", @"I like game  string");
	
	return str;
}

+(NSString*)GetString_MessageFailed
{
	NSString* str = @"MessageFailed";
	
	//Localization string query here
	str = NSLocalizedString(@"MessageFailed", @"EmailFailed string");
	
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

+(NSString*)GetString_PurchaseSuggestion
{
	NSString* str = @"PurchaseSuggestion";
	
	str = NSLocalizedString(@"PurchaseSuggestion", @"PurchaseSuggestion string");
    
    return str;
}

+(NSString*)GetString_TryAgain
{
	NSString* str = @"Try Again";
	
	str = NSLocalizedString(@"Try Again", @"Try Agin label string");
    
    return str;
}

+(NSString*)GetString_SuggestTemporaryAccess
{
	NSString* str = @"SuggestTemporaryAccess";
	
	str = NSLocalizedString(@"SuggestTemporaryAccess", @"SuggestTemporaryAccess string");
    
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

+(NSString*)GetString_ClickToClose
{
	NSString* str = @"ClickToClose";
	
	str = NSLocalizedString(@"ClickToClose", @"ClickToClose string");
    
    return str;
}

+(NSString*)GetString_RestorePurchase
{
	NSString* str = @"RestorePurchase";
	
	str = NSLocalizedString(@"RestorePurchase", @"RestorePurchase label string");
    
    return str;
}

+(NSString*)GetString_EdgeUnit
{
	NSString* str = @"EdgeUnit";
	
	str = NSLocalizedString(@"Edge Unit", @"EdgeUnit label string");
    
    return str;
}

+(NSString*)GetString_WinningScore
{
	NSString* str = @"Earned Score";
	
	str = NSLocalizedString(@"Earned Score/Per Game", @"Earned score label string");
    
    return str;
}

+(NSString*)GetString_PostGameScore
{
	NSString* str = @"Post Game Score";
	
	str = NSLocalizedString(@"Post Game Score", @"Post Game Score label string");
    
    return str;
}

+(NSString*)GetString_Score
{
	NSString* str = @"Score";
	
	//Localization string query here
	str = NSLocalizedString(@"Score", @"Score label string");
	
	return str;
}

+(NSString*)GetString_ReviewGamerOnlineStatus
{
	NSString* str = @"ReviewGamerOnlineStatus";
	
	str = NSLocalizedString(@"ReviewGamerOnlineStatus", @"ReviewGamerOnlineStatus label string");
    return str;
}


@end
