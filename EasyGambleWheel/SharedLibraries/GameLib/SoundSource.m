//
//  SoundSource.m
//  XXXXXXX
//
//  Created by Zhaohui Xing on 2010-08-20.
//  Copyright 2010 xgadget. All rights reserved.
//
#import "SoundSource.h"


static AVAudioPlayer*  g_WheelStaticSound;
static BOOL			   g_bPlayingWheelStaticSound = NO;	

static AVAudioPlayer*  g_PointerSpinSound;
static BOOL			   g_bPlayingPointerSpinSound = NO;	

static AVAudioPlayer*  g_GameResultSound;
static BOOL			   g_bPlayingGameResultSound = NO;	

static AVAudioPlayer*  g_DropCoinSound;
static BOOL			   g_bPlayingDropCoinSound = NO;	

@implementation SoundSource

+(void)InitializeSoundSource:(id<AVAudioPlayerDelegate>)delegate
{
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"sndsrc1" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_WheelStaticSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	if (!g_WheelStaticSound || error != nil)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_WheelStaticSound prepareToPlay];
	[g_WheelStaticSound setNumberOfLoops:999999];
	g_WheelStaticSound.delegate = delegate;
    g_bPlayingWheelStaticSound = NO;	
    
	path = [[NSBundle mainBundle] pathForResource:@"sndsrc4" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_PointerSpinSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	if (!g_PointerSpinSound || error != nil)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_PointerSpinSound prepareToPlay];
	[g_PointerSpinSound setNumberOfLoops:999999];
	g_PointerSpinSound.delegate = delegate;
	g_bPlayingPointerSpinSound = NO;
    
	path = [[NSBundle mainBundle] pathForResource:@"sndresult" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_GameResultSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	if (!g_GameResultSound || error != nil)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_GameResultSound prepareToPlay];
	[g_GameResultSound setNumberOfLoops:999999];
	g_GameResultSound.delegate = delegate;
	g_bPlayingGameResultSound = NO;
    
	path = [[NSBundle mainBundle] pathForResource:@"sndcoin" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_DropCoinSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	if (!g_DropCoinSound || error != nil)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_DropCoinSound prepareToPlay];
	g_DropCoinSound.delegate = delegate;
	g_bPlayingDropCoinSound = NO;
    
}

+(void)ReleaseSoundSource
{
	if(g_WheelStaticSound)
	{	
		[g_WheelStaticSound stop];
	}
	if(g_PointerSpinSound)
	{	
		[g_PointerSpinSound stop];
	}
	if(g_GameResultSound)
	{	
		[g_GameResultSound stop];
	}
	if(g_DropCoinSound)
	{	
		[g_DropCoinSound stop];
	}	
}	

+(BOOL)IsPlayWheelStaticSound
{
    return g_bPlayingWheelStaticSound;
}

+(BOOL)IsPlayPointerSpinSound
{
    return g_bPlayingPointerSpinSound;
}

+(BOOL)IsPlayGameResultSound
{
    return g_bPlayingGameResultSound;
}

+(BOOL)IsPlayDropCoinSound
{
    return g_bPlayingDropCoinSound;
}

+(void)PlayWheelStaticSound
{
	if(g_WheelStaticSound)
	{
        g_bPlayingWheelStaticSound = YES;
		[g_WheelStaticSound play];
	}	
    
}

+(void)PlayPointerSpinSound
{
    if(g_PointerSpinSound)
    {
        g_bPlayingPointerSpinSound = YES;
        [g_PointerSpinSound play];
    }
}

+(void)PlayGameResultSound
{
    if(g_GameResultSound)
    {
        g_bPlayingGameResultSound = YES;
        [g_GameResultSound play];
    }
}

+(void)PlayDropCoinSound
{
    if(g_DropCoinSound)
    {
        g_bPlayingDropCoinSound = YES;
        [g_DropCoinSound play];
    }
}

+(void)StopWheelStaticSound
{
	if(g_WheelStaticSound)
	{
        g_bPlayingWheelStaticSound = NO;
		[g_WheelStaticSound stop];
	}	
    
}

+(void)StopPointerSpinSound
{
    if(g_PointerSpinSound)
    {
        g_bPlayingPointerSpinSound = NO;
        [g_PointerSpinSound stop];
    }
}
    
+(void)StopGameResultSound
{
    if(g_GameResultSound)
    {
        g_bPlayingGameResultSound = NO;
        [g_GameResultSound stop];
    }
}

+(void)StopDropCoinSound
{
    if(g_DropCoinSound)
    {
        g_bPlayingDropCoinSound = NO;
        [g_DropCoinSound stop];
    }
}

+(void)StopPlaySoundFile:(AVAudioPlayer *)player
{
	if(player == g_WheelStaticSound)
	{
		[SoundSource StopWheelStaticSound];
	}	
	else if(player == g_PointerSpinSound)
	{
		[SoundSource StopPointerSpinSound];
	}	
	else if(player == g_GameResultSound)
	{
		[SoundSource StopGameResultSound];
	}	
	else if(player == g_DropCoinSound)
	{
		[SoundSource StopDropCoinSound];
	}	
}	

+(void)StopAllPlayingSound
{
    [SoundSource StopWheelStaticSound];
    [SoundSource StopPointerSpinSound];
    [SoundSource StopGameResultSound];
    [SoundSource StopDropCoinSound];
}	

@end
