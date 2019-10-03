//
//  Gun.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 10-07-28.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "BulletObject.h"
#import "GunEventDelegate.h"
#import "Gun.h"


@implementation Gun
@synthesize     m_EventDispatcher;
@synthesize		m_Shooter;
@synthesize		m_Target;
@synthesize     m_Aliens;
@synthesize		m_bBulletReusable;
@synthesize		m_EmenyGun;

-(id)init
{
	if(self = [super init])
	{
		m_Bullets = [[NSMutableArray array] retain];
		m_bBulletReusable = YES;
		m_Shooter = nil;
	}
	
	return self;
}	

- (void)dealloc 
{
	[m_Bullets release];
    [super dealloc];
}

-(void)reset
{
	int nCount = [m_Bullets count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			[(BulletObject*)[m_Bullets objectAtIndex:i] reset];
		}	
	}
}	

-(void)shoot
{
	int nCount = [m_Bullets count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			BulletObject* bullet = (BulletObject*)[m_Bullets objectAtIndex:i];
			if(bullet != nil && [bullet isReady] == YES)
			{
				[bullet moveTo:[self getPosition]];
				[bullet setSpeed:[self getSpeed]];
				[bullet shoot];
				if(m_Shooter != nil)
					[m_Shooter fire];
				
				return;
			}	
		}	
	}
}

-(void)shootAt:(CGPoint)fromPt withSpeed:(CGPoint)speed
{
	int nCount = [m_Bullets count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			BulletObject* bullet = (BulletObject*)[m_Bullets objectAtIndex:i];
			if(bullet != nil && [bullet isReady] == YES)
			{
				[bullet moveTo:fromPt];
				[bullet setSpeed:speed];
				[bullet shoot];
				if(m_Shooter != nil)
					[m_Shooter fire];
				
				return;
			}	
		}	
	}
}	

-(int)bulletInGun
{
	int nRet = 0;
	
	int nCount = [m_Bullets count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			BulletObject* bullet = (BulletObject*)[m_Bullets objectAtIndex:i];
			if(bullet != nil)
			{
				if([bullet isReady] == YES)
					++nRet;
			}	
		}	
	}
	
	
	return nRet;
}	


-(void)bulletBlasted:(BulletObject*)bullet
{
	[bullet reset];
	if(m_bBulletReusable == NO)
	{	
		[m_Bullets removeObjectIdenticalTo:bullet];
	}	
}	

-(BOOL)bulletHitByEmeny:(BulletObject*)bullet
{
	int nCount = [m_Bullets count];
	BOOL bRet = NO;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			BulletObject* mybullet = (BulletObject*)[m_Bullets objectAtIndex:i];
			if(bullet != nil)
			{
				if([mybullet isShoot] == YES)
				{	
					if([mybullet hit:bullet] == YES)
					{
						if(m_EventDispatcher)
							[m_EventDispatcher PlaySound:GAME_SOUND_ID_COLLISION];
						
						[mybullet blast];
						return YES;
					}	
				}	
			}	
		}	
	}
	return bRet;
}

-(void)addBullet:(BulletObject*)bullet
{
	[m_Bullets addObject:bullet];
}	

-(BOOL)onTimerEvent
{
	int nCount = [m_Bullets count];
	BOOL bRet = NO;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			BulletObject* bullet = (BulletObject*)[m_Bullets objectAtIndex:i];
			if(bullet != nil)
			{
				if([bullet isShoot] == YES || [bullet isBlast] == YES)
				{	
					if([bullet onTimerEvent] == YES)
					{	
						bRet = YES;
						if(m_Aliens != nil && [bullet isShoot] == YES)
						{
							if([m_Aliens hit:bullet] == YES)
							{
								[bullet blast];
							}	
						}	
						if(m_Target != nil && [bullet isShoot] == YES)
						{
							if([m_Target hit:bullet] == YES)
							{
								[bullet blast];
							}	
						}
						
						if([bullet isShoot] == YES)
						{
							if(m_EmenyGun != nil)
							{
								if([m_EmenyGun bulletHitByEmeny:bullet] == YES)
								{
									[bullet blast];
								}	
							}	
						}		
					}
				}	
			}	
		}	
	}
	return bRet;
}	

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
	if(isGameResult() == 1)
		return;
	
	int nCount = [m_Bullets count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			BulletObject* bullet = (BulletObject*)[m_Bullets objectAtIndex:i];
			if(bullet != nil)
			{
				if([bullet isShoot] == YES || [bullet isBlast] == YES)
				{	
					[bullet draw:context inRect:rect];
				}	
			}	
		}	
	}
}

@end
