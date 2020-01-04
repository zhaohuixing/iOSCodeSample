//
//  DealResult.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "CardEquation.h"
#import "DealResult.h"


@implementation DealResult

-(id)init
{
	if(self = [super init])
	{
		m_EquationList = [[NSMutableArray array] retain];
	}	
	
	return self;
}	

- (void)AddEquation:(CardEquation*)card
{
	[m_EquationList addObject:card];
}

- (CardEquation*)GetEquation:(int)index
{
	CardEquation* eqn = nil;
	
	if(0 <= index && index < [m_EquationList count])
	{
		eqn = (CardEquation*)[m_EquationList objectAtIndex:index];
	}	
	
	return eqn;
}	

- (int)GetSize
{
	int nRet = [m_EquationList count];
	return nRet;
}	

- (void)Clear
{
	[m_EquationList removeAllObjects];
}	

- (void)dealloc 
{
	[m_EquationList release];
    [super dealloc];
}

- (void)ToFormatArray:(NSMutableArray*)array
{
	for(int index = 0; index < [m_EquationList count]; ++index)
	{
		CardEquation* eqn = (CardEquation*)[m_EquationList objectAtIndex:index];
        NSMutableDictionary* pDict = [[[NSMutableDictionary alloc] init] autorelease];
        [eqn ToFormatDictionary:pDict];
        [array addObject:pDict];
	}	
}

- (void)FromFormatArray:(NSArray*)array
{
    [self Clear];
	for(int index = 0; index < [array count]; ++index)
	{
		NSDictionary* dict = (NSDictionary*)[array objectAtIndex:index];
		CardEquation* eqn = [[[CardEquation alloc] init] autorelease];
        [eqn FromFormatDictionary:dict];
        [m_EquationList addObject:eqn];
	}	
}

@end
