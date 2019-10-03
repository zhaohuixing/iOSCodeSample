//
//  AlienObject.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-28.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "BulletObject.h"
#import "AlienObject.h"
#import "Configuration.h"
#import "ImageLoader.h"
#import "RenderHelper.h"

@implementation AlienObject

@synthesize	m_EventDispatcher;

-(id)init:(int)index
{
	if(self = [super init])
	{
        // Initialization code
		m_Alien = [[[AlienData alloc] init] retain]; 
		m_nTimerElaspe = [Configuration getAlienTimerElapse];
		m_nTimerStep = 0;
		m_nBlastAnimationStep = 0;
		m_nBlastCount = GAME_DEFAULT_PLAYER_BULLET_BLAST_STEP;
		int nRand = getRandNumberBySeed(index%298818);
		if(nRand%2 == 0)
		{
			//m_Image = [ImageLoader LoadCloudImage1];
			//m_Image2 = [ImageLoader LoadRainImage1];
            m_ImageType = 1;
		}
		else 
		{
			//m_Image = [ImageLoader LoadCloudImage2];
			//m_Image2 = [ImageLoader LoadRainImage2];
            m_ImageType = 0;
		}
		float fWidth = [Configuration getRandomCloudWidth:nRand%6];
		nRand = getRandNumberBySeed(nRand%298299);
		float fHeight = [Configuration getRandomCloudHeight:nRand%5];
		if(fWidth < fHeight)
		{
			float ft = fHeight; 
			fHeight = fWidth;
			fWidth = ft;
		}	
		
		[m_Alien setSize:CGSizeMake(fWidth, fHeight)];
		//m_BlastAnimation = [ImageLoader LoadBlastImage:fWidth andHeight:fHeight];

		m_fShakeY = (float)(nRand%12);
		m_nShakingStep = 0;
		m_nShakingCount = nRand%20;
        
        m_nBirdAnimation = 0;
        //m_nBirdShootAnimation = 0;
        
	}
    return self;
}

- (void)dealloc 
{
	//CGImageRelease(m_Image);
	//CGImageRelease(m_BlastAnimation);
	//CGImageRelease(m_Image2);
	[m_Alien release];
    [super dealloc];
}

//Alien Data functions
-(void)reset
{
	[m_Alien reset];
	m_nTimerStep = 0;
	m_nTimerElaspe = [Configuration getAlienTimerElapse];
	m_nBlastAnimationStep = 0;
	m_nShakingStep = 0;
	m_fShakeY = fabs(m_fShakeY);
    m_nBirdAnimation = 0;
    //m_nBirdShootAnimation = 0;
}

-(enAlienType)getAlienType
{
    return [m_Alien getAlienType];
}

-(void)setAlienType:(enAlienType)enType
{
    [m_Alien setAlienType:enType];
}

-(void)blast
{
	if(m_EventDispatcher)
		[m_EventDispatcher PlaySound:GAME_SOUND_ID_BLAST];
	[m_Alien blast];
	++m_nBlastAnimationStep;
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

-(BOOL)hit:(BulletObject*)bullet
{
	CGRect rect = [bullet getBound];
	if([self hitTestWithRect:rect] == YES)
	{
		[self blast];
		return YES;
	}	
	
	return NO;
}	

//Location and size in screen view coordinate
-(CGSize)getSizeInView						//Base on game view coordinate system
{
	return [m_Alien getSizeInView];
}

-(CGRect)getBoundInView					//Base on game view coordinate system
{
    if([Configuration getThunderTheme] == YES && [m_Alien getAlienType] == GAME_ALIEN_TYPE_CLOUD)
    {
        CGPoint pt = [m_Alien getPosition];
        CGSize size = [m_Alien getSize];
        float x = [CGameLayout GameSceneToDeviceX:pt.x];
        float y = [CGameLayout GameSceneToDeviceY:pt.y];
        float w = [CGameLayout ObjectMeasureToDevice:size.width];
        float h = [CGameLayout ObjectMeasureToDevice:size.width];
        CGRect rect = CGRectMake(x-w*0.5, y-h*0.5, w, h);
        return rect;
    }
    else
    {    
        return [m_Alien getBoundInView];
    }    
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
		pt.x += v.x;
		pt.y += v.y;
		
		if([Configuration canAlienShaking] == YES)
		{
			pt.y += m_fShakeY;
			if([CGameLayout GetGameSceneHeight] <= pt.y)
			{
				pt.y = [CGameLayout GetGameSceneHeight]-1; 
			}	
			++m_nShakingStep;
			if(m_nShakingCount <= m_nShakingStep)
			{
				m_nShakingStep = 0;
				m_fShakeY *= -1.0;
			}
		}	
		[m_Alien updateBirdBubbleSize];
		[self moveTo:pt];
		if([self outOfSceneBound] == YES)
		{
			[self reset];
		}	
	}
	else if([self isBlast] == YES)
	{
		++m_nBlastAnimationStep;
		if(m_nBlastCount <= m_nBlastAnimationStep)
		{
			[self reset];
		}
	}	
}

-(BOOL)onTimerEvent
{
	BOOL bRet = NO;
	
    m_nBirdAnimation = (m_nBirdAnimation+1)%4;
    //++m_nBirdShootAnimation;
	if([self isBlast] == YES || [self isMotion] == YES)
	{
		++m_nTimerStep;
        if([self getAlienType] == GAME_ALIEN_TYPE_CLOUD)
        {    
            if(m_nTimerElaspe <= m_nTimerStep)
            {
                m_nTimerStep = 0;
                [self updateTimerEvent];
                bRet = YES;
            }
        }
        else
        {
            int nAcceleration = [Configuration getBirdFlyingAcceleration];
            if(m_nTimerElaspe/nAcceleration <= m_nTimerStep)
            {
                m_nTimerStep = 0;
                [self updateTimerEvent];
                bRet = YES;
            }
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
	CGRect rt = [self getBoundInView];
    enAlienType enType = [self getAlienType];
    if(enType == GAME_ALIEN_TYPE_CLOUD)
    {    
        if([Configuration getThunderTheme] == YES)
        {
            if(m_ImageType == 0)
                [RenderHelper DrawRainCloud1:context atRect:rt];
            else 
                [RenderHelper DrawRainCloud2:context atRect:rt];
            //CGContextDrawImage(context, rt, m_Image2);
        }
        else
        {    
            if(m_ImageType == 0)
                [RenderHelper DrawCloud1:context atRect:rt];
            else 
                [RenderHelper DrawCloud2:context atRect:rt];
            //CGContextDrawImage(context, rt, m_Image);
        }
    }
    else if(enType == GAME_ALIEN_TYPE_BIRD)
    {
        enAlienBirdState enState = [m_Alien getBirdState];
        if(enState == GAME_ALIEN_BIRD_MOTION)
        {
            if(m_nBirdAnimation == 0)
                [RenderHelper DrawBirdFly1:context atRect:rt];
            else if(m_nBirdAnimation == 1)
                [RenderHelper DrawBirdFly2:context atRect:rt];
            else if(m_nBirdAnimation == 2)
                [RenderHelper DrawBirdShoot1:context atRect:rt];
            else
                [RenderHelper DrawBirdShoot2:context atRect:rt];
        }
    }
    else if(enType == GAME_ALIEN_TYPE_BIRD_BUBBLE)
    {
        [RenderHelper DrawBirdBubble:context atRect:rt];
    }
}

-(void)drawBlast:(CGContextRef)context inRect:(CGRect)rect
{
	if(m_nBlastCount <= m_nBlastAnimationStep)
		return;
	
	CGRect rt = [self getBoundInView];
	float cx = rt.origin.x+rt.size.width*0.5;
	float cy = rt.origin.y+rt.size.height*0.5;
	float fAngle = ((float)(m_nBlastAnimationStep+1))/((float)m_nBlastCount);
	float w1 = rt.size.width*(1-fAngle);
	float h1 = rt.size.height*(1-fAngle);
	float w2 = rt.size.width*fAngle;
	float h2 = rt.size.height*fAngle;
	
	if(0 < w1 && 0 < h1)
	{	
		CGRect rt1 = CGRectMake(cx-w1*0.5, cy-h1*0.5, w1, h1); 
        enAlienType enType = [self getAlienType];
        if(enType == GAME_ALIEN_TYPE_CLOUD)
        {    
            if([Configuration getThunderTheme] == YES)
            {
                if(m_ImageType == 0)
                    [RenderHelper DrawRainCloud1:context atRect:rt1];
                else 
                    [RenderHelper DrawRainCloud2:context atRect:rt1];
                //CGContextDrawImage(context, rt1, m_Image2);
            }
            else
            {    
                if(m_ImageType == 0)
                    [RenderHelper DrawCloud1:context atRect:rt1];
                else 
                    [RenderHelper DrawCloud2:context atRect:rt1];
                //CGContextDrawImage(context, rt1, m_Image);
            }
        }   
        else if(enType == GAME_ALIEN_TYPE_BIRD)
        {
            enAlienBirdState enState = [m_Alien getBirdState];
            if(enState == GAME_ALIEN_BIRD_MOTION)
            {
                if(m_nBirdAnimation == 0)
                    [RenderHelper DrawBirdFly1:context atRect:rt];
                else if(m_nBirdAnimation == 1)
                    [RenderHelper DrawBirdFly2:context atRect:rt];
                else if(m_nBirdAnimation == 2)
                    [RenderHelper DrawBirdShoot1:context atRect:rt];
                else
                    [RenderHelper DrawBirdShoot2:context atRect:rt];
            }
        }
        else if(enType == GAME_ALIEN_TYPE_BIRD_BUBBLE)
        {
            [RenderHelper DrawBirdBubble:context atRect:rt];
        }
	}
	CGRect rt2 = CGRectMake(cx-w2*0.5, cy-h2*0.5, w2, h2); 
	//CGContextDrawImage(context, rt2, m_BlastAnimation);
    [RenderHelper DrawBlast:context atRect:rt2];
}

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
	if([self isMotion] == YES)
	{
        if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT)
        {
            CGContextSaveGState(context);
            if([self getAlienType] == GAME_ALIEN_TYPE_CLOUD)
                CGContextSetAlpha(context, 0.3);
        }
		[self drawMotion:context inRect:rect];
        if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT)
        {
            CGContextRestoreGState(context);
        }
	}	
	else if([self isBlast] == YES)
	{
		[self drawBlast:context inRect:rect];
	}	
    
    
}	

@end
