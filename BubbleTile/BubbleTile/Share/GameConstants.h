//
//  GameConstants.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-06.
//  Copyright 2011 xgadget. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MOTION_DIRCTION_ONE         0       
#define MOTION_MOTION_TWO           1  
#define MOTION_MOTION_THREE         2

//The following constants representing the grid edge unit
#define MIN_BUBBLE_UNIT             3

#define POINT(X)	[[points objectAtIndex:X] locationInView:self]

typedef enum 
{
	GAME_BUBBLE_TILE = 0,       
	GAME_TRADITION_SLIDE       
} enGameType;


typedef enum 
{
	PUZZLE_BUBBLE_COLOR = 0,       
	PUZZLE_BUBBLE_STAR,
	PUZZLE_BUBBLE_FROG,
	PUZZLE_BUBBLE_REDHEART,
	PUZZLE_BUBBLE_BLUE
} enBubbleType;

typedef enum 
{
	PUZZLE_GRID_TRIANDLE = 0,       
	PUZZLE_GRID_SQUARE,
	PUZZLE_GRID_DIAMOND,
	PUZZLE_GRID_HEXAGON
} enGridType;

typedef enum 
{
	PUZZLE_LALOUT_MATRIX = 0,       
	PUZZLE_LALOUT_SNAKE,       
	PUZZLE_LALOUT_SPIRAL       
} enGridLayout;

typedef enum 
{
	BUBBLE_MOTION_NONE = 0,       
	BUBBLE_MOTION_HORIZONTAL,       
	BUBBLE_MOTION_VERTICAL,
	BUBBLE_MOTION_60DIAGONAL,
	BUBBLE_MOTION_120DIAGONAL
} enBubbleMotion;

typedef enum 
{
	MOTION_DIRECTION_NONE = 0,       
	MOTION_DIRECTION_FORWARD,       
	MOTION_DIRECTION_BACKWARD
} enMotionDirection;


@protocol IPuzzleGrid 
-(id)CreateAsTemplate:(CGSize)size withLayout:(enGridLayout)enLayout withEdge:(int)nEdge withBubble:(enBubbleType)bubbleType;    
-(enGridType) GetGridType;
-(enGridLayout) GetGridLayout;
-(enGameType)GetGameType;
-(void) SetGridLayout:(enGridLayout)gLayout;
-(void) SetBubbleUnit: (int)nEdge;
//-(void) InitializeGrid;
-(int) GetBubbleUnit;

-(int) GetBubbleNumberAtRow:(int)nRowIndex;
-(int) GetFirstIndexAtRow:(int)nRowIndex;

-(int) GetGridRow:(int)nIndex;
-(int) GetGridColumne:(int)nIndex;
-(float) GetBubbleDiameter;
-(CGPoint) GetBubbleCenter:(int)nIndex;
-(void) DrawGrid:(CGContextRef)context;
-(void) DrawMotionGrid:(CGContextRef)context;
-(void) DrawStaticGrid:(CGContextRef)context;
-(void) DrawSampleLayout:(CGContextRef)context withLevel:(BOOL)bEasy;
-(void) DrawPreviewLayout:(CGContextRef)context withLevel:(BOOL)bEasy;
-(void) InitializeGrid:(BOOL)bNeedShuffle withBubble:(enBubbleType)bubbleType;
-(void) ShuffleBubble;
-(BOOL) MatchCheck;
-(void) CheckBubbleState;
-(void) CleanBubbleCheckState;
-(void) StartWinAnimation;
-(void) StopWinAnimation;
-(BOOL) IsWinAnimation;
-(BOOL)IsEasyAnimation;
-(void)StartEasyAnimation:(int)nSelectedType;

-(void) CalculateBubbleSize;
-(void) InitializeGridCells;
-(void) InitializeMatrixLayout:(enBubbleType)bubbleType;
-(void) InitializeSnakeLayout:(enBubbleType)bubbleType;
-(void) InitializeSpiralLayout:(enBubbleType)bubbleType;

-(void) UpdateGridLayout;
-(void) Undo;
-(void) Reset;
-(int) GetUndoLocationInfo;
-(void) ExceuteUndoCommand:(enBubbleMotion)enMotion along:(enMotionDirection)enDir at:(int)nIndex;


-(BOOL) OnTouchBegin:(CGPoint)pt;
-(BOOL) OnTouchMove:(CGPoint)pt;
-(BOOL) OnTouchEnd:(CGPoint)pt;
-(void) ShiftBubbles;
-(BOOL) OnTimerEvent;

-(void) CleanTouchState;
-(int) GetBubbleCurrentLocationIndex:(int)nDestIndex;
-(int) GetBubbleDestinationIndex:(int)nCurrentLocationIndex;
-(void)CalculateCurrentTouchGesture;

-(int)GetRowOrColumnFirstLocationIndex:(int)nRowOrColIndex alongWith:(enBubbleMotion)motion;

-(void)Dealloc;

//Test suite for R&D
-(void)TestSuite;


//
//Game set storage and sharing function
//
//Save game setting
-(void)SaveGameSet:(NSMutableArray*)gameSet;
//Save easy level reference solution
-(void)SaveGameEasySolution:(NSMutableArray*)easySolution;
//Save player solution
-(void)SavePlayerSolution:(NSMutableArray*)playerSolution;
//Game completion state
-(BOOL)IsGameComplete;

//Load game setting
-(void)LoadFromGameSet:(NSArray*)gameSet;
//Load easy level reference solution
-(void)LoadFromGameEasySolution:(NSArray*)easySolution;
//Load undo from play step
-(void)LoadFromPlayerSolution:(NSArray*)playerSolution;

-(void)DumpGameSet:(NSMutableDictionary**)dataDict;
-(void)DumpUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index;



@end
