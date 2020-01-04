//
//  GameBaseView.m
//  xxxxx
//
//  Created by ZXing on 09/10/2009.
//  Copyright 2009 Zhaohui Xing. All rights reserved.
//
#import "GameBaseView.h"
#import "GUILayout.h"
#include "GameUtility.h"

@implementation GameBaseView


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}


- (void)dealloc 
{
    [super dealloc];
}

/*
- (void)OnOrientationChange:(BOOL)bLandscape
{
	
}*/	

- (void)OnTimerEvent
{
	[self setNeedsDisplay];
}	

- (void)Hide
{
	m_bShow = NO;
	[self setAlpha:0.0f];
}

- (void)Show:(float)fAlpha
{
	m_bShow = YES;
	[self setAlpha:fAlpha];
}	

- (BOOL)IsShow
{
	return m_bShow;
}

- (void)UpdateGameViewLayout
{
	float w = [GUILayout GetContentViewWidth];
	float h = [GUILayout GetContentViewHeight];

	CGRect rt = CGRectMake(0, 0, w, h);
	
	// Create the view
	[self setFrame: rt];
}

- (int)GetViewType
{
	return GAME_VIEW_INVALID;
}	

@end
