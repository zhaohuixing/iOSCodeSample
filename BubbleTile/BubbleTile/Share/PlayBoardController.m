//
//  PlayBoardController.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-06.
//  Copyright 2011 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "PlayBoardController.h"
#import "CPuzzleGrid.h"
#import "GameLayout.h"
#import "GameConfiguration.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"
#import "ApplicationController.h"
#import "GameConfiguration.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"

@implementation PlayBoardController

-(id) init
{
    if((self = [super init]))
    {
        m_Puzzle = nil; 
        
        enGridType enType = [GameConfiguration GetGridType];
        enGridLayout enLayout = [GameConfiguration GetGridLayout];
        int nEdge = [GameConfiguration GetGridBubbleUnit:enType];
        enBubbleType bubbleType = [GameConfiguration GetBubbleType];
        m_Puzzle = [CPuzzleGrid CreateGrid:enType withLayout:enLayout withSize:nEdge withBubble:bubbleType];
    }
    return self;
}

- (void)dealloc
{
    if(m_Puzzle != nil)
        [m_Puzzle Dealloc];
    
    [super dealloc];
}

-(void) DrawGame:(CGContextRef)context
{
    if(m_Puzzle != nil)
        [m_Puzzle DrawGrid:context];
}

-(void) InitializePuzzle:(enGridType)enType withLayout:(enGridLayout)enLayout withSize:(int)nEdge withBubble:(enBubbleType)bubbleType
{
    if(m_Puzzle != nil)
        [m_Puzzle Dealloc];
    
    m_Puzzle = [CPuzzleGrid CreateGrid:enType withLayout:enLayout withSize:nEdge withBubble:bubbleType];
}

-(void) InitializePuzzleFromCacheFile
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pController && 
       [pController GetFileManager] && 
       [pController GetFileManager].m_PlayingFile &&
       [[pController GetFileManager].m_PlayingFile IsValid]/* &&
       [[pController GetFileManager].m_PlayingFile CurrentDocumentIsCacheFile]*/)
    {
        if(m_Puzzle != nil)
            [m_Puzzle Dealloc];
        m_Puzzle = [CPuzzleGrid CreateGridFromGameFile:[pController GetFileManager].m_PlayingFile isCacheFile:YES followUpPlay:-1];
    }
    else
    {    
        enGridType enType = [GameConfiguration GetGridType];
        enGridLayout enLayout = [GameConfiguration GetGridLayout];
        enBubbleType bubbleType = [GameConfiguration GetBubbleType];
        int nEdge = [GameConfiguration GetGridBubbleUnit:enType];
        [self InitializePuzzle:enType withLayout:enLayout withSize:nEdge withBubble:bubbleType];
    }    
    [GUIEventLoop SendEvent:GUIID_EVENT_CONFIGURECHANGE eventSender:self];
}

-(void)UndoGame
{
    if(m_Puzzle != nil)
        [m_Puzzle Undo];
}

-(void)ResetGame
{
    if(m_Puzzle != nil)
    {    
        [m_Puzzle Reset];
    }    
}

-(BOOL)IsWinAnimation
{
    BOOL bRet = NO;
    if(m_Puzzle != nil)
    {    
        bRet = [m_Puzzle IsWinAnimation];
    }    
    return bRet;
}

-(BOOL)IsEasyAnimation
{
    BOOL bRet = NO;
    if(m_Puzzle != nil)
    {    
        bRet = [m_Puzzle IsEasyAnimation];
    }    
    return bRet;
}

-(void)StartEasyAnimation:(int)nSelectedType
{
    if(m_Puzzle != nil)
    {    
        [m_Puzzle StartEasyAnimation:nSelectedType];
    }    
}

-(void)UpdatePuzzleLayout
{
    if(m_Puzzle != nil)
        [m_Puzzle UpdateGridLayout];
}

-(BOOL) OnTimerEvent
{
    BOOL bRet = NO;
    if(m_Puzzle != nil)
        bRet = [m_Puzzle OnTimerEvent];
    return bRet;
}

-(BOOL) OnTouchBegin:(CGPoint)pt
{
    BOOL bRet = NO;
    
    float fSize = [GameLayout GetPlayBoardSize];
    if(pt.x <= 0 || fSize <= pt.x || pt.y <= 0 || fSize <= pt.y || m_Puzzle == nil)
        return bRet;
        
    bRet = [m_Puzzle OnTouchBegin:pt];
    
    return bRet;
}

-(BOOL) OnTouchMove:(CGPoint)pt
{
    BOOL bRet = NO;

    float fSize = [GameLayout GetPlayBoardSize];
    if(pt.x <= 0 || fSize <= pt.x || pt.y <= 0 || fSize <= pt.y || m_Puzzle == nil)
        return bRet;

    bRet = [m_Puzzle OnTouchMove:pt];
    
    return bRet;
}

-(BOOL) OnTouchEnd:(CGPoint)pt
{
    BOOL bRet = NO;
    
    //float fSize = [GameLayout GetPlayBoardSize];
    //if(pt.x <= 0 || fSize <= pt.x || pt.y <= 0 || fSize <= pt.y || m_Puzzle == nil)
    if(m_Puzzle == nil)
        return bRet;
  
    bRet = [m_Puzzle OnTouchEnd:pt];
    
    return bRet;
}

-(void) CheckBubbleState
{
    if(m_Puzzle)
        [m_Puzzle CheckBubbleState];
}

-(void) CleanBubbleCheckState
{
    if(m_Puzzle)
        [m_Puzzle CleanBubbleCheckState];
}

-(BOOL)IsGameComplete
{
    BOOL bRet = YES;
    if(m_Puzzle)
        bRet = [m_Puzzle IsGameComplete];
    
    return bRet;
}

-(void)LoadGameSet:(NSMutableDictionary**)dataDict
{
    if(m_Puzzle)
        [m_Puzzle DumpGameSet:dataDict];
}

//-(void)LoadUndoList:(NSMutableDictionary**)dataDict withKey:(NSString*)szKey
- (void)LoadUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index
{
    if(m_Puzzle)
        [m_Puzzle DumpUndoList:dataDict withPrefIndex:index];
}

-(void)StartNewGameFromOpenFile:(BOOL)bRestart
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pController && 
       [pController GetFileManager] && 
       [pController GetFileManager].m_PlayingFile &&
       [[pController GetFileManager].m_PlayingFile IsValid])
    {
        if(m_Puzzle != nil)
            [m_Puzzle Dealloc];
        int nIndex = -1;
        if(bRestart)
            nIndex = -2;
        m_Puzzle = [CPuzzleGrid CreateGridFromGameFile:[pController GetFileManager].m_PlayingFile isCacheFile:NO followUpPlay:nIndex];
    }
    else 
    {
        enGridType enType = [GameConfiguration GetGridType];
        enGridLayout enLayout = [GameConfiguration GetGridLayout];
        enBubbleType bubbleType = [GameConfiguration GetBubbleType];
        int nEdge = [GameConfiguration GetGridBubbleUnit:enType];
        [self InitializePuzzle:enType withLayout:enLayout withSize:nEdge withBubble:bubbleType];
    }    
    [GUIEventLoop SendEvent:GUIID_EVENT_CONFIGURECHANGE eventSender:self];
}

-(void)TestSuite
{
#ifdef __RUN_TESTSUITE__
    if(m_Puzzle)
        [m_Puzzle TestSuite];
#endif    
}

@end
