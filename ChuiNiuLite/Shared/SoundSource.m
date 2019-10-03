//
//  SoundSource.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-20.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "SoundSource.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"

static AVAudioPlayer*  g_BackgroundSound;
static AVAudioPlayer*  g_BackgroundSound2;
static BOOL			   g_bPlayingBackgroundSound2;	

static AVAudioPlayer*  g_CowMeeoSound;
static BOOL			   g_bPlayingCowMeeoSound = NO;	

static AVAudioPlayer*  g_CowPupuSound;
static BOOL			   g_bPlayingCowPupuSound = NO;	

static AVAudioPlayer*  g_CowKnockdownSound;
static BOOL			   g_bPlayingCowKnockdownSound = NO;	

static AVAudioPlayer*  g_DogBreathSound;
static BOOL			   g_bPlayingDogBreathSound = NO;	

static AVAudioPlayer*  g_BlastSound;
static BOOL			   g_bPlayingBlastSound = NO;	

static AVAudioPlayer*  g_CollisionSound;
static BOOL			   g_bPlayingCollisionSound = NO;	

static AVAudioPlayer*  g_JumpSound;
static BOOL			   g_bPlayingJumpSound = NO;	

static AVAudioPlayer*  g_CrashSound;
static BOOL			   g_bPlayingCrashSound = NO;	

static AVAudioPlayer*  g_WinSound;
static AVAudioPlayer*  g_LoseSound;
static BOOL			   g_bPlayingWinSound = NO;	
static BOOL			   g_bPlayingLoseSound = NO;	

static AVAudioPlayer*  g_ThunderSound;
static BOOL			   g_bPlayingThunderSound = NO;	



@implementation SoundSource


+(void)InitializeDogSounds:(id<AVAudioPlayerDelegate>)delegate
{
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"breath" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_DogBreathSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_DogBreathSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_DogBreathSound prepareToPlay];
	g_DogBreathSound.volume = g_DogBreathSound.volume/4;
	g_DogBreathSound.delegate = delegate;
	g_bPlayingDogBreathSound = NO;	
}

+(void)InitializeCowSounds:(id<AVAudioPlayerDelegate>)delegate
{
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"cowmee" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_CowMeeoSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_CowMeeoSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_CowMeeoSound prepareToPlay];
	g_CowMeeoSound.delegate = delegate;
	g_CowMeeoSound.volume = g_CowMeeoSound.volume/3;
	g_bPlayingCowMeeoSound = NO;	

	path = [[NSBundle mainBundle] pathForResource:@"cowpupu" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_CowPupuSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_CowPupuSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_CowPupuSound prepareToPlay];
	g_CowPupuSound.delegate = delegate;
	g_bPlayingCowPupuSound = NO;	

	path = [[NSBundle mainBundle] pathForResource:@"cowknockdown" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_CowKnockdownSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_CowKnockdownSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_CowKnockdownSound prepareToPlay];
	g_CowKnockdownSound.delegate = delegate;
	g_bPlayingCowKnockdownSound = NO;	
	
}

+(void)InitializeBackgroundSound:(id<AVAudioPlayerDelegate>)delegate
{
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bkmusic" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_BackgroundSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_BackgroundSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_BackgroundSound prepareToPlay];
	[g_BackgroundSound setNumberOfLoops:999999];
	g_BackgroundSound.delegate = delegate;

	path = [[NSBundle mainBundle] pathForResource:@"bkmusic2" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_BackgroundSound2 = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_BackgroundSound2)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_BackgroundSound2 prepareToPlay];
	[g_BackgroundSound2 setNumberOfLoops:999999];
	g_BackgroundSound2.delegate = delegate;
	g_bPlayingBackgroundSound2 = NO;
	
}	

+(void)InitializeBlast:(id<AVAudioPlayerDelegate>)delegate
{
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"blast" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_BlastSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_BlastSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_BlastSound prepareToPlay];
	g_BlastSound.volume = g_BlastSound.volume/4;
	g_BlastSound.delegate = delegate;
	g_bPlayingBlastSound = NO;	
}	

+(void)InitializeMisc:(id<AVAudioPlayerDelegate>)delegate
{
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"collision" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_CollisionSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_CollisionSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_CollisionSound prepareToPlay];
	g_CollisionSound.volume = g_CollisionSound.volume/4;
	g_CollisionSound.delegate = delegate;
	g_bPlayingCollisionSound = NO;	

	path = [[NSBundle mainBundle] pathForResource:@"jump" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_JumpSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_JumpSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_JumpSound prepareToPlay];
	//g_JumpSound.volume = g_JumpSound.volume/4;
	//[g_JumpSound setNumberOfLoops:4];
	g_JumpSound.delegate = delegate;
	g_bPlayingJumpSound = NO;	


	path = [[NSBundle mainBundle] pathForResource:@"dead" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_CrashSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_CrashSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_CrashSound prepareToPlay];
	g_CrashSound.volume = g_CrashSound.volume;
	g_CrashSound.delegate = delegate;
	g_bPlayingCrashSound = NO;	
	
	path = [[NSBundle mainBundle] pathForResource:@"win" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_WinSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_WinSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_WinSound prepareToPlay];
	g_WinSound.delegate = delegate;

	path = [[NSBundle mainBundle] pathForResource:@"lose" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_LoseSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_LoseSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_LoseSound prepareToPlay];
	g_LoseSound.delegate = delegate;
    
    
    //Initalize thunder sound source
	path = [[NSBundle mainBundle] pathForResource:@"thunders" ofType:@"caf"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
		return ;
	
	// Initialize the player
	g_ThunderSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error] retain];
	if (!g_ThunderSound)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}
	
	// Prepare the player and set the loops to, basically, unlimited
	[g_ThunderSound prepareToPlay];
	g_ThunderSound.volume = g_ThunderSound.volume;
	g_ThunderSound.delegate = delegate;
	g_bPlayingThunderSound = NO;	

    g_bPlayingWinSound = NO;	
    g_bPlayingLoseSound = NO;	
    
}

+(void)InitializeSoundSource:(id<AVAudioPlayerDelegate>)delegate
{
	[SoundSource InitializeBackgroundSound:delegate];
	[SoundSource InitializeCowSounds:delegate];
	[SoundSource InitializeDogSounds:delegate];
	[SoundSource InitializeBlast:delegate];
	[SoundSource InitializeMisc:delegate];
}

+(void)ReleaseSoundSource
{
	if(g_BackgroundSound)
	{	
		[g_BackgroundSound stop];
		[g_BackgroundSound release];
	}	
	if(g_BackgroundSound2)
	{	
		[g_BackgroundSound2 stop];
		[g_BackgroundSound2 release];
	}	
	if(g_CowMeeoSound)
	{	
		[g_CowMeeoSound stop];
		[g_CowMeeoSound release];
	}	
	if(g_CowPupuSound)
	{	
		[g_CowPupuSound stop];
		[g_CowPupuSound release];
	}	
	if(g_CowKnockdownSound)
	{	
		[g_CowKnockdownSound stop];
		[g_CowKnockdownSound release];
	}	
	if(g_DogBreathSound)
	{	
		[g_DogBreathSound stop];
		[g_DogBreathSound release];
	}	
	if(g_BlastSound)
	{	
		[g_BlastSound stop];
		[g_BlastSound release];
	}	
	if(g_CollisionSound)
	{	
		[g_CollisionSound stop];
		[g_CollisionSound release];
	}	
	if(g_JumpSound)
	{	
		[g_JumpSound stop];
		[g_JumpSound release];
	}	
	if(g_CrashSound)
	{	
		[g_CrashSound stop];
		[g_CrashSound release];
	}	
	if(g_WinSound)
	{
		[g_WinSound stop];
		[g_WinSound release];
	}	
	if(g_LoseSound)
	{
		[g_LoseSound stop];
		[g_LoseSound release];
	}	

	if(g_ThunderSound)
	{	
		[g_ThunderSound stop];
		[g_ThunderSound release];
	}	
}	

+(void)PlayBackgroundSound
{
	if(g_BackgroundSound)
	{	
		[g_BackgroundSound play];
	}	
}

+(void)PlayBlockageSound
{
	if(g_BackgroundSound2 && g_bPlayingBackgroundSound2 == NO)
	{
		if(g_BackgroundSound)
		{	
			[g_BackgroundSound stop];
		}	
		[g_BackgroundSound2 play];
		g_bPlayingBackgroundSound2 = YES;
	}	
}	

+(void)SwitchToBackgroundSound
{
	if(g_bPlayingBackgroundSound2 == YES)
	{
		if(g_BackgroundSound2)
			[g_BackgroundSound2 stop];
		
		g_bPlayingBackgroundSound2 = NO;
		
		[SoundSource PlayBackgroundSound];
	}
}

+(void)StopBackgroundSound
{
	if(g_BackgroundSound2 && g_bPlayingBackgroundSound2 == YES)
	{
		[g_BackgroundSound2 stop];
		g_bPlayingBackgroundSound2 = NO;
	}
	
	if(g_BackgroundSound)
		[g_BackgroundSound stop];
}

+(void)PauseBackgroundSound
{
	if(g_bPlayingBackgroundSound2 == YES)
	{
		if(g_BackgroundSound2)
			[g_BackgroundSound2 pause];
	}
	else 
	{
		if(g_BackgroundSound)
		{	
			[g_BackgroundSound pause];
		}
	}	
}

+(void)ResumeBackgroundSound
{
	if(g_bPlayingBackgroundSound2 == YES)
	{
		if(g_BackgroundSound2)
			[g_BackgroundSound2 play];
	}
	else 
	{
		if(g_BackgroundSound)
		{	
			[g_BackgroundSound play];
		}	
	}	
}	

+(void)StopAllPlayingSound
{
	[SoundSource StopBackgroundSound];
	[SoundSource StopCowMeeo];
	[SoundSource StopCowPupu];
	[SoundSource StopCowKnockdown];
	[SoundSource StopDogBreath];
	[SoundSource StopBlast];
	[SoundSource StopCollision];
	[SoundSource StopJump];
	[SoundSource StopCrash];
	[SoundSource StopWin];
	[SoundSource StopLose];
	[SoundSource StopThunder];
}	

+(void)PauseAllPlayingSound
{
	[SoundSource PauseBackgroundSound];
	[SoundSource PauseCowMeeo];
	[SoundSource PauseCowPupu];
	[SoundSource PauseCowKnockdown];
	[SoundSource PauseDogBreath];
	[SoundSource PauseBlast];
	[SoundSource PauseCollision];
	[SoundSource PauseCrash];
	[SoundSource PauseJump];
	[SoundSource PauseThunder];
}

+(void)ResumeAllPlayingSound
{
	[SoundSource ResumeBackgroundSound];
	[SoundSource ResumeCowMeeo];
	[SoundSource ResumeCowPupu];
	[SoundSource ResumeCowKnockdown];
	[SoundSource ResumeDogBreath];
	[SoundSource ResumeBlast];
	[SoundSource ResumeCollision];
	[SoundSource ResumeJump];
	[SoundSource ResumeCrash];
	[SoundSource ResumeThunder];
}	

+(void)PlayCowMeeo
{
	if(g_CowMeeoSound && g_bPlayingCowMeeoSound == NO)
	{	
		[g_CowMeeoSound play];
		g_bPlayingCowMeeoSound = YES;	
	}	
}	

+(void)StopCowMeeo
{
	if(g_bPlayingCowMeeoSound == YES && g_CowMeeoSound != nil)
	{
		[g_CowMeeoSound stop];
		g_bPlayingCowMeeoSound = NO;	
	}	
}

+(void)PauseCowMeeo
{
	if(g_bPlayingCowMeeoSound == YES && g_CowMeeoSound != nil)
	{
		[g_CowMeeoSound pause];
	}	
}

+(void)ResumeCowMeeo
{
	if(g_bPlayingCowMeeoSound == YES && g_CowMeeoSound != nil)
	{
		[g_CowMeeoSound play];
	}	
}	

+(BOOL)IsPlayCowMeeo
{
    return g_bPlayingCowMeeoSound; 
}

+(void)PlayCowPupu
{
	if(g_CowPupuSound && g_bPlayingCowPupuSound == NO)
	{	
		[g_CowPupuSound play];
		g_bPlayingCowPupuSound = YES;	
	}	
}

+(void)StopCowPupu
{
	if(g_bPlayingCowPupuSound == YES && g_CowPupuSound != nil)
	{
		[g_CowPupuSound stop];
		g_bPlayingCowPupuSound = NO;	
	}	
}	

+(void)PauseCowPupu
{
	if(g_bPlayingCowPupuSound == YES && g_CowPupuSound != nil)
	{
		[g_CowPupuSound pause];
	}	
}

+(void)ResumeCowPupu
{
	if(g_bPlayingCowPupuSound == YES && g_CowPupuSound != nil)
	{
		[g_CowPupuSound play];
	}	
}	

+(BOOL)IsPlayCowPupu
{
    return g_bPlayingCowPupuSound;  
}

+(void)PlayCowKnockdown
{
	if(g_CowKnockdownSound && g_bPlayingCowKnockdownSound == NO)
	{	
		[g_CowKnockdownSound play];
		g_bPlayingCowKnockdownSound = YES;	
	}	
}

+(void)StopCowKnockdown
{
	if(g_bPlayingCowKnockdownSound == YES && g_CowKnockdownSound != nil)
	{
		[g_CowKnockdownSound stop];
		g_bPlayingCowKnockdownSound = NO;	
	}	
}

+(void)PauseCowKnockdown
{
	if(g_bPlayingCowKnockdownSound == YES && g_CowKnockdownSound != nil)
	{
		[g_CowKnockdownSound pause];
	}	
}

+(void)ResumeCowKnockdown
{
	if(g_bPlayingCowKnockdownSound == YES && g_CowKnockdownSound != nil)
	{
		[g_CowKnockdownSound play];
	}	
}	

+(BOOL)IsPlayCowKnockdown
{
    return g_bPlayingCowKnockdownSound; 
}

+(void)PlayDogBreath
{
	if(g_DogBreathSound != nil && g_bPlayingDogBreathSound == NO)
	{
		[g_DogBreathSound play];
		g_bPlayingDogBreathSound = YES;
	}	
}

+(void)StopDogBreath
{
	if(g_DogBreathSound != nil && g_bPlayingDogBreathSound == YES)
	{
		[g_DogBreathSound stop];
		g_bPlayingDogBreathSound = NO;
	}	
}	

+(void)PauseDogBreath
{
	if(g_DogBreathSound != nil && g_bPlayingDogBreathSound == YES)
	{
		[g_DogBreathSound pause];
	}	
}

+(void)ResumeDogBreath
{
	if(g_DogBreathSound != nil && g_bPlayingDogBreathSound == YES)
	{
		[g_DogBreathSound play];
	}	
}	

+(void)PlayBlast
{
	if(g_BlastSound != nil)
	{
		if(g_bPlayingBlastSound == YES)
			[g_BlastSound stop];
			
		[g_BlastSound play];
		g_bPlayingBlastSound = YES;
	}	
}

+(void)StopBlast
{
	if(g_BlastSound != nil && g_bPlayingBlastSound == YES)
	{
		[g_BlastSound stop];
		g_bPlayingBlastSound = NO;
	}	
}

+(void)PauseBlast
{
	if(g_BlastSound != nil && g_bPlayingBlastSound == YES)
	{
		[g_BlastSound pause];
	}	
}

+(void)ResumeBlast
{
	if(g_BlastSound != nil && g_bPlayingBlastSound == YES)
	{
		[g_BlastSound play];
	}	
}	


+(void)PlayCollision
{
	if(g_CollisionSound != nil)
	{
		if(g_bPlayingCollisionSound == YES)
			[g_CollisionSound stop];
		
		[g_CollisionSound play];
		g_bPlayingCollisionSound = YES;
	}	
}

+(void)StopCollision
{
	if(g_CollisionSound != nil && g_bPlayingCollisionSound == YES)
	{
		[g_CollisionSound stop];
		g_bPlayingCollisionSound = NO;
	}	
}

+(void)PauseCollision
{
	if(g_CollisionSound != nil && g_bPlayingCollisionSound == YES)
	{
		[g_CollisionSound pause];
	}	
}

+(void)ResumeCollision
{
	if(g_CollisionSound != nil && g_bPlayingCollisionSound == YES)
	{
		[g_CollisionSound play];
	}	
}	

+(void)PlayJump
{
	if(g_JumpSound && g_bPlayingJumpSound == NO)
	{	
		[g_JumpSound play];
		g_bPlayingJumpSound = YES;	
	}	
}
	
+(void)StopJump
{
	if(g_bPlayingJumpSound == YES && g_JumpSound != nil)
	{
		[g_JumpSound stop];
		g_bPlayingJumpSound = NO;	
	}	
}

+(void)PauseJump
{
	if(g_bPlayingJumpSound == YES && g_JumpSound != nil)
	{
		[g_JumpSound pause];
	}	
}

+(void)ResumeJump
{
	if(g_bPlayingJumpSound == YES && g_JumpSound != nil)
	{
		[g_JumpSound play];
	}	
}


+(void)PlayCrash
{
	if(g_CrashSound != nil)
	{
		if(g_bPlayingCrashSound == YES)
			[g_CrashSound stop];
		
		[g_CrashSound play];
		g_bPlayingCrashSound = YES;
	}	
}

+(void)StopCrash
{
	if(g_CrashSound != nil && g_bPlayingCrashSound == YES)
	{
		[g_CrashSound stop];
		g_bPlayingCrashSound = NO;
	}	
}

+(void)PauseCrash
{
	if(g_CrashSound != nil && g_bPlayingCrashSound == YES)
	{
		[g_CrashSound pause];
	}	
}

+(void)ResumeCrash
{
	if(g_CrashSound != nil && g_bPlayingCrashSound == YES)
	{
		[g_CrashSound play];
	}	
}

+(void)PlayThunder
{
	if(g_ThunderSound != nil)
	{
		if(g_bPlayingThunderSound == YES)
			[g_ThunderSound stop];
		
		[g_ThunderSound play];
		g_bPlayingThunderSound = YES;
	}	
    
}

+(void)StopThunder
{
	if(g_ThunderSound != nil && g_bPlayingThunderSound == YES)
	{
		[g_ThunderSound stop];
		g_bPlayingThunderSound = NO;
	}	
}

+(void)PauseThunder
{
	if(g_ThunderSound != nil && g_bPlayingThunderSound == YES)
	{
		[g_ThunderSound pause];
	}	
}

+(void)ResumeThunder
{
	if(g_ThunderSound != nil && g_bPlayingThunderSound == YES)
	{
		[g_ThunderSound play];
	}	
}


+(void)PlayWin
{
	if(g_WinSound)
	{
        g_bPlayingWinSound = YES;	
		[g_WinSound play];
	}	
}

+(void)StopWin
{
	if(g_WinSound)
	{
        g_bPlayingWinSound = NO;	
		[g_WinSound stop];
	}	
}

+(void)PlayLose
{
	if(g_LoseSound)
	{
        g_bPlayingLoseSound = YES;	
		[g_LoseSound play];
	}	
}

+(void)StopLose
{
	if(g_LoseSound)
	{
        g_bPlayingLoseSound = NO;	
		[g_LoseSound stop];
	}	
}

+(BOOL)IsPlayWin
{
    return g_bPlayingWinSound;	
    
}

+(BOOL)IsPlayLose
{
    return g_bPlayingLoseSound;
}

+(void)StopPlaySoundFile:(AVAudioPlayer *)player
{
	if(player == g_CowMeeoSound)
	{
		[SoundSource StopCowMeeo];
	}	
	else if(player == g_CowPupuSound)
	{
		[SoundSource StopCowPupu];
	}	
	else if(player == g_CowKnockdownSound)
	{
		[SoundSource StopCowKnockdown];
	}	
	else if(player == g_DogBreathSound)
	{
		[SoundSource StopDogBreath];
	}	
	else if(player == g_BlastSound)
	{
		[SoundSource StopBlast];
	}	
	else if(player == g_CollisionSound)
	{
		[SoundSource StopCollision];
	}	
	else if(player == g_JumpSound)
	{
		[SoundSource StopJump];
	}	
	else if(player == g_CrashSound)
	{
		[SoundSource StopCrash];
	}	
	else if(player == g_WinSound)
	{
		[SoundSource StopWin];
        setGamePlayState(GAME_PLAY_READY);
        [GUIEventLoop SendEvent:GUIID_EVENT_RESETGAME eventSender:nil];
	}	
	else if(player == g_LoseSound)
	{
		[SoundSource StopLose];
        setGamePlayState(GAME_PLAY_READY);
        [GUIEventLoop SendEvent:GUIID_EVENT_RESETGAME eventSender:nil];
	}
	else if(player == g_ThunderSound)
	{
		[SoundSource StopThunder];
	}	
}	


@end
