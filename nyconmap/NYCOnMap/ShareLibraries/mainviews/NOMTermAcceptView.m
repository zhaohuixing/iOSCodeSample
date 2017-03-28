//
//  NOMTermAcceptView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMTermAcceptView.h"
#import "NOMTermAcceptViewButtonPanel.h"
#import "NOMTermAcceptUIFrame.h"
#import "NOMAppInfo.h"
#import "StringFactory.h"

@interface NOMTermAcceptView ()
{
    NOMTermAcceptViewButtonPanel*                   m_ButtonPanel;
    NOMTermAcceptUIFrame*                           m_ReadView;
    BOOL                                            m_bCloseViewByOK;
    BOOL                                            m_bAlertExitAppByNotAcceptTermOfUse;
    
    NOMDocumentController*                          m_Document;

}

@end

@implementation NOMTermAcceptView

+(double)GetDefaultBasicUISize
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 44;
}

-(void)InitializeSubViews
{
    float fSize = [NOMTermAcceptView GetDefaultBasicUISize];
    float sx = 0;
    float sy = self.frame.size.height - fSize;
    CGRect rect = CGRectMake(sx, sy, self.frame.size.width, sy);
    m_ButtonPanel = [[NOMTermAcceptViewButtonPanel alloc] initWithFrame:rect];
    [self addSubview:m_ButtonPanel];
    
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    rect = CGRectMake(0, 0, width, height);
    
    m_ReadView = [[NOMTermAcceptUIFrame alloc] initWithFrame:rect];
    [self addSubview:m_ReadView];
    
    
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
        m_bAlertExitAppByNotAcceptTermOfUse = NO;
        [self InitializeSubViews];
        m_Document = nil;
    }
    return self;
}

-(void)SetDocumentController:(NOMDocumentController*)document
{
    m_Document = document;
}

-(void)UpdateLayout
{
    float fSize = [NOMTermAcceptView GetDefaultBasicUISize];
    float sx = 0;
    float sy = 0;
    float height;
    float width;
    
    CGRect rect;
    
    sy = self.frame.size.height - fSize;
        
    rect = CGRectMake(sx, sy, self.frame.size.width, fSize);
    [m_ButtonPanel setFrame:rect];
    [m_ButtonPanel UpdateLayout];
        
    height = self.frame.size.height - fSize;
    width = self.frame.size.width;
        
    rect = CGRectMake(0, 0, width, height);
    [m_ReadView setFrame:rect];
    [m_ReadView UpdateLayout];
}

-(void)OnViewClose
{
	self.hidden = YES;
	[self setAlpha:1.0];
	[[self superview] sendSubviewToBack:self];
    
    if(m_Document != nil)
    {
        if([m_Document IsCloudServiceInitialized] == NO)
        {
            [m_Document SetCloudInitializationPause:NO];
            [m_Document InitializeCloudService];
        }
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
}

-(void)OpenView:(BOOL)bAnimation
{
    m_bCloseViewByOK = NO;
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

-(void)OnOKButtonClick
{
    [NOMAppInfo AcceptTermOfUse];
    m_bCloseViewByOK = YES;
    [self CloseView:YES];
}

-(void)ShowExitAppByNotAcceptTermOfUse
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[StringFactory GetString_Warning] message:[StringFactory GetString_NotAcceptTermOfUse] delegate:nil cancelButtonTitle:[StringFactory GetString_Close] otherButtonTitles:nil];
    [alertView show];
}

-(void)OnCancelButtonClick
{
    if(m_bAlertExitAppByNotAcceptTermOfUse == YES)
    {
        [self ShowExitAppByNotAcceptTermOfUse];
        return;
    }
    m_bCloseViewByOK = NO;
    [self CloseView:YES];
}

-(void)OpenPrivacyView:(BOOL)bAnimation
{
    m_bAlertExitAppByNotAcceptTermOfUse = NO;
    [m_ReadView OpenPrivacyView];
    [m_ButtonPanel ShowCloseButton];
    [m_ButtonPanel HideAcceptButton];
    [self OpenView:bAnimation];
}

-(void)OpenTermOfUseView:(BOOL)bAnimation AcceptOption:(BOOL)bAccepted
{
    [m_ReadView OpenTermOfUseView];
    if(bAccepted == YES)
    {
        m_bAlertExitAppByNotAcceptTermOfUse = NO;
        [m_ButtonPanel ShowCloseButton];
        [m_ButtonPanel HideAcceptButton];
    }
    else
    {
        m_bAlertExitAppByNotAcceptTermOfUse = YES;
        [m_ButtonPanel ShowCloseButton];
        [m_ButtonPanel ShowAcceptButton];
    }
    [self OpenView:bAnimation];
}

@end
