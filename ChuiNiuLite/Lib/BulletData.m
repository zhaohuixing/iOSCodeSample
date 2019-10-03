//
//  BulletData.m
//  XXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "GameBaseObject.h"
#import "BulletData.h"


@implementation BulletData

-(id)init
{
	if((self = [super init]))
	{
		m_enState = GAME_BULLET_READY;
	}	
	
	return self;
}	

-(enObjectType)getType
{
	return GAME_OBJECT_BULLET; 
}	

-(enBulletState)getBulletState
{
	return m_enState;
}	

-(void)shoot
{
	m_enState = GAME_BULLET_SHOOTTING;
}

-(void)blast
{
	m_enState = GAME_BULLET_BLAST;
}

-(void)reset
{
	m_enState = GAME_BULLET_READY;
}	

-(BOOL)isShoot
{
	BOOL bRet = NO;

	if(m_enState == GAME_BULLET_SHOOTTING)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isBlast
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_BULLET_BLAST)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isReady
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_BULLET_READY)
		bRet = YES;
	
	return bRet;
}	

@end
