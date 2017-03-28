//
//  NOMWebBrowserContainer.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/10/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMWebBrowserContainer.h"
#import "NOMAppInfo.h"
#import "StringFactory.h"
#import "NOMGUILayout.h"
#import "ImageLoader.h"
#import "CustomImageButton.h"

#define NOM_WEBVIEWCONTAINER_CLOSEBUTTON_ID     0

@interface NOMWebBrowserContainer ()
{
@private
    CustomImageButton*              m_CloseButton;
    UIWebView*                      m_WebBrowser;
    UIActivityIndicatorView*        m_Spinner;
}
@end


@implementation NOMWebBrowserContainer

-(void)ShowSpinner
{
    [self bringSubviewToFront:m_Spinner];
    m_Spinner.hidden = NO;
    [m_Spinner sizeToFit];
    [m_Spinner startAnimating];
    m_Spinner.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
}

-(void)HideSpinner
{
    [m_Spinner stopAnimating];
    m_Spinner.hidden = YES;
}

-(void)CloseButtonClick
{
    [self CloseView:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        m_WebBrowser = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:m_WebBrowser];
        m_WebBrowser.delegate = self;
        
        float btnSize = 30;
        if([NOMAppInfo IsDeviceIPad])
        {
            btnSize = 50;
        }
        
        CGRect rect = CGRectMake(frame.size.width - btnSize, frame.size.height - btnSize, btnSize, btnSize);
        
        m_CloseButton = [[CustomImageButton alloc] initWithFrame:rect];
        m_CloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_CloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [m_CloseButton SetCustomImage:[ImageLoader LoadImageWithName:@"bclosebtn200.png"]];
        [m_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_CloseButton];
        
        m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:m_Spinner];
    }
    return self;
}

-(void)dealloc
{
    m_WebBrowser.delegate = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)OnViewClose
{
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];
}

-(void)CloseView:(BOOL)bAnimation
{
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[self setAlpha:0.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewClose)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
		[UIView commitAnimations];
	}
	else
	{
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
}

-(void)OpenView:(BOOL)bAnimation
{
	self.hidden = NO;
	[[self superview] bringSubviewToFront:self];
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewOpen)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
		[UIView commitAnimations];
	}
	else
	{
		[self OnViewOpen];
	}
}

-(void)LoadURL:(NSString*)szURL
{
    [self ShowSpinner];
    NSURL *url = [NSURL URLWithString:szURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [m_WebBrowser loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self HideSpinner];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self ShowSpinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self HideSpinner];
}

-(void)UpdateLayout
{
    [m_WebBrowser setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    float btnSize = 30;
    if([NOMAppInfo IsDeviceIPad])
    {
        btnSize = 50;
    }
    
    CGRect rect = CGRectMake(self.frame.size.width - btnSize, self.frame.size.height - btnSize, btnSize, btnSize);
    [m_CloseButton setFrame:rect];

    m_Spinner.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
}


@end
