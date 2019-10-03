//
//  ScoreRecord.h
//  ChuiNiu
//
//  Created by ZXing on 2010-08-10.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScoreRecord : NSObject 
{
}

+(int)getLastWinSkill;
+(int)getLastWinLevel;
+(int)getScore:(int)nSkill atLevel:(int)nLevel;
+(int)getPoint:(int)nSkill atLevel:(int)nLevel;
+(void)addScore:(int)nSkill atLevel:(int)nLevel;
+(void)setScore:(int)nScore atSkill:(int)nSkill atLevel:(int)nLevel;
+(void)setPoint:(int)nPoint atSkill:(int)nSkill atLevel:(int)nLevel;

+(void)saveRecord;
+(void)loadRecord;

+(BOOL)CheckPaymentState;
+(void)SavePaidState;

+(void)addTotalWinScore:(int)nWinScore;
+(void)reduceTotalWinScore:(int)nLostScore;
+(int)getTotalWinScore;

+(BOOL)shouldAchievement1Reported;
+(BOOL)shouldAchievement2Reported;
+(BOOL)shouldAchievement3Reported;
+(BOOL)shouldAchievement4Reported;

+(void)resetAchievement1Reported;
+(void)resetAchievement2Reported;
+(void)resetAchievement3Reported;
+(void)resetAchievement4Reported;

+(void)checkAWSServiceEnable;
+(void)setAWSServiceEnable:(BOOL)bEnable;
+(BOOL)isAWSServiceEnabled;

@end
