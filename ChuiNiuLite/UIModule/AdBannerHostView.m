//
//  AdBannerHostView.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-02.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "iAdViewHolder.h"
#import "MobclixAdViewHolder.h"
#import "AdBannerHostView.h"
#import "GoogleAdViewHolder.h"
#import "UIDevice-Reachability.h"


@implementation AdBannerHostView


-(void)PauseAd
{
    m_bPaused = YES;
    [m_iADView PauseAd];
    [m_MobclixView PauseAd];
    [m_GoogleView PauseAd];
}

-(void)ResumeAd
{
    m_bPaused = NO;
    [m_iADView ResumeAd];
    [m_MobclixView ResumeAd];
    [m_GoogleView ResumeAd];
    [self Start];
}

- (void)initSubAdViews
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    m_iADView = [[iAdViewHolder alloc] initWithFrame:rect];
    m_iADView.m_Delegate = self;
    [self addSubview:m_iADView];
    [m_iADView release];
    
    m_MobclixView = [[MobclixAdViewHolder alloc] initWithFrame:rect];
    m_MobclixView.m_Delegate = self;
    [self addSubview:m_MobclixView];
    [m_MobclixView release];
    
    m_GoogleView = [[GoogleAdViewHolder alloc] initWithFrame:rect];
    m_GoogleView.m_Delegate = self;
    [self addSubview:m_GoogleView];
    [m_GoogleView release];
    
    m_nCurrentAdType = ADVIEW_TYPE_MOBCLIX;
    m_bCountTimer = NO;
    m_TimerStart = 0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_Delegate = nil;
        [self initSubAdViews];
        m_bPaused = NO;
        m_AlertView = [[CustomDummyAlertView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width, frame.size.height)];
        [self addSubview:m_AlertView];
        [m_AlertView release];
        [m_AlertView Hide];
        [m_AlertView SetMultiLineText:NO];
        m_TimerCount = [[NSProcessInfo processInfo] systemUptime];
    }
    return self;
}

-(void)AdViewClicked:(int)nType
{
    
}

-(void)AdViewLoaded:(int)nType
{
    if(m_bCountTimer == NO && m_nCurrentAdType == nType)
    {    
        m_bCountTimer = YES;
        m_TimerStart = [[NSProcessInfo processInfo] systemUptime];
    }
    if(nType == ADVIEW_TYPE_APPLE)
    {
        [self bringSubviewToFront:m_iADView];
    }
    else if(nType == ADVIEW_TYPE_GOOGLE)
    {
        [self bringSubviewToFront:m_GoogleView];
    }
    else if(nType == ADVIEW_TYPE_MOBCLIX)
    {
        [self bringSubviewToFront:m_MobclixView];
    }
}

-(void)AdViewClosed:(int)nType
{
    m_bCountTimer = NO;
    if(nType == ADVIEW_TYPE_APPLE)
    {
        [self sendSubviewToBack:m_iADView];
        m_nCurrentAdType = ADVIEW_TYPE_MOBCLIX;
        [m_MobclixView OpenAdView];
    }
    else if(nType == ADVIEW_TYPE_MOBCLIX)
    {
        [self sendSubviewToBack:m_MobclixView];
        m_nCurrentAdType = ADVIEW_TYPE_GOOGLE;
        [m_GoogleView OpenAdView];
    }
    else if(nType == ADVIEW_TYPE_GOOGLE)
    {
        [self sendSubviewToBack:m_GoogleView];
        m_nCurrentAdType = ADVIEW_TYPE_APPLE;
        [m_iADView OpenAdView];
    }
    [self AdViewLoaded:m_nCurrentAdType];
}

-(void)AdViewFailed
{
    
}

-(void)RegisterDelegate:(id<AdRequestHandlerDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)Start
{
    m_bCountTimer = NO;
    m_TimerStart = 0;
    m_bPaused = NO;
    if(m_nCurrentAdType == ADVIEW_TYPE_APPLE)
    {
        [m_iADView OpenAdView];
    }
    else if(m_nCurrentAdType == ADVIEW_TYPE_MOBCLIX)
    {
        [m_MobclixView OpenAdView];
    }
    else 
    {
        [m_GoogleView OpenAdView];
    }
    //[self.superview bringSubviewToFront:self];
}

-(void)CloseCurrentAdView
{
    m_bCountTimer = NO;
    if(m_nCurrentAdType == ADVIEW_TYPE_APPLE)
    {
        [m_iADView CloseAdView];
    }
    else if(m_nCurrentAdType == ADVIEW_TYPE_MOBCLIX)
    {
        [m_MobclixView CloseAdView];
    }
    else if(m_nCurrentAdType == ADVIEW_TYPE_GOOGLE)
    {
        [m_GoogleView CloseAdView];
    }
}

-(void)SetAlertMessage:(NSString*)text
{
    [m_AlertView SetMessage:text];
}

-(void)OnTimerEvent
{
    float fCurrent = [[NSProcessInfo processInfo] systemUptime]; 
    if(10 <= fCurrent - m_TimerCount)
    {
        if(m_AlertView.hidden == YES && [UIDevice networkAvailable] == NO)
        {
            [self PauseAd];
            [m_AlertView Show];
        }
        else if(m_AlertView.hidden == NO && [UIDevice networkAvailable] == YES)
        {
            [m_AlertView Hide];
            [self ResumeAd];
        }
        m_TimerCount = fCurrent; 
    }
    
    if(m_bPaused)
        return;
    
    if(m_bCountTimer)
    {
        NSTimeInterval curTime = [[NSProcessInfo processInfo] systemUptime];
        if(ADVIEW_DISPLAY_TIME <= (curTime - m_TimerStart))
        {
            [self CloseCurrentAdView];
        }
    }
}

@end
