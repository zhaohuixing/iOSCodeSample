//
//  SoundSource.h
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-20.
//  Copyright 2010 xgadget. All rights reserved.
//
@import UIKit;

#import <AVFoundation/AVFoundation.h>


@interface SoundSource : NSObject 
{
}

+(void)InitializeSoundSource:(id<AVAudioPlayerDelegate>)delegate;
+(void)ReleaseSoundSource;

+(BOOL)IsPlayWheelStaticSound;
+(BOOL)IsPlayPointerSpinSound;
+(BOOL)IsPlayGameResultSound;
+(BOOL)IsPlayDropCoinSound;

+(void)PlayWheelStaticSound;
+(void)PlayPointerSpinSound;
+(void)PlayGameResultSound;
+(void)PlayDropCoinSound;

+(void)StopWheelStaticSound;
+(void)StopPointerSpinSound;
+(void)StopGameResultSound;
+(void)StopDropCoinSound;

+(void)StopPlaySoundFile:(AVAudioPlayer *)player;
+(void)StopAllPlayingSound;

@end
