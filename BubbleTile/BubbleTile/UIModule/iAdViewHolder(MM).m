//
//  iAdViewHolder.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "iAdViewHolder.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"

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
    if(m_MMAdView)
    {    
        m_MMAdView.refreshTimerEnabled = NO;
    }    
    if(m_AdView != nil)
    {    
        m_AdView.delegate = nil;
        [m_AdView removeFromSuperview];
        m_AdView = nil;
    }
}

-(void)ResumeAd
{
    if(m_MMAdView)
    {    
        m_MMAdView.refreshTimerEnabled = YES;
        [m_MMAdView refreshAd];
    }    
    
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
        
        // Create a 320 x 53 frame to display iPhone ads, or a 768 x 90 frame to display iPad ads
        CGRect adFrame = CGRectMake(0, 0, 320, 53);
        if([ApplicationConfigure iPADDevice])
            adFrame = CGRectMake(0, 0, 768, 90);
        
        // Returns an autoreleased MMAdView object
        m_MMAdView = [MMAdView adWithFrame:adFrame 
                                         type:MMBannerAdBottom 
                                      apid:[ApplicationConfigure GetMMSDKBottomAdID]
                                     delegate:self  // Must be set, CANNOT be nil
                                       loadAd:YES   // Loads an ad immediately
                                   startTimer:YES]; // Start timer to auto refresh the ad view
        m_MMAdView.rootViewController = [GUILayout GetMainViewController]; // you must set the 
        [self addSubview:m_MMAdView];
        
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

-(void)dealloc
{
    m_MMAdView.refreshTimerEnabled = NO; // Stop internal refresh timer
    m_MMAdView.delegate = nil; // Set the delegate to nil
    m_MMAdView = nil; // Set your variable to nil
    
    [super dealloc];
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
    if(m_MMAdView)
    {    
        m_MMAdView.refreshTimerEnabled = YES;
        [m_MMAdView refreshAd];
    }   
    [self.superview bringSubviewToFront:self];
    [self bringSubviewToFront:m_MMAdView];
    
    if(m_AdView == nil)
        return;
    
    CGRect frame;
     float sy = (self.frame.size.height - [iAdViewHolder iADBannerHeight]);   
     if(m_bProtraitOnly)
     {
         m_AdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
         frame = CGRectMake((self.frame.size.width-[iAdViewHolder iADBannerProtraitWidth])/2.0, sy,[iAdViewHolder iADBannerProtraitWidth], self.frame.size.height);
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
        
     if(m_AdView.bannerLoaded)
         [self bringSubviewToFront:m_AdView];
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
    //[self CloseAdView];
    if(m_MMAdView)
    {
        [m_MMAdView refreshAd];
        m_MMAdView.refreshTimerEnabled = YES;
        [self bringSubviewToFront:m_MMAdView];
    }    
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

//MMSDK delegate
- (void)adRequestSucceeded:(MMAdView *) adView
{
	NSLog(@"MM AD REQUEST SUCCEEDED");
    if(m_Delegate)
        [m_Delegate AdViewLoaded:ADVIEW_TYPE_APPLE];
}

- (void)adRequestFailed:(MMAdView *) adView
{
	NSLog(@"MM AD REQUEST FAILED");
    [self CloseAdView];
}

- (void)adDidRefresh:(MMAdView *)adView
{
    NSLog(@"MM AD DID REFRESH");
}

- (void)adWasTapped:(MMAdView *)adView
{
	NSLog(@"MM AD WAS TAPPED");
    if(m_Delegate)
        [m_Delegate AdViewLoaded:ADVIEW_TYPE_APPLE];
}

- (void)applicationWillTerminateFromAd
{
	NSLog(@"MM AD WILL OPEN SAFARI");
}

- (void)adModalWasDismissed
{
	NSLog(@"MM AD MODAL WAS DISMISSED");
}

- (void)adModalWillAppear
{
	NSLog(@"MM AD MODAL WILL APPEAR");
}

- (void)adModalDidAppear
{
	NSLog(@"MM AD MODAL DID APPEAR");
}

// Caching delegates

- (void)adRequestIsCaching:(MMAdView *) adView {
    NSLog(@"MM AD IS CACHING");
}

@end
