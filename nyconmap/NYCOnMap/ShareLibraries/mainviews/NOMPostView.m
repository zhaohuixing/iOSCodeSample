//
//  NOMPostView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPostView.h"
#import "NOMPostViewButtonPanel.h"
#import "NOMPostUIFrame.h"
#import "NOMAppInfo.h"
#import "NOMGEOPlanView.h"

@interface NOMPostView ()
{
    NOMPostViewButtonPanel*                 m_ButtonPanel;
    NOMPostUIFrame*                         m_PostView;
    NOMGEOPlanView*                         m_GEOPlanView;

    BOOL                                    m_bCloseViewByOK;

    id<IPostViewController>                 m_Controller;
}

@end


@implementation NOMPostView

+(double)GetDefaultBasicUISize
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}

-(void)InitializeSubViews
{
    float fSize = [NOMPostView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, fSize);
    m_ButtonPanel = [[NOMPostViewButtonPanel alloc] initWithFrame:rect];
    [self addSubview:m_ButtonPanel];
    
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    rect = CGRectMake(0, 0, width, height);
    
    m_PostView = [[NOMPostUIFrame alloc] initWithFrame:rect];
    [self addSubview:m_PostView];
    
    
    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    m_GEOPlanView = [[NOMGEOPlanView alloc] initWithFrame:rect];
    [self addSubview:m_GEOPlanView];
    [m_GEOPlanView CloseView:NO];
    
    [self UpdateLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor darkGrayColor];
        m_bCloseViewByOK = NO;
        m_Controller = nil;
        [self InitializeSubViews];
    }
    return self;
}

-(void)UpdateLayout
{
    float fSize = [NOMPostView GetDefaultBasicUISize];
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
        [m_PostView setFrame:rect];
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
        [m_PostView setFrame:rect];
    }
    [m_ButtonPanel UpdateLayout];
    [m_PostView UpdateLayout];
    
    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_GEOPlanView setFrame:rect];
    [m_GEOPlanView UpdateLayout];
}

-(void)OnViewClose
{
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];
    if(m_Controller != nil)
    {
        [m_Controller OnPostViewClosed:m_bCloseViewByOK];
    }
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
    //[self CleanControlState];
    [m_PostView OpenView];
}

-(void)CleanControlState
{
    [m_GEOPlanView Reset];
    [m_GEOPlanView ClearReferencePoint];
    [m_PostView CleanControlState];
}

-(void)OpenView:(BOOL)bAnimation
{
    m_bCloseViewByOK = NO;
    [self CleanControlState];
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

-(void)SetTwitterEnabling:(BOOL)bTwitterEnable
{
    [m_ButtonPanel SetTwitterEnabling:bTwitterEnable];
}

-(void)OnOKButtonClick
{
    m_bCloseViewByOK = YES;
    [self CloseView:YES];
}

-(void)OnCancelButtonClick
{
    m_bCloseViewByOK = NO;
    [self CloseView:YES];
}

-(void)RegisterController:(id<IPostViewController>)controller
{
    m_Controller = controller;
}

-(NSString*)GetSubject
{
    return [m_PostView GetSubject];
}

-(NSString*)GetPost
{
    return [m_PostView GetPost];
}

-(NSString*)GetKeywords
{
    return [m_PostView GetKeywords];
}

-(NSString*)GetCopyright
{
    return [m_PostView GetCopyright];
}

-(NSString*)GetGeographicKML
{
    return [m_PostView GetGeographicKML];
}

-(UIImage*)GetImage
{
    return [m_PostView GetImage];
}

-(BOOL)AllowTwitterShare
{
    BOOL bRet = YES;
    
    bRet = [m_ButtonPanel IsTwitterEnable];
    
    return bRet;
}

-(void)OpenMapElementView
{
    [m_GEOPlanView ClearMap];
    [m_GEOPlanView OpenView:YES];
}

-(void)HandlePlanCompleted:(NSString*)kml
{
    NSLog(@"KML:%@", kml);
    
    [m_PostView SetKML:kml];
}

-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span
{
    [m_PostView SetReferencePoint:dLat withLongitude:dLong withSpan:Span];
    [m_GEOPlanView SetReferencePoint:dLat withLongitude:dLong withSpan:Span];
}

-(void)SetReferenceInfo:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType isTTweet:(BOOL)bTwitterTweet
{
    [m_PostView SetReferenceInfo:nMainCate withSubType:nSubCate withThirdType:nThirdType isTTweet:bTwitterTweet];
    [m_GEOPlanView SetReferenceInfo:nMainCate withSubType:nSubCate withThirdType:nThirdType isTTweet:bTwitterTweet];
}

-(void)HideKeyboard
{
    [m_PostView HideKeyboard];
}

@end
