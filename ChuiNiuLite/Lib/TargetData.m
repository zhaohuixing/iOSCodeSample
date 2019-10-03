//
//  TargetData.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "GameBaseObject.h"
#import "TargetData.h"


@implementation TargetData

-(id)init
{
	if((self = [super init]))
	{
		m_enState = GAME_TARGET_NORMAL;
	}	
	
	return self;
}	

-(enObjectType)getType
{
	return GAME_OBJECT_TARGET; 
}	

-(enTargetState)getState
{
	return m_enState;
}
	
-(void)reset
{
	m_enState = GAME_TARGET_NORMAL;
}

-(void)shoot
{
	m_enState = GAME_TARGET_SHOOT;
}

-(void)crash
{
	m_enState = GAME_TARGET_CRASH;
}

-(void)blowout
{
	m_enState = GAME_TARGET_BLOWOUT;
}

-(void)knockdown
{
	m_enState = GAME_TARGET_KNOCKDOWN;
}	

-(BOOL)isShoot
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_TARGET_SHOOT)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isCrash
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_TARGET_CRASH)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isBlowout
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_TARGET_BLOWOUT)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isKnockout
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_TARGET_KNOCKDOWN)
		bRet = YES;
	
	return bRet;
}	

-(BOOL)isNormal
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_TARGET_NORMAL)
		bRet = YES;
	
	return bRet;
}

@end
