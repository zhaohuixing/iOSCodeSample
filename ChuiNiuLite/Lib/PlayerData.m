//
//  PlayerData.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "GameBaseObject.h"
#import "PlayerData.h"


@implementation PlayerData

-(id)init
{
	if((self = [super init]))
	{
		m_enState = GAME_PLAYER_STOP; 
	}	
	
	return self;
}	

-(enObjectType)getType
{
	return GAME_OBJECT_PLAYER; 
}	

-(enPlayerState)getState
{
	return m_enState;
}

-(void)reset
{
	m_enState = GAME_PLAYER_STOP; 
}

-(void)startMotion
{
	if(m_enState == GAME_PLAYER_DEAD || [self isJump] == YES)
		return;

	if(m_enState == GAME_PLAYER_SHOOT)
		m_enState = GAME_PLAYER_SHOOTANDMOTION;
	else 
		m_enState = GAME_PLAYER_MOTION;
}
	
-(void)stopMotion
{
	if(m_enState == GAME_PLAYER_DEAD || m_enState == GAME_PLAYER_SHOOT || m_enState == GAME_PLAYER_STOP || [self isJump] == YES)
		return;
	
	switch (m_enState)
	{
		case GAME_PLAYER_SHOOTANDMOTION:
			m_enState = GAME_PLAYER_SHOOT;
			break;
		default:	
			m_enState = GAME_PLAYER_STOP;
			break;
	}		
}

-(void)startJump
{
	if(m_enState == GAME_PLAYER_DEAD)
		return;
	
	if(m_enState == GAME_PLAYER_SHOOT)
		m_enState = GAME_PLAYER_SHOOTANDJUMP;
	else 
		m_enState = GAME_PLAYER_JUMP;
}

-(void)stopJump
{
	if(m_enState == GAME_PLAYER_DEAD || [self isMotion] == YES)
		return;
	
	switch (m_enState)
	{
		case GAME_PLAYER_SHOOTANDJUMP:
			m_enState = GAME_PLAYER_SHOOT;
			break;
		default:	
			m_enState = GAME_PLAYER_STOP;
			break;
	}		
}

-(void)startShoot
{
	if(m_enState == GAME_PLAYER_DEAD)
		return;
	
	if(m_enState == GAME_PLAYER_MOTION)
		m_enState = GAME_PLAYER_SHOOTANDMOTION;
	if(m_enState == GAME_PLAYER_JUMP)
		m_enState = GAME_PLAYER_SHOOTANDJUMP;
	else 
		m_enState = GAME_PLAYER_SHOOT;
}

-(void)stopShoot
{
	if(m_enState == GAME_PLAYER_DEAD)
		return;
	
	if(m_enState == GAME_PLAYER_SHOOTANDMOTION)
		m_enState = GAME_PLAYER_MOTION;
	else if(m_enState == GAME_PLAYER_SHOOTANDJUMP)
		m_enState = GAME_PLAYER_JUMP;
	else 
		m_enState = GAME_PLAYER_STOP;
}

-(void)dead
{
	m_enState = GAME_PLAYER_DEAD;
}	

-(BOOL)isMotion
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_PLAYER_MOTION || m_enState == GAME_PLAYER_SHOOTANDMOTION)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isJump
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_PLAYER_JUMP || m_enState == GAME_PLAYER_SHOOTANDJUMP)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isShoot
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_PLAYER_SHOOT || m_enState == GAME_PLAYER_SHOOTANDMOTION ||
	   m_enState == GAME_PLAYER_SHOOTANDJUMP)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isShootAndMotion
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_PLAYER_SHOOTANDMOTION)
		bRet = YES;
	
	return bRet;
}	

-(BOOL)isShootAndJump
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_PLAYER_SHOOTANDJUMP)
		bRet = YES;
	
	return bRet;
}	

-(BOOL)isStop
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_PLAYER_STOP)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isDead
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_PLAYER_DEAD)
		bRet = YES;
	
	return bRet;
}	

-(BOOL)hitHead:(CGPoint)point
{
	BOOL bRet = NO;

	if([self hitTestWithPoint:point] == YES)
	{
		CGRect rect = [self getBound];
		CGRect headRect = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height*2.0/3.0, rect.size.width*0.4, rect.size.height/3.0);
		if(CGRectContainsPoint(headRect, point) == true)
			bRet = YES;
	}	
	
	return bRet;
}

-(BOOL)hitBody:(CGPoint)point
{
	BOOL bRet = NO;

	if([self hitTestWithPoint:point] == YES && [self hitHead:point] == NO)
	{
		bRet = YES;
	}
	
	return bRet;
}	

-(CGPoint)getHeadPosition
{
	CGRect rect = [self getBound];
	return CGPointMake(rect.origin.x, rect.origin.y+rect.size.height*5.0/6.0);
}	

@end
