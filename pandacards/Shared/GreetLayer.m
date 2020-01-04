//
//  GreetLayer.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-27.
//  Copyright 2010 xgadget. All rights reserved.
//
#import "GreetLayer.h"
#import "CGameLayout.h"
#import "StringFactory.h"
#include "GameUtility.h"


@implementation GreetLayer


- (id)initView:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		m_nAnimationStep = 0;
		m_nTimeSlowPace = 0;
		m_bWin = NO;
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
		m_GreetText = [[UILabel alloc] initWithFrame:rect];
		m_GreetText.backgroundColor = [UIColor clearColor];
		[m_GreetText setTextColor:[UIColor redColor]];
        [m_GreetText setTextAlignment:UITextAlignmentCenter];
        m_GreetText.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        m_GreetText.adjustsFontSizeToFitWidth = YES;
		m_GreetText.font = [UIFont fontWithName:@"Times New Roman" size:72];//[UIFont systemFontOfSize:18];//[UIFont fontWithName:@"Georgia" size:18];
		[m_GreetText setText:@""];
		[self addSubview:m_GreetText];
		[m_GreetText release];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)OnTimerEvent
{
	if(m_bShow == NO)
		return;
	
	m_nTimeSlowPace = (m_nTimeSlowPace+1)%4;
	if(m_nTimeSlowPace != 0)
		return;
	
	m_nAnimationStep = (m_nAnimationStep+1)%2;
	[self setNeedsDisplay];
	
}

- (int)GetViewType
{
	return GAME_VIEW_GREETTING;
}

- (void)UpdateGameViewLayout
{
	if(m_bShow == NO)
		return;

	CGRect rect = [CGameLayout GetGreetViewRect];
	[self setFrame:rect];
	[self setNeedsDisplay];
}

- (void)Hide
{
	[super Hide];
	//CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
	//[self setFrame:rect];
    self.hidden = YES;
}

- (void)Show
{
	m_bShow = YES;
	self.hidden = NO;
	CGRect rect = [CGameLayout GetGreetViewRect];
	[self setFrame:rect];
	[self setAlpha:1.0];
	m_nAnimationStep = 0;
	m_nTimeSlowPace = 0;
	[self setNeedsDisplay];
}	

- (void)SetWinGreet
{
	m_nAnimationStep = 0;
	m_nTimeSlowPace = 0;
	m_bWin = YES;
	[m_GreetText setText:[StringFactory GetString_YouWin]];
	[m_GreetText setTextColor:[UIColor redColor]];
    [m_GreetText setNeedsDisplay];
}

- (void)SetLoseGreet
{
	m_nAnimationStep = 0;
	m_nTimeSlowPace = 0;
	m_bWin = NO;
    
	[m_GreetText setText:[StringFactory GetString_YouLose]];
	[m_GreetText setTextColor:[UIColor blackColor]];
    [m_GreetText setNeedsDisplay];
}	

@end
