//
//  MobclixAdViewHolder.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 2011-11-03.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "MobclixAdViewHolder.h"
#import "MainApplicationDelegateTemplate.h"
#import "ApplicationConfigure.h"
#import "AdConfiguration.h"
#import "GUILayout.h"


@implementation MobclixAdViewHolder

@synthesize m_Delegate;

-(void)InitiPhoneAddViews:(BOOL)bEnable
{
    if(m_iPhoneAdViewMobclix == nil)
    {    
        m_iPhoneAdViewMobclix = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, [GUILayout GetAdBannerHeight], 320.0f, 50.0f)] autorelease];		
        m_iPhoneAdViewMobclix.delegate = self;
        [self addSubview:m_iPhoneAdViewMobclix];
    }    
}

-(void)InitiPadAddViews
{
    if(m_iPadSmallAdViewMobclix == nil)
    {    
        m_iPadSmallAdViewMobclix = [[[MobclixAdViewiPad_468x60 alloc] initWithFrame:CGRectMake((self.frame.size.width-468)/2.0, [GUILayout GetAdBannerHeight], 468.0f, 60.0f)] autorelease];		
        m_iPadSmallAdViewMobclix.delegate = self;
        [self addSubview:m_iPadSmallAdViewMobclix];
    }
    
    if(m_iPadAdViewMobclix == nil)
    {    
        m_iPadAdViewMobclix = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0f, [GUILayout GetAdBannerHeight], 728.0f, 90.0f)] autorelease];
        [self addSubview:m_iPadAdViewMobclix];
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

-(void)PauseAd
{
    if([ApplicationConfigure iPhoneDevice])
    {
        if(m_iPhoneAdViewMobclix)
        {
            [m_iPhoneAdViewMobclix pauseAdAutoRefresh];
            m_iPhoneAdViewMobclix.delegate = nil;
            [m_iPhoneAdViewMobclix removeFromSuperview];
            m_iPhoneAdViewMobclix = nil;
        }
    }
    else
    {
        if(m_iPadAdViewMobclix)
        {
            [m_iPadAdViewMobclix pauseAdAutoRefresh];
            m_iPadAdViewMobclix.delegate = nil;
            [m_iPadAdViewMobclix removeFromSuperview];
            m_iPadAdViewMobclix = nil;
        }
        if(m_iPadSmallAdViewMobclix)
        {
            [m_iPadSmallAdViewMobclix pauseAdAutoRefresh];
            m_iPadSmallAdViewMobclix.delegate = nil;
            [m_iPadSmallAdViewMobclix removeFromSuperview];
            m_iPadSmallAdViewMobclix = nil;
        }
    }
}

-(void)ResumeAd
{
    if([ApplicationConfigure iPhoneDevice])
    {
        [self InitiPhoneAddViews:YES];
    }
    else
    {
        [self InitiPadAddViews];
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
    m_bClicked = NO;
    NSLog(@"Mobclix holder is called to close View");
    if([ApplicationConfigure iPhoneDevice] && m_iPhoneAdViewMobclix)
    {
        CGRect rect = CGRectMake(0.0f, [GUILayout GetAdBannerHeight], 320.0f, 50.0f);
        [m_iPhoneAdViewMobclix setFrame:rect];
        [m_iPhoneAdViewMobclix pauseAdAutoRefresh];
        
    }
    else
    {
        CGRect rect = CGRectMake((self.frame.size.width-728)/2.0, [GUILayout GetAdBannerHeight], 728.0f, 90.0f);
        if(m_iPadAdViewMobclix)
        {
            [m_iPadAdViewMobclix setFrame:rect];
            [m_iPadAdViewMobclix pauseAdAutoRefresh];
        }    
        rect = CGRectMake((self.frame.size.width-468)/2.0, [GUILayout GetAdBannerHeight], 468.0f, 60.0f);
        if(m_iPadSmallAdViewMobclix)
        {    
            [m_iPadSmallAdViewMobclix setFrame:rect];
            [m_iPadSmallAdViewMobclix pauseAdAutoRefresh];
        }    
    }
    if(m_Delegate)
    {
        [m_Delegate AdViewClosed:ADVIEW_TYPE_MOBCLIX];
    }
}

-(void)OpenAdView
{
    m_bClicked = NO;
    NSLog(@"Mobclix holder is called to open View");
    if([ApplicationConfigure iPADDevice])
    {    
        if(m_iPadAdViewMobclix)
        {    
            CGRect rect = CGRectMake((self.frame.size.width-728)/2.0, 0, 728.0f, 90.0f);
            [m_iPadAdViewMobclix setFrame:rect];
            [self bringSubviewToFront:m_iPadAdViewMobclix];
            [m_iPadAdViewMobclix resumeAdAutoRefresh];
            [m_iPadAdViewMobclix getAd];
        }
        else
        {
            [self InitiPadAddViews];
        }
    }    
    else
    {    
        if(m_iPhoneAdViewMobclix)
        {    
            CGRect rect = CGRectMake(0.0f, 0, 320.0f, 50.0f);
            [m_iPhoneAdViewMobclix setFrame:rect];
            [self bringSubviewToFront:m_iPhoneAdViewMobclix];
            [m_iPhoneAdViewMobclix resumeAdAutoRefresh];
            [m_iPhoneAdViewMobclix getAd];
        }
        else
        {
            [self InitiPhoneAddViews:YES];
        }
    }    
}


- (BOOL)adView:(MobclixAdView*)adView shouldHandleSuballocationRequest: (MCAdsSuballocationType)suballocationType
{
	return YES;
}	

- (NSString*)adView:(MobclixAdView*)adView publisherKeyForSuballocationRequest:(MCAdsSuballocationType)suballocationType
{
	return [AdConfiguration GetAdMobPublishKey];
}	

- (void)adView:(MobclixAdView*)adView didFailLoadWithError:(NSError*)error
{
    NSLog(@"mobclixView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    if([ApplicationConfigure iPADDevice])
    {    
        if(error != nil)
        {
            if(m_iPadAdViewMobclix == adView)
            {
                [self sendSubviewToBack:m_iPadAdViewMobclix];
                CGRect rect = CGRectMake((self.frame.size.width-728)/2.0, [GUILayout GetAdBannerHeight], 728.0f, 90.0f);
                [m_iPadSmallAdViewMobclix setFrame:rect];  
                [m_iPadSmallAdViewMobclix resumeAdAutoRefresh];
                [m_iPadSmallAdViewMobclix getAd];
            }
            if(m_iPadSmallAdViewMobclix == adView)
            {
                [self CloseAdView];
            }
        }    
    }
    else
    {
        if(m_iPhoneAdViewMobclix == adView)
        {
            [self CloseAdView];
        }
    }
}

- (void)adViewDidFinishLoad:(MobclixAdView*)adView
{
	NSLog(@"Mobclix AdView Loaded AD");
    if(m_Delegate)
    {
        [m_Delegate AdViewLoaded:ADVIEW_TYPE_MOBCLIX];
    }
}

- (void)adViewWillTouchThrough:(MobclixAdView*)adView 
{
	NSLog(@"Ad Will Touch Through: %@.", NSStringFromCGSize(adView.frame.size));
    m_bClicked = YES;
}

- (void)adViewDidFinishTouchThrough:(MobclixAdView*)adView 
{
	NSLog(@"Ad Did Finish Touch Through: %@.", NSStringFromCGSize(adView.frame.size));
//    [ApplicationConfigure ClearModalPresentAccountable];
    [adView getAd];
}

- (void)adView:(MobclixAdView*)adView didTouchCustomAdWithString:(NSString*)string
{
	NSLog(@"didTouchCustomAdWithString: %@.", string);
    
}
@end
