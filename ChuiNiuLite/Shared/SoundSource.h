//
//  SoundSource.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-20.
//  Copyright 2010 xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface SoundSource : NSObject 
{
}

+(void)InitializeSoundSource:(id<AVAudioPlayerDelegate>)delegate;
+(void)ReleaseSoundSource;

+(void)PlayBackgroundSound;
+(void)PlayBlockageSound;
+(void)SwitchToBackgroundSound;

+(void)StopBackgroundSound;
+(void)PauseBackgroundSound;
+(void)ResumeBackgroundSound;

+(void)StopAllPlayingSound;
+(void)PauseAllPlayingSound;
+(void)ResumeAllPlayingSound;

+(void)PlayCowMeeo;
+(void)StopCowMeeo;
+(void)PauseCowMeeo;
+(void)ResumeCowMeeo;
+(BOOL)IsPlayCowMeeo;

+(void)PlayCowPupu;
+(void)StopCowPupu;
+(void)PauseCowPupu;
+(void)ResumeCowPupu;
+(BOOL)IsPlayCowPupu;

+(void)PlayCowKnockdown;
+(void)StopCowKnockdown;
+(void)PauseCowKnockdown;
+(void)ResumeCowKnockdown;
+(BOOL)IsPlayCowKnockdown;

+(void)PlayDogBreath;
+(void)StopDogBreath;
+(void)PauseDogBreath;
+(void)ResumeDogBreath;

+(void)PlayBlast;
+(void)StopBlast;
+(void)PauseBlast;
+(void)ResumeBlast;

+(void)PlayCollision;
+(void)StopCollision;
+(void)PauseCollision;
+(void)ResumeCollision;

+(void)PlayJump;
+(void)StopJump;
+(void)PauseJump;
+(void)ResumeJump;

+(void)PlayCrash;
+(void)StopCrash;
+(void)PauseCrash;
+(void)ResumeCrash;

+(void)PlayWin;
+(void)StopWin;
+(void)PlayLose;
+(void)StopLose;
+(BOOL)IsPlayWin;
+(BOOL)IsPlayLose;

+(void)PlayThunder;
+(void)StopThunder;
+(void)PauseThunder;
+(void)ResumeThunder;

+(void)StopPlaySoundFile:(AVAudioPlayer *)player;

@end
