//
//  Blockage.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-11.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "AlienData.h"
#import "Blockage.h"
#import "Configuration.h"
#import "RenderHelper.h"

#define GAME_BLOCKAGE_SHAKING_ANGLE  10

@implementation Blockage

@synthesize	m_EventDispatcher;
@synthesize m_BlockTarget;

-(id)init
{
	if(self = [super init])
	{
        // Initialization code
		m_Alien = [[[AlienData alloc] init] retain]; 
		m_nTimerElaspe = [Configuration getBlockageTimerElapse];
		m_nTimerStep = 0;
		[m_Alien setSize:CGSizeMake([CGameLayout GetDogHeight]*0.5, [CGameLayout GetDogHeight]*0.325)];
		m_bShaking = NO;
		m_fShakingAngle = GAME_BLOCKAGE_SHAKING_ANGLE;
		m_nShakeStep = 0;
		//m_Image = nil;
        m_nImageType = 0;
    }
    return self;
}

//-(void)setImage:(CGImageRef)image
//{
//	m_Image = image;
//	[m_Alien setSize:CGSizeMake(CGImageGetWidth(m_Image), CGImageGetHeight(m_Image))];
//}	
-(void)setImageType:(int)nType
{
    m_nImageType = nType;
}

-(void)setShaking:(BOOL)bShaking
{
	m_bShaking = bShaking;
}	

- (void)dealloc 
{
//	CGImageRelease(m_Image);
	[m_Alien release];
    [super dealloc];
}

//Alien Data functions
-(void)reset
{
	[m_Alien reset];
	m_nTimerStep = 0;
	m_BlockTarget = nil;
	m_nTimerElaspe = [Configuration getBlockageTimerElapse];
	m_nShakeStep = 0;
}

-(void)blast
{
	//[m_Alien blast];
	//++m_nBlastAnimationStep;
}

-(void)startMotion
{
	[m_Alien startMotion];
}	

-(BOOL)isBlast
{
	return [m_Alien isBlast];
}


-(BOOL)isMotion
{
	return [m_Alien isMotion];
}	

-(BOOL)isStop
{
	return [m_Alien isStop];
}	

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt
{
	[m_Alien moveTo:pt];
}

-(CGPoint)getPosition
{
	return [m_Alien getPosition];
}

-(CGSize)getSize
{
	return [m_Alien getSize];
}

-(void)setSize:(CGSize)size
{
	[m_Alien setSize:size];
}

-(CGRect)getBound
{
	return [m_Alien getBound];
}

-(enHitObjectState)getHitTestState
{
	return [m_Alien getHitTestState];
}

-(BOOL)hitTestWithPoint:(CGPoint)point
{
	return [m_Alien hitTestWithPoint:point];
}

-(BOOL)hitTestWithRect:(CGRect)rect
{
	return [m_Alien hitTestWithRect:rect];
}

-(void)setSpeed:(CGPoint)pt
{
	[m_Alien setSpeed:pt];
}

-(CGPoint)getSpeed
{
	return [m_Alien getSpeed];
}	

-(void)detachTarget
{
	if(m_BlockTarget != nil)
		m_BlockTarget = nil;
}	

//Location and size in screen view coordinate
-(CGSize)getSizeInView						//Base on game view coordinate system
{
	return [m_Alien getSizeInView];
}

-(CGRect)getBoundInView					//Base on game view coordinate system
{
	return [m_Alien getBoundInView];
}

-(CGPoint)getPositionInView				//Base on game view coordinate system
{
	return [m_Alien getPositionInView];
}

-(void)updateTimerEvent
{
	if([self isMotion] == YES)
	{
		CGPoint pt = [self getPosition];
		CGPoint v = [self getSpeed];

		if(m_BlockTarget != nil)
			[m_BlockTarget pushBack:v];
		
		pt.x += v.x;
		pt.y += v.y;
		[self moveTo:pt];
		
		if(m_bShaking == YES)
		{
			m_nShakeStep = (m_nShakeStep+1)%3;
		}	
		
		if([self outOfSceneBound] == YES)
		{
			[self reset];
		}	
	}
}

-(BOOL)onTimerEvent
{
	BOOL bRet = NO;
	
	if([self isBlast] == YES || [self isMotion] == YES)
	{
		++m_nTimerStep;
		if(m_nTimerElaspe <= m_nTimerStep)
		{
			m_nTimerStep = 0;
			[self updateTimerEvent];
			bRet = YES;
		}	
	}
	
	return bRet;
}

-(BOOL)outOfSceneBound
{
	BOOL bRet = NO;
	
	if([self isMotion] == YES || [self isBlast] == YES)
	{	
		bRet = [m_Alien outOfSceneBound];
	}
	
	return bRet;
}

-(void)setTimerElaspe:(int)nInterval
{
	m_nTimerElaspe = nInterval;
}

-(void)drawMotion:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
  	CGRect rt = [self getBoundInView];
	if(m_bShaking == YES && m_nShakeStep != 1)
	{
		float fSign = ((float)m_nShakeStep)-1.0f;
		float angle = fSign*m_fShakingAngle;
		float cx = rt.origin.x+rt.size.width*0.5;
		float cy = rt.origin.y+rt.size.height*0.5;
		
		CGContextTranslateCTM(context, cx, cy);
		CGContextRotateCTM(context, angle*M_PI/180.0f);
		CGContextTranslateCTM(context, -cx, -cy);
	}
	//CGContextDrawImage(context, rt, m_Image);
    if(m_nImageType == 0)
    {	
        [RenderHelper DrawRock1:context atRect:rt];
    }
    else if(m_nImageType == 1)
    {	
        [RenderHelper DrawSnail:context atRect:rt];
    }
    else
    {	
        [RenderHelper DrawRock2:context atRect:rt];
    }
	CGContextRestoreGState(context);
}

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
	if([self isMotion] == YES)
	{
        if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT)
        {
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.3);
        }
		[self drawMotion:context inRect:rect];
        if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT)
        {
            CGContextRestoreGState(context);
        }
	}	
}	

@end
