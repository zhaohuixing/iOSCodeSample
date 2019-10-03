//
//  GameGround.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-10.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "Blockage.h"
#import "GameGround.h"
#import "ImageLoader.h"
#import "Configuration.h"
#import "RenderHelper.h"

#define GRASS_SPEED_FACTOR  3.0
@implementation GameGround

@synthesize m_BlockTarget;

- (id)init 
{
    if ((self = [super init])) 
	{
		m_Skill1Blocks = [[NSMutableArray array] retain];
		m_Skill2Blocks = [[NSMutableArray array] retain];
		m_Skill3Blocks = [[NSMutableArray array] retain];
		m_nShootStep = 0;
		m_nShootMaxInterval = GAME_DEFAULT_BLOCK_SHOOT_THRESHED;
		m_nShootThreshold = [Configuration getBlockageShootThreshold];
		m_nTimerStep = 0;
		m_nAnimationStep = 0;
		m_BlockTarget = nil;
     }
    return self;
}

- (void)dealloc 
{
	[m_Skill1Blocks release];
	[m_Skill2Blocks release];
	[m_Skill3Blocks release];
	[super dealloc];
}	

-(void)resetSkillOne
{
	int nCount = [m_Skill1Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			[(Blockage*)[m_Skill1Blocks objectAtIndex:i] reset];
		}
	}	
}	

-(void)resetSkillTwo
{
	int nCount = [m_Skill2Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			[(Blockage*)[m_Skill2Blocks objectAtIndex:i] reset];
		}
	}	
}

-(void)resetSkillThree
{
	int nCount = [m_Skill3Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			[(Blockage*)[m_Skill3Blocks objectAtIndex:i] reset];
		}
	}	
}	

-(void)reset
{
	[self resetSkillOne];
	[self resetSkillTwo];
	[self resetSkillThree];
	m_nShootStep = 0;
	m_nTimerStep = 0;
	m_nAnimationStep = 0;
	m_nShootStep = 0;
	m_nShootMaxInterval = GAME_DEFAULT_BLOCK_SHOOT_THRESHED;
	m_nShootThreshold = [Configuration getBlockageShootThreshold];
	
}

-(BOOL)checkBlockTargetSkillOne
{
	BOOL bRet = NO;
	if(m_BlockTarget == nil)
		return bRet;
	
	int nCount = [m_Skill1Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill1Blocks objectAtIndex:i];
			if(block != nil && [block isMotion] == YES)
			{
				bRet = [m_BlockTarget blockBy:block];
				if(bRet == YES)
					break;
			}
		}
	}	
	
	return bRet;
}


-(BOOL)checkBlockTargetSkillTwo
{
	BOOL bRet = NO;
	if(m_BlockTarget == nil)
		return bRet;
	
	int nCount = [m_Skill2Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill2Blocks objectAtIndex:i];
			if(block != nil && [block isMotion] == YES)
			{
				bRet = [m_BlockTarget blockBy:block];
				if(bRet == YES)
					break;
			}
		}
	}	
	
	return bRet;
}


-(BOOL)checkBlockTargetSkillThree
{
	BOOL bRet = NO;
	if(m_BlockTarget == nil)
		return bRet;
	
	int nCount = [m_Skill3Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill3Blocks objectAtIndex:i];
			if(block != nil && [block isMotion] == YES)
			{
				bRet = [m_BlockTarget blockBy:block];
				if(bRet == YES)
					break;
			}
		}
	}	
	
	return bRet;
}


-(BOOL)checkBlockTarget
{
	BOOL bRet = NO;

	int nSkill = [Configuration getGameSkill];
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			bRet = [self checkBlockTargetSkillOne];
			break;
		case GAME_SKILL_LEVEL_TWO:
			bRet = [self checkBlockTargetSkillTwo];
			break;
		case GAME_SKILL_LEVEL_THREE:
			bRet = [self checkBlockTargetSkillThree];
			break;
	}		
	
	return bRet;
}


-(BOOL)shootSkillOne
{
	int nCount = [m_Skill1Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill1Blocks objectAtIndex:i];
			if(block != nil && [block isStop] == YES)
			{
				float x = [CGameLayout GetGameSceneWidth]*(-0.5);
				float y = [block getSize].height*0.5;
				[block moveTo:CGPointMake(x, y)];
				[block setSpeed:[Configuration getBlockageSpeed]];
				[block startMotion];
				return YES;
			}	
		}	
	}
	return NO;
}

-(BOOL)shootSkillTwo
{
	int nCount = [m_Skill2Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill2Blocks objectAtIndex:i];
			if(block != nil && [block isStop] == YES)
			{
				float x = [CGameLayout GetGameSceneWidth]*(-0.5);
				float y = [block getSize].height*0.5;
				[block moveTo:CGPointMake(x, y)];
				[block setSpeed:[Configuration getBlockageSpeed]];
				[block startMotion];
				return YES;
			}	
		}	
	}
	return NO;
}

-(BOOL)shootSkillThree
{
	int nCount = [m_Skill3Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill3Blocks objectAtIndex:i];
			if(block != nil && [block isStop] == YES)
			{
				float x = [CGameLayout GetGameSceneWidth]*(-0.5);
				float y = [block getSize].height*0.5;
				[block moveTo:CGPointMake(x, y)];
				[block setSpeed:[Configuration getBlockageSpeed]];
				[block startMotion];
				return YES;
			}	
		}	
	}
	return NO;
}


-(BOOL)shoot
{
	BOOL bRet = NO;
	
	int nSkill = [Configuration getGameSkill];
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			bRet = [self shootSkillOne];
			break;
		case GAME_SKILL_LEVEL_TWO:
			bRet = [self shootSkillTwo];
			break;
		case GAME_SKILL_LEVEL_THREE:
			bRet = [self shootSkillThree];
			break;
	}		
	
	return bRet;
}

-(void)shootSkillOneAt:(CGPoint)fromPt withSpeed:(CGPoint)speed
{
	int nCount = [m_Skill1Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill1Blocks objectAtIndex:i];
			if(block != nil && [block isStop] == YES)
			{
				[block moveTo:fromPt];
				[block setSpeed:speed];
				[block startMotion];
				return;
			}	
		}	
	}
}

-(void)shootSkillTwoAt:(CGPoint)fromPt withSpeed:(CGPoint)speed
{
	int nCount = [m_Skill2Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill2Blocks objectAtIndex:i];
			if(block != nil && [block isStop] == YES)
			{
				[block moveTo:fromPt];
				[block setSpeed:speed];
				[block startMotion];
				return;
			}	
		}	
	}
}

-(void)shootSkillThreeAt:(CGPoint)fromPt withSpeed:(CGPoint)speed
{
	int nCount = [m_Skill3Blocks count];
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = (Blockage*)[m_Skill3Blocks objectAtIndex:i];
			if(block != nil && [block isStop] == YES)
			{
				[block moveTo:fromPt];
				[block setSpeed:speed];
				[block startMotion];
				return;
			}	
		}	
	}
}

-(void)shootAt:(CGPoint)fromPt withSpeed:(CGPoint)speed
{
	int nSkill = [Configuration getGameSkill];
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			[self shootSkillOneAt:fromPt withSpeed:speed];
			break;
		case GAME_SKILL_LEVEL_TWO:
			[self shootSkillTwoAt:fromPt withSpeed:speed];
			break;
		case GAME_SKILL_LEVEL_THREE:
			[self shootSkillThreeAt:fromPt withSpeed:speed];
			break;
	}		
}

-(int)blocksInQueue
{
	int nRet = 0;
	int nCount = 0;
	int nSkill = [Configuration getGameSkill];
	
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			nCount = [m_Skill1Blocks count];
			break;
		case GAME_SKILL_LEVEL_TWO:
			nCount = [m_Skill2Blocks count];
			break;
		case GAME_SKILL_LEVEL_THREE:
			nCount = [m_Skill3Blocks count];
			break;
	}		
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = nil; 
			switch(nSkill)
			{
				case GAME_SKILL_LEVEL_ONE:
					block = (Blockage*)[m_Skill1Blocks objectAtIndex:i];
					break;
				case GAME_SKILL_LEVEL_TWO:
					block = (Blockage*)[m_Skill2Blocks objectAtIndex:i];
					break;
				case GAME_SKILL_LEVEL_THREE:
					block = (Blockage*)[m_Skill3Blocks objectAtIndex:i];
					break;
			}		
			if(block != nil && [block isStop] == YES)
			{
				++nRet;
			}	
		}	
	}
	
	return nRet;
}

-(void)addBlocks:(Blockage*)block atSkill:(int)nSkill
{
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			[m_Skill1Blocks addObject:block];
			break;
		case GAME_SKILL_LEVEL_TWO:
			[m_Skill2Blocks addObject:block];
			break;
		case GAME_SKILL_LEVEL_THREE:
			[m_Skill3Blocks addObject:block];
			break;
	}		
}	

-(void)adjustTargetFreePosition
{
	int nCount = 0;
	int nSkill = [Configuration getGameSkill];
	
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			nCount = [m_Skill1Blocks count];
			break;
		case GAME_SKILL_LEVEL_TWO:
			nCount = [m_Skill2Blocks count];
			break;
		case GAME_SKILL_LEVEL_THREE:
			nCount = [m_Skill3Blocks count];
			break;
	}		
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = nil; 
			switch(nSkill)
			{
				case GAME_SKILL_LEVEL_ONE:
					block = (Blockage*)[m_Skill1Blocks objectAtIndex:i];
					break;
				case GAME_SKILL_LEVEL_TWO:
					block = (Blockage*)[m_Skill2Blocks objectAtIndex:i];
					break;
				case GAME_SKILL_LEVEL_THREE:
					block = (Blockage*)[m_Skill3Blocks objectAtIndex:i];
					break;
			}		
			if(block != nil && [block isMotion] == YES)
			{
				if([m_BlockTarget hitTestWithBlockage:block] == YES)
					[m_BlockTarget escapeFromBlockage:block];
			}
		}
	}	
}	

-(BOOL)blockageHitTestWithTarget
{
	BOOL bRet = NO;
	
	if([Configuration canShootBlock] == YES)
	{
		int nCount = 0;
		int nSkill = [Configuration getGameSkill];
		
		switch(nSkill)
		{
			case GAME_SKILL_LEVEL_ONE:
				nCount = [m_Skill1Blocks count];
				break;
			case GAME_SKILL_LEVEL_TWO:
				nCount = [m_Skill2Blocks count];
				break;
			case GAME_SKILL_LEVEL_THREE:
				nCount = [m_Skill3Blocks count];
				break;
		}		
		if(0 < nCount)
		{
			for(int i = 0; i < nCount; ++i)
			{
				Blockage* block = nil; 
				switch(nSkill)
				{
					case GAME_SKILL_LEVEL_ONE:
						block = (Blockage*)[m_Skill1Blocks objectAtIndex:i];
						break;
					case GAME_SKILL_LEVEL_TWO:
						block = (Blockage*)[m_Skill2Blocks objectAtIndex:i];
						break;
					case GAME_SKILL_LEVEL_THREE:
						block = (Blockage*)[m_Skill3Blocks objectAtIndex:i];
						break;
				}		
				if(block != nil && [block isMotion] == YES)
				{
					if([m_BlockTarget hitTestWithBlockage:block] == YES)
					{	
						bRet = YES;
						break;
					}	
				}
			}
		}	
	}	
	
	return bRet;
}
	
-(BOOL)timerEventUpdate
{
	BOOL bRet = YES;
	
	if([Configuration canShootBlock] == YES)
	{
		++m_nShootStep;
		if(m_nShootThreshold <= m_nShootStep)
		{	
			m_nShootThreshold = [Configuration getBlockageShootThreshold];
			m_nShootStep = 0;
			bRet = [self shoot];
		}	
		
		if(m_BlockTarget != nil)
		{
			if([self checkBlockTarget] == YES)
			{
				bRet = YES;
			}	
		}
		
	}	
	
	return bRet;
}

-(void)CalculateGrassLandMotion
{
    float xoffset = [CGameLayout GetGrassUnitWidth];
    float xspeed = [Configuration getBlockageSpeed].x/[Configuration getBlockageTimerElapse];
    if(xoffset < ((float)m_nAnimationStep)*xspeed)
        m_nAnimationStep = 0;
}

-(BOOL)onTimerEvent
{
	BOOL bRet = NO;
	++m_nTimerStep;
	if(GAME_TIMER_PLAYER_STEP <= m_nTimerStep)
	{
		m_nTimerStep = 0;
		if([self timerEventUpdate] == YES)
			bRet = YES;
	}	
	
	++m_nAnimationStep;
    [self CalculateGrassLandMotion];
    
	int nCount = 0;
	int nSkill = [Configuration getGameSkill];
	
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			nCount = [m_Skill1Blocks count];
			break;
		case GAME_SKILL_LEVEL_TWO:
			nCount = [m_Skill2Blocks count];
			break;
		case GAME_SKILL_LEVEL_THREE:
			nCount = [m_Skill3Blocks count];
			break;
	}		
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = nil; 
			switch(nSkill)
			{
				case GAME_SKILL_LEVEL_ONE:
					block = (Blockage*)[m_Skill1Blocks objectAtIndex:i];
					break;
				case GAME_SKILL_LEVEL_TWO:
					block = (Blockage*)[m_Skill2Blocks objectAtIndex:i];
					break;
				case GAME_SKILL_LEVEL_THREE:
					block = (Blockage*)[m_Skill3Blocks objectAtIndex:i];
					break;
			}		
			if(block != nil && [block isMotion] == YES)
			{
				if([block onTimerEvent] == YES)
				{
					bRet = YES;
				}	
			}
		}	
	}
	
	return NO;
}

-(void)drawBlocks:(CGContextRef)context inRect:(CGRect)rect
{
	int nCount = 0;
	int nSkill = [Configuration getGameSkill];
	
	switch(nSkill)
	{
		case GAME_SKILL_LEVEL_ONE:
			nCount = [m_Skill1Blocks count];
			break;
		case GAME_SKILL_LEVEL_TWO:
			nCount = [m_Skill2Blocks count];
			break;
		case GAME_SKILL_LEVEL_THREE:
			nCount = [m_Skill3Blocks count];
			break;
	}		
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{
			Blockage* block = nil; 
			switch(nSkill)
			{
				case GAME_SKILL_LEVEL_ONE:
					block = (Blockage*)[m_Skill1Blocks objectAtIndex:i];
					break;
				case GAME_SKILL_LEVEL_TWO:
					block = (Blockage*)[m_Skill2Blocks objectAtIndex:i];
					break;
				case GAME_SKILL_LEVEL_THREE:
					block = (Blockage*)[m_Skill3Blocks objectAtIndex:i];
					break;
			}		
			if(block != nil && [block isMotion] == YES)
			{
				[block draw:context inRect:rect];
			}
		}
	}
}	

-(void)draw:(CGContextRef)context inRect:(CGRect)rect
{
	[self drawBlocks: context inRect:rect];
	
}

-(void)drawWin:(CGContextRef)context inRect:(CGRect)rect
{
}	

-(void)drawGrass:(CGContextRef)context inRect:(CGRect)rect
{
    float xoffset = [CGameLayout GetGrassUnitWidth];
    float xspeed = [Configuration getBlockageSpeed].x/[Configuration getBlockageTimerElapse];
    float sx = (((float)m_nAnimationStep)*xspeed) - xoffset;
    float sy = [CGameLayout GetGrassUnitHeight];
    float width = xoffset;
    float height = [CGameLayout GetGrassUnitHeight];
    
 	float x = sx*[CGameLayout GetGameSceneDMScaleX];
	float y = [CGameLayout GameSceneToDeviceY:sy];
	float w = [CGameLayout ObjectMeasureToDevice:width];
	float h = [CGameLayout ObjectMeasureToDevice:height];
    CGRect rt;
    
	for(int i = 0; i < [CGameLayout GetGrassUnitNumber]; ++i)
    {
        rt = CGRectMake(x + w*((float)i), y, w, h);
        [RenderHelper DrawGrassUnit:context atRect:rt];
    }
   
    
}

@end
