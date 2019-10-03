//
//  GameStatusBar.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "GameStatusBar.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#include "drawhelper.h"
#import "DrawHelper2.h"
#import "ApplicationConfigure.h"

@implementation GameStatusBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float fEdgeSize = [GUILayout GetDefaultAlertUIEdge];
        float w = self.frame.size.width - fEdgeSize*2.0;
        float h = self.frame.size.height - fEdgeSize;
        float sx = fEdgeSize;
        float sy = fEdgeSize*0.5;
        CGRect rect =CGRectMake(sx, sy, w, h);
        m_Text = [[UILabel alloc] initWithFrame:rect];
        m_Text.backgroundColor = [UIColor clearColor];
        [m_Text setTextColor:[UIColor yellowColor]];
        float fFontSize = 0.6;
        if([ApplicationConfigure iPADDevice])
            fFontSize = 0.4;
        m_Text.font = [UIFont fontWithName:@"Times New Roman" size:frame.size.height*fFontSize];
        [m_Text setTextAlignment:NSTextAlignmentCenter];
        m_Text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Text.adjustsFontSizeToFitWidth = YES;
        [m_Text setText:@""];
        m_Text.hidden = NO;
        [self addSubview:m_Text];
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
    CGFloat fsize = [GUILayout GetDefaultAlertUIConner]/2.0;
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [DrawHelper2 DrawOptionalAlertBackground:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    CGFloat foffset = [GUILayout GetDefaultAlertUIEdge]/4.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawHalfSizeGrayBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(void)OnViewClose
{
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
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
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
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
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

-(void)SetText:(NSString*)text
{
    [m_Text setText:text];
    if(self.hidden == YES)
        [self OpenView:YES];
}

@end
