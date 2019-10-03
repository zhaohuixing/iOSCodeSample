//
//  GoogleAdViewHolder.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-05.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "ApplicationConfigure.h"
#import "AdConfiguration.h"
#import "MainApplicationDelegateTemplate.h"
#import "GoogleAdViewHolder.h"
#import "GUILayout.h"

@implementation GoogleAdViewHolder

@synthesize m_Delegate;

-(void)InitiPhoneAddViews:(BOOL)bEnable
{
    if(m_AdmobView == nil)
    {    
        m_AdmobView = [[[GADBannerView alloc] initWithFrame:CGRectMake(0.0, [GUILayout GetAdBannerHeight], 320, 50)] autorelease];
        m_AdmobView.adUnitID = [AdConfiguration GetAdMobPublishKey];
        m_AdmobView.rootViewController = [GUILayout GetMainViewController];
        m_AdmobView.delegate = self;
        [self addSubview:m_AdmobView];
    }    
}

-(void)InitiPadAddViews
{
    if(m_AdmobView == nil)
    {    
        m_AdmobView = [[[GADBannerView alloc] initWithFrame:CGRectMake((self.frame.size.width-468)/2.0, [GUILayout GetAdBannerHeight], 468, 60)] autorelease];
        m_AdmobView.adUnitID = [AdConfiguration GetAdMobPublishKey];
        m_AdmobView.rootViewController = [GUILayout GetMainViewController];
        m_AdmobView.delegate = self;
        [self addSubview:m_AdmobView];
    }
    
    if(m_AdmobView728 == nil)
    {    
        m_AdmobView728 = [[[GADBannerView alloc] initWithFrame:CGRectMake((self.frame.size.width-728)/2.0, [GUILayout GetAdBannerHeight], 728, 90)] autorelease];
        m_AdmobView728.adUnitID = [AdConfiguration GetAdMobPublishKey];
        m_AdmobView728.rootViewController = [GUILayout GetMainViewController];
        m_AdmobView728.delegate = self;
        [self addSubview:m_AdmobView728];
    }    
}

-(void)PauseAd
{
    if(m_AdmobView != nil)
    {    
        m_AdmobView.rootViewController = nil;
        m_AdmobView.delegate = nil;
        [m_AdmobView removeFromSuperview];
        m_AdmobView = nil;
    }
    
    if(m_AdmobView728 == nil)
    {    
        m_AdmobView728.rootViewController = nil;
        m_AdmobView728.delegate = nil;
        [m_AdmobView728 removeFromSuperview];
        m_AdmobView728 = nil;
    }    
}

-(void)ResumeAd
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        [self InitiPhoneAddViews:NO];
    }
    else
    {
        [self InitiPadAddViews];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code.
        self.backgroundColor = [UIColor clearColor];
        if([ApplicationConfigure iPhoneDevice] == YES)
        {
            [self InitiPhoneAddViews:NO];
        }
        else
        {
            [self InitiPadAddViews];
        }
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)CloseAdView
{
    m_bClicked = NO;
    if([ApplicationConfigure iPhoneDevice])
    {
        CGRect rect = CGRectMake(0.0, [GUILayout GetAdBannerHeight], 320, 50);
        if(m_AdmobView)
            [m_AdmobView setFrame:rect];
    }
    else
    {
        CGRect rect = CGRectMake((self.frame.size.width-728)/2.0, [GUILayout GetAdBannerHeight], 728.0f, 90.0f);
        if(m_AdmobView728)
            [m_AdmobView728 setFrame:rect];
        rect = CGRectMake((self.frame.size.width-468)/2.0, [GUILayout GetAdBannerHeight], 468.0f, 60.0f);
        if(m_AdmobView)
            [m_AdmobView setFrame:rect];
    }
    if(m_Delegate)
    {
        [m_Delegate AdViewClosed:ADVIEW_TYPE_GOOGLE];
    }
    
}

-(void)OpenAdView
{
    m_bClicked = NO;
    if([ApplicationConfigure iPADDevice])
    {    
        if(m_AdmobView728)
        {    
            CGRect rect = CGRectMake((self.frame.size.width-728)/2.0, 0, 728.0f, 90.0f);
            [m_AdmobView728 setFrame:rect];
            [self bringSubviewToFront:m_AdmobView728];
        
            GADRequest *request = [GADRequest request];
            //if ([ApplicationConfigure HaveLocationData])
            //{
            //    [request setLocationWithLatitude:[ApplicationConfigure GetLatitude] longitude:[ApplicationConfigure GetLongitude] accuracy:200.0];
            //}
       
            [m_AdmobView728 loadRequest:request];
        }
        else
        {
            [self InitiPadAddViews];
        }
    }    
    else
    {    
        CGRect rect = CGRectMake(0.0f, 0, 320.0f, 50.0f);
        if(m_AdmobView)
        {    
            [m_AdmobView setFrame:rect];
            [self bringSubviewToFront:m_AdmobView];
            GADRequest *request = [GADRequest request];
            //if ([ApplicationConfigure HaveLocationData])
            //{
            //    [request setLocationWithLatitude:[ApplicationConfigure GetLatitude] longitude:[ApplicationConfigure GetLongitude] accuracy:200.0];
            //}
            [m_AdmobView loadRequest:request];
        }
        else
        {
            [self InitiPhoneAddViews:YES];
        }
    }    
    
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error 
{
    m_bClicked = NO;
    NSLog(@"admobView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    if([ApplicationConfigure iPADDevice])
    {    
        if(error != nil)
        {
            if(m_AdmobView728 == bannerView)
            {
                [self sendSubviewToBack:bannerView];
                CGRect rect = CGRectMake((self.frame.size.width-728)/2.0, [GUILayout GetAdBannerHeight], 728.0f, 90.0f);
                [m_AdmobView728 setFrame:rect];  
                GADRequest *request = [GADRequest request];
                //if ([ApplicationConfigure HaveLocationData])
                //{
                //    [request setLocationWithLatitude:[ApplicationConfigure GetLatitude] longitude:[ApplicationConfigure GetLongitude] accuracy:200.0];
                //}
                [m_AdmobView loadRequest:request];
            }
            if(m_AdmobView == bannerView)
            {
                [self CloseAdView];
            }
        }    
    }
    else
    {
        if(m_AdmobView == bannerView)
        {
            [self CloseAdView];
        }
    }

}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView 
{
    m_bClicked = NO;
	NSLog(@"GADBannerView AdView Loaded AD");
    if(m_Delegate)
    {
        [m_Delegate AdViewLoaded:ADVIEW_TYPE_MOBCLIX];
    }
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
	NSLog(@"Google ad View Will Touch Through");
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
	NSLog(@"Google ad View Finish Touch Through");
    GADRequest *request = [GADRequest request];
/*    if ([ApplicationConfigure HaveLocationData])
    {
        [request setLocationWithLatitude:[ApplicationConfigure GetLatitude] longitude:[ApplicationConfigure GetLongitude] accuracy:200.0];
    }*/
    [adView loadRequest:request];
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
	NSLog(@"Google ad View Popup!");
}
@end
