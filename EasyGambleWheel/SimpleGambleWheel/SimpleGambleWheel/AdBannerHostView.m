//
//  AdBannerHostView.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "AdBannerHostView.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "MainAppViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AmazonAd/AmazonAdView.h>
#import <AmazonAd/AmazonAdOptions.h>
#import <AmazonAd/AmazonAdError.h>

@import iAd;


@interface AdBannerHostView ()<GADBannerViewDelegate, ADBannerViewDelegate, AmazonAdViewDelegate>
{
    ADBannerView*                       m_AdView;
    GADBannerView*                      m_AdmobView;
    AmazonAdView*                       m_AmazonAdView;
    BOOL                                m_bHasIAd;
    BOOL                                m_bHasGoogleAd;
    BOOL                                m_bHasAmazonAd;
}

@end

#define DEFAULT_GOOGLE_ADBANNER_UNITID  @"xx-xxx-xx-xxxxxxxxxxxxxx/xxxxxxxxx"

@implementation AdBannerHostView

+(CGFloat)GetADBannerHeight
{
    CGFloat hRet = 50;
    
    if([ApplicationConfigure iPADDevice] == YES)
    {
        //if([GUILayout IsProtrait] == YES)
        //{
            hRet = 90;
        //}
    }
    else
    {
        hRet = 50;
    }
    
    return hRet;
}

- (GADRequest *)CreateGoogleRequest
{
    GADRequest *request = [GADRequest request];
    return request;
}

- (AmazonAdOptions*)CreateAmazonRequest
{
    AmazonAdOptions* options = [AmazonAdOptions options];
    //options.isTestRequest = NO;
    return options;
}

-(BOOL)HasAds
{
    return (m_bHasGoogleAd || ((m_AdView && m_AdView.bannerLoaded) || m_bHasIAd) || m_bHasAmazonAd);
}

-(void)UpdateAdBannerState
{
    [(MainAppViewController *)[GUILayout GetRootViewController] updateLayout];
}

-(void)ShowiAdView
{
    m_bHasIAd = YES;
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    float cx = w*0.5;
    float cy = h*0.5;
    m_AdView.center = CGPointMake(cx, cy);
    m_AdView.delegate = self;
    [self bringSubviewToFront:m_AdView];
    [self UpdateAdBannerState];
}

-(void)HideiAdView
{
    m_bHasIAd = NO;
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    float cx = w*0.5;
    float cy = h*(1.5);
    m_AdView.center = CGPointMake(cx, cy);
    [m_AdmobView loadRequest:[self CreateGoogleRequest]];
}

-(void)ShowAdmobView
{
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    float cx = w*0.5;
    float cy = h*0.5;
    m_AdmobView.center = CGPointMake(cx, cy);
    m_AdmobView.delegate = self;
    [m_AdmobView loadRequest:[self CreateGoogleRequest]];
}

-(void)HideAdmobView
{
    m_bHasGoogleAd = NO;
    [self sendSubviewToBack:m_AdmobView];
    [self UpdateAdBannerState];
}

-(void)ShowAmazonView
{
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    float cx = w*0.5;
    float cy = h*0.5;
    m_AmazonAdView.center = CGPointMake(cx, cy);
    m_AmazonAdView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleTopMargin;
    
    [m_AmazonAdView loadAd:[self CreateAmazonRequest]];
}

-(void)HideAmazonView
{
    m_bHasAmazonAd = NO;
    [self sendSubviewToBack:m_AmazonAdView];
    [self UpdateAdBannerState];
}



-(void)initAdmobBanner
{
    m_AdmobView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFluid];
    m_AdmobView.adUnitID = DEFAULT_GOOGLE_ADBANNER_UNITID;
    m_AdmobView.delegate = self;
    [m_AdmobView setRootViewController:[GUILayout GetRootViewController]];
    [self addSubview:m_AdmobView];
    [m_AdmobView loadRequest:[self CreateGoogleRequest]];
}


-(void)initiAdBanner
{
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)])
    {
        m_AdView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    }
    else
    {
        m_AdView = [[ADBannerView alloc] init];
    }
    m_AdView.delegate = self;
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    CGRect rect = CGRectMake(0, 0, w, h);
    [m_AdView setFrame:rect];
    [self addSubview:m_AdView];
}

-(void)initAmazonBanner
{
    if([ApplicationConfigure iPADDevice] == YES)
    {
        //if([GUILayout IsProtrait] == YES)
        //{
            m_AmazonAdView = [AmazonAdView amazonAdViewWithAdSize:AmazonAdSize_728x90];
        //}
        //else
        //{
        //    m_AmazonAdView = [AmazonAdView amazonAdViewWithAdSize:AmazonAdSize_1024x50];
        //}
    }
    else
    {
        m_AmazonAdView = [AmazonAdView amazonAdViewWithAdSize:AmazonAdSize_320x50];
        m_AmazonAdView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleTopMargin;
    }
    m_AmazonAdView.delegate = self;
    [self addSubview:m_AmazonAdView];
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    float cx = w*0.5;
    float cy = h*0.5;
    m_AmazonAdView.center = CGPointMake(cx, cy);
    m_AmazonAdView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleTopMargin;
    
    [m_AmazonAdView loadAd:[self CreateAmazonRequest]];
}

-(void)initAdBanners
{
    [self initAdmobBanner];
    [self initiAdBanner];
    [self initAmazonBanner];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_bHasIAd = NO;
        m_bHasGoogleAd = NO;
        m_bHasAmazonAd = NO;
        
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_AdmobView = nil;
        m_AmazonAdView = nil;
        [self initAdBanners];
        [self ShowiAdView];
        [self HideAdmobView];
        [self HideAmazonView];
    }
    return self;
}

-(void)DismissAdBanner
{
    m_AdmobView.delegate = nil;
    [m_AdmobView setRootViewController:nil];
    [m_AdmobView removeFromSuperview];
    m_AdView.delegate = nil;
    [m_AdView removeFromSuperview];
    m_AmazonAdView.delegate = nil;
    [m_AmazonAdView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)UpdateAmazonAdViewLayout
{
    /*???
    if([ApplicationConfigure iPADDevice] == YES)
    {
        [m_AmazonAdView removeFromSuperview];
        if([GUILayout IsProtrait] == YES)
        {
            m_AmazonAdView = [AmazonAdView amazonAdViewWithAdSize:AmazonAdSize_728x90];
        }
        else
        {
            m_AmazonAdView = [AmazonAdView amazonAdViewWithAdSize:AmazonAdSize_1024x50];
        }
        m_AmazonAdView.delegate = self;
        [self addSubview:m_AmazonAdView];
    }
    ???*/
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    float cx = w*0.5;
    float cy = h*0.5;
    m_AmazonAdView.center = CGPointMake(cx, cy);
    m_AmazonAdView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleTopMargin;
    
    //[m_AmazonAdView loadAd:[self CreateAmazonRequest]];
}

-(void)UpdateLayout
{
    CGFloat w = [GUILayout GetMainUIWidth]; //[NOMGUILayout GetAdBannerWidth];
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    //[self setFrame:CGRectMake(0, 0, w, h)];
    
    [m_AdmobView loadRequest:[self CreateGoogleRequest]];
    
    if(m_bHasIAd == NO)
    {
        float cx = w*0.5;
        float cy = h*(1.5);
        m_AdView.center = CGPointMake(cx, cy);
    }
    
    [self UpdateAmazonAdViewLayout];
    //[self UpdateAdBannerState];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self UpdateLayout];
}

//
//ADBannerViewDelegate methods
//
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    m_bHasIAd = NO;
    [self HideiAdView];
    [self ShowAdmobView];
    [self ShowAmazonView];
    [self UpdateAdBannerState];
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    if(banner && banner.bannerLoaded == YES)
    {
        m_bHasIAd = YES;
        [self ShowiAdView];
        [self HideAdmobView];
        [self HideAmazonView];

    }
    else
    {
        m_bHasIAd = NO;
        [self HideiAdView];
        [self ShowAdmobView];
        [self ShowAmazonView];
    }
    [self UpdateAdBannerState];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    m_bHasIAd = YES;
    [self ShowiAdView];
    [self HideAdmobView];
    [self HideAmazonView];
    [self UpdateAdBannerState];
}

//
//ADBannerViewDelegate methods
//
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    m_bHasGoogleAd = NO;
    [self HideAdmobView];
    [self ShowiAdView];
    [self ShowAmazonView];
    [self UpdateAdBannerState];
}

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    m_bHasGoogleAd = YES;
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    float cx = w*0.5;
    float cy = h*0.5;
    m_AdmobView.center = CGPointMake(cx, cy);
    [self bringSubviewToFront:m_AdmobView];
    [self UpdateAdBannerState];
}

//
//
// AmazonAdViewDelegate Methods
//
//
- (UIViewController *)viewControllerForPresentingModalView
{
    return [GUILayout GetRootViewController];
}

- (void)adViewDidCollapse:(AmazonAdView *)view
{
    [self ShowAdmobView];
    [self ShowAmazonView];
    [self UpdateAdBannerState];
}

- (void)adViewDidFailToLoad:(AmazonAdView *)view withError:(AmazonAdError *)error
{
    m_bHasAmazonAd = NO;
    [self HideAmazonView];
    [self ShowiAdView];
    [self ShowAdmobView];
    [self UpdateAdBannerState];
}

- (void)adViewDidLoad:(AmazonAdView *)view
{
    m_bHasAmazonAd = YES;
    CGFloat h = [AdBannerHostView GetADBannerHeight];
    CGFloat w = self.frame.size.width;
    float cx = w*0.5;
    float cy = h*0.5;
    m_AmazonAdView.center = CGPointMake(cx, cy);
    [self bringSubviewToFront:m_AmazonAdView];
    [self UpdateAdBannerState];
}

@end
