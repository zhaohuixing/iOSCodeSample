//
//  AlienData.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-07-26.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "GameBaseObject.h"
#import "AlienData.h"

#define BIRD_BUBBLE_SIZE_COUNT_THRESHOLD            5

@implementation AlienData

-(id)init
{
	if((self = [super init]))
	{
		m_enState = GAME_ALIEN_STOP;
        m_enAlienType = GAME_ALIEN_TYPE_CLOUD;
        m_BaseSize = CGSizeMake(1, 1);
        m_enBirdState = GAME_ALIEN_BIRD_MOTION;
        m_nBirdBubbleSizeChangeCount = 1;
	}	
	
	return self;
}	

-(enObjectType)getType
{
	return GAME_OBJECT_ALIEN; 
}	

-(enAlienState)getState
{
	return m_enState;
}	

-(enAlienType)getAlienType;
{
    return m_enAlienType;
}

-(void)setAlienType:(enAlienType)enType
{
    m_enAlienType = enType;
    if(m_enAlienType == GAME_ALIEN_TYPE_BIRD)
    {
        m_Size.width = GAME_BIRD_WIDTH;
        m_Size.height = GAME_BIRD_HEIGHT;
    }
    else if(m_enAlienType == GAME_ALIEN_TYPE_BIRD_BUBBLE)
    {
        float ratio = ((float)m_nBirdBubbleSizeChangeCount)/BIRD_BUBBLE_SIZE_COUNT_THRESHOLD;
        m_Size.width = GAME_BIRD_BUBBLE_WIDTH*ratio;
        m_Size.height = GAME_BIRD_BUBBLE_HEIGHT*ratio;
    }
}

-(void)setSize:(CGSize)size
{
    m_BaseSize.width = size.width;
    m_BaseSize.height = size.height;
    m_Size.width = size.width;
    m_Size.height = size.height;
    if(m_enAlienType == GAME_ALIEN_TYPE_BIRD)
    {
        m_Size.width = GAME_BIRD_WIDTH;
        m_Size.height = GAME_BIRD_HEIGHT;
    }
    else if(m_enAlienType == GAME_ALIEN_TYPE_BIRD_BUBBLE)
    {
        float ratio = ((float)m_nBirdBubbleSizeChangeCount)/BIRD_BUBBLE_SIZE_COUNT_THRESHOLD;
        m_Size.width = GAME_BIRD_BUBBLE_WIDTH*ratio;
        m_Size.height = GAME_BIRD_BUBBLE_HEIGHT*ratio;
    }
}

-(void)setBirdState:(enAlienBirdState)enBirdState
{
    m_enBirdState = enBirdState;
}

-(enAlienBirdState)getBirdState
{
    return m_enBirdState;
}

-(void)reset
{
	m_enState = GAME_ALIEN_STOP;
    m_enAlienType = GAME_ALIEN_TYPE_CLOUD;
    m_Size.width = m_BaseSize.width;
    m_Size.height = m_BaseSize.height;
    m_enBirdState = GAME_ALIEN_BIRD_MOTION;
    m_nBirdBubbleSizeChangeCount = 1;
}

-(void)blast
{
	m_enState = GAME_ALIEN_BLAST;
}

-(void)startMotion
{
	m_enState = GAME_ALIEN_MOTION;
    m_enBirdState = GAME_ALIEN_BIRD_MOTION;
    m_nBirdBubbleSizeChangeCount = 1;
}

-(BOOL)isBlast
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_ALIEN_BLAST)
		bRet = YES;
	
	return bRet;
}

-(BOOL)isMotion
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_ALIEN_MOTION)
		bRet = YES;
	
	return bRet;
}	

-(BOOL)isStop
{
	BOOL bRet = NO;
	
	if(m_enState == GAME_ALIEN_STOP)
		bRet = YES;
	
	return bRet;
}	

-(void)updateBirdBubbleSize
{
    if(m_enAlienType == GAME_ALIEN_TYPE_BIRD_BUBBLE && m_nBirdBubbleSizeChangeCount < BIRD_BUBBLE_SIZE_COUNT_THRESHOLD)
    {
        ++m_nBirdBubbleSizeChangeCount;
        float ratio = ((float)m_nBirdBubbleSizeChangeCount)/BIRD_BUBBLE_SIZE_COUNT_THRESHOLD;
        m_Size.width = GAME_BIRD_BUBBLE_WIDTH*ratio;
        m_Size.height = GAME_BIRD_BUBBLE_HEIGHT*ratio;
    }
}

@end
