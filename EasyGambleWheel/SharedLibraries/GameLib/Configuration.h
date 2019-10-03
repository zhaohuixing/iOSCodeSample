//
//  Configuration.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-06.
//  Copyright 2010 xgadget. All rights reserved.
//

@import UIKit;


@interface Configuration : NSObject 
{
}

+(BOOL)isDirty;
+(void)resetDirty;
+(void)setDirty;

+(BOOL)canPlaySound;
+(void)enablePlaySound;
+(void)disablePlaySound;
+(void)setPlaySoundEffect:(BOOL)enable;

+(BOOL)isOnline;
+(void)setOnline:(BOOL)bOnline;
+(void)cacheOnlineSetting;
+(BOOL)isOnlineSettingChange;
+(void)setPlayTurn:(int)bPlayTurnType;
+(int)getPlayTurnType;
+(BOOL)isPlayTurnBySequence;


+(int)getCurrentGameType;
+(void)setCurrentGameType:(int)nType;
+(BOOL)isRoPaAutoBet;
+(void)setRoPaAutoBet:(BOOL)bAuto;

+(void)AddGKGameCenterAccessTry;
+(int)GetGKGameCenterAccessTry;
+(void)ClearGKGameCenterAccessTry;

+(int)getCurrentGameTheme;
+(void)setCurrentGameTheme:(int)themeType;


@end
