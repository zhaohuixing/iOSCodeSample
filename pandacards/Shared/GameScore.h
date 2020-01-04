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
}

@property int			m_bPaid;


- (void)CreateScoreRecord:(int)nPoint withSpeed:(int)nSpeed;
- (int)CheckScoreRecord:(int)nPoint;
- (int)GetScoreCount;
- (int)GetActivePointScoreIndex;
- (void)AddScore:(int)nPoint withSpeed:(int)nSpeed withScore:(double)dScore;
- (void)LoadScoresFromPreference:(BOOL)bSetGamePoint;
- (void)SaveScoresToPreference;
- (void)Reset;
- (ScoreRecord*)GetScoreRecord:(int)index;
- (ScoreRecord*)GetNonActivePointScoreRecord:(int)index;
- (ScoreRecord*)GetScoreRecordByPoint:(int)nPoint;

-(void)SaveGamePoints;
-(void)SaveGameSpeed;
-(void)SaveBackground;
-(void)SavePaymentState;
-(void)LoadPaymentState;

+(BOOL)CheckPaymentState;
+(void)SavePaidState;

+(int)GetSNPostYear;
+(int)GetSNPostMonth;
+(int)GetSNPostDay;
+(void)SetSNPostTime:(int)nDay withMonth:(int)nMonth withYear:(int)nYear;


@end
