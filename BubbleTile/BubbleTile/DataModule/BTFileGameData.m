//
//  BTFileGameData.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BTFileGameData.h"

@implementation BTFileGameData

@synthesize          m_GameType;
@synthesize          m_Bubble;
@synthesize          m_GridType;
@synthesize          m_GridLayout;
@synthesize          m_GridEdge;
@synthesize          m_GameLevel;
@synthesize          m_HiddenBubbleIndex;
@synthesize          m_GameSet;
@synthesize          m_EasySolution;

-(id)init
{
    self = [super init];
    if(self)
    {
        m_GameType = 0;
        m_Bubble = 0;
        m_GridType = 0;
        m_GridLayout = 0;
        m_GridEdge = 3;
        m_GameLevel = 0;
        m_HiddenBubbleIndex = -1;
        m_GameSet = nil;
        m_EasySolution = nil;
    }
    return self;
}

-(void)dealloc
{
    if(m_GameSet != nil)
    {
        [m_GameSet removeAllObjects];
        [m_GameSet release];
        m_GameSet = nil;
    }
    if(m_EasySolution != nil)
    {
        [m_EasySolution removeAllObjects];
        [m_EasySolution release];
        m_EasySolution = nil;
    }
    [super dealloc];
}

/*
-(void)SetGameParams:(int)nBubble type:(int)nGridType layout:(int)nLayout edge:(int)nEdge level:(int)nLevel gameset:(NSArray*)arrayGameSet easysolution:(NSArray*)arrayEasyWay
{
    m_Bubble = nBubble;
    m_GridType = nGridType;
    m_GridLayout = nGridType;
    m_GridEdge = nLayout;
    m_GameLevel = nLevel;
    if(m_GameSet != nil)
    {
        [m_GameSet release];
        m_GameSet = nil;
    }
    if(m_EasySolution != nil)
    {
        [m_EasySolution release];
        m_EasySolution = nil;
    }
    if(arrayGameSet)
    {    
        m_GameSet = [[[NSMutableArray alloc] initWithArray:arrayGameSet copyItems:YES] retain];
    }    
    
    if(m_GameLevel == 0 && arrayEasyWay)
    {
        m_EasySolution = [[[NSMutableArray alloc] initWithArray:arrayEasyWay copyItems:YES] retain];
    }
}*/

-(void)SaveToMessage:(GameMessage*)msg
{
    if(msg == nil)
        return;

    NSNumber* msgGame = [[[NSNumber alloc] initWithInt:m_GameType] autorelease]; 
    [msg AddMessage:BTF_GAME_GAMETYPE withNumber:msgGame];
    
    NSNumber* msgBubble = [[[NSNumber alloc] initWithInt:m_Bubble] autorelease]; 
    [msg AddMessage:BTF_GAME_BUBBLE withNumber:msgBubble];

    NSNumber* msgGridType = [[[NSNumber alloc] initWithInt:m_GridType] autorelease]; 
    [msg AddMessage:BTF_GAME_GRIDTYPE withNumber:msgGridType];

    NSNumber* msgGridLayout = [[[NSNumber alloc] initWithInt:m_GridLayout] autorelease]; 
    [msg AddMessage:BTF_GAME_LAYOUTTYPE withNumber:msgGridLayout];

    NSNumber* msgGridEdge = [[[NSNumber alloc] initWithInt:m_GridEdge] autorelease]; 
    [msg AddMessage:BTF_GAME_EDGE withNumber:msgGridEdge];

    NSNumber* msgGameLevel = [[[NSNumber alloc] initWithInt:m_GameLevel] autorelease]; 
    [msg AddMessage:BTF_GAME_LEVEL withNumber:msgGameLevel];
    
    NSNumber* msgHiddenIndex = [[[NSNumber alloc] initWithInt:m_HiddenBubbleIndex] autorelease]; 
    [msg AddMessage:BTF_GAME_HIDDENBUBBLE_INDEX withNumber:msgHiddenIndex];
    

    if(m_GameSet)
    {
        //????????????????
        [msg AddMessage:BTF_GAME_GAMESET withArray:m_GameSet];
    }
    
    if(m_GameLevel == 0 && m_EasySolution)
    {
        //????????????????
        [msg AddMessage:BTF_GAME_GAMEEASYSOLUTION withArray:m_EasySolution];
    }
}

-(void)LoadFromMessage:(NSDictionary*)msgData
{
    if(msgData == nil)
        return;
    NSNumber* msgGame = [msgData valueForKey:BTF_GAME_GAMETYPE];
    if(msgGame)
    {
        m_GameType = [msgGame integerValue];
    }
    else 
    {
        m_GameType = 0;
    }
    
    NSNumber* msgBubble = [msgData valueForKey:BTF_GAME_BUBBLE];
    if(msgBubble)
        m_Bubble = [msgBubble integerValue]; 

    NSNumber* msgGridType = [msgData valueForKey:BTF_GAME_GRIDTYPE];
    if(msgGridType)
        m_GridType = [msgGridType integerValue];
    
    NSNumber* msgGridLayout = [msgData valueForKey:BTF_GAME_LAYOUTTYPE];
    if(msgGridLayout)
        m_GridLayout = [msgGridLayout integerValue];
    
    NSNumber* msgGridEdge = [msgData valueForKey:BTF_GAME_EDGE];
    if(msgGridEdge)
        m_GridEdge = [msgGridEdge integerValue];
    
    NSNumber* msgGameLevel = [msgData valueForKey:BTF_GAME_LEVEL];
    if(msgGameLevel)
        m_GameLevel = [msgGameLevel integerValue];
    
    NSNumber* msgHiddenIndex = [msgData valueForKey:BTF_GAME_HIDDENBUBBLE_INDEX];
    if(msgHiddenIndex)
    {
        m_HiddenBubbleIndex = [msgHiddenIndex integerValue];
    }
    else
    {
        m_HiddenBubbleIndex = -1;
    }
    
    if(m_GameSet != nil)
    {
        [m_GameSet removeAllObjects];
    }
    else
    {    
        m_GameSet = [[NSMutableArray alloc] init];
    }    
    NSMutableArray* msgGameSet = [msgData valueForKey:BTF_GAME_GAMESET];
    if(msgGameSet)
    {
        for(int i = 0; i < [msgGameSet count]; ++i)
        {
            NSNumber* nsInteger = [[[NSNumber alloc] initWithInt:[(NSNumber*)[msgGameSet objectAtIndex:i] intValue]] autorelease];
            [m_GameSet addObject:nsInteger];
        }
    }
    if(m_EasySolution != nil)
    {
        [m_EasySolution removeAllObjects];
        [m_EasySolution release];
        m_EasySolution = nil;
    }
    if(m_GameLevel == 0)
    {
        NSMutableArray* msgEasySolution = [msgData valueForKey:BTF_GAME_GAMEEASYSOLUTION];
        if(msgEasySolution)
        {
            m_EasySolution = [[NSMutableArray alloc] init];
            for(int i = 0; i < [msgEasySolution count]; ++i)
            {
                NSNumber* nsInteger = [[[NSNumber alloc] initWithInt:[(NSNumber*)[msgEasySolution objectAtIndex:i] intValue]] autorelease];
                [m_EasySolution addObject:nsInteger];
            }
        }
    }
}

-(BOOL)IsValid
{
    BOOL bRet = YES;
    if(m_GameSet == nil || [m_GameSet count] <= 0)
        bRet = NO;
    if(m_GameLevel == 0 && (m_EasySolution == nil || [m_EasySolution count] <= 0))
        bRet = NO;
    
    return bRet;
}

@end
