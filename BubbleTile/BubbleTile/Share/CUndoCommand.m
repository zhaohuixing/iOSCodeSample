//
//  CUndoCommand.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CUndoCommand.h"


@implementation CUndoCommand

@synthesize   m_Motion;
@synthesize   m_Direction;
@synthesize   m_PositionIndex;


-(id)init
{
    if((self = [super init]))
    {
        m_Motion = BUBBLE_MOTION_NONE;
        m_Direction = MOTION_DIRECTION_NONE;
        m_PositionIndex = -1;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(int)GetEncodeValue
{
    if(m_PositionIndex == -1 || m_Direction == MOTION_DIRECTION_NONE || m_Motion == BUBBLE_MOTION_NONE)
        return -1;
    
    int nEncode = 0;
    int nIndex = m_PositionIndex & 0xFFFF;
    int nDir = ((int)m_Direction) & 0xFF;
    int nMot = ((int)m_Motion) & 0xFF;
    nEncode = nIndex | (nDir << 16) | (nMot << 24); 
    
    return nEncode;
}

-(void)SetFromEncodeValue:(int)nEncode
{
    if(nEncode < 0)
        return;
    
    m_PositionIndex = nEncode & 0xFFFF;
    m_Direction = (enMotionDirection)((nEncode >> 16) & 0xFF);
    m_Motion = (enBubbleMotion)((nEncode >> 24) & 0xFF);    
}

@end
