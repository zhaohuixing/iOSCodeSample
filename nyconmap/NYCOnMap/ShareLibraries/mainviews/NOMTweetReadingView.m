//
//  NOMTweetReadingView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/7/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTweetReadingViewFrame.h"
#import "NOMTweetReadingView.h"
#import "NOMWebBrowserContainer.h"
#import "NOMTweetReadingViewButtonPanel.h"
#import "NOMAppInfo.h"

@interface NOMTweetReadingView ()
{
    NOMTweetReadingViewButtonPanel*         m_ButtonPanel;
    NOMTweetReadingViewFrame*               m_NewsReadingView;
    NOMWebBrowserContainer*                 m_TweetLinkView;
    
    NOMNewsMetaDataRecord*                  m_pTweetRecord;
}

-(void)UpdateButtonStateByData:pTweetRecord:(NOMNewsMetaDataRecord*)pRecord;

@end


@implementation NOMTweetReadingView

+(double)GetDefaultBasicUISize
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}


-(void)InitializeSubViews
{
    float fSize = [NOMTweetReadingView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, sy);
    m_ButtonPanel = [[NOMTweetReadingViewButtonPanel alloc] initWithFrame:rect];
    [self addSubview:m_ButtonPanel];
    
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    rect = CGRectMake(0, 0, width, height);
    
    m_NewsReadingView = [[NOMTweetReadingViewFrame alloc] initWithFrame:rect];
    [self addSubview:m_NewsReadingView];
    
    m_TweetLinkView = [[NOMWebBrowserContainer alloc] initWithFrame:rect];
    [self addSubview:m_TweetLinkView];
    [self sendSubviewToBack:m_TweetLinkView];
    [m_TweetLinkView CloseView:NO];
    
    [self UpdateLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor darkGrayColor];
        [self InitializeSubViews];
        m_pTweetRecord = nil;
    }
    return self;
}

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

-(void)SetTweetContent:(NOMNewsMetaDataRecord*)pTweetRecord
{
    m_pTweetRecord = pTweetRecord;
    [m_NewsReadingView SetTweetContent:pTweetRecord];
    [self UpdateButtonStateByData:pTweetRecord];
}

-(void)OpenTweetLink:(NSString*)linkURL
{
    [m_TweetLinkView LoadURL:linkURL];
    [m_TweetLinkView OpenView:YES];
}

-(void)OnCloseButtonClick
{
    [self CloseView:YES];
}

-(void)OnLinkButtonClick
{
    [self OpenTweetLink:m_pTweetRecord.m_TwitterTweetLinkURL];
}

-(void)OnRetweetButtonClick
{
    
}

-(void)UpdateLayout
{
    float fSize = [NOMTweetReadingView GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    float height;
    float width;
    
    CGRect rect;
    
    if(self.frame.size.width < self.frame.size.height)
    {
        sy = self.frame.size.height - fSize;
        
        rect = CGRectMake(sx, sy, self.frame.size.width, fSize);
        [m_ButtonPanel setFrame:rect];
        [m_ButtonPanel UpdateLayout];
        
        height = self.frame.size.height - fSize;
        width = self.frame.size.width;
        
        rect = CGRectMake(0, 0, width, height);
        [m_NewsReadingView setFrame:rect];
    }
    else
    {
        sx = self.frame.size.width - fSize;
        sy = 0;
        
        rect = CGRectMake(sx, sy, fSize, self.frame.size.height);
        [m_ButtonPanel setFrame:rect];
        
        height = self.frame.size.height;
        width = self.frame.size.width - fSize;
        
        rect = CGRectMake(0, 0, width, height);
        [m_NewsReadingView setFrame:rect];
    }
    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_TweetLinkView setFrame:rect];
    [m_TweetLinkView UpdateLayout];
    [m_ButtonPanel UpdateLayout];
    [m_NewsReadingView UpdateLayout];
}

-(void)UpdateButtonStateByData:(NOMNewsMetaDataRecord*)pRecord
{
    BOOL bEnable = NO;
    
    if(pRecord && pRecord.m_TwitterTweetLinkURL != nil && 0 < pRecord.m_TwitterTweetLinkURL.length)
        bEnable = YES;
    
    [m_ButtonPanel EnableLinkButton:bEnable];
    
    [m_ButtonPanel EnableRetweetButton:NO/*YES ??????????????????*/];
}

@end
