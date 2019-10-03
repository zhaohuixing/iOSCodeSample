//
//  GameScene.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-27.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "GameView.h"
#import "GameGround.h"
#import "BulletObject.h"
#import "Gun.h"
#import "PlayerObject.h"
#import "AlienObject.h"
#import "TargetObject.h"
#import "ClockObject.h"
#import "GameScene.h"
#import "Configuration.h"
#import "AlienMaster.h"
#import "Blockage.h"
#import "SoundSource.h"
#import "ScoreRecord.h"
#import "ImageLoader.h"
#import "ApplicationMainView.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"

#define THUNDER_ENLARGE         60
#define THUNDER_THRESHOLD       20
#define THUNDER_STEP_THRESHOLD_IPHONE  17
#define THUNDER_STEP_THRESHOLD_IPAD  13
#define THUNDER_STEP_ENLARGE_IPHONE    5
#define THUNDER_STEP_ENLARGE_IPAD    4


@implementation GameScene

@synthesize m_GameView;

-(void)initPlayerGun
{
	float w = [CGameLayout GetPlayerBulletWidth];
	float h = [CGameLayout GetPlayerBulletHeight];
	float xper = [CGameLayout GetPlayerBulletStartRatioX];
	float yper = [CGameLayout GetPlayerBulletStartRatioY];
	float cxper = [CGameLayout GetPlayerBulletChangeRatioX];
	float cyper = [CGameLayout GetPlayerBulletChangeRatioY];
	
	for(int i = 0; i < GAME_DEFAULT_PLAYER_BULLET_NUMBER;++i)
	{
		BulletObject* bullet = [[BulletObject alloc] initWithGun:m_PlayerGun 
														  inFrame:CGRectMake(0.0, 0.0, 
																			 w, h)];
		bullet.m_EventDispatcher = self;
		bullet.m_bBubble = YES;
	    bullet.m_fStartRatioX = xper;
	    bullet.m_fStartRatioY = yper;
	    bullet.m_fChangeRatioX = cxper;
	    bullet.m_fChangeRatioY = cyper;
		[m_PlayerGun addBullet:bullet];
	}	
}

-(void)initTargetGun
{
	float w = [CGameLayout GetTargetBulletWidth];
	float h = [CGameLayout GetTargetBulletHeight];
	float xper = [CGameLayout GetTargetBulletStartRatioX];
	float yper = [CGameLayout GetTargetBulletStartRatioY];
	float cxper = [CGameLayout GetTargetBulletChangeRatioX];
	float cyper = [CGameLayout GetTargetBulletChangeRatioY];
	
	for(int i = 0; i < GAME_DEFAULT_PLAYER_BULLET_NUMBER;++i)
	{
		BulletObject* bullet = [[BulletObject alloc] initWithGun:m_PlayerGun 
														 inFrame:CGRectMake(0.0, 0.0, 
																			w, h)];
		bullet.m_EventDispatcher = self;
		bullet.m_bBubble = NO;//bullet.m_Image = [ImageLoader LoadTargetBulletImage:w andHeight:h];
	    bullet.m_fStartRatioX = xper;
	    bullet.m_fStartRatioY = yper;
	    bullet.m_fChangeRatioX = cxper;
	    bullet.m_fChangeRatioY = cyper;
		[m_TargetGun addBullet:bullet];
	}	
}

-(void)initAliens
{
	for(int i = 0; i < GAME_DEFAULT_ALIEN_NUMBER;++i)
	{
		AlienObject* alien = [[AlienObject alloc] init:i];
		alien.m_EventDispatcher = self;
		[m_Aliens addAlien:alien];
	}	
}

-(void)initBlocks
{
	for(int i = 0; i < GAME_DEFAULT_BLOCK_NUMBER;++i)
	{
		//float rSize = [CGameLayout GetRockSize];
		
		Blockage* block1 = [[Blockage alloc] init];
		block1.m_EventDispatcher = self;
		if(i%2 == 0)
		    [block1 setImageType:0];
		else
		    [block1 setImageType:2];
		[m_Ground addBlocks:block1 atSkill:GAME_SKILL_LEVEL_ONE];
		
		Blockage* block2 = [[Blockage alloc] init];
		block2.m_EventDispatcher = self;
		int n = i%3;
		if(n == 0)
		{	
		    [block2 setImageType:0];
		}
		else if(n == 1)
		{	
		    [block2 setImageType:1];
			[block2 setShaking:YES];
		}
		else
		{	
		    [block2 setImageType:2];
		}
		[m_Ground addBlocks:block2 atSkill:GAME_SKILL_LEVEL_TWO];

		Blockage* block3 = [[Blockage alloc] init];
		block3.m_EventDispatcher = self;
	    [block3 setImageType:1];
		[block3 setShaking:YES];
		[m_Ground addBlocks:block3 atSkill:GAME_SKILL_LEVEL_THREE];
		
	}	
}

-(id)init
{
    self = [super init];
	if(self)
	{
		m_Player = [[PlayerObject alloc] init];
		m_Player.m_EventDispatcher = self;
		m_PlayerGun = [[Gun alloc] init];
		m_PlayerGun.m_Shooter = m_Player;
		m_Player.m_Gun = m_PlayerGun;
		[self initPlayerGun];
		
		m_Target = [[TargetObject alloc] init];
		m_Target.m_EventDispatcher = self;
		m_PlayerGun.m_Target = m_Target;
	    m_PlayerGun.m_EventDispatcher = self;
		
		m_TargetGun = [[Gun alloc] init];
		m_Target.m_Gun = m_TargetGun;
		m_TargetGun.m_Shooter = m_Target;
		m_TargetGun.m_Target = m_Player;
	    m_TargetGun.m_EventDispatcher = self;
		[self initTargetGun];
		m_PlayerGun.m_EmenyGun = m_TargetGun;
		m_TargetGun.m_EmenyGun = m_PlayerGun;
	
		m_Aliens = [[AlienMaster alloc] init];
		m_Aliens.m_EventDispatcher = self;
		[self initAliens];
		m_Aliens.m_Target = m_Target;
		m_PlayerGun.m_Aliens = m_Aliens;
		m_Ground = [[GameGround	alloc] init];
		m_Ground.m_BlockTarget = m_Player;
		m_nGameTimeLength = [Configuration getGameTime];
		m_nGameTimeCounter = 0;
		
		m_Clock = [[ClockObject alloc] init];
	
		
		float clrvals[] = {1.0, 0.2, 0.2, 1.0f};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(10, 10);
		
		m_bDirty = YES;
		
		[self initBlocks];
		[ScoreRecord loadRecord];
 
        int n = getRandNumber();
        m_nThunderThreshod = THUNDER_ENLARGE*(1+n%THUNDER_THRESHOLD);
        if([ApplicationConfigure iPhoneDevice])
            m_nThunderLength = THUNDER_STEP_ENLARGE_IPHONE*(1+n%THUNDER_STEP_THRESHOLD_IPHONE);
        else
            m_nThunderLength = THUNDER_STEP_ENLARGE_IPAD*(1+n%THUNDER_STEP_THRESHOLD_IPAD);
            
        m_nThunderType = 0;     //0: 1 vertical; 1:1 horizontal; 2: 1 verical, 1 horz; 3 2 vertical; 4 2 horz
        m_nThunderStep = -1;
        
        m_LightImage1 = [ImageLoader LoadLightImage1];
        m_LightImage2 = [ImageLoader LoadLightImage2];
        m_fGameStartTimeStample = 0;
        m_bHandlePostWinGameOptions = NO;
        m_bHandlePostLostGameAction = NO;
        
	}
	return self;
}	

-(void)onTimerEvent
{
	if(isGameResultLose() == 1 && m_GameView != nil)
	{
		m_GameView.m_nLoseSceneFlash = (m_GameView.m_nLoseSceneFlash+1)%60;
		if(m_GameView.m_nLoseSceneFlash == 1 || m_GameView.m_nLoseSceneFlash == 31)
		{
			[self invalidRender];
		}
		return;
	}	
	
	if(isGamePlayPlaying() == 0)
    {
        
		return;
	}
    
	++m_nGameTimeCounter;
	if(m_nGameTimeLength <= m_nGameTimeCounter)
	{
		[self GameWin];
		[self invalidRender];
		return;
	}	
	
	int nCount = 0;
	BOOL bRet = NO;
	if(m_Player != nil)
	{	
		bRet = [m_Player onTimerEvent];
		if(bRet == YES)
		{
			++nCount;
			bRet = NO;
		}	
	}
	if(m_PlayerGun != nil)
	{
		bRet = [m_PlayerGun onTimerEvent];
		if(bRet == YES)
		{
			++nCount;
			bRet = NO;
		}	
	}	
	
	if(m_Aliens != nil)
	{
		bRet = [m_Aliens onTimerEvent];
		if(bRet == YES)
		{
			++nCount;
			bRet = NO;
		}	
	}
	
	if(m_Target != nil)
	{
		bRet = [m_Target onTimerEvent];
		if(bRet == YES)
		{
			++nCount;
			bRet = NO;
		}	
	}
	if(m_TargetGun != nil)
	{
		bRet = [m_TargetGun onTimerEvent];
		if(bRet == YES)
		{
			++nCount;
			bRet = NO;
		}	
	}	
	if(m_Ground != nil)
	{
		bRet = [m_Ground onTimerEvent];
		if(bRet == YES)
		{
			++nCount;
			bRet = NO;
		}	
	}	
	if(m_Clock != nil)
	{
		bRet = [m_Clock onTimerEvent];
		if(bRet == YES)
		{
			++nCount;
			bRet = NO;
		}	
	}	
	
    if([Configuration getThunderTheme] == YES && isGamePlayPlaying() == 1)
    {
        if(m_nThunderStep < 0)
        {
            int nCheck = m_nGameTimeCounter%m_nThunderThreshod;
            if(nCheck == m_nThunderThreshod-1)
            {    
                ++nCount;
                m_nThunderStep = 0;
                m_nThunderType = getRandNumber()%5;//m_nGameTimeCounter%5; 
                [self PlaySound:GAME_SOUND_ID_THUNDER];
            }    
        }
        else
        {
            ++nCount;
            ++m_nThunderStep;
            if(m_nThunderLength <= m_nThunderStep)
            {
                m_nThunderStep = -1;
            }
        }
    }
    
	if(0 < nCount)
		[self invalidRender];
}	

-(float)getSceneWidth
{
	return [CGameLayout GetGameSceneWidth];//getGameSceneWidth();
}

-(float)getSceneHeight
{
	return [CGameLayout GetGameSceneHeight];//getGameSceneHeight();
}	

-(void)invalidRender
{
	if(m_GameView != nil)
		[m_GameView invalidate];
}

-(void)updateGameLayout
{
	[self invalidRender];
}	

-(void)drawThunderBrighter:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    if(m_nThunderStep%6 == 0)
        CGContextSetRGBFillColor(context, 0.6, 0.6, 0.6, 0.40);
    else
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.00);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}

-(void)drawThunderDarker:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    if(m_nThunderStep%6 == 0)
        CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 0.70);
    else
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.00);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}

-(void)drawLighting:(CGContextRef)context inRect:(CGRect)rect withAlpha:(float)fAlpha
{
    CGContextSetAlpha(context, fAlpha);
    
    if(m_nThunderType == 0)
    {
        float cx = rect.origin.x + rect.size.width*0.2;
        float cy = rect.origin.y + rect.size.height*0.1;
        float w = 0.6*(rect.size.width < rect.size.height ? rect.size.width : rect.size.height);
        float h = w/3.0;
        CGRect rt = CGRectMake(cx, cy, w, h);
        CGContextDrawImage(context, rt, m_LightImage1);
        
    }
    else if(m_nThunderType == 1)
    {
        float cx = rect.origin.x + rect.size.width*0.25;
        float cy = rect.origin.y + rect.size.height*0.05;
        float h = rect.size.height*0.75;
        float w = h/2.0;
        CGRect rt = CGRectMake(cx, cy, w, h);
        CGContextDrawImage(context, rt, m_LightImage2);
    }
    else if(m_nThunderType == 2)
    {
        float cx = rect.origin.x + rect.size.width*0.1;
        float cy = rect.origin.y + rect.size.height*0.05;
        float h = rect.size.height*0.75;
        float w = h/2.0;
        CGRect rt = CGRectMake(cx, cy, w, h);
        CGContextDrawImage(context, rt, m_LightImage2);
        
        cx = rect.origin.x + rect.size.width*0.6;
        cy = rect.origin.y + rect.size.height*0.1;
        w = 0.6*(rect.size.width < rect.size.height ? rect.size.width : rect.size.height);
        h = w/3.0;
        rt = CGRectMake(cx, cy, w, h);
        CGContextDrawImage(context, rt, m_LightImage1);
    }
    else if(m_nThunderType == 3)
    {
        float cx = rect.origin.x + rect.size.width*0.15;
        float cy = rect.origin.y + rect.size.height*0.05;
        float h = rect.size.height*0.6;
        float w = h/2.0;
        CGRect rt = CGRectMake(cx, cy, w, h);
        CGContextDrawImage(context, rt, m_LightImage2);
        
        h = rect.size.height*0.8;
        w = h/4.0;
        cx = rect.origin.x + rect.size.width*0.65;
        cy = rect.origin.y + rect.size.height*0.2;
        rt = CGRectMake(cx, cy, w, h);
        CGContextDrawImage(context, rt, m_LightImage2);
    }
    else
    {
        float cx = rect.origin.x + rect.size.width*0.15;
        float cy = rect.origin.y + rect.size.height*0.1;
        float w = 0.6*(rect.size.width < rect.size.height ? rect.size.width : rect.size.height);
        float h = w/3.0;
        CGRect rt = CGRectMake(cx, cy, w, h);
        CGContextDrawImage(context, rt, m_LightImage1);
        
        cx = rect.origin.x + rect.size.width*0.3;
        cy = rect.origin.y + rect.size.height*0.65;
        w = 0.70*(rect.size.width < rect.size.height ? rect.size.width : rect.size.height);
        h = w/4.0;
        rt = CGRectMake(cx, cy, w, h);
        CGContextDrawImage(context, rt, m_LightImage1);
    }
        
}

-(void)drawThunderLighting:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    if(m_nThunderStep%5 == 0)
    {    
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.50);
        [self drawLighting:context inRect:rect withAlpha:1.0];
    }    
    else
    {    
        CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 0.8);
        [self drawLighting:context inRect:rect withAlpha:1.0];
    }    
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
}

-(void)drawThunderStorm:(CGContextRef)context inRect:(CGRect)rect
{
    if(m_nThunderStep < (int)((float)m_nThunderLength*0.25))
    {  
        [self drawThunderBrighter:context inRect:rect];
    }
    else if((int)((float)m_nThunderLength*0.75) <= m_nThunderStep && m_nThunderStep <= m_nThunderLength)
    {
        [self drawThunderDarker:context inRect:rect];
    }
    else
    {
        [self drawThunderLighting:context inRect:rect];
    }
}

-(void)drawGame:(CGContextRef)context inRect:(CGRect)rect
{
	if(m_Ground != nil)
		[m_Ground draw:context inRect: rect];
	
	if(m_Player != nil)
		[m_Player draw:context inRect: rect];
	if(m_PlayerGun != nil)
		[m_PlayerGun draw:context inRect: rect];
	if(m_Target != nil)
		[m_Target draw:context inRect: rect];
	if(m_TargetGun != nil)
		[m_TargetGun draw:context inRect: rect];
	if(m_Aliens != nil)
		[m_Aliens draw:context inRect: rect];
	if(m_Clock != nil && [Configuration isClockShown] == YES)
		[m_Clock draw:context inRect: rect];
    
	if(m_Ground != nil)
		[m_Ground drawGrass:context inRect:rect];
    
    if([Configuration getThunderTheme] == YES && isGamePlayPlaying() == 1 && 0 <= m_nThunderStep)
        [self drawThunderStorm:context inRect: rect];
}

-(void)drawGameSceneWin:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, m_ShadowSize, 10, m_ShadowClrs);
	if(m_Ground != nil)
		[m_Ground drawWin:context inRect: rect];
	
	if(m_Aliens != nil)
		[m_Aliens drawWin:context inRect: rect];

	if(m_Player != nil)
		[m_Player drawWin:context inRect: rect];
	if(m_Target != nil)
		[m_Target drawWin:context inRect: rect];
	
	CGContextRestoreGState(context);
	
	if(m_Clock != nil && [Configuration isClockShown] == YES)
		[m_Clock draw:context inRect: rect];

	if(m_Ground != nil)
		[m_Ground drawGrass:context inRect:rect];
    
}	

- (void)dealloc 
{
	[m_Aliens release];
	[m_Player release];
	[m_PlayerGun release];
	[m_Target release];
	[m_TargetGun release];
	[m_Ground release];
	[m_Clock release];
    CGImageRelease(m_LightImage1);
    CGImageRelease(m_LightImage2);
   [super dealloc];
}

-(void)touchBegan:(CGPoint)pt
{
	if(isGamePlayPlaying() == 0)
	{	
		NSLog(@"touchBegan: return in non-playing");
		return;
	}	
	
	if(m_Player != nil)
	{	
		BOOL bRet = [m_Player hitTestWithPoint:pt];
		if(bRet == YES)
		{
			//if([m_Player hitHead:pt] == YES)
			//{
			[m_Player setTouched:YES];
			[m_Player startShoot];
			//	[self invalidRender];	
			//}
			//else 
			//{	
				if([m_Player isJump] == NO && [Configuration canPlayerJump] == YES && [m_Player isBlocked] == YES)
				{	
					if([m_Player isInWaitTap2] == YES)
					{
						[m_Player startJump];
						[self invalidRender];
						return;
					}	
					else if([m_Player isInTap1] == NO)
					{
						[m_Player enterTap1];
					}	
				}	
				[self invalidRender];	

				if([m_Player isBlocked] == NO)
					m_Player.m_touchPoint = pt;
			//}	
		}	
	}	
}

-(void)touchMoved:(CGPoint)pt
{
	if(isGamePlayPlaying() == 0)
	{	
		NSLog(@"touchMoved: return in non-playing");
		return;
	}
	
	if(m_Player != nil)
	{	
		BOOL bRet = [m_Player hitTestWithPoint:pt];
		if(bRet == YES)
		{
			if([m_Player isJump] == NO)
			{	
				[m_Player setTouched:YES];
				if([m_Player isBlocked] == NO && [m_Ground blockageHitTestWithTarget] == NO)
				{	
					float x = pt.x - m_Player.m_touchPoint.x;
					CGPoint pt0 = [m_Player getPosition];
					pt0.x += x;
					[m_Player moveTo:pt0];
					m_Player.m_touchPoint = pt;
					[self invalidRender];
				}
				else 
				{
					float x = pt.x - m_Player.m_touchPoint.x;
					BOOL bUpdate = [m_Player moveBackFromBlockage:x];
					if(bUpdate)
					{	
						m_Player.m_touchPoint = pt;
						[self invalidRender];
					}	
				}
			}	
		}
		else if([m_Player isTouched] == YES)
		{
			if([m_Player isJump] == NO)
			{	
				if([m_Player isBlocked] == NO && [m_Ground blockageHitTestWithTarget] == NO)
				{	
					float x = pt.x - m_Player.m_touchPoint.x;
					CGPoint pt0 = [m_Player getPosition];
					pt0.x += x;
					[m_Player moveTo:pt0];
					m_Player.m_touchPoint = pt;
					[self invalidRender];
				}
				else 
				{
					float x = pt.x - m_Player.m_touchPoint.x;
					BOOL bUpdate = [m_Player moveBackFromBlockage:x];
					if(bUpdate)
					{	
						m_Player.m_touchPoint = pt;
						[self invalidRender];
					}	
				}
			}	
		}	
	}	
}

-(void)touchEnded:(CGPoint)pt
{
    if(isGamePlayPlaying() == 0)
	{	
		NSLog(@"touchEnded: return in non-playing");
        return;
	}	
	
	if(m_Player != nil)
	{	
		BOOL bRet = [m_Player hitTestWithPoint:pt];
		if(bRet == YES && [m_Player hitHead:pt] == NO && [m_Player isJump] == NO)
		{
			if([m_Player isInTap1] == YES)
			{
				[m_Player enterTap2];
			}
			
			if([m_Player isBlocked] == NO && [m_Ground blockageHitTestWithTarget] == NO)
			{	
				float x = pt.x - m_Player.m_touchPoint.x;
				CGPoint pt0 = [m_Player getPosition];
				pt0.x += x;
				[m_Player moveTo:pt0];
				m_Player.m_touchPoint = pt0;
				[self invalidRender];
			}	
		}
		[m_Player setTouched:NO];
	}	
}	

-(BOOL)ShouldHandlePostWinningOptions
{
    return m_bHandlePostWinGameOptions;
}

-(BOOL)ShouldHandlePostLostAction
{
    return m_bHandlePostLostGameAction;
}

-(void)handleLoseResult
{
	setGameResultLose();
	if([Configuration canPlaySound] == YES)
	{
		[SoundSource PlayLose];
	}
	int nSkill = [Configuration getGameSkill];
	int nLevel = [Configuration getGameLevel];
    int nLostScore = [Configuration getGameLostPenalityScore:nSkill inLevel:nLevel];
    [ScoreRecord reduceTotalWinScore:nLostScore];
	[ScoreRecord saveRecord];
    
	if(m_GameView != nil)
	{
		m_GameView.m_nLoseSceneFlash = 0;
		[m_GameView updateGameEndState];
	}	
    m_bHandlePostWinGameOptions = NO;
    m_bHandlePostLostGameAction = YES;
  
    [GUIEventLoop SendEvent:GUIID_EVENT_POSTLOSTMESSAGE eventSender:nil];
}

-(void)handleWinResult
{
	setGameResultWin();
	if([Configuration canPlaySound] == YES)
	{
		[SoundSource PlayWin];
	}	
	
	int nSkill = [Configuration getGameSkill];
	int nLevel = [Configuration getGameLevel];
    int nWinScore = [Configuration getGameWinScore:nSkill inLevel:nLevel];
	[ScoreRecord addScore:nSkill atLevel:nLevel];
    [ScoreRecord addTotalWinScore:nWinScore];
	[ScoreRecord saveRecord];
	if(m_GameView != nil)
	{
		[m_GameView updateGameEndState];
        [m_GameView updatePlayerLobbyWinScore];
	}
    m_bHandlePostWinGameOptions = YES;
    m_bHandlePostLostGameAction = NO;
    [GUIEventLoop SendEvent:GUIID_EVENT_POSTWINMESSAGE eventSender:nil];
}	

-(void)GameLose
{
	[self endGame];
	[self handleLoseResult];
}

-(void)GameWin
{
	[self endGame];
	[self handleWinResult];
}	

-(BOOL)IsPlayingSound
{
	BOOL bRet = NO;
	
	if(isGamePlayPlaying() == 1)
	{
		if(m_GameView != nil)
			bRet = [m_GameView isPlayingSound];
	}	
	
	return bRet; 
}

-(void)PlaySound:(int)sndID
{
	if(isGamePlayPlaying() == 1)
	{
		if(m_GameView != nil)
			[m_GameView playSound:sndID];
	}	
}

-(void)StopSound:(int)sndID
{
	if(isGamePlayPlaying() == 1)
	{
		if(m_GameView != nil)
			[m_GameView stopSound:sndID];
	}	
}	

-(void)PlayBlockageSound
{
	if(isGamePlayPlaying() == 1)
	{
		if(m_GameView != nil)
			[m_GameView playBlockageSound];
	}	
}

-(void)SwitchToBackgroundSound
{
	if(isGamePlayPlaying() == 1)
	{
		if(m_GameView != nil)
			[m_GameView switchToBackgroundSound];
	}	
}	

-(void)startNewGame
{
	if(m_bDirty == YES)
		[self resetGameScene];
    [Configuration clearDirty];
    m_bHandlePostWinGameOptions = NO;
    m_bHandlePostLostGameAction = NO;
	playGame();
	m_bDirty = YES;
	if(m_GameView != nil)
		[m_GameView playBackgroundSound];
	[self invalidRender];
}

-(void)pauseGame
{
	pauseGame();
	if(m_GameView != nil)
		[m_GameView pauseSoundPlay];
	[self invalidRender];
}

-(void)resumeGame
{
	playGame();
	if(m_GameView != nil)
		[m_GameView resumeSoundPlay];
	[self invalidRender];
}

-(void)endGame
{
	m_nGameTimeCounter = 0;
	resetGame();
	if(m_GameView != nil)
		[m_GameView stopAllSoundPlay];
	[self invalidRender];
}

-(void)resetGameScene
{
	m_bDirty = NO;
	resetGame();
	[m_Player reset];
	[m_PlayerGun reset];
	[m_Target reset];
	[m_TargetGun reset];
	[m_Aliens reset];
	[m_Ground reset];
	[m_Clock reset];
	m_nGameTimeLength = [Configuration getGameTime];
	m_nGameTimeCounter = 0;
	[self invalidRender];
    int n = getRandNumber();
    m_nThunderThreshod = THUNDER_ENLARGE*(1+n%THUNDER_THRESHOLD);
    if([ApplicationConfigure iPhoneDevice])
        m_nThunderLength = THUNDER_STEP_ENLARGE_IPHONE*(1+n%THUNDER_STEP_THRESHOLD_IPHONE);
    else
        m_nThunderLength = THUNDER_STEP_ENLARGE_IPAD*(1+n%THUNDER_STEP_THRESHOLD_IPAD);
    m_nThunderType = 0;     //0: 1 vertical; 1:1 horizontal; 2: 1 verical, 1 horz; 3 2 vertical; 4 2 horz
    m_nThunderStep = -1;
}

-(void)adjustPlayerInProtraitMode
{
	if(isGamePlayReady() == 1 || isGamePlayPaused() == 1)
		return;
	
	CGRect rt = [m_Player getBoundInView];
	if([GUILayout GetContentViewWidth] <= rt.origin.x || (rt.origin.x+rt.size.width) <= 0.0)
	{	
		if([m_Player resetPosition] == YES && [Configuration canShootBlock] == YES)
		{
			[m_Ground adjustTargetFreePosition];
		}	
	}
}	

@end
