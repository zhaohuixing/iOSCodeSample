//
//  SquareGrid.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-07.
//  Copyright 2011 xgadget. All rights reserved.
//
#import "CPuzzleGrid.h"

@interface SquareGrid : CPuzzleGrid 
{
}

-(id)init;
-(int) GetGridRow:(int)nIndex;
-(int) GetGridColumne:(int)nIndex;
-(void) CalculateBubbleSize;
-(void) InitializeGridCells;
-(void) InitializeMatrixLayout:(enBubbleType)bubbleType;
-(void) InitializeSnakeLayout:(enBubbleType)bubbleType;
-(void) InitializeSpiralLayout:(enBubbleType)bubbleType;

-(void) ShiftBubbles;
-(int) GetUndoLocationInfo;
-(void) ExceuteUndoCommand:(enBubbleMotion)enMotion along:(enMotionDirection)enDir at:(int)nIndex;

-(int)GetRowOrColumnFirstLocationIndex:(int)nRowOrColIndex alongWith:(enBubbleMotion)motion;

+(void) DrawSample:(CGContextRef)context withRect:(CGRect)rect withSize:(int)nEdge withBubble:(enBubbleType)enBType;

@end
