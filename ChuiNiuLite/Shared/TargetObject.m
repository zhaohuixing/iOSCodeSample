//
//  TargetObject.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-28.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "BulletObject.h"
#import "GunEventDelegate.h"
#import "Gun.h"
#import "AlienObject.h"
#import "TargetObject.h"
#import "PlayerObject.h"
#import "Configuration.h"
#import "ImageLoader.h"
#import "RenderHelper.h"


@implementation TargetObject

@synthesize	m_EventDispatcher;
@synthesize m_Gun;

- (void)setToStartPosition
{
	[self moveTo:CGPointMake(0.0, [CGameLayout GetGameSceneHeight] - [CGameLayout GetCowHeight]*0.5)];
}

- (void)loadImages
{
	float w = [CGameLayout GetCowWidth]*GAME_RATIO_ZOOM;
	float h = [CGameLayout GetCowHeight]*GAME_RATIO_ZOOM;
	m_Animations[0] = [ImageLoader LoadCowImage1:w andHeight:h]; 
	m_Animations[1] = [ImageLoader LoadCowImage2:w andHeight:h]; 
	m_Animations[2] = [ImageLoader LoadCowImage3:w andHeight:h];
	m_Animations[3] = [ImageLoader LoadCowImage2:w andHeight:h]; 
	m_Animations[4] = [ImageLoader LoadCowImage1:w andHeight:h]; 
	m_Animations[5] = [ImageLoader LoadCowImage4:w andHeight:h];
	
	m_AnimationAngle[0] = 0.0;
	m_AnimationAngle[1] = 8.0;
	m_AnimationAngle[2] = 16.0;
	m_AnimationAngle[3] = 8.0;
	m_AnimationAngle[4] = 0.0;
	m_AnimationAngle[5] = -8.0;
	
	
	m_DeathAnimation = [ImageLoader LoadDeadCowImage:w andHeight:h];

	//m_BlastAnimation = [ImageLoader LoadBlastImage:w andHeight:h];
}	

- (id)init 
{
    if ((self = [super init])) 
	{
        // Initialization code
		m_Target = [[[TargetData alloc] init] retain];
		float w = [CGameLayout GetCowWidth];
		float h = [CGameLayout GetCowHeight];
		[self setSize:CGSizeMake(w, h)];
		[self setToStartPosition];
		[self setSpeed:CGPointMake(GAME_DEFAULT_TARGET_SPEED_X, [Configuration getTargetSpeedY])];
		m_nTimerStep = 0;
		m_nTimerElapse = [Configuration getTargetTimerStep];
		m_fBack = GAME_DEFAULT_TARGET_FLOAT_SPEED_Y;
		
		m_nShootStep = 0;
		m_nShootMaxInterval = GAME_DEFAULT_TARGET_SHOOT_THRESHED;
		m_nShootThreshold = getRandNumber()%m_nShootMaxInterval+1;
		
		m_nAnimationStep = 0;
		m_nKnockDownStep = 0;
		m_fKnockDownStepLenght = 0.0;
		
		m_nHitThreshold = [Configuration getTargetHitLimit];
		m_nHitCount = 0;
		m_nHitCountStep = 0;
		m_nHitDeducable = [Configuration getTargetHitDeductable];
	
		m_nAnimationDelay = 0;
		m_nAnimationDelayThreshold = [Configuration getTargetAnimationDelayThreshold];
		
		[self loadImages];
	
		float clrvals[] = {1.0, 0.5, 0.2, 0.6};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(3, 0);
    
    }
    return self;
}

- (void)dealloc 
{
	for(int i = 0; i < GAME_TARGET_ANIMATION_FRAME; ++i)
		CGImageRelease(m_Animations[i]);
	
	CGImageRelease(m_DeathAnimation);
	//CGImageRelease(m_BlastAnimation);
    
    CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
    
	[m_Target release];
    [super dealloc];
}

//Target data functions
-(void)reset
{
	[m_Target reset];
	[self setToStartPosition];
	
	m_nTimerStep = 0;
	m_fBack = GAME_DEFAULT_TARGET_FLOAT_SPEED_Y;
	
	m_nShootStep = 0;
	m_nShootMaxInterval = GAME_DEFAULT_TARGET_SHOOT_THRESHED;
	m_nShootThreshold = getRandNumber()%m_nShootMaxInterval+1;
	
	m_nAnimationStep = 0;
	m_nKnockDownStep = 0;
	m_fKnockDownStepLenght = 0.0;
	
	m_nHitThreshold = [Configuration getTargetHitLimit];
	m_nHitCount = 0;
	m_nHitCountStep = 0;
	m_nHitDeducable = [Configuration getTargetHitDeductable];

	m_nBlowOutStep = 0;
	m_nTimerElapse = [Configuration getTargetTimerStep];
	
	m_nAnimationDelay = 0;
	m_nAnimationDelayThreshold = [Configuration getTargetAnimationDelayThreshold];
	[self setSpeed:CGPointMake(GAME_DEFAULT_TARGET_SPEED_X, [Configuration getTargetSpeedY])];
}

-(void)shoot
{
	[m_Target shoot];
	if(m_Gun != nil && 0 < [m_Gun bulletInGun])
	{
		if(m_EventDispatcher)
			[m_EventDispatcher PlaySound:GAME_SOUND_ID_TARGETSHOOT];
		CGPoint pt = [self getGunPoint];
		[m_Gun shootAt:pt withSpeed:[Configuration getTargetBulletSpeed]];
	}	
}

-(void)crash
{
	CGPoint pt = [self getPosition];
	pt.y = [self getSize].height*0.5;
	[self moveTo:pt];
	[m_Target crash];
	if(m_EventDispatcher != nil)
		[m_EventDispatcher GameLose];
}

-(void)blowout
{
	if(m_EventDispatcher != nil)
	{	
		[m_EventDispatcher StopSound:GAME_SOUND_ID_TARGETHORN];
		[m_EventDispatcher PlaySound:GAME_SOUND_ID_BLAST];
	}	
	m_nBlowOutStep = 0;
	[m_Target blowout];
}

-(void)knockdown
{
	[m_Target knockdown];
}

-(BOOL)detectHitPlayer
{
	PlayerObject* plyerobj = (PlayerObject*)m_Gun.m_Target;
	if(plyerobj != nil)
	{	
		CGRect port = [plyerobj getBound];
		if([self hitTestWithRect:port] == YES)
		{
			[plyerobj deadToGround];
		    [self crash];
			return YES;
		}	
	}	
	return NO;
}	

-(void)updateKnockDownPosition
{
	CGPoint pt = [self getPosition];
    pt.y += m_fKnockDownStepLenght;
	[self moveTo:pt];
	[self detectHitPlayer];
}

-(void)updateHitBearingState
{
	if(m_nHitThreshold < m_nHitCount)
	{
		[self blowout];
	}
	else if(m_nHitThreshold*3/5 <= m_nHitCount)
	{
		if(m_EventDispatcher != nil)
			[m_EventDispatcher PlaySound:GAME_SOUND_ID_TARGETHORN];
	}

}

-(BOOL)hit:(BulletObject*)bullet
{
	CGRect rect = [bullet getBound];
	if([self isNormal] == YES && [self hitTestWithRect:rect] == YES)
	{	
		CGPoint pt = [self getPosition];
		pt.y += m_fBack;
		[self moveTo:pt];
		pt = [self getPosition];
		float h = [CGameLayout GetGameSceneHeight];
		float myh = [self getSize].height*0.5;
		if(h < pt.y+myh)
		{	
			pt.y = h-myh; 
			[self moveTo:pt];
		}
		
		if([Configuration canTargetBlast] == YES)
		{
			++m_nHitCount;
			[self updateHitBearingState];
		}	
		return YES;
	}	
	
	return NO;
}

-(BOOL)knockdownBy:(AlienObject*)alien
{
	CGRect rect = [alien getBound];
	if([self hitTestWithRect:rect] == YES)
	{
		if(m_EventDispatcher)
			[m_EventDispatcher PlaySound:GAME_SOUND_ID_TARGETKNOCKDOWN];
		CGPoint pt = [self getPosition];
		CGSize size = [self getSize];
		m_nKnockDownStep = 0;
		m_fKnockDownStepLenght = (size.width*0.5-pt.y)/GAME_TARGET_KNOCKDOWN_FRAME;
		[self knockdown];
		[self updateKnockDownPosition];
		return YES;
	}	
	
	return NO;
}

-(BOOL)isShoot
{
	return [m_Target isShoot];
}

-(BOOL)isCrash
{
	return [m_Target isCrash];
}

-(BOOL)isBlowout
{
	return [m_Target isBlowout];
}

-(BOOL)isKnockout
{
	return [m_Target isKnockout];
}	

-(BOOL)isNormal
{
	return [m_Target isNormal];
}

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt
{
	[m_Target moveTo:pt];
}

-(void)setSize:(CGSize)size
{
	[m_Target setSize:size];
}

-(CGPoint)getPosition
{
	return [m_Target getPosition];
}

-(CGSize)getSize
{
	return [m_Target getSize];
}

-(CGRect)getBound
{
	return [m_Target getBound];
}

-(void)setSpeed:(CGPoint)pt
{
	[m_Target setSpeed:pt];
}

-(CGPoint)getSpeed
{
	return [m_Target getSpeed];
}	


-(enHitObjectState)getHitTestState
{
	return [m_Target getHitTestState];
}

-(BOOL)hitTestWithPoint:(CGPoint)point
{
	return [m_Target hitTestWithPoint:point];
}

-(BOOL)hitTestWithRect:(CGRect)rect
{
	return [m_Target hitTestWithRect:rect];
}

//GunOwnership functions
-(void)fire
{
	[m_Target reset];
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

//Location and size in screen view coordinate
-(CGSize)getSizeInView						//Base on game view coordinate system
{
	return [m_Target getSizeInView];
}

-(CGRect)getBoundInView					//Base on game view coordinate system
{
	return [m_Target getBoundInView];
}

-(CGPoint)getPositionInView				//Base on game view coordinate system
{
	return [m_Target getPositionInView];
}

-(void)updateKnockDownTimerEvent
{
	if(m_nKnockDownStep < GAME_TARGET_KNOCKDOWN_FRAME)
	{
		++m_nKnockDownStep;
		[self updateKnockDownPosition];
		if(m_nKnockDownStep == GAME_TARGET_KNOCKDOWN_FRAME && [self isCrash] == NO)
		{
			[self crash];
		}	
	}
}

-(void)updateBlowoutTimerEvent
{
	++m_nHitCountStep;

	if(4 <=	m_nHitCountStep)
	{	
		m_nHitCountStep = 0;
		m_nHitCount = m_nHitCount - m_nHitDeducable;
		if(m_nHitCount < 0)
			m_nHitCount = 0;
	}	
}	
 
-(void)updateBlastTimerEvent
{
	++m_nBlowOutStep;
	if(GAME_TARGET_BLOWOUT_FRAME <= m_nBlowOutStep)
	{
		if(m_EventDispatcher != nil)
			[m_EventDispatcher GameLose];
	}
}
	
-(BOOL)detectHitGround
{
	CGPoint pt = [self getPosition];
	if((pt.y - [self getSize].height*0.5) <= 0)
		return YES;

	return NO;
}


-(void)updateTimerEvent
{
	if([self isNormal] == YES)
	{	
		CGPoint pt = [self getPosition];
		CGPoint v = [self getSpeed];
		pt.x += v.x;
		pt.y += v.y;
		if(pt.y <= 0)
			pt.y = 0;
		
		[self moveTo:pt];
		if([self detectHitGround] == YES)
		{
			[self crash];
			return;
		}	
		
		//???++m_nAnimationDelay;
		//???if(m_nAnimationDelayThreshold <= m_nAnimationDelay)
		//???{
		//???	m_nAnimationDelay = 0;
			m_nAnimationStep = (m_nAnimationStep+1)%GAME_TARGET_ANIMATION_FRAME;
		//???}
		
		if([Configuration canTargetBlast] == YES)
		{
			[self updateBlowoutTimerEvent];
		}	
		if([self detectHitPlayer] == YES)
			return;
	}
	else if([self isKnockout] == YES) 
	{
		[self updateKnockDownTimerEvent];
	}
	else 
	{
		[self updateBlastTimerEvent];
	}


	
	if([Configuration canTargetShoot] == YES && [self isNormal] == YES)
	{
		++m_nShootStep;
		if(m_nShootThreshold <= m_nShootStep)
		{	
			m_nShootThreshold = getRandNumber()%m_nShootMaxInterval+1;
			m_nShootStep = 0;
			[self shoot];
		}	
	}	
}	

-(BOOL)onTimerEvent
{
	BOOL bRet = NO;
	
	++m_nTimerStep;

	if(m_nTimerElapse <= m_nTimerStep)
	{
		m_nTimerStep = 0;
		[self updateTimerEvent];
		bRet = YES;
	}
	
	return bRet;
}

-(void)drawKnockout:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
	float cx = rt.origin.x+rt.size.width*0.5;
	float cy = rt.origin.y+rt.size.height*0.5;
	float fAngle = (-60)*((float)(m_nKnockDownStep+1));
	
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, fAngle*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
	
	CGContextDrawImage(context, rt, m_DeathAnimation);
	
	CGContextRestoreGState(context);
    
    float x = rt.size.height/3;
	rt = CGRectMake(rt.origin.x, rt.origin.y, x, x);
	[RenderHelper DrawHat:context atRect:rt];
	
}

-(void)drawBlast:(CGContextRef)context inRect:(CGRect)rect
{
	if(GAME_TARGET_BLOWOUT_FRAME <= m_nBlowOutStep)
		return;
	
	CGRect rt = [self getBoundInView];
	float cx = rt.origin.x+rt.size.width*0.5;
	float cy = rt.origin.y+rt.size.height*0.5;
	float fAngle = ((float)(m_nBlowOutStep+1))/((float)GAME_TARGET_BLOWOUT_FRAME);
	float w1 = rt.size.width*(1-fAngle);
	float h1 = rt.size.height*(1-fAngle);
	float w2 = rt.size.width*fAngle;
	float h2 = rt.size.height*fAngle;
	if(0 < w1 && 0 < h1)
	{	
		CGRect rt1 = CGRectMake(cx-w1*0.5, cy-h1*0.5, w1, h1); 
		CGContextDrawImage(context, rt1, m_Animations[m_nAnimationStep]);
	}
	CGRect rt2 = CGRectMake(cx-w2*0.5, cy-h2*0.5, w2, h2); 
	//CGContextDrawImage(context, rt2, m_BlastAnimation);
    [RenderHelper DrawBlast:context atRect:rt2];
}

-(void)drawCrash:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
    float x = rt.size.height/3;
	CGRect rt2 = CGRectMake(rt.origin.x, rt.origin.y+rt.size.height-x, x, x);
	[RenderHelper DrawHat:context atRect:rt2];
	CGContextDrawImage(context, rt, m_DeathAnimation);
}

-(void)drawNormalNonHit:(CGContextRef)context inRect:(CGRect)rect
{
	CGRect rt = [self getBoundInView];
	float cx = rt.origin.x+rt.size.width*0.5;
	float cy = rt.origin.y+rt.size.height*0.5;
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, m_AnimationAngle[m_nAnimationStep]*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
	CGContextDrawImage(context, rt, m_Animations[m_nAnimationStep]);
	CGContextRestoreGState(context);
}

-(void)drawNormalHitted:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
	CGRect rt = [self getBoundInView];
	float cx = rt.origin.x+rt.size.width*0.5;
	float cy = rt.origin.y+rt.size.height*0.5;
	
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, m_AnimationAngle[m_nAnimationStep]*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
	
	CGContextDrawImage(context, rt, m_Animations[m_nAnimationStep]);
	CGContextClipToMask(context, rt, m_Animations[m_nAnimationStep]);
	float fRatio = ((float)m_nHitCount)/((float)m_nHitThreshold);
	
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	CGFloat colors[8] = {fRatio, 0.0, 0.0, fRatio, 1.0, 0.0, 0.0, fRatio};
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGPoint pt1, pt2;
	pt1.x = rt.origin.x;
	pt1.y = rt.origin.y;
	pt2.x = rt.origin.x;
	pt2.y = rt.origin.y+rt.size.height;
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	CGContextRestoreGState(context);
}

-(void)drawNormal:(CGContextRef)context inRect:(CGRect)rect
{
	if([Configuration canTargetBlast] == NO || m_nHitCount == 0)
	{
		[self drawNormalNonHit:context inRect:rect];
	}
	else 
	{
		[self drawNormalHitted:context inRect:rect];
	}
}

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
    if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT && [self isBlowout] == NO)
    {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, m_ShadowSize, 6, m_ShadowClrs);
    }
    
	if([self isNormal] == YES)
		[self drawNormal:context inRect:rect];
	else if([self isKnockout] == YES)
		[self drawKnockout:context inRect:rect];
	else if([self isCrash] == YES)
		[self drawCrash:context inRect:rect];
	else if([self isBlowout] == YES)
		[self drawBlast:context inRect:rect];

    if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT && [self isBlowout] == NO)
    {
        CGContextRestoreGState(context);
    }
}	

-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect
{
/*	float x = 0.0;
	float y = [CGameLayout GetGameSceneWiningCenterY];
	float rw = [CGameLayout GetRainBowWidth];
	CGSize size = [self getSize];
	float wh = rw*GAME_SCENCE_WIN_SIGN_CENTER_Y_RATIO;
	y = y - wh*0.5+size.height*0.6;  
	
	x = [CGameLayout GameSceneToDeviceX:x];
	y = [CGameLayout GameSceneToDeviceY:y];
	float w = [CGameLayout ObjectMeasureToDevice:size.width];
	float h = [CGameLayout ObjectMeasureToDevice:size.height];
	CGRect rt = CGRectMake(x-w*0.5, y, w, h);
*/
    float x = 0.0;
    float y = [CGameLayout GetGameSceneWiningCenterY];
    float rw = [CGameLayout GetRainBowWidth];
    CGSize size = [self getSize];
    size.width *= 0.8;
    size.height *= 0.8;
    
    float wh = rw*GAME_SCENCE_WIN_SIGN_CENTER_Y_RATIO;
    y = y + wh*0.5 + size.height*0.75;  
     
    x = [CGameLayout GameSceneToDeviceX:x];
    y = [CGameLayout GameSceneToDeviceY:y];
    float w = [CGameLayout ObjectMeasureToDevice:size.width];
    float h = [CGameLayout ObjectMeasureToDevice:size.height];
    CGRect rt = CGRectMake(x-w*0.5, y, w, h);   
    
	float cx = rt.origin.x+rt.size.width*0.5;
	float cy = rt.origin.y+rt.size.height*0.5;
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, cx, cy);
	CGContextRotateCTM(context, m_AnimationAngle[5]*M_PI/180.0f);
	CGContextTranslateCTM(context, -cx, -cy);
	CGContextDrawImage(context, rt, m_Animations[5]);
	CGContextRestoreGState(context);
}

-(CGPoint)getGunPoint
{
	CGRect rt = [self getBound];
	CGPoint pt = CGPointMake(rt.origin.x+rt.size.width*0.75, rt.origin.y+rt.size.height*0.3);
	return pt;
}

@end
