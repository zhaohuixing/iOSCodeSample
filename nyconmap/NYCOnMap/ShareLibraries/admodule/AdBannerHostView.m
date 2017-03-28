//
//  AdBannerHostView.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "AdBannerHostView.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "NOMAppDelegate.h"

@implementation AdBannerHostView


-(void)HideiAdView
{
    m_bShowIAD = NO;
    CGFloat h = [NOMGUILayout GetAdBannerHeight];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    float cx = w*0.5;
    float cy = h*(-0.5);
    m_AdView.center = CGPointMake(cx, cy);
}

-(void)ShowAdmobView
{
    CGFloat h = [NOMGUILayout GetAdBannerHeight];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    float cx = w*0.5;
    float cy = h*0.5;
    m_AdmobView.center = CGPointMake(cx, cy);
    m_AdmobView.delegate = self;
    [m_AdmobView setRootViewController:[NOMGUILayout GetRootViewController]];
    [m_AdmobView loadRequest:[self CreateGoogleRequest]];
}

-(void)HideAdmobView
{
    CGFloat h = [NOMGUILayout GetAdBannerHeight];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    float cx = w*0.5;
    float cy = h*(-0.5);
    m_AdmobView.center = CGPointMake(cx, cy);
}

-(void)ShowiAdView
{
    m_bShowIAD = YES;
    CGFloat h = [NOMGUILayout GetiADBannerHeight];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    float cx = w*0.5;
    float cy = h*0.5;
    m_AdView.center = CGPointMake(cx, cy);
}

- (GADRequest *)CreateGoogleRequest
{
    GADRequest *request = [GADRequest request];
    [request setLocationWithLatitude:[NOMAppInfo GetAppLatitude] longitude:[NOMAppInfo GetAppLongitude] accuracy:[NOMAppInfo GetGoogleADAccuracy]];
    return request;
}

-(void)initAdmobBanner
{
    if([NOMGUILayout IsLandscape] == YES)
        m_AdmobView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    else
        m_AdmobView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];

    m_AdmobView.adUnitID = [NOMAppInfo GetGoogleADUnitID];
    m_AdmobView.delegate = self;
    [m_AdmobView setRootViewController:[NOMGUILayout GetRootViewController]];
    [self addSubview:m_AdmobView];
    [m_AdmobView loadRequest:[self CreateGoogleRequest]];
}

-(void)initiAdBanner
{
    m_AdView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];

    m_AdView.delegate = self;
    
    CGFloat h = [NOMGUILayout GetiADBannerHeight];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGRect rect = CGRectMake(0, 0, w, h);
    [m_AdView setFrame:rect];
    
    [self addSubview:m_AdView];
}

-(void)initAdBanners
{
    [self initAdmobBanner];
    [self initiAdBanner];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_bShowIAD = NO;
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_AdmobView = nil;
        [self initAdBanners];
        [self ShowiAdView];
        [self HideAdmobView];
    }
    return self;
}

-(void)UpdateLayout
{
    CGFloat w = [NOMGUILayout GetLayoutWidth]; //[NOMGUILayout GetAdBannerWidth];
    CGFloat h = [NOMGUILayout GetAdBannerHeight];
    [self setFrame:CGRectMake(0, 0, w, h)];
    
    if(m_AdmobView != nil)
    {
        if([NOMGUILayout IsLandscape] == YES)
            m_AdmobView.adSize = kGADAdSizeSmartBannerLandscape;
        else
            m_AdmobView.adSize = kGADAdSizeSmartBannerPortrait;
    }

    [m_AdmobView loadRequest:[self CreateGoogleRequest]];

    h = [NOMGUILayout GetiADBannerHeight];
    //w = [NOMGUILayout GetAdBannerWidth];
    CGRect rect = CGRectMake(0, 0, w, h);
    [m_AdView setFrame:rect];

    if(m_bShowIAD == NO)
    {
        float cx = w*0.5;
        float cy = h*(-0.5);
        m_AdView.center = CGPointMake(cx, cy);
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

//
//ADBannerViewDelegate methods
//
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self HideiAdView];
    [self ShowAdmobView];
    
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [self ShowiAdView];
    [self HideAdmobView];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self ShowiAdView];
    [self HideAdmobView];
}

//
//ADBannerViewDelegate methods
//
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self HideAdmobView];
    [self ShowiAdView];
}

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    
}

@end
