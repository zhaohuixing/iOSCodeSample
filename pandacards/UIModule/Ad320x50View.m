//
//  Ad320x50View.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "Ad320x50View.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "MainApplicationDelegateTemplate.h"

@implementation Ad320x50iPhoneMixedView

/*
{
	//iPhone
    MobclixAdViewiPhone_320x50*		m_iPhoneAdViewMobclix;  //Mobclix adview
    MobFoxBannerView*               m_iPhoneAdViewMobFox;   //MobFox adview
}

-(void)ResumeAd;
-(void)PauseAd;
 
*/ 
- (id)initWithFrame:(CGRect)frame enableMobFox:(BOOL)bEnable 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
        self.backgroundColor = [UIColor clearColor];
        
        m_iPhoneAdViewMobclix = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)] autorelease];		
        m_iPhoneAdViewMobclix.delegate = self;
        [m_iPhoneAdViewMobclix getAd];
        [self addSubview:m_iPhoneAdViewMobclix];
        
        if(bEnable)
        {    
            m_iPhoneAdViewMobFox = [[MobFoxBannerView alloc] initWithFrame:
                                        CGRectMake(0, 0, 320, 50)];
            m_iPhoneAdViewMobFox.delegate = self;  // triggers ad loading
            m_iPhoneAdViewMobFox.backgroundColor = [UIColor darkGrayColor]; // fill horizontally
            m_iPhoneAdViewMobFox.refreshAnimation = UIViewAnimationTransitionCurlDown;
            [self addSubview:m_iPhoneAdViewMobFox];
        }
        else
        {
            m_iPhoneAdViewMobFox = nil;
        }
    }
    return self;
}

- (void)dealloc 
{
    [m_iPhoneAdViewMobclix pauseAdAutoRefresh];
    m_iPhoneAdViewMobclix.delegate = nil;
    if(m_iPhoneAdViewMobFox)
    {    
        m_iPhoneAdViewMobFox.delegate = nil;
    }
    [super dealloc];
}


-(void)ResumeAd
{
    [m_iPhoneAdViewMobclix resumeAdAutoRefresh];
}

-(void)PauseAd
{
    [m_iPhoneAdViewMobclix pauseAdAutoRefresh];
}

-(void)StopAd
{
    [m_iPhoneAdViewMobclix pauseAdAutoRefresh];
    m_iPhoneAdViewMobclix.delegate = nil;
    if(m_iPhoneAdViewMobFox)
    {    
        m_iPhoneAdViewMobFox.delegate = nil;
    }
}

- (BOOL)adView:(MobclixAdView*)adView shouldHandleSuballocationRequest: (MCAdsSuballocationType)suballocationType
{
	return YES;
}	

- (NSString*)adView:(MobclixAdView*)adView publisherKeyForSuballocationRequest:(MCAdsSuballocationType)suballocationType
{
	return [ApplicationConfigure GetAdMobPublishKey];
}	


- (NSString *)publisherIdForMobFoxBannerView:(MobFoxBannerView *)banner
{
	return [ApplicationConfigure GetMobFoxPublishKey];
}

- (void)mobfoxBannerViewDidLoadMobFoxAd:(MobFoxBannerView *)banner
{
	NSLog(@"MobFox: did load ad");
	
	// animate banner into view
    [self bringSubviewToFront:m_iPhoneAdViewMobFox];
    [m_iPhoneAdViewMobclix pauseAdAutoRefresh];
}

- (void)mobfoxBannerView:(MobFoxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	NSLog(@"MobFox: did fail to load ad: %@", [error localizedDescription]);
	
	// animate banner outside view
    [m_iPhoneAdViewMobclix resumeAdAutoRefresh];
    [self bringSubviewToFront:m_iPhoneAdViewMobclix];
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


@implementation Ad320x50View


-(void)InitiPhoneAddViews:(BOOL)bEnable
{
	m_iPhoneAdViewMobclix1 = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)] autorelease];		
	m_iPhoneAdViewMobclix1.delegate = self;
    [m_iPhoneAdViewMobclix1 getAd];
	[self addSubview:m_iPhoneAdViewMobclix1];

	m_iPhoneAdViewMobclix2 = [[[Ad320x50iPhoneMixedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)enableMobFox:bEnable] autorelease];		
	[self addSubview:m_iPhoneAdViewMobclix2];
}

-(void)InitiPadAddViews
{
	m_iPadAdViewMobclix2 = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 728.0f, 90.0f)] autorelease];		
	m_iPadAdViewMobclix2.delegate = self;
    [m_iPadAdViewMobclix2 getAd];
	[self addSubview:m_iPadAdViewMobclix2];
	m_iPadAdViewMobclix1 = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 728.0f, 90.0f)] autorelease];		
	m_iPadAdViewMobclix1.delegate = self;
    [m_iPadAdViewMobclix1 getAd];
	[self addSubview:m_iPadAdViewMobclix1];
}


-(id)initAdViewWithFrame:(CGRect)frame enableMobFox:(BOOL)bEnable
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
        self.backgroundColor = [UIColor clearColor];//[UIColor greenColor];
        if([ApplicationConfigure iPhoneDevice] == YES)
        {
            [self InitiPhoneAddViews:bEnable];
        }
        else
        {
            [self InitiPadAddViews];
        }
        [self OnOrientationChange];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
        self.backgroundColor = [UIColor clearColor];//[UIColor greenColor];
        if([ApplicationConfigure iPhoneDevice] == YES)
        {
            [self InitiPhoneAddViews:NO];
        }
        else
        {
            [self InitiPadAddViews];
        }
        m_AdmobView468_1 = nil;
        m_AdmobView468_2 = nil;
        m_AdmobView728_1 = nil;
        m_AdmobView728_2 = nil;

        [self OnOrientationChange];
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
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        [m_iPhoneAdViewMobclix2 StopAd];
    }
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

-(void)OnOrientationChange
{
    float cy = self.frame.size.height/2;
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        float cx = self.frame.size.width-160;
        [m_iPhoneAdViewMobclix2 setCenter:CGPointMake(cx, cy)];
        [m_iPhoneAdViewMobclix1 setCenter:CGPointMake(160, cy)];
    }
    else
    {
        float cx = self.frame.size.width-364;
        if(m_iPadAdViewMobclix2 != nil)
            [m_iPadAdViewMobclix2  setCenter:CGPointMake(cx, cy)];
        if(m_iPadAdViewMobclix1 != nil)
            [m_iPadAdViewMobclix1  setCenter:CGPointMake(364, cy)];

        if(m_AdmobView728_1 != nil)
            [m_AdmobView728_1 setCenter:CGPointMake(cx, cy)];
            
        if(m_AdmobView728_2 != nil)
            [m_AdmobView728_2  setCenter:CGPointMake(364, cy)];
        
         
        cx = self.frame.size.width-234;
        if(m_iPadSmallAdViewMobclix1 != nil)
            [m_iPadSmallAdViewMobclix1  setCenter:CGPointMake(234, cy)];
        
        if(m_iPadSmallAdViewMobclix2 != nil)
            [m_iPadSmallAdViewMobclix2  setCenter:CGPointMake(cx, cy)];
        
        if(m_AdmobView468_1 != nil)
            [m_AdmobView468_1  setCenter:CGPointMake(234, cy)];
        if(m_AdmobView468_2 != nil)
            [m_AdmobView468_2  setCenter:CGPointMake(cx, cy)];
        
    }

}

-(void)ResumeAd
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        [m_iPhoneAdViewMobclix1 resumeAdAutoRefresh];
        [m_iPhoneAdViewMobclix2 ResumeAd];
    }
    else
    {
        if(m_iPadAdViewMobclix1 != nil)
            [m_iPadAdViewMobclix1  resumeAdAutoRefresh];
        if(m_iPadAdViewMobclix2 != nil)
            [m_iPadAdViewMobclix2  resumeAdAutoRefresh];
   
        if(m_iPadSmallAdViewMobclix1 != nil)
            [m_iPadSmallAdViewMobclix1  resumeAdAutoRefresh];
        
        if(m_iPadSmallAdViewMobclix2 != nil)
            [m_iPadSmallAdViewMobclix2  resumeAdAutoRefresh];
    
    }
}

-(void)PauseAd
{
    if([ApplicationConfigure iPhoneDevice] == YES)
    {
        [m_iPhoneAdViewMobclix2 PauseAd];
        [m_iPhoneAdViewMobclix1 pauseAdAutoRefresh];
    }
    else
    {
        if(m_iPadAdViewMobclix2 != nil)
            [m_iPadAdViewMobclix2  pauseAdAutoRefresh];
        
        if(m_iPadAdViewMobclix1 != nil)
            [m_iPadAdViewMobclix1  pauseAdAutoRefresh];
    
        if(m_iPadSmallAdViewMobclix1 != nil)
            [m_iPadSmallAdViewMobclix1  pauseAdAutoRefresh];
            
        if(m_iPadSmallAdViewMobclix2 != nil)
            [m_iPadSmallAdViewMobclix2  pauseAdAutoRefresh];
    }
}

- (void)adView:(MobclixAdView*)adView didFailLoadWithError:(NSError*)error
{
    NSLog(@"mobclixView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    if(error != nil)
    {
        if(m_iPadAdViewMobclix1 == adView)
        {
            [m_iPadAdViewMobclix1 removeFromSuperview];
            m_iPadAdViewMobclix1 = nil;
        
            m_iPadSmallAdViewMobclix1 = [[[MobclixAdViewiPad_468x60 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 468.0f, 60.0f)] autorelease];		
            m_iPadSmallAdViewMobclix1.delegate = self;
            [m_iPadSmallAdViewMobclix1 getAd];
            [self addSubview:m_iPadSmallAdViewMobclix1];
        
            
        }
        if(m_iPadAdViewMobclix2 == adView)
        {
            [m_iPadAdViewMobclix2 removeFromSuperview];
            m_iPadAdViewMobclix2 = nil;
            
            m_iPadSmallAdViewMobclix2 = [[[MobclixAdViewiPad_468x60 alloc] initWithFrame:CGRectMake(self.frame.size.width-468, 0.0f, 468.0f, 60.0f)] autorelease];		
            m_iPadSmallAdViewMobclix2.delegate = self;
            [m_iPadSmallAdViewMobclix2 getAd];
            [self addSubview:m_iPadSmallAdViewMobclix2];
        }
        if(m_iPadSmallAdViewMobclix1 == adView)
        {
            [m_iPadSmallAdViewMobclix1 removeFromSuperview];
            m_iPadSmallAdViewMobclix1 = nil;
         
            m_AdmobView468_1 = [[[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 468, 60)] autorelease];
            m_AdmobView468_1.adUnitID = [ApplicationConfigure GetAdMobPublishKey];
            m_AdmobView468_1.rootViewController = [GUILayout GetMainViewController];
            m_AdmobView468_1.delegate = self;
            [self addSubview:m_AdmobView468_1];
            [m_AdmobView468_1 loadRequest:[GADRequest request]];
        }
        if(m_iPadSmallAdViewMobclix2 == adView)
        {
            [m_iPadSmallAdViewMobclix2 removeFromSuperview];
            m_iPadSmallAdViewMobclix2 = nil;
            
            m_AdmobView468_2 = [[[GADBannerView alloc] initWithFrame:CGRectMake(self.frame.size.width-468, 0.0, 468, 60)] autorelease];
            m_AdmobView468_2.adUnitID = [ApplicationConfigure GetAdMobPublishKey];
            m_AdmobView468_2.rootViewController = [GUILayout GetMainViewController];
            m_AdmobView468_2.delegate = self;
            [self addSubview:m_AdmobView468_2];
            [m_AdmobView468_2 loadRequest:[GADRequest request]];
        }
        
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error 
{
    NSLog(@"admobView:didFailToReceiveAdWithError:%@", [error localizedDescription]);

    if(m_AdmobView468_1 == bannerView)
    {
        [m_AdmobView468_1 removeFromSuperview];
        m_AdmobView468_1 = nil;
        
        m_AdmobView728_1 = [[[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 728, 90)] autorelease];
        m_AdmobView728_1.adUnitID = [ApplicationConfigure GetAdMobPublishKey];
        m_AdmobView728_1.rootViewController = [GUILayout GetMainViewController];
        m_AdmobView728_1.delegate = self;
        [self addSubview:m_AdmobView728_1];
        [m_AdmobView728_1 loadRequest:[GADRequest request]];
    }
    if(m_AdmobView468_2 == bannerView)
    {
        [m_AdmobView468_2 removeFromSuperview];
        m_AdmobView468_2 = nil;
        
        m_AdmobView728_2 = [[[GADBannerView alloc] initWithFrame:CGRectMake(self.frame.size.width-728, 0.0, 728, 90)] autorelease];
        m_AdmobView728_2.adUnitID = [ApplicationConfigure GetAdMobPublishKey];
        m_AdmobView728_2.rootViewController = [GUILayout GetMainViewController];
        m_AdmobView728_2.delegate = self;
        [self addSubview:m_AdmobView728_1];
        [m_AdmobView728_2 loadRequest:[GADRequest request]];
    }
    if(m_AdmobView728_1 == bannerView)
    {
        [m_AdmobView728_1 removeFromSuperview];
        m_AdmobView728_1 = nil;
        
        m_iPadAdViewMobclix1 = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 728.0f, 90.0f)] autorelease];		
        m_iPadAdViewMobclix1.delegate = self;
        [m_iPadAdViewMobclix1 getAd];
        [self addSubview:m_iPadAdViewMobclix1];
    }
    if(m_AdmobView728_2 == bannerView)
    {
        [m_AdmobView728_2 removeFromSuperview];
        m_AdmobView728_2 = nil;
        
        m_iPadAdViewMobclix2 = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(self.frame.size.width-728, 0.0f, 728.0f, 90.0f)] autorelease];		
        m_iPadAdViewMobclix2.delegate = self;
        [m_iPadAdViewMobclix2 getAd];
        [self addSubview:m_iPadAdViewMobclix2];
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
