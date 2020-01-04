//
//  CPuzzleGrid.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-08.
//  Copyright 2011 xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "BubbleObject.h"
#import "GridCell.h"
#import "EasyShuffleSuite.h"
#import "BTFile.h"

#define SQURT_3     1.732050807568877
#define SHIFT_FACTOR0     1.95
#define SHIFT_FACTOR1     4.2
#define SHIFT_FACTOR2     4.4


@interface CPuzzleGrid : NSObject<IPuzzleGrid> 
{
    enGridLayout        m_LayoutType;
    int                 m_nEdge;
    float               m_fBubbleSize;
    
    enBubbleMotion      m_Motion;
    enMotionDirection   m_Direction;
    
	NSMutableArray*		m_Bubbles;
	NSMutableArray*		m_Cells;
    NSMutableArray*     m_IndexListForReset;
    NSMutableArray*     m_UndoCommandList;

    float               m_fOffset;
    CGPoint             m_ptTouchPoint;
    int                 m_nTouchedCellIndex;
    
    //For icon template image
    CGRect              m_IconBound;
    BOOL                m_bIconTemplate;
    
    CGPoint             m_ptArrowStart;
    CGPoint             m_ptArrowEnd;
    CGPoint             m_ptArrowChange;
    CGPoint             m_ptArrowPosition;
    CGImageRef          m_ArrowAnimation;
    CGImageRef          m_StarBall;

    BOOL                m_bWinState;
    
@protected
    EasyShuffleSuite*   m_EasySuite;
    
    BOOL                m_bEasyAnimation;
    BOOL                m_bNeedReset;
    NSMutableArray*     m_SnapshotInEasyAnimation;
    int                 m_nEasyAnimationStep;
    int                 m_nLEDFlashStep;
    
    int                 m_nGestureDelay;
    
    int                 m_nPlayHelpType;
}

-(id)init;
-(enGridLayout) GetGridLayout;
-(enGameType)GetGameType;
-(void) SetGridLayout:(enGridLayout)gLayout;
-(void) SetBubbleUnit: (int)nEdge;
-(int) GetBubbleUnit;
-(void)Dealloc;
-(void) DrawGrid:(CGContextRef)context;
-(void) DrawArrowAnimation:(CGContextRef)context;
-(float) GetBubbleDiameter;
-(CGPoint) GetBubbleCenter:(int)nIndex;
-(void) InitializeGrid:(BOOL)bNeedShuffle withBubble:(enBubbleType)bubbleType;
//-(void) ShuffleBubble;
-(BOOL) MatchCheck;
-(void) CheckBubbleState;
-(void) CleanBubbleCheckState;
-(void) CleanTouchState;
-(int) GetBubbleCurrentLocationIndex:(int)nDestIndex;
-(int) GetBubbleDestinationIndex:(int)nCurrentLocationIndex;
-(int) GetBubbleCurrentLocationIndexByLabelValue:(int)nLable;
-(int) GetBubbleDestinationIndexByLabelValue:(int)nLable;
-(void) Undo;
-(void) Reset;
-(void) ShiftBubbles;
-(BOOL) OnTimerEvent;
-(void) InitializeArrowAnimation;
-(void) AddUndoData;
-(void) UpdateGridLayout;
-(void) MoveDestinationBubbles:(BOOL)bSendMesg;

-(void) StartWinAnimation;
-(void) StopWinAnimation;
-(BOOL) IsWinAnimation;
-(BOOL)IsEasyAnimation;
-(void)StartEasyAnimation:(int)nSelectedType;
-(void)StopEasyAnimation;
-(void) OnTimerEventForEasyAnimation;

-(CGPoint)GetTemplateCenter;
-(CGPoint)GetGridCenter;
-(float)GetGridMaxSize:(float)fMaxSize;
-(id)CreateAsTemplate:(CGSize)size withLayout:(enGridLayout)enLayout withEdge:(int)nEdge withBubble:(enBubbleType)bubbleType;    

-(void) DrawSampleLayout:(CGContextRef)context withLevel:(BOOL)bEasy;
-(void) DrawPreviewLayout:(CGContextRef)context withLevel:(BOOL)bEasy;


+(id<IPuzzleGrid>)CreateGrid:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withBubble:(enBubbleType)bubbleType;
+(id<IPuzzleGrid>)CreateGridFromGameFile:(BTFile*)file isCacheFile:(BOOL)bCacheFile followUpPlay:(int)recordIndex;  //-1: last one, -2: not followup and start new one
+(int)GetTriangleGridFirstIndexAtRow:(int)nRow;
+(int)GetTriangleGridLastIndexAtRow:(int)nRow;

+(int)GetDiamonGridBubbleNumber:(int)nEdge;
+(int)GetHexagonGridBubbleNumber:(int)nEdge;


+(void)DrawSampleGrid:(CGContextRef)context withRect:(CGRect)rect withType:(enGridType)enType withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)enBType;
+(CGImageRef)GetDefaultGridImage:(enGridType)enType withSize:(int)nEdge withBubble:(enBubbleType)enBType;
+(CGImageRef)GetDefaultLayoutImage:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)bubbleType;
+(CGImageRef)GetDefaultPreviewImage:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withLevel:(BOOL)bEasy withBubble:(enBubbleType)bubbleType withSetting:(NSArray*)setting;


//
//Game set storage and sharing function
//
//Load game setting
-(void)SaveGameSet:(NSMutableArray*)gameSet;
//Load easy level reference solution
-(void)SaveGameEasySolution:(NSMutableArray*)easySolution;
//Load player solution
-(void)SavePlayerSolution:(NSMutableArray*)playerSolution;
//Game completion state
-(BOOL)IsGameComplete;

//Load game setting
-(void)LoadFromGameSet:(NSArray*)gameSet;
//Load undo from play step
-(void)LoadFromPlayerSolution:(NSArray*)playerSolution;

-(void)DumpGameSet:(NSMutableDictionary**)dataDict;
-(void)DumpUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index;

@end
