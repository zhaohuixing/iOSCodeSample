//
//  GameScore.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-05-11.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "GameScore.h"
#import "StringFactory.h"
#import "ApplicationConfigure.h"
#import "GameConstants.h"
#import "GameConfiguration.h"

#define PRODUCT_FREE			0
#define	PRODUCT_PAID			1

static GameScore* g_Score;

static BOOL     g_bDisableAWSService = NO;


@implementation GameScore

@synthesize			m_bPaid;
@synthesize			m_bSquarePaid;
@synthesize			m_bDiamondPaid;
@synthesize			m_bHexagonPaid;
@synthesize         m_nDefaultType;
@synthesize			m_nDefaultLayout;
@synthesize			m_nDefaultEdge;
@synthesize			m_nDefaultBubble;
@synthesize         m_nDefaultLevel;
@synthesize         m_nDefaultGame;

-(id)init
{
	if((self = [super init]))
	{
		m_Scores = [[NSMutableArray array] retain];
		//if([ApplicationConfigure GetAdViewsState] == NO)
        //{    
       //     m_bPaid = PRODUCT_PAID;
        //}    
        //else
        //{    
        //    m_bPaid = PRODUCT_FREE;
        //}    
        m_bPaid = PRODUCT_FREE;
        m_bSquarePaid = PRODUCT_FREE;
        m_bDiamondPaid = PRODUCT_FREE;
        m_bHexagonPaid = PRODUCT_FREE;
            
        m_nDefaultType = (int)PUZZLE_GRID_TRIANDLE;
        m_nDefaultLayout = (int)PUZZLE_LALOUT_MATRIX;
        m_nDefaultEdge = MIN_BUBBLE_UNIT;
        m_nDefaultBubble = (int)PUZZLE_BUBBLE_COLOR;
        m_nDefaultLevel = 0;
        m_nDefaultGame = (int)GAME_BUBBLE_TILE;
	}	
	
	return self;
}	

- (void)dealloc 
{
	[m_Scores release];
    [super dealloc];
}

- (void)CreateScoreRecord:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType
{
	ScoreRecord* score = [[ScoreRecord alloc] initRecord:nType withLayout:nLayout withEdge:nEdge withLevel:nLevel withGameType:gameType];
	[m_Scores addObject:score];
}

- (int)GetScoreCount
{
	int nRet = [m_Scores count];
	return nRet;
}	

- (int)CheckScoreRecord:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType
{
	int nRet = -1;
	
	for (int i = 0; i < [m_Scores count]; ++i)
	{
		if([(ScoreRecord*)[m_Scores objectAtIndex:i] IsSame:nType withLayout:nLayout withEdge:nEdge withLevel:nLevel withGameType:gameType] == YES)
		{
			nRet = i;
		}	
	}	
	return nRet;
}

- (void)AddScore:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withScore:(int)nStep withLevel:(int)nLevel withGameType:(int)gameType
{
	int nRet = -1;
	
	for (int i = 0; i < [m_Scores count]; ++i)
	{
		if([(ScoreRecord*)[m_Scores objectAtIndex:i] IsSame:nType withLayout:nLayout withEdge:nEdge withLevel:nLevel withGameType:gameType] == YES)
		{
			[(ScoreRecord*)[m_Scores objectAtIndex:i] AddScore:nStep];
			nRet = i;
		}	
	}	
	
	if(nRet == -1)
	{
		ScoreRecord* score = [[[ScoreRecord alloc] initRecord:nType withLayout:nLayout withEdge:nEdge withLevel:nLevel withGameType:gameType] autorelease];
		[score AddScore:nStep];
		[m_Scores addObject:score];
	}
	[self SaveScoresToPreference];
}

- (void)Reset
{
	[m_Scores removeAllObjects];
}

-(void)LoadScore:(NSUserDefaults*)prefs withIndex:(int)index
{
	ScoreRecord* score = [[[ScoreRecord alloc] init] autorelease];
	[score LoadScore:prefs scoreIndex:index];
	[m_Scores addObject:score];
}	

-(void)LoadGameScores:(NSUserDefaults*)prefs
{
	NSString* sKey = [StringFactory GetString_ScoreNumberKey];	
	int nCount = [prefs integerForKey:sKey];
	if(0 < nCount)
	{	
		for(int i = 0; i < nCount; ++i)
		{
			[self LoadScore:prefs withIndex:i];
		}	
	}	
}

- (void)LoadDefaultSetting:(NSUserDefaults*)prefs
{
    NSString* sKey = [StringFactory GetString_DefaultTypeKey];
    m_nDefaultType = [prefs integerForKey:sKey];
    if(m_nDefaultType < 0)
        m_nDefaultType = (int)PUZZLE_GRID_TRIANDLE;
    
    sKey = [StringFactory GetString_DefaultLayoutKey];
    m_nDefaultLayout = [prefs integerForKey:sKey];
    if(m_nDefaultLayout < 0)
        m_nDefaultLayout = (int)PUZZLE_LALOUT_MATRIX;
    
    sKey = [StringFactory GetString_DefaultEdgeKey];
    m_nDefaultEdge = [prefs integerForKey:sKey];
    if(m_nDefaultEdge <= 0)
        m_nDefaultEdge = MIN_BUBBLE_UNIT;
    
    sKey = [StringFactory GetString_DefaultLevelKey];
    m_nDefaultLevel = [prefs integerForKey:sKey];
    if(m_nDefaultLevel <= 0)
        m_nDefaultLevel = 0;
    
    sKey = [StringFactory GetString_BubbleTypeKey];
    m_nDefaultBubble = [prefs integerForKey:sKey]; 
    if(m_nDefaultBubble <= 0)
        m_nDefaultBubble = (int)PUZZLE_BUBBLE_COLOR;

    sKey = [StringFactory GetString_DefaultGameKey];
    m_nDefaultGame = [prefs integerForKey:sKey];
    if(m_nDefaultGame < 0)
        m_nDefaultGame = (int)GAME_BUBBLE_TILE;
}

-(void)LoadDefaultConfigure
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self LoadDefaultSetting:prefs];
}


- (void)LoadScoresFromPreference
{
	[m_Scores removeAllObjects];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	m_bPaid = 0;
	m_bPaid = [prefs integerForKey:[StringFactory GetString_PurchaseStateKey]];
	
    m_bSquarePaid = PRODUCT_FREE;
    m_bSquarePaid = [prefs integerForKey:[StringFactory GetString_PurchaseSquareStateKey]];
    m_bDiamondPaid = PRODUCT_FREE;
    m_bDiamondPaid = [prefs integerForKey:[StringFactory GetString_PurchaseDiamondStateKey]];
    m_bHexagonPaid = PRODUCT_FREE;
    m_bHexagonPaid = [prefs integerForKey:[StringFactory GetString_PurchaseDiamondStateKey]];
    
    [self LoadDefaultSetting:prefs];
    
    [self LoadGameScores:prefs];
}

- (ScoreRecord*)GetScoreRecord:(int)index
{
	ScoreRecord* score = nil;
    
	if(0 <= index && index < [m_Scores count])
	{
		score = (ScoreRecord*)[m_Scores objectAtIndex:index];
	}	
	
	return score;
}

- (ScoreRecord*)GetScoreRecordByInfo:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType 
{
	ScoreRecord* score = nil;
    
	for (int i = 0; i < [m_Scores count]; ++i)
	{
		if([(ScoreRecord*)[m_Scores objectAtIndex:i] IsSame:nType withLayout:nLayout withEdge:nEdge withLevel:nLevel withGameType:gameType] == YES)
		{
            score = (ScoreRecord*)[m_Scores objectAtIndex:i]; 
			return score;
		}	
	}	
	
	return score;
}


- (void)LoadPaymentState
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	m_bPaid = 0;
	m_bPaid = [prefs integerForKey:[StringFactory GetString_PurchaseStateKey]];
}

-(void)SaveGameScores:(NSUserDefaults*)prefs
{
	int nCount = [m_Scores count];
	
	if(0 < nCount)
	{	
		NSString* sKey = [StringFactory GetString_ScoreNumberKey];	
		[prefs setInteger:nCount forKey:sKey];
		for(int i = 0; i < nCount; ++i)
		{
			[(ScoreRecord*)[m_Scores objectAtIndex:i] SaveScore:prefs scoreIndex:i];
		}	
	}
}	


-(void)SaveDefaultSetting:(NSUserDefaults*)prefs
{
    NSString* sKey = [StringFactory GetString_DefaultTypeKey];
    [prefs setInteger:m_nDefaultType forKey:sKey];
    
    sKey = [StringFactory GetString_DefaultLayoutKey];
    [prefs setInteger:m_nDefaultLayout forKey:sKey];
    
    sKey = [StringFactory GetString_DefaultEdgeKey];
    [prefs setInteger:m_nDefaultEdge forKey:sKey];

    sKey = [StringFactory GetString_DefaultLevelKey];
    [prefs setInteger:m_nDefaultLevel forKey:sKey];
    
    sKey = [StringFactory GetString_BubbleTypeKey];
    [prefs setInteger:m_nDefaultBubble forKey:sKey];

    sKey = [StringFactory GetString_DefaultGameKey];
    [prefs setInteger:m_nDefaultGame forKey:sKey];
}

-(void)SavePaymentState
{
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
	//return;
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    
    [NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:m_bPaid forKey:[StringFactory GetString_PurchaseStateKey]];
}

-(void)SaveSquarePaymentState
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:m_bSquarePaid forKey:[StringFactory GetString_PurchaseSquareStateKey]];
}

-(void)SaveDiamondPaymentState
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:m_bDiamondPaid forKey:[StringFactory GetString_PurchaseDiamondStateKey]];
}

-(void)SaveHexagonPaymentState
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:m_bHexagonPaid forKey:[StringFactory GetString_PurchaseHexagonStateKey]];
    
}

-(void)LoadSquarePaymentState
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
    m_bSquarePaid = PRODUCT_FREE;
	m_bSquarePaid = [prefs integerForKey:[StringFactory GetString_PurchaseSquareStateKey]];
}

-(void)LoadDiamondPaymentState
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
    m_bDiamondPaid = PRODUCT_FREE;
	m_bDiamondPaid = [prefs integerForKey:[StringFactory GetString_PurchaseDiamondStateKey]];
}

-(void)LoadHexagonPaymentState
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
    m_bHexagonPaid = PRODUCT_FREE;
	m_bHexagonPaid = [prefs integerForKey:[StringFactory GetString_PurchaseHexagonStateKey]];
}

-(void)SaveDefaultConfigure
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self SaveDefaultSetting:prefs];
}

- (void)SaveScoresToPreference
{
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
    //
	//Don't save any payment information here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //
    //[prefs setInteger:m_bPaid forKey:[StringFactory GetString_PurchaseStateKey]];
    
    [self SaveDefaultSetting:prefs];
	
    [self SaveGameScores:prefs];
}	


+(BOOL)CheckPaymentState
{
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //return YES;     
    
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    //??????????????????????????????????
    
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    [scores LoadScoresFromPreference];
    if(scores.m_bPaid == PRODUCT_PAID)
    {    
        return YES;
    }    
    else
    {    
        return NO;
    }
}

+(BOOL)CheckSquarePaymentState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    [scores LoadSquarePaymentState];
    if(scores.m_bSquarePaid == PRODUCT_PAID)
    {    
        return YES;
    }    
    else
    {    
        return NO;
    }
}

+(BOOL)CheckDiamondPaymentState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    [scores LoadDiamondPaymentState];
    if(scores.m_bDiamondPaid == PRODUCT_PAID)
    {    
        return YES;
    }    
    else
    {    
        return NO;
    }
}

+(BOOL)CheckHexagonPaymentState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    [scores LoadHexagonPaymentState];
    if(scores.m_bHexagonPaid == PRODUCT_PAID)
    {    
        return YES;
    }    
    else
    {    
        return NO;
    }
}

+(BOOL)HasPurchasedProduct
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    [scores LoadPaymentState];
    [scores LoadSquarePaymentState];
    [scores LoadDiamondPaymentState];
    [scores LoadHexagonPaymentState];
    if(scores.m_bPaid || scores.m_bSquarePaid || scores.m_bDiamondPaid || scores.m_bHexagonPaid)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(void)SavePaidState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    scores.m_bPaid = PRODUCT_PAID;
    [scores SavePaymentState];
}

+(void)SaveSquarePaidState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    scores.m_bSquarePaid = PRODUCT_PAID;
    [scores SaveSquarePaymentState];
}

+(void)SaveDiamondPaidState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    scores.m_bDiamondPaid = PRODUCT_PAID;
    [scores SaveDiamondPaymentState];
}

+(void)SaveHexagonPaidState
{
    GameScore* scores = [[[GameScore alloc] init] autorelease];
    scores.m_bHexagonPaid = PRODUCT_PAID;
    [scores SaveHexagonPaymentState];
}

+(void)InitializeGameScore
{
    g_Score = [[GameScore alloc] init];
    [g_Score LoadScoresFromPreference];
}

+(void)CleanGameScore
{
    [g_Score SaveScoresToPreference];
    [g_Score release];
}

+(int)GetScoreCount
{
    int nRet = 0;
    
    nRet = [g_Score GetScoreCount];
    
    return nRet;
}

+(BOOL)HasScoreRecord:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType
{
    BOOL bRet = NO;
    
    bRet = [g_Score CheckScoreRecord:nType withLayout:nLayout withEdge:nEdge withLevel:nLevel withGameType:gameType];
    
    return bRet;
}

+(ScoreRecord*)GetScore:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType
{
    return [g_Score GetScoreRecordByInfo:nType withLayout:nLayout withEdge:nEdge withLevel:nLevel withGameType:gameType];
}

+(ScoreRecord*)GetScoreAt:(int)nIndex
{
    return [g_Score GetScoreRecord:nIndex];
}

+(void)AddScore:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withScore:(int)nStep withLevel:(int)nLevel withGameType:(int)gameType
{
    [g_Score AddScore:nType withLayout:nLayout withEdge:nEdge withScore:nStep withLevel:nLevel withGameType:gameType];
    if(nLevel == 0)
    {
        int nWinScore = [GameConfiguration getEasyGameWinScore:(enGridType)nType withEdge:nEdge];
        [GameScore AddEasyGameScore:nWinScore];
        int nTotalScore = [GameScore GetTotalGameScore] + nWinScore;
        [GameScore SetTotalGameScore:nTotalScore];
    }
    else
    {
        int nWinScore = [GameConfiguration getDifficultGameWinScore:(enGridType)nType withEdge:nEdge];
        [GameScore AddDifficultGameScore:nWinScore];
        int nTotalScore = [GameScore GetTotalGameScore] + nWinScore;
        [GameScore SetTotalGameScore:nTotalScore];
    }
}

+(int)GetDefaultGame
{
    return g_Score.m_nDefaultGame;
}

+(int)GetDefaultType
{
    return g_Score.m_nDefaultType;
}

+(int)GetDefaultLayout
{
    return g_Score.m_nDefaultLayout;
}

+(int)GetDefaultEdge
{
    return g_Score.m_nDefaultEdge;
}

+(int)GetDefaultBubble
{
    return g_Score.m_nDefaultBubble;
}

+(int)GetDefaultLevel
{
    return g_Score.m_nDefaultLevel;
}

+(void)SetDefaultConfigure:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withBubble:(int)nBubbleType withGameType:(int)gameType
{
    g_Score.m_nDefaultType = nType;
    g_Score.m_nDefaultLayout = nLayout;
    g_Score.m_nDefaultEdge = nEdge;
    g_Score.m_nDefaultBubble = nBubbleType;
    g_Score.m_nDefaultLevel = nLevel;
    g_Score.m_nDefaultGame = gameType;
    
    [g_Score SaveDefaultConfigure];
}


+(void)SaveBackgoundType:(int)nType
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* sKey = @"BUBBLETILE_BACKGROUND";
    [prefs setInteger:nType forKey:sKey];
}

+(int)GetBackgoundType
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* sKey = @"BUBBLETILE_BACKGROUND";
    int nRet = [prefs integerForKey:sKey];
    if(nRet < 0)
        nRet = 0;
    
    return nRet;
}

+(int)GetSNPostYear
{
    int nRet = -1;
	NSString* sKey = @"BUBBLETILE_SN_POST_REWARD_YEAR";	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	nRet = [prefs integerForKey:sKey];
	if(nRet <= 0)
	{
		nRet = -1;
	}	
    
    return nRet;
}

+(int)GetSNPostMonth
{
    int nRet = -1;
	NSString* sKey = @"BUBBLETILE_SN_POST_REWARD_MONTH";	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	nRet = [prefs integerForKey:sKey];
	if(nRet <= 0)
	{
		nRet = -1;
	}	
    
    return nRet;
}

+(int)GetSNPostDay
{
    int nRet = -1;
	NSString* sKey = @"BUBBLETILE_SN_POST_REWARD_DAY";	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	nRet = [prefs integerForKey:sKey];
	if(nRet <= 0)
	{
		nRet = -1;
	}	
    
    return nRet;
}

+(void)SetSNPostTime:(int)nDay withMonth:(int)nMonth withYear:(int)nYear
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKeyYear = @"BUBBLETILE_SN_POST_REWARD_YEAR";	
	NSString* sKeyMonth = @"BUBBLETILE_SN_POST_REWARD_MONTH";	
	NSString* sKeyDay = @"BUBBLETILE_SN_POST_REWARD_DAY";	
	[prefs setInteger:nDay forKey:sKeyDay];
	[prefs setInteger:nMonth forKey:sKeyMonth];
	[prefs setInteger:nYear forKey:sKeyYear];
}


+(void)SetTotalGameScore:(int)nWinScore
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sGameScore = @"BUBBLETILE_TOTAL_GAMESCORE";	
    [prefs setInteger:nWinScore forKey:sGameScore];
}

+(int)GetTotalGameScore
{
    int nRet = 0;

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sGameScore = @"BUBBLETILE_TOTAL_GAMESCORE";	
	nRet = [prefs integerForKey:sGameScore];
    if(nRet < 0)
        nRet = 0;
    
    return nRet;
}

+(void)AddEasyGameScore:(int)nWinScore
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sEasyGameScore = @"BUBBLETILE_EASYGAME_SCORE";	
	int nOldScore = [prefs integerForKey:sEasyGameScore];
	int nNewScore = nOldScore + nWinScore; 
    [prefs setInteger:nNewScore forKey:sEasyGameScore];
}

+(int)GetEasyGameScore
{
    int nRet = 0;
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sEasyGameScore = @"BUBBLETILE_EASYGAME_SCORE";	
	nRet = [prefs integerForKey:sEasyGameScore];
    if(nRet < 0)
        nRet = 0;
    
    return nRet;
}

+(void)AddDifficultGameScore:(int)nWinScore
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sDifficultGameScore = @"BUBBLETILE_DIFFICULTGAME_SCORE";	
	int nOldScore = [prefs integerForKey:sDifficultGameScore];
	int nNewScore = nOldScore + nWinScore; 
    [prefs setInteger:nNewScore forKey:sDifficultGameScore];
}

+(int)GetDifficultGameScore
{
    int nRet = 0;
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sDifficultGameScore = @"BUBBLETILE_DIFFICULTGAME_SCORE";	
	nRet = [prefs integerForKey:sDifficultGameScore];
    if(nRet < 0)
        nRet = 0;
    
    return nRet;
}

+(void)checkAWSServiceEnable
{
    g_bDisableAWSService = NO;
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	g_bDisableAWSService = [prefs boolForKey:@"BUBBLETILE_AWSSERVICE_KEY"];
}

+(void)setAWSServiceEnable:(BOOL)bEnable
{
    if(bEnable)
        g_bDisableAWSService = NO;
    else
        g_bDisableAWSService = YES;
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* sKey = @"BUBBLETILE_AWSSERVICE_KEY";
	[prefs setBool:g_bDisableAWSService forKey:sKey];
}

+(BOOL)isAWSServiceEnabled
{
    if(g_bDisableAWSService == NO)
        return YES;
    else
        return NO;
}

@end
