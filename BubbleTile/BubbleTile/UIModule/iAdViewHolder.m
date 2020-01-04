//
//  iAdViewHolder.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "iAdViewHolder.h"
#import "ApplicationConfigure.h"

@implementation iAdViewHolder

@synthesize m_Delegate;
@synthesize m_bProtraitOnly;

+ (float)iADBannerProtraitWidth
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return 320;
    }
    else 
    {
        return 768;
    }
}

+ (float)iADBannerLandscapeWidth
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return 480;
    }
    else 
    {
        return 1024;
    }
}

+ (float)iADBannerHeight
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        return 50;
    }
    else 
    {
        return 66;
    }
}

-(void)PauseAd
{
    if(m_AdView != nil)
    {    
        m_AdView.delegate = nil;
        [m_AdView removeFromSuperview];
        m_AdView = nil;
    }
}

-(void)ResumeAd
{
    if(m_AdView == nil)
    {
        m_AdView = [[ADBannerView alloc] init];
        m_AdView.delegate = self;
        CGRect frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerProtraitWidth])/2.0, self.frame.size.height, [iAdViewHolder iADBannerProtraitWidth], self.frame.size.height);
        [self addSubview:m_AdView];
        [m_AdView setFrame:frame];
        [m_AdView release];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        m_bProtraitOnly = YES;
        if(m_AdView == nil)
        {
            m_AdView = [[ADBannerView alloc] init];
            m_AdView.delegate = self;
            CGRect frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerProtraitWidth])/2.0, self.frame.size.height, [iAdViewHolder iADBannerProtraitWidth], self.frame.size.height);
            [self addSubview:m_AdView];
            [m_AdView setFrame:frame];
            [m_AdView release];
        }
    }
    return self;
}

-(void)CloseAdView
{
    if(m_AdView != nil)
    {
        CGRect frame;
        if(m_bProtraitOnly)
        {
            m_AdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
            frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerProtraitWidth])/2.0, self.frame.size.height, [iAdViewHolder iADBannerProtraitWidth], self.frame.size.height);
        }
        else
        {
            if (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation)) 
            {
                m_AdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
                frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerProtraitWidth])/2.0, self.frame.size.height, [iAdViewHolder iADBannerProtraitWidth], self.frame.size.height);
            } 
            else 
            {
                m_AdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
                frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerLandscapeWidth])/2.0, self.frame.size.height, [iAdViewHolder iADBannerLandscapeWidth], self.frame.size.height);
            }
        }
        [m_AdView setFrame:frame];
    }
    [self.superview sendSubviewToBack:self];
    if(m_Delegate)
    {
        [m_Delegate AdViewClosed:ADVIEW_TYPE_APPLE];
    }
}

-(void)OpenAdView
{
    if(m_AdView == nil)
        return;
    
    CGRect frame;
     float sy = (self.frame.size.height - [iAdViewHolder iADBannerHeight]);   
     if(m_bProtraitOnly)
     {
     m_AdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
     frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerProtraitWidth])/2.0, sy, [iAdViewHolder iADBannerProtraitWidth], self.frame.size.height);
     }
     else
     {
     if (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation)) 
     {
     m_AdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
     frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerProtraitWidth])/2.0, sy, [iAdViewHolder iADBannerProtraitWidth], self.frame.size.height);
     } 
     else 
     {
     m_AdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
     frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerLandscapeWidth])/2.0, sy, [iAdViewHolder iADBannerLandscapeWidth], self.frame.size.height);
     }
     }
     [m_AdView setFrame:frame];
     [self.superview bringSubviewToFront:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
}

// This method is invoked each time a banner loads a new advertisement. Once a banner has loaded an ad,
// it will display that ad until another ad is available. The delegate might implement this method if
// it wished to defer placing the banner in a view hierarchy until the banner has content to display.
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //AD loaded then show it!
    if(m_Delegate)
        [m_Delegate AdViewLoaded:ADVIEW_TYPE_APPLE];
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self CloseAdView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

@end
