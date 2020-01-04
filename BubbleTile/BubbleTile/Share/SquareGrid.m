//
//  SquareGrid.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-07.
//  Copyright 2011 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "SquareGrid.h"
#import "GameConfiguration.h"
#import "GameLayout.h"
#import "ImageLoader.h"
#import "RenderHelper.h"

@implementation SquareGrid

-(id)init
{
    if((self = [super init]))
    {
    }
    return self;
}

-(enGridType) GetGridType
{
    return PUZZLE_GRID_SQUARE;
}

-(void) InitializeMatrixLayout:(enBubbleType)bubbleType
{
    int k = 0;
    for (int i = 0; i < m_nEdge; ++i) 
    {
        for(int j = 0; j < m_nEdge; ++j)
        {
            BubbleObject* pb = [[[BubbleObject alloc] initBubble:k+1 isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
            pb.m_nCurrentLocationIndex = k;
            [m_Bubbles addObject:pb];
            ++k;
        }
    }
}

-(void) InitializeSnakeLayout:(enBubbleType)bubbleType
{
    int k = 0;
    for (int i = 0; i < m_nEdge; ++i) 
    {
        if(i%2 == 0)
        {    
            for(int j = 0; j < m_nEdge; ++j)
            {
                BubbleObject* pb = [[[BubbleObject alloc] initBubble:k+1 isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
                pb.m_nCurrentLocationIndex = k;
                [m_Bubbles addObject:pb];
                ++k;
            }
        }
        else
        {
            int n = k+m_nEdge;
            for(int j = 0; j < m_nEdge; ++j)
            {
                BubbleObject* pb = [[[BubbleObject alloc] initBubble:n-j isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
                pb.m_nCurrentLocationIndex = k;
                [m_Bubbles addObject:pb];
                ++k;
            }
        }
    }
}

-(void) InitializeSpiralLayout:(enBubbleType)bubbleType
{
    if(m_nEdge <= 0)
        return;
    
    int n = 0;
    int i, j, k, l, m;
    for (i = 0; i < m_nEdge; ++i) 
    {
        for(j = 0; j < m_nEdge; ++j)
        {
            BubbleObject* pb = [[[BubbleObject alloc] init:bubbleType] autorelease];
            [pb SetIconTemplate:m_bIconTemplate];
            pb.m_nCurrentLocationIndex = n;
            [m_Bubbles addObject:pb];
            ++n;
        }
    }

    n = 1;
    int index;
    int nThreshed = m_nEdge-1;
    for (i = 0; i <= nThreshed-i; ++i) 
    {
        //upper bound of circle
        for(j = i; j <= nThreshed-i; j++)
        {
            index = i*m_nEdge + j;
            [[m_Bubbles objectAtIndex:index] SetLabel:n];
            ++n;
        }
        //right bound of circle
        for(k = i+1; k <= nThreshed-i; k++)
        {
            index = k*m_nEdge + (nThreshed-i);
            [[m_Bubbles objectAtIndex:index] SetLabel:n];
            ++n;
        }
        //lower bound of circle
        for(l = nThreshed-i-1; i <=l; --l)
        {
            index = (nThreshed-i)*m_nEdge + l;
            [[m_Bubbles objectAtIndex:index] SetLabel:n];
            ++n;
        }
        //left bound of circle
        for(m = nThreshed-i-1; i < m; --m)
        {
            index = m*m_nEdge + i;
            [[m_Bubbles objectAtIndex:index] SetLabel:n];
            ++n;
        }
    }
    
}

-(void) CalculateBubbleSize
{
    float gridSize = [self GetGridMaxSize:m_nEdge];
    m_fBubbleSize = gridSize/((float)m_nEdge);
}

-(void) InitializeGridCells
{
    float fInnerSize = m_fBubbleSize*(m_nEdge-1);
    CGPoint ptCenter = [self GetGridCenter];
    float startX = ptCenter.x - fInnerSize*0.5;
    float startY = ptCenter.y - fInnerSize*0.5;
    
    for (int i = 0; i < m_nEdge; ++i) 
    {
        for(int j = 0; j < m_nEdge; ++j)
        {
            float x = startX + m_fBubbleSize*j;
            float y = startY + m_fBubbleSize*i;
            GridCell* pc = [[[GridCell alloc] initWithX:x withY:y] autorelease];
            [m_Cells addObject:pc];
        }
    }
    
}

-(int) GetGridRow:(int)nIndex
{
    int nRet = -1;

    if(0 <= nIndex && nIndex < m_nEdge*m_nEdge)
    {
        float f1 = (float)nIndex;
        float f2 = (float)m_nEdge;
        float f3 = f1/f2;
        nRet = (int)f3;
    }    
    return nRet;
}

-(int) GetGridColumne:(int)nIndex
{
    int nRet = -1;
    
    if(0 <= nIndex && nIndex < m_nEdge*m_nEdge)
    {
        nRet = nIndex%m_nEdge;
    }    
    return nRet;
}

-(int) GetBubbleNumberAtRow:(int)nRowIndex
{
    int nRet = -1;
    
    if(0 <= nRowIndex && nRowIndex < m_nEdge)
        nRet = m_nEdge;
    
    return nRet;
}

-(int) GetFirstIndexAtRow:(int)nRowIndex
{
    int nRet = -1;
    
    if(0 <= nRowIndex && nRowIndex < m_nEdge)
        nRet = nRowIndex*m_nEdge;
    
    return nRet;
}

-(void) UpdateGridLayout
{
    [super UpdateGridLayout];

    [self CalculateBubbleSize];

    float fInnerSize = m_fBubbleSize*(m_nEdge-1);
    CGPoint ptCenter = [self GetGridCenter];
    float startX = ptCenter.x - fInnerSize*0.5;
    float startY = ptCenter.y - fInnerSize*0.5;

    int nIndex = 0;
    for (int i = 0; i < m_nEdge; ++i) 
    {
        for(int j = 0; j < m_nEdge; ++j)
        {
            float x = startX + m_fBubbleSize*j;
            float y = startY + m_fBubbleSize*i;
            [[m_Cells objectAtIndex:nIndex] SetCenter:x withY:y];
            ++nIndex;
        }
    }
}

-(void)CalculateCurrentTouchGesture
{
    if(0 <= m_nTouchedCellIndex)
    {
        CGPoint ptCenter = [self GetBubbleCenter:m_nTouchedCellIndex];
        float x1 = ptCenter.x;
        float y1 = ptCenter.y;
        float x2 = m_ptTouchPoint.x;
        float y2 = m_ptTouchPoint.y;
        float dx = x2 - x1;
        float dx2 = dx*dx;
        float dy = y2 - y1;
        float dy2 = dy*dy;
        
        if(dy2 == 0 && dx2 == 0)
            return;
        
        BOOL bChange = NO;
        if(m_Motion == BUBBLE_MOTION_NONE)
        {    
            float temp = sqrtf(dy2+dx2);
            if(temp < [GameLayout GetBubbleMotionThreshold:m_fBubbleSize])
                return;
            
            if(dy2 <= dx2)
            {
                m_Motion = BUBBLE_MOTION_HORIZONTAL;
                if(0 < dx)
                    m_Direction = MOTION_DIRECTION_FORWARD;
                else
                    m_Direction = MOTION_DIRECTION_BACKWARD;
                m_fOffset = sqrtf(dx2);
            }
            else
            {
                m_Motion = BUBBLE_MOTION_VERTICAL;
                if(dy < 0)
                    m_Direction = MOTION_DIRECTION_FORWARD;
                else
                    m_Direction = MOTION_DIRECTION_BACKWARD;
                m_fOffset = sqrtf(dy2);
            }
            bChange = YES;
        }
        else if(m_Motion == BUBBLE_MOTION_HORIZONTAL)
        {
            if(0 < dx)
            {    
                if(m_Direction != MOTION_DIRECTION_FORWARD)
                    bChange = YES;
                m_Direction = MOTION_DIRECTION_FORWARD;
            }    
            else
            {    
                if(m_Direction != MOTION_DIRECTION_BACKWARD)
                    bChange = YES;
                m_Direction = MOTION_DIRECTION_BACKWARD;
            }    
            m_fOffset = sqrtf(dx2);
        }
        else if(m_Motion == BUBBLE_MOTION_VERTICAL)
        {
            if(dy < 0)
            {    
                if(m_Direction != MOTION_DIRECTION_FORWARD)
                    bChange = YES;
                m_Direction = MOTION_DIRECTION_FORWARD;
            }    
            else
            {    
                if(m_Direction != MOTION_DIRECTION_BACKWARD)
                    bChange = YES;
                m_Direction = MOTION_DIRECTION_BACKWARD;
            }    
            m_fOffset = sqrtf(dy2);
        }
        if(bChange)    
            [super InitializeArrowAnimation];
            
        if(m_fBubbleSize*[GameLayout GetTouchSensitivity] <= m_fOffset)
        {
            //[self ShiftBubbles];
            //[self CleanTouchState];
            m_fOffset = m_fBubbleSize*[GameLayout GetTouchSensitivity]; 
        }
    }
}

-(void) RowShiftForward:(int)nRowIndex
{
    int nCount = [self GetBubbleNumberAtRow:nRowIndex];
    
    if(nCount <= 1)
        return;
    
    int nStartIndex = [self GetFirstIndexAtRow:nRowIndex];
    
    int b1 = [self GetBubbleDestinationIndex:(nStartIndex + nCount - 1)];
    BubbleObject* pbFirst = [m_Bubbles objectAtIndex:b1];
    
    for(int i = (nStartIndex + nCount - 2); nStartIndex <= i; --i)
    {    
        b1 = [self GetBubbleDestinationIndex:i];
        BubbleObject* pb = [m_Bubbles objectAtIndex:b1];
        pb.m_nCurrentLocationIndex = i+1;
    }
    pbFirst.m_nCurrentLocationIndex = nStartIndex;
}

-(void) HorzShiftBubblesForward
{
    if(m_nTouchedCellIndex < 0)
        return;
    int nRowIndex = [self GetGridRow:m_nTouchedCellIndex];

    [self RowShiftForward:nRowIndex];
}

-(void) RowShiftBackward:(int)nRowIndex
{
    int nCount = [self GetBubbleNumberAtRow:nRowIndex];
    
    if(nCount <= 1)
        return;
    
    int nStartIndex = [self GetFirstIndexAtRow:nRowIndex];
    
    int b1 = [self GetBubbleDestinationIndex:nStartIndex];
    BubbleObject* pbFirst = [m_Bubbles objectAtIndex:b1];
    
    for(int i = nStartIndex + 1; i <= nStartIndex+nCount-1; ++i)
    {    
        b1 = [self GetBubbleDestinationIndex:i];
        BubbleObject* pb = [m_Bubbles objectAtIndex:b1];
        pb.m_nCurrentLocationIndex = i-1;
    }
    pbFirst.m_nCurrentLocationIndex = nStartIndex+nCount-1;
}

-(void) HorzShiftBubblesBackward
{
    if(m_nTouchedCellIndex < 0)
        return;
    int nRowIndex = [self GetGridRow:m_nTouchedCellIndex];

    [self RowShiftBackward:nRowIndex];
}

-(void) HorzShiftBubbles
{
    switch(m_Direction)
    {
        case MOTION_DIRECTION_FORWARD:
            [self HorzShiftBubblesForward];
            break;
        case MOTION_DIRECTION_BACKWARD:
            [self HorzShiftBubblesBackward];
            break;
        default:
            break;
    }
}

-(void) ColumnShiftForward:(int)nColIndex
{
    int nStartIndex = nColIndex;
    
    int b1 = [self GetBubbleDestinationIndex:nStartIndex];
    BubbleObject* pbFirst = [m_Bubbles objectAtIndex:b1];
    
    for(int i = 1; i < m_nEdge; ++i)
    {
        int k = i*m_nEdge+nColIndex;
        b1 = [self GetBubbleDestinationIndex:k];
        BubbleObject* pb = [m_Bubbles objectAtIndex:b1];
        pb.m_nCurrentLocationIndex = k-m_nEdge;
    }
    pbFirst.m_nCurrentLocationIndex = (m_nEdge-1)*m_nEdge+nColIndex;
}

-(void) VertShiftBubblesForward
{
    if(m_nTouchedCellIndex < 0)
        return;
    int nColIndex = [self GetGridColumne:m_nTouchedCellIndex];

    [self ColumnShiftForward:nColIndex];
}

-(void) ColumnShiftBackward:(int)nColIndex
{
    int b1 = [self GetBubbleDestinationIndex:((m_nEdge-1)*m_nEdge+nColIndex)];
    BubbleObject* pbFirst = [m_Bubbles objectAtIndex:b1];
    
    for(int i = m_nEdge-2; 0 <= i; --i)
    {
        int k = i*m_nEdge+nColIndex;
        b1 = [self GetBubbleDestinationIndex:k];
        BubbleObject* pb = [m_Bubbles objectAtIndex:b1];
        pb.m_nCurrentLocationIndex = k+m_nEdge;
    }
    pbFirst.m_nCurrentLocationIndex = nColIndex;
}

-(void) VertShiftBubblesBackward
{
    if(m_nTouchedCellIndex < 0)
        return;
    int nColIndex = [self GetGridColumne:m_nTouchedCellIndex];

    [self ColumnShiftBackward:nColIndex];
}


-(void) VerticalShiftBubbles
{
    switch(m_Direction)
    {
        case MOTION_DIRECTION_FORWARD:
            [self VertShiftBubblesForward];
            break;
        case MOTION_DIRECTION_BACKWARD:
            [self VertShiftBubblesBackward];
            break;
        default:
            break;
    }
}

-(void) ShiftBubbles
{
    switch(m_Motion)
    {
        case BUBBLE_MOTION_HORIZONTAL:
            [self HorzShiftBubbles];
            break;
        case BUBBLE_MOTION_VERTICAL:
            [self VerticalShiftBubbles];
            break;
        default:
            break;
    }
    [super ShiftBubbles];
}

-(void) ExceuteUndoCommand:(enBubbleMotion)enMotion along:(enMotionDirection)enDir at:(int)nIndex
{
    switch(enMotion)
    {
        case BUBBLE_MOTION_HORIZONTAL:
        {
            if(enDir == MOTION_DIRECTION_FORWARD)
            {
                [self RowShiftBackward:nIndex];
            }
            else if(enDir == MOTION_DIRECTION_BACKWARD)
            {
                [self RowShiftForward:nIndex];
            }
            break;
        }    
        case BUBBLE_MOTION_VERTICAL:
        {    
            if(enDir == MOTION_DIRECTION_FORWARD)
            {
                [self ColumnShiftBackward:nIndex];
            }
            else if(enDir == MOTION_DIRECTION_BACKWARD)
            {
                [self ColumnShiftForward:nIndex];
            }
            break;
        }    
        default:
            break;
    }
}

-(int)GetRowOrColumnFirstLocationIndex:(int)nRowOrColIndex alongWith:(enBubbleMotion)enMotion
{
    int nRet = -1;
    
    switch(enMotion)
    {
        case BUBBLE_MOTION_HORIZONTAL:
        {
            nRet = [self GetFirstIndexAtRow:nRowOrColIndex];
            break;
        }    
        case BUBBLE_MOTION_VERTICAL:
        {    
            nRet = nRowOrColIndex;
            break;
        }    
        default:
            break;
    }
    return nRet;
}

-(void) DrawMotionGridHorizontal:(CGContextRef)context
{
    if(m_nTouchedCellIndex < 0)
    {
        [self DrawStaticGrid:context];
        return;
    }
    
    int nRowIndex = [self GetGridRow:m_nTouchedCellIndex];
    float xOffset = m_fOffset;
    if(m_Direction == MOTION_DIRECTION_BACKWARD)
    {
        xOffset *= -1.0;
    }
    
    int k = 0;
    CGRect rect;
    CGPoint ptCenter;
    float fRad = m_fBubbleSize/2.0;
    BOOL bMotion = NO;
    for (int i = 0; i < m_nEdge; ++i) 
    {
        for(int j = 0; j < m_nEdge; ++j)
        {
            bMotion = NO;
            ptCenter = [self GetBubbleCenter:k];
            if(nRowIndex == i)
            {
                bMotion = YES;
                ptCenter.x += xOffset;
            }
            rect = CGRectMake(ptCenter.x-fRad, ptCenter.y-fRad, m_fBubbleSize, m_fBubbleSize);
            int nIndex = [self GetBubbleDestinationIndex:k];
            BubbleObject* pb = [m_Bubbles objectAtIndex:nIndex];
            if(pb)
                [pb DrawBubble:context inRect:rect inMotion:bMotion];
            ++k;
        }
    }
}


-(void) DrawMotionGridVertical:(CGContextRef)context
{
    if(m_nTouchedCellIndex < 0)
    {
        [self DrawStaticGrid:context];
        return;
    }
    
    int nColIndex = [self GetGridColumne:m_nTouchedCellIndex];
    float yOffset = m_fOffset;
    if(m_Direction == MOTION_DIRECTION_FORWARD)
    {
        yOffset *= -1.0;
    }
    
    int k = 0;
    CGRect rect;
    CGPoint ptCenter;
    float fRad = m_fBubbleSize/2.0;
    BOOL bMotion = NO;
    for (int i = 0; i < m_nEdge; ++i) 
    {
        for(int j = 0; j < m_nEdge; ++j)
        {
            bMotion = NO;
            ptCenter = [self GetBubbleCenter:k];
            if(nColIndex == j)
            {
                bMotion = YES;
                ptCenter.y += yOffset;
            }
            
            rect = CGRectMake(ptCenter.x-fRad, ptCenter.y-fRad, m_fBubbleSize, m_fBubbleSize);
            int nIndex = [self GetBubbleDestinationIndex:k];
            BubbleObject* pb = [m_Bubbles objectAtIndex:nIndex];
            if(pb)
                [pb DrawBubble:context inRect:rect inMotion:bMotion];
            ++k;
        }
    }
}

-(void) DrawMotionGrid:(CGContextRef)context
{
    switch(m_Motion)
    {
        case BUBBLE_MOTION_HORIZONTAL:
            [self DrawMotionGridHorizontal:context];
            break;
        case BUBBLE_MOTION_VERTICAL:
            [self DrawMotionGridVertical:context];
            break;
        default:
            break;
    }
    if(m_Motion != BUBBLE_MOTION_NONE)
        [super DrawArrowAnimation:context];
}

-(int) GetUndoLocationInfo
{
    int nRet = -1;
    
    if(m_Motion == BUBBLE_MOTION_HORIZONTAL)
    {
        nRet = [self GetGridRow:m_nTouchedCellIndex];
    }
    else if(m_Motion == BUBBLE_MOTION_VERTICAL)
    {
        nRet = [self GetGridColumne:m_nTouchedCellIndex];
    }
    
    return nRet;
}

-(void)TestSuite
{
    
}

+(void) DrawSample:(CGContextRef)context withRect:(CGRect)rect withSize:(int)nEdge withBubble:(enBubbleType)enBType
{
    float fBubbleSize = fminf(rect.size.width, rect.size.height)/((float)nEdge);
    float fInnerSize = fBubbleSize*((float)(nEdge-1));
    CGPoint ptCenter = CGPointMake(rect.origin.x+rect.size.width*0.5, rect.origin.y+rect.size.height*0.5);
    float startX = ptCenter.x - fInnerSize*0.5;
    float startY = ptCenter.y - fInnerSize*0.5;
    float fRad = fBubbleSize*0.5;
    
    //enBubbleType enBType = [GameConfiguration GetBubbleType];
    
    for (int i = 0; i < nEdge; ++i) 
    {
        for(int j = 0; j < nEdge; ++j)
        {
            float x = startX + fBubbleSize*j;
            float y = startY + fBubbleSize*i;
            CGRect rt = CGRectMake(x-fRad, y-fRad, fBubbleSize, fBubbleSize);
            if(enBType == PUZZLE_BUBBLE_STAR)
            {
                [RenderHelper DrawStarBubble:context at:rt];
            }
            else if(enBType == PUZZLE_BUBBLE_FROG)
            {
                [RenderHelper DrawFrogBubble:context at:rt];
            }
            else if(enBType == PUZZLE_BUBBLE_REDHEART)
            {
                [RenderHelper DrawHeartBubble:context at:rt];
            }
            else if(enBType == PUZZLE_BUBBLE_BLUE)
            {    
                [RenderHelper DrawBlueBubble:context at:rt];
            }
            else
            {    
                [RenderHelper DrawRedBubble:context at:rt];
            }    
        }
    }
}

@end
