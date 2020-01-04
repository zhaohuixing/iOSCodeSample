//
//  ResultSet.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import "ResultSet.h"


@implementation ResultSet

-(id)init
{
	if((self = [super init]))
	{
		m_AnswerList = [[NSMutableArray array] retain];
	}	
	
	return self;
}	

- (void)dealloc 
{
	[m_AnswerList release];
    [super dealloc];
}

- (void)AddAnswer:(DealResult*)answer
{
	[m_AnswerList addObject:answer];
}

- (DealResult*)GetAnswer:(int)index
{
	DealResult* answer = nil;
	
	if(0 <= index && index < [m_AnswerList count])
	{
		answer = (DealResult*)[m_AnswerList objectAtIndex:index];
	}	
	
	return answer;
}

- (int)GetSize
{
	return [m_AnswerList count];
}
	
- (void)Clear
{
	/*for(int i = 0;  i < [m_AnswerList count]; ++i)
	{
		[[m_AnswerList objectAtIndex:i] release];
	}*//*Pay aatention Multiple release*/	
	[m_AnswerList removeAllObjects];
}	


@end
