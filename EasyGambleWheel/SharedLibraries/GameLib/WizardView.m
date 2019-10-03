//
//  WizardView.m
//  XXXXXXX
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "BetMethodView.h"
#import "NumericView.h"
#import "ThemeSelectView.h"
#import "PlayModeView.h"
#import "PlayTurnView.h"
#import "WizardView.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "GameViewController.h"
#import "ImageLoader.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#import "RenderHelper.h"
#import "Configuration.h"

@implementation WizardView

+ (float)GetSquareIconViewSize
{
    float fSize = 220;
    
    if([ApplicationConfigure iPADDevice])
        fSize = 320;
    
    return fSize;
    
}

- (void)InitSubViews
{
    float fSize = [WizardView GetSquareIconViewSize];
    float sx = (self.frame.size.width-fSize)*0.5;
    float sy = (self.frame.size.height-fSize)*0.5;
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
   
    m_PlayModeView = [[PlayModeView alloc] initWithFrame:rect];
    [self addSubview:m_PlayModeView];
   
    m_BetMethodView = [[BetMethodView alloc] initWithFrame:rect];
    [self addSubview:m_BetMethodView];

    m_OnlinePlayTurnView = [[PlayTurnView alloc] initWithFrame:rect];
    [self addSubview:m_OnlinePlayTurnView];
    
    
    float lw = [GUILayout GetLuckyNumberPickViewWidth];
    float lh = [GUILayout GetLuckyNumberPickViewHeight];
    sx = (self.frame.size.width-lw)*0.5;
    sy = (self.frame.size.height-lh)*0.5;
    rect = CGRectMake(sx, sy, lw, lh);
    m_LuckyNumberView = [[NumericView alloc] initWithFrame:rect];
    [self addSubview:m_LuckyNumberView];
    
    if([ApplicationConfigure iPhoneDevice])
    {
        lw = 300;
        sx = (self.frame.size.width-lw)*0.5;
        sy = (self.frame.size.height-lh)*0.5;
        rect = CGRectMake(sx, sy, lw, lh);
    }
    m_ThemeSelectionView = [[ThemeSelectView alloc]  initWithFrame:rect];
    [self addSubview:m_ThemeSelectionView];
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
        self.backgroundColor = [UIColor redColor];
        [self InitSubViews];
        [self InitButtons];
        m_CurrentTab = 0;
        m_bAnimation = NO;
        m_bNetworkConnected = YES;
    }
    return self;
}

/*
- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
	
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreatePattern(NULL);
	CGContextSetFillColorSpace(context, colorSpace);
    
	float fAlpha = 0.65;
	[RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
    CGColorSpaceRelease(colorSpace);
	CGContextRestoreGState(context);
}*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect:rect];
}

- (void)dealloc
{
//    CGImageRelease(m_BackGround);
    
}

-(void)UpdateViewLayout
{
    [super UpdateViewLayout];
    float fSize = [WizardView GetSquareIconViewSize];
    float sx = (self.frame.size.width-fSize)*0.5;
    float sy = (self.frame.size.height-fSize)*0.5;
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    
    [m_PlayModeView setFrame:rect];
    [m_BetMethodView setFrame:rect];
    [m_OnlinePlayTurnView setFrame:rect];
    
    float lw = [GUILayout GetLuckyNumberPickViewWidth];
    float lh = [GUILayout GetLuckyNumberPickViewHeight];
    sx = (self.frame.size.width-lw)*0.5;
    sy = (self.frame.size.height-lh)*0.5;
    rect = CGRectMake(sx, sy, lw, lh);
    [m_LuckyNumberView setFrame:rect];
    if([ApplicationConfigure iPhoneDevice])
    {
        lw = 300;
        sx = (self.frame.size.width-lw)*0.5;
        sy = (self.frame.size.height-lh)*0.5;
        rect = CGRectMake(sx, sy, lw, lh);
    }
    [m_ThemeSelectionView setFrame:rect];
    
    [self setNeedsDisplay];
}

-(void)OpenView:(BOOL)bAnimation
{
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    
    if(pController)
    {    
        m_bNetworkConnected = [pController IsSupportMultPlayerGame];
    }    
    else
    {    
        m_bNetworkConnected = NO;
        [Configuration setOnline:NO];
    }    
    
    [super OpenView:bAnimation];
    
    if(m_bNetworkConnected)
    {
        m_ThemeSelectionView.hidden = YES;
        m_LuckyNumberView.hidden = YES;
        m_BetMethodView.hidden = YES;
        m_PlayModeView.hidden = NO;
        m_OnlinePlayTurnView.hidden = YES;
        [self bringSubviewToFront:m_PlayModeView];
        [m_PlayModeView OpenView];
    }
    else
    {
        m_LuckyNumberView.hidden = NO;
        m_ThemeSelectionView.hidden = YES;
        m_BetMethodView.hidden = YES;
        m_PlayModeView.hidden = YES;
        m_OnlinePlayTurnView.hidden = YES;
        [self bringSubviewToFront:m_LuckyNumberView];
        [m_LuckyNumberView OpenView];
    }
    m_CurrentTab = 0;
}

-(void)OnPrevViewOpen:(id)sender
{
    m_bAnimation = NO;
    
    if(0 < m_CurrentTab)
        --m_CurrentTab;
}

-(void)OnPrevViewHideWithOnlineOption:(id)sender
{
    UIView* pView;
    if(m_CurrentTab == 3)
    {
        if([Configuration isOnline])
        {
            [self bringSubviewToFront:m_LuckyNumberView];
            [m_LuckyNumberView OpenView];
            m_LuckyNumberView.hidden = NO;
            pView = m_LuckyNumberView;
        }
        else
        {
            [self bringSubviewToFront:m_ThemeSelectionView];
            [m_ThemeSelectionView OpenView];
            m_ThemeSelectionView.hidden = NO;
            pView = m_ThemeSelectionView;
        }
    }
    else if(m_CurrentTab == 2)
    {
        if([Configuration isOnline])
        {
            [self bringSubviewToFront:m_OnlinePlayTurnView];
            [m_OnlinePlayTurnView OpenView];
            m_OnlinePlayTurnView.hidden = NO;
            pView = m_OnlinePlayTurnView;
        }
        else
        {
            [self bringSubviewToFront:m_LuckyNumberView];
            [m_LuckyNumberView OpenView];
            m_LuckyNumberView.hidden = NO;
            pView = m_LuckyNumberView;
        }    
    }
    else if(m_CurrentTab == 1)
    {    
        [self bringSubviewToFront:m_PlayModeView];
        [m_PlayModeView OpenView];
        m_PlayModeView.hidden = NO;
        pView = m_PlayModeView;
    }    
    else
    {    
        return;
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnPrevViewOpen:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)OpenPrevTabWithOnlineOption
{
    m_bAnimation = YES;
    
    UIView* pView;
    if(m_CurrentTab == 3)
    {
        if([Configuration isOnline])
        {
            m_ThemeSelectionView.hidden = YES;
            [self sendSubviewToBack:m_ThemeSelectionView];
            pView = m_ThemeSelectionView;
        }
        else
        {
            m_BetMethodView.hidden = YES;
            [self sendSubviewToBack:m_BetMethodView];
            pView = m_BetMethodView;
        }
    }
    else if(m_CurrentTab == 2)
    {    
        if([Configuration isOnline])
        {
            m_LuckyNumberView.hidden = YES;
            [self sendSubviewToBack:m_LuckyNumberView];
            pView = m_LuckyNumberView;
        }
        else
        {    
            m_ThemeSelectionView.hidden = YES;
            [self sendSubviewToBack:m_ThemeSelectionView];
            pView = m_ThemeSelectionView;
        }   
    }    
    else if(m_CurrentTab == 1)
    {    
        if([Configuration isOnline])
        {
            m_OnlinePlayTurnView.hidden = YES;
            [self sendSubviewToBack:m_OnlinePlayTurnView];
            pView = m_OnlinePlayTurnView;
        }
        else
        {    
            m_LuckyNumberView.hidden = YES;
            [self sendSubviewToBack:m_LuckyNumberView];
            pView = m_LuckyNumberView;
        }    
    }    
    else
    {    
        return;
    }
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnPrevViewHideWithOnlineOption:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)HandlePrevButtonWithOnlineOption
{
    if(0 < m_CurrentTab)
    {    
        [self OpenPrevTabWithOnlineOption];
    }    
}

-(void)OnPrevViewHideNoOnlineOption:(id)sender
{
    UIView* pView;
    if(m_CurrentTab == 1)
    {
        [self bringSubviewToFront:m_LuckyNumberView];
        [m_LuckyNumberView OpenView];
        m_LuckyNumberView.hidden = NO;
        pView = m_LuckyNumberView;
    }
    else
    {    
        return;
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnPrevViewOpen:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)OpenPrevTabNoOnlineOption
{
    m_bAnimation = YES;
    
    UIView* pView;
    if(m_CurrentTab == 3)
    {    
        m_BetMethodView.hidden = YES;
        [self sendSubviewToBack:m_BetMethodView];
        pView = m_BetMethodView;
    }    
    else
    {    
        return;
    }
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnPrevViewHideNoOnlineOption:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)HandlePrevButtonNoOnlineOption
{
    if(0 < m_CurrentTab)
    {    
        [self OpenPrevTabNoOnlineOption];
    }    
}


-(void)PrevButtonClick
{
    if(m_bAnimation == YES)
        return;

    if(m_bNetworkConnected)
    {
        [self HandlePrevButtonWithOnlineOption];
    }
    else
    {
        [self HandlePrevButtonNoOnlineOption];
    }
}

-(void)OnNextViewOpenWithOnlineOption:(id)sender
{
    m_bAnimation = NO;
    if(m_CurrentTab < 3)
        ++m_CurrentTab;
}

-(void)OnNextViewHideWithOnlineOption:(id)sender
{
    UIView* pView;
    if(m_CurrentTab == 0)
    {    
        if([Configuration isOnline])
        {
            [self bringSubviewToFront:m_OnlinePlayTurnView];
            [m_OnlinePlayTurnView OpenView];
            m_OnlinePlayTurnView.hidden = NO;
            pView = m_OnlinePlayTurnView;
        }
        else
        {    
            [self bringSubviewToFront:m_LuckyNumberView];
            [m_LuckyNumberView OpenView];
            m_LuckyNumberView.hidden = NO;
            pView = m_LuckyNumberView;
        }    
    }
    else if(m_CurrentTab == 1)
    {
        if([Configuration isOnline])
        {
            [self bringSubviewToFront:m_LuckyNumberView];
            [m_LuckyNumberView OpenView];
            m_LuckyNumberView.hidden = NO;
            pView = m_LuckyNumberView;
        }
        else
        {    
            [self bringSubviewToFront:m_ThemeSelectionView];
            [m_ThemeSelectionView OpenView];
            m_ThemeSelectionView.hidden = NO;
            pView = m_ThemeSelectionView;
        }    
    }
    else if(m_CurrentTab == 2)
    {
        if([Configuration isOnline])
        {
            [self bringSubviewToFront:m_ThemeSelectionView];
            [m_ThemeSelectionView OpenView];
            m_ThemeSelectionView.hidden = NO;
            pView = m_ThemeSelectionView;
        }
        else
        {
            [self bringSubviewToFront:m_BetMethodView];
            [m_BetMethodView OpenView];
            m_BetMethodView.hidden = NO;
            pView = m_BetMethodView;
        }
    }
    else
    {    
        return;
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNextViewOpenWithOnlineOption:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)OpenNextTabWithOnlineOption
{
    m_bAnimation = YES;
    UIView* pView;
    if(m_CurrentTab == 0)
    {    
        m_PlayModeView.hidden = YES;
        [self sendSubviewToBack:m_PlayModeView];
        pView = m_PlayModeView;
    }
    else if(m_CurrentTab == 1)
    {
        if([Configuration isOnline])
        {
            m_OnlinePlayTurnView.hidden = YES;
            [self sendSubviewToBack:m_OnlinePlayTurnView];
            pView = m_OnlinePlayTurnView;
        }
        else
        {    
            m_LuckyNumberView.hidden = YES;
            [self sendSubviewToBack:m_LuckyNumberView];
            pView = m_LuckyNumberView;
        }    
    }
    else if(m_CurrentTab == 2)
    {
        if([Configuration isOnline])
        {
            m_LuckyNumberView.hidden = YES;
            [self sendSubviewToBack:m_LuckyNumberView];
            pView = m_LuckyNumberView;
        }
        else
        {
            m_ThemeSelectionView.hidden = YES;
            [self sendSubviewToBack:m_ThemeSelectionView];
            pView = m_ThemeSelectionView;
        }
    }
    else
    {    
        return;
    }
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNextViewHideWithOnlineOption:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)HandleNextButtonWithOnlineOption
{
     if(m_CurrentTab < 3)
     {    
         [self OpenNextTabWithOnlineOption];
     }
     else if(3 <= m_CurrentTab)
     {
         [self CloseView:YES];
     }
}


-(void)OnNextViewOpenNoOnlineOption:(id)sender
{
    m_bAnimation = NO;
    if(m_CurrentTab < 3)
        ++m_CurrentTab;
}

-(void)OnNextViewHideNoOnlineOption:(id)sender
{
    UIView* pView;
    if(m_CurrentTab == 0)
    {
        [self bringSubviewToFront:m_BetMethodView];
        [m_BetMethodView OpenView];
        m_BetMethodView.hidden = NO;
        pView = m_BetMethodView;
    }
    else
    {    
        return;
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNextViewOpenNoOnlineOption:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)OpenNextTabNoOnlineOption
{
    m_bAnimation = YES;
    UIView* pView;

    if(m_CurrentTab == 0)
    {
        m_LuckyNumberView.hidden = YES;
        [self sendSubviewToBack:m_LuckyNumberView];
        pView = m_LuckyNumberView;
    }
    else
    {    
        return;
    }
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnNextViewHideNoOnlineOption:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:pView cache:YES];
    [UIView commitAnimations];
}

-(void)HandleNextButtonNoOnlineOption
{
    if(m_CurrentTab < 3)
    {    
        [self OpenNextTabNoOnlineOption];
    }
    else if(3 <= m_CurrentTab)
    {
        [self CloseView:YES];
    }
}

-(void)NextButtonClick
{
    if(m_bAnimation == YES)
        return;
    
    if(m_bNetworkConnected)
    {
        [self HandleNextButtonWithOnlineOption];
    }
    else
    {
        [self HandleNextButtonNoOnlineOption];
    }
}

-(void)CloseView:(BOOL)bAnimation
{
    [super CloseView:bAnimation];
    [GUIEventLoop SendEvent:GUIID_EVENT_WIZARDFINISHED eventSender:self];
}

-(void)OnTimerEvent
{
    if(m_LuckyNumberView.hidden == NO)
        [m_LuckyNumberView OnTimerEvent];
    if(m_ThemeSelectionView.hidden == NO)
        [m_ThemeSelectionView OnTimerEvent];
}

@end
