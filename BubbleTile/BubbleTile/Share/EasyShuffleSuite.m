//
//  EasyShuffleSuite.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-09-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EasyShuffleSuite.h"

@implementation EasyShuffleSuite

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        m_GridType = PUZZLE_GRID_TRIANDLE;
        m_nCount = 0;
        //Using CUndoCommand object to record easy level step
        m_StepList = [[NSMutableArray alloc] init];
        m_nCachedIndex = -1;
    }
    
    return self;
}

-(void)dealloc
{
    [m_StepList removeAllObjects];
    [m_StepList release];
    [super dealloc];
}

-(int)GetBubbleCount
{
    return m_nCount;
}

-(int)GetSteps
{
    int nStep = [m_StepList count];
    return nStep;
}

-(enGridType)GetType
{
    return m_GridType;
}

-(CUndoCommand*)GetStep:(int)nIndex
{
    CUndoCommand* pStep = nil;
    int nStep = [m_StepList count];
    if(0 <= nIndex && nIndex < nStep)
    {
        pStep = (CUndoCommand*)[m_StepList objectAtIndex:nIndex];
    }
    return pStep;
}

-(int)CreateSteps
{
    float fSeed = [[NSProcessInfo processInfo] systemUptime];
    srand((unsigned)fSeed);
    int nRand = rand();
    if(nRand < 0)
        nRand *= -1;
    
    int nThreshold = m_nCount < 10 ? m_nCount*3 : 30;//m_nCount;//*3 < 30 ? m_nCount*3 : 30;
    int nSteps = nRand%nThreshold+1;
    if(nSteps == 0)
        nSteps = nThreshold/2; 
    return nSteps;
}

-(void)CreateEasyStep
{
    if(m_nCachedIndex == -1)
    {    
        float fSeed = [[NSProcessInfo processInfo] systemUptime];
        srand((unsigned)fSeed);
    }    
    else
    {    
        srand(m_nCachedIndex);
    }    
    int nRand = rand();
    if(nRand < 0)
        nRand *= -1;
    
    int nIndex = nRand%m_nCount;
    if(m_nCachedIndex == nIndex)
    {
        nIndex = (nIndex+1)%m_nCount;
    }
    
    int nDirect = nRand%3;
    if(nDirect == 0)
        nDirect = MOTION_DIRECTION_BACKWARD;
    int nMotion;
    switch (m_GridType)
    {
        case PUZZLE_GRID_TRIANDLE:
            nMotion = nRand%4;
            if(0 == nMotion)
                nMotion = (int)BUBBLE_MOTION_120DIAGONAL;
            else if(2 == nMotion)
                nMotion = (int)BUBBLE_MOTION_60DIAGONAL;
            break;
        case PUZZLE_GRID_SQUARE:
            nMotion = nRand%3;
            if(0 == nMotion)
                nMotion = (int)BUBBLE_MOTION_VERTICAL;
            break;
        case PUZZLE_GRID_DIAMOND:
            nMotion = nRand%4;
            if(0 == nMotion)
                nMotion = (int)BUBBLE_MOTION_120DIAGONAL;
            else if(2 == nMotion)
                nMotion = (int)BUBBLE_MOTION_60DIAGONAL;
            break;
            break;
        case PUZZLE_GRID_HEXAGON:
            nMotion = nRand%4;
            if(0 == nMotion)
                nMotion = (int)BUBBLE_MOTION_120DIAGONAL;
            else if(2 == nMotion)
                nMotion = (int)BUBBLE_MOTION_60DIAGONAL;
            break;
            break;
    }
    CUndoCommand* pStep = [[[CUndoCommand alloc] init] autorelease];
    pStep.m_Motion = nMotion;
    pStep.m_Direction = nDirect;
    pStep.m_PositionIndex = nIndex;
    [m_StepList addObject:pStep];
    m_nCachedIndex = nIndex;
    return;
}

-(void)Shuffle:(enGridType)enType withBubble:(int)nCount
{
    [m_StepList removeAllObjects];
    m_nCachedIndex = -1;
    m_GridType = enType;
    m_nCount = nCount;
    int nSteps = [self CreateSteps];
    for(int i = 0; i < nSteps; ++i)
    {
        [self CreateEasyStep];
    }
}

-(BOOL)IsValid
{
    BOOL bRet = ([m_StepList count] != 0);
    return bRet;
}

-(void)SaveGameEasySolution:(NSMutableArray*)easySolution
{
    int nCount = [m_StepList count]; 
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            CUndoCommand* pUndo = (CUndoCommand*)[m_StepList objectAtIndex:i];
            int nEncode = [pUndo GetEncodeValue];
            NSNumber* pValue = [[[NSNumber alloc] initWithInt:nEncode] autorelease];
            [easySolution addObject:pValue];
        }
    }
}

-(void)LoadFromGameEasySolution:(NSArray*)easySolution
{
    [m_StepList removeAllObjects];
    int nCount = [easySolution count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NSNumber* pValue = [easySolution objectAtIndex:i];
            int nEncode = [pValue intValue];
            CUndoCommand* pStep = [[[CUndoCommand alloc] init] autorelease];
            [pStep SetFromEncodeValue:nEncode];
            [m_StepList addObject:pStep];
        }    
    }
}


@end
