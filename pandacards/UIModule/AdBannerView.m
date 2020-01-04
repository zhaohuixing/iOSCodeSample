//
//  AdBannerView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "AdBannerView.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "GUIBasicConstant.h"
#import "GUIEventLoop.h"
#import "MainApplicationDelegateTemplate.h"

@implementation AdBannerView

-(void)ShowiPhoneBigBannerAd
{
    m_iPhoneBigAdViewMobclix.hidden = NO;   
    [self bringSubviewToFront:m_iPhoneBigAdViewMobclix];
    [m_iPhoneBigAdViewMobclix resumeAdAutoRefresh];
}

-(void)InitiPhoneAdViews
{
	m_iPhoneBigAdViewMobclix = [[[MobclixAdViewiPhone_300x250 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 250.0f)] autorelease];		
	m_iPhoneBigAdViewMobclix.delegate = self;
    [m_iPhoneBigAdViewMobclix getAd];
	[self addSubview:m_iPhoneBigAdViewMobclix];
	
	m_MobClixFS  = [[MobclixFullScreenAdViewController alloc] init];
	m_MobClixFS.delegate = self;
    m_bAutoHide = YES;
}

-(void)InitiPadAdViews
{
	m_iPadBigAdViewMobclix[0] = [[[MobclixAdViewiPad_300x250 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 250.0f)] autorelease];		
	m_iPadBigAdViewMobclix[0].delegate = self;
	[self addSubview:m_iPadBigAdViewMobclix[0]];
	
	m_iPadBigAdViewMobclix[1] = [[[MobclixAdViewiPad_300x250 alloc] initWithFrame:CGRectMake(300.0f, 0.0f, 300.0f, 250.0f)] autorelease];		
	m_iPadBigAdViewMobclix[1].delegate = self;
	[self addSubview:m_iPadBigAdViewMobclix[1]];
    [m_iPadBigAdViewMobclix[0] getAd];
    [m_iPadBigAdViewMobclix[1] getAd];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code.
        // Initialization code.
        self.backgroundColor = [UIColor clearColor];
        if([ApplicationConfigure iPhoneDevice] == YES)
        {
            [self InitiPhoneAdViews];
        }
        else
        {
            [self InitiPadAdViews];
        }
        m_AdmobView300x250[0] = nil;
        m_AdmobView300x250[1] = nil;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc 
{
    [super dealloc];
}


- (BOOL)adView:(MobclixAdView*)adView shouldHandleSuballocationRequest: (MCAdsSuballocationType)suballocationType
{
	return YES;
}	
 
- (NSString*)adView:(MobclixAdView*)adView publisherKeyForSuballocationRequest:(MCAdsSuballocationType)suballocationType
{
	return [ApplicationConfigure GetAdMobPublishKey];
}	
 
- (void)fullScreenAdViewControllerDidFinishLoad:(MobclixFullScreenAdViewController*)fullScreenAdViewController 
{
	NSLog(@"Full screen ad was loaded");
}

- (void)fullScreenAdViewController:(MobclixFullScreenAdViewController*)fullScreenAdViewController didFailToLoadWithError:(NSError*)error 
{
	NSLog(@"Failed to load full screen ad");
    m_bAutoHide = NO;
    [self ShowiPhoneBigBannerAd];
}

- (void)fullScreenAdViewControllerWillPresentAd:(MobclixFullScreenAdViewController*)fullScreenAdViewController 
{
	NSLog(@"Full screen ad will be presented");
}

- (void)fullScreenAdViewControllerDidDismissAd:(MobclixFullScreenAdViewController*)fullScreenAdViewController 
{
    [GUIEventLoop SendEvent:GUIID_FUNSCREENADDFINISH_EVENT eventSender:self]; 
}

- (void)adView:(MobclixAdView*)adView didFailLoadWithError:(NSError*)error
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        [GUIEventLoop SendEvent:GUIID_FUNSCREENADDFINISH_EVENT eventSender:self]; 
    }
    else
    {
        if(m_iPadBigAdViewMobclix[0] == adView)
        {
            [self sendSubviewToBack:m_iPadBigAdViewMobclix[0]];
            
            m_AdmobView300x250[0] = [[[GADBannerView alloc] initWithFrame:m_iPadBigAdViewMobclix[0].frame] autorelease];
            m_AdmobView300x250[0].adUnitID = [ApplicationConfigure GetAdMobPublishKey];
            m_AdmobView300x250[0].rootViewController = [GUILayout GetMainViewController];
            m_AdmobView300x250[0].delegate = self;
            [self addSubview:m_AdmobView300x250[0]];
            [m_AdmobView300x250[0] loadRequest:[GADRequest request]];
        }
        if(m_iPadBigAdViewMobclix[1] == adView)
        {
            [self sendSubviewToBack:m_iPadBigAdViewMobclix[1]];
            
            m_AdmobView300x250[1] = [[[GADBannerView alloc] initWithFrame:m_iPadBigAdViewMobclix[1].frame] autorelease];
            m_AdmobView300x250[1].adUnitID = [ApplicationConfigure GetAdMobPublishKey];
            m_AdmobView300x250[1].rootViewController = [GUILayout GetMainViewController];
            m_AdmobView300x250[1].delegate = self;
            [self addSubview:m_AdmobView300x250[1]];
            [m_AdmobView300x250[1] loadRequest:[GADRequest request]];
        }
    }
}


-(BOOL)CanAutoHide
{
    if([ApplicationConfigure iPhoneDevice])
    {
        return m_bAutoHide;
    }
    else
    {
        return NO;
    }
}

-(void)ShowAd
{
    if([ApplicationConfigure iPhoneDevice])
    {
        [self ShowiPhoneAd];
    }
    else
    {
        [self ShowiPadAd];
    }
}

-(void)HideAd
{
    if([ApplicationConfigure iPhoneDevice])
    {    
        [self HideiPhoneAd];
    }
    else
    {
        [self HideiPadAd];
    }
}

-(void)ShowiPhoneAd
{
    m_bAutoHide = NO;
    UIViewController* parent = [GUILayout GetMainViewController];
    if(parent)
    {
        m_iPhoneBigAdViewMobclix.hidden = YES;    
        [m_MobClixFS requestAndDisplayAdFromViewController:parent];
        m_bAutoHide = YES;
    }
    if(m_bAutoHide == NO)
    {
        [self ShowiPhoneBigBannerAd];
    }
}

-(void)ShowiPadAd
{
    [m_iPadBigAdViewMobclix[0] resumeAdAutoRefresh];
    [m_iPadBigAdViewMobclix[1] resumeAdAutoRefresh];
}

-(void)HideiPhoneAd
{
    [m_iPhoneBigAdViewMobclix pauseAdAutoRefresh];
}

-(void)HideiPadAd
{
    [m_iPadBigAdViewMobclix[0] pauseAdAutoRefresh];
    [m_iPadBigAdViewMobclix[1] pauseAdAutoRefresh];
    if(m_AdmobView300x250[0] != nil)
    {
        [m_AdmobView300x250[0] removeFromSuperview];
        m_AdmobView300x250[0] = nil;
    }
    if(m_AdmobView300x250[1] != nil)
    {
        [m_AdmobView300x250[1] removeFromSuperview];
        m_AdmobView300x250[1] = nil;
    }
}

-(void)ResumeAd
{
    if(self.hidden == YES)
        return;
    
    if([ApplicationConfigure iPhoneDevice])
    {    
        [m_iPhoneBigAdViewMobclix resumeAdAutoRefresh];
    }
    else
    {
        [m_iPadBigAdViewMobclix[0] resumeAdAutoRefresh];
        [m_iPadBigAdViewMobclix[1] resumeAdAutoRefresh];
    }
}

-(void)PauseAd
{
    if([ApplicationConfigure iPhoneDevice])
    {    
        [m_iPhoneBigAdViewMobclix pauseAdAutoRefresh];
    }
    else
    {
        [m_iPadBigAdViewMobclix[0] pauseAdAutoRefresh];
        [m_iPadBigAdViewMobclix[1] pauseAdAutoRefresh];
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error 
{
    NSLog(@"admobView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    if(m_AdmobView300x250[0] == bannerView)
    {
        [m_AdmobView300x250[0] removeFromSuperview];
        m_AdmobView300x250[0] = nil;
        [m_iPadBigAdViewMobclix[0] resumeAdAutoRefresh];
    }
    if(m_AdmobView300x250[1] == bannerView)
    {
        [m_AdmobView300x250[1] removeFromSuperview];
        m_AdmobView300x250[1] = nil;
        [m_iPadBigAdViewMobclix[1] resumeAdAutoRefresh];
    }
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView 
{
}

- (void)adViewWillTouchThrough:(MobclixAdView*)adView 
{
	NSLog(@"Ad Will Touch Through: %@.", NSStringFromCGSize(adView.frame.size));
    [ApplicationConfigure SetMobclixAdviewType];
    id<AdRequestHandlerDelegate> pDelegate = (id<AdRequestHandlerDelegate>)[GUILayout GetMainViewController];
    if(pDelegate != nil)
    {
        [pDelegate AdViewClicked];
    }
}

- (void)adViewDidFinishTouchThrough:(MobclixAdView*)adView {
	NSLog(@"Ad Did Finish Touch Through: %@.", NSStringFromCGSize(adView.frame.size));
    [adView getAd];
    [ApplicationConfigure ClearAdViewType];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
	NSLog(@"Google ad View Will Touch Through");
    [ApplicationConfigure SetGoogleAdviewType];
    id<AdRequestHandlerDelegate> pDelegate = (id<AdRequestHandlerDelegate>)[GUILayout GetMainViewController];
    if(pDelegate != nil)
    {
        [pDelegate AdViewClicked];
    }
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
	NSLog(@"Google ad View Finish Touch Through");
    [ApplicationConfigure ClearAdViewType];
}

@end
