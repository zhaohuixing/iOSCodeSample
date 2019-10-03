//
//  PlayerObject.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-27.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "BulletObject.h"
#import "GunEventDelegate.h"
#import "Gun.h"
#import "PlayerObject.h"
#import "ImageLoader.h"
#import "Configuration.h"
#import "Blockage.h"
#import "RenderHelper.h"

#define GAME_PLAYER_DEAD_SIZE_FACTOR	0.38

#define GAME_PLAYER_WALKSHOOT_SRCIMAGE_WIDTH        270  //Hardcode value 
#define GAME_PLAYER_WALKSHOOT_SRCIMAGE_HEIGHT       370  //Hardcode value

#define GAME_PLAYER_WALKSHOOT_X_RATIO               0.7  //Hardcode value 
#define GAME_PLAYER_WALKSHOOT_X_RATIO_HALFREVERSE   0.15  //Hardcode value 
#define GAME_PLAYER_WALKSHOOT_Y_RATIO               1.4  //Hardcode value
#define GAME_PLAYER_MOUTHSHOOT_Y_RATIO              1.2  //Hardcode value
 

@implementation PlayerObject

@synthesize m_Gun;
@synthesize m_touchPoint;
@synthesize m_EventDispatcher;
@synthesize m_Blockage;

- (void)setToStartPosition
{
	[self moveTo:CGPointMake(0.0, [CGameLayout GetDogHeight]*0.5)];
}	

- (id)init 
{
    if ((self = [super init])) 
	{
        // Initialization code
		m_Player = [[[PlayerData alloc] init] retain];
		m_Gun = nil;	
		m_nTimerStep = 0;
		m_nAnimationStep = 0;
		m_nShootStep = 0;
		
		m_nTapStep1 = -1;
		m_nTapStep2 = -1;
		
		m_nJumpStep = 0;
		m_nJumpShootStep = 0;
		m_fJumpAngle = 0.0;
		m_nDeadStep = 0;	
		m_DeathAnimationOffset = CGPointMake(0.0, 0.0);
		m_bTouched = NO;
		float w = [CGameLayout GetDogWidth];//getPlayerWidth();
		float h = [CGameLayout GetDogHeight];//getPlayerHeight();
		[self setSize:CGSizeMake(w, h)];
		[self setToStartPosition];
    
		float clrvals[] = {1.0, 0.5, 0.2, 0.6};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(3, 0);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc 
{

    CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
    
    [m_Player release];
    [super dealloc];
}

-(BOOL)isNormalAnimation
{
	BOOL bRet = NO;
	if([self isStop] == YES || ([self isMotion] == YES && [self isShootAndMotion] == NO))
	{
		bRet = YES;
	}	
	return bRet;
}	

-(BOOL)isNormalShootAnimation
{
	BOOL bRet = NO;
	if([self isShoot] == YES && [self isShootAndJump] == NO)
	{
		bRet = YES;
	}	
	return bRet;
}	

-(BOOL)isNormalJumpAnimation
{
	BOOL bRet = NO;
	if([self isJump] == YES && [self isShootAndJump] == NO)
	{
		bRet = YES;
	}	
	return bRet;
}	

-(BOOL)isJumpShootAnimation
{
	BOOL bRet = NO;
	if([self isShootAndJump] == YES)
	{
		bRet = YES;
	}	
	return bRet;
}	

-(BOOL)isInTap1
{
	BOOL bRet = NO;
	if(0 <= m_nTapStep1 && m_nTapStep1 <= GAME_TAP_STEP)
	{
		bRet = YES;
	}	
	return bRet;
}

-(void)enterTap1
{
	m_nTapStep1 = 0;
	m_nTapStep2 = -1;
}

-(BOOL)isInWaitTap2
{
	BOOL bRet = NO;
	if(0 <= m_nTapStep2 && m_nTapStep2 <= GAME_TAP_STEP)
	{
		bRet = YES;
	}	
	return bRet;
}

-(void)enterTap2;
{
	m_nTapStep2 = 0;
	m_nTapStep1 = -1;
}

-(BOOL)isInTapState
{
	BOOL bRet = NO;
	if([self isInTap1] == YES || [self isInWaitTap2] == YES)
	{
		bRet = YES;
	}	
	return bRet;
}

-(void)cleanTapFlags
{
	m_nTapStep1 = -1;
	m_nTapStep2 = -1;
}	

-(void)setTouched:(BOOL)bTouched
{
	m_bTouched = bTouched;
}

-(BOOL)isTouched
{
	return m_bTouched;
}	

//PlayData handle function
-(void)reset
{
	if(m_Blockage != nil)
		[m_Blockage detachTarget];
	m_Blockage = nil;
	[m_Player reset];
	[self setToStartPosition];
	m_bTouched = NO;
}

-(void)startMotion
{
	[m_Player startMotion];
}

-(void)updateJumpPosition
{
	float fbaseY = [self getSize].height*0.5;
	float fv = [self getSize].width;
	float fh = 0.0;
	if(m_Blockage != nil)
	{	Blockage* block = (Blockage*)m_Blockage;
		fv = [block getSize].width+[self getSize].width;
		fh = [block getSize].height*2.0;
	}
	
	float fx = fv/5.0;
	float fy = fh/3.0;

	CGPoint pt = [self getPosition];
	
	switch (m_nJumpStep) 
	{
		case 0:
			pt.x -= fx;
			pt.y += fy;
			break;
		case 1:
			pt.x -= fx;
			pt.y += fy;
			break;
		case 2:
			pt.x -= fx;
			pt.y += fy;
			break;
		case 3:
			pt.x -= fx;
			pt.y -= fy;
			break;
		case 4:
			pt.x -= fx;
			pt.y -= fy;
			break;
		case 5:
			pt.x -= fx;
			pt.y -= fy;
			break;
	}
	if([self isJump] == NO || pt.y < fbaseY)
		pt.y = fbaseY;
	
	[self moveTo:pt];
	pt = [self getPosition];
	if(pt.x < ([CGameLayout GetGameSceneWidth]*(-0.5)))
	{
		pt.x = [CGameLayout GetGameSceneWidth]*(-0.5);
		[self moveTo:pt];
	}	
}

-(void)startJump
{
	if([Configuration canPlayerJump] == NO)
		return;
	
	m_nJumpStep = 0;
	m_fJumpAngle = 60.0;
	m_nJumpShootStep = 0;
	if([self isNormalShootAnimation] == YES)
	{
		m_nJumpShootStep = m_nShootStep;
		m_nShootStep = 0; 
		if(GAME_SHOOT_FRAME <= m_nJumpShootStep)
		{
			[self stopShoot];
		}	
	}	
	if(m_EventDispatcher)
		[m_EventDispatcher PlaySound:GAME_SOUND_ID_JUMP];
	
	[m_Player startJump];
	[self updateJumpPosition];
}

-(void)stopJump
{
	//Reset the player location first
	[m_Player stopJump];
	
	m_nJumpStep = 0;
	m_fJumpAngle = 0.0;
	[self cleanTapFlags];
	[self updateJumpPosition];
	if([self isShoot] == YES)
	{
		m_nShootStep = m_nJumpShootStep;
		m_nJumpShootStep = 0; 
		if(GAME_SHOOT_FRAME <= m_nJumpShootStep)
		{
			[self stopShoot];
			m_nJumpShootStep = 0;
		}	
	}	
	if(m_Blockage != nil)
		[m_Blockage detachTarget];
	
	m_Blockage = nil;
	if(m_EventDispatcher)
		[m_EventDispatcher SwitchToBackgroundSound];
}	

-(void)stopMotion
{
	[m_Player stopMotion];
}

-(void)startShoot
{
	m_nShootStep = 0;
	if(m_Gun != nil && 0 < [m_Gun bulletInGun])
	{
		if(m_EventDispatcher)
			[m_EventDispatcher PlaySound:GAME_SOUND_ID_PLAYERSHOOT];
		//CGPoint pt = [self getHeadPosition];
        CGRect rt = [self getBound];
        
        float h = rt.size.height*GAME_PLAYER_WALKSHOOT_Y_RATIO;
        float sx = rt.origin.x + rt.size.width*GAME_PLAYER_WALKSHOOT_X_RATIO_HALFREVERSE*1.4;
        float sy = rt.origin.y + h*0.9;
		if([Configuration isUseFacialGesture])
        {
            sx = rt.origin.x + rt.size.width*0.4;
            sy = rt.origin.y + h*0.4;
        }
        
        CGPoint pt = CGPointMake(sx, sy);
        
		CGPoint v = CGPointMake(GAME_DEFAULT_PLAYER_BULLET_SPEED_X, GAME_DEFAULT_PLAYER_BULLET_SPEED_Y);
		[m_Gun shootAt:pt withSpeed:v];
	}	
}

-(void)stopShoot
{
	[m_Player stopShoot];
	m_nShootStep = 0;
}

-(void)dead
{
	if(m_EventDispatcher)
		[m_EventDispatcher PlaySound:GAME_SOUND_ID_CRASH];
	
	float x = 0.0;
	float y = 0.0;
	if([self isJump] == YES)
	{
		Blockage* block = (Blockage*)m_Blockage;
		float ylast = [CGameLayout GetDogHeight]*0.5;
		CGRect brt = [block getBound];
		CGPoint cpt = [self getPosition];
		CGSize size = [self getSize];
		float xlast;
		if(m_nJumpStep == 0 || m_nJumpStep == 1) 
		{
			brt = [block getBound];
			cpt = [self getPosition];
			size = [self getSize];
			xlast = brt.origin.x + brt.size.width+size.width*0.5;
			x = (xlast - cpt.x)/(GAME_DEFAULT_PLAYER_DEATH_STEP-1);
			y = (ylast - cpt.y)/(GAME_DEFAULT_PLAYER_DEATH_STEP-1);
			[self stopJump];
		}
		else
		{
			brt = [block getBound];
			cpt = [self getPosition];
			size = [self getSize];
			xlast = brt.origin.x - size.width*0.5;
			x = (xlast - cpt.x)/(GAME_DEFAULT_PLAYER_DEATH_STEP-1);
			y = (ylast - cpt.y)/(GAME_DEFAULT_PLAYER_DEATH_STEP-1);
			[self stopJump];
		}	
	}
	m_DeathAnimationOffset = CGPointMake(x, y);
	[m_Player dead];
	m_nDeadStep = 0;	
}

-(void)deadToGround
{
	if(m_EventDispatcher)
		[m_EventDispatcher PlaySound:GAME_SOUND_ID_CRASH];
	
	CGPoint pt = [self getPosition];
	pt.y = [CGameLayout GetDogHeight]*0.5;
	[self moveTo:pt];
	
	m_nDeadStep = GAME_DEFAULT_PLAYER_DEATH_STEP;
	[m_Player dead];
	if(m_EventDispatcher != nil)
		[m_EventDispatcher GameLose];
}	

-(BOOL)isMotion
{
	return [m_Player isMotion];
}

-(BOOL)isJump
{
	return [m_Player isJump];
}

-(BOOL)isShoot
{
	return [m_Player isShoot];
}

-(BOOL)isShootAndMotion
{
	return [m_Player isShootAndMotion];
}

-(BOOL)isShootAndJump
{
	return [m_Player isShootAndJump];
}	

-(BOOL)isStop
{
	return [m_Player isStop];
}

-(BOOL)isDead
{
	return [m_Player isDead];
}	

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt
{
	[m_Player moveTo:pt];
}

-(void)setSize:(CGSize)size
{
	[m_Player setSize:size];
}

-(CGPoint)getPosition
{
	return [m_Player getPosition];
}

-(CGPoint)getHeadPosition
{
	return [m_Player getHeadPosition];
}	

-(CGSize)getSize
{
	return [m_Player getSize];
}

-(CGRect)getBound
{
	return [m_Player getBound];
}

-(enHitObjectState)getHitTestState
{
	return [m_Player getHitTestState];
}

-(BOOL)hitTestWithPoint:(CGPoint)point
{
	return [m_Player hitTestWithPoint:point];
}

-(BOOL)hitTestWithRect:(CGRect)rect
{
	return [m_Player hitTestWithRect:rect];
}

-(BOOL)hitHead:(CGPoint)point
{
	return [m_Player hitHead:point];
}

-(BOOL)hitBody:(CGPoint)point
{
	return [m_Player hitHead:point];
}	


//Location and size in screen view coordinate
-(CGSize)getSizeInView						//Base on game view coordinate system
{
	return [m_Player getSizeInView];
}

-(CGRect)getBoundInView					//Base on game view coordinate system
{
	return [m_Player getBoundInView];
}

-(CGPoint)getPositionInView				//Base on game view coordinate system
{
	return [m_Player getPositionInView];
}

//GunOwnership functions
-(void)fire
{
	[m_Player startShoot];
}	

-(int)bulletInGun
{
	int nRet = 0;
	if(m_Gun != nil)
	{
		nRet = [m_Gun bulletInGun];
	}	
	return nRet;
}

//GunTarget function
-(BOOL)hit:(BulletObject*)bullet
{
	CGRect rect = [bullet getBound];
	if([self hitTestWithRect:rect] == YES)
	{	
		[self dead];
		return YES;
	}	
		
	return NO;
}	

-(void)updateDeadState
{
	if(m_nDeadStep < GAME_DEFAULT_PLAYER_DEATH_STEP)
	{
		++m_nDeadStep;
		CGPoint pt = [self getPosition];
		pt.x += m_DeathAnimationOffset.x;
		pt.y += m_DeathAnimationOffset.y;
		[self moveTo:pt];
		
		if(m_nDeadStep == GAME_DEFAULT_PLAYER_DEATH_STEP)
		{
			pt.y = [CGameLayout GetDogHeight]*0.5;
			[self moveTo:pt];
			if(m_EventDispatcher != nil)
				[m_EventDispatcher GameLose];
		}	
	}	
}

-(void)updateJumpState
{
	if([Configuration canPlayerJump] == NO)
		return;
	
	++m_nJumpStep;
    if([self isShoot] == YES)
	{
		++m_nJumpShootStep;
		if(GAME_SHOOT_FRAME <= m_nJumpShootStep)
		{
			[self stopShoot];
			m_nJumpShootStep = 0;
		}	
	}
	
	if(GAME_SHOOT_FRAME <= m_nJumpStep)
	{
		[self stopJump];
		return;
	}	
	else 
	{	
		switch (m_nJumpStep) 
		{
			case 0:
				m_fJumpAngle = 60.0;
				break;
			case 1:
				m_fJumpAngle = 30.0;
				break;
			case 2:
				m_fJumpAngle = 0.0;
				break;
			case 3:
				m_fJumpAngle = -60.0;
				break;
			case 4:
				m_fJumpAngle = -45.0;
				break;
		}
		[self updateJumpPosition];
	}

}	

-(void)timerEventUpdate
{
	if([self isNormalAnimation] == YES)
	{	
		m_nAnimationStep = (m_nAnimationStep+1)%5;
		float fbaseY = [self getSize].height*0.5;
		CGPoint pt = [self getPosition];
		if(fbaseY < pt.y)
		{
			pt.y = fbaseY;
			[self moveTo:pt];
		}	
	}
	else if([self isNormalShootAnimation] == YES)
	{
		++m_nShootStep;
		if(GAME_SHOOT_FRAME <= m_nShootStep)
		{
			[self stopShoot];
		}	
		float fbaseY = [self getSize].height*0.5;
		CGPoint pt = [self getPosition];
		if(fbaseY < pt.y)
		{
			pt.y = fbaseY;
			[self moveTo:pt];
		}	
	}	
	else if([self isJump] == YES)
	{
		[self updateJumpState];
	}
	else if([self isDead] == YES)
	{
		[self updateDeadState];
	}	
}
	
-(BOOL)onTimerEvent
{
	++m_nTimerStep;
	
	if([self isInTap1] == YES)
	{
		++m_nTapStep1;
		if(GAME_TAP_STEP < m_nTapStep1)
		{
			[self cleanTapFlags];
		}	
	}	
	else if([self isInWaitTap2] == YES)
	{	
		++m_nTapStep2;
		if(GAME_TAP_STEP < m_nTapStep2)
		{
			[self cleanTapFlags];
		}	
	}

	
	//if(GAME_TIMER_PLAYER_STEP <= m_nTimerStep)
	//{
		m_nTimerStep = 0;
		[self timerEventUpdate];
		return YES;
	//}	
	
	return NO;
}

-(void)drawNormal:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
    if([Configuration isUseFacialGesture])
    {
        float cx = rt.origin.x+rt.size.width*0.5;
        float cy = rt.origin.y+rt.size.height*0.5;
        float fAngle = 0.0;
        if(m_nAnimationStep == 0 || m_nAnimationStep == 3)
            fAngle = 0.0;
        else if(m_nAnimationStep == 4)
            fAngle = -10.0;
        else 
            fAngle = 10.0*m_nAnimationStep;
            
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, cx, cy);
        CGContextRotateCTM(context, fAngle*M_PI/180.0f);
        CGContextTranslateCTM(context, -cx, -cy);
        [RenderHelper DrawMouthNormal:context atRect:rt];
        CGContextRestoreGState(context);
        
    }
    else
    {
        if(isGamePlayReady())
            [RenderHelper DrawDogWalk:context withIndex:0 atRect:rt];
        else         
            [RenderHelper DrawDogWalk:context withIndex:m_nAnimationStep atRect:rt];
    }    
}	

-(void)drawNormalShoot:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
    if([Configuration isUseFacialGesture])
    {
        float w = rt.size.width;
        float h = rt.size.height*GAME_PLAYER_MOUTHSHOOT_Y_RATIO;
        float sx = rt.origin.x;
        float sy = rt.origin.y + rt.size.height - h;
        CGRect rt1 = CGRectMake(sx, sy, w, h);
        if(m_nShootStep == 0 || m_nShootStep == 4)
            [RenderHelper DrawMouthBeath1:context atRect:rt1];
        else if(m_nShootStep == 1 || m_nShootStep == 3)
            [RenderHelper DrawMouthBeath2:context atRect:rt1];
        else
            [RenderHelper DrawMouthBeath3:context atRect:rt1];
    }
    else 
    {    
        float w = rt.size.width*GAME_PLAYER_WALKSHOOT_X_RATIO;
        float h = rt.size.height*GAME_PLAYER_WALKSHOOT_Y_RATIO;
        float sx = rt.origin.x + rt.size.width*GAME_PLAYER_WALKSHOOT_X_RATIO_HALFREVERSE;
        float sy = rt.origin.y + rt.size.height - h;
        CGRect rt1 = CGRectMake(sx, sy, w, h);
        [RenderHelper DrawDogShoot:context withIndex:m_nShootStep atRect:rt1];
    }    
}	

#define DOG_JUMP_X_RATIO            1.042
#define DOG_JUMP_Y_RATIO            0.88


-(void)drawNormalJump:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
	
    if(m_nJumpStep == 2 || m_nJumpStep == 3 | m_nJumpStep == 4)
    {
        rt.size.width = rt.size.width*DOG_JUMP_X_RATIO;
        rt.size.height = rt.size.height*DOG_JUMP_Y_RATIO;
    }
        
    float cx = rt.origin.x+rt.size.width*0.5;
	float cy = rt.origin.y+rt.size.height*0.5;
	
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, m_fJumpAngle*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
	if([Configuration isUseFacialGesture])
        [RenderHelper DrawMouthNormal:context atRect:rt];
    else    
        [RenderHelper DrawDogJump:context withIndex:m_nJumpStep atRect:rt];
	
	
	CGContextRestoreGState(context);
}	

-(void)drawJumpShoot:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
    if(m_nJumpStep == 2 || m_nJumpStep == 3 || m_nJumpStep == 4)
    {
        rt.size.width = rt.size.width*DOG_JUMP_X_RATIO;
        rt.size.height = rt.size.height*DOG_JUMP_Y_RATIO;
    }
    if([Configuration isUseFacialGesture])
        rt.size.height = rt.size.height*GAME_PLAYER_MOUTHSHOOT_Y_RATIO;
        
	
    float cx = rt.origin.x+rt.size.width*0.5;
	float cy = rt.origin.y+rt.size.height*0.5;
	
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, m_fJumpAngle*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
	
	if([Configuration isUseFacialGesture])
    {    
        if(m_nShootStep == 0 || m_nShootStep == 4)
            [RenderHelper DrawMouthBeath1:context atRect:rt];
        else if(m_nShootStep == 1 || m_nShootStep == 3)
            [RenderHelper DrawMouthBeath2:context atRect:rt];
        else
            [RenderHelper DrawMouthBeath3:context atRect:rt];
    }
    else
        [RenderHelper DrawDogJumpShoot:context withIndex:m_nJumpStep atRect:rt];
	
	
	CGContextRestoreGState(context);
}	

-(void)drawDeath:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
	float w = rt.size.width*1.2;
    float h = w*GAME_PLAYER_DEAD_SIZE_FACTOR;
	float sx = rt.origin.x;
	float sy = rt.origin.y+rt.size.height-h;
	
	CGRect nrt = CGRectMake(sx, sy, w, h);
	
	CGContextSaveGState(context);

	if([Configuration isUseFacialGesture])
        [RenderHelper DrawMouthNormal:context atRect:nrt];
    else
        [RenderHelper DrawDogDeath:context atRect:nrt];
	CGContextRestoreGState(context);
}	

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
    if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT)
    {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, m_ShadowSize, 6, m_ShadowClrs);
    }
    
	if([self isNormalAnimation] == YES)
		[self drawNormal:context inRect:rect];
	else if([self isNormalShootAnimation] == YES)
		[self drawNormalShoot:context inRect:rect];
	else if([self isNormalJumpAnimation] == YES)
		[self drawNormalJump:context inRect:rect];
	else if([self isJumpShootAnimation] == YES)
		[self drawJumpShoot:context inRect:rect];
	else if([self isDead] == YES)
		[self drawDeath:context inRect:rect];

    if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT)
    {
        CGContextRestoreGState(context);
    }    
}	

-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect
{
    float x = 0.0;
    float y = [CGameLayout GetGameSceneWiningCenterY];
    float rw = [CGameLayout GetRainBowWidth];
    CGSize size = [self getSize];
    float wh = rw*GAME_SCENCE_WIN_SIGN_CENTER_Y_RATIO;
    y = y - wh*0.5+size.height;  
     
    x = [CGameLayout GameSceneToDeviceX:x];
    y = [CGameLayout GameSceneToDeviceY:y];
    float w = [CGameLayout ObjectMeasureToDevice:size.width];
    float h = [CGameLayout ObjectMeasureToDevice:size.height];
    CGRect rt = CGRectMake(x-w*0.5, y, w, h);    
  
    float w1 = rt.size.width*GAME_PLAYER_WALKSHOOT_X_RATIO;
    float h1 = rt.size.height*GAME_PLAYER_WALKSHOOT_Y_RATIO;
    float sx = rt.origin.x + rt.size.width*GAME_PLAYER_WALKSHOOT_X_RATIO_HALFREVERSE;
    float sy = rt.origin.y + rt.size.height - h1;
    CGRect rt1; 
    if([Configuration isUseFacialGesture])
    {
        w1 = rt.size.width;
        h1 = rt.size.height*GAME_PLAYER_MOUTHSHOOT_Y_RATIO;
        sx = rt.origin.x;
        rt1 = CGRectMake(sx, sy, w1, h1);
        [RenderHelper DrawMouthBeath3:context atRect:rt1];
    }
    else
    {    
        rt1 = CGRectMake(sx, sy, w1, h1);
        [RenderHelper DrawDogShoot:context withIndex:2 atRect:rt1];
    }    
}	

//BlockTarget function
-(void)pushBack:(CGPoint)point
{
	CGPoint pt = [self getPosition];
	pt.y += point.y;	
	pt.x += point.x;
	[self moveTo:pt];
	if([m_Player outOfSceneBound] == YES)
	{
		if(m_EventDispatcher != nil)
			[m_EventDispatcher GameLose];
	}
}

-(BOOL)blockBy:(id)blockage
{
	BOOL bRet = NO;
	
	Blockage* block = (Blockage*)blockage;
	if(block != nil)
	{
		CGPoint pt = [block getPosition];
		CGPoint mypt = [self getPosition];
		if(([block hitTestWithPoint:mypt] == YES || [self hitTestWithPoint:pt] == YES) && pt.x <= mypt.x)
		{
			bRet = YES;
			block.m_BlockTarget = self;
			m_Blockage = block;
			mypt.x = pt.x + ([block getSize].width+[self getSize].width)/2;
			[self moveTo:mypt];
		    if(m_EventDispatcher)
				[m_EventDispatcher PlayBlockageSound];
		}	
	}	
	
	return bRet;
}	

-(BOOL)isBlocked
{
	if(m_Blockage != nil)
		return YES;
	else 
		return NO;
}	

-(BOOL)hitTestWithBlockage:(id)blockage
{
	BOOL bRet = NO;
	
	Blockage* block = (Blockage*)blockage;
	if(block != nil)
	{
		CGRect rt = [block getBound];
		if([self hitTestWithRect:rt] == YES)
		{
			bRet = YES;
		}	
	}	
	
	return bRet;
}

-(void)escapeFromBlockage:(id)blockage
{
	Blockage* block = (Blockage*)blockage;
	if(block != nil)
	{
		CGRect rt = [block getBound];
		CGPoint pt = [self getPosition];
		CGSize size = [self getSize];
		pt.x = rt.origin.x - size.width*0.5;
		[self moveTo:pt];
	}	
}	

-(BOOL)moveBackFromBlockage:(float)x
{
	if(m_Blockage != nil && 0 < x)
	{
		Blockage* block = (Blockage*)m_Blockage;
		CGRect myrt = [self getBound];
		CGRect blkrt = [block getBound];
		if((blkrt.origin.x+blkrt.size.width) < (myrt.origin.x + x))
		{
			CGPoint mypt = [self getPosition];
			mypt.x += x;
			[self moveTo:mypt];
			block.m_BlockTarget = nil;
			m_Blockage = nil;
		    if(m_EventDispatcher)
				[m_EventDispatcher SwitchToBackgroundSound];
			return YES;
		}	
	}	
	return NO;
}

-(BOOL)resetPosition
{
	if(m_Blockage == nil)
	{	
		[self setToStartPosition];
		return YES;
	}
	
	return NO;
}	

@end
