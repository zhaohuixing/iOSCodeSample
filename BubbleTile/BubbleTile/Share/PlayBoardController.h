//
//  PlayBoardController.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-06.
//  Copyright 2011 xgadget. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "BubbleObject.h"

@interface PlayBoardController : NSObject 
{
    id<IPuzzleGrid>         m_Puzzle;
}

-(id) init;
-(void) DrawGame:(CGContextRef)context;
-(void) InitializePuzzle:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withBubble:(enBubbleType)bubbleType;
-(void) InitializePuzzleFromCacheFile;
-(void) UpdatePuzzleLayout;
-(void)UndoGame;
-(void)ResetGame;
-(BOOL)IsWinAnimation;
-(BOOL)IsEasyAnimation;
-(void)StartEasyAnimation:(int)nSelectedType;
-(BOOL)IsGameComplete;
-(void)LoadGameSet:(NSMutableDictionary**)dataDict;
//-(void)LoadUndoList:(NSMutableDictionary**)dataDict withKey:(NSString*)szKey;
- (void)LoadUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index;
-(void)StartNewGameFromOpenFile:(BOOL)bRestart;

-(BOOL) OnTouchBegin:(CGPoint)pt;
-(BOOL) OnTouchMove:(CGPoint)pt;
-(BOOL) OnTouchEnd:(CGPoint)pt;
-(BOOL) OnTimerEvent;
-(void) CheckBubbleState;
-(void) CleanBubbleCheckState;
-(void)TestSuite;

@end
