//
//  QQLoginView.m
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-02-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "libinc.h"
#import "QQLoginView.h"
#import "QWeiboSyncApi.h"
#import "QWeiboAsyncApi.h"
#import "QWeiboSyncApi.h"
#import "QOauthConfigure.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"

#define VERIFY_URL @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="

static CGFloat kSTBlue2[4] = {0.42578125, 0.515625, 0.703125, 1.0};
static CGFloat kSTGray2[4] = {0.7, 0.7, 0.7, 0.8};
static CGFloat kSTBorderBlue2[4] = {0.23, 0.35, 0.6, 1.0};

#ifndef STLABELHEIGHT
#define STLABELHEIGHT			30
#endif

@implementation QQLoginView

- (void)DismissMe:(BOOL) bOK
{
	m_CanWork = NO;
    if(bOK == NO)
        [GUIEventLoop SendEvent:GUIID_EVENT_QQLOGINFAILED eventSender:self];
    else
        [GUIEventLoop SendEvent:GUIID_EVENT_QQLOGINSUCCEED eventSender:self];

    [self.superview sendSubviewToBack:self];
    self.hidden = YES;
}

- (void)CloseButtonClick
{
	m_CanWork = NO;
	[self DismissMe:NO];
}

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

- (void)Login
{
	NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, [QOauthConfigure GetTokenKey]];
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
	[m_WebLoginView loadRequest:request];
	m_CanWork = YES;
	[m_Spinner sizeToFit];
	[m_Spinner startAnimating];
	m_Spinner.center = m_WebLoginView.center;
	
}	

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//if(m_CanWork == NO)
	//	return YES;
	
	
	NSString *query = [[request URL] query];
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	
	if (verifier && ![verifier isEqualToString:@""]) 
	{
		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *retString = [api getAccessTokenWithConsumerKey:[QOauthConfigure GetAppKey] 
												  consumerSecret:[QOauthConfigure GetAppSecret] 
												 requestTokenKey:[QOauthConfigure GetTokenKey] 
											  requestTokenSecret:[QOauthConfigure GetTokenSecret] 
														  verify:verifier];
		NSLog(@"\nget access token:%@", retString);
		[QOauthConfigure ParseTokenKeyWithResponse:retString];
		[QOauthConfigure SaveDefaultKey];
		
		//[[NSNotificationCenter defaultCenter] postNotificationName:[QOauthConfigure GetQQLoginViewDoneEventID] object:self];
		
		[self DismissMe:YES];
		return NO;
	}
	
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
	[m_Spinner stopAnimating];
	m_Spinner.hidden = YES;
}


- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
		m_fOldWidth = frame.size.width;
		
		UIImage* iconImage = [UIImage imageNamed:@"qqicon.png"];
		UIImage* closeImage = [UIImage imageNamed:@"stclose.png"];
		
		m_TitleIcon = [[UIImageView alloc] initWithImage:iconImage];
		[m_TitleIcon setFrame:CGRectMake(2, 2, STLABELHEIGHT-4, STLABELHEIGHT-4)];
		[self addSubview:m_TitleIcon];
		
		CGRect rect = CGRectMake(frame.origin.x+frame.size.width-32, 1, 28, 28);
		
		m_CloseButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_CloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_CloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_CloseButton setBackgroundImage:closeImage forState:UIControlStateNormal];
		[m_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_CloseButton];
		[self bringSubviewToFront:m_CloseButton];
	
		rect = CGRectMake(frame.origin.x, frame.origin.y+STLABELHEIGHT, frame.size.width, frame.size.height-STLABELHEIGHT-50);

		m_WebLoginView = [[UIWebView alloc] initWithFrame:rect];
		m_WebLoginView.delegate = self;
		[self addSubview:m_WebLoginView];
		
		m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
		m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[self addSubview:m_Spinner];
		
		m_CanWork = NO;
    }
    return self;
}


- (void)DrawRect:(CGRect)rect fill:(const CGFloat*)fillColors
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	if (fillColors) 
	{
		CGContextSaveGState(context);
		CGContextSetFillColor(context, fillColors);
		CGContextFillRect(context, rect);
		CGContextRestoreGState(context);
	}
	
	CGColorSpaceRelease(space);
}

- (void)StrokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(context);
	CGContextSetStrokeColorSpace(context, space);
	CGContextSetStrokeColor(context, strokeColor);
	CGContextSetLineWidth(context, 1.0);
	
	{
		CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y-0.5},
			{rect.origin.x+rect.size.width, rect.origin.y-0.5}};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5},
			{rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5}};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {{rect.origin.x+rect.size.width-0.5, rect.origin.y},
			{rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height}};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y},
			{rect.origin.x+0.5, rect.origin.y+rect.size.height}};
		CGContextStrokeLineSegments(context, points, 2);
	}
	
	CGContextRestoreGState(context);
	
	CGColorSpaceRelease(space);
}

- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh
{
    CGRect rect = self.frame;
    rect.size.width = nw;
    rect.size.height = nh;
    [self setFrame:rect];
	
	
	rect = m_CloseButton.frame;
	rect.origin.x = nw-32;
	[m_CloseButton setFrame:rect];

	rect = m_WebLoginView.frame;
	rect.size.width = nw;
	rect.size.height = (nh-STLABELHEIGHT);
	[m_WebLoginView setFrame:rect];
	m_Spinner.center = m_WebLoginView.center;
    [self setNeedsDisplay];
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
	CGRect headerRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, STLABELHEIGHT);
	[self DrawRect:headerRect fill:kSTBlue2];
	[self StrokeLines:headerRect stroke:kSTBorderBlue2];
	
	CGRect webRect = CGRectMake(rect.origin.x, rect.origin.y+STLABELHEIGHT, rect.size.width, rect.size.height - STLABELHEIGHT);
	[self DrawRect:webRect fill:kSTGray2];
}

- (void)dealloc 
{
	[m_TitleIcon release];
	[m_CloseButton release];
	[m_WebLoginView release];
	[m_Spinner release];
    [super dealloc];
}

@end
