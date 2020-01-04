//
//  EqnViewController.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "GameBaseView.h"
#import "Bulletin.h"
#import "EqnViewController.h"
#import "DealController.h"
#import "EquationView.h"
#import "CGameLayout.h"
#import "ResultSet.h"
#include "GameUtility.h"

@implementation EqnViewController

- (void)initViews:(UIView*)ParentView
{
	for(int i = 0; i < 3; ++i)
	{	
		//m_View[i] = [[EquationView alloc] initView:[CGameLayout GetEqnViewRect:i] withRoot:ParentView];
		m_View[i] = [[EquationView alloc] initView:[CGameLayout GetEqnViewRect:i]];
		[ParentView addSubview:m_View[i]];
		[m_View[i] release];
	}	
}

- (id)initController:(UIView*)ParentView  withGame:(DealController*)game
{
    if ((self = [super init])) 
	{
		m_Game = game;	
		m_nCurrentAnswer = 0;
		[self initViews:ParentView];
		m_nAnimationLock = 0;
		m_bGotoNext = NO;
	}
	
	return self;
}	

- (void)dealloc 
{
	for(int i = 0; i < 3; ++i)
	{	
		[m_View[i] release];
	}	
    [super dealloc];
}

- (void)Start
{
	m_nCurrentAnswer = 0;
    if(m_Game != nil && [m_Game IsResultValid] == YES)
	{
		DealResult* answer = [m_Game GetResult:m_nCurrentAnswer];
		if(answer != nil && 0 < [answer GetSize])
		{
			for(int i = 0; i < 3; ++i)
			{
				CardEquation* ceqn = [answer GetEquation:i];
				if(ceqn != nil)
				{
					[m_View[i] SetEquation:ceqn];
					[m_View[i] setNeedsDisplay];
				}	
			}	
		}	
	}	
}

- (void)Reset
{
	for(int i = 0; i < 3; ++i)
	{	
		[m_View[i] Reset];
	}	
}	

- (void)UpdateGameViewLayout
{
	for(int i = 0; i < 3; ++i)
	{	
		[m_View[i] setFrame:[CGameLayout GetEqnViewRect:i]];
		[m_View[i] setNeedsDisplay];
	}	
	//CGRect rect = [self getBulletinRect];
}

- (void)OnTimerEvent
{
	for(int i = 0; i < 3; ++i)
	{	
		[m_View[i] OnTimerEvent];
	}	
}

- (void)OnViewShow1:(id)sender
{
	--m_nAnimationLock;
	[m_View[0] Show:1.0];
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
     [UIView beginAnimations:nil context:context];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationDuration:1.0];
     [UIView setAnimationDelegate:self];
     [UIView setAnimationDidStopSelector:@selector(OnViewShow2:)];
     [m_View[1] setAlpha:1.0];
     if(m_bGotoNext)
         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_View[1] cache:YES];
     else
         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_View[1] cache:YES];
     
     [UIView commitAnimations];
    
}	

- (void)OnViewShow2:(id)sender
{
	--m_nAnimationLock;
	[m_View[1] Show:1.0];

	CGContextRef context = UIGraphicsGetCurrentContext();
	
     [UIView beginAnimations:nil context:context];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationDuration:1.0];
     [UIView setAnimationDelegate:self];
     [UIView setAnimationDidStopSelector:@selector(OnViewShow3:)];
     [m_View[2] setAlpha:1.0];
     if(m_bGotoNext)
         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_View[2] cache:YES];
     else
         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_View[2] cache:YES];
     
     [UIView commitAnimations];
}	

- (void)OnViewShow3:(id)sender
{
	--m_nAnimationLock;
	[m_View[2] Show:1.0];
}	

- (void)MoveIntoResult
{
	m_nAnimationLock = 3;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(OnViewShow1:)];
	[m_View[0] setAlpha:1.0];
    if(m_bGotoNext)
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_View[0] cache:YES];
    else
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_View[0] cache:YES];
        
	[UIView commitAnimations];
}	


- (void)MoveToNextAnswer
{
    if(m_Game != nil && [m_Game IsResultValid] && m_nCurrentAnswer < [m_Game GetResultCount]-1)
	{
		++m_nCurrentAnswer;
		DealResult* answer = [m_Game GetResult:m_nCurrentAnswer];
		if(answer != nil && 0 < [answer GetSize])
		{
			//Reset the equation information to the view
			for(int i = 0; i < 3; ++i)
			{
				CardEquation* ceqn = [answer GetEquation:i];
				if(ceqn != nil)
				{
					[m_View[i] SetEquation:ceqn];
				}	
			}
			//Start the result moving to animation	
			[self MoveIntoResult];
		}	
	}	
}

- (void)MoveToPrevAnswer
{
    if(m_Game != nil && [m_Game IsResultValid] && 0 < m_nCurrentAnswer)
	{
		--m_nCurrentAnswer;
		DealResult* answer = [m_Game GetResult:m_nCurrentAnswer];
		if(answer != nil && 0 < [answer GetSize])
		{
			//Reset the equation information to the view
			for(int i = 0; i < 3; ++i)
			{
				CardEquation* ceqn = [answer GetEquation:i];
				if(ceqn != nil)
				{
					[m_View[i] SetEquation:ceqn];
				}	
			}	
			//Start the result moving to animation	
			[self MoveIntoResult];
		}	
	}	
}

- (void)OnViewHide1:(id)sender
{
	--m_nAnimationLock;
	[m_View[0] Hide];
	if(m_nAnimationLock <= 0)
	{
		if(m_bGotoNext == YES)
		{	
			[self MoveToNextAnswer];
		}
		else 
		{
			[self MoveToPrevAnswer];
		}
	}
	else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [m_View[1] setAlpha:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(OnViewHide2:)];
        if(m_bGotoNext)
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_View[1] cache:YES];
        else
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_View[1] cache:YES];
         
        [UIView commitAnimations];
    }
}	

- (void)OnViewHide2:(id)sender
{
	--m_nAnimationLock;
	[m_View[1] Hide];
	if(m_nAnimationLock <= 0)
	{
		if(m_bGotoNext == YES)
		{	
			[self MoveToNextAnswer];
		}
		else 
		{
			[self MoveToPrevAnswer];
		}
	}
	else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [m_View[2] setAlpha:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(OnViewHide3:)];
        if(m_bGotoNext)
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_View[2] cache:YES];
        else
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_View[2] cache:YES];
         
        [UIView commitAnimations];
    }
}	

- (void)OnViewHide3:(id)sender
{
	--m_nAnimationLock;
	[m_View[2] Hide];
	if(m_nAnimationLock <= 0)
	{
		if(m_bGotoNext == YES)
		{	
			[self MoveToNextAnswer];
		}
		else 
		{
			[self MoveToPrevAnswer];
		}
	}	
}	

//
//Current result moving out animation
//
- (void)MoveOutOldResult
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	m_nAnimationLock = 3; 
	[UIView beginAnimations:nil context:context];
	[m_View[0] setAlpha:0.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(OnViewHide1:)];
    if(m_bGotoNext)
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_View[0] cache:YES];
    else
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_View[0] cache:YES];
        
	[UIView commitAnimations];
}	


//
// Called to move to next result by outside caller 
//
- (void)GoToNextAnswer
{
	if(0 < m_nAnimationLock || m_nCurrentAnswer == [m_Game GetResultCount]-1)
		return;
	
	//Decide to move to the next result;
	m_bGotoNext = YES;

	//Start current result moveing out animation
	[self MoveOutOldResult];
}

//
// Called to move to previous result by outside caller 
//
- (void)GoToPrevAnswer
{
	if(0 < m_nAnimationLock || m_nCurrentAnswer == 0)
		return;

	//Decide to move to the previous result;
	m_bGotoNext = NO;
	
	//Start current result moveing out animation
	[self MoveOutOldResult];
}

- (void)touchesBegan:(NSSet*)touches withEvent: (UIEvent*)event
{
}

- (void)touchesMoved:(NSSet*)touches withEvent: (UIEvent*)event
{
}
	
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}	

@end
