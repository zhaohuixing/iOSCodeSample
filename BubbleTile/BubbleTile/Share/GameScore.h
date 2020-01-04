//
//  GameScore.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-05-11.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ScoreRecord.h"


@interface GameScore : NSObject 
{
	NSMutableArray*		m_Scores;
	
    int                 m_bPaid;

	int                 m_bSquarePaid;
	int                 m_bDiamondPaid;
	int                 m_bHexagonPaid;
    
	int                 m_nDefaultGame;
	int                 m_nDefaultBubble;
	int                 m_nDefaultType;
	int                 m_nDefaultLayout;
    int                 m_nDefaultEdge;
    int                 m_nDefaultLevel;
}

@property int			m_bPaid;
@property int           m_bSquarePaid;
@property int           m_bDiamondPaid;
@property int           m_bHexagonPaid;
@property int           m_nDefaultType;
@property int			m_nDefaultLayout;
@property int			m_nDefaultEdge;
@property int           m_nDefaultBubble;
@property int           m_nDefaultLevel;
@property int           m_nDefaultGame;


- (void)CreateScoreRecord:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType;
- (int)GetScoreCount;
- (int)CheckScoreRecord:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType;
- (void)AddScore:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withScore:(int)nStep withLevel:(int)nLevel withGameType:(int)gameType;
- (void)Reset;

- (void)LoadScoresFromPreference;
- (void)SaveScoresToPreference;
- (ScoreRecord*)GetScoreRecord:(int)index;
- (ScoreRecord*)GetScoreRecordByInfo:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType;
-(void)SavePaymentState;
-(void)LoadPaymentState;
-(void)LoadDefaultConfigure;
-(void)SaveDefaultConfigure;

-(void)SaveSquarePaymentState;
-(void)LoadSquarePaymentState;
-(void)SaveDiamondPaymentState;
-(void)LoadDiamondPaymentState;
-(void)SaveHexagonPaymentState;
-(void)LoadHexagonPaymentState;

+(BOOL)CheckPaymentState;
+(BOOL)CheckSquarePaymentState;
+(BOOL)CheckDiamondPaymentState;
+(BOOL)CheckHexagonPaymentState;
+(BOOL)HasPurchasedProduct;

+(void)SavePaidState;
+(void)SaveSquarePaidState;
+(void)SaveDiamondPaidState;
+(void)SaveHexagonPaidState;

+(void)InitializeGameScore;
+(void)CleanGameScore;
+(int)GetScoreCount;
+(BOOL)HasScoreRecord:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType;
+(ScoreRecord*)GetScore:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withGameType:(int)gameType;
+(ScoreRecord*)GetScoreAt:(int)nIndex;
+(void)AddScore:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withScore:(int)nStep withLevel:(int)nLevel withGameType:(int)gameType;
+(int)GetDefaultGame;
+(int)GetDefaultType;
+(int)GetDefaultLayout;
+(int)GetDefaultEdge;
+(int)GetDefaultBubble;
+(int)GetDefaultLevel;
+(void)SetDefaultConfigure:(int)nType withLayout:(int)nLayout withEdge:(int)nEdge withLevel:(int)nLevel withBubble:(int)nBubbleType withGameType:(int)gameType;

+(void)SaveBackgoundType:(int)nType;
+(int)GetBackgoundType;

+(int)GetSNPostYear;
+(int)GetSNPostMonth;
+(int)GetSNPostDay;
+(void)SetSNPostTime:(int)nDay withMonth:(int)nMonth withYear:(int)nYear;


+(void)SetTotalGameScore:(int)nWinScore;
+(int)GetTotalGameScore;
+(void)AddEasyGameScore:(int)nWinScore;
+(int)GetEasyGameScore;
+(void)AddDifficultGameScore:(int)nWinScore;
+(int)GetDifficultGameScore;


+(void)checkAWSServiceEnable;
+(void)setAWSServiceEnable:(BOOL)bEnable;
+(BOOL)isAWSServiceEnabled;

@end
