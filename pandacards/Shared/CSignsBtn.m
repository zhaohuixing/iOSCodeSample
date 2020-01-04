//
//  CSignSlider.m
//  MindFire
//
//  Created by Zhaohui Xing on 10-04-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "GameBaseView.h"
#include "GameUtility.h"
#import "CSignsBtn.h"
#import "RenderHelper.h"

@implementation CSignsBtn


- (id)initView:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
    {
        // Initialization code
		m_bHighlight = NO;
		m_nOperation = -1;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
	[RenderHelper DrawSigns:context withSign:m_nOperation witHit:m_bHighlight inRect:rect];
    CGContextRestoreGState(context);
}


- (void)dealloc 
{
    [super dealloc];
}

- (int)GetViewType
{
	return GAME_VIEW_SIGNSLIDER;
}

- (void)OnTimerEvent
{
//	[self setNeedsDisplay];
}

- (void)UpdateGameViewLayout
{
}

- (int)GetOperation
{
	return m_nOperation;	
}

- (void)SetHighlight
{
	m_bHighlight = YES;
	[self setNeedsDisplay];
}

- (void)RemoveHighlight
{
	m_bHighlight = NO;
	[self setNeedsDisplay];
}

- (BOOL)HitBtn:(CGPoint)point
{
	CGRect rect = self.frame;
	CGRect subrect;
	subrect.origin.x = rect.origin.x;
	subrect.origin.y = rect.origin.y;
	subrect.size.width = rect.size.width*0.5;
	subrect.size.height = rect.size.height*0.5;

	if(CGRectContainsPoint(subrect, point) == 1)
	{
		m_nOperation = 0;
		[self setNeedsDisplay];
		return YES;
	}

	subrect.origin.x = rect.origin.x+subrect.size.width;
	subrect.origin.y = rect.origin.y;
	if(CGRectContainsPoint(subrect, point) == 1)
	{
		m_nOperation = 1;
		[self setNeedsDisplay];
		return YES;
	}

	subrect.origin.x = rect.origin.x+subrect.size.width;
	subrect.origin.y = rect.origin.y+subrect.size.height;
	if(CGRectContainsPoint(subrect, point) == 1)
	{
		m_nOperation = 2;
		[self setNeedsDisplay];
		return YES;
	}

	subrect.origin.x = rect.origin.x;
	subrect.origin.y = rect.origin.y+subrect.size.height;
	if(CGRectContainsPoint(subrect, point) == 1)
	{
		m_nOperation = 3;
		[self setNeedsDisplay];
		return YES;
	}
	
	return NO;
}

- (BOOL)IsHighlight
{
	return m_bHighlight;
}	

- (void)Reset
{
	m_bHighlight = NO;
	m_nOperation = -1;
	[self setNeedsDisplay];
}	


@end
