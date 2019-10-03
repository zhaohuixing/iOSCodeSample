//
//  FrameView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FrameView.h"


@implementation FrameView


- (void)CloseButtonClick
{
	[self CloseView:YES];
}	

-(float)GetCloseButtonSize
{
	return 30.0;
}	

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		float size = [self GetCloseButtonSize];
		CGRect rect = CGRectMake(frame.size.width-size, 0, size, size);
		m_CloseButton = [[UIButton alloc] initWithFrame:rect];
		m_CloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_CloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_CloseButton setBackgroundImage:[UIImage imageNamed:@"closeicon.png"] forState:UIControlStateNormal];
		[m_CloseButton setBackgroundImage:[UIImage imageNamed:@"closeiconhi.png"] forState:UIControlStateHighlighted];
		[m_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_CloseButton];
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

-(void)OnViewClose
{
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];
}	

-(void)CloseView:(BOOL)bAnimation
{
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[self setAlpha:0.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewClose)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
		[UIView commitAnimations];
	}	
	else
	{
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
}	

-(void)OpenView:(BOOL)bAnimation
{
	self.hidden = NO;
	[[self superview] bringSubviewToFront:self];
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewOpen)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
		[UIView commitAnimations];
	}
	else 
	{
		[self OnViewOpen];
	}
}

-(void)UpdateViewLayout
{
	CGRect rect = CGRectMake(self.frame.size.width-30, 0, 30, 30);
	[m_CloseButton setFrame:rect];
}	

-(void)ShowHideCloseButton:(BOOL)bShow
{
    m_CloseButton.hidden = !bShow;
}

@end
