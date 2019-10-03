//
//  Configuration.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-06.
//  Copyright 2010 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Configuration : NSObject 
{
}
+(BOOL)isDirty;
+(void)setDirty;
+(void)clearDirty;

+(BOOL)isClockShown;
+(void)setClockShown:(BOOL)bShown;

+(CGPoint)GetDefaultPlayerBulletSpeed;
+(BOOL)canTargetShoot;
+(BOOL)canKnockDownTarget;
+(BOOL)canPlayerJump;
+(BOOL)canShootBlock;
+(BOOL)canTargetBlast;
+(BOOL)canPlaySound;
+(BOOL)canAlienShaking;
+(BOOL)isPaperBackground;
+(void)setPaperBackground:(BOOL)bYesNo;
+(int)getBackgroundSetting;
+(void)setBackgroundSetting:(int)setting;

+(void)enablePlaySound;
+(void)disablePlaySound;
+(void)setPlaySoundEffect:(BOOL)enable;

+(BOOL)canBirdFly;
+(BOOL)canBirdShoot;

+(void)setGameLevel:(int)nLevel;
+(void)setGameLevelOne;
+(void)setGameLevelTwo;
+(void)setGameLevelThree;
+(void)setGameLevelFour;
+(int)getGameLevel;
+(BOOL)isGameLevelOne;
+(BOOL)isGameLevelTwo;
+(BOOL)isGameLevelThree;
+(BOOL)isGameLevelFour;

+(void)setGameSkill:(int)nSkill;
+(void)setGameSkillOne;
+(void)setGameSkillTwo;
+(void)setGameSkillThree;
+(int)getGameSkill;
+(BOOL)isGameSkillOne;
+(BOOL)isGameSkillTwo;
+(BOOL)isGameSkillThree;

+(int)getTargetHitLimit;
+(int)getTargetHitDeductable;

+(int)getGameTime;

+(int)getBulletTimerElapse;
+(CGPoint)getTargetBulletSpeed;

+(int)getTargetTimerStep;
+(int)getTargetAnimationDelayThreshold;
+(float)getTargetSpeedY;

+(int)getAlienTimerElapse;
+(int)getAlienShootThreshold;
+(int)getBlockageTimerElapse;
+(int)getBlockageShootThreshold;
+(CGPoint)getBlockageSpeed;

+(int)getRainRowStartTime;

+(float)getRandomCloudWidth:(int)nRand;
+(float)getRandomCloudHeight:(int)nRand;

+(int)getDefaultTargetHitLimit;
+(int)getGameTimerClickThreshold;

+(void)setThunderTheme:(BOOL)bYes;
+(BOOL)getThunderTheme;

+(int)getGameWinScore:(int)nSkill inLevel:(int)nLevel;
+(int)getGamePLayThesholdScore:(int)nSkill inLevel:(int)nLevel;
+(int)getGameLostPenalityScore:(int)nSkill inLevel:(int)nLevel;

+(int)getCanGamePlaySkillAtScore:(int)nScore;
+(int)getCanGamePlayLevelAtScore:(int)nScore;

+(float)getBirdFlyingRatio;
+(int)getBirdFlyingThreshold;
+(int)getBirdFlyingAcceleration;

+(void)AddFlashAddDelayCount;
+(BOOL)CanPlayFlashAddNow;
+(void)CleanFlashAddDelayCount;

+(int)GetGameSettingIndex:(int)nSkill witLevel:(int)nLevel;
+(int)GetGameSkillFromSettingIndex:(int)nIndex;
+(int)GetGameLevelFromSettingIndex:(int)nIndex;

+(void)setUseFacialGesture:(BOOL)bMouth;
+(BOOL)isUseFacialGesture;


@end
