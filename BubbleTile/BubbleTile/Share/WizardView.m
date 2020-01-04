//
//  WizardView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "BubbleView.h"
#import "LayoutView.h"
#import "NumericView.h"
#import "PatternView.h"
#import "LevelView.h"
#import "WizardView.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "ImageLoader.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#import "RenderHelper.h"

@implementation WizardView

- (void)InitSubViews
{
    float y = [GUILayout GetTitleBarHeight];
    float w = self.frame.size.width;
    float h = self.frame.size.height-y;
    CGRect rect = CGRectMake(0, y, w, h);
   
    m_BubbleView = [[BubbleView alloc] initWithFrame:rect];
    m_BubbleView.backgroundColor = [UIColor clearColor];
    m_BubbleView.hidden = NO;
    [self addSubview:m_BubbleView];
    [m_BubbleView release];
    
    m_LayoutView = [[LayoutView alloc] initWithFrame:rect];
    m_LayoutView.backgroundColor = [UIColor clearColor];
    m_LayoutView.hidden = YES;
    [self addSubview:m_LayoutView];
    [m_LayoutView release];
    
    m_EdgeView = [[NumericView alloc] initWithFrame:rect];
    //m_EdgeView.backgroundColor = [UIColor clearColor];
    m_EdgeView.hidden = YES;
    [self addSubview:m_EdgeView];
    [m_EdgeView release];
    
    m_PatternView = [[PatternView alloc] initWithFrame:rect];
    //m_PatternView.backgroundColor = [UIColor clearColor];
    m_PatternView.hidden = YES;
    [self addSubview:m_PatternView];
    [m_PatternView release];

    m_LevelView = [[LevelView alloc] initWithFrame:rect];
    m_LevelView.hidden = YES;
    [self addSubview:m_LevelView];
    [m_LevelView release];

}

- (void)InitButtons
{
    float fsize = [GUILayout GetDefaultAlertUIEdge];
    float fBtnSize = [GUILayout GetTitleBarHeight];
    CGRect rect = CGRectMake(fsize, fsize, fBtnSize, fBtnSize);
   
    m_PrevButton = [[UIButton alloc] initWithFrame:rect];
    // Set up the button aligment properties
    m_PrevButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_PrevButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_PrevButton setBackgroundImage:[UIImage imageNamed:@"previcon.png"] forState:UIControlStateNormal];
    [m_PrevButton setBackgroundImage:[UIImage imageNamed:@"previconhi.png"] forState:UIControlStateHighlighted];
    [m_PrevButton addTarget:self action:@selector(PrevButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_PrevButton];
    [self bringSubviewToFront:m_PrevButton];
    
    rect = CGRectMake(fBtnSize+2+fsize, fsize, fBtnSize, fBtnSize);
    m_NextButton = [[UIButton alloc] initWithFrame:rect];
    // Set up the button aligment properties
    m_NextButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_NextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticon.png"] forState:UIControlStateNormal];
    [m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticonhi.png"] forState:UIControlStateHighlighted];
    [m_NextButton addTarget:self action:@selector(NextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_NextButton];
    [self bringSubviewToFront:m_NextButton];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self InitSubViews];
        [self bringSubviewToFront:m_LayoutView];
        [self InitButtons];
        m_CurrentTab = 0;
        m_bAnimation = NO;
    }
    return self;
}


/*- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
    float fAlpha = 1.0;
    [RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
	CGContextRestoreGState(context);
}*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

- (void)dealloc
{
    [super dealloc];
}

-(void)UpdateViewLayout
{
    [super UpdateViewLayout];
    float y = [GUILayout GetTitleBarHeight];
    float w = self.frame.size.width;
    float h = self.frame.size.height-y;
    CGRect rect = CGRectMake(0, y, w, h);
    
    [m_BubbleView setFrame:rect];
    [m_BubbleView UpdateViewLayout];
    [m_LayoutView setFrame:rect];
    [m_LayoutView UpdateViewLayout];
    [m_EdgeView setFrame:rect];
    [m_EdgeView UpdateViewLayout];
    [m_PatternView setFrame:rect];
    [m_PatternView UpdateViewLayout];
    [m_LevelView setFrame:rect];
    [m_LevelView UpdateViewLayout];
    [self setNeedsDisplay];
}

-(void)OpenView:(BOOL)bAnimation
{
    [super OpenView:bAnimation];
    m_BubbleView.hidden = NO;
    m_LayoutView.hidden = YES;
    m_PatternView.hidden = YES;
    m_EdgeView.hidden = YES;
    m_LevelView.hidden = YES;
    [self bringSubviewToFront:m_BubbleView];
    [m_BubbleView OpenView];
    m_CurrentTab = 0;
}

-(void)OnPrevViewOpen:(id)sender
{
    m_bAnimation = NO;
    
    if(0 < m_CurrentTab)
        --m_CurrentTab;
}

-(void)OnPrevViewHide:(id)sender
{
    UIView* pView;
    if(m_CurrentTab == 4)
    {    
        [self bringSubviewToFront:m_EdgeView];
        [m_EdgeView OpenView];
        m_EdgeView.hidden = NO;
        pView = m_EdgeView;
    }    
    else if(m_CurrentTab == 3)
    {    
        [self bringSubviewToFront:m_PatternView];
        [m_PatternView OpenView];
        m_PatternView.hidden = NO;
        pView = m_PatternView;
    }    
    else if(m_CurrentTab == 2)
    {    
        [self bringSubviewToFront:m_LayoutView];
        m_LayoutView.hidden = NO;
        pView = m_LayoutView;
    }    
    else if(m_CurrentTab == 1)
    {    
        [self bringSubviewToFront:m_BubbleView];
        m_BubbleView.hidden = NO;
        pView = m_BubbleView;
    }    
    else
        return;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnPrevViewOpen:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:pView cache:YES];
    [UIView commitAnimations];
    
}


-(void)OpenPrevTab
{
    m_bAnimation = YES;
    
    UIView* pView;
    if(m_CurrentTab == 4)
    {    
        m_LevelView.hidden = YES;
        [self sendSubviewToBack:m_LevelView];
        pView = m_LevelView;
    }    
    else if(m_CurrentTab == 3)
    {    
        m_EdgeView.hidden = YES;
        [self sendSubviewToBack:m_EdgeView];
        pView = m_EdgeView;
    }    
    else if(m_CurrentTab == 2)
    {    
        [self sendSubviewToBack:m_PatternView];
        m_PatternView.hidden = YES;
        pView = m_PatternView;
    }    
    else if(m_CurrentTab == 1)
    {    
        [self sendSubviewToBack:m_LayoutView];
        m_LayoutView.hidden = YES;
        pView = m_LayoutView;
    }    
    else
        return;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnPrevViewHide:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)PrevButtonClick
{
    if(m_bAnimation == YES)
        return;
    
    if(0 < m_CurrentTab)
    {    
        [self OpenPrevTab];
    }    
}

-(void)OnNextViewOpen:(id)sender
{
    m_bAnimation = NO;
    if(m_CurrentTab < 4)
        ++m_CurrentTab;
}

-(void)OnNextViewHide:(id)sender
{
    UIView* pView;
    if(m_CurrentTab == 0)
    {    
        [self bringSubviewToFront:m_LayoutView];
        [m_LayoutView OpenView];
        m_LayoutView.hidden = NO;
        pView = m_LayoutView;
    }    
    else if(m_CurrentTab == 1)
    {    
        [self bringSubviewToFront:m_PatternView];
        [m_PatternView OpenView];
        m_PatternView.hidden = NO;
        pView = m_PatternView;
    }    
    else if(m_CurrentTab == 2)
    {    
        [self bringSubviewToFront:m_EdgeView];
        m_EdgeView.hidden = NO;
        [m_EdgeView OpenView];
        pView = m_EdgeView;
    }    
    else if(m_CurrentTab == 3)
    {    
        [self bringSubviewToFront:m_LevelView];
        m_LevelView.hidden = NO;
        [m_LevelView OpenView];
        pView = m_LevelView;
    }    
    else
        return;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNextViewOpen:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)OpenNextTab
{
    m_bAnimation = YES;
    UIView* pView;
    if(m_CurrentTab == 0)
    {    
        m_BubbleView.hidden = YES;
        [self sendSubviewToBack:m_BubbleView];
        pView = m_BubbleView;
    }    
    else if(m_CurrentTab == 1)
    {    
        m_LayoutView.hidden = YES;
        [self sendSubviewToBack:m_LayoutView];
        pView = m_LayoutView;
    }    
    else if(m_CurrentTab == 2)
    {    
        [self sendSubviewToBack:m_PatternView];
        m_PatternView.hidden = YES;
        pView = m_PatternView;
    }    
    else if(m_CurrentTab == 3)
    {    
        [self sendSubviewToBack:m_EdgeView];
        m_EdgeView.hidden = YES;
        pView = m_EdgeView;
    }    
    else
        return;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNextViewHide:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)NextButtonClick
{
    if(m_bAnimation == YES)
        return;
    
    if(m_CurrentTab < 4)
    {    
        [self OpenNextTab];
    }
    else if(m_CurrentTab == 4)
    {
        [self CloseView:YES];
    }
}

-(void)CloseView:(BOOL)bAnimation
{
    [super CloseView:bAnimation];
    [GUIEventLoop SendEvent:GUIID_EVENT_WIZARDFINISHED eventSender:self];
}

@end
