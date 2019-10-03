//
//  AlienMaster.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-09.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "BulletObject.h"
#import "AlienObject.h"
#import "AlienMaster.h"
#import "Configuration.h"


@implementation AlienMaster

@synthesize	m_EventDispatcher;
@synthesize	m_Target;

-(id)init
{
	if(self = [super init])
	{
		m_Aliens = [[NSMutableArray array] retain];
		m_nShootStep = 0;
		//m_nShootMaxInterval = GAME_DEFAULT_ALIEN_SHOOT_THRESHED;
		m_nShootThreshold = [Configuration getAlienShootThreshold]; //(getRandNumber()%m_nShootMaxInterval+1)%5;
		m_nTimerElaspe = GAME_TIMER_DEFAULT_ALIEN_STEP;
		m_nTimerStep = 0;
		m_Rainbow = [[RainBow alloc] init];
		m_nShootRainBowTime = [Configuration getRainRowStartTime];
	}
	
	return self;
}	

- (void)dealloc 
{
	[m_Aliens release];
	[m_Rainbow release];
    [super dealloc];
}

-(void)reset
{
	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			[(AlienObject*)[m_Aliens objectAtIndex:i] reset];
		}	
	}
	m_nTimerStep = 0;
	m_nShootStep = 0;
	m_nShootThreshold = [Configuration getAlienShootThreshold]; 
	m_nShootRainBowTime = [Configuration getRainRowStartTime];
	[m_Rainbow reset];
}

-(BOOL)hit:(BulletObject*)bullet
{
	BOOL bRet = NO;

	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			AlienObject* alien = (AlienObject*)[m_Aliens objectAtIndex:i];
			if(alien != nil && [alien isMotion] == YES)
			{
				if([alien hit:bullet] == YES)
				{
					[alien blast];
					bRet = YES;
				}	
			}
		}	
	}
	
	return bRet;
}

-(void)shootAt:(CGPoint)fromPt withSpeed:(CGPoint)speed
{
	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			AlienObject* alien = (AlienObject*)[m_Aliens objectAtIndex:i];
			if(alien != nil && [alien isStop] == YES)
			{
                if([Configuration canBirdFly])
                {
                    if(i%3 == 0)
                    {    
                        [alien setAlienType:GAME_ALIEN_TYPE_BIRD];
                    }    
                }
				[alien moveTo:fromPt];
				[alien setSpeed:speed];
				[alien startMotion];
				return;
			}	
		}	
	}
}

-(int)aliensInQueue
{
	int nRet = 0;
	
	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			AlienObject* alien = (AlienObject*)[m_Aliens objectAtIndex:i];
			if(alien != nil && [alien isStop] == YES)
			{
				++nRet;
			}	
		}	
	}
	
	return nRet;
}

-(int)getCanShootBird
{
    int index = -1;
   
	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			AlienObject* alien = (AlienObject*)[m_Aliens objectAtIndex:i];
			if(alien != nil && [alien isMotion] == YES && [alien getAlienType] == GAME_ALIEN_TYPE_BIRD)
			{
                //float x = [alien getPosition].x+[alien getSize].width*0.3;//0.5;
                //float cowheadx = [CGameLayout GetCowWidth]*0.3; //0.5;
                
                //if(x < cowheadx*(-1.0))
                    //return i;
                if([alien getPosition].x < 0)
                    return i;
			}
		}	
	}
    
    return index;
}

-(BOOL)shoot
{
	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			AlienObject* alien = (AlienObject*)[m_Aliens objectAtIndex:i];
            float sFactor = 1.0;
			if(alien != nil && [alien isStop] == YES)
			{
				float x = [CGameLayout GetGameSceneWidth]*(-0.5);
				float r = (float)(getRandNumber()%4+1);
				float y = [CGameLayout GetGameSceneHeight]- GAME_DEFAULT_ALIEN_POINT_OFFSET/r;
                if([Configuration canBirdFly] && m_nTimerStep%2 == 0)
                {
                    int nThreshold = [Configuration getBirdFlyingThreshold];
                    if(i%nThreshold == 0)
                    {
                        [alien setAlienType:GAME_ALIEN_TYPE_BIRD];
                        //sFactor = (1.0 + [Configuration getBirdFlyingRatio]);
                    }    
                }
                if([Configuration canBirdShoot])
                {
                    if(i%3 == 1)
                    {
                        int nIndex = [self getCanShootBird];
                        if(0 <= nIndex)
                        {
                            AlienObject* pBird = (AlienObject*)[m_Aliens objectAtIndex:nIndex];
                            if(pBird)
                            {
                                x = [pBird getPosition].x+[pBird getSize].width*0.5;
                                y = [pBird getPosition].y;
                                sFactor = 2.0;//(1.0 + [Configuration getBirdFlyingRatio])*1.6;
                                [alien setAlienType:GAME_ALIEN_TYPE_BIRD_BUBBLE];
                            }
                        }
                    }
                }
                
				
				[alien moveTo:CGPointMake(x, y)];
				[alien setSpeed:CGPointMake(GAME_DEFAULT_ALIEN_SPEED_X*sFactor, GAME_DEFAULT_ALIEN_SPEED_Y)];
				[alien startMotion];
				return YES;
			}	
		}	
	}
	
	return NO;
}	

-(BOOL)updateTimerEvent
{
	BOOL bRet = NO;

	++m_nShootStep;
	if(m_nShootThreshold <= m_nShootStep)
	{	
		m_nShootThreshold = [Configuration getAlienShootThreshold]; 
		m_nShootStep = 0;
		bRet = [self shoot];
	}	
	
	if(m_Target != nil)
	{
		if([self knockDown:m_Target] == YES)
		{
			bRet = YES;
		}	
	}
	
	return bRet;
}

-(BOOL)onTimerEvent
{
	BOOL bRet = NO;
	
	++m_nTimerStep;
	if(m_nTimerElaspe <= (m_nTimerStep%(m_nTimerElaspe+1)))
	{
		//m_nTimerStep = 0;
		if([self updateTimerEvent] == YES)
			bRet = YES;
	}	
	
	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			AlienObject* alien = (AlienObject*)[m_Aliens objectAtIndex:i];
			if(alien != nil && ([alien isMotion] == YES || [alien isBlast] == YES))
			{
				if([alien onTimerEvent] == YES)
				{
					bRet = YES;
				}	
			}
		}	
	}
	if(m_nShootRainBowTime == m_nTimerStep)
	{
		[self ShootRainBow];
		bRet = YES;
	}	
	else if(m_nShootRainBowTime < m_nTimerStep) 
	{
		if(m_Rainbow)
		{
			if([m_Rainbow onTimerEvent] == YES)
				bRet = YES;
		}	
	}

	
	return bRet;
}

-(void)addAlien:(AlienObject*)alien
{
	[m_Aliens addObject:alien];
}

-(BOOL)knockDown:(id<AlienTarget>)target
{
	BOOL bRet = NO;
    if([Configuration canKnockDownTarget] == NO)
		return bRet;
	
	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			AlienObject* alien = (AlienObject*)[m_Aliens objectAtIndex:i];
			if(alien != nil && [alien isMotion] == YES)
			{
				bRet = [target knockdownBy:alien];
				if(bRet == YES)
					break;
			}	
		}	
	}
	return bRet;
}

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
	int nCount = [m_Aliens count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			AlienObject* alien = (AlienObject*)[m_Aliens objectAtIndex:i];
			if(alien != nil && ([alien isMotion] == YES || [alien isBlast] == YES))
			{
				[alien draw:context inRect:rect];
			}
		}	
	}
	if(m_Rainbow && ([m_Rainbow isMotion] == YES || [m_Rainbow isWin] == YES))
	{
		[m_Rainbow draw:context inRect:rect];
	}	
}	

-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect
{
	if(m_Rainbow)
	{
		[m_Rainbow drawWin:context inRect:rect];
	}	
}	


-(void)ShootRainBow
{
	if(m_Rainbow)
		[m_Rainbow startMotion];
}

@end
