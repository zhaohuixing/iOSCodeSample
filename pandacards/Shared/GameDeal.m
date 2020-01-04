//
//  GameDeal.m
//  MindFire
//
//  Created by ZXing on 26/10/2009.
//  Copyright 2009 Zhaohui Xing. All rights reserved.
//
#import "GameDeal.h"
#include "GameUtility.h"

@implementation GameDeal

-(id)init
{
	if(self = [super init])
	{
		m_Card[0] = CARD_INVALID;
		m_Card[1] = CARD_INVALID;
		m_Card[2] = CARD_INVALID;
		m_Card[3] = CARD_INVALID;
	}	
	
	return self;
}	

- (void)SetCard:(int)nIndex withValue:(int)nValue
{
	if(0 <= nIndex && nIndex < 4)
	{
		m_Card[nIndex] = nValue;
	}	
}

- (int)GetCard:(int)nIndex
{
	int nRet = -1;
	
	if(0 <= nIndex && nIndex < 4)
	{
		nRet = m_Card[nIndex];
	}
	
	return nRet;
}	

- (void)dealloc 
{
    [super dealloc];
}


@end
