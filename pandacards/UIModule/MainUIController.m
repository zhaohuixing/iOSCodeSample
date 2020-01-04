    //
//  MainUIController.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "MainUIView.h"
#import "MainUIController.h"
#import "ApplicationConfigure.h"
#define NETWORK_TIMEOUT     120.0
#define ADREPOST_INVALID      1

@implementation MainUIController

- (id)init
{
	self = [super init];
	if(self)
	{
        m_CachedAdPostURL = @"";
        m_nRepostLimit = 1000000;
        m_nRepostCount = 0;
        m_nRepostTimerInterval = 1000;
        m_nRepostTimerCount = 0;
        m_URLConnection = nil;
	}
	
	return self;
}	

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	[m_MainView OnOrientationChange];
	[m_MainView UpdateSubViewsOrientation];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations.
    return YES;
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    if(m_URLConnection != nil)
        [m_URLConnection release];
    [super dealloc];
}

- (void)HttpPostAdRequest:(NSURL*)url
{
    if(m_URLConnection != nil)
        [m_URLConnection release];
    
    ++m_nRepostCount;
    m_nRepostTimerCount = 0;

	NSMutableURLRequest* req;
	req = [NSMutableURLRequest requestWithURL:url
							  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
							  timeoutInterval:NETWORK_TIMEOUT];

    [req setHTTPShouldHandleCookies:NO];
	
    NSLog(@"HttpPostAdRequust:%@", [url absoluteString]);
    
     NSDictionary *dic = [req allHTTPHeaderFields];
     for (NSString *key in [dic allKeys]) {
     NSLog(@"key:%@, value:%@", key, [dic objectForKey:key]);
     }
	 
    
	m_URLConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}


- (void)HandleAdRequest:(NSURL*)url
{
#ifndef ADREPOST_INVALID    
    NSLog(@"HandleAdRequest:url called");
    m_nRepostCount = 0;
    m_nRepostTimerCount = 0;
    m_CachedAdPostURL = [url absoluteString];
    [self HttpPostAdRequest:url];
#endif    
}

-(void)AdViewClicked:(int)nType
{
    
}

- (void)DismissExtendAdView
{
    
}

- (void)InterstitialAdViewClicked
{
    
}

- (void)CloseRedeemAdView
{
    
}

- (NSString*)GetCachedAdPost
{
    return m_CachedAdPostURL;
}

- (int)GetRepostLimit
{
    return m_nRepostLimit;
}

- (void)SetRepostLimit:(int)nLimit
{
    m_nRepostLimit = nLimit;
}

- (int)GetRepostCount
{
    return m_nRepostCount;
}

- (int)GetRepostTimerInterval
{
    return m_nRepostTimerInterval;
}

- (void)SetRepostTimerInterval:(int)nTiming
{
    m_nRepostTimerInterval = nTiming;
}

- (void)OnAdRepostHandlingTimer
{
#ifndef ADREPOST_INVALID    
    ++m_nRepostTimerCount;
    if(m_nRepostTimerInterval < m_nRepostTimerCount)
    {    
        [self ResendAdRequest];
    }
#endif    
}

- (void)ResendAdRequest
{
#ifndef ADREPOST_INVALID    
    if(0 < [m_CachedAdPostURL length] && m_nRepostCount <= m_nRepostLimit)
    {
        NSURL *url = [NSURL URLWithString: m_CachedAdPostURL];
        [self HttpPostAdRequest:url];
    }
#endif    
}

- (void)PauseGame
{
    
}

- (void)ResumeGame
{
    
}

- (void)HandleFreeVersionOnlineOption
{
    
}

- (void)HandleFreeVersionGameCenterScorePost:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed
{
    
}

- (void)HandleFreeVersionOnlineInvitation
{
    
}

-(void)CompleteFacebookFeedMySelf
{
    
}

-(void)CompleteFacebookSuggestToFriends
{
    
}

@end
