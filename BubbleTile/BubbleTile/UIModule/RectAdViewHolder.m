//
//  RectAdViewHolder.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "RectAdViewHolder.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "StringFactory.h"

@implementation RectAdViewHolder

@synthesize m_Delegate;

-(void)ShowSpinner
{
    [self bringSubviewToFront:m_Spinner];
    m_Spinner.hidden = NO;
    [m_Spinner sizeToFit];
    [m_Spinner startAnimating];
}

-(void)HideSpinner
{
    [m_Spinner stopAnimating];
    m_Spinner.hidden = YES;
}

-(void)ShowClickToEarnText
{
//    [m_Label setTextColor:[UIColor darkTextColor]];
//    [m_Label setText:[StringFactory GetString_ClickToEarn]];
//    m_bShowCongratulation = NO;
}

-(void)ShowCongratulationText
{
//    [m_Label setTextColor:[UIColor yellowColor]];
//    [m_Label setText:[StringFactory GetString_Congratulation]];
//    m_bShowCongratulation = YES;
//    m_TimeStartShowCongratulation = [[NSProcessInfo processInfo] systemUptime];
    //[self TryNextAdUnit];
}

-(void)InitMobclixUnit
{
    if(m_MobclixAd == nil)
    {
        if([ApplicationConfigure iPhoneDevice])
        {   
            m_MobclixAd = [[[MobclixAdViewiPhone_300x250 alloc] initWithFrame:CGRectMake(0.0f, 0, 300.0f, 250.0f)] autorelease];
        }
        else
        {
            m_MobclixAd = [[[MobclixAdViewiPad_300x250 alloc] initWithFrame:CGRectMake(0.0f, 0, 300.0f, 250.0f)] autorelease];
        }
        m_MobclixAd.delegate = self;
        [m_MobclixAd pauseAdAutoRefresh];
        [self addSubview:m_MobclixAd];
    }   
}

-(void)InitGoogleUnit
{
    if(m_GoogleAd == nil)
    {    
        m_GoogleAd = [[[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 250)] autorelease];
        m_GoogleAd.adUnitID = [ApplicationConfigure GetAdMobPublishKey];
        m_GoogleAd.rootViewController = [GUILayout GetMainViewController];
        m_GoogleAd.delegate = self;
        [self addSubview:m_GoogleAd];
    }    
}

-(void)InitAdUnits
{
    m_nPrevAdType = ADVIEW_TYPE_MOBCLIX;//ADVIEW_TYPE_NONE;
    [self InitMobclixUnit];
    [self InitGoogleUnit];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self InitAdUnits];
/*        float h = [GUILayout GetFullScreenAdLabelHeight];
        CGRect rect = CGRectMake(0, frame.size.height-h, frame.size.width, h);
		m_Label = [[UILabel alloc] initWithFrame:rect];
		m_Label.backgroundColor = [UIColor clearColor];
		[m_Label setTextColor:[UIColor darkTextColor]];
		m_Label.font = [UIFont fontWithName:@"Times New Roman" size:[GUILayout GetFullScreenAdLabelFont]];
        [m_Label setTextAlignment:UITextAlignmentCenter];
        m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label.adjustsFontSizeToFitWidth = YES;
		[m_Label setText:[StringFactory GetString_ClickToEarn]];
		[self addSubview:m_Label];
		[m_Label release];*/
        m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:m_Spinner];
        [m_Spinner release];
        m_Spinner.center = CGPointMake(frame.size.width/2, 0);
        m_bAdViewIdle = NO;
    }
    return self;
}

-(void)dealloc
{
    if(m_MobclixAd != nil)
    {
        [m_MobclixAd pauseAdAutoRefresh];
        m_MobclixAd.delegate = nil;
    }   
    if(m_GoogleAd != nil)
    {    
        m_GoogleAd.rootViewController = nil;
        m_GoogleAd.delegate = nil;
     }    
    [super dealloc];
}

-(void)AdLoadFailed
{
    if(m_Delegate)
        [m_Delegate AdViewFailed];
}

-(void)ShowMobclixAd
{
    if(m_MobclixAd == nil)
    {
        [self InitMobclixUnit];
    }
    
	[m_MobclixAd getAd];
    [self bringSubviewToFront:m_MobclixAd];
    [self ShowSpinner];
}

-(void)ShowGoogleAd
{
    if(m_GoogleAd == nil)
    {   
        [self InitGoogleUnit];
    }
    
    GADRequest *request = [GADRequest request];
	//if ([ApplicationConfigure HaveLocationData])
	//{
    //    [request setLocationWithLatitude:[ApplicationConfigure GetLatitude] longitude:[ApplicationConfigure GetLongitude] accuracy:200.0];
	//}
    m_GoogleAd.adUnitID = [ApplicationConfigure GetAdMobPublishKey];
    m_GoogleAd.rootViewController = [GUILayout GetMainViewController];
    m_GoogleAd.delegate = self;
    [m_GoogleAd loadRequest: request];
    [self bringSubviewToFront:m_GoogleAd];
    [self ShowSpinner];
}

-(void)ShowAd:(int)nType
{
    switch(nType)
    {
        case ADVIEW_TYPE_MOBCLIX:
            m_bAdViewIdle = NO;
            m_TimeStartLoadAd = [[NSProcessInfo processInfo] systemUptime];
            [self ShowMobclixAd];
            break;
        case ADVIEW_TYPE_GOOGLE:
            m_bAdViewIdle = NO;
            m_TimeStartLoadAd = [[NSProcessInfo processInfo] systemUptime];
            [self ShowGoogleAd];
            break;
    }
}

-(void)TryNextAdUnit
{
    /*if(m_nPrevAdType == m_nCurrentType)
    {
        [self AdLoadFailed];
        return;    
    }*/
    if(m_nCurrentType == ADVIEW_TYPE_MOBCLIX)
    {
        m_nCurrentType = ADVIEW_TYPE_GOOGLE;
        m_bStartLoadAd = YES;
    }
    else if(m_nCurrentType == ADVIEW_TYPE_GOOGLE)
    {
        m_nCurrentType = ADVIEW_TYPE_MOBCLIX;
        m_bStartLoadAd = YES;
    }
    [self ShowAd:m_nCurrentType];
}

-(void)StartShowAd
{
    if(m_nPrevAdType == ADVIEW_TYPE_MOBCLIX)
    {
        m_nCurrentType = ADVIEW_TYPE_GOOGLE;
        m_bStartLoadAd = YES;
    }
    else if(m_nPrevAdType == ADVIEW_TYPE_GOOGLE || m_nPrevAdType == ADVIEW_TYPE_NONE)
    {
        m_nCurrentType = ADVIEW_TYPE_MOBCLIX;
        m_bStartLoadAd = YES;
    }
    [self ShowAd:m_nCurrentType];
}

-(void)OnTimerEvent
{
    NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
/*    if(m_bShowCongratulation)
    {
        if(CONGRATULATION_SHOW_TIME <= (currentTime - m_TimeStartShowCongratulation))
            [self ShowClickToEarnText];
    }*/
    NSTimeInterval tTime = currentTime - m_TimeStartLoadAd;
    if(REDEEMADVIEW_IDLE_TIME <= tTime)
    {
        if(m_bAdViewIdle && m_bStartLoadAd)
        {
            [self TryNextAdUnit];
            return;
        }
    }
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
    [self HideSpinner];
    [self PauseAd];
    //[m_MobclixAd pauseAdAutoRefresh];
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}

-(void)OpenAdView
{
    //[m_MobclixAd resumeAdAutoRefresh];
    m_bGoogleAdClicked = NO;
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    [self StartShowAd];
    [self ShowClickToEarnText];
}

/*
//
//GADBannerViewDelegate method
// 
*/ 
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error 
{
    [self HideSpinner];
    NSLog(@"300x250 admobView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    m_bGoogleAdClicked = NO;
    [self TryNextAdUnit];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView 
{
    [self HideSpinner];
	NSLog(@"300x250 GADBannerView AdView Loaded AD");
    if(m_Delegate)
    {
        [m_Delegate AdViewLoaded:ADVIEW_TYPE_GOOGLE];
    }
    if(m_nCurrentType == ADVIEW_TYPE_GOOGLE)
    {    
        m_bAdViewIdle = YES;
        m_bStartLoadAd = NO;
    }    
    m_bGoogleAdClicked = NO;
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    [self HideSpinner];
	NSLog(@"300x250 Google ad View Will Touch Through");
    if(m_Delegate)
    {    
        [ApplicationConfigure SetModalPresentAccountable];
        [m_Delegate AdViewClicked:ADVIEW_TYPE_GOOGLE];
        [self TryNextAdUnit];
    }    
    m_bGoogleAdClicked = YES;
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    [self HideSpinner];
	NSLog(@"300x250 Google ad View Finish Touch Through");
    //[adView loadRequest:[GADRequest request]];
    [ApplicationConfigure ClearModalPresentAccountable];
    m_bGoogleAdClicked = NO;
    if(m_Delegate)
    {    
        [m_Delegate AdViewClicked:ADVIEW_TYPE_GOOGLE];
    }    
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    [self HideSpinner];
	NSLog(@"300x250 Google ad View Popup!");
    if(m_bGoogleAdClicked == NO && self.hidden == NO)
    {    
        if(m_Delegate)
        {    
            [ApplicationConfigure SetModalPresentAccountable];
            //[m_Delegate AdViewClicked:ADVIEW_TYPE_GOOGLE];
            [self TryNextAdUnit];
        }    
    }    
}


/*
//
//MobclixAdViewDelegate methods
// 
*/
- (BOOL)adView:(MobclixAdView*)adView shouldHandleSuballocationRequest: (MCAdsSuballocationType)suballocationType
{
	return YES;
}	

- (NSString*)adView:(MobclixAdView*)adView publisherKeyForSuballocationRequest:(MCAdsSuballocationType)suballocationType
{
	return [ApplicationConfigure GetAdMobPublishKey];
}	

- (void)adView:(MobclixAdView*)adView didFailLoadWithError:(NSError*)error
{
    [self HideSpinner];
    NSLog(@"mobclixView320x250:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    [self TryNextAdUnit];
}

- (void)adViewDidFinishLoad:(MobclixAdView*)adView
{
    [self HideSpinner];
	NSLog(@"300x250 Mobclix AdView Loaded AD");
    if(m_Delegate)
    {
        [m_Delegate AdViewLoaded:ADVIEW_TYPE_MOBCLIX];
    }
    if(m_nCurrentType == ADVIEW_TYPE_MOBCLIX)
    {    
        m_bAdViewIdle = YES;
        m_bStartLoadAd = NO;
    }    
}

- (void)adViewWillTouchThrough:(MobclixAdView*)adView 
{
    [self HideSpinner];
	NSLog(@"Ad Will Touch Through: %@.", NSStringFromCGSize(adView.frame.size));
    if(m_Delegate)
    {    
        [ApplicationConfigure SetModalPresentAccountable];
        [m_Delegate AdViewClicked:ADVIEW_TYPE_MOBCLIX];
        [self TryNextAdUnit];
    }    
}

- (void)adViewDidFinishTouchThrough:(MobclixAdView*)adView 
{
    [self HideSpinner];
	NSLog(@"Ad Did Finish Touch Through: %@.", NSStringFromCGSize(adView.frame.size));
    [ApplicationConfigure ClearModalPresentAccountable];
    if(self.hidden == NO)
        [adView getAd];
    /*if(m_Delegate)
    {    
        [m_Delegate AdViewClicked:ADVIEW_TYPE_MOBCLIX];
    } */   
}

-(void)PauseAd
{
    if(m_MobclixAd != nil)
    {
        [m_MobclixAd pauseAdAutoRefresh];
        m_MobclixAd.delegate = nil;
        [m_MobclixAd removeFromSuperview];
        m_MobclixAd = nil;
    }   
    if(m_GoogleAd != nil)
    {    
        m_GoogleAd.rootViewController = nil;
        m_GoogleAd.delegate = nil;
        [m_GoogleAd removeFromSuperview];
        m_GoogleAd = nil;
    }    
    
}

-(void)ResumeAd
{
    [self InitAdUnits];
    if(m_MobclixAd != nil)
    {
        [m_MobclixAd resumeAdAutoRefresh];
    }   
}

@end
