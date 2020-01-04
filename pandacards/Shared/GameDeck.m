//
//  GameDeck.m
//  MindFire
//
//  Created by ZXing on 24/10/2009.
//  Copyright 2009 Zhaohui Xing. All rights reserved.
//
#import "GameCard.h"
#import "GameDeck.h"
#import "GameDeal.h"
#include "GameUtility.h"


@implementation GameDeck

@synthesize m_Answers;

-(id)init
{
	if((self = [super init]))
	{
		m_CardList = [[NSMutableArray array] retain];
		m_TempCardList = [[NSMutableArray array] retain];
		m_Answers = [[ResultSet alloc] init];
	}
	
	return self;
}	

- (void)dealloc 
{
	[m_CardList release];
	[m_TempCardList release];
	[m_Answers release];
    [super dealloc];
}


- (BOOL)isEmpty
{
	BOOL bRet = NO;
	
	bRet = ([m_CardList count] == 0); 
	
	return bRet;
}

-(int)getDealLeft
{
	return (int)([m_CardList count]/4);
}	

-(int)getRandomIndex
{
	int nIndex = -1;
	GameCard* card;
	
	int nCount = [m_TempCardList count];
	if(0 < nCount)
	{
		if(nCount == 1)
		{
			card = (GameCard*)[m_TempCardList objectAtIndex:0];
			if(card != nil)
			{	
				nIndex = card.m_Card;
				[m_TempCardList removeAllObjects];
				return nIndex;
			}	
		}
		
		int nRand = GetRandom();
		if(nRand < 0)
			nRand *= -1;
		
		int nRandIndex = nRand%nCount; 
		
		if(0 <= nRandIndex && nRandIndex < nCount)
		{	
			card = [m_TempCardList objectAtIndex:nRandIndex];
			nIndex = card.m_Card;
			[m_TempCardList removeObjectAtIndex:nRandIndex];
		}				
	}
	
	return nIndex;
}

-(void)addCard:(int)index
{
	GameCard* card = [[[GameCard alloc] init] autorelease];
	card.m_Card = index;
	[m_CardList addObject:card];
}

-(void)shuffle
{
	[m_Answers Clear];
	[m_TempCardList removeAllObjects];
	[m_CardList removeAllObjects];
	for(int i = 0; i < 52; ++i)
	{
		GameCard* card = [[[GameCard alloc] init] autorelease];
		card.m_Card = i;
		[m_TempCardList addObject:card];
	}
	
	int nIndex = [self getRandomIndex];
	while(nIndex != -1)
	{
		[self addCard:nIndex];
		nIndex = [self getRandomIndex];
	}
}


-(int)getCardCount
{
	int nCount = [m_CardList count];
	return nCount;
}

-(int)size
{
	int nCount = [m_CardList count];
	return nCount;
}

-(int)getDealCount
{
	int nCount = [m_CardList count];
	return nCount/4;
}

-(int)popupCard
{
	int nRet = -1;
	
	if(0 < [m_CardList count])
	{	
		GameCard* card = (GameCard*)[m_CardList objectAtIndex:0];
		nRet = card.m_Card;
		[m_CardList removeObjectAtIndex:0];
	}
	
	return nRet;
}

-(GameDeal*)getDeal
{
	GameDeal* pDeal = nil;
	
	if(0 < [self getDealCount])
	{
		pDeal = [[GameDeal alloc] init];
		[pDeal SetCard:0 withValue:[self popupCard]];
		[pDeal SetCard:1 withValue:[self popupCard]];
		[pDeal SetCard:2 withValue:[self popupCard]];
		[pDeal SetCard:3 withValue:[self popupCard]];
	}	
	
	return pDeal;
}

-(void)queryDeal:(int*)nCard1 withCard2:(int*)nCard2 withCard3:(int*)nCard3 withCard4:(int*)nCard4
{
	if(0 < [self getDealCount])
	{
		*nCard1 = [self popupCard];
		*nCard2 = [self popupCard];
		*nCard3 = [self popupCard];
		*nCard4 = [self popupCard];
	}	
}	

-(void)clear
{
	[m_TempCardList removeAllObjects];
	[m_CardList removeAllObjects];
}

- (void)ToFormatArray:(NSMutableArray*)array
{
	int nCount = [m_CardList count];
    for(int index = 0; index < nCount; ++index)
    {
        GameCard* card = (GameCard*)[m_CardList objectAtIndex:index];
		NSNumber* nCard = [[[NSNumber alloc] initWithInt:card.m_Card] autorelease];
        [array addObject:nCard];
    }
}

- (void)FromFormatArray:(NSArray*)array
{
    if(array == nil)
        return;
    
    [self clear];
	int nCount = [array count];
    for(int index = 0; index < nCount; ++index)
    {
        NSNumber* nCard  = [array objectAtIndex:index];
	    if(nCard)
        {    
            GameCard* card = [[[GameCard alloc] init] autorelease];
            card.m_Card = [nCard intValue];
            [m_CardList addObject:card];
        }    
    }
}

@end
