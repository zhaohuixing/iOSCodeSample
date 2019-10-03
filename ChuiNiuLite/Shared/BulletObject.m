//
//  BulletObject.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-07-28.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "BulletObject.h"
#import "GunEventDelegate.h"
#import "Configuration.h"
#import "ImageLoader.h"
#import "RenderHelper.h"

@implementation BulletObject

@synthesize	m_EventDispatcher;
@synthesize	m_bBubble;
@synthesize	m_fStartRatioX;
@synthesize	m_fStartRatioY;
@synthesize	m_fChangeRatioX;
@synthesize	m_fChangeRatioY;


-(id)initWithGun:(id)gun inFrame:(CGRect)frame
{
    //if ((self = [super initWithFrame:frame])) 
    if ((self = [super init])) 
	{
        // Initialization code
		m_Bullet = [[BulletData alloc] init];//[[[BulletData alloc] init] autorelease];
		m_Gun = gun;
		m_nTimerElaspe = [Configuration getBulletTimerElapse];
		m_nTimerStep = 0;
		m_nBlastAnimationStep = 0;
		m_nBlastCount = GAME_DEFAULT_PLAYER_BULLET_BLAST_STEP;
		[m_Bullet setSize:frame.size];
		m_bBubble = NO;
		m_fOriginalWith = frame.size.width;
		m_fOriginalHeight = frame.size.height;
		m_fStartRatioX = 1.0;
		m_fStartRatioY = 1.0;
		m_fChangeRatioX = 0.0;
		m_fChangeRatioY = 0.0;
        
		float clrvals[] = {1.0, 0.5, 0.2, 0.6};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(3, 0);
	}
    return self;
}

-(void)setTimerElaspe:(int)nInterval
{
	m_nTimerElaspe = nInterval;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)outOfSceneBound
{
	BOOL bRet = NO;
	
	if([self isShoot] == YES || [self isBlast] == YES)
	{	
		CGRect rt = [self getBound];
		if(rt.origin.y < 0)//getGroundHeight())
			return YES;
		
		bRet = [m_Bullet outOfSceneBound];
	}
	
	return bRet;
}	

- (void)dealloc 
{
//	if(m_Image)
//		CGImageRelease(m_Image);
	
    CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
    [super dealloc];
}

//Bullet data function
-(void)shoot
{
	float w = m_fOriginalWith*m_fStartRatioX;
	float h = m_fOriginalWith*m_fStartRatioY;
	[m_Bullet setSize:CGSizeMake(w, h)];
	[m_Bullet shoot];
}

-(void)blast
{
	[m_Bullet blast];
	m_nBlastAnimationStep = 0;
}

-(void)reset
{
	[m_Bullet reset];
	m_nTimerStep = 0;
	m_nTimerElaspe = [Configuration getBulletTimerElapse];
	m_nTimerStep = 0;
	m_nBlastAnimationStep = 0;
	[m_Bullet setSize:CGSizeMake(m_fOriginalWith, m_fOriginalHeight)];
}

-(BOOL)isShoot
{
	return [m_Bullet isShoot];
}

-(BOOL)isBlast
{
	return [m_Bullet isBlast];
}

-(BOOL)isReady
{
	return [m_Bullet isReady];
}	

//GameBaseData handle function
-(void)moveTo:(CGPoint)pt
{
	[m_Bullet moveTo:pt];
}

-(CGPoint)getPosition
{
	return [m_Bullet getPosition];
}

-(CGSize)getSize
{
	return [m_Bullet getSize];
}

-(CGRect)getBound
{
	return [m_Bullet getBound];
}

-(void)setSpeed:(CGPoint)pt
{
	[m_Bullet setSpeed:pt];
}

-(CGPoint)getSpeed
{
	return [m_Bullet getSpeed];
}	

-(enHitObjectState)getHitTestState
{
	return [m_Bullet getHitTestState];
}

-(BOOL)hitTestWithPoint:(CGPoint)point
{
	return [m_Bullet hitTestWithPoint:point];
}

-(BOOL)hitTestWithRect:(CGRect)rect
{
	return [m_Bullet hitTestWithRect:rect];
}

-(BOOL)hit:(BulletObject*)bullet
{
	CGRect rect = [bullet getBound];
	if([self hitTestWithRect:rect] == YES)
	{	
		return YES;
	}	
	
	return NO;
}	


-(void)updateTimerEvent
{
	if([self isShoot] == YES)
	{
		CGPoint pt = [self getPosition];
		CGPoint v = [self getSpeed];
		CGSize size = [self getSize];
		pt.x += v.x;
		pt.y += v.y;
		[self moveTo:pt];
		size.width += m_fChangeRatioX*m_fOriginalWith;
	    if(m_fOriginalWith <= size.width)
			size.width = m_fOriginalWith;
		size.height += m_fChangeRatioY*m_fOriginalHeight;
	    if(m_fOriginalHeight <= size.height)
			size.height = m_fOriginalHeight;
		
		[m_Bullet setSize:size];
		
		if([self outOfSceneBound] == YES)
		{
			[self blast];
		}	
	}
	else if([self isBlast] == YES)
	{
		++m_nBlastAnimationStep;
		float fRatio = ((float)(m_nBlastAnimationStep-m_nBlastAnimationStep))/((float)m_nBlastAnimationStep);
		CGSize size = [self getSize];
		size.width *= fRatio;
		size.height *= fRatio;
		[m_Bullet setSize:size];
		if(m_nBlastCount <= m_nBlastAnimationStep)
		{
			[m_Gun bulletBlasted:self];
		}
	}	
}

-(BOOL)onTimerEvent
{
	BOOL bRet = NO;
	
	if([self isBlast] == YES || [self isShoot] == YES)
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

//Location and size in screen view coordinate
-(CGSize)getSizeInView						//Base on game view coordinate system
{
	return [m_Bullet getSizeInView];
}

-(CGRect)getBoundInView					//Base on game view coordinate system
{
	return [m_Bullet getBoundInView];
}

-(CGPoint)getPositionInView				//Base on game view coordinate system
{
	return [m_Bullet getPositionInView];
}

-(void)drawShoot:(CGContextRef)context inRect:(CGRect)rect
{
//	if(m_Image == NULL)
//		return;
	
	CGRect rt = [self getBoundInView];
//	CGContextDrawImage(context, rt, m_Image);
    if(m_bBubble)
        [RenderHelper DrawAirBubble:context atRect:rt];
    else
        [RenderHelper DrawPoop:context atRect:rt];
}

-(void)drawBlast:(CGContextRef)context inRect:(CGRect)rect
{
//	if(m_Image == NULL)
//		return;
	
	CGRect rt = [self getBoundInView];
//	CGContextDrawImage(context, rt, m_Image);
    if(m_bBubble)
        [RenderHelper DrawAirBubble:context atRect:rt];
    else
        [RenderHelper DrawPoop:context atRect:rt];
}

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    if([Configuration getBackgroundSetting] == GAME_BACKGROUND_NIGHT)
    {
        CGContextSetAlpha(context, 0.5);
        CGContextSetShadowWithColor(context, m_ShadowSize, 5, m_ShadowClrs);
    }
    
	if([self isShoot] == YES)
	{
		[self drawShoot:context inRect:rect];
	}	
	else if([self isBlast] == YES)
	{
		[self drawBlast:context inRect:rect];
	}	
    CGContextRestoreGState(context);
}	

@end
