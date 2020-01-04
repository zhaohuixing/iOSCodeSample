//
//  iAdViewHolder.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "iAdViewHolder.h"
#import "ApplicationConfigure.h"
#import "StringFactory.h"

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

-(BOOL)SupportiAd
{
    if([StringFactory IsOSLangZH])
        return NO;
    if([ApplicationConfigure IsOnSimulator])
        return NO;
    
    return YES;
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

-(void)SwitchToSOMAAdView
{
    if(m_SOMABannerView != nil)
    {
        [m_SOMABannerView setAutoReloadEnabled:YES];
        [m_SOMABannerView asyncLoadNewBanner];
        [self bringSubviewToFront:m_SOMABannerView];
    }
}

-(void)InitSOMAAdView
{
    if(m_SOMABannerView == nil)
    {
        if([ApplicationConfigure iPADDevice])
            m_SOMABannerView = [[SOMABannerView alloc] initWithDimension:kSOMAAdDimensionLeaderboard];
        else 
            m_SOMABannerView = [[SOMABannerView alloc] initWithDimension:kSOMAAdDimensionDefault];
    
    
        [m_SOMABannerView adSettings].adType = kSOMAAdTypeImage;
        m_SOMABannerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        m_SOMABannerView.center = CGPointMake(self.center.x, self.center.y);
        [m_SOMABannerView setDelegate:self];
        [m_SOMABannerView addAdListener:self];
        [m_SOMABannerView adSettings].adspaceId = [ApplicationConfigure GetSOMAAdSpaceIDKey];
        [m_SOMABannerView adSettings].publisherId = [ApplicationConfigure GetSOMAPublisherID];
        [self addSubview: m_SOMABannerView];
        [m_SOMABannerView release];
    }    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        m_biAdFailed = NO;
        [self InitSOMAAdView];
        if([self SupportiAd])
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
        else 
        {
            m_AdView = nil;
        }
    }
    return self;
}

-(void)CloseAdView
{
    m_biAdFailed = NO;
    if(m_SOMABannerView != nil)
    {
        [m_SOMABannerView setAutoReloadEnabled:NO];
    }
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
    CGRect frame;
     
    m_biAdFailed = NO;
    if(m_SOMABannerView != nil)
    {
        [m_SOMABannerView setAutoReloadEnabled:YES];
        [m_SOMABannerView asyncLoadNewBanner];
    }
    if(m_AdView != nil)
    {    
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
        [self bringSubviewToFront:m_AdView];
    }   
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
       m_biAdFailed = NO;
}

// This method is invoked each time a banner loads a new advertisement. Once a banner has loaded an ad,
// it will display that ad until another ad is available. The delegate might implement this method if
// it wished to defer placing the banner in a view hierarchy until the banner has content to display.
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //AD loaded then show it!
/*    CGRect frame;
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
    [self.superview bringSubviewToFront:self];*/
    CGRect rt = banner.frame ;
    rt.origin.y = 0;
    [banner setFrame:rt];
    
    m_biAdFailed = NO;
    if(m_AdView != nil)
        [self bringSubviewToFront:m_AdView];
    if(m_Delegate)
        [m_Delegate AdViewLoaded:ADVIEW_TYPE_APPLE];
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    CGRect rt = banner.frame ;
    rt.origin.y = self.frame.size.height;
    [banner setFrame:rt];
    
    m_biAdFailed = YES;
    [self SwitchToSOMAAdView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    if(m_Delegate)
    {    
        [ApplicationConfigure SetModalPresentAccountable];
        [m_Delegate AdViewClicked:ADVIEW_TYPE_APPLE];
    }    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [ApplicationConfigure ClearModalPresentAccountable];
}

- (void)landingPageWillBeDisplayed
{
    
}

- (void)landingPageHasBeenClosed
{
    if(m_AdView == nil)
        [self CloseAdView];
}

-(void)onReceiveAd:(id<SOMAAdDownloaderProtocol>)sender withReceivedBanner:(id<SOMAReceivedBannerProtocol>)receivedBanner
{
    if ([receivedBanner status] == kSOMABannerStatusError) 
    {
        if(m_AdView == nil || m_biAdFailed == YES)
            [self CloseAdView];
    } 
    else 
    {
        if(m_Delegate)
            [m_Delegate AdViewLoaded:ADVIEW_TYPE_APPLE];
    }
}

@end
