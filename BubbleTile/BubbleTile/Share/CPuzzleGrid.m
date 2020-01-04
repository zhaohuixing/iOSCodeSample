//
//  CPuzzleGrid.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-08.
//  Copyright 2011 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "BTFileConstant.h"
#import "GUILayout.h"
#import "CPuzzleGrid.h"
#import "GameConfiguration.h"
#import "TriangleGrid.h"
#import "DiamondGrid.h"
#import "SquareGrid.h"
#import "HexagonGrid.h"
#import "ShuffleSuite.h"
#import "GameLayout.h"
#import "GUIEventLoop.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "ApplicationController.h"
#import "ImageLoader.h"
#import "CUndoCommand.h"
#import "RenderHelper.h"
#import "GameScore.h"
#import "DebogConsole.h"
#import "UIDevice-Reachability.h"
#import "CustomModalAlertView.h"
#import "StringFactory.h"
#include <math.h>

@implementation CPuzzleGrid

-(id)init
{
    if((self = [super init]))
    {
        m_LayoutType = PUZZLE_LALOUT_MATRIX;
        m_nEdge = [GameConfiguration GetDefaultBubbleUnit];
        m_fBubbleSize = 128;
        m_Bubbles = [[NSMutableArray alloc] init]; //[[[NSMutableArray alloc] init] retain];
        m_Cells = [[NSMutableArray alloc] init]; //[[[NSMutableArray alloc] init] retain];
        m_IndexListForReset = [[NSMutableArray alloc] init];//[[[NSMutableArray alloc] init] retain];     
        m_UndoCommandList = [[NSMutableArray alloc] init];//[[[NSMutableArray alloc] init] retain];

        m_bIconTemplate = NO;

        m_ArrowAnimation = [ImageLoader LoadResourceImage:@"arrow.png"];
        m_StarBall = [ImageLoader LoadResourceImage:@"starballs.png"];

        m_bWinState = NO;
        [self CleanTouchState];
        m_EasySuite = [[EasyShuffleSuite alloc] init];
        
        m_bEasyAnimation = NO;
        m_SnapshotInEasyAnimation = [[NSMutableArray alloc] init];
        m_nEasyAnimationStep = 0;
        m_bNeedReset = NO;
        
    }
    return self;
}

-(void)Dealloc
{
	[m_Bubbles removeAllObjects];
	[m_Bubbles release];
	[m_Cells removeAllObjects];
	[m_Cells release];
	[m_IndexListForReset removeAllObjects];
	[m_IndexListForReset release];
	[m_UndoCommandList removeAllObjects];
    [m_UndoCommandList release];
    CGImageRelease(m_ArrowAnimation);
    CGImageRelease(m_StarBall);
    [m_EasySuite release];
    [m_SnapshotInEasyAnimation release];
    [self release];
}

-(enGameType)GetGameType
{
    return GAME_BUBBLE_TILE;
}

-(enGridLayout) GetGridLayout
{
    return m_LayoutType;
}

-(void) SetGridLayout:(enGridLayout)gLayout
{
    m_LayoutType = gLayout;
}

-(void) SetBubbleUnit: (int)nEdge
{
    m_nEdge = nEdge;
}

-(int) GetBubbleUnit
{
    return m_nEdge;
}

-(float) GetBubbleDiameter
{
    return m_fBubbleSize;
}

-(CGPoint) GetBubbleCenter:(int)nIndex
{
    CGPoint pt = CGPointMake(-1, -1);
    
    int nCount = [m_Cells count];
    if(0 < nCount && 0 <= nIndex && nIndex < nCount)
    {
        GridCell* pc = [m_Cells objectAtIndex:nIndex];
        if(pc)
        {
            pt = pc._m_Center;
        }
    }
    
    return pt;
}

-(void) UpdateGridLayout
{
    
}

-(void) DrawStaticGrid:(CGContextRef)context
{
    int nCount = [m_Bubbles count];
    if(0 < nCount)
    {
        CGRect rect;
        float fRad = m_fBubbleSize/2.0;
        for(int i = 0; i < nCount; ++i)
        {
            BubbleObject* pb = [m_Bubbles objectAtIndex:i];
            if(pb)
            {
                CGPoint pt = [self GetBubbleCenter:pb.m_nCurrentLocationIndex];
                if(0 <= pt.x && 0 <= pt.y)
                {
                    rect = CGRectMake(pt.x-fRad, pt.y-fRad, m_fBubbleSize, m_fBubbleSize);
                    [pb DrawBubble:context inRect:rect inMotion:NO];
                }
            }
        }
    }
}

-(void) DrawWinLayout:(CGContextRef)context
{
    [self DrawStaticGrid:context];
    int nCount = [m_Bubbles count];
    if(0 < nCount)
    {
        CGRect rect;
        float fRad = m_fBubbleSize/10.0;
        float fStoke = 2.4;
        if([ApplicationConfigure iPhoneDevice])
            fStoke = 2;
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, fStoke);
        CGContextSetRGBStrokeColor(context, 1, 1, 0.5, 1);
        CGColorSpaceRef		shadowClrSpace;
        CGColorRef			shadowClrs;
        CGSize				shadowSize;
        shadowClrSpace = CGColorSpaceCreateDeviceRGB();
        shadowSize = CGSizeMake(5, 5);
        float clrvals[] = {0.1, 0.1, 0.1, 0.9};
        shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
        CGContextSetShadowWithColor(context, shadowSize, 6.0, shadowClrs);
        ///
        CGContextSetAlpha(context, 0.8);

        for(int i = 0; i < nCount; ++i)
        {
            int nLabel1 = i+1;
            int index1 = [self GetBubbleDestinationIndexByLabelValue:nLabel1];
            BubbleObject* pb = [m_Bubbles objectAtIndex:index1];
            if(pb)
            {
                CGPoint pt = [self GetBubbleCenter:pb.m_nCurrentLocationIndex];
                if((i+1) < nCount)
                {
                    int nLabel2 = nLabel1+1;
                    int index2 = [self GetBubbleDestinationIndexByLabelValue:nLabel2];
                    BubbleObject* pb2 = [m_Bubbles objectAtIndex:index2];
                    if(pb2)
                    {
                        CGPoint pt2 = [self GetBubbleCenter:pb2.m_nCurrentLocationIndex];
                        ///
                        DrawLine1(context, pt, pt2);
                    }
                }
                if(0 <= pt.x && 0 <= pt.y)
                {
                    rect = CGRectMake(pt.x-fRad, pt.y-fRad, fRad*2.0, fRad*2.0);
                    CGContextDrawImage(context, rect, m_StarBall);
                }
                
            }
        }
        CGContextRestoreGState(context);
        CGColorSpaceRelease(shadowClrSpace);
        CGColorRelease(shadowClrs);
        
    }
}

-(void) DrawGameTypeIndicator:(CGContextRef)context
{
    CGRect rt = [GameLayout GetGameDifficultyIndicatorRect];
    if([GameConfiguration IsGameDifficulty] == YES)
    {
        [RenderHelper DrawRedIndicator:context at:rt];
    }
    else
    {
        if(m_bNeedReset)
        {
            if(m_nLEDFlashStep == 0)
                [RenderHelper DrawGreenIndicator:context at:rt];
        }
        else
        {    
            [RenderHelper DrawGreenIndicator:context at:rt];
        }    
    }
}

//This is default implementation and need to be updated to render
//the bobbule motion with the bubble motion algorithm.
-(void) DrawGrid:(CGContextRef)context
{
    [self DrawGameTypeIndicator:context];
    if(m_Motion == BUBBLE_MOTION_NONE)
    {
        if(m_bWinState == YES)
            [self DrawWinLayout:context];
        else
            [self DrawStaticGrid:context];
    }
    else
    {
        [self DrawMotionGrid:context];
    }
}

-(void) DrawArrowAnimation:(CGContextRef)context
{
    CGContextSaveGState(context);
    float fAngle = 0.0;
    CGRect rect = CGRectMake(m_ptArrowPosition.x-m_fBubbleSize*0.5, m_ptArrowPosition.y-m_fBubbleSize*0.5, m_fBubbleSize, m_fBubbleSize);

    if(m_Motion == BUBBLE_MOTION_HORIZONTAL)
    {
        if(m_Direction == MOTION_DIRECTION_FORWARD)
            fAngle = 90.0;
        else if(m_Direction == MOTION_DIRECTION_BACKWARD)
            fAngle = 270.0;
    }
    else if(m_Motion == BUBBLE_MOTION_VERTICAL)
    {
        if(m_Direction == MOTION_DIRECTION_BACKWARD)
            fAngle = 180.0;
    }
    else if(m_Motion == BUBBLE_MOTION_60DIAGONAL)
    {
        if(m_Direction == MOTION_DIRECTION_FORWARD)
            fAngle = 30.0;
        else if(m_Direction == MOTION_DIRECTION_BACKWARD)
            fAngle = 210.0;
    }
    else if(m_Motion == BUBBLE_MOTION_120DIAGONAL)
    {
        if(m_Direction == MOTION_DIRECTION_FORWARD)
            fAngle = 330.0;
        else if(m_Direction == MOTION_DIRECTION_BACKWARD)
            fAngle = 150.0;
    }
    if(fAngle != 0.0)
    {
		CGContextTranslateCTM(context, m_ptArrowPosition.x, m_ptArrowPosition.y);
		CGContextRotateCTM(context, fAngle*M_PI/180.0f);
		CGContextTranslateCTM(context, -m_ptArrowPosition.x, -m_ptArrowPosition.y);
    }

    CGContextSetAlpha(context, 0.3);
    CGContextDrawImage(context, rect, m_ArrowAnimation);
    CGContextRestoreGState(context);
}

-(void) InitializeArrowAnimationHorizontal
{
    CGPoint ptCenter = [self GetBubbleCenter:m_nTouchedCellIndex];
    float fDist = m_fBubbleSize*[GameLayout GetArrowAnimationLimitRatio];
    
    m_ptArrowChange.y = 0;
    m_ptArrowStart.y = ptCenter.y;
    m_ptArrowEnd.y = ptCenter.y;
    if(m_Direction == MOTION_DIRECTION_FORWARD)
    {
        m_ptArrowStart.x = ptCenter.x-fDist;
        m_ptArrowEnd.x = ptCenter.x+fDist;
        m_ptArrowChange.x = fDist*2.0/[GameLayout GetArrowAnimationStep];
    }
    else
    {    
        m_ptArrowStart.x = ptCenter.x+fDist;
        m_ptArrowEnd.x = ptCenter.x-fDist;
        m_ptArrowChange.x = fDist*(-2.0)/[GameLayout GetArrowAnimationStep];
    }
    m_ptArrowPosition.x = m_ptArrowStart.x;        
    m_ptArrowPosition.y = m_ptArrowStart.y;        
}

-(void) InitializeArrowAnimationVertical
{
    CGPoint ptCenter = [self GetBubbleCenter:m_nTouchedCellIndex];
    float fDist = m_fBubbleSize*[GameLayout GetArrowAnimationLimitRatio];
    
    m_ptArrowChange.x = 0;
    m_ptArrowStart.x = ptCenter.x;
    m_ptArrowEnd.x = ptCenter.x;
    if(m_Direction == MOTION_DIRECTION_FORWARD)
    {
        m_ptArrowStart.y = ptCenter.y+fDist;
        m_ptArrowEnd.y = ptCenter.y-fDist;
        m_ptArrowChange.y = fDist*(-2.0)/[GameLayout GetArrowAnimationStep];
    }
    else
    {    
        m_ptArrowStart.y = ptCenter.y-fDist;
        m_ptArrowEnd.y = ptCenter.y+fDist;
        m_ptArrowChange.y = fDist*2.0/[GameLayout GetArrowAnimationStep];
    }
    m_ptArrowPosition.x = m_ptArrowStart.x;        
    m_ptArrowPosition.y = m_ptArrowStart.y;        
}

-(void) InitializeArrowAnimation60Diagonal
{
    CGPoint ptCenter = [self GetBubbleCenter:m_nTouchedCellIndex];
    float fDist = m_fBubbleSize*[GameLayout GetArrowAnimationLimitRatio];
    float fDistX = fDist*0.5;
    float fDistY = fDist*SQURT_3*0.5;
    
    if(m_Direction == MOTION_DIRECTION_FORWARD)
    {
        m_ptArrowStart.x = ptCenter.x-fDistX;
        m_ptArrowEnd.x = ptCenter.x+fDistX;
        m_ptArrowStart.y = ptCenter.y+fDistY;
        m_ptArrowEnd.y = ptCenter.y-fDistY;
        m_ptArrowChange.y = fDistY*(-2.0)/[GameLayout GetArrowAnimationStep];
        m_ptArrowChange.x = fDistX*2.0/[GameLayout GetArrowAnimationStep];
    }
    else
    {    
        m_ptArrowStart.x = ptCenter.x+fDistX;
        m_ptArrowEnd.x = ptCenter.x-fDistX;
        m_ptArrowStart.y = ptCenter.y-fDistY;
        m_ptArrowEnd.y = ptCenter.y+fDistY;
        m_ptArrowChange.y = fDistY*2.0/[GameLayout GetArrowAnimationStep];
        m_ptArrowChange.x = fDistX*(-2.0)/[GameLayout GetArrowAnimationStep];
    }
    m_ptArrowPosition.x = m_ptArrowStart.x;        
    m_ptArrowPosition.y = m_ptArrowStart.y;        
}

-(void) InitializeArrowAnimation120Diagonal
{
    CGPoint ptCenter = [self GetBubbleCenter:m_nTouchedCellIndex];
    float fDist = m_fBubbleSize*[GameLayout GetArrowAnimationLimitRatio];
    float fDistX = fDist*0.5;
    float fDistY = fDist*SQURT_3*0.5;
    
    if(m_Direction == MOTION_DIRECTION_FORWARD)
    {
        m_ptArrowStart.x = ptCenter.x+fDistX;
        m_ptArrowEnd.x = ptCenter.x-fDistX;
        m_ptArrowStart.y = ptCenter.y+fDistY;
        m_ptArrowEnd.y = ptCenter.y-fDistY;
        m_ptArrowChange.y = fDistY*(-2.0)/[GameLayout GetArrowAnimationStep];
        m_ptArrowChange.x = fDistX*(-2.0)/[GameLayout GetArrowAnimationStep];
    }
    else
    {    
        m_ptArrowStart.x = ptCenter.x-fDistX;
        m_ptArrowEnd.x = ptCenter.x+fDistX;
        m_ptArrowStart.y = ptCenter.y-fDistY;
        m_ptArrowEnd.y = ptCenter.y+fDistY;
        m_ptArrowChange.y = fDistY*2.0/[GameLayout GetArrowAnimationStep];
        m_ptArrowChange.x = fDistX*2.0/[GameLayout GetArrowAnimationStep];
    }
    m_ptArrowPosition.x = m_ptArrowStart.x;        
    m_ptArrowPosition.y = m_ptArrowStart.y;        
}


-(void) InitializeArrowAnimation
{
    if(m_Motion == BUBBLE_MOTION_HORIZONTAL)
    {
        [self InitializeArrowAnimationHorizontal];
    }
    else if(m_Motion == BUBBLE_MOTION_VERTICAL)
    {
        [self InitializeArrowAnimationVertical];
    }
    else if(m_Motion == BUBBLE_MOTION_60DIAGONAL)
    {
        [self InitializeArrowAnimation60Diagonal];
    }
    else if(m_Motion == BUBBLE_MOTION_120DIAGONAL)
    {
        [self InitializeArrowAnimation120Diagonal];
    }

}

-(void)UpdateMotionIndictor
{
    m_ptArrowPosition.x += m_ptArrowChange.x;
    m_ptArrowPosition.y += m_ptArrowChange.y;

    float dX = m_ptArrowEnd.x - m_ptArrowStart.x;
    float dY = m_ptArrowEnd.y - m_ptArrowStart.y;
    float dDelta = sqrtf(dX*dX+dY*dY);

    float dX1 = m_ptArrowPosition.x - m_ptArrowStart.x;
    float dY1 = m_ptArrowPosition.y - m_ptArrowStart.y;
    
    float dChange = sqrtf(dX1*dX1 + dY1*dY1);
    if(dDelta <= dChange)
    {
        m_ptArrowPosition.x = m_ptArrowStart.x;
        m_ptArrowPosition.y = m_ptArrowStart.y;
    }
}

-(BOOL) OnTimerEvent
{
    BOOL bRet = NO;
    
    if(m_bNeedReset)
    {
        m_nLEDFlashStep = (m_nLEDFlashStep+1)%10;
        if(m_nLEDFlashStep == 0)
            return YES;
        else
            bRet = YES;
    }
    
    if(m_bEasyAnimation == YES)
    {
        [self OnTimerEventForEasyAnimation];
        return YES;
    }
    
    if(m_Motion != BUBBLE_MOTION_NONE)
    {
        [self UpdateMotionIndictor];
        bRet = YES;
    }

    return bRet;
}

-(void) ShuffleBubble
{
#ifdef __ALG_DEV__
    return;   //For verify index initialization code only
#endif    
    if(m_Bubbles == nil)
        return;

	[m_IndexListForReset removeAllObjects];
    [m_UndoCommandList removeAllObjects];
    int nCount = [m_Bubbles count];
    if(nCount)
    {
        ShuffleSuite* pShuffle = [[[ShuffleSuite alloc] initWithBase:nCount] autorelease];
        for(int i = 0; i < nCount; ++i)
        {
            int n = [pShuffle GetValue:i];
            ((BubbleObject*)[m_Bubbles objectAtIndex:i]).m_nCurrentLocationIndex = n;
            IndexObject* index = [[[IndexObject alloc] InitWithIndex:n] autorelease];
            [m_IndexListForReset addObject:index];
        }
    }
}

-(void) EasyShuffleBubble
{
    enGridType enType = [self GetGridType];
    int nCount = [m_Bubbles count];
    [m_EasySuite Shuffle:enType withBubble:nCount];
    int i;
    for(i = 0; i < [m_EasySuite GetSteps]; ++i)
    {
        CUndoCommand* pStep = [m_EasySuite GetStep:i];
        if(pStep != nil)
        {
            int index = pStep.m_PositionIndex;
            if(0 <= index && index < nCount)
                m_nTouchedCellIndex = ((BubbleObject*)[m_Bubbles objectAtIndex:index]).m_nCurrentLocationIndex;
            else
                m_nTouchedCellIndex = 0;
            m_Motion = pStep.m_Motion;
            if(pStep.m_Direction == MOTION_DIRECTION_FORWARD)
                m_Direction = MOTION_DIRECTION_BACKWARD;
            else
                m_Direction = MOTION_DIRECTION_FORWARD;
            
            [self MoveDestinationBubbles:NO];
        }
    }
    if([self MatchCheck] == YES)
    {    
        [self CleanTouchState];
        [self StartWinAnimation];
        [GUIEventLoop SendEvent:GUIID_EVENT_RESETEASYGAMESHUFFLE eventSender:self];
        return;
    }    
    int n;
    for(int i = 0; i < nCount; ++i)
    {
        n = ((BubbleObject*)[m_Bubbles objectAtIndex:i]).m_nCurrentLocationIndex;
        IndexObject* index = [[[IndexObject alloc] InitWithIndex:n] autorelease];
        [m_IndexListForReset addObject:index];
    }
    m_Motion = BUBBLE_MOTION_NONE;
    m_Direction = MOTION_DIRECTION_NONE;
    m_nTouchedCellIndex = -1;
}

-(void) InitializeGrid:(BOOL)bNeedShuffle withBubble:(enBubbleType)bubbleType
{
    if(m_bEasyAnimation)
    {    
        m_bEasyAnimation = NO;
        [self CleanTouchState];
    }
    
	[m_IndexListForReset removeAllObjects];
    [m_UndoCommandList removeAllObjects];
    [self CalculateBubbleSize];
    [self InitializeGridCells];
    
    switch(m_LayoutType)
    {
        case PUZZLE_LALOUT_MATRIX:
            [self InitializeMatrixLayout:bubbleType];
            break;
        case PUZZLE_LALOUT_SNAKE:       
            [self InitializeSnakeLayout:bubbleType];
            break;
        case PUZZLE_LALOUT_SPIRAL:       
            [self InitializeSpiralLayout:bubbleType];
            break;
    }
    if(bNeedShuffle)
    {
        if([GameConfiguration IsGameDifficulty])
        {    
            [self ShuffleBubble];
            if([self MatchCheck] == YES)
                [self ShuffleBubble];
        }
        else
        {
            [self EasyShuffleBubble];
        }
    }    
}

-(BOOL) MatchCheck
{
    BOOL bRet = YES;
    
    int nCount = [m_Bubbles count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            BubbleObject* pb = [m_Bubbles objectAtIndex:i];
            if(pb)
            {
                if(pb.m_nCurrentLocationIndex != i)
                {
                    bRet = NO;
                    break;
                }
            }
        }
    }
    return bRet;
}

-(void) CheckBubbleState
{
    int nCount = [m_Bubbles count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            BubbleObject* pb = [m_Bubbles objectAtIndex:i];
            if(pb)
            {
                if(pb.m_nCurrentLocationIndex != i)
                {
                    [pb SetQMark:YES];
                }
                else
                {
                    [pb SetQMark:NO];
                }
            }
        }
    }
}

-(void) CleanBubbleCheckState
{
    if(m_bNeedReset)
    {
        int nCount1 = [m_Bubbles count];
        int nCount2 = [m_SnapshotInEasyAnimation count];
        if(nCount1 == nCount2 && 0 < nCount1)
        {
            for(int i = 0; i < nCount1; ++i)
            {
                IndexObject* pIndex = (IndexObject*)[m_SnapshotInEasyAnimation objectAtIndex:i];
                ((BubbleObject*)[m_Bubbles objectAtIndex:i]).m_nCurrentLocationIndex = [pIndex GetIndex];
            }
        }
        [m_SnapshotInEasyAnimation removeAllObjects];
        m_bNeedReset = NO;
        m_nLEDFlashStep = 0;
    }
    
    int nCount = [m_Bubbles count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            BubbleObject* pb = [m_Bubbles objectAtIndex:i];
            if(pb)
            {
                [pb SetQMark:NO];
            }
        }
    }
}


-(BOOL) OnTouchBegin:(CGPoint)pt
{
    BOOL bRet = NO;

    if(m_bWinState == YES)
        return YES;
    
    [self CleanBubbleCheckState];
    
    int k = 0;
    CGRect rect;
    CGPoint ptCenter;
    float fRad = m_fBubbleSize/2.0;
    int nCount = [m_Cells count];
    for (k = 0; k < nCount; ++k) 
    {
        ptCenter = [self GetBubbleCenter:k];
        rect = CGRectMake(ptCenter.x-fRad, ptCenter.y-fRad, m_fBubbleSize, m_fBubbleSize);
        if(CGRectContainsPoint(rect, pt) == true)
        {
            m_fOffset = 0;
            m_ptTouchPoint = pt;
            m_nTouchedCellIndex = k;
            m_nGestureDelay = 0;
            return YES;
        }
    }
    
    return bRet;
}

-(BOOL) OnTouchMove:(CGPoint)pt
{
    BOOL bRet = NO;
 
    if(m_bWinState == YES)
        return YES;
    
    if(0 <= m_nTouchedCellIndex)
    {
        if(m_nGestureDelay < 1)
        {
            ++m_nGestureDelay;
            return YES;
        }
        m_ptTouchPoint = pt;
        [self CalculateCurrentTouchGesture];
        return YES;
    }
    else
    {
        int k = 0;
        CGRect rect;
        CGPoint ptCenter;
        float fRad = m_fBubbleSize/2.0;
        int nCount = [m_Cells count];
        for (k = 0; k < nCount; ++k) 
        {
            ptCenter = [self GetBubbleCenter:k];
            rect = CGRectMake(ptCenter.x-fRad, ptCenter.y-fRad, m_fBubbleSize, m_fBubbleSize);
            if(CGRectContainsPoint(rect, pt) == true)
            {
                m_fOffset = 0;
                m_ptTouchPoint = pt;
                m_nTouchedCellIndex = k;
                return YES;
            }
        }
    }
    return bRet;
}

-(BOOL) OnTouchEnd:(CGPoint)pt
{
    BOOL bRet = NO;
   
    if(m_bWinState == YES)
    { 
/*        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate && [UIDevice networkAvailable] == YES)
        {
            if ([CustomModalAlertView Ask:nil withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory   GetString_PostGameScore]] == ALERT_OK)
            {
                [pGKDelegate PostCurrentGameScoreOnline];
            }
        }*/
        
        [GUIEventLoop SendEvent:GUIID_EVENT_GOTONEXTGAMENOTIFICATION eventSender:self];
        return YES;
    }
    
    if(m_Motion != BUBBLE_MOTION_NONE)
    {
        if([GameLayout GetBubbleMotionThreshold:m_fBubbleSize] <= m_fOffset) 
        {
            [self AddUndoData];
            //[self ShiftBubbles];
            [self MoveDestinationBubbles:YES];
        }    
    }
    [self CleanTouchState];
    if([self MatchCheck] == YES)
    {
        int nStep = [GameConfiguration GetPlaySteps];
        int nType = (int)[GameConfiguration GetGridType];
        int nLayout = (int)[GameConfiguration GetGridLayout];
        int nEdge = [GameConfiguration GetBubbleUnit];
        int nLevel = 0;
        if([GameConfiguration IsGameDifficulty])
            nLevel = 1;
        [GameScore AddScore:nType withLayout:nLayout withEdge:nEdge withScore:nStep withLevel:nLevel withGameType:[self GetGameType]];
        [self StartWinAnimation];
        [GUIEventLoop SendEvent:GUIID_EVENT_GAMEWINNOTIFICATION eventSender:self];
        bRet = YES;
    }
    
    m_nGestureDelay = 0;
    
    return bRet;
}

-(void) StartWinAnimation
{
    m_bWinState = YES;
}

-(void) StopWinAnimation
{
    m_bWinState = NO;
}

-(BOOL) IsWinAnimation
{
    return m_bWinState;
}

-(BOOL)IsEasyAnimation
{
    return m_bEasyAnimation;
}

-(void) StartEasyAnimationStep
{
    int nCount = [m_Bubbles count];
    CUndoCommand* pStep = nil;
    if(m_nPlayHelpType < 0)
    {    
        pStep = [m_EasySuite GetStep:m_nEasyAnimationStep];
        if(pStep != nil)
        {
            int index = pStep.m_PositionIndex;
            if(0 <= index && index < nCount)
            {    
                m_nTouchedCellIndex = ((BubbleObject*)[m_Bubbles objectAtIndex:index]).m_nCurrentLocationIndex;
            }
            else
            {
                m_nTouchedCellIndex = 0;
            }
            m_Motion = pStep.m_Motion;
            m_Direction = pStep.m_Direction;
            [self InitializeArrowAnimation];
        }
    }
    else
    {
        if(0 <= m_nEasyAnimationStep)
        {    
            ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
            BTFilePlayRecord* pRecord = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:m_nPlayHelpType];
            int nIndex = [pRecord.m_PlaySteps count]-1 - m_nEasyAnimationStep;
            NSNumber* pValue = [pRecord.m_PlaySteps objectAtIndex:nIndex];
            int nEncode = [pValue intValue];
            pStep = [[[CUndoCommand alloc] init] autorelease];
            [pStep SetFromEncodeValue:nEncode];
            if(pStep != nil)
            {
                m_nTouchedCellIndex = [self GetRowOrColumnFirstLocationIndex:pStep.m_PositionIndex alongWith:pStep.m_Motion];
                if(m_nTouchedCellIndex < 0 || nCount <= m_nTouchedCellIndex)
                {
                    m_nTouchedCellIndex = 0;
                }
                m_Motion = pStep.m_Motion;
                m_Direction = pStep.m_Direction;
                /*if(m_Direction == MOTION_DIRECTION_FORWARD)
                    m_Direction = MOTION_DIRECTION_BACKWARD;
                else
                    m_Direction = MOTION_DIRECTION_FORWARD;*/
                [self InitializeArrowAnimation];
            }
        }    
    }
}

-(void) HandleEasyAnimationStep
{
    [self ShiftBubbles];
    [self CleanTouchState];
    [self CheckBubbleState];
    --m_nEasyAnimationStep;// = (m_nEasyAnimationStep-1)%[m_EasySuite GetSteps];
    m_fOffset = 0;
    [self StartEasyAnimationStep];
}

-(void) OnTimerEventForEasyAnimation
{
    m_ptArrowPosition.x += m_ptArrowChange.x;
    m_ptArrowPosition.y += m_ptArrowChange.y;
    
    float dX = m_ptArrowEnd.x - m_ptArrowStart.x;
    float dY = m_ptArrowEnd.y - m_ptArrowStart.y;
    float dDelta = sqrtf(dX*dX+dY*dY);
    
    float dX1 = m_ptArrowPosition.x - m_ptArrowStart.x;
    float dY1 = m_ptArrowPosition.y - m_ptArrowStart.y;
    
    float dChange = sqrtf(dX1*dX1 + dY1*dY1);
    m_fOffset += 2*sqrtf(m_ptArrowChange.x*m_ptArrowChange.x + m_ptArrowChange.y*m_ptArrowChange.y)/[GameLayout GetArrowAnimationStep];
    if(dDelta <= dChange)
    {
        if(m_nEasyAnimationStep < 0)
        {
            [self StopEasyAnimation];
        }
        else
        {
            [self HandleEasyAnimationStep];
        }    
    }
}

-(void)StartEasyAnimation:(int)nSelectedType
{
    m_nPlayHelpType = nSelectedType;
    [m_SnapshotInEasyAnimation removeAllObjects];
    int nCount = [m_Bubbles count];
    int n;
    for(int i = 0; i < nCount; ++i)
    {
        n = ((BubbleObject*)[m_Bubbles objectAtIndex:i]).m_nCurrentLocationIndex;
        IndexObject* index = [[[IndexObject alloc] InitWithIndex:n] autorelease];
        [m_SnapshotInEasyAnimation addObject:index];
    }
    int nCount1 = [m_Bubbles count];
    int nCount2 = [m_IndexListForReset count];
    if(nCount1 == nCount2 && 0 < nCount1)
    {
        for(int i = 0; i < nCount1; ++i)
        {
            IndexObject* pIndex = (IndexObject*)[m_IndexListForReset objectAtIndex:i];
            ((BubbleObject*)[m_Bubbles objectAtIndex:i]).m_nCurrentLocationIndex = [pIndex GetIndex];
        }
    }
    [self CleanTouchState];
    [self CheckBubbleState];
    if(m_nPlayHelpType < 0)
    {    
        m_nEasyAnimationStep = [m_EasySuite GetSteps]-1;
    }
    else 
    {
        ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
        BTFilePlayRecord* pRecord = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:m_nPlayHelpType];
        m_nEasyAnimationStep = [pRecord.m_PlaySteps count]-1;
    }
    m_fOffset = 0;
    [self StartEasyAnimationStep];
    m_bEasyAnimation = YES;
    m_bNeedReset = YES;
    m_nLEDFlashStep = 0;
}

-(void)StopEasyAnimation
{
    m_fOffset = 0;
    m_bEasyAnimation = NO;
    [self CleanTouchState];
    /*int nCount1 = [m_Bubbles count];
    int nCount2 = [m_SnapshotInEasyAnimation count];
    if(nCount1 == nCount2 && 0 < nCount1)
    {
        for(int i = 0; i < nCount1; ++i)
        {
            IndexObject* pIndex = (IndexObject*)[m_SnapshotInEasyAnimation objectAtIndex:i];
            ((BubbleObject*)[m_Bubbles objectAtIndex:i]).m_nCurrentLocationIndex = [pIndex GetIndex];
        }
    }
    [m_SnapshotInEasyAnimation removeAllObjects];*/
    [self CheckBubbleState];
}

-(void) AddUndoData
{
    if(m_Motion != BUBBLE_MOTION_NONE && m_Direction != MOTION_DIRECTION_NONE && 0 <= m_nTouchedCellIndex)
    {    
        int nIndex = 0;
        nIndex = [self GetUndoLocationInfo];
        if(nIndex < 0)
            return;
        
        CUndoCommand* pUndo = [[[CUndoCommand alloc] init] autorelease];
        pUndo.m_Motion = m_Motion;
        pUndo.m_Direction = m_Direction;
        pUndo.m_PositionIndex = nIndex;
        [m_UndoCommandList addObject:pUndo];
        
        /*int nEncode = [pUndo GetEncodeValue];
        NSLog(@"Original: encode: %i, index: %i, dir: %i, motion: %i",nEncode, (int)pUndo.m_PositionIndex, (int)pUndo.m_Direction, (int)pUndo.m_Motion);
        
        CUndoCommand* pTemp = [[[CUndoCommand alloc] init] autorelease];
        [pTemp SetFromEncodeValue:nEncode];
        NSLog(@"After: encode: %i, index: %i, dir: %i, motion: %i",nEncode, (int)pTemp.m_PositionIndex, (int)pTemp.m_Direction, (int)pTemp.m_Motion);*/
        
    }    
}

-(void) ShiftBubbles
{
    //[GameConfiguration IncrementPlayStep];
    //[GUIEventLoop SendEvent:GUIID_EVENT_PLAYSTEPCHANGE eventSender:self];
}

-(void) MoveDestinationBubbles:(BOOL)bSendMesg
{
    [self ShiftBubbles];
    if(bSendMesg)
    {    
        [GameConfiguration IncrementPlayStep];
        [GUIEventLoop SendEvent:GUIID_EVENT_PLAYSTEPCHANGE eventSender:self];
    }    
}

-(void) CleanTouchState
{
    m_fOffset = 0;
    m_ptTouchPoint.x = -1;
    m_ptTouchPoint.y = -1;
    m_nTouchedCellIndex = -1;
    m_Motion = BUBBLE_MOTION_NONE;
    m_Direction = MOTION_DIRECTION_NONE;
    m_ptArrowStart.x = 0;
    m_ptArrowStart.y = 0;
    m_ptArrowEnd.x = 0;
    m_ptArrowEnd.y = 0;
    m_ptArrowChange.x = 0;
    m_ptArrowChange.y = 0;
    m_ptArrowPosition.x = 0;
    m_ptArrowPosition.y = 0;
}

-(int) GetBubbleCurrentLocationIndex:(int)nDestIndex
{
    int nRet = -1;
    
    int nCount = [m_Bubbles count];
    if(0 <= nDestIndex && nDestIndex < nCount)
    {
        BubbleObject* pb = [m_Bubbles objectAtIndex:nDestIndex];
        nRet = pb.m_nCurrentLocationIndex;
    }
    
    return nRet;
}

-(int) GetBubbleDestinationIndex:(int)nCurrentLocationIndex
{
    int nRet = -1;
    
    int nCount = [m_Bubbles count];
    if(0 <= nCurrentLocationIndex && nCurrentLocationIndex < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {    
            BubbleObject* pb = [m_Bubbles objectAtIndex:i];
            if(pb.m_nCurrentLocationIndex == nCurrentLocationIndex)
            {
                return i;
            }
        }    
    }
    
    return nRet;
}

-(int) GetBubbleCurrentLocationIndexByLabelValue:(int)nLable
{
    int nRet = -1;
    
    int nCount = [m_Bubbles count];
    for(int i = 0; i < nCount; ++i)
    {    
        BubbleObject* pb = [m_Bubbles objectAtIndex:i];
        if([pb GetLabelValue] == nLable)
        {
            return pb.m_nCurrentLocationIndex;
        }
    }
    
    return nRet;
    
}

-(int) GetBubbleDestinationIndexByLabelValue:(int)nLable
{
    int nRet = -1;
    
    int nCount = [m_Bubbles count];
    for(int i = 0; i < nCount; ++i)
    {    
        BubbleObject* pb = [m_Bubbles objectAtIndex:i];
        if([pb GetLabelValue] == nLable)
        {
            return i;
        }
    }
    
    return nRet;
    
}


-(CGPoint)GetTemplateCenter
{
    float x = m_IconBound.origin.x + m_IconBound.size.width*0.5;
    float y = m_IconBound.origin.y + m_IconBound.size.height*0.5;
    CGPoint pt = CGPointMake(x, y);
    return pt;
}

-(CGPoint)GetGridCenter
{
    CGPoint pt;
    if(m_bIconTemplate)
        pt = [self GetTemplateCenter];
    else
        pt = [GameLayout GetGridCenter];
    
    return pt;
}

-(float)GetGridMaxSize:(float)fMaxSize
{
    float fRet = 0.0;
    if(m_bIconTemplate)
        fRet = fminf(m_IconBound.size.width, m_IconBound.size.height);
    else
        fRet = [GameLayout GetGridMaxSize:fMaxSize];
    return fRet;
}

-(id)CreateAsTemplate:(CGSize)size withLayout:(enGridLayout)enLayout withEdge:(int)nEdge withBubble:(enBubbleType)bubbleType
{
    self = [super init];
    if(self)
    {   
        m_bIconTemplate = YES;
        m_IconBound = CGRectMake(0, 0, size.width, size.height);
        m_Bubbles = [[[NSMutableArray alloc] init] retain];
        m_Cells = [[[NSMutableArray alloc] init] retain];
        [self SetGridLayout:enLayout];
        [self SetBubbleUnit:nEdge];
        [self InitializeGrid:NO withBubble:bubbleType];
    }
    return self;
}

-(void) DrawSampleLayout:(CGContextRef)context withLevel:(BOOL)bEasy
{
    int nCount = [m_Bubbles count];
    if(0 < nCount)
    {
        CGRect rect;
        float fRad = m_fBubbleSize/2.5; ///4.0;
        if([ApplicationConfigure iPhoneDevice])
            fRad = m_fBubbleSize/3.0;
        
        for(int i = 0; i < nCount; ++i)
        {
            int nLabel1 = i+1;
            int index1 = [self GetBubbleDestinationIndexByLabelValue:nLabel1];
            BubbleObject* pb = [m_Bubbles objectAtIndex:index1];
            if(pb)
            {
                CGPoint pt = [self GetBubbleCenter:pb.m_nCurrentLocationIndex];
                if((i+1) < nCount)
                {
                    int nLabel2 = nLabel1+1;
                    int index2 = [self GetBubbleDestinationIndexByLabelValue:nLabel2];
                    BubbleObject* pb2 = [m_Bubbles objectAtIndex:index2];
                    if(pb2)
                    {
                        CGPoint pt2 = [self GetBubbleCenter:pb2.m_nCurrentLocationIndex];
                        CGContextSaveGState(context);
                        CGContextSetLineWidth(context, 3);
                        if(bEasy)
                            CGContextSetRGBStrokeColor(context, 0.2, 1, 0.2, 1);
                        else    
                            CGContextSetRGBStrokeColor(context, 1, 0.2, 0.2, 1);
                     
                        ///
                        CGColorSpaceRef		shadowClrSpace;
                        CGColorRef			shadowClrs;
                        CGSize				shadowSize;
                        shadowClrSpace = CGColorSpaceCreateDeviceRGB();
                        shadowSize = CGSizeMake(5, 5);
                        float clrvals[] = {0.1, 0.1, 0.1, 0.9};
                        shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
                        CGContextSetShadowWithColor(context, shadowSize, 6.0, shadowClrs);
                        ///
                        DrawLine1(context, pt, pt2);
                        CGContextRestoreGState(context);
                     
                        CGColorSpaceRelease(shadowClrSpace);
                        CGColorRelease(shadowClrs);
                       
                    }
                }
                
                if(0 <= pt.x && 0 <= pt.y)
                {
                    rect = CGRectMake(pt.x-fRad, pt.y-fRad, fRad*2.0, fRad*2.0);
                    [pb DrawBubble:context inRect:rect inMotion:NO];
                }
            }
        }
    }
    
}


-(void) DrawPreviewLayout:(CGContextRef)context withLevel:(BOOL)bEasy
{
    int nCount = [m_Bubbles count];
    if(0 < nCount)
    {
        CGRect rect;
        float fRad = m_fBubbleSize/2; 
        for(int i = 0; i < nCount; ++i)
        {
            int nLabel1 = i+1;
            int index1 = [self GetBubbleDestinationIndexByLabelValue:nLabel1];
            BubbleObject* pb = [m_Bubbles objectAtIndex:index1];
            if(pb)
            {
                CGPoint pt = [self GetBubbleCenter:pb.m_nCurrentLocationIndex];
                if(0 <= pt.x && 0 <= pt.y)
                {
                    rect = CGRectMake(pt.x-fRad, pt.y-fRad, m_fBubbleSize, m_fBubbleSize);
                    [pb DrawBubble:context inRect:rect inMotion:NO];
                }
            }
        }
    }
}

-(void) Undo
{
    if([self IsWinAnimation])
        return;
    
    int nCount = [m_UndoCommandList count];
    if(0 < nCount)
    {
        CUndoCommand* pUndo = (CUndoCommand*)[m_UndoCommandList objectAtIndex:nCount-1];
        if(pUndo)
        {
            [self ExceuteUndoCommand:pUndo.m_Motion along:pUndo.m_Direction at:pUndo.m_PositionIndex];
            [m_UndoCommandList removeLastObject];
            [GameConfiguration DecrementPlayStep];
            [GUIEventLoop SendEvent:GUIID_EVENT_PLAYSTEPCHANGE eventSender:self];
        }
    }
}

-(void) Reset
{
    if([self IsWinAnimation])
        return;
    
    int nCount1 = [m_Bubbles count];
    int nCount2 = [m_IndexListForReset count];
    if(nCount1 == nCount2 && 0 < nCount1)
    {
        for(int i = 0; i < nCount1; ++i)
        {
            IndexObject* pIndex = (IndexObject*)[m_IndexListForReset objectAtIndex:i];
            ((BubbleObject*)[m_Bubbles objectAtIndex:i]).m_nCurrentLocationIndex = [pIndex GetIndex];
        }
    }
    [m_UndoCommandList removeAllObjects];
    [GameConfiguration CleanPlaySteps];
    [GUIEventLoop SendEvent:GUIID_EVENT_PLAYSTEPCHANGE eventSender:self];
}

+(id<IPuzzleGrid>)CreateGrid:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withBubble:(enBubbleType)bubbleType
{
    id<IPuzzleGrid> pRet = nil;
    
    switch(enType)
    {
        case PUZZLE_GRID_TRIANDLE:
            pRet = [[TriangleGrid alloc] init];
            break;
        case PUZZLE_GRID_SQUARE:
            pRet = [[SquareGrid alloc] init];
            break;
        case PUZZLE_GRID_DIAMOND:
            pRet = [[DiamondGrid alloc] init];
            break;
        case PUZZLE_GRID_HEXAGON:
            pRet = [[HexagonGrid alloc] init];
            break;
    }
    
    if(pRet != nil)
    {
        [pRet SetGridLayout:enLayout];
        [pRet SetBubbleUnit:nEdge];
        [pRet InitializeGrid:YES withBubble:bubbleType];
    }
    
    return pRet;
}

+(int)GetTriangleGridFirstIndexAtRow:(int)nRow
{
    int nRet = (nRow+1)*nRow/2;
    return nRet;
}

+(int)GetTriangleGridLastIndexAtRow:(int)nRow
{
    int nRet = [CPuzzleGrid GetTriangleGridFirstIndexAtRow:(nRow+1)]-1;
    return nRet;
}

+(void)DrawSampleGrid:(CGContextRef)context withRect:(CGRect)rect withType:(enGridType)enType withSize:(int)nEdge withBubble:(enBubbleType)enBType
{
    switch (enType) 
    {
        case PUZZLE_GRID_TRIANDLE:
            [TriangleGrid DrawSample:context withRect:rect withSize:nEdge withBubble:enBType];
            break;
        case PUZZLE_GRID_SQUARE:
            [SquareGrid DrawSample:context withRect:rect withSize:nEdge withBubble:enBType];
            break;
        case PUZZLE_GRID_DIAMOND:
            [DiamondGrid DrawSample:context withRect:rect withSize:nEdge withBubble:enBType];
            break;
        case PUZZLE_GRID_HEXAGON:
            [HexagonGrid DrawSample:context withRect:rect withSize:nEdge withBubble:enBType];
            break;
    }
}

+(CGImageRef)GetDefaultGridImage:(enGridType)enType withSize:(int)nEdge withBubble:(enBubbleType)enBType
{
    float fSize = [GameLayout GetDefaultIconImageSize];
    CGRect rect = CGRectMake(0, 0, fSize, fSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
	[CPuzzleGrid DrawSampleGrid:bitmapContext withRect:rect withType:enType withSize:nEdge withBubble:enBType];
    CGContextRestoreGState(bitmapContext);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	return retImage;
}

+(void)DrawGridLayout:(CGContextRef)context withSize:(CGSize)size withType:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge  withLevel:(BOOL)bEasy withBubble:(enBubbleType)bubbleType
{
    CPuzzleGrid* pTemp = nil;
    switch (enType) 
    {
        case PUZZLE_GRID_TRIANDLE:
            pTemp = [[[TriangleGrid alloc] CreateAsTemplate:size withLayout:enLayout withEdge:nEdge withBubble:bubbleType] autorelease];
            break;
        case PUZZLE_GRID_SQUARE:
            pTemp = [[[SquareGrid alloc] CreateAsTemplate:size withLayout:enLayout withEdge:nEdge withBubble:bubbleType] autorelease];
            break;
        case PUZZLE_GRID_DIAMOND:
            pTemp = [[[DiamondGrid alloc] CreateAsTemplate:size withLayout:enLayout withEdge:nEdge withBubble:bubbleType] autorelease];
            break;
        case PUZZLE_GRID_HEXAGON:
            pTemp = [[[HexagonGrid alloc] CreateAsTemplate:size withLayout:enLayout withEdge:nEdge withBubble:bubbleType] autorelease];
            break;
    }
    if(pTemp)
    {
        [pTemp DrawSampleLayout:context withLevel:bEasy];
    }
}

+(CGImageRef)GetDefaultLayoutImage:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)bubbleType
{
    float fSize = [GameLayout GetDefaultIconImageSize];
    CGSize size = CGSizeMake(fSize, fSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
	[CPuzzleGrid DrawGridLayout:bitmapContext withSize:size withType:enType withLayout:enLayout withSize:nEdge withLevel:bEasy withBubble:bubbleType];
    CGContextRestoreGState(bitmapContext);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	return retImage;
}


+(void)DrawGridPreview:(CGContextRef)context withSize:(CGSize)size withType:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge  withLevel:(BOOL)bEasy withBubble:(enBubbleType)bubbleType withSetting:(NSArray*)setting
{
    CPuzzleGrid* pTemp = nil;
    switch (enType) 
    {
        case PUZZLE_GRID_TRIANDLE:
            pTemp = [[[TriangleGrid alloc] CreateAsTemplate:size withLayout:enLayout withEdge:nEdge withBubble:bubbleType] autorelease];
            break;
        case PUZZLE_GRID_SQUARE:
            pTemp = [[[SquareGrid alloc] CreateAsTemplate:size withLayout:enLayout withEdge:nEdge withBubble:bubbleType] autorelease];
            break;
        case PUZZLE_GRID_DIAMOND:
            pTemp = [[[DiamondGrid alloc] CreateAsTemplate:size withLayout:enLayout withEdge:nEdge withBubble:bubbleType] autorelease];
            break;
        case PUZZLE_GRID_HEXAGON:
            pTemp = [[[HexagonGrid alloc] CreateAsTemplate:size withLayout:enLayout withEdge:nEdge withBubble:bubbleType] autorelease];
            break;
    }
    if(pTemp)
    {
        [pTemp LoadFromGameSet:setting];
        [pTemp DrawPreviewLayout:context withLevel:bEasy];
    }
}



+(CGImageRef)GetDefaultPreviewImage:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)bubbleType withSetting:(NSArray*)setting
{
    float fSize = [GameLayout GetDefaultPreviewImageSize];
    float fGridSize = fSize*0.99;
    if([ApplicationConfigure iPhoneDevice])
        fGridSize = fSize*0.98;
    
    CGSize size = CGSizeMake(fGridSize, fGridSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
	[CPuzzleGrid DrawGridPreview:bitmapContext withSize:size withType:enType withLayout:enLayout withSize:nEdge withLevel:bEasy withBubble:bubbleType withSetting:setting];
    CGContextRestoreGState(bitmapContext);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	return retImage;
}


+(int)GetDiamonGridBubbleNumber:(int)nEdge
{
    int nRet = nEdge*nEdge;
    return nRet;
}

+(int)GetHexagonGridBubbleNumber:(int)nEdge
{
    int nRet = -1;
    if(0 < nEdge)
    {
        nRet = nEdge*nEdge + nEdge*(nEdge-1) + (nEdge-1)*(nEdge-1);
    }
    return nRet;
}

//
//Game set storage and sharing function
//
//Load game setting
-(void)SaveGameSet:(NSMutableArray*)gameSet
{
    int nCount = [m_IndexListForReset count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            IndexObject* pIndex = (IndexObject*)[m_IndexListForReset objectAtIndex:i];
            NSNumber* pCopyIndex = [[[NSNumber alloc] initWithInt:[pIndex GetIndex]] autorelease];
            [gameSet addObject:pCopyIndex];
        }
    }
}

//Load game setting
-(void)LoadFromGameSet:(NSArray*)gameSet
{
    if(gameSet == nil)
        return;
    
    int nArrayCount = [gameSet count];
    int nBubbleCount = [m_Bubbles count];
    if(nArrayCount != nBubbleCount)
    {
#ifdef DEBUG
        NSLog(@"Something with gameset: gameset #:%i, bubble #%i", nArrayCount, nBubbleCount);
#endif    
        nArrayCount = MIN(nArrayCount, nBubbleCount);
    }
    if(0 < nArrayCount)
    {
        for (int i=0; i < nArrayCount; ++i) 
        {
            NSNumber* pIndex = [gameSet objectAtIndex:i];
            if(pIndex)
            {
                int n = [pIndex intValue];
                ((BubbleObject*)[m_Bubbles objectAtIndex:i]).m_nCurrentLocationIndex = n;
                IndexObject* index = [[[IndexObject alloc] InitWithIndex:n] autorelease];
                [m_IndexListForReset addObject:index];
            }
        }
    }
}


//Load easy level reference solution
-(void)SaveGameEasySolution:(NSMutableArray*)easySolution
{
    if(m_EasySuite && [m_EasySuite IsValid])
    {
        [m_EasySuite SaveGameEasySolution:easySolution];
    }
}

//Load easy level reference solution
-(void)LoadFromGameEasySolution:(NSArray*)easySolution
{
    if(m_EasySuite)
    {
        [m_EasySuite LoadFromGameEasySolution:easySolution];
    }
}

//Load player solution
-(void)SavePlayerSolution:(NSMutableArray*)playerSolution
{
    int nCount = [m_UndoCommandList count];
    for(int i = 0; i < nCount; ++i)
    {
        CUndoCommand* pUndo = (CUndoCommand*)[m_UndoCommandList objectAtIndex:i];
        if(pUndo)
        {
            int nEncode = [pUndo GetEncodeValue];
            NSNumber* pValue = [[[NSNumber alloc] initWithInt:nEncode] autorelease];
            [playerSolution addObject:pValue];
        }
    }
}

//Load undo from play step
-(void)LoadFromPlayerSolution:(NSArray*)playerSolution
{
    int nCount = [playerSolution count];
    for(int i = 0; i < nCount; ++i)
    {
        NSNumber* pValue = [playerSolution objectAtIndex:i];
        int nEncode = [pValue intValue];
        CUndoCommand* pStep = [[[CUndoCommand alloc] init] autorelease];
        [pStep SetFromEncodeValue:nEncode];
        [m_UndoCommandList addObject:pStep];

        
        enMotionDirection  newDirection;
        if(pStep.m_Direction == MOTION_DIRECTION_FORWARD)
            newDirection = MOTION_DIRECTION_BACKWARD;
        else
            newDirection = MOTION_DIRECTION_FORWARD;
        
        [self ExceuteUndoCommand:pStep.m_Motion along:newDirection at:pStep.m_PositionIndex];
        [GUIEventLoop SendEvent:GUIID_EVENT_PLAYSTEPCHANGE eventSender:self];
    }
}

-(BOOL)IsGameComplete
{
    return [self IsWinAnimation];
}

//-1: last one, -2: not followup and start new one
+(id<IPuzzleGrid>)CreateGridFromGameFile:(BTFile*)file isCacheFile:(BOOL)bCacheFile followUpPlay:(int)recordIndex
{
    id<IPuzzleGrid> pRet = nil;
    
    if(file == nil || file.m_FileHeader == nil || file.m_FileHeader.m_GameData == nil || file.m_FileHeader.m_GameData.m_GameSet == nil)
        return pRet;
    
    
    enGridType enType = (enGridType)file.m_FileHeader.m_GameData.m_GridType; 
    enGridLayout enLayout = (enGridLayout)file.m_FileHeader.m_GameData.m_GridLayout; 
    int nEdge = file.m_FileHeader.m_GameData.m_GridEdge;
    switch(enType)
    {
        case PUZZLE_GRID_TRIANDLE:
            pRet = [[TriangleGrid alloc] init];
            break;
        case PUZZLE_GRID_SQUARE:
            pRet = [[SquareGrid alloc] init];
            break;
        case PUZZLE_GRID_DIAMOND:
            pRet = [[DiamondGrid alloc] init];
            break;
        case PUZZLE_GRID_HEXAGON:
            pRet = [[HexagonGrid alloc] init];
            break;
    }
    
    [pRet SetGridLayout:enLayout];
    [pRet SetBubbleUnit:nEdge];
    [GameConfiguration SetGridType:enType];
    [GameConfiguration SetGridLayout:enLayout];
    [GameConfiguration SetBubbleUnit:nEdge];
    [GameConfiguration SetBubbleType:(enBubbleType)file.m_FileHeader.m_GameData.m_Bubble];
    [pRet InitializeGrid:NO withBubble:(enBubbleType)file.m_FileHeader.m_GameData.m_Bubble];
    [pRet LoadFromGameSet:file.m_FileHeader.m_GameData.m_GameSet];
    if(file.m_FileHeader.m_GameData.m_GameLevel == 0 && file.m_FileHeader.m_GameData.m_EasySolution != nil && 0 < [file.m_FileHeader.m_GameData.m_EasySolution count])
    {
        [GameConfiguration SetGameDifficulty:NO];
        [pRet LoadFromGameEasySolution:file.m_FileHeader.m_GameData.m_EasySolution];
    }
    else
    {
        [GameConfiguration SetGameDifficulty:YES];
    }
    int nLoadRecordIndex = recordIndex;
    if(bCacheFile)
        nLoadRecordIndex = -1;
    
    if(nLoadRecordIndex == -2 || file.m_PlayRecordList == nil || [file.m_PlayRecordList count] <= 0 )
    {    
        [GameConfiguration SetPlaySteps:0];
        return pRet;
    }
    if([file.m_PlayRecordList count] <= nLoadRecordIndex || nLoadRecordIndex == -1)
        nLoadRecordIndex = [file.m_PlayRecordList count]-1; 
    BTFilePlayRecord* pRecord = [file.m_PlayRecordList objectAtIndex:nLoadRecordIndex];
    if(pRecord && pRecord.m_PlaySteps && 0 < [pRecord.m_PlaySteps count] && pRecord.m_bCompleted == NO) 
    {
        [GameConfiguration SetPlaySteps:[pRecord.m_PlaySteps count]];
        [pRet LoadFromPlayerSolution:pRecord.m_PlaySteps];
    }
   
#ifdef DEBUG    
    [DebogConsole ShowDebugMsg:@"CreateGridFromGameFile"];
#endif    
    return pRet;
}

-(void)DumpGameSet:(NSMutableDictionary**)dataDict
{
    int nGameType = (int)GAME_BUBBLE_TILE;
    NSNumber* msgGame = [[[NSNumber alloc] initWithInt:nGameType] autorelease]; 
    [(*dataDict) setObject:msgGame forKey:BTF_GAME_GAMETYPE];
    
    enBubbleType enBubble = [GameConfiguration GetBubbleType];
    NSNumber* msgBubble = [[[NSNumber alloc] initWithInt:(int)enBubble] autorelease]; 
    [(*dataDict) setObject:msgBubble forKey:BTF_GAME_BUBBLE];

    enGridType enType = [GameConfiguration GetGridType];
    NSNumber* msgGridType = [[[NSNumber alloc] initWithInt:(int)enType] autorelease]; 
    [(*dataDict) setObject:msgGridType forKey:BTF_GAME_GRIDTYPE];

    enGridLayout enLayout = [GameConfiguration GetGridLayout];
    NSNumber* msgGridLayout = [[[NSNumber alloc] initWithInt:(int)enLayout] autorelease]; 
    [(*dataDict) setObject:msgGridLayout forKey:BTF_GAME_LAYOUTTYPE];
    
    int nEdge = [GameConfiguration GetGridBubbleUnit:enType];
    NSNumber* msgGridEdge = [[[NSNumber alloc] initWithInt:nEdge] autorelease]; 
    [(*dataDict) setObject:msgGridEdge forKey:BTF_GAME_EDGE];

    int nLevel = 0;
    if([GameConfiguration IsGameDifficulty])
        nLevel = 1;
    NSNumber* msgGameLevel = [[[NSNumber alloc] initWithInt:nLevel] autorelease]; 
    [(*dataDict) setObject:msgGameLevel forKey:BTF_GAME_LEVEL];
   
    int nHiddenIndex = -1;
    NSNumber* msgHiddenIndex = [[[NSNumber alloc] initWithInt:nHiddenIndex] autorelease]; 
    [(*dataDict) setObject:msgHiddenIndex forKey:BTF_GAME_HIDDENBUBBLE_INDEX];
    
    NSMutableArray* gameSetArray = [[[NSMutableArray alloc] init] autorelease];
    [self SaveGameSet:gameSetArray];
    [(*dataDict) setObject:gameSetArray forKey:BTF_GAME_GAMESET];

    if(![GameConfiguration IsGameDifficulty] && m_EasySuite && [m_EasySuite IsValid])
    {
        NSMutableArray* playerSolution = [[[NSMutableArray alloc] init] autorelease];
        [self SaveGameEasySolution:playerSolution];
        [(*dataDict) setObject:playerSolution forKey:BTF_GAME_GAMEEASYSOLUTION];
    }
}

-(void)DumpUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index 
{
    NSMutableArray* undoArray = [[[NSMutableArray alloc] init] autorelease];
    [self SavePlayerSolution:undoArray];
    NSString* szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYING_STEPS_PREFIX, index];
    [(*dataDict) setObject:undoArray forKey:szKey];
}


@end
