//
//  ShuffleSuite.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "stdinc.h"
#import "ShuffleSuite.h"

@implementation IndexObject

-(id)InitWithIndex:(int)nIndex
{
    if((self = [super init]))
    {
        m_nIndex = nIndex;
    }
    return self;
}


-(int)GetIndex
{
    return m_nIndex;
}

@end

@implementation ShuffleSuite

-(int)getRandomIndex
{
    int nRet = -1;
    
	int nCount = [m_TempList count];
	if(0 < nCount)
	{
		if(nCount == 1)
		{
			nRet = [[m_TempList objectAtIndex:0] GetIndex];
			[m_TempList removeAllObjects];
			return nRet;
		}
		
        srand(time(NULL));
		int nRand = rand();
		if(nRand < 0)
			nRand *= -1;
		
		int nRandIndex = nRand%nCount; 
		
		if(0 <= nRandIndex && nRandIndex < nCount)
		{	
			nRet = [[m_TempList objectAtIndex:nRandIndex] GetIndex];
			[m_TempList removeObjectAtIndex:nRandIndex];
		}				
	}
    
    return nRet;
}

-(void)Shuffle
{
	[m_TempList removeAllObjects];
	[m_IndexList removeAllObjects];
	for(int i = 0; i < m_nCount; ++i)
	{
		IndexObject* index = [[[IndexObject alloc] InitWithIndex:i] autorelease];
		[m_TempList addObject:index];
	}
	
	int nIndex = [self getRandomIndex];
	while(nIndex != -1)
	{
		IndexObject* index = [[[IndexObject alloc] InitWithIndex:nIndex] autorelease];
		[m_IndexList addObject:index];
		nIndex = [self getRandomIndex];
	}
    
}

-(id)initWithBase:(int)nCount
{
    if((self = [super init]))
    {
        m_nCount = nCount;
        m_IndexList = [[[NSMutableArray alloc] init] retain];
        m_TempList = [[[NSMutableArray alloc] init] retain];
        [self Shuffle];
    }
    return self;
}

-(int)GetValue:(int)nIndex
{
    int nRet = -1;
    
    if(m_IndexList != nil && 0 <= nIndex && nIndex < [m_IndexList count])
    {
        nRet = [[m_IndexList objectAtIndex:nIndex] GetIndex];
    }
    
    return nRet;
}

-(void)dealloc
{
    [m_IndexList removeAllObjects];
    [m_IndexList release];
    [m_TempList release];
    [super dealloc];
}

@end
