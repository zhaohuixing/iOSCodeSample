//
//  ResultView.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-19.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "GameBaseView.h"
#import "DealController.h"
#import "EqnViewController.h"
#import "ResultView.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "Bulletin.h"
#import "GUILayout.h"
#import "CGameLayout.h"

#include "GameUtility.h"
#include "GameState.h"

@implementation ResultView

- (int)GetViewType
{
	return GAME_VIEW_RESULTVIEW;
}	

- (void)CloseButtonClick
{
    [self EndResult];
    [self CloseView:YES];
}	

- (void)PrevButtonClick
{
    [self GotoPrev];
}

- (void)NextButtonClick
{
    [self GotoNext];
}

- (id)initView:(CGRect)frame  withGame:(DealController*)game 
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
 		m_ResultController = [[EqnViewController alloc] initController:self withGame:game];

		[self setBackgroundColor:[UIColor clearColor]];
        float fMargin = [GUILayout GetDefaultAlertUIEdge];

		CGRect rect = [CGameLayout GetDealCountAreaRect];
        float fHeight = rect.size.height;
        float fWidth = rect.size.width;
        rect = CGRectMake(fMargin, fMargin, fWidth, fHeight);
		m_Bulletin = [[Bulletin alloc] initWithFrame2:rect];
		[m_Bulletin setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_Bulletin];
		[m_Bulletin release];			  
        
        float fSize = [GUILayout GetTitleBarHeight];
        
        // Initialization code.
		rect = CGRectMake(fWidth+2+fMargin, fMargin, fSize, fSize);
		m_PrevButton = [[UIButton alloc] initWithFrame:rect];
		m_PrevButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_PrevButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_PrevButton setBackgroundImage:[UIImage imageNamed:@"previcon.png"] forState:UIControlStateNormal];
		[m_PrevButton setBackgroundImage:[UIImage imageNamed:@"previconhi.png"] forState:UIControlStateHighlighted];
		[m_PrevButton addTarget:self action:@selector(PrevButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_PrevButton];

		rect = CGRectMake(fWidth+2+(fSize+2)+fMargin, fMargin, fSize, fSize);
		m_NextButton = [[UIButton alloc] initWithFrame:rect];
		m_NextButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_NextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticon.png"] forState:UIControlStateNormal];
		[m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticonhi.png"] forState:UIControlStateHighlighted];
		[m_NextButton addTarget:self action:@selector(NextButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_NextButton];
    
        
		//[self setNeedsDisplay];
    }
    return self;
}

- (void)StartResult:(int)nPoint withScore:(int)nScore
{
    [m_Bulletin AddNonWinPoint:nPoint];
    [m_Bulletin AddWinPoint:nScore];
	[m_ResultController Start];
}

- (void)EndResult
{
	[m_ResultController Reset];
}

- (void)GotoNext
{
	[m_ResultController GoToNextAnswer];
}

- (void)GotoPrev
{
	[m_ResultController GoToPrevAnswer];
}	


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    [super drawBackground:context inRect:rect];	
    //[self drawBackground:context  inRect:rect];	
	
/*	CGContextRef layerDC;
	CGLayerRef   layerObj;
	layerObj = CGLayerCreateWithContext(context, rect.size, NULL);
	layerDC = CGLayerGetContext(layerObj);
	
	CGContextSaveGState(layerDC);
	
	
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGFloat colors[] =
	{
		0.0, 0.0, 1.0, 1.00,
		0.8, 0.8, 0.8, 1.00,
	};
	
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	
	CGPoint pt1, pt2;
	pt1.x = rect.origin.x;
	pt1.y = rect.origin.y;
	pt2.x = rect.origin.x+rect.size.width;
	pt2.y = rect.origin.y+rect.size.height;
	CGContextDrawLinearGradient (layerDC, gradientFill, pt1, pt2, 0);
	
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	CGContextRestoreGState(layerDC);
	CGContextSaveGState(context);
	CGContextDrawLayerAtPoint(context, CGPointMake(0.0f, 0.0f), layerObj);
	CGContextRestoreGState(context);
	CGLayerRelease(layerObj);*/
	
}

- (void)OnTimerEvent
{
	[m_ResultController OnTimerEvent];
	[self setNeedsDisplay];
}	

- (void)dealloc 
{
	[m_ResultController release];
    [super dealloc];
}

- (void)UpdateGameViewLayout
{
	[m_ResultController UpdateGameViewLayout];
	//[super UpdateViewLayout];
	CGRect rect = CGRectMake(self.frame.size.width-30, 0, 30, 30);
	[m_CloseButton setFrame:rect];
}

- (void)UpdateViewLayout
{
	[m_ResultController UpdateGameViewLayout];
	//[super UpdateViewLayout];
	CGRect rect = CGRectMake(self.frame.size.width-30, 0, 30, 30);
	[m_CloseButton setFrame:rect];
}

//- (BOOL)canBecomeFirstResponder 
//{
//	return YES;
//}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	//if(event.subtype == UIEventSubtypeMotionShake)
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	
}

- (void) touchesBegan : (NSSet*)touches withEvent: (UIEvent*)event
{
	//[m_DealController touchesBegan:touches withEvent:event];
}	

- (void) touchesMoved: (NSSet*)touches withEvent: (UIEvent*)event
{
	//[m_DealController touchesMoved:touches withEvent:event];
}	

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//[m_DealController touchesEnded:touches withEvent:event];
}	

-(void)OnViewClose
{
	self.hidden = YES;
	[[self superview] performSelector:@selector(CloseView)];
}	

-(void)CloseView:(BOOL)bAnimation
{
	self.hidden = YES;
	if(bAnimation)
	{
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
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
    [self setAlpha:1.0];
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
		[self setAlpha:1.0];
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

@end




@implementation ResultViewParent 

- (id)initView:(CGRect)frame withGame:(DealController*)game
{
    self = [super initWithFrame:CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight])];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        m_ResultView = [[ResultView alloc] initView:frame withGame:game];
        [self addSubview:m_ResultView];
        m_ResultView.hidden = YES;
        [m_ResultView release];
    }
    return self;
}

- (void)UpdateGameViewLayout
{
    [self setFrame:CGRectMake(0, 0, [GUILayout GetMainUIWidth], [GUILayout GetMainUIHeight])];
    float fResultViewSize = [CGameLayout GetResultViewSize];
    CGRect rect = CGRectMake(([GUILayout GetMainUIWidth]-fResultViewSize)/2.0, ([GUILayout GetMainUIHeight]-fResultViewSize)/2.0, fResultViewSize, fResultViewSize);
    if([ApplicationConfigure iPhoneDevice] && [GUILayout IsLandscape] && [ApplicationConfigure GetAdViewsState])
        rect = CGRectMake(([GUILayout GetMainUIWidth]-fResultViewSize)/2.0, 0, fResultViewSize, fResultViewSize);        
    
    [m_ResultView setFrame:rect];
    [m_ResultView UpdateGameViewLayout];

    if(self.hidden == NO)
        [[self superview] bringSubviewToFront:self];
}

- (void)OnTimerEvent
{
    [m_ResultView OnTimerEvent];
}

- (void)StartResult:(int)nPoint withScore:(int)nScore
{
    [m_ResultView StartResult:nPoint withScore:nScore];
}

- (void)EndResult
{
    [m_ResultView EndResult];
}

- (void)CloseView
{
    [[self superview] sendSubviewToBack:self];
    self.hidden = YES;
    [GUIEventLoop SendEvent:GUIID_EVENT_GOTONEWGAMEBUTTON eventSender:self];
}

- (void)OpenView
{
    self.hidden = NO;
    [[self superview] bringSubviewToFront:self];
    [m_ResultView OpenView:YES];
}

- (void) touchesBegan : (NSSet*)touches withEvent: (UIEvent*)event
{
}	

- (void) touchesMoved: (NSSet*)touches withEvent: (UIEvent*)event
{
}	

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}	

@end



