//
//  PlayBoard.m
//  XXXXX
//
//  Created by Zhaohui Xing on 11-05-06.
//  Copyright 2011 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "PlayBoard.h"
#import "ImageLoader.h"
#import "GameConfiguration.h"
#import "BubbleObject.h"
#import "GameScore.h"
#import "GameConstants.h"
#import "ApplicationConfigure.h"
#import "UIDevice-Reachability.h"
#import "StringFactory.h"
#import "CustomModalAlertView.h"
#import "GameConstants.h"
#import "RenderHelper.h"

@implementation PlayBoard


-(void)LoadDefautConfigure
{
    [GameConfiguration SetGameType:[GameScore GetDefaultGame]];
    [GameConfiguration SetGridType:(enGridType)[GameScore GetDefaultType]];
    [GameConfiguration SetGridLayout:(enGridLayout)[GameScore GetDefaultLayout]];
    int nEdge = [GameScore GetDefaultEdge];
    int nMaxEdge = [GameConfiguration GetMaxBubbleUnit:(enGridType)[GameScore GetDefaultType]];
    if(nMaxEdge < nEdge)
        nEdge = nMaxEdge;
   
    [GameConfiguration SetBubbleUnit:nEdge];
    [GameConfiguration SetBubbleType:(enBubbleType)[GameScore GetDefaultBubble]];
    int nLevel = [GameScore GetDefaultLevel];
    if(nLevel)
        [GameConfiguration SetGameDifficulty:NO];
    else
        [GameConfiguration SetGameDifficulty:YES];
    [GameConfiguration RecheckConfigureValidation];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        //[self LoadDefautConfigure];
        self.backgroundColor = [UIColor clearColor];
        m_GameController = [[PlayBoardController alloc] init];
        m_bAnimation = NO;
    }
    return self;
}

-(BOOL)InAnimation
{
    return m_bAnimation;
}

-(BOOL)IsWinAnimation
{
    return [m_GameController IsWinAnimation];
}

-(BOOL)IsEasyAnimation
{
    return [m_GameController IsEasyAnimation];
}

-(void)StartEasyAnimation:(int)nSelectedType
{
    [m_GameController StartEasyAnimation:nSelectedType];
    [self setNeedsDisplay];
}

- (void)drawBoard:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect newRt = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width-6, rect.size.height-6);
    [RenderHelper DrawBoard:context at:newRt];
}

- (void)drawPuzzle:(CGContextRef)context
{
    [m_GameController DrawGame:context];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
    //[self drawBoard:context inRect:rect];
    [self drawPuzzle:context];
	CGContextRestoreGState(context);
    
}


- (void)dealloc
{
    [m_GameController release];
    [super dealloc];
}

-(void)UpdateGameViewLayout
{
    if(m_GameController)
        [m_GameController UpdatePuzzleLayout];
    
    [self setNeedsDisplay];
}

-(void)OnNewGameBegin:(id)sender
{
    m_bAnimation = NO;
    [self setNeedsDisplay];
}

-(void)OnOldGameEnd:(id)sender
{
    enGridType enType = [GameConfiguration GetGridType];
    enGridLayout enLayout = [GameConfiguration GetGridLayout];
    enBubbleType bubbleType = [GameConfiguration GetBubbleType];
    int nEdge = [GameConfiguration GetGridBubbleUnit:enType];
    [m_GameController InitializePuzzle:enType withLayout:enLayout withSize:nEdge withBubble:bubbleType];
    [GameConfiguration CleanDirty];
    [self setNeedsDisplay];
    
    self.hidden = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNewGameBegin:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
    
}

-(void)OnOldGameEndAndOpenNewGameFromCacheData:(id)sender
{
    [m_GameController InitializePuzzleFromCacheFile];
    [GameConfiguration CleanDirty];
    [self setNeedsDisplay];
    
    self.hidden = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNewGameBegin:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
}

-(void)StartNewGame:(BOOL)bLoadCacheData
{
    /*if([ApplicationConfigure GetAdViewsState] == YES && [UIDevice networkAvailable] == NO)
    {
        NSString* str = [StringFactory GetString_NetworkWarn];
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }*/
        
    m_bAnimation = YES;
    self.hidden = YES;

    CGContextRef context = UIGraphicsGetCurrentContext();

    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    if(bLoadCacheData)
        [UIView setAnimationDidStopSelector:@selector(OnOldGameEndAndOpenNewGameFromCacheData:)];
    else    
        [UIView setAnimationDidStopSelector:@selector(OnOldGameEnd:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
}

-(void)UndoGame
{
    [m_GameController UndoGame];
    [self setNeedsDisplay];
}

-(void)ResetGame
{
    [m_GameController ResetGame];
    [self setNeedsDisplay];
}

-(void)OnTomerEvent
{
    if(m_GameController)
    {    
        if([m_GameController OnTimerEvent])
            [self setNeedsDisplay];
    }    
}

- (void) touchesBegan : (NSSet*)touches withEvent: (UIEvent*)event
{
    if([self IsEasyAnimation])
        return;
    
	NSArray *points = [touches allObjects];
	CGPoint pt;
	for(int i = 0; i < points.count; ++i)
	{
		pt = POINT(i);
        if(m_GameController && [m_GameController OnTouchBegin:pt])
        {
            [self setNeedsDisplay];
            return;
        }    
    }    
}	

- (void) touchesMoved: (NSSet*)touches withEvent: (UIEvent*)event
{
    if([self IsEasyAnimation])
        return;
	
    NSArray *points = [touches allObjects];
	CGPoint pt;
	for(int i = 0; i < points.count; ++i)
	{
		pt = POINT(i);
        if(m_GameController && [m_GameController OnTouchMove:pt])
        {
            [self setNeedsDisplay];
            return;
        }    
    }    
}	

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self IsEasyAnimation])
        return;
	
    NSArray *points = [touches allObjects];
	CGPoint pt;
	for(int i = 0; i < points.count; ++i)
	{
		pt = POINT(i);
        if(m_GameController && [m_GameController OnTouchEnd:pt])
        {
            [self setNeedsDisplay];
            return;
        }    
    }    
    [self setNeedsDisplay];
}	

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}	

-(void) CheckBubbleState
{
    if(m_GameController)
    {    
        [m_GameController CheckBubbleState];
        [self setNeedsDisplay];
    }    
}

-(void)CleanBubbleCheckState
{
    if(m_GameController)
    {    
        [m_GameController CleanBubbleCheckState];
        [self setNeedsDisplay];
    }    
}

-(BOOL)IsGameComplete
{
    BOOL bRet = YES;
    if(m_GameController)
        bRet = [m_GameController IsGameComplete];
    return bRet;
}


-(void)LoadGameSet:(NSMutableDictionary**)dataDict
{
    if(m_GameController)
        [m_GameController LoadGameSet:dataDict];
}

//-(void)LoadUndoList:(NSMutableDictionary**)dataDict withKey:(NSString*)szKey
- (void)LoadUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index
{
    if(m_GameController)
        [m_GameController LoadUndoList:dataDict withPrefIndex:index];
}


-(void)OnStartNewGameFromFileInRestart:(id)sender
{
    [m_GameController StartNewGameFromOpenFile:YES];
    [GameConfiguration CleanDirty];
    [self setNeedsDisplay];
    
    self.hidden = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNewGameBegin:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
}

-(void)OnStartNewGameFromFileInContinue:(id)sender
{
    [m_GameController StartNewGameFromOpenFile:NO];
    [GameConfiguration CleanDirty];
    [self setNeedsDisplay];
    
    self.hidden = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNewGameBegin:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
}

-(void)StartNewGameFromOpenFile:(BOOL)bRestart
{
    m_bAnimation = YES;
    self.hidden = YES;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    if(bRestart)
        [UIView setAnimationDidStopSelector:@selector(OnStartNewGameFromFileInRestart:)];
    else    
        [UIView setAnimationDidStopSelector:@selector(OnStartNewGameFromFileInContinue:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];

}

-(void)TestSuite
{
#ifdef __RUN_TESTSUITE__
    if(m_GameController)
        [m_GameController TestSuite];
    [self setNeedsDisplay];
#endif    
}

@end
