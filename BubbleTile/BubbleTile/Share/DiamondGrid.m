//
//  DiamondGrid.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-07.
//  Copyright 2011 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "DiamondGrid.h"
#import "GameConfiguration.h"
#import "GameLayout.h"
#import "ImageLoader.h"
#import "RenderHelper.h"

@implementation DiamondGrid

-(id)init
{
    if((self = [super init]))
    {
    }
    return self;
}

-(enGridType) GetGridType
{
    return PUZZLE_GRID_DIAMOND;
}

-(void) InitializeMatrixLayout:(enBubbleType)bubbleType
{
    int nRow = m_nEdge*2-1;
    int k = 0;
    for(int i = 0; i < nRow; ++i)
    {
        if(i <= m_nEdge-1)
        {
            for(int j = 0; j <= i; ++j)
            {
                BubbleObject* pb = [[[BubbleObject alloc] initBubble:k+1 isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
                pb.m_nCurrentLocationIndex = k;
                [m_Bubbles addObject:pb];
                ++k;
            }
        }
        else
        {
            for(int j = 0; j < nRow-i; ++j)
            {
                BubbleObject* pb = [[[BubbleObject alloc] initBubble:k+1 isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
                pb.m_nCurrentLocationIndex = k;
                [m_Bubbles addObject:pb];
                ++k;
            }
        }
    }
}

-(void) InitializeSnakeLayout:(enBubbleType)bubbleType
{
    int nRow = m_nEdge*2-1;
    int k = 0;
    for(int i = 0; i < nRow; ++i)
    {
        if(i <= m_nEdge-1)
        {
            if(i%2 == 0)
            {    
                for(int j = 0; j <= i; ++j)
                {
                    BubbleObject* pb = [[[BubbleObject alloc] initBubble:k+1 isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
                    pb.m_nCurrentLocationIndex = k;
                    [m_Bubbles addObject:pb];
                    ++k;
                }
            }
            else
            {
                int n = k+i+1;
                for(int j = 0; j <= i; ++j)
                {
                    BubbleObject* pb = [[[BubbleObject alloc] initBubble:n-j isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
                    pb.m_nCurrentLocationIndex = k;
                    [m_Bubbles addObject:pb];
                    ++k;
                }
            }
        }
        else
        {
            if(i%2 == 0)
            {    
                for(int j = 0; j < nRow-i; ++j)
                {
                    BubbleObject* pb = [[[BubbleObject alloc] initBubble:k+1 isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
                    pb.m_nCurrentLocationIndex = k;
                    [m_Bubbles addObject:pb];
                    ++k;
                }
            }
            else
            {
                int n = k+nRow-i;
                for(int j = 0; j < nRow-i; ++j)
                {
                    BubbleObject* pb = [[[BubbleObject alloc] initBubble:n-j isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
                    pb.m_nCurrentLocationIndex = k;
                    [m_Bubbles addObject:pb];
                    ++k;
                }
            }
        }
    }
}

-(void) InitializeSpiralLayout:(enBubbleType)bubbleType
{
    if(m_nEdge <= 0)
        return;
    
    int nSize = m_nEdge * m_nEdge;
    int *label = (int*)malloc(sizeof(int)*nSize);
    int nDirection = 0;
    int nCount = 0;
    int nRound = 0;
    while (nCount < nSize)
    {
        for (int i = nRound; i < m_nEdge -1 - nRound; i++)
        {
            if (nDirection == 0)
            {
                *(label + nRound*m_nEdge + i) = ++nCount;
            }
            else if (nDirection == 1)
            {
                *(label + i*m_nEdge + m_nEdge-1-nRound) = ++nCount;
            }
            else if (nDirection == 2)
            {
                *(label + (m_nEdge-1-nRound)*m_nEdge + (m_nEdge-1 - i)) = ++nCount;
            }
            else if (nDirection == 3)
            {
                *(label + (m_nEdge-1-i)*m_nEdge + nRound) = ++nCount;
            }
        }
        
        nDirection = ++nDirection%4;
        if (nDirection == 0)
        {
            nRound++;
            if (nRound == m_nEdge -1 - nRound)
            {
                *(label + nRound*m_nEdge + nRound) = ++nCount;
                break; // last element is the center.
            }
        }
    }
    
    int nRow = m_nEdge*2-1;
    nCount = 0;
    for (int i = 0; i < nRow; ++i) 
    {
        int nLen = i < m_nEdge ? (i+1) : (nRow - i);
        int x = i < m_nEdge ? 0 : i-m_nEdge+1;
        int y = i < m_nEdge ? i : m_nEdge -1;
        
        for (int j = 0; j < nLen; j++)
        {            
            int nLabel = *(label + y*m_nEdge+x);
            x++;
            y--;
            
            BubbleObject* pb = [[[BubbleObject alloc] initBubble:nLabel isTemplate:m_bIconTemplate withType:bubbleType] autorelease];
            pb.m_nCurrentLocationIndex = nCount++;
            [m_Bubbles addObject:pb];
        }
    }
    
    free(label);
    label = NULL;
}

-(void) CalculateBubbleSize
{
    float fMaxSize = m_nEdge*SQURT_3;
    float gridSize = [self GetGridMaxSize:fMaxSize];
    m_fBubbleSize = gridSize/fMaxSize;
}

-(void) InitializeGridCells
{
    float fInnerWidth = m_fBubbleSize*(m_nEdge-1);
    float fInnerHeight = fInnerWidth*SQURT_3;
    CGPoint ptCenter = [self GetGridCenter];
    float startX = ptCenter.x;
    float startY = ptCenter.y - fInnerHeight*0.5;
    float deltaX = m_fBubbleSize*0.5;
    float deltaY = deltaX*SQURT_3;
  
    int nRow = m_nEdge*2-1;

    for(int i = 0; i < nRow; ++i)
    {
        if(i <= m_nEdge-1)
        {
            for(int j = 0; j <= i; ++j)
            {
                float y = startY + deltaY*i;
                float x = startX;
                int k = i%2;
                if(k == 0)
                {    
                    int l = (int)(((float)i)/2.0);
                    x += (j-l)*deltaX*2.0;
                }
                else
                {
                    float m = i/2.0;
                    x += (((float)j)-m)*m_fBubbleSize; 
                }
                GridCell* pc = [[[GridCell alloc] initWithX:x withY:y] autorelease];
                [m_Cells addObject:pc];
            }
        }
        else
        {
            for(int j = 0; j < nRow-i; ++j)
            {
                float y = startY + deltaY*i;
                float x = startX;
                int k = i%2;
                if(k == 0)
                {    
                    float l = (((float)(nRow-i-1))/2.0);
                    x += (j-l)*deltaX*2.0;
                }
                else
                {
                    float m = (nRow-i-1)/2.0;
                    x += (((float)j)-m)*m_fBubbleSize; 
                }
                GridCell* pc = [[[GridCell alloc] initWithX:x withY:y] autorelease];
                [m_Cells addObject:pc];
            }    
        }
    }
    
}

-(int) GetBubbleNumberAtRow:(int)nRowIndex
{
    int nRet = -1;

    int nRow = m_nEdge*2-1;
    
    if(0 <= nRowIndex && nRowIndex < m_nEdge)
        nRet = nRowIndex+1;
    else if(nRowIndex < nRow)
        nRet = nRow - nRowIndex;
    
    return nRet;
}

-(int) GetFirstIndexAtRow:(int)nRowIndex
{
    int nRet = -1;
    
    int nRow = m_nEdge*2-1;
    
    if(0 <= nRowIndex && nRowIndex < m_nEdge)
        nRet = (nRowIndex+1)*nRowIndex/2;
    else if(nRowIndex < nRow)
    {
        int rEdge = nRow - nRowIndex;
        int rCount = rEdge*(rEdge+1)/2;
        nRet = [CPuzzleGrid GetDiamonGridBubbleNumber:m_nEdge]-rCount;
    }    
    
    return nRet;
}

-(int) GetLastIndexAtRow:(int)nRowIndex
{
    int nRet = -1;
    
    int nRow = m_nEdge*2-1;
    
    if(0 <= nRowIndex && nRowIndex < nRow-1)
        nRet = [self GetFirstIndexAtRow:nRowIndex+1]-1;
    else if(nRowIndex == nRow-1)
    {
        nRet = [CPuzzleGrid GetDiamonGridBubbleNumber:m_nEdge]-1;
    }    
    
    return nRet;
}

-(int) GetGridRow:(int)nIndex
{
    int nRet = -1;
    int nCount  = [CPuzzleGrid GetDiamonGridBubbleNumber:m_nEdge];
    int nRow = m_nEdge*2-1;
    for(int i = 0; i < nRow; ++i)
    {
        if(i <= m_nEdge-1)
        {
            int j = i+1;
            int v1 = (i+1)*i/2;
            int v2 = (j+1)*j/2;
            if(v1 <= nIndex && nIndex < v2)
            {
                nRet = i;
                break;
            }
        }
        else
        {
            int j = nRow-i;
            int k = nRow-(i+1);
            int v1 = nCount - (j+1)*j/2;
            int v2 = nCount - (k+1)*k/2;
            if(v1 <= nIndex && nIndex < v2)
            {
                nRet = i;
                break;
            }
        }
    }
    
    return nRet;
}

-(int) GetGridColumne:(int)nIndex
{
    int nRet = -1;
    
    int nRowIndex = [self GetGridRow:nIndex];
    int nRow = m_nEdge*2-1;
    int nFirstIndexAtRow = [self GetFirstIndexAtRow:nRowIndex];
    if(0 <= nRowIndex && nRowIndex <= m_nEdge-1)
    {    
        nRet = nIndex - nFirstIndexAtRow;
    }
    else if(nRowIndex < nRow)
    {
        int nStep = nIndex-nFirstIndexAtRow;
        int nTemp = nRowIndex-(m_nEdge-1);
        nRet = nStep+nTemp;
    }
    
    return nRet;
}



-(void) UpdateGridLayout
{
    [super UpdateGridLayout];

    [self CalculateBubbleSize];
    
    float fInnerWidth = m_fBubbleSize*(m_nEdge-1);
    float fInnerHeight = fInnerWidth*SQURT_3;
    CGPoint ptCenter = [self GetGridCenter];
    float startX = ptCenter.x;
    float startY = ptCenter.y - fInnerHeight*0.5;
    float deltaX = m_fBubbleSize*0.5;
    float deltaY = deltaX*SQURT_3;
    
    int nIndex = 0;

    int nRow = m_nEdge*2-1;
    
    for(int i = 0; i < nRow; ++i)
    {
        if(i <= m_nEdge-1)
        {
            for(int j = 0; j <= i; ++j)
            {
                float y = startY + deltaY*i;
                float x = startX;
                int k = i%2;
                if(k == 0)
                {    
                    int l = (int)(((float)i)/2.0);
                    x += (j-l)*deltaX*2.0;
                }
                else
                {
                    float m = i/2.0;
                    x += (((float)j)-m)*m_fBubbleSize; 
                }
                [[m_Cells objectAtIndex:nIndex] SetCenter:x withY:y];
                ++nIndex;
            }
        }
        else
        {
            for(int j = 0; j < nRow-i; ++j)
            {
                float y = startY + deltaY*i;
                float x = startX;
                int k = i%2;
                if(k == 0)
                {    
                    float l = (((float)(nRow-i-1))/2.0);
                    x += (j-l)*deltaX*2.0;
                }
                else
                {
                    float m = (nRow-i-1)/2.0;
                    x += (((float)j)-m)*m_fBubbleSize; 
                }
                [[m_Cells objectAtIndex:nIndex] SetCenter:x withY:y];
                ++nIndex;
            }    
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
                float f60sign = dx*dy;
                if(f60sign <= 0.0)
                {
                    m_Motion = BUBBLE_MOTION_60DIAGONAL;
                    if(dy < 0)
                        m_Direction = MOTION_DIRECTION_FORWARD;
                    else
                        m_Direction = MOTION_DIRECTION_BACKWARD;
                }
                else
                {
                    m_Motion = BUBBLE_MOTION_120DIAGONAL;
                    if(dy < 0 && dx < 0)
                        m_Direction = MOTION_DIRECTION_FORWARD;
                    else
                        m_Direction = MOTION_DIRECTION_BACKWARD;
                }
                m_fOffset = temp;
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
        else if(m_Motion == BUBBLE_MOTION_60DIAGONAL)
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
            m_fOffset = sqrtf(dy2+dx2);
        }
        else if(m_Motion == BUBBLE_MOTION_120DIAGONAL)
        {
            if(dy < 0 && dx < 0)
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
            m_fOffset = sqrtf(dy2+dx2);
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

-(int) GetFirstIndexAtDiagonal60Column:(int)nColIndex
{
    int nRet = -1;
    
    if(0 <= nColIndex && nColIndex < m_nEdge)
    {
        nRet = [CPuzzleGrid GetTriangleGridLastIndexAtRow:nColIndex];
    }
    
    return nRet;
}

-(int) GetLastIndexAtDiagonal60Column:(int)nColIndex
{
    int nRet = -1;
    
    if(0 <= nColIndex && nColIndex < m_nEdge)
    {
        nRet = [self GetFirstIndexAtRow:(m_nEdge-1+nColIndex)];
    }
    
    return nRet;
}

-(int) GetIndexAtDiagonal60Column:(int)nColIndex with:(int)nCellIndex
{
    int nRet = -1;
    
    int nRow = m_nEdge*2-1;
    if(0 <= nColIndex && nColIndex < m_nEdge && 0 <= nCellIndex && nCellIndex < m_nEdge)
    {
        int nRowIndex = nColIndex + nCellIndex;
        int nFistIndex = [self GetFirstIndexAtRow:nRowIndex];
        if(0 <= nRowIndex && nRowIndex <= m_nEdge-1)
        {
            nRet = nFistIndex + nColIndex;
        }
        else if(nRowIndex < nRow)
        {
            int nNewCellIndex = m_nEdge - (nCellIndex+1);
            nRet = nFistIndex + nNewCellIndex;
        }
    }
    
    return nRet;
}

-(int) GetBubbleNumberAtDiagonal60Column:(int)nColIndex
{
    int nRet = -1;
    
    if(0 <= nColIndex && nColIndex < m_nEdge)
    {
        nRet = m_nEdge;
    }
    
    return nRet;
}

-(void) Diagonal60ShiftForward:(int)nColIndex
{
    int nCount = [self GetBubbleNumberAtDiagonal60Column:nColIndex];
    
    if(nCount <= 1)
        return;
    
    for(int i = 0; i < nCount-1; ++i)
    {   
        int index1 = [self GetIndexAtDiagonal60Column:nColIndex with:i];
        int index2 = [self GetIndexAtDiagonal60Column:nColIndex with:i+1];
        
        int b1 = [self GetBubbleDestinationIndex:index1];
        int b2 = [self GetBubbleDestinationIndex:index2];
        BubbleObject* pb1 = [m_Bubbles objectAtIndex:b1];
        pb1.m_nCurrentLocationIndex = index2;
        BubbleObject* pb2 = [m_Bubbles objectAtIndex:b2];
        pb2.m_nCurrentLocationIndex = index1;
    }
}

-(void) Diagonal60ShiftBubblesForward
{
    if(m_nTouchedCellIndex < 0)
        return;
    
    int nColIndex = [self GetGridColumne:m_nTouchedCellIndex];
    [self Diagonal60ShiftForward:nColIndex];
}

-(void) Diagonal60ShiftBackward:(int)nColIndex
{
    int nCount = [self GetBubbleNumberAtDiagonal60Column:nColIndex];
    
    if(nCount <= 1)
        return;
    
    for(int i = nCount-1; 0 < i; --i)
    {   
        int index1 = [self GetIndexAtDiagonal60Column:nColIndex with:i];
        int index2 = [self GetIndexAtDiagonal60Column:nColIndex with:i-1];
        
        int b1 = [self GetBubbleDestinationIndex:index1];
        int b2 = [self GetBubbleDestinationIndex:index2];
        BubbleObject* pb1 = [m_Bubbles objectAtIndex:b1];
        pb1.m_nCurrentLocationIndex = index2;
        BubbleObject* pb2 = [m_Bubbles objectAtIndex:b2];
        pb2.m_nCurrentLocationIndex = index1;
    }
}

-(void) Diagonal60ShiftBubblesBackward
{
    if(m_nTouchedCellIndex < 0)
        return;
    
    int nColIndex = [self GetGridColumne:m_nTouchedCellIndex];
    [self Diagonal60ShiftBackward:nColIndex];
}

-(void) Diagonal60ShiftBubbles
{
    switch(m_Direction)
    {
        case MOTION_DIRECTION_FORWARD:
            [self Diagonal60ShiftBubblesForward];
            break;
        case MOTION_DIRECTION_BACKWARD:
            [self Diagonal60ShiftBubblesBackward];
            break;
        default:
            break;
    }
}

-(int) GetGridDiagonal120Columne:(int)nIndex
{
    int nRet = -1;
    
    int nRowIndex = [self GetGridRow:nIndex];
    int nRow = m_nEdge*2-1;
    int nFirstIndexAtRow = [self GetFirstIndexAtRow:nRowIndex];
    if(0 <= nRowIndex && nRowIndex <= m_nEdge-1)
    {    
        nRet = nRowIndex - (nIndex - nFirstIndexAtRow);
    }
    else if(nRowIndex < nRow)
    {
        int nStep = nIndex-nFirstIndexAtRow;
        nRet = (m_nEdge-1) - nStep;
    }
    
    return nRet;
}

-(int) GetFirstIndexAtDiagonal120Column:(int)nColIndex
{
    int nRet = -1;
    
    if(0 <= nColIndex && nColIndex < m_nEdge)
    {
        nRet = [self GetFirstIndexAtRow:nColIndex];
    }
    
    return nRet;
}

-(int) GetLastIndexAtDiagonal120Column:(int)nColIndex
{
    int nRet = -1;
    
    if(0 <= nColIndex && nColIndex < m_nEdge)
    {
        int nRowIndex = (m_nEdge-1)+nColIndex;
        int nFirstIndex = [self GetFirstIndexAtRow:nRowIndex];
        int nCount = [self GetBubbleNumberAtRow:nRowIndex];
        nRet = nFirstIndex + nCount - 1;
    }
    
    return nRet;
}

-(int) GetIndexAtDiagonal120Column:(int)nColIndex with:(int)nCellIndex
{
    int nRet = -1;
    
    int nRow = m_nEdge*2-1;
    if(0 <= nColIndex && nColIndex < m_nEdge && 0 <= nCellIndex && nCellIndex < m_nEdge)
    {
        int nRowIndex = nColIndex + nCellIndex;
        int nFistIndex = [self GetFirstIndexAtRow:nRowIndex];
        if(0 <= nRowIndex && nRowIndex <= m_nEdge-1)
        {
            nRet = nFistIndex + nCellIndex;
        }
        else if(nRowIndex < nRow)
        {
            int nCount = [self GetBubbleNumberAtRow:nRowIndex];
            int nNewCellIndex = (nCount-1) - (m_nEdge - (nCellIndex+1));
            nRet = nFistIndex + nNewCellIndex;
        }
    }
    
    return nRet;
}

-(int) GetBubbleNumberAtDiagonal120Column:(int)nColIndex
{
    int nRet = -1;
    
    if(0 <= nColIndex && nColIndex < m_nEdge)
    {
        nRet = m_nEdge;
    }
    
    return nRet;
}

-(void) Diagonal120ShiftForward:(int)nColIndex
{
    int nCount = [self GetBubbleNumberAtDiagonal120Column:nColIndex];
    
    if(nCount <= 1)
        return;
    
    for(int i = 0; i < nCount-1; ++i)
    {   
        int index1 = [self GetIndexAtDiagonal120Column:nColIndex with:i];
        int index2 = [self GetIndexAtDiagonal120Column:nColIndex with:i+1];
        
        int b1 = [self GetBubbleDestinationIndex:index1];
        int b2 = [self GetBubbleDestinationIndex:index2];
        BubbleObject* pb1 = [m_Bubbles objectAtIndex:b1];
        pb1.m_nCurrentLocationIndex = index2;
        BubbleObject* pb2 = [m_Bubbles objectAtIndex:b2];
        pb2.m_nCurrentLocationIndex = index1;
    }
}

-(void) Diagonal120ShiftBubblesForward
{
    if(m_nTouchedCellIndex < 0)
        return;
    
    int nRowIndex = [self GetGridRow:m_nTouchedCellIndex];
    int nColIndex = nRowIndex - [self GetGridColumne:m_nTouchedCellIndex];

    [self Diagonal120ShiftForward:nColIndex];
}

-(void) Diagonal120ShiftBackward:(int)nColIndex
{
    int nCount = [self GetBubbleNumberAtDiagonal120Column:nColIndex];
    
    if(nCount <= 1)
        return;
    
    for(int i = nCount-1; 0 < i; --i)
    {   
        int index1 = [self GetIndexAtDiagonal120Column:nColIndex with:i];
        int index2 = [self GetIndexAtDiagonal120Column:nColIndex with:i-1];
        
        int b1 = [self GetBubbleDestinationIndex:index1];
        int b2 = [self GetBubbleDestinationIndex:index2];
        BubbleObject* pb1 = [m_Bubbles objectAtIndex:b1];
        pb1.m_nCurrentLocationIndex = index2;
        BubbleObject* pb2 = [m_Bubbles objectAtIndex:b2];
        pb2.m_nCurrentLocationIndex = index1;
    }
}

-(void) Diagonal120ShiftBubblesBackward
{
    if(m_nTouchedCellIndex < 0)
        return;
    
    int nRowIndex = [self GetGridRow:m_nTouchedCellIndex];
    int nColIndex = nRowIndex - [self GetGridColumne:m_nTouchedCellIndex];

    [self Diagonal120ShiftBackward:nColIndex];
}

-(void) Diagonal120ShiftBubbles
{
    switch(m_Direction)
    {
        case MOTION_DIRECTION_FORWARD:
            [self Diagonal120ShiftBubblesForward];
            break;
        case MOTION_DIRECTION_BACKWARD:
            [self Diagonal120ShiftBubblesBackward];
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
        case BUBBLE_MOTION_60DIAGONAL:
            [self Diagonal60ShiftBubbles];
            break;
        case BUBBLE_MOTION_120DIAGONAL:
            [self Diagonal120ShiftBubbles];
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
        case BUBBLE_MOTION_60DIAGONAL:
        {    
            if(enDir == MOTION_DIRECTION_FORWARD)
            {
                [self Diagonal60ShiftBackward:nIndex];
            }
            else if(enDir == MOTION_DIRECTION_BACKWARD)
            {
                [self Diagonal60ShiftForward:nIndex];
            }
            break;
        }    
        case BUBBLE_MOTION_120DIAGONAL:
        {    
            if(enDir == MOTION_DIRECTION_FORWARD)
            {
                [self Diagonal120ShiftBackward:nIndex];
            }
            else if(enDir == MOTION_DIRECTION_BACKWARD)
            {
                [self Diagonal120ShiftForward:nIndex];
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
        case BUBBLE_MOTION_60DIAGONAL:
        {    
            nRet = [self GetFirstIndexAtDiagonal60Column:nRowOrColIndex];
            break;
        }    
        case BUBBLE_MOTION_120DIAGONAL:
        {    
            nRet = [self GetFirstIndexAtDiagonal120Column:nRowOrColIndex];
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
    
    int nRow = m_nEdge*2-1;
    
    float fyOffset = (1.0 - SQURT_3*0.5)*fabsf(xOffset)*SHIFT_FACTOR0;
    BOOL bMotion = NO;
    for(int i = 0; i < nRow; ++i)
    {
        if(i <= m_nEdge-1)
        {
            for(int j = 0; j <= i; ++j)
            {
                bMotion = NO;
                ptCenter = [self GetBubbleCenter:k];
                if(nRowIndex == i)
                {
                    bMotion = YES;
                    ptCenter.x += xOffset;
                }
                else if(i < nRowIndex)
                {
                    ptCenter.y -= fyOffset;
                }
                else
                {
                    ptCenter.y += fyOffset;
                }
               rect = CGRectMake(ptCenter.x-fRad, ptCenter.y-fRad, m_fBubbleSize, m_fBubbleSize);
                int nIndex = [self GetBubbleDestinationIndex:k];
                BubbleObject* pb = [m_Bubbles objectAtIndex:nIndex];
                if(pb)
                    [pb DrawBubble:context inRect:rect inMotion:bMotion];
            
                ++k;
            }
        }
        else
        {
            for(int j = 0; j < nRow-i; ++j)
            {
                bMotion = NO;
                ptCenter = [self GetBubbleCenter:k];
                if(nRowIndex == i)
                {
                    bMotion = YES;
                    ptCenter.x += xOffset;
                }
                else if(i < nRowIndex)
                {
                    ptCenter.y -= fyOffset;
                }
                else
                {
                    ptCenter.y += fyOffset;
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
}

-(void) DrawMotionGrid60Diagonal:(CGContextRef)context
{
    if(m_nTouchedCellIndex < 0)
    {
        [self DrawStaticGrid:context];
        return;
    }    
    
    int nColIndex = [self GetGridColumne:m_nTouchedCellIndex];
    
    float xOffset = m_fOffset*0.5;
    float yOffset = xOffset*SQURT_3;
    if(m_Direction == MOTION_DIRECTION_FORWARD)
    {
        yOffset *= -1.0;
    }
    else
    {
        xOffset *= -1.0;
    }
    
    int k = 0;
    CGRect rect;
    CGPoint ptCenter;
    float fRad = m_fBubbleSize/2.0;

    int nRow = m_nEdge*2-1;
    float fxOffset = (1.0 - SQURT_3*0.5)*fabsf(xOffset);
    BOOL bMotion = NO;
    for (int i = 0; i < nRow; ++i) 
    {
        if(i <= m_nEdge-1)
        {
            for(int j = 0; j <= i; ++j)
            {
                bMotion = NO;
                ptCenter = [self GetBubbleCenter:k];
                if(nColIndex == j)
                {
                    bMotion = YES;
                    ptCenter.x += xOffset;
                    ptCenter.y += yOffset;
                }
                else if(j < nColIndex)
                {
                    ptCenter.x -= fxOffset*SHIFT_FACTOR1;
                }
                else
                {
                    ptCenter.x += fxOffset*SHIFT_FACTOR2;
                }
                rect = CGRectMake(ptCenter.x-fRad, ptCenter.y-fRad, m_fBubbleSize, m_fBubbleSize);
                int nIndex = [self GetBubbleDestinationIndex:k];
                BubbleObject* pb = [m_Bubbles objectAtIndex:nIndex];
                if(pb)
                    [pb DrawBubble:context inRect:rect inMotion:bMotion];
                ++k;
            }
        }   
        else
        {
            for(int j = 0; j < nRow-i; ++j)
            {
                bMotion = NO;
                ptCenter = [self GetBubbleCenter:k];
                int nTempIndex = i-(m_nEdge-1)+j;
                if(nColIndex == nTempIndex)
                {
                    bMotion = YES;
                    ptCenter.x += xOffset;
                    ptCenter.y += yOffset;
                }
                else if(nTempIndex < nColIndex)
                {
                    ptCenter.x -= fxOffset*SHIFT_FACTOR1;
                }
                else
                {
                    ptCenter.x += fxOffset*SHIFT_FACTOR2;
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
}

-(void) DrawMotionGrid120Diagonal:(CGContextRef)context
{
    if(m_nTouchedCellIndex < 0)
    {
        [self DrawStaticGrid:context];
        return;
    }    
    
    int nColIndex = [self GetGridDiagonal120Columne:m_nTouchedCellIndex];
    
    float xOffset = m_fOffset*0.5;
    float yOffset = xOffset*SQURT_3;
    if(m_Direction == MOTION_DIRECTION_FORWARD)
    {
        xOffset *= -1.0;
        yOffset *= -1.0;
    }
    
    int k = 0;
    CGRect rect;
    CGPoint ptCenter;
    float fRad = m_fBubbleSize/2.0;
    
    int nRow = m_nEdge*2-1;
    float fxOffset = (1.0 - SQURT_3*0.5)*fabsf(xOffset);
    BOOL bMotion = NO;
    for (int i = 0; i < nRow; ++i) 
    {
        if(i <= m_nEdge-1)
        {
            for(int j = 0; j <= i; ++j)
            {
                bMotion = NO;
                ptCenter = [self GetBubbleCenter:k];
                if(nColIndex == (i-j))
                {
                    bMotion = YES;
                    ptCenter.x += xOffset;
                    ptCenter.y += yOffset;
                }
                else if((i-j) < nColIndex)
                {
                    ptCenter.x += fxOffset*SHIFT_FACTOR2;
                }
                else
                {
                    ptCenter.x -= fxOffset*SHIFT_FACTOR1;
                }
                
                rect = CGRectMake(ptCenter.x-fRad, ptCenter.y-fRad, m_fBubbleSize, m_fBubbleSize);
                int nIndex = [self GetBubbleDestinationIndex:k];
                BubbleObject* pb = [m_Bubbles objectAtIndex:nIndex];
                if(pb)
                    [pb DrawBubble:context inRect:rect inMotion:bMotion];
                ++k;
            }
        }   
        else
        {
            for(int j = 0; j < nRow-i; ++j)
            {
                bMotion = NO;
                ptCenter = [self GetBubbleCenter:k];
                int nTempIndex = (m_nEdge-1)-j;
                if(nColIndex == nTempIndex)
                {
                    bMotion = YES;
                    ptCenter.x += xOffset;
                    ptCenter.y += yOffset;
                }
                else if(nTempIndex < nColIndex)
                {
                    ptCenter.x += fxOffset*SHIFT_FACTOR2;
                }
                else
                {
                    ptCenter.x -= fxOffset*SHIFT_FACTOR1;
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
}

-(void) DrawMotionGrid:(CGContextRef)context
{
    switch(m_Motion)
    {
        case BUBBLE_MOTION_HORIZONTAL:
            [self DrawMotionGridHorizontal:context];
            break;
        case BUBBLE_MOTION_60DIAGONAL:
            [self DrawMotionGrid60Diagonal:context];
            break;
        case BUBBLE_MOTION_120DIAGONAL:
            [self DrawMotionGrid120Diagonal:context];
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
    else if(m_Motion == BUBBLE_MOTION_60DIAGONAL)
    {
        nRet = [self GetGridColumne:m_nTouchedCellIndex];
    }
    else if(m_Motion == BUBBLE_MOTION_120DIAGONAL)
    {
        nRet = [self GetGridDiagonal120Columne:m_nTouchedCellIndex];
    }
    
    return nRet;
}

-(void)TestSuite
{
    
}

+(void) DrawSample:(CGContextRef)context withRect:(CGRect)rect withSize:(int)nEdge withBubble:(enBubbleType)enBType
{
    float fMaxSize = ((float)(nEdge))*SQURT_3;
    
    float fBubbleSize = fminf(rect.size.width, rect.size.height)/fMaxSize;
    CGPoint ptCenter = CGPointMake(rect.origin.x+rect.size.width*0.5, rect.origin.y+rect.size.height*0.5);
    float fInnerWidth = fBubbleSize*(nEdge-1);
    float fInnerHeight = fInnerWidth*SQURT_3;
    float startX = ptCenter.x;
    float startY = ptCenter.y - fInnerHeight*0.5;
    float deltaX = fBubbleSize*0.5;
    float deltaY = deltaX*SQURT_3;
    float fRad = fBubbleSize*0.5;
    
    //CGImageRef  bkImage = NULL;
    //enBubbleType enBType = [GameConfiguration GetBubbleType];
    int nRow = nEdge*2-1;
    for(int i = 0; i < nRow; ++i)
    {
        if(i <= nEdge-1)
        {
            for(int j = 0; j <= i; ++j)
            {
                float y = startY + deltaY*i;
                float x = startX;
                int k = i%2;
                if(k == 0)
                {    
                    int l = (int)(((float)i)/2.0);
                    x += (j-l)*deltaX*2.0;
                }
                else
                {
                    float m = i/2.0;
                    x += (((float)j)-m)*fBubbleSize; 
                }
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
        else
        {
            for(int j = 0; j < nRow-i; ++j)
            {
                float y = startY + deltaY*i;
                float x = startX;
                int k = i%2;
                if(k == 0)
                {    
                    float l = (((float)(nRow-i-1))/2.0);
                    x += (j-l)*deltaX*2.0;
                }
                else
                {
                    float m = (nRow-i-1)/2.0;
                    x += (((float)j)-m)*fBubbleSize; 
                }
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
    //CGImageRelease(bkImage);
}

@end
