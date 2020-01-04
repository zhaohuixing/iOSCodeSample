//
//  GameStatusBar.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "GameStatusBar.h"
#import "GUILayout.h"
#import "CGameLayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#include "drawhelper.h"
#import "DrawHelper2.h"
#import "RenderHelper.h"
#import "ApplicationConfigure.h"
#include "GameUtility.h"

@implementation GameStatusBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_bWin = NO;
        m_nAnimationFrame = 0;
        m_timerCount = 0.0;
        m_timerStartShow = 0.0;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawBackground:(CGContextRef)context inRect:(CGRect)rect;
{
    CGContextSaveGState(context);
    float fsize = [GUILayout GetDefaultAlertUIConner];///2.0;
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    if(m_bWin)
    {
        [DrawHelper2 DrawRedTextureRect:context at:rect];
    }
    else 
    {    
        [DrawHelper2 DrawOptionalAlertBackground:context at:rect];
    }    
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/2.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawGrayFrameViewBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

-(void)drawRopaAnimation:(CGContextRef)context inRect:(CGRect)rect
{
    int index = m_nAnimationFrame;
    if(3 <= index)
        index = 1;
    
    float fEdge = [GUILayout GetDefaultAlertUIEdge];
    float fUnitSize = [CGameLayout GetStatusBarAnimatorSize];
    float sx = rect.origin.x + 3.0*fEdge;
    float sy = rect.origin.y + 3.0*fEdge;
    CGRect rt;
    float sxi;
    for(int i = 0; i < 4; ++i)
    {    
        sxi = sx + (fUnitSize+fEdge*2.0)*i;
        rt = CGRectMake(sxi, sy, fUnitSize, fUnitSize);
        if(m_bWin)
        {
            [RenderHelper DrawAvatarResult:context withRect:rt withIndex:((index+i)%3) withResult:YES withFlag:YES];
        }
        else 
        {
            [RenderHelper DrawAvatarResult:context withRect:rt withIndex:((index+i)%3) withResult:NO withFlag:NO];
        }
    }    
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
    [self drawRopaAnimation:context inRect: rect];
}

-(void)OnViewClose
{
	[[self superview] sendSubviewToBack:self];
}

-(void)CloseView:(BOOL)bAnimation
{
	if(bAnimation)
	{
        self.hidden = YES;
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(OnViewClose)];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
        [UIView commitAnimations];
	}	
	else
	{
        self.hidden = YES;
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
    m_timerCount = [[NSProcessInfo processInfo] systemUptime];
    m_timerStartShow = m_timerCount;
    m_nAnimationFrame = 0;
    [self setNeedsDisplay];
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
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
		[UIView commitAnimations];
	}
	else 
	{
		[self OnViewOpen];
	}
}

-(void)UpdateViewLayout
{
    [self setNeedsDisplay];
}

-(void)OnTimerEvent
{
    if(self.hidden == NO)
    {
        NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(AVATAR_SHOW_TIMEINTERNVAL <= currentTime - m_timerStartShow)
        {
            [self CloseView:YES];
            return;
        }
        if(AVATAR_ANIMATION_TIMEINTERNVAL <= (currentTime - m_timerCount))
        {   
            m_timerCount = currentTime;
            m_nAnimationFrame = (1+m_nAnimationFrame)%4;
            [self setNeedsDisplay];
        }    
    }
}

-(void)SetWinState:(BOOL)bWin
{
    m_bWin = bWin;
    [self setNeedsDisplay];
    if(self.hidden == YES)
        [self OpenView:YES];
}


@end
