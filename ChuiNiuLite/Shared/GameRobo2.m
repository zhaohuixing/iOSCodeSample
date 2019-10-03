//
//  GameRobo2.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameRobo2.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "StringFactory.h"
#include "drawhelper.h"
//#include "GameUtil.h"


@implementation GameRobo2

-(void)ClearScore
{
    m_nBest = 0;
    m_nGood = 0;
    m_nBad = 0;
    m_nWorst = 0;
    
    m_nYang = 0;
    m_nYing = 0;
}

-(id)initWithAchorPoint:(CGPoint)pt
{
    self = [super initWithAchorPoint:pt];
    if(self)
    {
        CGRect rect = CGRectMake(0, 0, [GUILayout GetMsgBoardViewWidth], [GUILayout GetMsgBoardViewHeight]);
        m_ScoreBoard = [[RoboListBoard alloc] initWithFrame:rect];
        [m_ScoreBoard SetAchorAtBottom:0.5];
		[self addSubview:m_ScoreBoard];
		[m_ScoreBoard release];
        m_ScoreBoard.hidden = YES;
        [self ClearScore];
    }
    return self;
}

-(void)OnScoreBoardClose:(id)sender
{
    [self UpdateViewLayout];
}

-(void)CloseScoreBoard
{
    m_nNameTipShowCount = 0;
    m_ScoreBoard.hidden = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnScoreBoardClose:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_ScoreBoard cache:YES];
    [UIView commitAnimations];
}

-(void)OnTimeEvent
{
    [m_Avatar OnTimeEvent];
    if(m_ScoreBoard.hidden == NO)
    {
        ++m_nNameTipShowCount;
        if(GAME_AVATAR_LABEL_TIMING*4 < m_nNameTipShowCount)
        {
            [self CloseScoreBoard];
        }
    }
}

-(void)AssignID:(NSString*)playerID withName:(NSString*)playerName
{
    [self ClearScore];
    [m_ScoreBoard SetTitle:playerName];
    [super AssignID:playerID withName:playerName];
}

-(void)UpdateViewLayout
{
    if(m_MsgBoard.hidden == NO || m_ScoreBoard.hidden == NO)
        [self UpdateLargeViewLayout];
    else
        [self UpdateSmallViewLayout];
}

-(void)OnScoreBoardOpen:(id)sender
{
    [self UpdateViewLayout];
}

-(void)UpdateLuckyScoreBoard
{
/*    [m_ScoreBoard EnableCell1:YES];
    [m_ScoreBoard EnableCell2:YES];
    [m_ScoreBoard EnableCell3:YES];
    [m_ScoreBoard EnableCell4:YES];
    
    [m_ScoreBoard SetCell1:[StringFactory GetString_Best] withText:[NSString stringWithFormat:@"%i", m_nBest]];
    [m_ScoreBoard SetCell2:[StringFactory GetString_Good] withText:[NSString stringWithFormat:@"%i", m_nGood]];
    [m_ScoreBoard SetCell3:[StringFactory GetString_Bad] withText:[NSString stringWithFormat:@"%i", m_nBad]];
    [m_ScoreBoard SetCell4:[StringFactory GetString_Worst] withText:[NSString stringWithFormat:@"%i", m_nWorst]];*/
}

-(void)UpdateTaiJiScoreBoard
{
/*    [m_ScoreBoard EnableCell1:YES];
    [m_ScoreBoard EnableCell2:YES];
    [m_ScoreBoard EnableCell3:NO];
    [m_ScoreBoard EnableCell4:NO];
    
    [m_ScoreBoard SetCell1:[StringFactory GetString_Yang:NO] withText:[NSString stringWithFormat:@"%i", m_nYang]];
    [m_ScoreBoard SetCell2:[StringFactory GetString_Yin:NO] withText:[NSString stringWithFormat:@"%i", m_nYing]];*/
}

-(void)UpdateScoreBoard
{
/*	if(IsLucky() == 1)
	{
        [self UpdateLuckyScoreBoard];
	}
	else if(IsTaiJi() == 1)
	{
        [self UpdateTaiJiScoreBoard];
	}	*/
}

-(void)OpenScoreBoard
{
    [self UpdateScoreBoard];
    if(m_MsgBoard.hidden == NO)
        [self ShowMessageBoard:NO];
    
    m_nNameTipShowCount = 0;
    [self UpdateLargeViewLayout];
    m_ScoreBoard.hidden = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnScoreBoardOpen:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_ScoreBoard cache:YES];
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self IsActive] == NO)
        return;
    if(m_ScoreBoard.hidden == NO)
        return;
    
    [self OpenScoreBoard];
}	

-(void)SetMessage:(NSString*)message
{
    if(m_ScoreBoard.hidden == NO)
    {
        [self CloseScoreBoard];
    }
    [super SetMessage:message];
}

-(void)UpdateScore
{
/*	int nIndex = GetResultScopeIndex();
	if(IsLucky() == 1)
	{	
		switch (nIndex)
		{
			case 0:
				++m_nGood;
				break;
			case 1:
				++m_nBest;
				break;
			case 2:
				++m_nBad;
				break;
			case 3:	
			default:
				++m_nWorst;
				break;
		}
	}
	else if(IsTaiJi() == 1)
	{
		switch (nIndex)
		{
			case 0:
				++m_nYang;
				break;
			case 1:
			default:
				++m_nYing;
				break;
		}		
	}
	[self UpdateScoreBoard];*/
}

-(void)SetBestScore:(int)nBest
{
    m_nBest = nBest;
}

-(void)SetGoodScore:(int)nGood
{
    m_nGood = nGood;
}

-(void)SetBadScore:(int)nBad
{
    m_nBad = nBad;
}

-(void)SetWorstScore:(int)nWorst
{
    m_nWorst = nWorst;
}

-(void)SetYangScore:(int)nYang
{
    m_nYang = nYang;
}

-(void)SetYingScore:(int)nYing
{
    m_nYing = nYing;
}

-(int)GetBestScore
{
    return m_nBest;
}

-(int)GetGoodScore
{
    return m_nGood;
}

-(int)GetBadScore
{
    return m_nBad;
}

-(int)GetWorstScore
{
    return m_nWorst;
}

-(int)GetYangScore
{
    return m_nYang;
}

-(int)GetYingScore
{
    return m_nYing;
}


@end
