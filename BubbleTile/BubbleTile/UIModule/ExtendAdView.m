//
//  ExtendAdView.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-10-16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "ExtendAdView.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"

@implementation ExtendAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_InternalWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_InternalWebView.delegate = self;
        m_InternalWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:m_InternalWebView];
        
        [self bringSubviewToFront:m_CloseButton];
        m_bDisplay = NO;
        m_StartTime = 0;
        m_bCornerShow = YES;
    }
    return self;
}

- (void)OpenWebPage:(NSURL*)url withAnimation:(BOOL)bAnimation
{
    //NSURL* testURL = [NSURL URLWithString:@"http://www.google.com"];
    //NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:testURL];//url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    m_InternalWebView.hidden = NO;
    [m_InternalWebView loadRequest:request];
    if(m_bDisplay == NO)
        [super OpenView:bAnimation];
}

-(void)OnViewOpen
{
	[super OnViewOpen];
    [m_InternalWebView setNeedsDisplay];
}	

-(void)OnViewClose
{
    [ApplicationConfigure DisableLaunchHouseAd];
    m_bDisplay = NO;
	[super OnViewClose];
}	

-(void)UpdateViewLayout
{
	CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	[m_InternalWebView setFrame:rect];
    [super UpdateViewLayout];
}	


- (void)dealloc 
{
    m_InternalWebView.delegate = nil;
    [m_InternalWebView release];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)avigationType
{
    if(webView != m_InternalWebView)
    {
        NSLog(@"web request is not from myself, stop it!");
        return NO;
    }
    if(avigationType == UIWebViewNavigationTypeReload)
    {
        NSLog(@"web reload request is waste money, stop it!");
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad!");
    [webView setNeedsDisplay];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad!");
    [webView setNeedsDisplay];
    //[webView resignFirstResponder];
    webView.exclusiveTouch = YES;

    m_bDisplay = YES;
    m_StartTime = [[NSProcessInfo processInfo] systemUptime];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webViewFailLoad!");
    [self CloseView:YES];
}

- (BOOL)IsDisplay
{
    return m_bDisplay;
}

- (void)OnTimerEvent
{
    if(m_bDisplay == NO)
        return;
    
    NSTimeInterval curTime = [[NSProcessInfo processInfo] systemUptime];
    if([ApplicationConfigure CanLaunchHouseAd] == NO)
    {
        if([GUILayout GetDefaultExtendAdViewDisplayTime] <= (curTime - m_StartTime))
        {
            [self CloseView:YES];
        }
    }
    else
    {
        if([GUILayout GetDefaultExtendAdViewDisplayTime]*5.0 <= (curTime - m_StartTime))
        {
            [self CloseView:YES];
        }
    }
}

- (void)SetCornerShow
{
    m_bCornerShow = YES;
}

- (void)DisableCornerShow
{
    m_bCornerShow = NO;
}

- (BOOL)IsCornerShow
{
    return m_bCornerShow;
}

@end
